import 'dart:async';

import 'package:weihua_flutter/config/const_config.dart';
import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/event/network_change_event.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/model/unify_login_result.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/event_bus.dart';
import 'package:weihua_flutter/ui/page/login/login_model.dart';
import 'package:weihua_flutter/ui/page/login/login_widget.dart';
import 'package:weihua_flutter/ui/page/login/login_widget_model.dart';
import 'package:weihua_flutter/ui/widget/custom_logintips_dialog.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/network_utils.dart';
import 'package:weihua_flutter/utils/platform_utils.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:weihua_flutter/utils/timer_util.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

///
/// @Desc: 登录页
/// @Author: zhhli
/// @Date: 2021-03-19
///
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  late DateTime lastPopTime;
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final FocusNode _pwdNode = FocusNode();

  //空白焦点,不赋值给任何focusNode
  final FocusNode _blankNode = FocusNode();

  // 定时器相关
  // 验证码计时器
  TimerUtil? _timerUtil;
  TimerUtil? _timerAudioCode;

  int _totalTime = 60 * 1000;

  late LoginWidgetModel widgetModel;
  late StreamSubscription _subscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      NetWorkUtils.check();
    }
  }

  @override
  void initState() {
    super.initState();
    NetWorkUtils.initConnectivity();

    _subscription = eventBus.on<NetworkChangeEvent>().listen((event) async {
      ishavenet = event.hasNet;
    });
    _timerUtil = TimerUtil(mTotalTime: _totalTime);
    _timerUtil!.setOnTimerTickCallback((millisUntilFinished) {
      double _tick = millisUntilFinished / 1000;
      debugPrint("$_tick");
      if (_tick == 0) {
        _timerUtil?.cancel();
      }
      widgetModel.updateTick(_tick.toInt());
    });

    _timerAudioCode = TimerUtil(mTotalTime: 20 * 1000);
    _timerAudioCode!.setOnTimerTickCallback((millisUntilFinished) {
      double _tick = millisUntilFinished / 1000;
      if (_tick == 0) {
        _timerAudioCode?.cancel();
      }
      widgetModel.updateAudioTick(_tick.toInt());
    });
    showLoginTips();
  }

  void showLoginTips() {
    if (accRepo.getAPPIsAgreeProt()) {
      return;
    }
    Future.delayed(Duration(milliseconds: 200)).then((e) {
      CustomLoginTipsDialog.showAlertDialog(
          context,
          "温馨提示",
          '欢迎来到微话，感谢您对微话的信任与支持！为了提供给您更优质的服务，我们会收集或使用您的相关信息及手机应用权限。具体内容请您详阅《隐私协议》全文，我们已经采用先进的信息保护措施，并将持续优化和提升信息安全管理措施及流程，来保护您的个人信息安全。',
          '不同意',
          '同意', (value) {
        if (value == 0) {
          // 退出app
          accRepo.saveAPPIsAgreeProt(false);
          exit(0);
        } else {
          accRepo.saveAPPIsAgreeProt(true);
        }
      }, false);
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _timerUtil?.cancel();
    _timerUtil = null;
    _timerAudioCode?.cancel();
    _timerAudioCode = null;

    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    hideKeyboard(context);
    super.dispose();
    NetWorkUtils.cancle();
    WidgetsBinding.instance.removeObserver(this);
    debugPrint("login dispose.....");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          print('loginPage WillPopScope');

          // T121 在登录页面点击手机的返回键无法退出程序
          if (Platform.isIOS) {
            //ios相关代码
            return Future.value(false);
          } else if (Platform.isAndroid) {
            // 点击返回键的操作
            if (DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
              lastPopTime = DateTime.now();
              showToast('再按一次退出');
              return Future.value(false);
            } else {
              lastPopTime = DateTime.now();
              // 退出app
              await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              return Future.value(true);
            }
          } else {
            return Future.value(false);
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colour.backgroundColor2
              : Colour.f111111,
          body: GestureDetector(
              onTap: () {
                hideKeyboard(context);
              },
              child: NotificationListener(
                onNotification: (ScrollNotification notification) {
                  if (notification is ScrollStartNotification) {
                    if (Platform.isIOS) {
                      hideKeyboard(context);
                    }
                  }
                  return false;
                },
                child: CustomScrollView(
                  physics: ClampingScrollPhysics(),
                  slivers: [
                    // SliverAppBar(
                    //   floating: true,
                    // ),
                    SliverToBoxAdapter(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 58.h),
                          LoginLogo(),
                          SizedBox(height: 20.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child:
                                ProviderWidget2<LoginModel, LoginWidgetModel>(
                              model1:
                                  LoginModel(Provider.of<UserModel>(context)),
                              model2: LoginWidgetModel(),
                              builder: (context, model, model2, child) {
                                if (model.isBusy) {
                                  // EasyLoading.show(status: "正在登录...");
                                }

                                if (model.isIdle) {
                                  EasyLoading.dismiss();
                                }
                                widgetModel = model2;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _phoneRow(context, model2),
                                    SizedBox(height: 10.h),
                                    _codeRow(context, model2),
                                    SizedBox(height: 10.h),
                                    // _audioText(context, model2),
                                    SizedBox(height: 20.h),
                                    _loginButton(context, model, model2)
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ));
  }

  Widget _phoneRow(BuildContext context, LoginWidgetModel model) {
    return Container(
      // height: 50.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  controller: _phoneCtrl,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  maxLength: 11,
                  autofocus: true,
                  cursorColor: context.isBrightness
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    counterText: "",
                    hintText: S.of(context).login_hint_input_phone,
                    hintStyle:
                        TextStyle(fontSize: 16.0, color: Colour.cFF999999),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (text) {
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
                          widgetModel.updateAudioTick(1);
                          model.updatePhone("");
                        },
                      ),
                    ),
                  )),
            ],
          ),
          Divider(
            height: 1,
            color: context.isBrightness ? Colour.cFFEEEEEE : Colour.f2E313C,
          )
        ],
      ),
    );
  }

  Widget _codeRow(BuildContext context, LoginWidgetModel model) {
    Color color = Theme.of(context).primaryColor;
    return Container(
      // height: 50.h,
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
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
                          String phone = _phoneCtrl.text;
                          if (StringUtils.isMobileNumber(phone)) {
                            bool canGetCode = await _doSendCode(context, 0);
                            if (canGetCode) {
                              _timerUtil?.updateTotalTime(_totalTime);
                              if (!model.showAudioCodeText) {
                                // 还未显示过语音验证码
                                _timerAudioCode?.startCountDown();
                              }
                            }
                          } else {
                            showToast(S.of(context).login_tips_input_phone);
                          }
                        },
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide.none),
                      foregroundColor: MaterialStateProperty.all(Colour.f3183F7
                          .withAlpha(
                              !StringUtils.isEmptyString(_phoneCtrl.text) &&
                                      _timerUtil!.isActive() == false
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
          Divider(
            height: 1,
            color: context.isBrightness ? Colour.cFFEEEEEE : Colour.f2E313C,
          )
        ],
      ),
    );
  }

  // 语音验证码
  Widget _audioText(BuildContext context, LoginWidgetModel model) {
    return Visibility(
      visible: model.showAudioCodeText,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(S.of(context).login_audio_code_subtitle,
              style: TextStyle(fontSize: 12)),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                S.of(context).login_audio_code,
                style: TextStyle(color: Colour.f3183F7, fontSize: 12),
              ),
            ),
            onTap: () {
              _doSendCode(context, 1);
            },
          )
        ],
      ),
    );
  }

  Widget _loginButton(
      BuildContext context, LoginModel model, LoginWidgetModel widgetModel) {
    var color = Colour.f0F8FFB;

    TextStyle textStyle = Theme.of(context).textTheme.caption!;

    return Column(
      children: [
        Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            color: !widgetModel.loginClickable ? color.withAlpha(80) : color,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(23),
            child: Container(
              height: 45.h,
              alignment: Alignment.center,
              child: Text(
                S.of(context).signIn,
                style: widgetModel.loginClickable
                    // ? Theme.of(context).accentTextTheme.bodyText1
                    ? TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary)
                    : TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colour.fffffff
                            : Colour.f61ffffff),
              ),
            ),
            onTap: !widgetModel.loginClickable
                ? null
                : () {
                    FocusScope.of(context).requestFocus(_blankNode); //收起键盘
                    Log.d('登录按钮被点击');
                    // 判断 手机号
                    if (!StringUtils.isMobileNumber(_phoneCtrl.text)) {
                      showToast(S.of(context).login_tips_input_phone);
                      return;
                    }

                    // 判断 验证码
                    if (_codeCtrl.text.isEmpty) {
                      showToast(S.of(context).login_tips_input_vctext);

                      return;
                    }

                    if (!widgetModel.checkedAgreement) {
                      showToast(S.of(context).login_agree_tip);
                      return;
                    }

                    _doLoginAction(context);
                  },
          ),
          // 校验显示 按钮可点击
        ),
        SizedBox(
          height: 13.h,
        ),
        Ink(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              gradient: LinearGradient(
                  //渐变位置
                  begin: Alignment.centerLeft, //右上
                  end: Alignment.centerRight, //左下
                  stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                  //渐变颜色[始点颜色, 结束颜色]
                  colors: [Colour.FFFF8786, Colour.FFFF4F4E])),
          // color: Colour.c0x0F88FF,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Container(
              height: 45.h,
              alignment: Alignment.center,
              child: Text(
                S.of(context).btn_buy_num,
                style: widgetModel.loginClickable
                    ? TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary)
                    : TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colour.fffffff
                            : Colour.f61ffffff),
              ),
            ),
            onTap: () {
              Get.toNamed(RouteName.pNumberBuy);
            },
          ),
          // 校验显示 按钮可点击
        ),
        SizedBox(
          height: 8.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    left: 10.w, top: 10.h, bottom: 10.h, right: 10.w),
                child: SvgPicture.asset(
                    widgetModel.checkedAgreement
                        ? ImageHelper.wrapAssets('sign_selected.svg')
                        : ImageHelper.wrapAssets('sign_unselected.svg'),
                    height: 16,
                    width: 16),
              ),
              onTap: () {
                widgetModel.updateChecked(!widgetModel.checkedAgreement);
              },
            ),
            Text(
              S.of(context).agree,
              style: textStyle.change(context, fontSize: 15),
            ),
            InkWell(
              child: Text(
                S.of(context).user_agreement,
                style: TextStyle(color: color, fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(RouteName.webH5,
                    arguments:
                        "${ConstConfig.user_agreement}${Theme.of(context).brightness == Brightness.light ? 0 : 1}");
              },
            ),
            InkWell(
              child: Text(
                S.of(context).privacy_agreement,
                style: TextStyle(color: color, fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(RouteName.webH5,
                    arguments:
                        "${ConstConfig.privacy}${Theme.of(context).brightness == Brightness.light ? 0 : 1}");
              },
            ),
          ],
        ),
        SizedBox(
          height: 30.h,
        ),
      ],
    );
  }

  void _doLoginAction(BuildContext context) async {
    // showToast(S.of(context).signIn);
    EasyLoading.show(status: "正在登录...");
    LoginModel _loginmodel = Provider.of<LoginModel>(context, listen: false);
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    UnifyLoginResult? loginResult =
        await _loginmodel.login(_phoneCtrl.text, _codeCtrl.text);
    EasyLoading.dismiss();
    if (loginResult != null) {
      if (loginResult.numberList.isEmpty) {
        showToast('暂无可使用号码，请购买新号码');
        return;
      }
      if (accRepo.unifyLoginResult!.companyNumberList.isNotEmpty) {
        userModel.saveUser(accRepo.unifyLoginResult!.companyNumberList[0]);
      } else {
        userModel.saveUser(accRepo.unifyLoginResult!.perNumberList[0]);
      }
      isLogin = true;
      Navigator.of(context).pushNamedAndRemoveUntil(
          RouteName.tab, (Route<dynamic> route) => false);
    } else {
      _loginmodel.showErrorMessage(context);
    }
  }

  Future<bool> _doSendCode(BuildContext context, int codeType) async {
    LoginModel _loginmodel = Provider.of<LoginModel>(context, listen: false);

    bool result = await _loginmodel.sendCode(_phoneCtrl.text, codeType);
    if (result) {
      if (codeType == 1) {
        showToast('请注意接95013***的来电');
      } else {
        showToast('验证码已发送至${_phoneCtrl.text}');
      }
    } else {
      _loginmodel.showErrorMessage(context);
      return false;
    }
    return result;
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
