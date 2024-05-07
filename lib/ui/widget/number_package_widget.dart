import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/package_item.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/package_list_mode.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'XFDashedLine.dart';

class NumPackageWidget extends StatefulWidget {
  final String channel;

  NumPackageWidget(this.channel);

  @override
  State<StatefulWidget> createState() => _NumPackageWidgetState();
}

class _NumPackageWidgetState extends State<NumPackageWidget> {
  XPackageListMode xPackageListMode = Get.find();

  @override
  void initState() {
    super.initState();
    xPackageListMode.getPackageList(widget.channel);
  }

  @override
  void dispose() {
    super.dispose();
    xPackageListMode.clearCash();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Container(
      margin: EdgeInsets.only(left: 10.w),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '选择套餐',
                  style: subtitle1,
                ),
                TextButton(
                  style: ButtonStyle(
                    //设置按钮的大小
                    minimumSize: MaterialStateProperty.all(Size(200.w, 20.h)),

                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              width: 0.5,
                              color: context.isBrightness
                                  ? Colour.FFFF8E12
                                  : Colour.F66FF8E12)),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    '新套餐将在当前套餐过期后开始使用',
                    style: TextStyle(fontSize: 12, color: Colour.FFFF8E12),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 151.h,
            child: Obx(() {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: xPackageListMode.packageItemList.length,
                itemBuilder: (
                  context,
                  index,
                ) {
                  return _itemContent(
                      context, xPackageListMode.packageItemList[index], index);
                },
              );
            }),
          ),
          Container(
            margin: EdgeInsets.only(right: 10.w, top: 10),
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 15.h, right: 15.h),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(Radius.circular(6))),
            child: _paymethodWidget(context),
          ),
        ],
      ),
    );
  }

  Widget _paymethodWidget(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Column(
      children: [
        InkWell(
          onTap: () async {},
          child: Container(
              margin: EdgeInsets.only(top: 17.h, bottom: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImageHelper.wrapAssets("icon_wechatpay.svg"),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    '微信',
                    style: subtitle1,
                  ),
                  Spacer(),
                  SvgPicture.asset(
                    // true
                    //     ? 
                        ImageHelper.wrapAssets("phone_radio_selected.svg")
                        // : context.isBrightness
                        //     ? ImageHelper.wrapAssets(
                        //         "phone_radio_unselected.svg")
                        //     : ImageHelper.wrapAssets(
                        //         "phone_radio_unselected_dark.svg"),
                  )
                ],
              )),
        ),
        // Divider(
        //   // color: Color(0xffeeeeee),
        //   indent: 36.w,
        // ),
        // InkWell(
        //   onTap: () async {},
        //   child: Container(
        //       margin: EdgeInsets.only(top: 15.h, bottom: 16.h),
        //       child: Row(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           SvgPicture.asset(
        //             ImageHelper.wrapAssets("icon_alipay.svg"),
        //           ),
        //           SizedBox(
        //             width: 10.w,
        //           ),
        //           Text(
        //             '支付宝',
        //             style: subtitle1,
        //           ),
        //           Spacer(),
        //           SvgPicture.asset(
        //             !true
        //                 ? ImageHelper.wrapAssets("phone_radio_selected.svg")
        //                 : context.isBrightness
        //                     ? ImageHelper.wrapAssets(
        //                         "phone_radio_unselected.svg")
        //                     : ImageHelper.wrapAssets(
        //                         "phone_radio_unselected_dark.svg"),
        //           )
        //         ],
        //       )),
        // ),
      ],
    );
  }

  Widget _itemContent(
      BuildContext context, PackageItem packageItem, int index) {
    return GestureDetector(
      onTap: () {
        xPackageListMode.checkedIndex.value = index;
      },
      child: Obx(() {
        return Container(
          width: 325.w,
          height: 151.h,
          margin: EdgeInsets.only(right: 10.w),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 325.w,
                    height: 151.h,
                    child: SvgPicture.asset(
                      ImageHelper.wrapAssets(
                          xPackageListMode.checkedIndex.value == index
                              ? (context.isBrightness
                                  ? 'icon_package_checked.svg'
                                  : 'icon_package_checked_dark.svg')
                              : (context.isBrightness
                                  ? 'icon_package_unchecked.svg'
                                  : 'icon_package_unchecked_dark.svg')),
                      fit: BoxFit.fill,
                    ),
                  )),
              Container(
                padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 10.h),
                // color: Colour.f0F8FFB,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24.h,
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6)),
                          gradient: LinearGradient(
                              //渐变位置
                              begin: Alignment.topCenter, //右上
                              end: Alignment.bottomCenter, //左下
                              stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                              //渐变颜色[始点颜色, 结束颜色]
                              colors: [Colour.FFFF9F8D, Colour.FFFF504E])),
                      child: Text(
                        '${packageItem.name}',
                        style: TextStyle(
                            color: context.isBrightness
                                ? Colors.white
                                : Colour.f111111,
                            fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${packageItem.locallen}',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: context.isBrightness
                                      ? Colour.cFF212121
                                      : Colour.fDEffffff),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              '分钟',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: context.isBrightness
                                      ? Colour.cFF212121
                                      : Colour.fDEffffff),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${packageItem.inner}',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: context.isBrightness
                                      ? Colour.cFF212121
                                      : Colour.fDEffffff),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              '个',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: context.isBrightness
                                      ? Colour.cFF212121
                                      : Colour.fDEffffff),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${packageItem.record}',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: context.isBrightness
                                      ? Colour.cFF212121
                                      : Colour.fDEffffff),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              '条',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: context.isBrightness
                                      ? Colour.cFF212121
                                      : Colour.fDEffffff),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '通话时长',
                          style: TextStyle(
                              fontSize: 14,
                              color: context.isBrightness
                                  ? Colour.cFF666666
                                  : Colour.f99ffffff),
                        ),
                        Text(
                          '企业分机',
                          style: TextStyle(
                              fontSize: 14,
                              color: context.isBrightness
                                  ? Colour.cFF666666
                                  : Colour.f99ffffff),
                        ),
                        Text(
                          '录音数',
                          style: TextStyle(
                              fontSize: 14,
                              color: context.isBrightness
                                  ? Colour.cFF666666
                                  : Colour.f99ffffff),
                        ),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 15.h),
                        width: 325.w,
                        child: XFDashedLine(
                          axis: Axis.horizontal,
                          count: 55,
                          dashedWidth: 3,
                          dashedHeight: 1,
                          color: context.isBrightness
                              ? Colour.FFE8E8E8
                              : Colour.c1AFFFFFF,
                        )),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '金额',
                          style: TextStyle(
                              textBaseline: TextBaseline.alphabetic,
                              fontSize: 14,
                              color: context.isBrightness
                                  ? Colour.cFF212121
                                  : Colour.fDEffffff,
                              height: 1),
                        ),
                        Row(
                          children: [
                            Text(
                              '¥ ',
                              style: TextStyle(
                                textBaseline: TextBaseline.alphabetic,
                                fontSize: 14,
                                color: Colour.FFFF4F4E,
                              ),
                            ),
                            Text(
                              '${packageItem.price}',
                              style: TextStyle(
                                fontSize: 16,
                                textBaseline: TextBaseline.alphabetic,
                                color: Colour.FFFF4F4E,
                              ),
                            ),
                            Text(
                              '/年',
                              style: TextStyle(
                                fontSize: 14,
                                textBaseline: TextBaseline.alphabetic,
                                color: Colour.FFFF4F4E,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
