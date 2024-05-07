import 'dart:async';

import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/model/notification_history_result.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/viewmodel/notification_history_model.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///
/// @Desc: 通知历史记录
///
/// @Author: zhhli
///
/// @Date: 21/7/21
///

class NotificationHistoryListPage extends StatefulWidget {
  final String number;

  NotificationHistoryListPage(this.number);

  @override
  _NotificationHistoryListPageState createState() =>
      _NotificationHistoryListPageState();
}

class _NotificationHistoryListPageState
    extends State<NotificationHistoryListPage> {
  NotificationHistoryModel _model = NotificationHistoryModel();

  final TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _model.refresh(init: true);
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text("历史记录"),
          leading: new IconButton(
              icon: SvgPicture.asset(ImageHelper.wrapAssets(
                  Theme.of(context).brightness == Brightness.light
                      ? "nav_icon_return.svg"
                      : "nav_icon_return_sel.svg")),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ProviderWidget(
            model: _model,
            builder: (context, NotificationHistoryModel model, child) {
              if (model.isBusy) {
                EasyLoading.show();
              }
              if (model.isIdle) {
                EasyLoading.dismiss();
              }
              return Column(children: [
                Container(
                  height: 50.h,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colour.FF1A1A1A,
                  child: _buildSearchTitleWidget(context),
                ),
                SizedBox(height: 7.h),
                Container(
                    // color: Theme.of(context).brightness == Brightness.light
                    //     ? Colour.widgetBackColor
                    //     : Colour.FF111111,
                    child: Text("暂支持查询最近三个月记录",
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colour.FF6B7685
                                    : Colour.fffffff.withAlpha(38),
                            fontSize: 14),
                        textAlign: TextAlign.center)),
                model.list.isEmpty
                    ? Text("")
                    : Container(
                        padding: EdgeInsets.only(bottom: 7.h),
                        height: 635.h,
                        // color: Colors.red,
                        child: SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: WaterDropHeader(),
                            footer: CustomFooter(
                              builder:
                                  (BuildContext context, LoadStatus? mode) {
                                Widget body;
                                if (mode == LoadStatus.idle) {
                                  body = Text("加载中...");
                                } else if (mode == LoadStatus.loading) {
                                  body = CircularProgressIndicator();
                                } else if (mode == LoadStatus.failed) {
                                  body = Text("加载失败！点击重试！");
                                } else if (mode == LoadStatus.canLoading) {
                                  body = Text("加载更多");
                                } else {
                                  body = Text("暂无更多数据");
                                }
                                return Container(
                                  height: 55.0,
                                  child: Center(child: body),
                                );
                              },
                            ),
                            controller: _model.refreshController,
                            onRefresh: _model.refresh,
                            onLoading: _model.loadMore,
                            child: model.list.isEmpty
                                ? Column(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.fromLTRB(
                                              78.w, 94.h, 78.w, 0),
                                          child: SvgPicture.asset(
                                              ImageHelper.wrapAssets(
                                                  "notification_nohistory.svg"))),
                                      SizedBox(
                                        height: 21.h,
                                      ),
                                      Text(
                                        "暂无相关记录",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colour.cFF999999),
                                      )
                                    ],
                                  )
                                : GestureDetector(
                                    // 触摸收起键盘
                                    behavior: HitTestBehavior.translucent,
                                    onPanDown: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                    child: Container(
                                        height: 635.h,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: model.list.length,
                                            itemBuilder: (context, index) {
                                              return _cellForRow(
                                                  context1, index, model);
                                            })))),
                      ),
              ]);
            }));
  }

  Widget _cellForRow(
      BuildContext context, int index, NotificationHistoryModel model) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle2 = textTheme.subtitle2!;

    NotificationHistory history = _model.list[index];

    return Container(
        decoration: BoxDecoration(
          color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        margin: EdgeInsets.all(ScreenUtil().setHeight(10.w)),
        child: InkWell(
          onTap: () {
            Get.toNamed(RouteName.noticeDataStatisticsDescPage,
                arguments: model.list[index]);
          },
          child: Container(
            // padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
            height: 180.h,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colour.FFF9FBFC
                  : Colour.FF1A1A1A,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(15.w, 0, 0.w, 0),
                    width: 355.w,
                    height: 50.h,
                    // color: context.isBrightness
                    //     ? Colour.FFF9FBFC
                    //     : Colour.FF1A1A1A,
                    child: Row(
                      children: [
                        Text(
                            '${history.callees!.split(',')[0]}等${history.calleeCount.toString()}个号码接收',
                            style: TextStyle(
                                color: context.isBrightness
                                    ? Colour.f333333
                                    : Colour.fffffff)),
                        SizedBox(width: 150.w),
                        InkWell(
                            child: SvgPicture.asset(context.isBrightness
                                ? ImageHelper.wrapAssets("me_icon_more.svg")
                                : ImageHelper.wrapAssets(
                                    "me_icon_more_dark.svg")),
                            onTap: () {}),
                      ],
                    )),
                // SizedBox(height: 0),
                Divider(
                    height: 0.5.h,
                    indent: 0.w,
                    endIndent: 0.w,
                    thickness: 1.0,
                    color: context.isBrightness
                        ? Colour.cFFEEEEEE
                        : Colour.f0x1AFFFFFF),
                Container(
                    height: 128.h,
                    padding: EdgeInsets.fromLTRB(15.w, 15.w, 0.w, 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Colour.FF1A1A1A,
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    ),
                    child: Column(children: [
                      Row(
                        children: [
                          SvgPicture.asset(ImageHelper.wrapAssets(
                              "notification_package.svg")),
                          SizedBox(width: 5.w),
                          Text(history.sendTemplateTitle!,
                              style: TextStyle(
                                  color: context.isBrightness
                                      ? Colour.f333333
                                      : Colour.fffffff))
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Row(children: [
                        history.resultIVR == 2
                            ? Text("")
                            : Row(
                                children: [
                                  SvgPicture.asset(ImageHelper.wrapAssets(
                                      history.resultIVR == 0
                                          ? "notification_success.svg"
                                          : "notification_failure.svg")),
                                  SizedBox(width: 2.w),
                                  Text(
                                      history.resultIVR == 0
                                          ? "语音通知成功"
                                          : "语音通知失败",
                                      style: TextStyle(
                                          color: history.resultIVR == 0
                                              ? Colour.FF19BA6C
                                              : Colour.FFF25643,
                                          fontSize: 14)),
                                ],
                              ),
                        history.resultIVR == 2
                            ? SizedBox(width: 0)
                            : SizedBox(width: 10.w),
                        history.resultMSG == 2
                            ? Text("")
                            : Row(
                                children: [
                                  SvgPicture.asset(ImageHelper.wrapAssets(
                                      history.resultMSG == 0
                                          ? "notification_success.svg"
                                          : "notification_failure.svg")),
                                  SizedBox(width: 2.w),
                                  Text(
                                      history.resultMSG == 0
                                          ? "短信通知成功"
                                          : "短信通知失败",
                                      style: TextStyle(
                                          color: history.resultMSG == 0
                                              ? Colour.FF19BA6C
                                              : Colour.FFF25643,
                                          fontSize: 14)),
                                ],
                              )
                      ]),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Text(
                            history.createTime!,
                            style: subtitle2.change(context,
                                fontSize: 12, color: Colour.hintTextColor),
                          ),
                          SizedBox(width: 130.w),
                          Container(
                            width: 60.w,
                            height: 24.w,
                            child: CupertinoButton(
                              borderRadius: BorderRadius.circular(13),
                              padding: EdgeInsets.all(0),
                              color: Colour.f0F8FFB,
                              disabledColor: Colour.f0F8FFB.withAlpha(100),
                              child: Text(
                                '重发',
                                style: TextStyle(
                                    color: Colour.fffffff, fontSize: 14),
                              ),
                              onPressed: () async {
                                showCustomSizeDialog(
                                  context,
                                  child:
                                      _buildDialogContainer(context, history),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ]))
              ],
            ),
          ),
        ));
  }

  Widget _buildSearchTitleWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(
          // flex: 1,
          child: Container(
              margin: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0),
              padding: EdgeInsets.symmetric(vertical: 0.h),
              height: 36.h,
              width: 345.w,
              decoration: BoxDecoration(
                color: context.isBrightness
                    ? Colour.cFFF7F8F9
                    : Colour.fffffff.withAlpha(10),
                borderRadius: BorderRadius.all(Radius.circular(18.0)),
              ),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextFormField(
                    // 输入数字
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: controller,
                    cursorColor: Color.fromRGBO(25, 186, 108, 1.0),
                    // cursorHeight: 18.h,
                    autofocus: false,
                    maxLines: 1,
                    autocorrect: true,
                    textInputAction: TextInputAction.search,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                        filled: false,
                        // contentPadding: EdgeInsets.fromLTRB(0, -0.h, 0, 0),
                        contentPadding: EdgeInsets.fromLTRB(10.w, 0, 50, 0),
                        hintText: ' 请输入接收号码',
                        hintStyle: TextStyle().change(context,
                            color: Colour.cFF999999, fontSize: 14),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: new OutlineInputBorder(
                          //没有焦点时
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: new OutlineInputBorder(
                          //有焦点时
                          borderSide: BorderSide.none,
                        ),
                        prefixIconConstraints: BoxConstraints(
                            //添加内部图标之后，图标和文字会有间距，实现这个方法，不用写任何参数即可解决
                            ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 124.w),
                          child: SvgPicture.asset(
                              ImageHelper.wrapAssets("search_icon.svg"),
                              fit: BoxFit.cover,
                              width: 20.w,
                              height: 20.w),
                          // myIcon is a 48px-wide widget.
                        )),
                    onChanged: (text) {
                      _model.search(text.trim());
                    },
                    onFieldSubmitted: (String value) async {
                      _model.search(value.trim());
                      // saveHistoryData();
                      // print("点击了键盘上 ${value}");
                    },
                  ),
                  //清空按钮
                  Visibility(
                    child: IconButton(
                        iconSize: 20.w,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(0.w),
                        icon: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 8),
                          child: SvgPicture.asset(
                              ImageHelper.wrapAssets(
                                  "search_icon_deleteall.svg"),
                              fit: BoxFit.cover,
                              width: 20.w,
                              height: 20.w),
                          // myIcon is a 48px-wide widget.
                        ),
                        onPressed: () {
                          controller.text = '';
                          _model.search('');
                        }),
                    visible: controller.text.length == 0 ? false : true,
                  )
                ],
              )),
        ),
        // Container(
        //   child: TextButton(
        //     child: Text(
        //       '取消',
        //       style: context.isBrightness
        //           ? TextStyle().change(context,
        //               color: Color.fromRGBO(33, 33, 33, 1.0),
        //               fontSize: 18,
        //               fontWeight: FontWeight.normal)
        //           : TextStyle(
        //               color: Color.fromRGBO(255, 255, 255, 0.87),
        //               fontSize: 18,
        //               fontWeight: FontWeight.normal),
        //     ),
        //     onPressed: () {
        //       controller.clear();
        //       Navigator.pop(context);
        //     },
        //   ),
        //   margin: EdgeInsets.fromLTRB(0, 44.h, 0, 0),
        // ),
      ],
    );
  }

  Widget _buildDialogContainer(
      BuildContext context, NotificationHistory history) {
    var list = [];
    if (history.resultIVR != 2) {
      list.add('语音通知');
    }
    if (history.resultMSG != 2) {
      list.add("短信通知");
    }

    return Container(
      decoration: BoxDecoration(
        color: context.isBrightness ? Colors.white : Colour.cFF2c2c2c,
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
      ),
      width: 320.w,
      height: 250.h,
      // color: Colors.white,
      child: Column(
        children: [
          Row(children: [
            Container(
                padding: EdgeInsets.fromLTRB(124.w, 18.h, 0, 0),
                child: Text("重新发送",
                    style: TextStyle(
                        color: context.isBrightness
                            ? Colour.FF333333
                            : Colour.fffffff,
                        fontSize: 18))),
            SizedBox(width: 90.w),
            InkWell(
              child: SvgPicture.asset(
                ImageHelper.wrapAssets("blacklistnum_delete.svg"),
              ),
              onTap: () async {
                Navigator.pop(context);
              },
            )
          ]),
          SizedBox(height: 15.h),
          Text(
              '${history.callees!.split(',')[0]}等${history.calleeCount.toString()}个号码接收',
              style: TextStyle(
                  color:
                      context.isBrightness ? Colour.FF333333 : Colour.fffffff,
                  fontSize: 16)),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: list.map((title) {
              return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: BoxDecoration(
                    border: new Border.all(
                        color: Colour.primaryColor,
                        width: context.isBrightness ? 0.5 : 0),
                    color: context.isBrightness
                        ? Colour.FFEFF6FF
                        : Colour.cFF2c2c2c,
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                  height: 24.h,
                  width: 66.w,
                  child: Text(title,
                      style:
                          TextStyle(color: Colour.primaryColor, fontSize: 12),
                      textAlign: TextAlign.center));
            }).toList(),
          ),
          SizedBox(height: 15.h),
          Container(
              child: Text(history.sendTemplateContent ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: context.isBrightness
                          ? Colour.cFF666666
                          : Colour.fffffff.withAlpha(60),
                      fontSize: 14),
                  textAlign: TextAlign.center),
              height: 20.h),
          SizedBox(height: 22.h),
          Divider(
              height: 1,
              endIndent: 0,
              indent: 0,
              color: !context.isBrightness
                  ? Colour.c1AFFFFFF
                  : Colour.dividerColor),
          Row(
            children: [
              InkWell(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(8.w, 7.h, 0, 0),
                      width: 140.w,
                      height: 34.h,
                      child: Text(
                        "更改",
                        style: TextStyle(
                            color: context.isBrightness
                                ? Colour.c0xFF181818
                                : Colour.fffffff,
                            fontSize: 18),
                        textAlign: TextAlign.center,
                      )),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, RouteName.noticeSendPage,
                            arguments: history)
                        .then((value) {
                      _model.refresh();
                    });
                  }),
              SizedBox(width: 1),
              Container(
                  child: VerticalDivider(
                      indent: 0.5.w,
                      endIndent: 0.w,
                      thickness: 0.5.w,
                      width: 38.w,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colour.dividerColor
                          : Colour.c1AFFFFFF.withAlpha(25)),
                  height: 55.w),
              // Container(
              //     child: VerticalDivider(
              //         indent: 0.w,
              //         endIndent: 0.w,
              //         thickness: 10.w,
              //         width: 1.w,
              //         color: context.isBrightness
              //             ? Colour.c1AFFFFFF
              //             : Colour.fffffff.withAlpha(25)),
              //     height: 65.h),
              SizedBox(width: 1),
              InkWell(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(8.w, 7.h, 0, 0),
                      width: 140.w,
                      height: 34.h,
                      child: Text(
                        "重发",
                        style: TextStyle(
                            color: context.isBrightness
                                ? Colour.FF0F88FF
                                : Colour.FF0F88FF,
                            fontSize: 18),
                        textAlign: TextAlign.center,
                      )),
                  onTap: () async {
                    bool result = await _model.resendNotification(history);
                    if (result == true) {
                      showToast("发送成功");
                      _model.refresh();
                    } else {
                      _model.showErrorMessage(context);
                      EasyLoading.dismiss();
                    }
                    Navigator.pop(context, true);
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

Future<T?> showCustomSizeDialog<T>(BuildContext context,
    {required Widget child}) {
  return showDialog<T?>(
    context: context,
    builder: (context) {
      return Material(
        type: MaterialType.transparency,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // Navigator.pop(context);
          },
          child: GestureDetector(
            child: Center(
              child: child,
            ),
            onTap: () {},
          ),
        ),
      );
    },
  );
}
