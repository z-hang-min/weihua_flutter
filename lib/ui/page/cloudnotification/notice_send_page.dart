import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/viewmodel/notice_page_view_model.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/viewmodel/send_notice_page_view_model.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/contact_ui.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/home_enterprise_address_model.dart';
import 'package:weihua_flutter/ui/page/tab/home_contact_list_page.dart';
import 'package:weihua_flutter/ui/widget/custom_alert_dialog.dart';
import 'package:weihua_flutter/ui/widget/custom_input_dialog.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class NoticeSendPage extends StatefulWidget {
  final dynamic noticeresult;

  NoticeSendPage(this.noticeresult);

  @override
  State<StatefulWidget> createState() => _NoticeSendPageState();
}

class _NoticeSendPageState extends State<NoticeSendPage> {
  XSendNoticePageViewModel noticePageViewModel = XSendNoticePageViewModel();
  XNoticePageViewModel xNoticePageViewModel = Get.find();

  @override
  void initState() {
    super.initState();
    noticePageViewModel.initData();
    if (widget.noticeresult != null) {
      List callees = widget.noticeresult.callees.split(',');
      noticePageViewModel.listNum.addAll(callees);
      noticePageViewModel.msgNoticeChecked.value =
          widget.noticeresult.resultMSG != 2 ? true : false;
      noticePageViewModel.voiceNoticeChecked.value =
          widget.noticeresult.resultIVR != 2 ? true : false;
      noticePageViewModel.checkedModel.value =
          noticePageViewModel.getNotificationModelList(
              '${widget.noticeresult.templateId}',
              widget.noticeresult.sendTemplateContent!);
      if (noticePageViewModel.voiceNumList
          .contains(widget.noticeresult.caller)) {
        noticePageViewModel.voiceNoticeNumber.value =
            widget.noticeresult.caller;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: themeData.cardColor,
        title: Text('发送通知'),
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          // hideKeyboard(context);
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    _main(context),
                  ])),
                  Obx(() {
                    return SliverList(
                      delegate: new SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          //创建子widget
                          return noticePageViewModel.listNum.isEmpty
                              ? _phoneRow(context)
                              : _itemWidget(
                                  context,
                                  index == noticePageViewModel.listNum.length
                                      ? null
                                      : noticePageViewModel.listNum[index],
                                  index == noticePageViewModel.listNum.length);
                        },
                        childCount: noticePageViewModel.listNum.length + 1,
                      ),
                    );
                  }),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(15.w),
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(25),
                padding: EdgeInsets.all(1),
                color: Colour.f0F8FFB,
                disabledColor: Colour.f0F8FFB.withAlpha(100),
                child: Container(
                  height: 50.h,
                  alignment: Alignment.center,
                  child: Text(
                    '发送',
                    style: TextStyle(color: Colour.fffffff),
                  ),
                ),
                onPressed: () async {
                  await noticePageViewModel.sendNotice().then((value) {
                    if (value) {
                      showToast('发送成功');
                      xNoticePageViewModel.getRecordToday();
                      xNoticePageViewModel.searchSendTimes();
                      // Get.back();
                      Navigator.pop(context, true);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _main(BuildContext context2) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Container(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            if (noticePageViewModel.isSending.isTrue) {
              EasyLoading.show(status: '发送中..');
            } else {
              EasyLoading.dismiss();
            }
            if (noticePageViewModel.isError) {
              noticePageViewModel.isSending.value = false;
              noticePageViewModel.showErrorMessage(context2);
            }

            return SizedBox();
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    '通知方式   ',
                    style: subtitle1.change(context, color: Colour.f333333),
                  ),
                  Text(
                    '',
                    style: subtitle1.change(context,
                        fontSize: 14, color: Colour.f333333),
                  ),
                ],
              ),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(80.w, 26.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    side: BorderSide(width: 1, color: Colour.FFF25845),
                  ),
                  onPressed: () {
                    Get.toNamed(RouteName.pNumberBuy);
                  },
                  child: Text(
                    '购买服务',
                    style: TextStyle(fontSize: 14, color: Colour.FFF25845),
                  ))
            ],
          ),
          _noticeMothed(),
          SizedBox(
            height: 15.h,
          ),
          Text(
            '模板名称',
            style: subtitle1.change(context, color: Colour.f333333),
          ),
          SizedBox(
            height: 15.h,
          ),
          _templateWidget(context),
          SizedBox(
            height: 15.h,
          ),
          Text(
            '接收号码',
            style: subtitle1.change(context, color: Colour.f333333),
          ),
        ],
      ),
    );
  }

  Widget _noticeMothed() {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    TextStyle subtitle1 = textTheme.subtitle1!;
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: themeData.cardColor,
      ),
      child: Column(
        children: [
          Container(
            height: 58.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (noticePageViewModel.voiceNoticeChecked.isTrue &&
                        noticePageViewModel.msgNoticeChecked.isFalse) {
                      showToast('必须选择一种通知方式');
                      return;
                    }
                    noticePageViewModel.voiceNoticeChecked.value =
                        !noticePageViewModel.voiceNoticeChecked.value;
                  },
                  child: Row(
                    children: [
                      Obx(() {
                        return SvgPicture.asset(ImageHelper.wrapAssets(
                            noticePageViewModel.voiceNoticeChecked.value
                                ? 'icon_sendnotice_select.svg'
                                : 'icon_sendnotice_unselect.svg'));
                      }),
                      SizedBox(width: 10.w),
                      Text('语音通知',
                          style: subtitle1.change(context, color: Colour.f18)),
                    ],
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    if (noticePageViewModel.voiceNumList.isEmpty) return;
                    showVoiceNoticeDialog(context);
                  },
                  child: Row(
                    children: [
                      Obx(() {
                        return Text(
                          '${noticePageViewModel.voiceNoticeNumber}',
                          style: subtitle1.change(context,
                              color: Colour.cFF666666),
                        );
                      }),
                      SizedBox(width: 5.w),
                      SvgPicture.asset(Theme.of(context).brightness ==
                              Brightness.light
                          ? ImageHelper.wrapAssets("me_icon_more.svg")
                          : ImageHelper.wrapAssets("me_icon_more_dark.svg")),
                    ],
                  ),
                )
              ],
            ),
          ),
          // Divider(
          //   height: 1.h,
          //   endIndent: 5.w,
          //   indent: 5.w,
          // ),
          // Container(
          //   height: 58.h,
          //   padding: EdgeInsets.symmetric(horizontal: 15.w),
          //   child: InkWell(
          //     onTap: () {
          //       if (noticePageViewModel.msgNoticeChecked.isTrue &&
          //           noticePageViewModel.voiceNoticeChecked.isFalse) {
          //         showToast('必须选择一种通知方式');
          //         return;
          //       }
          //       noticePageViewModel.msgNoticeChecked.value =
          //           !noticePageViewModel.msgNoticeChecked.value;
          //     },
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Obx(() {
          //           return SvgPicture.asset(ImageHelper.wrapAssets(
          //               noticePageViewModel.msgNoticeChecked.isTrue
          //                   ? 'icon_sendnotice_select.svg'
          //                   : 'icon_sendnotice_unselect.svg'));
          //         }),
          //         SizedBox(width: 10.w),
          //         Text('短信通知',
          //             style: subtitle1.change(context, color: Colour.f18)),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void showVoiceNoticeDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Obx(() {
            return Ink(
              height: (59 * noticePageViewModel.voiceNumList.length) + 68,
              width: double.infinity,
              child: ListView.builder(
                  itemCount: noticePageViewModel.voiceNumList.length + 1,
                  itemBuilder: (context, index) {
                    return _itemVoiceNoticeWidget(
                        context,
                        index == noticePageViewModel.voiceNumList.length
                            ? ""
                            : '${noticePageViewModel.voiceNumList[index]}',
                        index == noticePageViewModel.voiceNumList.length);
                  }),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
            );
          });
        });
  }

  Widget _itemVoiceNoticeWidget(BuildContext context, String text, bool last) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    TextStyle subtitle1 = textTheme.subtitle1!;
    return last
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 10.h,
                color:
                    !context.isBrightness ? Colour.cFF1E1E1E : Colour.cFFF7F8F9,
              ),
              InkWell(
                child: Container(
                  child: Text(
                    S.of(context).actionCancel,
                    style: subtitle1,
                  ),
                  height: 58.h,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        : Column(
            children: [
              Divider(
                height: 1,
                endIndent: 15,
                indent: 15,
                color:
                    !context.isBrightness ? Colour.c1AFFFFFF : Colour.cffE6E6E6,
              ),
              InkWell(
                child: Container(
                  height: 58.h,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text('$text',
                      style: TextStyle(
                          fontSize: 16,
                          color: (context.isBrightness
                              ? Colour.titleColor
                              : Colour.fDEffffff))),
                ),
                onTap: () {
                  noticePageViewModel.voiceNoticeNumber.value = text;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
  }

  Widget _templateWidget(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: themeData.cardColor,
      ),
      child: Column(
        children: [
          Container(
            height: 58.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: InkWell(
              onTap: () async {
                // await noticePageViewModel
                //     .getNotificationModel()
                //     .then((value) =>
                if (noticePageViewModel.templateList.isEmpty) {
                  await noticePageViewModel
                      .getNotificationModel()
                      .then((value) {
                    if (noticePageViewModel.templateList.isEmpty) {
                      showToast('没有可选模板,请新增模板');
                    }
                  });
                } else
                  showTemplateDialog(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() {
                    return Text(
                      '${noticePageViewModel.checkedModel.value.templateName}',
                      style: subtitle1.change(context, color: Colour.f18),
                    );
                  }),
                  SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? ImageHelper.wrapAssets("me_icon_more.svg")
                          : ImageHelper.wrapAssets("me_icon_more_dark.svg")),
                ],
              ),
            ),
          ),
          Container(
            // height: 40.h,
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            padding: EdgeInsets.only(
                top: 12.h, bottom: 14.h, left: 10.w, right: 10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: context.isBrightness
                  ? Colour.backgroundColor
                  : Colour.f111111,
            ),
            alignment: Alignment.center,
            child: Obx(() {
              return Text(
                '模板内容：${noticePageViewModel.checkedModel.value.templateContent}',
                style: TextStyle(color: Colour.FF6C7588, fontSize: 12),
              );
            }),
          ),
          SizedBox(
            height: 15.h,
          ),
          Divider(
            height: 1.h,
            endIndent: 5.w,
            indent: 5.w,
          ),
          SizedBox(
            height: 15.h,
          ),
          InkWell(
            onTap: () {
              Get.toNamed(RouteName.addNoticeTemPage);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(ImageHelper.wrapAssets('manage_add.svg')),
                SizedBox(
                  width: 8.w,
                ),
                Text(
                  '新增模板',
                  style: TextStyle(fontSize: 16, color: Colour.f0F8FFB),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 18.h,
          ),
        ],
      ),
    );
  }

  void showTemplateDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Obx(() {
            return Ink(
              height: (59 * noticePageViewModel.templateList.length) + 68,
              width: double.infinity,
              child: ListView.builder(
                  itemCount: noticePageViewModel.templateList.length + 1,
                  itemBuilder: (context, index) {
                    return _itemTemplateWidget(
                        context,
                        index == noticePageViewModel.templateList.length
                            ? null
                            : noticePageViewModel.templateList[index],
                        index == noticePageViewModel.templateList.length);
                  }),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
            );
          });
        });
  }

  Widget _itemTemplateWidget(
      BuildContext context, var notificationModelList, bool last) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    TextStyle subtitle1 = textTheme.subtitle1!;
    return last
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 10.h,
                color:
                    !context.isBrightness ? Colour.cFF1E1E1E : Colour.cFFF7F8F9,
              ),
              InkWell(
                child: Container(
                  child: Text(
                    S.of(context).actionCancel,
                    style: subtitle1,
                  ),
                  height: 58.h,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        : Column(
            children: [
              Divider(
                height: 1,
                endIndent: 15,
                indent: 15,
                color:
                    !context.isBrightness ? Colour.c1AFFFFFF : Colour.cffE6E6E6,
              ),
              InkWell(
                child: Container(
                  height: 58.h,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text('${notificationModelList.templateName}',
                      style: TextStyle(
                          fontSize: 16,
                          color: (context.isBrightness
                              ? Colour.titleColor
                              : Colour.fDEffffff))),
                ),
                onTap: () {
                  noticePageViewModel.checkedModel.value =
                      notificationModelList;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
  }

  Widget _phoneRow(BuildContext context) {
    final _phoneCtrl = TextEditingController();
    return Container(
      height: 61.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      margin: EdgeInsets.only(bottom: 75.w, left: 15.w, right: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              autofocus: false,
              controller: _phoneCtrl,
              textAlign: TextAlign.start,
              maxLines: 1,
              maxLength: 11,
              // style: Theme.of(context).textTheme.bodyText2,
              cursorColor: context.isBrightness
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                counterText: "",
                hintText: '请输入号码',
                hintStyle: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (text) {
                if (text.isNotEmpty &&
                    text.length == 11 &&
                    StringUtils.isMobileNumber(text)) {
                  noticePageViewModel.addNum(text);
                  _phoneCtrl.clear();
                }
              },
            ),
          ),
          // 清空
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Semantics(
              child: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: SvgPicture.asset(
                      ImageHelper.wrapAssets('icon_sendnotice_contacts.svg')),
                ),
                onTap: () {
                  Provider.of<HomeBusinessContactModel>(context, listen: false)
                      .reSetSelected(noticePageViewModel.listNum);
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) => HomeContactListPage(
                      onSelectcontact: true,
                      multipleChoice: true,
                    ),
                  ))
                      .then((value) {
                    Map<String, ContactUIInfo> _selectedMap = Map();
                    _selectedMap = value;
                    _selectedMap.forEach((key, value) {
                      if (!noticePageViewModel.isChecked(key))
                        noticePageViewModel.listNum.add(key);
                    });
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemWidget(BuildContext context, String? test, bool last) {
    return last
        ? _phoneRow(context)
        : Container(
            height: 61.h,
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            margin: EdgeInsets.only(bottom: 15.h, left: 15.w, right: 15.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: Theme.of(context).cardColor,
            ),
            child: Row(
              children: [
                Text('$test'),
                Spacer(),
                InkWell(
                  onTap: () {
                    CustomInputDialog.showAlertDialog(
                        context, '号码更改', '$test', '取消', '确认', 180, (value) {
                      Log.d(value);
                      if (value.isNotEmpty) {
                        noticePageViewModel.editNum(test!, value);
                      }
                    }, false);
                  },
                  child: SvgPicture.asset(
                      ImageHelper.wrapAssets('manage_edit.svg')),
                ),
                SizedBox(
                  width: 14.w,
                ),
                InkWell(
                  onTap: () {
                    CustomAlertDialog.showAlertDialog(
                        context, '删除', '确认删除号码$test？', '取消', '确认', 180,
                        (value) {
                      if (value == 1) {
                        noticePageViewModel.delNum(test!);
                      }
                    }, false);
                  },
                  child: SvgPicture.asset(
                      ImageHelper.wrapAssets('manage_delete.svg')),
                ),
              ],
            ),
          );
  }

// void hideKeyboard(BuildContext context) {
//   FocusScopeNode currentFocus = FocusScope.of(context);
//   if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
//     FocusManager.instance.primaryFocus?.unfocus();
//   }
// }
}
