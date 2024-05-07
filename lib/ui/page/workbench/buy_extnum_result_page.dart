import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/package_item.dart';
import 'package:weihua_flutter/utils/time_util.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

///
/// @Desc: 购买分机号
///
/// @Author: zm
///
/// @Date: 21/11/23
///
class BuyExtNumResultPage extends StatefulWidget {
  final bool isSuccess;
  final PackageItem packageItem;
  BuyExtNumResultPage(this.isSuccess, this.packageItem);
  @override
  State createState() => _BuyExtNumResultPageState();
}

class _BuyExtNumResultPageState extends State<BuyExtNumResultPage> {
  @override
  void initState() {
    super.initState();
    payType = -1;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.cardColor,
        title: Text(widget.isSuccess ? '成功' : '失败'),
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ),
      body: Container(
          color: context.isBrightness ? Colors.white : Colour.f111111,
          width: double.infinity,
          margin: EdgeInsets.only(top: 10.h),
          padding: EdgeInsets.only(top: 48.h, left: 10.h, right: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(ImageHelper.wrapAssets(widget.isSuccess
                  ? 'buy_result_success.svg'
                  : 'buy_result_fail.svg')),
              SizedBox(
                height: 20.h,
              ),
              Text(
                widget.isSuccess ? '购买成功' : '购买失败',
                style: subtitle1.change(context, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 40.h,
              ),
              Visibility(
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
                              color: Colour.c0xFF0085FF),
                        ),
                      ],
                    ),
                  ],
                ),
                visible: widget.isSuccess,
                child: Text(
                  '已经购买分机数${widget.packageItem.inner}个\n 有效期至${TimeUtil.formatTimeDayWithreg(widget.packageItem.validtime, 'yyyy年MM月dd日')}',
                  style: subtitle2,
                  textAlign: TextAlign.center,
                ),
              ),
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
                    child: Text(
                      widget.isSuccess ? '确定' : "重新支付",
                      style: TextStyle(color: Colour.fffffff, fontSize: 16),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ],
          )),
    );
  }
}
