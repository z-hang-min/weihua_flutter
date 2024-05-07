import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/edit_phone_model.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

///
/// @Desc: 更改绑定手机号
///
/// @Author:zm
///
/// @Date: 21/7/23
///

typedef AlertConfirmCallBack = void Function(int value);
typedef OnPressedGetCode = void Function(String value);
typedef OnPressedBtnOk = void Function(String value);

class AlertEditPhoneDialog extends Dialog {
  final String phone;
  final OnPressedGetCode onPressedGetCode;
  final OnPressedBtnOk onPressedbtnOk;
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final FocusNode _pwdNode = FocusNode();
  final XEditPhoneViewModel xEditPhoneViewModel = XEditPhoneViewModel();

  AlertEditPhoneDialog(
    this.phone,
    this.onPressedGetCode,
    this.onPressedbtnOk,
  ) : super();

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle headline6 = textTheme.headline6!;
    _phoneCtrl.text = phone;
    xEditPhoneViewModel.editPhone.value = phone;
    //自定义弹框内容
    return Material(
      type: MaterialType.transparency,
      child: Center(
          child: Container(
        width: 320.w,
        constraints: BoxConstraints(minHeight: 242.w),
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
            height: 242.h,
            margin: EdgeInsets.only(top: 16.h),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "绑定手机号",
                        style: headline6.change(context, color: Colour.f333333),
                      ),
                      Positioned(
                          right: 16.w,
                          child: InkWell(
                            onTap: () {
                              xEditPhoneViewModel.stopTimer();
                              Get.back();
                            },
                            child: SvgPicture.asset(
                              ImageHelper.wrapAssets('icon_delete.svg'),
                            ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 26.h,
                ),
                _phoneRow(context),
                SizedBox(
                  height: 10.h,
                ),
                _codeRow(context),
                SizedBox(
                  height: 16.h,
                ),
                Obx(() {
                  return ListTile(
                    contentPadding: EdgeInsets.only(left: 20.w, right: 20.w),
                    title: CupertinoButton(
                      borderRadius: BorderRadius.circular(23),
                      padding: EdgeInsets.all(1),
                      color: Colour.f0F8FFB,
                      disabledColor: Colour.f0F8FFB.withAlpha(100),
                      child: Container(
                        height: 45.h,
                        alignment: Alignment.center,
                        child: Text(
                          '确定',
                          style: TextStyle(color: Colour.fffffff),
                        ),
                      ),
                      onPressed: xEditPhoneViewModel.editPhone.isEmpty ||
                              xEditPhoneViewModel.code.isEmpty
                          ? null
                          : () async {
                              // FocusScope.of(context)
                              //     .requestFocus(_blankNode); //收起键盘
                              //
                              // 判断 手机号
                              if (!StringUtils.isMobileNumber(
                                  _phoneCtrl.text)) {
                                showToast(S.of(context).login_tips_input_phone);
                                return;
                              }

                              // 判断 验证码
                              if (_codeCtrl.text.isEmpty ||
                                  _codeCtrl.text.length < 4) {
                                showToast('请输入4位验证码');
                                return;
                              }
                              var result = await xEditPhoneViewModel.register();
                              if (result) {
                                showToast('号码绑定成功');
                                xEditPhoneViewModel.stopTimer();
                                Get.back();
                                onPressedbtnOk(_phoneCtrl.text);
                                xEditPhoneViewModel.editPhone.value = '';
                                xEditPhoneViewModel.code.value = '';
                              } else {
                                xEditPhoneViewModel.showErrorMessage(context);
                              }
                            },
                    ),
                  );
                }),
                SizedBox(
                  height: 16.h,
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget _phoneRow(BuildContext context) {
    bool light = Theme.of(context).brightness == Brightness.light;
    return Container(
      height: 45.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 0),
      decoration: ShapeDecoration(
        color: light ? null : Colour.FF565656,
        shape: StadiumBorder(
            side: BorderSide(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colour.bordColor
                    : Colour.FF565656)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              controller: _phoneCtrl,
              textAlign: TextAlign.start,
              maxLines: 1,
              maxLength: 11,
              autofocus: true,
              // style: Theme.of(context).textTheme.bodyText2,
              cursorColor: context.isBrightness
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                counterText: "",
                hintText: S.of(context).login_hint_input_phone,
                hintStyle: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (text) {
                xEditPhoneViewModel.editPhone.value = text;
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_pwdNode); //焦点付给密码输入框
              },
            ),
          ),
          // 清空
          Obx(() {
            return Visibility(
                visible: xEditPhoneViewModel.editPhone.isNotEmpty,
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
                        _phoneCtrl.text = '';
                        xEditPhoneViewModel.editPhone.value = "";
                      },
                    ),
                  ),
                ));
          }),
        ],
      ),
    );
  }

  Widget _codeRow(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    bool light = Theme.of(context).brightness == Brightness.light;
    return Container(
      height: 45.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      decoration: ShapeDecoration(
        color: light ? null : Colour.FF565656,
        shape: StadiumBorder(
            side: BorderSide(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colour.bordColor
                    : Colour.FF565656)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 1,
            child: TextField(
                controller: _codeCtrl,
                textAlign: TextAlign.start,
                focusNode: _pwdNode,
                maxLines: 1,
                maxLength: 6,
                cursorColor: context.isBrightness
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  counterText: "",
                  hintText: S.of(context).login_tips_input_vctext,
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  Log.d(text);
                  xEditPhoneViewModel.code.value = text;
                }),
          ),
          // 清空验证码
          Obx(() {
            return Visibility(
                visible: xEditPhoneViewModel.code.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
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
                        _codeCtrl.text = '';
                        xEditPhoneViewModel.code.value = '';
                      },
                    ),
                  ),
                ));
          }),
          // 验证码按钮
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Obx(() {
              return OutlinedButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () async {
                  if (!StringUtils.isMobileNumber(_phoneCtrl.text)) {
                    showToast(S.of(context).login_tips_input_phone);
                    return;
                  }
                  if (xEditPhoneViewModel.editPhone.isEmpty ||
                      xEditPhoneViewModel.isTimerActive()) return;
                  var result = await xEditPhoneViewModel.sendCode();
                  if (result) {
                    xEditPhoneViewModel.startTimer();
                    onPressedGetCode(_phoneCtrl.text);
                  }
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(1.0)),
                    side: MaterialStateProperty.all(BorderSide.none),
                    foregroundColor: MaterialStateProperty.all(Colour.f3183F7
                        .withAlpha(xEditPhoneViewModel.editPhone.isNotEmpty
                            ? 500
                            : 100))),
                child: Container(
                  child: Obx(() {
                    return Text(
                      xEditPhoneViewModel.tick > 0
                          ? '${xEditPhoneViewModel.tick} s'
                          : '获取验证码',
                    );
                  }),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  static showAlertDialog(
      context,
      String phone,
      OnPressedGetCode onPressedGetCode,
      OnPressedBtnOk onPressedBtnOk,
      bool canCancle) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            child:
                AlertEditPhoneDialog(phone, onPressedGetCode, onPressedBtnOk),
            onWillPop: () async {
              return canCancle;
            },
          );
        });
  }
}
