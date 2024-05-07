import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oktoast/oktoast.dart';

///自定义alertDialog

typedef AlertConfirmCallBack = void Function(String value);
String? newmessage;

class EnterpriseDialog extends Dialog {
  final String title;
  final String hintText;
  late final String message;
  final String left;
  final String right;
  final int dialogheight;
  final AlertConfirmCallBack confirmCallBack;
  final _nameAndaddressCtrl = TextEditingController();

  EnterpriseDialog(this.title, this.hintText, this.message, this.left,
      this.right, this.dialogheight, this.confirmCallBack);

  @override
  Widget build(BuildContext context) {
    _nameAndaddressCtrl.text = message;
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
          onTap: () {
            //  hideKeyboard(context);
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            width: double.infinity,
            height: dialogheight.h,
            margin: EdgeInsets.only(top: 31.h),
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: headline6,
                ),
                SizedBox(
                  height: 20.h,
                ),
                _nameAndaddressRow(context, _nameAndaddressCtrl),
                Spacer(),
                Divider(
                  height: 0,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colour.c1AFFFFFF
                      : Colour.c1A000000,
                ),
                Container(
                  height: 55.h,
                  // color: Colors.red,
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
                              confirmCallBack('');
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
                              if (_nameAndaddressCtrl.text != '' &&
                                  _nameAndaddressCtrl.text != ' ') {
                                //回调事件
                                Navigator.of(context).pop();
                                confirmCallBack(_nameAndaddressCtrl.text);
                              } else {
                                if (title == "公司名称") {
                                  showToast("名称不能为空");
                                } else {
                                  showToast("地址不能为空");
                                }
                              }
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

  Widget _nameAndaddressRow(
      BuildContext context, TextEditingController controller) {
    bool light = Theme.of(context).brightness == Brightness.light;
    return Container(
      height: 45.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 0),
      decoration: ShapeDecoration(
        color: light ? Colour.backgroundColor : Colour.f2E313C,
        shape: StadiumBorder(
            side: BorderSide(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colour.backgroundColor
                    : Colour.f2E313C)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(0),
                height: 40.h,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  maxLength: 30,
                  autofocus: true,
                  // style: Theme.of(context).textTheme.bodyText2,
                  cursorColor: context.isBrightness
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 10),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    counterText: "",
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (text) {
                    message = text;
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              )),
          // 清空
          Visibility(
              visible: controller.text.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Semantics(
                  label: '清空',
                  hint: '清空输入框',
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: SvgPicture.asset(
                          ImageHelper.wrapAssets('login_icon_delete.svg')),
                    ),
                    onTap: () {
                      controller.text = '';
                    },
                  ),
                ),
              ))
        ],
      ),
    );
  }

  static showAlertDialog(
      context,
      String title,
      String hintText,
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
            child: EnterpriseDialog(title, hintText, message, left, right,
                dialogheight, confirmCallBack),
            onWillPop: () async {
              return canCancle;
            },
          );
        });
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
