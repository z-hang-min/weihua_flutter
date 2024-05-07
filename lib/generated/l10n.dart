// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Wei Hua`
  String get appName {
    return Intl.message(
      'Wei Hua',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get actionConfirm {
    return Intl.message(
      'Confirm',
      name: 'actionConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get actionCancel {
    return Intl.message(
      'Cancel',
      name: 'actionCancel',
      desc: '',
      args: [],
    );
  }

  /// `Load Failed`
  String get viewStateMessageError {
    return Intl.message(
      'Load Failed',
      name: 'viewStateMessageError',
      desc: '',
      args: [],
    );
  }

  /// `Load Failed,Check network `
  String get viewStateMessageNetworkError {
    return Intl.message(
      'Load Failed,Check network ',
      name: 'viewStateMessageNetworkError',
      desc: '',
      args: [],
    );
  }

  /// `Nothing Found`
  String get viewStateMessageEmpty {
    return Intl.message(
      'Nothing Found',
      name: 'viewStateMessageEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Not sign in yet`
  String get viewStateMessageUnAuth {
    return Intl.message(
      'Not sign in yet',
      name: 'viewStateMessageUnAuth',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get viewStateButtonRefresh {
    return Intl.message(
      'Refresh',
      name: 'viewStateButtonRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get viewStateButtonRetry {
    return Intl.message(
      'Retry',
      name: 'viewStateButtonRetry',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get viewStateButtonLogin {
    return Intl.message(
      'Sign In',
      name: 'viewStateButtonLogin',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get splashSkip {
    return Intl.message(
      'Skip',
      name: 'splashSkip',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get tabCall {
    return Intl.message(
      'Call',
      name: 'tabCall',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get tabContact {
    return Intl.message(
      'Contact',
      name: 'tabContact',
      desc: '',
      args: [],
    );
  }

  /// `find`
  String get tabWorkbench {
    return Intl.message(
      'find',
      name: 'tabWorkbench',
      desc: '',
      args: [],
    );
  }

  /// `Me`
  String get tabMe {
    return Intl.message(
      'Me',
      name: 'tabMe',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get settingLanguage {
    return Intl.message(
      'Language',
      name: 'settingLanguage',
      desc: '',
      args: [],
    );
  }

  /// `System Font`
  String get settingFont {
    return Intl.message(
      'System Font',
      name: 'settingFont',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get logout {
    return Intl.message(
      'Sign Out',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message(
      'Dark Mode',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `FeedBack`
  String get feedback {
    return Intl.message(
      'FeedBack',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Can't find mail app,please github issues`
  String get githubIssue {
    return Intl.message(
      'Can\'t find mail app,please github issues',
      name: 'githubIssue',
      desc: '',
      args: [],
    );
  }

  /// `Auto`
  String get autoBySystem {
    return Intl.message(
      'Auto',
      name: 'autoBySystem',
      desc: '',
      args: [],
    );
  }

  /// `ZCOOL KuaiLe`
  String get fontKuaiLe {
    return Intl.message(
      'ZCOOL KuaiLe',
      name: 'fontKuaiLe',
      desc: '',
      args: [],
    );
  }

  /// `not empty`
  String get fieldNotNull {
    return Intl.message(
      'not empty',
      name: 'fieldNotNull',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get userName {
    return Intl.message(
      'Username',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get rePassword {
    return Intl.message(
      'Confirm Password',
      name: 'rePassword',
      desc: '',
      args: [],
    );
  }

  /// `The two passwords differ`
  String get twoPwdDifferent {
    return Intl.message(
      'The two passwords differ',
      name: 'twoPwdDifferent',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get toSignIn {
    return Intl.message(
      'Sign In',
      name: 'toSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `No Account ? `
  String get noAccount {
    return Intl.message(
      'No Account ? ',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `Hot`
  String get searchHot {
    return Intl.message(
      'Hot',
      name: 'searchHot',
      desc: '',
      args: [],
    );
  }

  /// `Shake`
  String get searchShake {
    return Intl.message(
      'Shake',
      name: 'searchShake',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get searchHistory {
    return Intl.message(
      'History',
      name: 'searchHistory',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Wechat`
  String get wechatAccount {
    return Intl.message(
      'Wechat',
      name: 'wechatAccount',
      desc: '',
      args: [],
    );
  }

  /// `Rate`
  String get rate {
    return Intl.message(
      'Rate',
      name: 'rate',
      desc: '',
      args: [],
    );
  }

  /// `Go to Sign In`
  String get needLogin {
    return Intl.message(
      'Go to Sign In',
      name: 'needLogin',
      desc: '',
      args: [],
    );
  }

  /// `Load failed,retry later`
  String get loadFailed {
    return Intl.message(
      'Load failed,retry later',
      name: 'loadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Open Browser`
  String get openBrowser {
    return Intl.message(
      'Open Browser',
      name: 'openBrowser',
      desc: '',
      args: [],
    );
  }

  /// `Check Update`
  String get appUpdateCheckUpdate {
    return Intl.message(
      'Check Update',
      name: 'appUpdateCheckUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Check Update`
  String get appUpdateCheckNew {
    return Intl.message(
      'Check Update',
      name: 'appUpdateCheckNew',
      desc: '',
      args: [],
    );
  }

  /// `立即升级`
  String get appUpdateActionUpdate {
    return Intl.message(
      '立即升级',
      name: 'appUpdateActionUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Least version now `
  String get appUpdateLeastVersion {
    return Intl.message(
      'Least version now ',
      name: 'appUpdateLeastVersion',
      desc: '',
      args: [],
    );
  }

  /// `Downloading...`
  String get appUpdateDownloading {
    return Intl.message(
      'Downloading...',
      name: 'appUpdateDownloading',
      desc: '',
      args: [],
    );
  }

  /// `Download failed`
  String get appUpdateDownloadFailed {
    return Intl.message(
      'Download failed',
      name: 'appUpdateDownloadFailed',
      desc: '',
      args: [],
    );
  }

  /// `It has been detected that it has been downloaded, whether it is installed?`
  String get appUpdateReDownloadContent {
    return Intl.message(
      'It has been detected that it has been downloaded, whether it is installed?',
      name: 'appUpdateReDownloadContent',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get appUpdateActionDownloadAgain {
    return Intl.message(
      'Download',
      name: 'appUpdateActionDownloadAgain',
      desc: '',
      args: [],
    );
  }

  /// `Install`
  String get appUpdateActionInstallApk {
    return Intl.message(
      'Install',
      name: 'appUpdateActionInstallApk',
      desc: '',
      args: [],
    );
  }

  /// `Version Update`
  String get appUpdateUpdate {
    return Intl.message(
      'Version Update',
      name: 'appUpdateUpdate',
      desc: '',
      args: [],
    );
  }

  /// `New version {version}`
  String appUpdateFoundNewVersion(Object version) {
    return Intl.message(
      'New version $version',
      name: 'appUpdateFoundNewVersion',
      desc: '',
      args: [version],
    );
  }

  /// `Download canceled`
  String get appUpdateDownloadCanceled {
    return Intl.message(
      'Download canceled',
      name: 'appUpdateDownloadCanceled',
      desc: '',
      args: [],
    );
  }

  /// `Press back again, cancel download`
  String get appUpdateDoubleBackTips {
    return Intl.message(
      'Press back again, cancel download',
      name: 'appUpdateDoubleBackTips',
      desc: '',
      args: [],
    );
  }

  /// `Account Management`
  String get accountManagement {
    return Intl.message(
      'Account Management',
      name: 'accountManagement',
      desc: '',
      args: [],
    );
  }

  /// `Answer Mode`
  String get answerMode {
    return Intl.message(
      'Answer Mode',
      name: 'answerMode',
      desc: '',
      args: [],
    );
  }

  /// `No Truble`
  String get notrubleset {
    return Intl.message(
      'No Truble',
      name: 'notrubleset',
      desc: '',
      args: [],
    );
  }

  /// `Black  List`
  String get blacklistset {
    return Intl.message(
      'Black  List',
      name: 'blacklistset',
      desc: '',
      args: [],
    );
  }

  /// `Log Off`
  String get logoff {
    return Intl.message(
      'Log Off',
      name: 'logoff',
      desc: '',
      args: [],
    );
  }

  /// `Tobuy Newnumber`
  String get tobuynewnumber {
    return Intl.message(
      'Tobuy Newnumber',
      name: 'tobuynewnumber',
      desc: '',
      args: [],
    );
  }

  /// `my number`
  String get mynumber {
    return Intl.message(
      'my number',
      name: 'mynumber',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `RingTongAndVibrator`
  String get ringAndVibrator {
    return Intl.message(
      'RingTongAndVibrator',
      name: 'ringAndVibrator',
      desc: '',
      args: [],
    );
  }

  /// `拨号按键音`
  String get ringtone {
    return Intl.message(
      '拨号按键音',
      name: 'ringtone',
      desc: '',
      args: [],
    );
  }

  /// `拨号按键震动`
  String get ringVibrator {
    return Intl.message(
      '拨号按键震动',
      name: 'ringVibrator',
      desc: '',
      args: [],
    );
  }

  /// `请输入验证码`
  String get login_tips_input_vctext {
    return Intl.message(
      '请输入验证码',
      name: 'login_tips_input_vctext',
      desc: '',
      args: [],
    );
  }

  /// `请输入正确的手机号`
  String get login_tips_input_phone {
    return Intl.message(
      '请输入正确的手机号',
      name: 'login_tips_input_phone',
      desc: '',
      args: [],
    );
  }

  /// `《用户协议》`
  String get user_agreement {
    return Intl.message(
      '《用户协议》',
      name: 'user_agreement',
      desc: '',
      args: [],
    );
  }

  /// `《隐私政策》`
  String get privacy_agreement {
    return Intl.message(
      '《隐私政策》',
      name: 'privacy_agreement',
      desc: '',
      args: [],
    );
  }

  /// `同意`
  String get agree {
    return Intl.message(
      '同意',
      name: 'agree',
      desc: '',
      args: [],
    );
  }

  /// `收不到? 试试`
  String get login_audio_code_subtitle {
    return Intl.message(
      '收不到? 试试',
      name: 'login_audio_code_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `语音验证码`
  String get login_audio_code {
    return Intl.message(
      '语音验证码',
      name: 'login_audio_code',
      desc: '',
      args: [],
    );
  }

  /// `请注意接95013***的来电`
  String get login_audio_code_tip {
    return Intl.message(
      '请注意接95013***的来电',
      name: 'login_audio_code_tip',
      desc: '',
      args: [],
    );
  }

  /// `请同意用户协议和隐私政策`
  String get login_agree_tip {
    return Intl.message(
      '请同意用户协议和隐私政策',
      name: 'login_agree_tip',
      desc: '',
      args: [],
    );
  }

  /// `请输入手机号`
  String get login_hint_input_phone {
    return Intl.message(
      '请输入手机号',
      name: 'login_hint_input_phone',
      desc: '',
      args: [],
    );
  }

  /// `This feature is in development。。。`
  String get tips_developing {
    return Intl.message(
      'This feature is in development。。。',
      name: 'tips_developing',
      desc: '',
      args: [],
    );
  }

  /// `最近通话`
  String get call_recent {
    return Intl.message(
      '最近通话',
      name: 'call_recent',
      desc: '',
      args: [],
    );
  }

  /// `天舟通信 版权所有`
  String get about_copyright_txt {
    return Intl.message(
      '天舟通信 版权所有',
      name: 'about_copyright_txt',
      desc: '',
      args: [],
    );
  }

  /// `95号`
  String get me_page_95num {
    return Intl.message(
      '95号',
      name: 'me_page_95num',
      desc: '',
      args: [],
    );
  }

  /// `手机号`
  String get me_page_phone {
    return Intl.message(
      '手机号',
      name: 'me_page_phone',
      desc: '',
      args: [],
    );
  }

  /// `按键音/深色模式/退出`
  String get answerMode_tips {
    return Intl.message(
      '按键音/深色模式/退出',
      name: 'answerMode_tips',
      desc: '',
      args: [],
    );
  }

  /// `版本信息/App升级`
  String get about_tips {
    return Intl.message(
      '版本信息/App升级',
      name: 'about_tips',
      desc: '',
      args: [],
    );
  }

  /// `新版抢新体验`
  String get checkUpdate_title {
    return Intl.message(
      '新版抢新体验',
      name: 'checkUpdate_title',
      desc: '',
      args: [],
    );
  }

  /// `系统主题`
  String get setting_theme_mode {
    return Intl.message(
      '系统主题',
      name: 'setting_theme_mode',
      desc: '',
      args: [],
    );
  }

  /// `跟随系统`
  String get setting_theme_mode1 {
    return Intl.message(
      '跟随系统',
      name: 'setting_theme_mode1',
      desc: '',
      args: [],
    );
  }

  /// `深色模式`
  String get setting_theme_mode2 {
    return Intl.message(
      '深色模式',
      name: 'setting_theme_mode2',
      desc: '',
      args: [],
    );
  }

  /// `浅色模式`
  String get setting_theme_mode3 {
    return Intl.message(
      '浅色模式',
      name: 'setting_theme_mode3',
      desc: '',
      args: [],
    );
  }

  /// `您确认要退出登录吗？`
  String get logout_tip {
    return Intl.message(
      '您确认要退出登录吗？',
      name: 'logout_tip',
      desc: '',
      args: [],
    );
  }

  /// `App接听`
  String get answer_mode1 {
    return Intl.message(
      'App接听',
      name: 'answer_mode1',
      desc: '',
      args: [],
    );
  }

  /// `绑定手机号接听`
  String get answer_mode2 {
    return Intl.message(
      '绑定手机号接听',
      name: 'answer_mode2',
      desc: '',
      args: [],
    );
  }

  /// `如想更改绑定手机号，请联系管理员`
  String get answer_mode2_tip {
    return Intl.message(
      '如想更改绑定手机号，请联系管理员',
      name: 'answer_mode2_tip',
      desc: '',
      args: [],
    );
  }

  /// `立即开启`
  String get open_permission {
    return Intl.message(
      '立即开启',
      name: 'open_permission',
      desc: '',
      args: [],
    );
  }

  /// `需要获取通讯录权限进行通话,是否允许此App获取通讯录权限？`
  String get open_permission_contact {
    return Intl.message(
      '需要获取通讯录权限进行通话,是否允许此App获取通讯录权限？',
      name: 'open_permission_contact',
      desc: '',
      args: [],
    );
  }

  /// `无录音权限，请开启录音权限`
  String get open_permission_speech {
    return Intl.message(
      '无录音权限，请开启录音权限',
      name: 'open_permission_speech',
      desc: '',
      args: [],
    );
  }

  /// `请开启拨打电话权限`
  String get open_permission_call {
    return Intl.message(
      '请开启拨打电话权限',
      name: 'open_permission_call',
      desc: '',
      args: [],
    );
  }

  /// `无通知权限，可能会错过来电哦`
  String get open_permission_notify {
    return Intl.message(
      '无通知权限，可能会错过来电哦',
      name: 'open_permission_notify',
      desc: '',
      args: [],
    );
  }

  /// `当前网络不可用，请检查你的网络设置`
  String get net_invalid_tip {
    return Intl.message(
      '当前网络不可用，请检查你的网络设置',
      name: 'net_invalid_tip',
      desc: '',
      args: [],
    );
  }

  /// `购买新号码`
  String get btn_buy_num {
    return Intl.message(
      '购买新号码',
      name: 'btn_buy_num',
      desc: '',
      args: [],
    );
  }

  /// `购买号码`
  String get page_buy_num {
    return Intl.message(
      '购买号码',
      name: 'page_buy_num',
      desc: '',
      args: [],
    );
  }

  /// `购买`
  String get btn_buy {
    return Intl.message(
      '购买',
      name: 'btn_buy',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
