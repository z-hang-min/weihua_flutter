import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/buy_view_model.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/pay_view_model.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

///
/// @Desc: 支付结果-购买新号码
///
/// @Author: zhhli
///
/// @Date: 21/7/21
///
class PayResultPersonNumberPage extends StatefulWidget {
  @override
  _PayResultPersonNumberPageState createState() =>
      _PayResultPersonNumberPageState();
}

class _PayResultPersonNumberPageState extends State<PayResultPersonNumberPage> {
  XPayViewModel payViewModel = Get.find();
  XBuyViewModel buyViewModel = Get.find();

  @override
  void initState() {
    super.initState();
    payType = -1;

    // 监听支付结果
  }

  @override
  void dispose() {
    super.dispose();
    // payViewModel.isOpenResult.value = false;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;

    return Scaffold(
      appBar: AppBar(
        title: Text('购买结果'),
        backgroundColor: Theme.of(context).cardColor,
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
          padding: EdgeInsets.only(top: 60.h, left: 10.h, right: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                return SvgPicture.asset(ImageHelper.wrapAssets(
                    payViewModel.wxPayResult.value
                        ? 'buy_result_success.svg'
                        : 'buy_result_fail.svg'));
              }),
              SizedBox(
                height: 20.h,
              ),
              Obx(() {
                return Text(
                  payViewModel.wxPayResult.value ? '购买成功' : '购买失败',
                  style: subtitle1.change(context, fontWeight: FontWeight.bold),
                );
              }),
              SizedBox(
                height: 40.h,
              ),
              Obx(() {
                return Visibility(
                    replacement: Column(
                      children: [
                        Text(
                          '支付失败，请重新支付',
                          style: subtitle2,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '如果有问题请联系客服',
                              style: subtitle2,
                            ),
                            Text(
                              '950138008',
                              style: TextStyle(
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colour.c0xFF0085FF
                                      : Colour.f61ffffff),
                            ),
                          ],
                        ),
                      ],
                    ),
                    visible: payViewModel.wxPayResult.value,
                    child: Column(
                      children: [
                        Text(
                          '${buyViewModel.number}',
                          style: TextStyle(
                            fontSize: 18,
                            color: context.isBrightness
                                ? Colour.f333333
                                : Colour.f0F8FFB,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          '号码有效期至${buyViewModel.validtime}',
                          style: subtitle2,
                        ),
                      ],
                    ));
              }),
              SizedBox(
                height: 81.h,
              ),
              ListTile(
                contentPadding: EdgeInsets.only(left: 95.w, right: 95.w),
                title: CupertinoButton(
                  borderRadius: BorderRadius.circular(23),
                  padding: EdgeInsets.all(1),
                  color: Colour.f0F8FFB,
                  disabledColor: Colour.f0F8FFB.withAlpha(100),
                  child: Container(
                    height: 45.h,
                    alignment: Alignment.center,
                    child: Obx(() {
                      return Text(
                        payViewModel.wxPayResult.isTrue ? '查看我的号码' : "重新支付",
                        style: TextStyle(color: Colour.fffffff, fontSize: 16),
                      );
                    }),
                  ),
                  onPressed: () {
                    if (payViewModel.wxPayResult.isTrue) {
                      Get.offNamed(RouteName.pNumberList,
                          arguments: payViewModel.bindPhone.toString());
                    } else {
                      Get.back();
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }
}
