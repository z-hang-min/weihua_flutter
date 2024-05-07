import 'dart:math';

import 'package:weihua_flutter/config/storage_manager.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/ui/helper/theme_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//const Color(0xFF5394FF),

/// 0xFF0F88FF    主题色
///
/// 0xFF212121    用于一级内容／正文字体／标题／名称 16 0xFF212121
///
/// 0xFF666666    用于普通的段落信息 / 副标题, 默认字体，直接使用Text 14
///
/// 0xFF999999    用于辅助次要 / 说明的文字, hint
///
/// 0xFF6B7685    用于指引用户操作的引导性文字
///
/// 0xFF8AA0C2    用于离线、不可用背景色
///
/// 0xFFF4F5F8    用于界面背景色
///
/// 0xFFF7F8F9    用于控件填充背景色（搜索框、文字背景框）
///
/// 0xFFEEEEEE    用于分割线
///
/// 0xFFE2E2E2    用于边框线
///
class Colour {
  Colour._();

  /// 主题色
  static const Color primaryColor = Color(0xFF0F88FF);

  /// 用于一级内容／正文字体／标题／名称 16 0xFF212121
  static const Color titleColor = cFF212121;

  /// 用于一级内容／正文字体／标题／名称 16 0xFF212121
  static const Color body1Color = cFF212121;

  /// 用于普通的段落信息 / 副标题 14 0xFF666666
  static const Color subtitle2Color = Color(0xFF666666);

  /// 默认字体，直接使用Text，未设置属性 14 0xFF666666
  static const Color body2Color = cFF666666;

  /// 用于辅助次要 / 说明的文字 0xFF999999
  static const Color hintTextColor = cFF999999;

  /// 用于离线、不可用背景色 0xFF8AA0C2
  static const Color disableColor = Color(0xFF8AA0C2);

  /// 用于界面背景色 0xFFF4F5F8
  static const Color backgroundColor = Color(0xFFF4F5F8);
  static const Color backgroundColor2 = Color(0xFFffffff);

  /// 用于指引用户操作的引导性文字
  static const Color guidColor = Color(0xFF6B7685);

  /// 用于控件填充背景色（搜索框、文字背景框） 0xFFF7F8F9
  static const Color widgetBackColor = cFFF7F8F9;

  /// 用于分割线 0xFFEEEEEE
  static const Color dividerColor = cFFEEEEEE;

  /// 用于边框线 0xFFE2E2E2
  static const Color bordColor = cFFE2E2E2;

  static const Color cFF666666 = Color(0xFF666666);
  static const Color cFF212121 = Color(0xFF212121);
  static const Color cFF999999 = Color(0xFF999999);

  static const Color f18 = Color(0xFF181818);
  static const Color f0F8FFB = Color(0xFF0F8FFB);
  static const Color ffff4f5f = Color(0xfff4f5f8);
  static const Color fEE4452 = Color(0xffEE4452);
  static const Color f99EE4452 = Color(0x99EE4452);
  static const Color fffffff = Color(0xffffffff);
  static const Color f333333 = Color(0xff333333);
  static const Color f1E1E1E = Color(0xff1E1E1E);
  static const Color f2C2C2C = Color(0xff2C2C2C);
  static const Color f1A1A1A = Color(0xff1A1A1A);
  static const Color f0x1AFFFFFF = Color(0x1AFFFFFF);
  static const Color f66ffffff = Color(0x66ffffff);
  static const Color f21ffffff = Color(0xD8ffffff);
  static const Color f85ffffff = Color(0x21ffffff);
  static const Color fA5ffffff = Color(0xa5ffffff);
  static const Color fDEffffff = Color(0xDEffffff); //87%不透明
  static const Color f99ffffff = Color(0x99ffffff); //60%不透明
  static const Color f99E4E4E4 = Color(0x99E4E4E4); //50%不透明
  static const Color f80333333 = Color(0x80333333); //80%不透明
  static const Color f61ffffff = Color(0x61ffffff); //38%不透明
  static const Color f2E313C = Color(0xff2E313C);
  static const Color f3183F7 = Color(0xff3183F7);
  static const Color f111111 = Color(0xff111111);
  static const Color f99fff = Color(0x59ffffff);
  static const Color cffE6E6E6 = Color(0xffE6E6E6);
  static const Color c1A000000 = Color(0x1A000000);
  static const Color cFFF7F8F9 = Color(0xFFF7F8F9);
  static const Color c1AFFFFFF = Color(0x1AFFFFFF); //10%
  static const Color cFF1E1E1E = Color(0xFF1E1E1E);
  static const Color cFF2c2c2c = Color(0xFF2c2c2c);
  static const Color cFFEEEEEE = Color(0xFFEEEEEE);
  static const Color cFFE2E2E2 = Color(0xFFE2E2E2);
  static const Color c0x29F75854 = Color(0x29F75854);
  static const Color c0xFF7C2B2A = Color(0xFF7C2B2A);
  static const Color c0xFFFFEDEA = Color(0xFFFFEDEA);
  static const Color c0xFFFE3B30 = Color(0xFFFE3B30);
  static const Color c0xFFF7F8FD = Color(0xFFF7F8FD);
  static const Color c0x0F88FF = Color(0xFF0F88FF);
  static const Color c0xCCCCCC = Color(0xFFCCCCCC);
  static const Color c0xF72626 = Color(0xFFF72626);
  static const Color c0xF25643 = Color(0xFFF25643);
  static const Color c0xFF0085FF = Color(0xFF0085FF);
  static const Color c0xFF6B7686 = Color(0xFF6B7686);
  static const Color c0xFF181818 = Color(0xFF181818);

  static const Color FFE3B30 = Color(0xFFFE3B30);
  static const Color FFFFEDEA = Color(0xFFFFEDEA);
  static const Color CCFFFFFF = Color(0xCCFFFFFF);
  static const Color cFF3A99FA = Color(0xFF3A99FA);
  static const Color FFFFFF80 = Color(0xFFFFFF80);
  static const Color FFFFF9ED = Color(0xFFFFF9ED);
  static const Color FFFE9F00 = Color(0xFFFE9F00);
  static const Color FFFF8786 = Color(0xFFFF8786);
  static const Color FFFF4F4E = Color(0xFFFF4F4E);
  static const Color FF6B7685 = Color(0xFF6B7685);
  static const Color FFFFA917 = Color(0xFFFFA917);
  static const Color FFFF8D12 = Color(0xFFFF8D12);
  static const Color FFFF8E12 = Color(0xFFFF8E12);
  static const Color F66FF8E12 = Color(0x66FF8E12);
  static const Color FFDDDDDD = Color(0xFFDDDDDD);
  static const Color FFFF9F8D = Color(0xFFFF9F8D);
  static const Color FFFF504E = Color(0xFFFF504E);
  static const Color FFFFB21B = Color(0xFFFFB21B);
  static const Color FFFF8F01 = Color(0xFFFF8F01);
  static const Color FFF25845 = Color(0xFFF25845);
  static const Color FF19BA6C = Color(0xFF19BA6C);
  static const Color FF239BFF = Color(0xFF239BFF);
  static const Color FF333333 = Color(0xFF333333);
  static const Color FF167AFF = Color(0xFF167AFF);
  static const Color FFF75854 = Color(0xFFF75854);
  static const Color F19F75854 = Color(0x19F75854);
  static const Color FF6C7588 = Color(0xFF6C7588);
  static const Color FFF25643 = Color(0xFFF25643);
  static const Color FFE9F8F1 = Color(0xFFE9F8F1);
  static const Color FFEFF6FF = Color(0xFFEFF6FF);
  static const Color FF0F88FF = Color(0xFF0F88FF);
  static const Color FFE8E8E8 = Color(0xFFE8E8E8);
  static const Color FFFCAE0C = Color(0xFFFCAE0C);
  static const Color FFFB9305 = Color(0xFFFB9305);
  static const Color FF111111 = Color(0xFF111111);
  static const Color FF565656 = Color(0xFF565656);
  static const Color FFFEE7E5 = Color(0xFFFEE7E5);
  static const Color FCAD0C1A = Color(0xFCAD0C1A);
  static const Color FFFCAD0C = Color(0xFFFCAD0C);
  static const Color FFF9F9F9 = Color(0xFFF9F9F9);
  static const Color FF191919 = Color(0xFF191919);
  static const Color FF1A1A1A = Color(0xFFF1A1A1A);
  static const Color FFF9FBFC = Color(0xFFF9FBFC);
  static const Color FF999999 = Color(0xFF999999);
  static const Color FF0086F5 = Color(0xFF0086F5);
  static const Color FF8AA0C2 = Color(0xFF8AA0C2);
  static const Color FFD8D8D8 = Color(0xFFD8D8D8);
  static const Color FFAFB6BC = Color(0xFFAFB6BC);

  static Color getContactColor(int index) {
    Color color = cFF3A99FA;

    if (index % 5 == 0) {
      color = cFF3A99FA;
    } else if (index % 5 == 1) {
      color = Color.fromRGBO(79, 75, 241, 1.0);
    } else if (index % 5 == 2) {
      color = Color.fromRGBO(135, 191, 255, 1.0);
    } else if (index % 5 == 3) {
      color = Color.fromRGBO(86, 73, 190, 1.0);
    } else if (index % 5 == 4) {
      color = Color.fromRGBO(68, 130, 255, 1.0);
    }
    return color;
  }
}

extension BuildContextExtension on BuildContext {
  bool get isBrightness => Theme.of(this).brightness == Brightness.light;

  Color color(Color light, Color night) => isBrightness ? light : night;

  String imageFile(String light, String night) {
    return isBrightness ? light : night;
  }
}

/// 扩展函数
extension TextStyleExtension on TextStyle {
  TextStyle change(BuildContext context,
      {Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      double? height}) {
    ThemeData themeData = Theme.of(context);
    bool isDark = themeData.brightness == Brightness.dark;
    Color? _color = this.color;
    double? _fontSize = fontSize ?? this.fontSize;
    FontWeight? _fontWeight = fontWeight ?? this.fontWeight;
    double? _height = height ?? this.height;

    if (!isDark) {
      _color = color;
    }
    return copyWith(
        color: _color,
        fontSize: _fontSize,
        fontWeight: _fontWeight,
        height: _height);
  }
}

class ThemeModel with ChangeNotifier {
  static const kThemeColorIndex = 'kThemeColorIndex';
  static const kThemeUserDarkMode = 'kThemeUserDarkMode';
  static const kThemeUserMode = 'kThemeUserMode';
  static const kFontIndex = 'kFontIndex';

  static const fontValueList = ['system', 'kuaile'];

  static int _primaryColorValue = Colour.primaryColor.value;

  MaterialColor _color = MaterialColor(
    _primaryColorValue,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(_primaryColorValue),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );

  /// 用户选择的明暗模式
  bool _userDarkMode = false;
  int _userThemMode = 0;
  int get userThemMode => _userThemMode;

  /// 当前主题颜色
  late MaterialColor _themeColor;

  /// 当前字体索引
  int _fontIndex = 0;

  ThemeModel() {
    /// 用户选择的明暗模式
    _userDarkMode =
        StorageManager.sharedPreferences!.getBool(kThemeUserDarkMode) ?? false;
    _userThemMode =
        StorageManager.sharedPreferences!.getInt(kThemeUserMode) ?? 2;

    /// 获取主题色
    // _themeColor = Colors.primaries[
    //     StorageManager.sharedPreferences!.getInt(kThemeColorIndex) ?? 5];
    _themeColor = _color;

    /// 获取字体
    _fontIndex = StorageManager.sharedPreferences!.getInt(kFontIndex) ?? 0;
  }

  int get fontIndex => _fontIndex;

  /// 切换指定色彩
  ///
  /// 没有传[brightness]就不改变brightness,color同理
  void switchTheme2({bool? userDarkMode, MaterialColor? color}) {
    _userDarkMode = userDarkMode ?? _userDarkMode;
    _themeColor = color ?? _themeColor;
    notifyListeners();
    saveTheme2Storage(_userDarkMode, _themeColor);
  }

  void switchTheme({bool? userDarkMode, MaterialColor? color}) {
    // _userDarkMode = userDarkMode ?? _userDarkMode;
    _userDarkMode = userDarkMode ?? !_userDarkMode;
    _themeColor = color ?? _themeColor;
    notifyListeners();
    saveTheme2Storage(_userDarkMode, _themeColor);
  }

  ///主题模式 0表示浅色，1表示深色，2表示跟随系统
  void changeThemeMode({int userMode = 0, MaterialColor? color}) {
    _userThemMode = userMode;
    _themeColor = color ?? _themeColor;
    notifyListeners();
    saveThemeMode2Storage(userMode, _themeColor);
  }

  /// 随机一个主题色彩
  ///
  /// 可以指定明暗模式,不指定则保持不变
  void switchRandomTheme({Brightness? brightness}) {
    int colorIndex = Random().nextInt(Colors.primaries.length - 1);
    switchTheme(
      userDarkMode: Random().nextBool(),
      color: Colors.primaries[colorIndex],
    );
  }

  /// 切换字体
  switchFont(int index) {
    _fontIndex = index;
    switchTheme();
    saveFontIndex(index);
  }

  /// 根据主题 明暗 和 颜色 生成对应的主题
  /// [dark]系统的Dark Mode
  themeData2({bool platformDarkMode = false}) {
    var isDark = platformDarkMode || _userDarkMode || _userThemMode == 1;
    Brightness brightness = isDark ? Brightness.dark : Brightness.light;

    var themeColor = _themeColor;
    var accentColor = isDark ? themeColor[700] : _themeColor;

    final ThemeData theme = ThemeData();

    TextSelectionThemeData textSelectionThemeData = TextSelectionThemeData(
        cursorColor: accentColor,
        selectionColor: accentColor?.withAlpha(60),
        selectionHandleColor: accentColor?.withAlpha(60));

    var themeData = ThemeData(
        brightness: brightness,
        primarySwatch: themeColor,
        colorScheme: theme.colorScheme.copyWith(secondary: accentColor),
        fontFamily: fontValueList[fontIndex]);

    themeData = themeData.copyWith(
      brightness: brightness,
      colorScheme: theme.colorScheme.copyWith(secondary: accentColor),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: themeColor,
        brightness: brightness,
      ),

      appBarTheme: themeData.appBarTheme.copyWith(elevation: 0),
      splashColor: themeColor.withAlpha(50),
      hintColor: themeData.hintColor.withAlpha(90),
      errorColor: Colors.red,
      textTheme: themeData.textTheme,
      textSelectionTheme: textSelectionThemeData,
      toggleableActiveColor: accentColor,
      chipTheme: themeData.chipTheme.copyWith(
        pressElevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        labelStyle: themeData.textTheme.caption,
        backgroundColor: themeData.chipTheme.backgroundColor?.withOpacity(0.1),
      ),
//          textTheme: CupertinoTextThemeData(brightness: Brightness.light)
      inputDecorationTheme: ThemeHelper.inputDecorationTheme(themeData),
    );
    return themeData;
  }

  themeData({bool platformDarkMode = false}) {
    var isDark = platformDarkMode || _userDarkMode || _userThemMode == 1;
    Brightness brightness = isDark ? Brightness.dark : Brightness.light;

    var themeColor = _themeColor;
    var accentColor = isDark ? themeColor[700] : _themeColor;

    final ThemeData theme = ThemeData();

    var themeData = ThemeData(
        brightness: brightness,
        primarySwatch: themeColor,
        colorScheme: theme.colorScheme
            .copyWith(secondary: accentColor, brightness: brightness),
        dividerColor: isDark ? Colour.f0x1AFFFFFF : Colour.dividerColor,
        hintColor: Colour.hintTextColor,
        cardColor: isDark ? Colour.f1A1A1A : Colour.backgroundColor2,
        typography: Typography.material2018(),
        fontFamily: fontValueList[fontIndex]);

    TextTheme textTheme = themeData.textTheme.copyWith(
      // appbar title
      headline6: themeData.textTheme.headline6?.copyWith(
          color: isDark ? Colour.fDEffffff : Colour.f18,
          fontSize: 18,
          fontWeight: FontWeight.bold),
      subtitle1: themeData.textTheme.subtitle1?.copyWith(
        /// 解决中文hint不居中的问题 https://github.com/flutter/flutter/issues/40248
        textBaseline: TextBaseline.alphabetic,
        color: isDark ? Colour.fDEffffff : Colour.titleColor,
        fontSize: 16,
      ),
      subtitle2: themeData.textTheme.subtitle2?.copyWith(
          color: isDark ? Colour.f61ffffff : Colour.subtitle2Color,
          fontSize: 14,
          fontWeight: FontWeight.normal),
      bodyText1: themeData.textTheme.bodyText1?.copyWith(
        color:
            isDark ? themeData.textTheme.bodyText1?.color : Colour.body1Color,
        fontSize: 16,
      ),
      bodyText2: themeData.textTheme.bodyText2?.copyWith(
        color:
            isDark ? themeData.textTheme.bodyText2?.color : Colour.body2Color,
        fontSize: 14,
      ),
      button: themeData.textTheme.button?.copyWith(
        color: isDark ? themeData.textTheme.button?.color : Colors.white,
        fontSize: 16,
      ),
      caption: themeData.textTheme.caption?.copyWith(
        color: isDark ? Colour.f99ffffff : Colour.body2Color,
        fontSize: 12,
      ),
    );

    TextSelectionThemeData textSelectionThemeData = TextSelectionThemeData(
        cursorColor: accentColor,
        selectionColor: accentColor?.withAlpha(60),
        selectionHandleColor: accentColor?.withAlpha(60));

    themeData = themeData.copyWith(
      brightness: brightness,
      colorScheme: theme.colorScheme.copyWith(secondary: accentColor),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: themeColor,
        brightness: brightness,
      ),
      // 页面背景色
      scaffoldBackgroundColor: isDark ? Colour.f111111 : Colour.backgroundColor,
      appBarTheme: themeData.appBarTheme.copyWith(
          // 设置状态栏文字颜色
          color: isDark ? Colour.f111111 : Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
              color: isDark ? Colors.white : Colour.subtitle2Color),
          toolbarTextStyle: themeData.textTheme.copyWith(headline6: textTheme.headline6).bodyText2,
          titleTextStyle: themeData.textTheme.copyWith(headline6: textTheme.headline6).headline6),
      splashColor: themeColor.withAlpha(50),
      hintColor: themeData.hintColor,
      errorColor: Colors.red,
      textTheme: textTheme,
      textSelectionTheme: textSelectionThemeData,
      toggleableActiveColor: accentColor,
      chipTheme: themeData.chipTheme.copyWith(
        pressElevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        labelStyle: themeData.textTheme.caption,
        backgroundColor: themeData.chipTheme.backgroundColor?.withOpacity(0.1),
      ),
      inputDecorationTheme: ThemeHelper.inputDecorationTheme(themeData),
      // buttonTheme: ButtonThemeData(
      //     minWidth: double.infinity,
      //     height: 45.0,
      //     shape: StadiumBorder(),
      //     buttonColor: themeData.primaryColor,
      //     disabledColor: themeData.primaryColor.withAlpha(800)),
      // textButtonTheme: TextButtonThemeData(
      //   style: ButtonStyle(
      //     //设置按钮的大小
      //     minimumSize:
      //     MaterialStateProperty.all(Size(double.infinity, 45)),
      //     //背景颜色
      //
      //     backgroundColor: MaterialStateProperty.resolveWith((states) {
      //       //设置按下时的背景颜色
      //       if (states.contains(MaterialState.pressed)) {
      //         return themeData.primaryColor.withAlpha(400);
      //       }
      //       //默认不使用背景颜色
      //       return themeData.primaryColor.withAlpha(180);
      //     }),
      //     shape: MaterialStateProperty.all(StadiumBorder()),
      //   )
      // )
    );
    return themeData;
  }

  /// 数据持久化到shared preferences
  saveTheme2Storage(bool userDarkMode, MaterialColor themeColor) async {
    var index = Colors.primaries.indexOf(themeColor);
    await Future.wait([
      StorageManager.sharedPreferences!
          .setBool(kThemeUserDarkMode, userDarkMode),
      StorageManager.sharedPreferences!.setInt(kThemeColorIndex, index)
    ]);
  }

  ///主题模式 0表示浅色，1表示深色，2表示跟随系统
  saveThemeMode2Storage(int themMode, MaterialColor themeColor) async {
    var index = Colors.primaries.indexOf(themeColor);
    await Future.wait([
      StorageManager.sharedPreferences!.setInt(kThemeUserMode, themMode),
      StorageManager.sharedPreferences!.setInt(kThemeColorIndex, index)
    ]);
  }

  /// 根据索引获取字体名称,这里牵涉到国际化
  static String fontName(index, context) {
    switch (index) {
      case 0:
        return S.of(context).autoBySystem;
      case 1:
        return S.of(context).fontKuaiLe;
      default:
        return '';
    }
  }

  /// 字体选择持久化
  static saveFontIndex(int index) async {
    await StorageManager.sharedPreferences!.setInt(kFontIndex, index);
  }
}
