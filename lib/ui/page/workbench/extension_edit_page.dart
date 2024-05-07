import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/ui/page/login/login_widget_model.dart';
import 'package:weihua_flutter/ui/page/workbench/extension_model.dart';
import 'package:weihua_flutter/ui/widget/custom_alert_dialog.dart';
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

///
/// @Desc: 分机编辑
///
/// @Author: zxh
///
/// @Date: 21/11/18
///

class ExtensioneditPage extends StatefulWidget {
  dynamic? extensionresult;
  ExtensioneditPage(this.extensionresult);
  @override
  _ExtensioneditPageState createState() => _ExtensioneditPageState();
}

class _ExtensioneditPageState extends State<ExtensioneditPage> {
  late DateTime lastPopTime;
  // late String nameStr;
  // late String extensionNumStr;

  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _exterpriseCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String name = '';
  String innernumber = '';
  String phone = '';
  String code = '';
  final FocusNode _pwdNode = FocusNode();
  //空白焦点,不赋值给任何focusNode
  // final FocusNode _blankNode = FocusNode();
  // 定时器相关
  // 验证码计时器
  TimerUtil? _timerUtil;
  int _totalTime = 60 * 1000;
  late LoginWidgetModel widgetModel;
  late ExtensionInfoMode extensionModel = ExtensionInfoMode();

  @override
  void initState() {
    super.initState();
    extensionModel.ischangePhone(widget.extensionresult.mobile);
    _phoneCtrl.selection = TextSelection.fromPosition(
        TextPosition(offset: _phoneCtrl.text.length));
    if (widget.extensionresult != null) {
      name = name == '' ? widget.extensionresult.userName : name;
      innernumber =
          innernumber == '' ? widget.extensionresult.number : innernumber;
      phone = phone == '' ? widget.extensionresult.mobile : phone;
      _phoneCtrl.text = phone;
      _nameCtrl.text = name;
      _exterpriseCtrl.text = innernumber;
    }
    _timerUtil = TimerUtil(mTotalTime: _totalTime);
    _timerUtil!.setOnTimerTickCallback((millisUntilFinished) {
      double _tick = millisUntilFinished / 1000;
      debugPrint("$_tick");
      if (_tick == 0) {
        _timerUtil?.cancel();
      }
      widgetModel.updateTick(_tick.toInt());
    });
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
    _timerUtil?.cancel();
    _timerUtil = null;
    // _phoneCtrl.dispose();
    _codeCtrl.dispose();
  }

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text("编辑分机号"),
          actions: [
            widget.extensionresult.number == '1000'
                ? Text('')
                : InkWell(
                    child: Container(
                        child: Text('删除',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white)),
                        padding: EdgeInsets.all(15.w)),
                    onTap: () async {
                      CustomAlertDialog.showAlertDialog(
                          context,
                          "删除",
                          '确认删除分机?',
                          S.of(context).actionCancel,
                          S.of(context).actionConfirm,
                          180, (value) async {
                        if (value == 1) {
                          bool result = await extensionModel.deleteExtension(
                              accRepo.user!.outerNumber.toString(),
                              widget.extensionresult.oid.toString());
                          if (result) {
                            Navigator.pop(context, true);
                          } else {
                            extensionModel.showErrorMessage(context);
                            EasyLoading.dismiss();
                          }
                        }
                      }, true);
                    },
                  )
          ],
          leading: new IconButton(
              icon: SvgPicture.asset(ImageHelper.wrapAssets(
                  Theme.of(context).brightness == Brightness.light
                      ? "nav_icon_return.svg"
                      : "nav_icon_return_sel.svg")),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ProviderWidget2<ExtensionInfoMode, LoginWidgetModel>(
            model1: ExtensionInfoMode(),
            model2: LoginWidgetModel(),
            builder: (context, model1, model2, child) {
              // extensionModel = model1;
              widgetModel = model2;
              if (extensionModel.isBusy) {
                EasyLoading.show();
              }
              if (extensionModel.isIdle) {
                EasyLoading.dismiss();
              }
              return Container(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.extensionresult.status == 1
                        ? _activationRow(context, model2)
                        : _noactivationRow(context, model2),
                  ],
                ),
              );
            }));
  }

  Widget _activationRow(BuildContext context, LoginWidgetModel model) {
    Color color = Theme.of(context).primaryColor;
    return GestureDetector(
        // 触摸收起键盘
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
            height: 700.h,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              children: [
                Container(
                  width: 355.w,
                  height: extensionModel.changePhone ==
                          widget.extensionresult.mobile
                      ? 190.h
                      : 232.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colour.f1A1A1A,
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                          width: 355.w,
                          height: 116.h,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : Colour.f1A1A1A,
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)),
                          ),
                          child: Column(children: [
                            Container(
                              padding: EdgeInsets.only(left: 15.w),
                              width: 355.w,
                              height: 55.h,
                              child: Row(
                                children: [
                                  Text(
                                    '姓名',
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colour.cFF212121
                                            : Colour.fffffff,
                                        fontSize: 16),
                                  ),
                                  SizedBox(width: 31.w),
                                  Expanded(
                                    flex: 1,
                                    child: TextField(
                                      controller: _nameCtrl,
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
                                        hintText: '请输入姓名',
                                        hintStyle: TextStyle(
                                            fontSize: 16.0,
                                            color: Colour.cFF999999),
                                      ),
                                      keyboardType: TextInputType.multiline,
                                      onChanged: (text) {
                                        name = text;
                                        // model.updatePhone(text);
                                      },
                                      onEditingComplete: () {
                                        // FocusScope.of(context)
                                        //     .requestFocus(_pwdNode); //焦点付给密码输入框
                                      },
                                    ),
                                  ),
                                  // 清空
                                  // Visibility(
                                  //     visible: model.clearPhone,
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(1.0),
                                  //       child: Semantics(
                                  //         label: '清空',
                                  //         hint: '清空输入框',
                                  //         child: GestureDetector(
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.all(10.0),
                                  //             child: SvgPicture.asset(
                                  //                 ImageHelper.wrapAssets(
                                  //                     'login_icon_delete.svg')),
                                  //           ),
                                  //           onTap: () {
                                  //             _phoneCtrl.text = '';
                                  //             _timerUtil?.cancel();
                                  //             _timerAudioCode?.cancel();
                                  //             widgetModel.updateTick(0);
                                  //             // widgetModel.updateAudioTick(1);
                                  //             model.updatePhone("");
                                  //           },
                                  //         ),
                                  //       ),
                                  //     )),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              endIndent: 15,
                              indent: 76.w,
                              color: context.isBrightness
                                  ? Colour.cFFEEEEEE
                                  : Colour.f2E313C,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15.w),
                              width: 355.w,
                              height: 55.h,
                              child: Row(
                                children: [
                                  Text(
                                    '分机号',
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colour.cFF212121
                                            : Colour.fffffff,
                                        fontSize: 16),
                                  ),
                                  SizedBox(width: 18.w),
                                  Expanded(
                                    flex: 1,
                                    child: TextField(
                                      controller: _exterpriseCtrl,
                                      textAlign: TextAlign.start,
                                      readOnly: widget.extensionresult.number ==
                                              '1000'
                                          ? true
                                          : false,
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
                                        hintText: '请输入3位或4位分机号',
                                        hintStyle: TextStyle(
                                            fontSize: 16.0,
                                            color: Colour.cFF999999),
                                      ),
                                      keyboardType: TextInputType.phone,
                                      onChanged: (text) {
                                        innernumber = text;
                                        // model.updatePhone(text);
                                      },
                                      onEditingComplete: () {
                                        //   FocusScope.of(context)
                                        //       .requestFocus(_pwdNode); //焦点付给密码输入框
                                      },
                                    ),
                                  ),
                                  // 清空
                                  // Visibility(
                                  //     visible: model.clearPhone,
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(1.0),
                                  //       child: Semantics(
                                  //         label: '清空',
                                  //         hint: '清空输入框',
                                  //         child: GestureDetector(
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.all(10.0),
                                  //             child: SvgPicture.asset(
                                  //                 ImageHelper.wrapAssets(
                                  //                     'login_icon_delete.svg')),
                                  //           ),
                                  //           onTap: () {
                                  //             _codeCtrl.text = '';
                                  //             _timerUtil?.cancel();
                                  //             _timerAudioCode?.cancel();
                                  //             widgetModel.updateTick(0);
                                  //             // widgetModel.updateAudioTick(1);
                                  //             model.updatePhone("");
                                  //           },
                                  //         ),
                                  //       ),
                                  //     )),
                                ],
                              ),
                            )
                          ])),
                      Divider(
                        height: 1,
                        endIndent: 15,
                        indent: 76.w,
                        color: context.isBrightness
                            ? Colour.cFFEEEEEE
                            : Colour.f2E313C,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 15.w),
                          Text(
                            '手机号',
                            style: TextStyle(
                                color: context.isBrightness
                                    ? Colour.cFF212121
                                    : Colour.CCFFFFFF,
                                fontSize: 16),
                          ),
                          SizedBox(width: 18.w),
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
                                hintStyle: TextStyle(
                                    fontSize: 16.0, color: Colour.cFF999999),
                              ),
                              keyboardType: TextInputType.phone,
                              onChanged: (text) {
                                phone = text;
                                model.updatePhone(text);
                                extensionModel.ischangePhone(text);
                              },
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(_pwdNode); //焦点付给密码输入框
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
                                          ImageHelper.wrapAssets(
                                              'login_icon_delete.svg')),
                                    ),
                                    onTap: () {
                                      _phoneCtrl.text = '';
                                      _timerUtil?.cancel();
                                      widgetModel.updateTick(0);
                                      // widgetModel.updateAudioTick(1);
                                      // model.updatePhone("");
                                    },
                                  ),
                                ),
                              )),
                        ],
                      ),
                      extensionModel.changePhone ==
                              widget.extensionresult.mobile
                          ? Divider(
                              height: 0,
                              endIndent: 0,
                              indent: 0.w,
                              color: context.isBrightness
                                  ? Colors.white
                                  : Colour.f1A1A1A,
                            )
                          : Divider(
                              height: 1,
                              endIndent: 15,
                              indent: 76.w,
                              color: context.isBrightness
                                  ? Colour.cFFEEEEEE
                                  : Colour.f2E313C,
                            ),
                      extensionModel.changePhone ==
                              widget.extensionresult.mobile
                          ? Text('')
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(width: 15.w),
                                Text(
                                  '验证码',
                                  style: TextStyle(
                                      color: context.isBrightness
                                          ? Colour.cFF212121
                                          : Colour.CCFFFFFF,
                                      fontSize: 16),
                                ),
                                SizedBox(width: 18.w),
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
                                        hintText: S
                                            .of(context)
                                            .login_tips_input_vctext,
                                        hintStyle: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (text) {
                                        code = text;
                                        // model.updateCode(text);
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
                                                ImageHelper.wrapAssets(
                                                    'login_icon_delete.svg')),
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
                                    onPressed: (_timerUtil?.isActive() ??
                                                false) ||
                                            !StringUtils.isMobileNumber(
                                                _phoneCtrl.text) ||
                                            StringUtils.isEmptyString(
                                                _phoneCtrl.text)
                                        ? null
                                        : () async {
                                            bool canGetCode =
                                                await extensionModel
                                                    .sendextensionCode(
                                                        _phoneCtrl.text);
                                            if (canGetCode) {
                                              _timerUtil
                                                  ?.updateTotalTime(_totalTime);
                                            }
                                          },
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.all(1.0)),
                                        side: MaterialStateProperty.all(
                                            BorderSide.none),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colour.f3183F7.withAlpha(
                                                    !StringUtils.isEmptyString(
                                                            _phoneCtrl.text)
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
                ),
                SizedBox(height: 20.h),
                _confirmationButton(context, widgetModel),
              ],
            )));
  }

  Widget _noactivationRow(BuildContext context, LoginWidgetModel model) {
    final _noactivenameCtrl = TextEditingController(
        text: widget.extensionresult == null
            ? ''
            : name == ''
                ? widget.extensionresult.userName
                : name);
    final _noactiveexterpriseCtrl = TextEditingController(
        text: widget.extensionresult == null
            ? ''
            : innernumber == ''
                ? widget.extensionresult.number
                : innernumber);
    // if (widget.extensionresult != null) {
    //   // _noactivenameCtrl.text = widget.extensionresult.userName;
    //   // _noactiveexterpriseCtrl.text = widget.extensionresult.number;
    //   name = name == '' ? widget.extensionresult.userName : name;
    //   innernumber =
    //       innernumber == '' ? widget.extensionresult.number : innernumber;
    // }
    return GestureDetector(
        // 触摸收起键盘
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
            height: 700.h,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(children: [
              Container(
                  width: 355.w,
                  height: 116.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colour.f1A1A1A,
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                  child: Column(children: [
                    Container(
                      padding: EdgeInsets.only(left: 15.w),
                      width: 355.w,
                      height: 55.h,
                      child: Row(
                        children: [
                          Text(
                            '姓名',
                            style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colour.cFF212121
                                    : Colour.fffffff,
                                fontSize: 16),
                          ),
                          SizedBox(width: 31.w),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: _noactivenameCtrl,
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
                                hintText: '请输入姓名',
                                hintStyle: TextStyle(
                                    fontSize: 16.0, color: Colour.cFF999999),
                              ),
                              keyboardType: TextInputType.multiline,
                              onChanged: (text) {
                                name = text;
                                // model.updatePhone(text);
                              },
                              onEditingComplete: () {
                                // FocusScope.of(context)
                                //     .requestFocus(_pwdNode); //焦点付给密码输入框
                              },
                            ),
                          ),
                          // 清空
                          // Visibility(
                          //     visible: model.clearPhone,
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(1.0),
                          //       child: Semantics(
                          //         label: '清空',
                          //         hint: '清空输入框',
                          //         child: GestureDetector(
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(10.0),
                          //             child: SvgPicture.asset(
                          //                 ImageHelper.wrapAssets(
                          //                     'login_icon_delete.svg')),
                          //           ),
                          //           onTap: () {
                          //             _phoneCtrl.text = '';
                          //             _timerUtil?.cancel();
                          //             _timerAudioCode?.cancel();
                          //             widgetModel.updateTick(0);
                          //             // widgetModel.updateAudioTick(1);
                          //             model.updatePhone("");
                          //           },
                          //         ),
                          //       ),
                          //     )),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      endIndent: 15,
                      indent: 76.w,
                      color: context.isBrightness
                          ? Colour.cFFEEEEEE
                          : Colour.f2E313C,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15.w),
                      width: 355.w,
                      height: 55.h,
                      child: Row(
                        children: [
                          Text(
                            '分机号',
                            style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colour.cFF212121
                                    : Colour.fffffff,
                                fontSize: 16),
                          ),
                          SizedBox(width: 18.w),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: _noactiveexterpriseCtrl,
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
                                hintText: '请输入3位或4位分机号',
                                hintStyle: TextStyle(
                                    fontSize: 16.0, color: Colour.cFF999999),
                              ),
                              keyboardType: TextInputType.phone,
                              onChanged: (text) {
                                // model.updatePhone(text);
                                innernumber = text;
                              },
                              onEditingComplete: () {
                                //   FocusScope.of(context)
                                //       .requestFocus(_pwdNode); //焦点付给密码输入框
                              },
                            ),
                          ),
                          // 清空
                          // Visibility(
                          //     visible: model.clearPhone,
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(1.0),
                          //       child: Semantics(
                          //         label: '清空',
                          //         hint: '清空输入框',
                          //         child: GestureDetector(
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(10.0),
                          //             child: SvgPicture.asset(
                          //                 ImageHelper.wrapAssets(
                          //                     'login_icon_delete.svg')),
                          //           ),
                          //           onTap: () {
                          //             _codeCtrl.text = '';
                          //             _timerUtil?.cancel();
                          //             _timerAudioCode?.cancel();
                          //             widgetModel.updateTick(0);
                          //             // widgetModel.updateAudioTick(1);
                          //             model.updatePhone("");
                          //           },
                          //         ),
                          //       ),
                          //     )),
                        ],
                      ),
                    )
                  ])),
              SizedBox(height: 20.h),
              _confirmationButton(context, widgetModel),
            ])));
  }

  Widget _confirmationButton(
      BuildContext context, LoginWidgetModel widgetModel) {
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
                '保存',
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
                () async {
              bool result;
              if (widget.extensionresult.status == 1) {
                result = await extensionModel.editactiveExtension(
                    accRepo.user!.outerNumber.toString(),
                    innernumber,
                    name,
                    widget.extensionresult!.oid.toString(),
                    phone,
                    extensionModel.changePhone == widget.extensionresult.mobile
                        ? '1239'
                        : code);
                if (result) {
                  Navigator.pop(context, true);
                } else {
                  extensionModel.showErrorMessage(context);
                  EasyLoading.dismiss();
                }
              } else {
                result = await extensionModel.editboactiveExtension(
                    accRepo.user!.outerNumber.toString(),
                    innernumber,
                    name,
                    widget.extensionresult!.oid.toString());
                if (result) {
                  Navigator.pushNamed(
                      context, RouteName.extentioneditResultPage,
                      arguments: '${widget.extensionresult.oid}');
                } else {
                  extensionModel.showErrorMessage(context);
                  EasyLoading.dismiss();
                }
              }

              // FocusScope.of(context).requestFocus(_blankNode); //收起键盘
              // Log.d('登录按钮被点击');
              // // 判断 手机号
              // if (!StringUtils.isMobileNumber(_phoneCtrl.text)) {
              //   showToast(S.of(context).login_tips_input_phone);
              //   return;
              // }

              // // 判断 验证码
              // if (_codeCtrl.text.isEmpty && _codeCtrl.text.length == 6) {
              //   showToast(S.of(context).login_tips_input_vctext);

              //   return;
              // }
            },
          ),
        ),
      ],
    );
  }
}
