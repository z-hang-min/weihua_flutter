import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/upgrade_pernum_mode.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

///
/// @Desc: 升级到联络中心
///
/// @Author: zm
///
/// @Date: 21/8/18
///
class UpgradePersonNumberPage extends StatefulWidget {
  @override
  _UpgradePayPersonNumberPageState createState() =>
      _UpgradePayPersonNumberPageState();
}

class _UpgradePayPersonNumberPageState extends State<UpgradePersonNumberPage> {
  XUpgradePerNumMode upgradePerNumMode = XUpgradePerNumMode();

  @override
  void initState() {
    super.initState();
    upgradePerNumMode.initData();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle bodyText2 = textTheme.bodyText2!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('升级企业联络中心'),
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
        width: double.infinity,
        padding: EdgeInsets.only(top: 15.h),
        child: Column(
          children: [
            Obx(() {
              if (upgradePerNumMode.isError) {
                upgradePerNumMode.showErrorMessage(context);
              }

              return SizedBox();
            }),
            Container(
              margin: EdgeInsets.only(left: 10.w, right: 10.w),
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "选择号码",
                        style: textTheme.subtitle1,
                      ),
                      InkWell(
                          onTap: () {
                            Get.toNamed(RouteName.pNumberBuy);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '使用新号码',
                                style: textTheme.subtitle2,
                              ),
                              SvgPicture.asset(context.isBrightness
                                  ? ImageHelper.wrapAssets("me_icon_more.svg")
                                  : ImageHelper.wrapAssets(
                                      "me_icon_more_dark.svg")),
                            ],
                          )),
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.only(
                        top: 15.w,
                      ),
                      height: upgradePerNumMode.perNumList.isEmpty
                          ? 0
                          : (upgradePerNumMode.perNumList.length >= 1 &&
                                  upgradePerNumMode.perNumList.length < 6
                              ? (58 * upgradePerNumMode.perNumList.length)
                                  .toDouble()
                              : 330.h),
                      padding: EdgeInsets.only(left: 15.h, right: 15.h),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _numItemWidger(
                              context,
                              upgradePerNumMode.perNumList[index].number!,
                              index);
                        },
                        itemCount: upgradePerNumMode.perNumList.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                                height: 1.0,
                                color: context.isBrightness
                                    ? Colour.cFFEEEEEE
                                    : Colour.f0x1AFFFFFF),
                      )),
                  SizedBox(
                    height: 13.h,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.w, right: 10.w),
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "免费赠送",
                    style: textTheme.subtitle1,
                  ),
                  Container(
                      margin: EdgeInsets.only(
                        top: 15.w,
                      ),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(ImageHelper.wrapAssets(
                                  'icon_upgrade_fenji.svg')),
                              SizedBox(
                                width: 10.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '分机',
                                        style: subtitle1,
                                      ),
                                      Obx(() {
                                        return Text(
                                          ' ${upgradePerNumMode.wareInfo.value.inner} ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colour.f0F8FFB),
                                        );
                                      }),
                                      Text('个', style: subtitle1),
                                    ],
                                  ),
                                  Text(
                                    '新建的分机，可通过手机号登录App',
                                    style: bodyText2,
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Divider(),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(ImageHelper.wrapAssets(
                                  'icon_upgrade_record.svg')),
                              SizedBox(
                                width: 10.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '录音',
                                        style: subtitle1,
                                      ),
                                      Obx(() {
                                        return Text(
                                          ' ${upgradePerNumMode.wareInfo.value.record} ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colour.f0F8FFB),
                                        );
                                      }),
                                      Text('条', style: subtitle1),
                                    ],
                                  ),
                                  Text(
                                    '可查询和收听通话录音',
                                    style: bodyText2,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 13.h,
                  ),
                ],
              ),
            ),
            Spacer(),
            Obx(() {
              if (upgradePerNumMode.isError) {
                upgradePerNumMode.showErrorMessage(context);
              }
              return SizedBox();
            }),
            InkWell(
              child: Obx(() {
                return Container(
                  height: 40.h,
                  width: double.infinity,
                  margin:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                          //渐变位置
                          begin: Alignment.topCenter, //右上
                          end: Alignment.bottomCenter, //左下
                          //渐变颜色[始点颜色, 结束颜色]
                          colors: !upgradePerNumMode.isBusy
                              ? [Colour.FFFF8786, Colour.FFFF4F4E]
                              : [Colour.FF6C7588, Colour.FF6C7588])),
                  alignment: Alignment.center,
                  child: Text(
                    '免费升级',
                    style: TextStyle(color: Colour.fffffff),
                  ),
                );
              }),
              onTap: () async {
                if (upgradePerNumMode.perNumList.isEmpty) {
                  showToast('暂无可升级号码，请购买新号码');
                  return;
                }
                var result = await upgradePerNumMode.doUpgrade();
                Get.offNamed(RouteName.pNumberUpgradePayResult,
                    arguments: result);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _numItemWidger(BuildContext context, String num, int index) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return InkWell(
      child: Container(
          height: 58.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$num',
                style: subtitle1,
              ),
              Obx(() {
                return SvgPicture.asset(
                  upgradePerNumMode.selectNumIndex.value == index
                      ? ImageHelper.wrapAssets("phone_radio_selected.svg")
                      : context.isBrightness
                          ? ImageHelper.wrapAssets("phone_radio_unselected.svg")
                          : ImageHelper.wrapAssets(
                              "phone_radio_unselected_dark.svg"),
                );
              })
            ],
          )),
      onTap: () {
        upgradePerNumMode.selectNumIndex.value = index;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (EasyLoading.isShow) EasyLoading.dismiss();
  }
}
