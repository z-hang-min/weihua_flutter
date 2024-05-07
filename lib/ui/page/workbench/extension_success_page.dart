import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

///
/// @Desc: 激活结果
///
/// @Author: zxh
///
/// @Date: 21/11/22
///
class ExtentionResultPage extends StatefulWidget {
  @override
  _ExtentionResultPageState createState() => _ExtentionResultPageState();
}

class _ExtentionResultPageState extends State<ExtentionResultPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('激活成功'),
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
          color: context.isBrightness ? Colour.c0xFFF7F8FD : Colour.f1A1A1A,
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
                '激活成功',
                textAlign: TextAlign.center,
                style: subtitle1.change(context, fontWeight: FontWeight.bold),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(79.w, 40.h, 79.w, 81.h),
                  child: Text(
                    '恭喜您，分机已激活，你可以通过手机号登录微话APP',
                    style: subtitle2,
                    textAlign: TextAlign.center,
                  )),
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
                      "下载微话APP",
                      style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colour.fffffff
                                  : Colour.fffffff,
                          fontSize: 16),
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          )),
    );
  }
}
