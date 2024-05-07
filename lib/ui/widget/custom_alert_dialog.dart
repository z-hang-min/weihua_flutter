import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///自定义alertDialog

typedef AlertConfirmCallBack = void Function(int value);

class CustomAlertDialog extends Dialog {
  final String title;
  final String message;
  final String left;
  final String right;
  final int dialogheight;
  final AlertConfirmCallBack confirmCallBack;

  CustomAlertDialog(this.title,this.message, this.left, this.right,
      this.dialogheight, this.confirmCallBack);

  // @override
  // Widget build(BuildContext context) {
  //
  //   return Material(
  //     type: MaterialType.transparency,
  //     child: Center(
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle headline6 = textTheme.headline6!;
    //自定义弹框内容
    return Material(
      type: MaterialType.transparency,
      child: Center(
          child: Container(
        width: 320.w,
        constraints: BoxConstraints(minHeight: 180.w),
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
            height: dialogheight.h,
            margin: EdgeInsets.only(top: 31.h),
            child: Column(
              children: <Widget>[
                Text(
                  "提示",
                  style: headline6,
                ),
                SizedBox(
                  height:title == '注销账号'? 28.h:0,
                ),
                Container(
                    padding: EdgeInsets.all(19.w),
                    child: title == '注销账号'?RichText(
                      text: TextSpan(text:'号码注销后,',style:TextStyle(color: themeData.brightness == Brightness.dark
                              ? Colour.f99ffffff
                              : Colour.f80333333),children: <TextSpan>[TextSpan(text:message,style: TextStyle(color: themeData.brightness == Brightness.dark
                              ? Colour.FF0086F5
                              : Colour.FF0086F5)),TextSpan(text:'将立即失效，无法继续使用，也无法找回，通讯服务费不退还，请谨慎操作。',style: TextStyle(color:  themeData.brightness == Brightness.dark
                              ? Colour.f99ffffff
                              : Colour.f80333333))]),
                    )
                   : Text(
                      message,
                      style: TextStyle(
                          fontSize: 16,
                          color: themeData.brightness == Brightness.dark
                              ? Colour.f99ffffff
                              : Colour.f80333333),
                      textAlign: TextAlign.center,
                    )),
                Spacer(),
                Divider(
                  height: 1,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colour.c1AFFFFFF
                      : Colour.c1A000000,
                ),
                Container(
                  height: 55.h,
                  child: Row(
                    mainAxisAlignment: left.isNotEmpty
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: left.isNotEmpty,
                        child: Expanded(
                          flex: 1,
                          child: TextButton(
                            child: Text(
                              left,
                              style: headline6.change(context,
                                  color: Colour.f18,
                                  fontWeight: FontWeight.normal),
                            ),
                            onPressed: () {
                              //回调事件
                              Navigator.of(context).pop();
                              confirmCallBack(0);
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: left.isNotEmpty,
                        child: Container(
                          width: 0.5,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colour.c1AFFFFFF
                              : Colour.c1A000000,
                          height: 55.h,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                            child: Text(
                              right,
                              style: TextStyle(
                                  fontSize: 18, color: Colour.f0F8FFB),
                            ),
                            onPressed: () {
                              //回调事件
                              Navigator.of(context).pop();
                              confirmCallBack(1);
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  static showAlertDialog(
      context,
      String title,
      String message,
      String left,
      String right,
      int dialogheight,
      AlertConfirmCallBack confirmCallBack,
      bool canCancle) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            child: CustomAlertDialog(
                title, message, left, right, dialogheight, confirmCallBack),
            onWillPop: () async {
              return canCancle;
            },
          );
        });
  }
}
