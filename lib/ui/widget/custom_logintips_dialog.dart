import 'package:weihua_flutter/config/const_config.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///自定义alertDialog

typedef AlertConfirmCallBack = void Function(int value);

class CustomLoginTipsDialog extends Dialog {
  final String title;
  final String message;
  final String left;
  final String right;
  final AlertConfirmCallBack confirmCallBack;

  CustomLoginTipsDialog(
      this.title, this.message, this.left, this.right, this.confirmCallBack);

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
            height: 330.h,
            margin: EdgeInsets.only(top: 31.h),
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: headline6,
                ),
                SizedBox(
                  height: 28.h,
                ),
                Container(
                  height: 200.h,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '欢迎来到微话，感谢您对微话的信任与支持！\n为了提供给您更优质的服务，我们会收集或使用您的相关信息及手机应用权限。\n具体内容请您详阅',
                            style: TextStyle(
                                fontSize: 16,
                                color: themeData.brightness == Brightness.dark
                                    ? Colour.f99ffffff
                                    : Colour.f80333333),
                          ),
                          TextSpan(
                            text: '《隐私协议》',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => {
                                    Navigator.of(context).pushNamed(
                                        RouteName.webH5,
                                        arguments:
                                            "${ConstConfig.privacy}${Theme.of(context).brightness == Brightness.light ? 0 : 1}")
                                  },
                          ),
                          TextSpan(
                            text:
                                '全文，我们已经采用先进的信息保护措施，并将持续优化和提升信息安全管理措施及流程，来保护您的个人信息安全。',
                            style: TextStyle(
                                fontSize: 16,
                                color: themeData.brightness == Brightness.dark
                                    ? Colour.f99ffffff
                                    : Colour.f80333333),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
      BuildContext context,
      String title,
      String message,
      String left,
      String right,
      AlertConfirmCallBack confirmCallBack,
      bool canCancle) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            child: CustomLoginTipsDialog(
                title, message, left, right, confirmCallBack),
            onWillPop: () async {
              return canCancle;
            },
          );
        });
  }
}
