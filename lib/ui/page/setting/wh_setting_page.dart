import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/config/storage_manager.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/function_permission_help.dart';
import 'package:weihua_flutter/ui/page/setting/answer_mode_page.dart';
import 'package:weihua_flutter/ui/widget/custom_alert_dialog.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'answer_mode.dart';

class SetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SetPageState();
}

class _SetPageState extends State {
  var answerMode =
      StorageManager.sharedPreferences!.getBool(kAnswerModeApp) ?? true;

  @override
  void initState() {
    super.initState();
  }

  String getThemTxt(int themMode) {
    if (themMode == 0) {
      return "浅色模式";
    } else if (themMode == 1) {
      return "深色模式";
    } else {
      return "跟随系统";
    }
    // return "跟随系统";
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          S.of(context).setting,
        ),
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            // _answerModeWidget(context),
            // SizedBox(
            //   height: 10,
            // ),
            Ink(
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                color: Theme.of(context).cardColor,
              ),
              child: InkWell(
                child: Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(ImageHelper.wrapAssets(
                          "setup_list_icon_ringtone.png")),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        S.of(context).ringAndVibrator,
                        style: subtitle1.change(context, color: Colour.f18),
                      ),
                      Spacer(),
                      SvgPicture.asset(context.isBrightness
                          ? ImageHelper.wrapAssets("me_icon_more.svg")
                          : ImageHelper.wrapAssets("me_icon_more_dark.svg")),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, RouteName.ringAndVibrator);
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            _changeThemeMode(context),
            Expanded(flex: 1, child: Container()),
            _logoutWidget(context),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _answerModeWidget(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    return ProviderWidgetNoConsumer(
      model: AnswerMode(),
      onModelReady: (AnswerMode model) {
        model.queryTransfer(accRepo.ownerId, accRepo.outerNumberId);
      },
      child: Consumer2<AnswerMode, UserModel>(
          builder: (context, model, model2, child) => Visibility(
              visible: UserPermissionHelp.enableAnswerType(),
              child: Ink(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  color: Theme.of(context).cardColor,
                ),
                child: InkWell(
                  child: Container(
                    height: 80,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                            ImageHelper.wrapAssets("setup_list_icon_mode.png")),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).answerMode,
                              style:
                                  subtitle1.change(context, color: Colour.f18),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              model.transfer == 0 ? "App接听" : "绑定手机号接听",
                              style: subtitle2.change(context,
                                  color: Colour.hintTextColor),
                            ),
                          ],
                        ),
                        Spacer(),
                        SvgPicture.asset(context.isBrightness
                            ? ImageHelper.wrapAssets("me_icon_more.svg")
                            : ImageHelper.wrapAssets("me_icon_more_dark.svg")),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.answerMode)
                        .then((value) {
                      if (value == null) return;
                      model.updateTransferValue(value as bool ? 0 : 1);
                    });
                  },
                ),
              ))),
    );
  }

  Widget _changeThemeMode(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    return Ink(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
        color: Theme.of(context).cardColor,
      ),
      child: InkWell(
        child: Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(ImageHelper.wrapAssets("setup_list_icon_theme.png")),
              SizedBox(
                width: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).setting_theme_mode,
                    style: subtitle1.change(context, color: Colour.f18),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Consumer<ThemeModel>(
                    builder: (context, model, child) => Text(
                        getThemTxt(model.userThemMode),
                        style: subtitle2.change(context,
                            color: Colour.hintTextColor)),
                  ),
                ],
              ),
              Spacer(),
              SvgPicture.asset(context.isBrightness
                  ? ImageHelper.wrapAssets("me_icon_more.svg")
                  : ImageHelper.wrapAssets("me_icon_more_dark.svg")),
            ],
          ),
        ),
        onTap: () {
          showModalBottomSheet(
              context: context,
              isDismissible: true,
              isScrollControlled: false,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return Consumer<ThemeModel>(
                    builder: (context, model, child) => Ink(
                          height: 247.h,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                child: Container(
                                  height: 58.h,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(
                                    S.of(context).setting_theme_mode1,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: model.userThemMode == 2
                                            ? Colour.f0F8FFB
                                            : (context.isBrightness
                                                ? Colour.titleColor
                                                : Colour.fDEffffff)),
                                  ),
                                ),
                                onTap: () {
                                  switchDarkMode(context, 2);
                                  Navigator.of(context).pop();
                                },
                              ),
                              Divider(
                                height: 1,
                                endIndent: 15,
                                indent: 15,
                                color: !context.isBrightness
                                    ? Colour.c1AFFFFFF
                                    : Colour.cffE6E6E6,
                              ),
                              InkWell(
                                child: Container(
                                  height: 58.h,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(
                                    S.of(context).setting_theme_mode2,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: model.userThemMode == 1
                                            ? Colour.f0F8FFB
                                            : (context.isBrightness
                                                ? Colour.titleColor
                                                : Colour.fDEffffff)),
                                  ),
                                ),
                                onTap: () {
                                  switchDarkMode(context, 1);
                                  Navigator.of(context).pop();
                                },
                              ),
                              Divider(
                                height: 1,
                                endIndent: 15,
                                indent: 15,
                                color: !context.isBrightness
                                    ? Colour.c1AFFFFFF
                                    : Colour.cffE6E6E6,
                              ),
                              InkWell(
                                child: Container(
                                  height: 58.h,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(S.of(context).setting_theme_mode3,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: model.userThemMode == 0
                                              ? Colour.f0F8FFB
                                              : (context.isBrightness
                                                  ? Colour.titleColor
                                                  : Colour.fDEffffff))),
                                ),
                                onTap: () {
                                  switchDarkMode(context, 0);
                                  Navigator.of(context).pop();
                                },
                              ),
                              Container(
                                height: 10.h,
                                color: !context.isBrightness
                                    ? Colour.cFF1E1E1E
                                    : Colour.cFFF7F8F9,
                              ),
                              InkWell(
                                child: Container(
                                  child: Text(
                                    S.of(context).actionCancel,
                                    style: subtitle1,
                                  ),
                                  height: 58.h,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                        ));
              });
        },
      ),
    );
  }

  Widget _logoutWidget(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, model, child) => TextButton(
        onPressed: () {
          CustomAlertDialog.showAlertDialog(
              context,
              "提示",
              S.of(context).logout_tip,
              S.of(context).actionCancel,
              S.of(context).actionConfirm,
              180, (value) {
            if (value == 1) {
              Navigator.pushReplacementNamed(context, RouteName.login);
              logout(model);
            }
          }, true);
        },
        child: Text(
          S.of(context).logout,
          // style: subtitle1.change(context, color: Colour.fEE4452),
          style: TextStyle(fontSize: 16, color: Colour.fEE4452),
        ),
        style: ButtonStyle(
          //设置按钮的大小
          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
          //背景颜色

          backgroundColor: MaterialStateProperty.resolveWith((states) {
            //设置按下时的背景颜色
            if (states.contains(MaterialState.pressed)) {
              return !context.isBrightness
                  ? Colour.f1A1A1A.withAlpha(400)
                  : Colour.fffffff.withAlpha(400);
            }
            //默认不使用背景颜色
            return !context.isBrightness ? Colour.f1A1A1A : Colour.fffffff;
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ),
    );
  }

  void logout(UserModel model) async {
    model.clearUser();
  }

  void switchDarkMode(BuildContext context, int mode) {
    // if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
    //   showToast("检测到系统为暗黑模式,已为你自动切换", position: ToastPosition.bottom);
    // } else {
    Provider.of<ThemeModel>(context, listen: false)
        .changeThemeMode(userMode: mode);
    // }
  }
}
