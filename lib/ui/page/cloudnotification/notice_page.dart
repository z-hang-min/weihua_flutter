import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/viewmodel/notice_page_view_model.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class NoticePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  XNoticePageViewModel xNoticePageViewModel = Get.put(XNoticePageViewModel());

  @override
  void initState() {
    super.initState();
    xNoticePageViewModel.getRecordToday();
    xNoticePageViewModel.searchSendTimes();
  }

  @override
  void dispose() {
    super.dispose();
    if (EasyLoading.isShow) EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('云通知'),
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        color: context.isBrightness ? Colour.c0xFFF7F8FD : Colour.FF111111,
        child: Stack(
          children: [
            Obx(() {
              if (xNoticePageViewModel.isBusy) EasyLoading.show(status: '加载数据');
              if (xNoticePageViewModel.isError)
                xNoticePageViewModel.showErrorMessage(context);
              if (xNoticePageViewModel.isIdle) EasyLoading.dismiss();
              return SizedBox();
            }),
            Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 15.w,
                    ),
                    SvgPicture.asset(
                      ImageHelper.wrapAssets(
                        'icon_todaydata.svg',
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      '今日数据',
                      style: subtitle1.change(context, color: Colour.f333333),
                    ),
                  ],
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        return _noticeContent(
                            context,
                            '发送总量',
                            '${xNoticePageViewModel.recordToday.value.totalSuccess + xNoticePageViewModel.recordToday.value.totalFail}',
                            '${xNoticePageViewModel.recordToday.value.totalSuccess}',
                            '${xNoticePageViewModel.recordToday.value.totalFail}');
                      }),
                      Obx(() {
                        return _noticeContent(
                            context,
                            '电话通知',
                            '${xNoticePageViewModel.recordToday.value.ivrSuccess + xNoticePageViewModel.recordToday.value.ivrFail}',
                            '${xNoticePageViewModel.recordToday.value.ivrSuccess}',
                            '${xNoticePageViewModel.recordToday.value.ivrFail}');
                      }),
                      Obx(() {
                        return _noticeContent(
                            context,
                            '短信通知',
                            '${xNoticePageViewModel.recordToday.value.msgSuccess + xNoticePageViewModel.recordToday.value.msgFail}',
                            '${xNoticePageViewModel.recordToday.value.msgSuccess}',
                            '${xNoticePageViewModel.recordToday.value.msgFail}');
                      }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(RouteName.noticeChargePage,
                        arguments: xNoticePageViewModel
                            .searchTimes.value.remainingTimes);
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 68.h,
                        color: Theme.of(context).cardColor,
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              ImageHelper.wrapAssets(context.isBrightness
                                  ? 'icon_count_charge.svg'
                                  : 'icon_count_charge_black.svg'),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              '次数充值',
                              style: subtitle1.change(context,
                                  color: Colour.f333333),
                            ),
                            Spacer(),
                            Obx(() {
                              return Visibility(
                                  visible: xNoticePageViewModel
                                          .searchTimes.value.remainingTimes !=
                                      0,
                                  replacement: Row(
                                    children: [
                                      SvgPicture.asset(ImageHelper.wrapAssets(
                                          'icon_notice_tip.svg')),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        '剩余0次',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colour.FFF25845,
                                            height: 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '剩余',
                                        style: subtitle2.change(context,
                                            fontSize: 14,
                                            color: Colour.cFF999999,
                                            height: 1),
                                      ),
                                      Text(
                                        ' ${xNoticePageViewModel.searchTimes.value.remainingTimes} ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colour.f0F8FFB,
                                            height: 1),
                                      ),
                                      Text(
                                        '次',
                                        style: subtitle2.change(context,
                                            fontSize: 14,
                                            color: Colour.cFF999999,
                                            height: 1),
                                      ),
                                    ],
                                  ));
                            }),
                            SvgPicture.asset(
                                Theme.of(context).brightness == Brightness.light
                                    ? ImageHelper.wrapAssets("me_icon_more.svg")
                                    : ImageHelper.wrapAssets(
                                        "me_icon_more_dark.svg")),
                          ],
                        ),
                      ),
                      Divider(
                        height: 0.5.h,
                        indent: 15.w,
                        endIndent: 15.w,
                        color: context.isBrightness
                            ? Colour.cFFEEEEEE
                            : Colour.f0x1AFFFFFF,
                      )
                    ],
                  ),
                ),
                _itemWidget(
                  context,
                  context.isBrightness
                      ? 'icon_model.svg'
                      : 'icon_model_black.svg',
                  '通知模版',
                  () {
                    Get.toNamed(RouteName.notifacationTemplatepage);
                  },
                ),
                _itemWidget(
                  context,
                  context.isBrightness
                      ? 'icon_history.svg'
                      : 'icon_history_black.svg',
                  '历史记录',
                  () {
                    Get.toNamed(RouteName.notificationHistorylistPage);
                  },
                ),
                _itemWidget(
                  context,
                  context.isBrightness
                      ? 'icon_data.svg'
                      : 'icon_data_black.svg',
                  '数据统计',
                  () {
                    Get.toNamed(RouteName.noticeDataStatisticsPage);
                  },
                )
              ],
            ),
            Positioned(
              left: 15.w,
              right: 15.w,
              bottom: 20.h,
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(25),
                padding: EdgeInsets.all(1),
                color: Colour.f0F8FFB,
                disabledColor: Colour.f0F8FFB.withAlpha(100),
                child: Container(
                  height: 50.h,
                  alignment: Alignment.center,
                  child: Text(
                    '发送通知',
                    style: TextStyle(color: Colour.fffffff),
                  ),
                ),
                onPressed: () {
                  if (xNoticePageViewModel.searchTimes.value.remainingTimes <=
                      0) {
                    showToast('无可用发送次数');
                    return;
                  }
                  Get.toNamed(RouteName.noticeSendPage);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _noticeContent(BuildContext context, String title, String total,
      String success, String fail) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 14.w),
      width: 111.w,
      height: 142.h,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title',
                style: subtitle1.change(context,
                    fontSize: 14, color: Colour.f333333),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                '$total',
                style: subtitle1.change(context,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colour.f333333),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 7.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '成功',
                    style: TextStyle(
                        fontSize: 14,
                        color: context.isBrightness
                            ? Colour.cFF999999
                            : Colour.f99ffffff,
                        height: 1.1),
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  Text(
                    '  $success',
                    style: TextStyle(
                        fontSize: 16, color: Colour.FF19BA6C, height: 1.1),
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '失败',
                    style: TextStyle(
                        fontSize: 14,
                        color: context.isBrightness
                            ? Colour.cFF999999
                            : Colour.f99ffffff,
                        height: 1.1),
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  Text(
                    '  $fail',
                    style: TextStyle(
                        fontSize: 16, color: Colour.FFF25643, height: 1.1),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _itemWidget(
      BuildContext context, String icon, String title, void Function() onDone) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return InkWell(
      onTap: () {
        onDone();
        // showToast('msg');
      },
      child: Column(
        children: [
          Container(
            color: Theme.of(context).cardColor,
            height: 68.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              children: [
                SvgPicture.asset(
                  ImageHelper.wrapAssets(icon),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  '$title',
                  style: subtitle1.change(context, color: Colour.f333333),
                ),
                Spacer(),
                SvgPicture.asset(
                    Theme.of(context).brightness == Brightness.light
                        ? ImageHelper.wrapAssets("me_icon_more.svg")
                        : ImageHelper.wrapAssets("me_icon_more_dark.svg")),
              ],
            ),
          ),
          Divider(
            height: 0.5.h,
            indent: 15.w,
            endIndent: 15.w,
            color: context.isBrightness ? Colour.cFFEEEEEE : Colour.f0x1AFFFFFF,
          )
        ],
      ),
    );
  }
}

typedef ItemCallBack = void Function();
