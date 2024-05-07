import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/mynum_calloutnum_model.dart';
import 'package:weihua_flutter/ui/widget/custom_alert_dialog.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class MyPersonNumberSettingPage extends StatefulWidget {
  final Map numberInfo;

  MyPersonNumberSettingPage(this.numberInfo);

  @override
  _MyPersonNumberSettingPageState createState() =>
      _MyPersonNumberSettingPageState();
}

class _MyPersonNumberSettingPageState extends State<MyPersonNumberSettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        padding: EdgeInsets.only(top: 10.h),
        child: Column(
          children: [
            _nodistrubleWidget(context),
            Divider(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colour.cFFEEEEEE
                  : Colour.fffffff.withAlpha(10),
              height: 0,
              indent: 45.w,
              endIndent: 15.w,
            ),
            _blacklistwidget(context),
            Expanded(flex: 1, child: Container()),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: InkWell(
                highlightColor: Colors.transparent,
                radius: 0,
                child: SvgPicture.asset(
                  ImageHelper.wrapAssets('icon_xufei.svg'),
                  height: 58.h,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                onTap: () {
                  Map<String, dynamic> routeParams = {
                    'businessid': "",
                    "number": widget.numberInfo['number']
                  };
                  Navigator.pushNamed(context, RouteName.pNumberRenew,
                      arguments: routeParams);
                },
              ),
            ),
            _logoffWidget(context),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _nodistrubleWidget(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Ink(
      decoration: new BoxDecoration(
        // borderRadius: BorderRadius.all(Radius.circular(6.0)),
        color: Theme.of(context).cardColor,
      ),
      child: InkWell(
        child: Container(
          height: 58.h,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(ImageHelper.wrapAssets(
                  Theme.of(context).brightness == Brightness.light
                      ? "icon_notrubleset.svg"
                      : "icon_notrubleset_dark.svg")),
              SizedBox(
                width: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).notrubleset,
                    style: subtitle1.change(context,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colour.f18
                            : Colour.fffffff.withAlpha(87)),
                  ),
                ],
              ),
              Spacer(),
              SvgPicture.asset(context.isBrightness
                  ? ImageHelper.wrapAssets("me_icon_more.svg")
                  : ImageHelper.wrapAssets("set_icon_more_dark.svg")),
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, RouteName.pNumberSetNoDisturb,
                  arguments: widget.numberInfo['number'])
              .then((value) {});
        },
      ),
    );
  }

  Widget _blacklistwidget(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Ink(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
        color: Theme.of(context).cardColor,
      ),
      child: InkWell(
        child: Container(
          height: 58.h,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(ImageHelper.wrapAssets(
                  Theme.of(context).brightness == Brightness.light
                      ? "icon_blacklistset.svg"
                      : "icon_blacklistset_dark.svg")),
              SizedBox(
                width: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).blacklistset,
                    style: subtitle1.change(context,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colour.f18
                            : Colour.fffffff.withAlpha(87)),
                  ),
                ],
              ),
              Spacer(),
              SvgPicture.asset(context.isBrightness
                  ? ImageHelper.wrapAssets("me_icon_more.svg")
                  : ImageHelper.wrapAssets("set_icon_more_dark.svg")),
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, RouteName.pNumberSetBlacklist,
                  arguments: widget.numberInfo['number'])
              .then((value) {});
        },
      ),
    );
  }

  Widget _logoffWidget(BuildContext context) {
    return Consumer<UserModel>(
        builder: (context, model, child) => Container(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
              child: TextButton(
                onPressed: () {
                  CustomAlertDialog.showAlertDialog(
                      context,
                      "注销账号",
                      StringUtils.get95WithSpace(widget.numberInfo['number']),
                      S.of(context).actionCancel,
                      S.of(context).actionConfirm,
                      260, (value) {
                    if (value == 1) {
                      // Navigator.pushReplacementNamed(context, RouteName.login);
                      logoff();
                    }
                  }, true);
                },
                child: Text(
                  S.of(context).logoff,
                  // style: subtitle1.change(context, color: Colour.fEE4452),
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colour.primaryColor
                          : Colour.FF0F88FF),
                ),
                style: ButtonStyle(
                  //设置按钮的大小
                  minimumSize:
                      MaterialStateProperty.all(Size(double.infinity, 45)),
                  //背景颜色
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    //设置按下时的背景颜色
                    if (states.contains(MaterialState.pressed)) {
                      return !context.isBrightness
                          ? Colour.f1A1A1A.withAlpha(400)
                          : Colour.FF111111;
                    }
                    //默认不使用背景颜色
                    return !context.isBrightness
                        ? Colour.f1A1A1A
                        : Colour.fffffff;
                  }),
                  side: MaterialStateProperty.all(
                      BorderSide(color: Colour.primaryColor, width: 0.5)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ));
  }

  void logoff() async {
    bool response = await MyCalloutnumMode().cancelcalloutnum(
        Provider.of<UserModel>(context, listen: false).user!.mobile.toString(),
        widget.numberInfo['number'],
        widget.numberInfo['id'].toString());
    if (response) {
      showToast('注销成功');
      Navigator.pop(context, true);
    } else {
      MyCalloutnumMode().showErrorMessage(context);
      EasyLoading.dismiss();
    }

    // model.clearUser();
    // model2.logOut();
  }
}
