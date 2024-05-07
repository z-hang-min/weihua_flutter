
import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/model/call_record.dart';
import 'package:weihua_flutter/ui/page/call/call_widget.dart';
import 'package:weihua_flutter/ui/page/tab/tab_navigator.dart';
import 'package:weihua_flutter/ui/widget/common_widget.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

///
/// @Desc: 通话详情页，小部件
///
/// @Author: zhhli
///
/// @Date: 21/5/28
///
class CallInfoHead extends StatelessWidget {
  final CallRecord callRecord;

  CallInfoHead(this.callRecord);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/// 通话记录，联系人详情中，号码栏
class CallNumberItemWidget extends StatelessWidget {
  final String number;
  final String subTitle;

  final bool hasPSTN;
  final bool hasVoIP;

  final bool isExNumber;

  final Function(Object?) onRefresh;

  CallNumberItemWidget(
      {required this.number,
      required this.onRefresh,
      this.subTitle = '',
      this.hasPSTN = true,
      this.hasVoIP = true,
      this.isExNumber = false});

  @override
  Widget build(BuildContext context) {
    bool showSubtitle = subTitle.isNotEmpty;
    List<Widget> titles = [
      Text(
        number,
        style:
            TextStyle().change(context, color: Colour.titleColor, fontSize: 17),
      ),
    ];
    if (showSubtitle) {
      titles.addAll([
        SizedBox(height: 9.h),
        Text(
          subTitle,
          style: TextStyle()
              .change(context, color: Colour.titleColor, fontSize: 14),
        ),
      ]);
    }

    return Container(
      color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
      child: Row(
        children: [
          SizedBox(width: 15.w),
          Expanded(
            flex: 1,
            child: InkWell(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: titles,
              ),
              onTap: () {
                if (hasPSTN && hasVoIP) {
                  // 有两种呼出方式，才弹窗选择
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        // 呼出底部弹窗选择
                        return BottomCallSheetWidget(
                            number, hasVoIP, hasPSTN, onRefresh);
                      });
                } else {
                  if (hasPSTN) {
                    if (number.isNotEmpty) {
                      doSysCallOut(context, number);
                    }
                  } else if (hasVoIP) {}
                }
              },
            ),
          ),
          Visibility(
            // 普通电话
            visible: hasPSTN,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 15.h, 30.w, 15.h),
                child: Column(
                  children: [
                    InkWell(
                      child: Image.asset(
                          ImageHelper.wrapAssets('btn_item_phone.png')),
                      onTap: () {
                        if (number.isNotEmpty) {
                          doSysCallOut(context, number);
                        }
                      },
                    ),
                    SizedBox(height: 8.h),
                    Text('普通电话',
                        style: TextStyle(
                            color: context.isBrightness
                                ? Color.fromRGBO(33, 33, 33, 1.0)
                                : Color.fromRGBO(255, 255, 255, 0.87),
                            fontSize: 14)),
                  ],
                )),
          ),
          Visibility(
              // 语音通话
              visible: hasVoIP,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 15.h, 17.w, 15.h),
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        return InkWell(
                          child: isExNumber
                              ? SvgPicture.asset(ImageHelper.wrapAssets(
                                  'list_exchoice_phone.svg'))
                              : Image.asset(ImageHelper.wrapAssets(
                                  'btn_item_phone_voice.png')),
                          onTap: () {},
                        );
                      },
                    ),
                    SizedBox(height: 8.h),
                    Text('语音通话',
                        style: TextStyle(
                            color: context.isBrightness
                                ? Color.fromRGBO(33, 33, 33, 1.0)
                                : Color.fromRGBO(255, 255, 255, 0.87),
                            fontSize: 14)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

/// 底部弹窗选择 呼叫方式
class BottomCallSheetWidget extends StatelessWidget {
  final String number;
  final bool hasVoIP;
  final bool hasPSTN;

  final Function(Object?) onRefresh;

  BottomCallSheetWidget(
      this.number, this.hasVoIP, this.hasPSTN, this.onRefresh);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
        builder: (context, model2, child) => Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                      visible: hasPSTN,
                      child: buildItem(context, "普通电话",
                          imgUrl: context.isBrightness
                              ? 'list_choice_phone.svg'
                              : 'list_choice_phone_dark.svg')),

                  //分割线
                  Visibility(
                    visible: hasPSTN,
                    child: MyDivider(),
                  ),
                  Visibility(
                      visible: hasVoIP,
                      child: buildItem(context, "语音通话",
                          imgUrl: context.isBrightness
                              ? 'list_choice_phone_voice.svg'
                              : 'list_choice_phone_voice_dark.svg')),

                  BlankDivider(),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      child: Text("取消"),
                      height: 58.h,
                      alignment: Alignment.center,
                    ),
                  )
                ],
              ),
            ));
  }

  Widget buildItem(BuildContext context, String title, {String? imgUrl}) {
    return InkWell(
      onTap: () {
        //关闭弹框
        Navigator.of(context).pop();
        if (title == '普通电话') {
          doSysCallOut(context, number);
        } else if (title == '语音通话') {}
      },
      child: Container(
        height: 58.h,
        //左右排开的线性布局
        child: Row(
          //所有的子Widget 水平方向居中
          mainAxisAlignment: MainAxisAlignment.center,
          //所有的子Widget 竖直方向居中
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imgUrl == null
                ? SizedBox(width: 0)
                : SvgPicture.asset(ImageHelper.wrapAssets(imgUrl)),
            imgUrl == null
                ? SizedBox(width: 0)
                : SizedBox(
                    width: 10.w,
                  ),
            Text(title, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}

void doSysCallOut(BuildContext context, String number) async {
  lastNum = number;
  Get.off(TabNavigator(
    jumpIndex: 0,
  ));
  // if (Platform.isIOS) {
  //   _sysCall(number);
  //   return;
  // }
  // if (!await Permission.phone.isGranted) {
  //   CustomPermissionAlertDialog.showAlertDialog(
  //       context,
  //       S.of(context).open_permission_call,
  //       context.isBrightness ? 'icon_call.svg' : 'icon_call_dark.svg',
  //       (value) async {
  //     if (await Permission.phone.request().isGranted) {
  //       _sysCall(number);
  //     }
  //   }, true);
  // } else {
  //   _sysCall(number);
  // }
}

// Future<void> _sysCall(String number) async {
//   if (!number.startsWith('95013')) number = "95013" + number;
//   String url = 'tel:' + number;
//   url = url.replaceAll(' ', '');
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }
