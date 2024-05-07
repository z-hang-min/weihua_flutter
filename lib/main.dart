import 'package:weihua_flutter/config/storage_manager.dart';
import 'package:weihua_flutter/db/phone_area_db_utils.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/network_utils.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'config/provider_manager.dart';
import 'config/router_manger.dart';
import 'db/db_core.dart';
import 'generated/l10n.dart';
import 'view_model/locale_model.dart';
import 'view_model/theme_model.dart';

main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.init();
  await DbCore.getInstance().openDb("weihua");
  await PhoneAreaDbUtils.getInstance().openPhoneAreaDb();
  //使用flutter异常上报
  // FlutterBugly.postCatchedException(() {
  runApp(MyApp());
  // });
  // FlutterBugly.init(androidAppId: "4afd533a1f", iOSAppId: "d47af15daf");
  NetWorkUtils.initConnectivity();
  // Android状态栏透明 splash为白色,所以调整状态栏文字为黑色
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    // statusBarBrightness: Brightness.dark
    systemNavigationBarColor: Colors.black, //虚拟按键背景色
  ));

  _initFluwx();
  isLogin = false;
}

_initFluwx() async {
  await registerWxApi(
      appId: "wxffb40f0d7116bfbe",
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: "https://tianzhou.weihua.com/link/");
  var result = await isWeChatInstalled;
  Log.d("is installed $result");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(375, 812),
        builder: (context, child) => OKToast(
            child: MultiProvider(
                providers: providers,
                child: Consumer2<ThemeModel, LocaleModel>(
                    builder: (context, themeModel, localeModel, child) {
                  return RefreshConfiguration(
                    hideFooterWhenNotFull: true, //列表数据不满一页,不触发加载更多
                    child: GetMaterialApp(
                        title: '微话',
                        debugShowCheckedModeBanner: false,
                        theme: themeModel.themeData(),
                        darkTheme: themeModel.themeData(
                            platformDarkMode: (StorageManager.sharedPreferences!
                                        .getInt(ThemeModel.kThemeUserMode) ??
                                    2) ==
                                2),
                        locale: localeModel.locale,
                        localizationsDelegates: const [
                          S.delegate,
                          RefreshLocalizations.delegate, //下拉刷新
                          GlobalCupertinoLocalizations.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate
                        ],
                        supportedLocales: S.delegate.supportedLocales,
                        onGenerateRoute: MyRouter.generateRoute,
                        initialRoute: nextPage(context),
                        builder: (context, widget) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: FlutterEasyLoading(child: widget),
                          );
                        }),
                  );
                }))));
  }

  String nextPage(context) {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    bool darkMode = (Theme.of(context).colorScheme.brightness ==
            Brightness.dark) ||
        ((StorageManager.sharedPreferences!.getInt(ThemeModel.kThemeUserMode) ??
                2) ==
            1);
    if (userModel.hasUser) {
      isLogin = true;
      return RouteName.tab;
    } else {
      isLogin = false;
      SystemChrome.setSystemUIOverlayStyle(
          darkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
      return RouteName.login;
    }
  }
}
