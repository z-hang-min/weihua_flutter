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
class UpgradePayResultPage extends StatefulWidget {
  final bool result;

  UpgradePayResultPage(this.result);

  @override
  _UpgradePayResultPageState createState() => _UpgradePayResultPageState();
}

class _UpgradePayResultPageState extends State<UpgradePayResultPage> {
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
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).cardColor,
            title: Text(widget.result ? '升级成功' : '升级失败'),
            leading: Visibility(
              visible: widget.result == false,
              child: new IconButton(
                  icon: SvgPicture.asset(ImageHelper.wrapAssets(
                      context.isBrightness
                          ? "nav_icon_return.svg"
                          : "nav_icon_return_sel.svg")),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ),
          body: Container(
              color:
                  context.isBrightness ? Colour.c0xFFF7F8FD : Colour.FF111111,
              width: double.infinity,
              padding: EdgeInsets.only(top: 60.h, left: 10.h, right: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(ImageHelper.wrapAssets(widget.result
                      ? 'buy_result_success.svg'
                      : 'buy_result_fail.svg')),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    widget.result ? '升级成功' : '升级失败',
                    style:
                        subtitle1.change(context, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Visibility(
                    replacement: Column(
                      children: [
                        Text(
                          '升级失败，请重新升级',
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
                    visible: widget.result,
                    child: Text(
                      '您已成功升级到企业微话',
                      style: subtitle2,
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
                          widget.result ? '马上使用' : "重新升级",
                          style: TextStyle(color: Colour.fffffff, fontSize: 16),
                        ),
                      ),
                      onPressed: () {
                        if (widget.result) {
                          // Provider.of<QueryInfoMode>(context, listen: false)
                          //     .checkLogin();
                          Get.off(TabNavigator(
                            jumpIndex: 2,
                          ));
                        } else
                          Get.back();
                      },
                    ),
                  ),
                ],
              )),
        ),
        onWillPop: () async {
          return !widget.result;
        });
  }
}
