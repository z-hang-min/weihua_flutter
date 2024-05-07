import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/ui/page/login/login_widget_model.dart';
import 'package:weihua_flutter/ui/page/workbench/extension_model.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:weihua_flutter/utils/timer_util.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';

///
/// @Desc: 分机激活
///
/// @Author: zxh
///
/// @Date: 21/11/18
///

class ExtensionactivationPage extends StatefulWidget {
  @override
  _ExtensionactivationPageState createState() =>
      _ExtensionactivationPageState();
}

class _ExtensionactivationPageState extends State<ExtensionactivationPage> {
  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  late DateTime lastPopTime;
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final FocusNode _pwdNode = FocusNode();

  //空白焦点,不赋值给任何focusNode
  // final FocusNode _blankNode = FocusNode();
  // 定时器相关
  // 验证码计时器
  TimerUtil? _timerUtil;
  TimerUtil? _timerAudioCode;

  // int _totalTime = 60 * 1000;
  late LoginWidgetModel widgetModel;
  late ExtensionInfoMode extensionModel;

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text("激活分机"),
          leading: new IconButton(
              icon: SvgPicture.asset(ImageHelper.wrapAssets(
                  Theme.of(context).brightness == Brightness.light
                      ? "extention_result_close.svg"
                      : "extention_result_close_dark.svg")),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ProviderWidget2<ExtensionInfoMode, LoginWidgetModel>(
            model1: ExtensionInfoMode(),
            model2: LoginWidgetModel(),
            builder: (context, model, model2, child) {
              // if (model.isBusy) {
              //   // EasyLoading.show(status: "正在登录...");
              // }

              // if (model.isIdle) {
              //   EasyLoading.dismiss();
              // }
              extensionModel = model;
              widgetModel = model2;
              return GestureDetector(
                  // 触摸收起键盘
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Container(
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        children: [
                          Text('134****7787,邀请你（王晋）成为分级用户，请输入您的手机号和短信验证码。',
                              style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colour.CCFFFFFF
                                      : Colour.FF999999)),
                          SizedBox(
                            height: 15.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: 355.w,
                                  height: 116.h,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.white
                                        : Colour.f1A1A1A,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      _phoneRow(context, model2),
                                      Divider(
                                        height: 1,
                                        endIndent: 15,
                                        indent: 94.w,
                                        color: context.isBrightness
                                            ? Colour.cFFEEEEEE
                                            : Colour.f2E313C,
                                      ),
                                      _codeRow(context, model2),
                                    ],
                                  )),
                              SizedBox(height: 20.h),
                              _confirmationButton(context, model, model2)
                            ],
                          ),
                        ],
                      )));
            }));
  }

  Widget _phoneRow(BuildContext context, LoginWidgetModel model) {
    return Container(
      height: 55.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 15.w),
              Text(
                '手机号',
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colour.cFF212121
                        : Colour.CCFFFFFF,
                    fontSize: 16),
              ),
              SizedBox(width: 31.w),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: _phoneCtrl,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  maxLength: 11,
                  autofocus: false,
                  cursorColor: context.isBrightness
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    counterText: "",
                    hintText: '请输入绑定的手机号',
                    hintStyle:
                        TextStyle(fontSize: 16.0, color: Colour.cFF999999),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (text) {
                    Log.v('change _inputPhoneString $text');
                    model.updatePhone(text);
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_pwdNode); //焦点付给密码输入框
                  },
                ),
              ),
              // 清空
              Visibility(
                  visible: model.clearPhone,
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
                          _timerUtil?.cancel();
                          _timerAudioCode?.cancel();
                          widgetModel.updateTick(0);
                          // widgetModel.updateAudioTick(1);
                          model.updatePhone("");
                        },
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _codeRow(BuildContext context, LoginWidgetModel model) {
    Color color = Theme.of(context).primaryColor;
    return Container(
      height: 55.h,
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 15.w),
              Text(
                '验证码',
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colour.cFF212121
                        : Colour.CCFFFFFF,
                    fontSize: 16),
              ),
              SizedBox(width: 31.w),
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
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      counterText: "",
                      hintText: S.of(context).login_tips_input_vctext,
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      model.updateCode(text);
                    }),
              ),
              // 清空验证码
              Visibility(
                  visible: model.clearCode,
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
                          model.updateCode("");
                        },
                      ),
                    ),
                  )),
              // 验证码按钮
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton(
                  focusNode: FocusNode(skipTraversal: true),
                  onPressed: (_timerUtil?.isActive() ?? false) ||
                          !StringUtils.isMobileNumber(_phoneCtrl.text) ||
                          StringUtils.isEmptyString(_phoneCtrl.text)
                      ? null
                      : () async {
                          // String phone = _phoneCtrl.text;
                          // if (StringUtils.isMobileNumber(phone)) {
                          //   bool canGetCode = await _doSendCode(context, 0);
                          //   if (canGetCode) {
                          //     _timerUtil?.updateTotalTime(_totalTime);
                          //     if (!model.showAudioCodeText) {
                          //       // 还未显示过语音验证码
                          //       _timerAudioCode?.startCountDown();
                          //     }
                          //   }
                          // } else {
                          //   showToast(S.of(context).login_tips_input_phone);
                          // }
                          extensionModel
                              .sendextensionCode(accRepo.user!.mobile);
                        },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(1.0)),
                      side: MaterialStateProperty.all(BorderSide.none),
                      foregroundColor: MaterialStateProperty.all(Colour.f3183F7
                          .withAlpha(!StringUtils.isEmptyString(_phoneCtrl.text)
                              ? 500
                              : 100))),
                  child: Container(
                    child: Text(
                      model.tickText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _confirmationButton(BuildContext context, ExtensionInfoMode model,
      LoginWidgetModel widgetModel) {
    var color = Colour.f0F8FFB;

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: CupertinoButton(
            borderRadius: BorderRadius.circular(23),
            padding: EdgeInsets.all(1),
            color: color,
            disabledColor: Colour.f0F8FFB.withAlpha(100),
            child: Container(
              height: 45.h,
              alignment: Alignment.center,
              child: Text(
                '确认',
                style: widgetModel.loginClickable
                    ? TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary)
                    : TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colour.fffffff
                            : Colour.fffffff),
              ),
            ),
            // 校验显示 按钮可点击
            onPressed:
                // !widgetModel.loginClickable
                //     ? null
                //     :
                () {
              // FocusScope.of(context).requestFocus(_blankNode); //收起键盘
              // Log.d('登录按钮被点击');
              // // 判断 手机号
              if (!StringUtils.isMobileNumber(_phoneCtrl.text)) {
                showToast(S.of(context).login_tips_input_phone);
                return;
              }

              // // 判断 验证码
              if (_codeCtrl.text.isEmpty && _codeCtrl.text.length == 6) {
                showToast(S.of(context).login_tips_input_vctext);

                return;
              }
              extensionModel.activeExtension(
                  accRepo.user!.outerNumber.toString(),
                  '1',
                  accRepo.user!.mobile.toString(),
                  _codeCtrl.text);
              Navigator.pushNamed(context, RouteName.extentionResultPage);

              // _doLoginAction(context);
            },
          ),
        ),
      ],
    );
  }
}
