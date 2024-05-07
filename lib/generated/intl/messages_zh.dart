// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static String m0(version) => "发现新版本${version},是否更新?";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("关于"),
        "about_copyright_txt":
            MessageLookupByLibrary.simpleMessage("天舟通信 版权所有"),
        "about_tips": MessageLookupByLibrary.simpleMessage("版本信息/App升级"),
        "accountManagement": MessageLookupByLibrary.simpleMessage("账号管理"),
        "actionCancel": MessageLookupByLibrary.simpleMessage("取消"),
        "actionConfirm": MessageLookupByLibrary.simpleMessage("确认"),
        "agree": MessageLookupByLibrary.simpleMessage("同意"),
        "answerMode": MessageLookupByLibrary.simpleMessage("接听方式"),
        "answerMode_tips": MessageLookupByLibrary.simpleMessage("按键音/深色模式/退出"),
        "answer_mode1": MessageLookupByLibrary.simpleMessage("App接听"),
        "answer_mode2": MessageLookupByLibrary.simpleMessage("绑定手机号接听"),
        "answer_mode2_tip":
            MessageLookupByLibrary.simpleMessage("如想更改绑定手机号，请联系管理员"),
        "appName": MessageLookupByLibrary.simpleMessage("微话"),
        "appUpdateActionDownloadAgain":
            MessageLookupByLibrary.simpleMessage("重新下载"),
        "appUpdateActionInstallApk":
            MessageLookupByLibrary.simpleMessage("直接安装"),
        "appUpdateActionUpdate": MessageLookupByLibrary.simpleMessage("立即升级"),
        "appUpdateCheckNew": MessageLookupByLibrary.simpleMessage("检查新版本"),
        "appUpdateCheckUpdate": MessageLookupByLibrary.simpleMessage("检查更新"),
        "appUpdateDoubleBackTips":
            MessageLookupByLibrary.simpleMessage("再次点击返回键,取消下载"),
        "appUpdateDownloadCanceled":
            MessageLookupByLibrary.simpleMessage("下载已取消"),
        "appUpdateDownloadFailed": MessageLookupByLibrary.simpleMessage("下载失败"),
        "appUpdateDownloading":
            MessageLookupByLibrary.simpleMessage("下载中,请稍后..."),
        "appUpdateFoundNewVersion": m0,
        "appUpdateLeastVersion": MessageLookupByLibrary.simpleMessage("已是最新版本"),
        "appUpdateReDownloadContent":
            MessageLookupByLibrary.simpleMessage("检测到本地已下载过该版本,是否直接安装?"),
        "appUpdateUpdate": MessageLookupByLibrary.simpleMessage("版本更新"),
        "autoBySystem": MessageLookupByLibrary.simpleMessage("跟随系统"),
        "blacklistset": MessageLookupByLibrary.simpleMessage("黑名单设置"),
        "btn_buy": MessageLookupByLibrary.simpleMessage("购买"),
        "btn_buy_num": MessageLookupByLibrary.simpleMessage("购买新号码"),
        "call_recent": MessageLookupByLibrary.simpleMessage("最近通话"),
        "checkUpdate_title": MessageLookupByLibrary.simpleMessage("新版抢新体验"),
        "clear": MessageLookupByLibrary.simpleMessage("清空"),
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "darkMode": MessageLookupByLibrary.simpleMessage("黑夜模式"),
        "feedback": MessageLookupByLibrary.simpleMessage("意见反馈"),
        "fieldNotNull": MessageLookupByLibrary.simpleMessage("不能为空"),
        "fontKuaiLe": MessageLookupByLibrary.simpleMessage("快乐字体"),
        "githubIssue":
            MessageLookupByLibrary.simpleMessage("未找到邮件客户端,请前往github,提issue"),
        "loadFailed": MessageLookupByLibrary.simpleMessage("加载失败,请稍后重试"),
        "login_agree_tip": MessageLookupByLibrary.simpleMessage("请同意用户协议和隐私政策"),
        "login_audio_code": MessageLookupByLibrary.simpleMessage("语音验证码"),
        "login_audio_code_subtitle":
            MessageLookupByLibrary.simpleMessage("收不到? 试试"),
        "login_audio_code_tip":
            MessageLookupByLibrary.simpleMessage("请注意接95013***的来电"),
        "login_hint_input_phone":
            MessageLookupByLibrary.simpleMessage("请输入手机号"),
        "login_tips_input_phone":
            MessageLookupByLibrary.simpleMessage("请输入正确的手机号"),
        "login_tips_input_vctext":
            MessageLookupByLibrary.simpleMessage("请输入验证码"),
        "logoff": MessageLookupByLibrary.simpleMessage("注销账号"),
        "logout": MessageLookupByLibrary.simpleMessage("退出登录"),
        "logout_tip": MessageLookupByLibrary.simpleMessage("您确认要退出登录吗？"),
        "me_page_95num": MessageLookupByLibrary.simpleMessage("95号"),
        "me_page_phone": MessageLookupByLibrary.simpleMessage("手机号"),
        "mynumber": MessageLookupByLibrary.simpleMessage("我的个人号"),
        "needLogin": MessageLookupByLibrary.simpleMessage("请先登录"),
        "net_invalid_tip":
            MessageLookupByLibrary.simpleMessage("当前网络不可用，请检查你的网络设置"),
        "noAccount": MessageLookupByLibrary.simpleMessage("还没账号? "),
        "notrubleset": MessageLookupByLibrary.simpleMessage("勿扰设置"),
        "openBrowser": MessageLookupByLibrary.simpleMessage("浏览器打开"),
        "open_permission": MessageLookupByLibrary.simpleMessage("立即开启"),
        "open_permission_call":
            MessageLookupByLibrary.simpleMessage("请开启拨打电话权限"),
        "open_permission_contact": MessageLookupByLibrary.simpleMessage(
            "需要获取通讯录权限进行通话,是否允许此App获取通讯录权限？"),
        "open_permission_notify":
            MessageLookupByLibrary.simpleMessage("无通知权限，可能会错过来电哦"),
        "open_permission_speech":
            MessageLookupByLibrary.simpleMessage("无录音权限，请开启录音权限"),
        "page_buy_num": MessageLookupByLibrary.simpleMessage("购买号码"),
        "password": MessageLookupByLibrary.simpleMessage("密码"),
        "privacy_agreement": MessageLookupByLibrary.simpleMessage("《隐私政策》"),
        "rate": MessageLookupByLibrary.simpleMessage("评分"),
        "rePassword": MessageLookupByLibrary.simpleMessage("确认密码"),
        "refresh": MessageLookupByLibrary.simpleMessage("刷新"),
        "retry": MessageLookupByLibrary.simpleMessage("重试"),
        "ringAndVibrator": MessageLookupByLibrary.simpleMessage("铃音与震动"),
        "ringVibrator": MessageLookupByLibrary.simpleMessage("拨号按键震动"),
        "ringtone": MessageLookupByLibrary.simpleMessage("拨号按键音"),
        "save": MessageLookupByLibrary.simpleMessage("保存"),
        "searchHistory": MessageLookupByLibrary.simpleMessage("历史搜索"),
        "searchHot": MessageLookupByLibrary.simpleMessage("热门搜索"),
        "searchShake": MessageLookupByLibrary.simpleMessage("换一换"),
        "setting": MessageLookupByLibrary.simpleMessage("设置"),
        "settingFont": MessageLookupByLibrary.simpleMessage("字体"),
        "settingLanguage": MessageLookupByLibrary.simpleMessage("多语言"),
        "setting_theme_mode": MessageLookupByLibrary.simpleMessage("系统主题"),
        "setting_theme_mode1": MessageLookupByLibrary.simpleMessage("跟随系统"),
        "setting_theme_mode2": MessageLookupByLibrary.simpleMessage("深色模式"),
        "setting_theme_mode3": MessageLookupByLibrary.simpleMessage("浅色模式"),
        "share": MessageLookupByLibrary.simpleMessage("分享"),
        "signIn": MessageLookupByLibrary.simpleMessage("登录"),
        "splashSkip": MessageLookupByLibrary.simpleMessage("跳过"),
        "tabCall": MessageLookupByLibrary.simpleMessage("通话"),
        "tabContact": MessageLookupByLibrary.simpleMessage("联系人"),
        "tabMe": MessageLookupByLibrary.simpleMessage("我的"),
        "tabWorkbench": MessageLookupByLibrary.simpleMessage("发现"),
        "theme": MessageLookupByLibrary.simpleMessage("色彩主题"),
        "tips_developing": MessageLookupByLibrary.simpleMessage("该功能正在开发中。。。"),
        "toSignIn": MessageLookupByLibrary.simpleMessage("点我登录"),
        "tobuynewnumber": MessageLookupByLibrary.simpleMessage("购买服务"),
        "twoPwdDifferent": MessageLookupByLibrary.simpleMessage("两次密码不一致"),
        "userName": MessageLookupByLibrary.simpleMessage("用户名"),
        "user_agreement": MessageLookupByLibrary.simpleMessage("《用户协议》"),
        "viewStateButtonLogin": MessageLookupByLibrary.simpleMessage("登录"),
        "viewStateButtonRefresh": MessageLookupByLibrary.simpleMessage("刷新一下"),
        "viewStateButtonRetry": MessageLookupByLibrary.simpleMessage("重试"),
        "viewStateMessageEmpty": MessageLookupByLibrary.simpleMessage("空空如也"),
        "viewStateMessageError": MessageLookupByLibrary.simpleMessage("加载失败"),
        "viewStateMessageNetworkError":
            MessageLookupByLibrary.simpleMessage("网络连接异常,请检查网络或稍后重试"),
        "viewStateMessageUnAuth": MessageLookupByLibrary.simpleMessage("未登录"),
        "wechatAccount": MessageLookupByLibrary.simpleMessage("公众号")
      };
}
