import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/ui/page/tab/tab_navigator.dart';
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
class CertificationResultPage extends StatefulWidget {
  @override
  _CertificationResultPageState createState() =>
      _CertificationResultPageState();
}

class _CertificationResultPageState extends State<CertificationResultPage> {
  @override
  void initState() {
    super.initState();
    // 监听支付结果
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    return Scaffold(
      appBar: AppBar(
        title: Text('成功'),
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
          color: Colour.c0xFFF7F8FD,
          width: double.infinity,
          padding: EdgeInsets.only(top: 60.h, left: 10.h, right: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                  ImageHelper.wrapAssets('buy_result_success.svg')),
              SizedBox(
                height: 20.h,
              ),
              Text(
                '提交成功',
                style: subtitle1.change(context, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 40.h,
              ),
              Text(
                '我们将会在1-3个工作日内审核完成,\n清注意接听来电或短信',
                style: subtitle2,
                textAlign: TextAlign.left,
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
                      "完成",
                      style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colour.fffffff
                                  : Colour.f61ffffff,
                          fontSize: 16),
                    ),
                  ),
                  onPressed: () {
                    Get.off(TabNavigator(
                      jumpIndex: 2,
                    ));
                  },
                ),
              ),
            ],
          )),
    );
  }
}
