import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

///自定义alertDialog

typedef AlertConfirmCallBack = void Function(int value);

class CustomPermissionAlertDialog extends Dialog {
  final String message;
  final String tipImg;
  final AlertConfirmCallBack confirmCallBack;

  CustomPermissionAlertDialog(this.message, this.tipImg, this.confirmCallBack);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    //自定义弹框内容
    return Material(
      type: MaterialType.transparency,
      child: Center(
          child: Container(
        width: 280.w,
        constraints: BoxConstraints(minHeight: 190.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Theme.of(context).brightness == Brightness.light
              ? Colour.backgroundColor2
              : Colour.f2C2C2C,
        ),
        child: GestureDetector(
          //解决showModalBottomSheet点击消失的问题
          behavior: HitTestBehavior.translucent,
          onTap: () {},
          child: Container(
            width: double.infinity,
            height: 190.h,
            margin: EdgeInsets.only(top: 28.h),
            child: Column(
              children: <Widget>[
                SvgPicture.asset(
                  ImageHelper.wrapAssets(tipImg),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  message,
                  style: subtitle1,
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Divider(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colour.c1AFFFFFF
                      : Colour.c1A000000,
                  height: 1,
                ),
                Row(
                  children: [
                    TextButton(
                      child: Text(
                        "拒绝",
                        style: TextStyle(
                            fontSize: 16, color: Colour.f0F8FFB.withAlpha(400)),
                      ),
                      onPressed: () {
                        //回调事件
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(140, 50)),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 0.5,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colour.c1AFFFFFF
                          : Colour.c1A000000,
                    ),
                    TextButton(
                      child: Text(
                        S.of(context).open_permission,
                        style: TextStyle(fontSize: 16, color: Colour.f0F8FFB),
                      ),
                      onPressed: () {
                        //回调事件
                        Navigator.of(context).pop();
                        confirmCallBack(1);
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(140, 50)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  static showAlertDialog(context, String message, String tipImage,
      AlertConfirmCallBack confirmCallBack, bool canCancle) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            child:
                CustomPermissionAlertDialog(message, tipImage, confirmCallBack),
            onWillPop: () async {
              return canCancle;
            },
          );
        });
  }
}
