import 'package:weihua_flutter/model/call_record.dart';
import 'package:weihua_flutter/model/extension_result.dart';
import 'package:weihua_flutter/model/order_record.dart';
import 'package:weihua_flutter/ui/page/call/calllog_Info_page.dart';
import 'package:weihua_flutter/ui/page/call/pick_single_existed_contact.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/notice_charge_page.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/notice_data_statistics_desc_page.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/notice_data_statistics_page.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/notice_page.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/notice_send_page.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/notification_historylist_page.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/notification_template_build_page.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/notification_template_list_page.dart';
import 'package:weihua_flutter/ui/page/db_test_page.dart';
import 'package:weihua_flutter/ui/page/login/login_page.dart';
import 'package:weihua_flutter/ui/page/person_number/person_number_buy_page.dart';
import 'package:weihua_flutter/ui/page/person_number/person_number_calloutnum_page.dart';
import 'package:weihua_flutter/ui/page/person_number/person_number_list_page.dart';
import 'package:weihua_flutter/ui/page/person_number/person_number_order_desc_page.dart';
import 'package:weihua_flutter/ui/page/person_number/person_number_order_manager_page.dart';
import 'package:weihua_flutter/ui/page/person_number/person_number_pay_page.dart';
import 'package:weihua_flutter/ui/page/person_number/person_number_pay_result_page.dart';
import 'package:weihua_flutter/ui/page/person_number/person_number_renew_page.dart';
import 'package:weihua_flutter/ui/page/person_number/person_number_set_blacklist_page.dart';
import 'package:weihua_flutter/ui/page/person_number/person_number_set_no_disturb_page.dart';
import 'package:weihua_flutter/ui/page/person_number/person_number_setting_page.dart';
import 'package:weihua_flutter/ui/page/person_number/person_number_upgrade_page.dart';
import 'package:weihua_flutter/ui/page/person_number/person_number_upgrade_result_page.dart';
import 'package:weihua_flutter/ui/page/setting/about_page.dart';
import 'package:weihua_flutter/ui/page/setting/answer_mode_page.dart';
import 'package:weihua_flutter/ui/page/setting/instructions_page.dart';
import 'package:weihua_flutter/ui/page/setting/ring_vibrator_page.dart';
import 'package:weihua_flutter/ui/page/setting/switch_account_page.dart';
import 'package:weihua_flutter/ui/page/setting/wh_setting_page.dart';
import 'package:weihua_flutter/ui/page/setting_page.dart';
import 'package:weihua_flutter/ui/page/splash.dart';
import 'package:weihua_flutter/ui/page/tab/tab_navigator.dart';
import 'package:weihua_flutter/ui/page/workbench/buy_extension_number_page.dart';
import 'package:weihua_flutter/ui/page/workbench/certification_success_page.dart';
import 'package:weihua_flutter/ui/page/workbench/enterprise_certification_page.dart';
import 'package:weihua_flutter/ui/page/workbench/enterprise_info_page.dart';
import 'package:weihua_flutter/ui/page/workbench/enterprise_moreinfo_page.dart';
import 'package:weihua_flutter/ui/page/workbench/extension_activation_page.dart';
import 'package:weihua_flutter/ui/page/workbench/extension_edit_page.dart';
import 'package:weihua_flutter/ui/page/workbench/extension_management_page.dart';
import 'package:weihua_flutter/ui/page/workbench/extension_success_page.dart';
import 'package:weihua_flutter/ui/page/workbench/exterprise_edit_success.dart';
import 'package:weihua_flutter/ui/page/workbench/no_network_page.dart';
import 'package:weihua_flutter/ui/page/workbench/renew_extension_number_page.dart';
import 'package:weihua_flutter/ui/page/workbench/workbench_webview.dart';
import 'package:weihua_flutter/ui/widget/page_route_anim.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool ishavenet = true;
bool isLogin = false;
int payType = 0; //支付页面，用于支付成功回调

class RouteName {
  static const String splash = 'splash';
  static const String tab = '/';
  static const String login = 'login';
  static const String setting = 'setting';
  static const String whSetting = 'wh_setting';
  static const String about = 'about';
  static const String answerMode = 'answerMode';
  static const String ringAndVibrator = 'ringAndVibrator';

  static const String dbTestPage = 'db/dbTestPage';
  static const String webH5 = 'webH5';
  static const String enterprisePage = 'enterprisePage';
  static const String enterprisemoreinfoPage = 'enterprisemoreinfoPage';
  static const String certificationPage = 'certificationPage';
  static const String certificationSuccessPage = 'certificationSuccessPage';
  static const String extentionResultPage = 'extentionResultPage';
  static const String extentioneditResultPage = 'extentioneditResultPage';
  static const String notifacationTemplatepage = "notifacationTemplatepage";
  static const String notificationHistorylistPage =
      "notificationHistorylistPage";
  static const String extensionmanagementPage = "extensionmanagementPage";
  static const String extensionactivationPage = 'extensionactivationPage';
  static const String extensioneditPage = 'extensioneditPage';
  static const String switchAccountPage = 'switchAccountPage';
  static const String callInfoPage = 'call/callInfoPage';
  static const String chooseContactPage = 'call/pick_single_existed_contact';

  static const String pNumberBuy = 'personNumber/buy';
  static const String pNumberPay = 'personNumber/pay';
  static const String pNumberPayResult = 'personNumber/pay_result';
  static const String pNumberList = 'personNumber/my_number_list';
  static const String pNumberSetting = 'personNumber/setting';
  static const String pNumberSetBlacklist = 'personNumber/set_blacklist';
  static const String pNumberSetNoDisturb = 'personNumber/set_no_disturb';
  static const String pNumberCalloutNum = 'personNumber/callouenumber';
  static const String pNumberOrderManager = 'personNumber/order_manager';
  static const String pNumberOrderManagerDesc =
      'personNumber/order_manager_desc';
  static const String pNumberUpgrade = 'personNumber/number_upgrade';
  static const String pNumberUpgradePayResult =
      'personNumber/number_upgrade_payresult';
  static const String pNumberRenew = 'personNumber/number_renew';
  static const String noticePage = 'notice/notice_page';
  static const String noticeSendPage = 'notice/notice_send';
  static const String noticeChargePage = 'notice/notice_charge';
  static const String noticeChargePageResult = 'notice/notice_charge_result';
  static const String addNoticeTemPage = 'notice/add_notice_tem_page';
  static const String noticeDataStatisticsPage =
      'notice/add_data_statistics_page';
  static const String noticeDataStatisticsDescPage =
      'notice/add_data_statistics_desc_page';
  static const String renewExNumPage = 'workbench/renew_ext_num_page';
  static const String buyExNumPage = 'workbench/buy_ext_num_page';
  static const String instructionsPage = 'setting/buy_ext_num_page';
}

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Log.w("跳转页面 ==========> ${settings.toString()}");
    switch (settings.name) {
      case RouteName.splash:
        return NoAnimRouteBuilder(SplashPage());
      case RouteName.tab:
        return NoAnimRouteBuilder(TabNavigator());
      case RouteName.login:
        return CupertinoPageRoute(
            fullscreenDialog: true, builder: (_) => LoginPage());

      case RouteName.whSetting:
        return CupertinoPageRoute(builder: (_) => SetPage());
      case RouteName.setting:
        return CupertinoPageRoute(builder: (_) => SettingPage());
      case RouteName.about:
        return CupertinoPageRoute(builder: (_) => AboutPage());
      case RouteName.answerMode:
        return CupertinoPageRoute(builder: (_) => AnswerModePage());
      case RouteName.ringAndVibrator:
        return CupertinoPageRoute(builder: (_) => RingAndVibratorPage());
      case RouteName.switchAccountPage:
        return CupertinoPageRoute(builder: (_) => SwitchAccountPage());
      case RouteName.webH5:
        {
          String data = settings.arguments as String;
          // isConnected();
          return ishavenet
              ? CupertinoPageRoute(builder: (_) => WebviewPage(data))
              : CupertinoPageRoute(builder: (_) => NoNetWorkPage(data));
        }
      case RouteName.enterprisePage:
        return CupertinoPageRoute(builder: (_) => EnterpriseInfoPage());
      case RouteName.dbTestPage:
        return CupertinoPageRoute(builder: (_) => DbTestPage());
      case RouteName.callInfoPage:
        CallRecord record = settings.arguments as CallRecord;
        return CupertinoPageRoute(builder: (_) => CallInfoPage(record));
      case RouteName.chooseContactPage:
        CallRecord record = settings.arguments as CallRecord;
        return CupertinoPageRoute(
            builder: (_) => PickContactPage(
                  onecallRecord: record,
                ));
      case RouteName.pNumberBuy:
        return CupertinoPageRoute(builder: (_) => BuyPersonNumberPage());
      case RouteName.pNumberPay:
        return CupertinoPageRoute(builder: (_) => PayPersonNumberPage());
      case RouteName.pNumberPayResult:
        return CupertinoPageRoute(builder: (_) => PayResultPersonNumberPage());
      case RouteName.pNumberList:
        String data = settings.arguments as String;
        return CupertinoPageRoute(builder: (_) => MyPersonNumberListPage(data));
      case RouteName.pNumberSetting:
        {
          Map data = settings.arguments as Map;
          // isConnected();
          return CupertinoPageRoute(
              builder: (_) => MyPersonNumberSettingPage(data));
        }
      case RouteName.enterprisemoreinfoPage:
        {
          String data = settings.arguments as String;
          return CupertinoPageRoute(
              builder: (_) => EnterpriseMoreInfoPage(data));
        }
      case RouteName.pNumberSetNoDisturb:
        String data = settings.arguments as String;
        return CupertinoPageRoute(
            builder: (_) => MyPersonNumbernodisturbPage(data));
      case RouteName.pNumberSetBlacklist:
        String data = settings.arguments as String;
        return CupertinoPageRoute(
            builder: (_) => MyPersonNumberblacklistPage(data));
      case RouteName.pNumberCalloutNum:
        Map data = settings.arguments as Map;
        return CupertinoPageRoute(
            builder: (_) => MyPersonNumbercalloutNumPage(data));
      case RouteName.pNumberOrderManager:
        return CupertinoPageRoute(builder: (_) => OrderManagerPage());
      case RouteName.pNumberOrderManagerDesc:
        return CupertinoPageRoute(
          builder: (_) => OrderDescPage(settings.arguments as OrderRecord),
        );
      case RouteName.pNumberUpgrade:
        return CupertinoPageRoute(
          builder: (_) => UpgradePersonNumberPage(),
        );
      case RouteName.pNumberRenew:
        return CupertinoPageRoute(
          builder: (_) => RenewPersonNumberPage(settings.arguments as Map),
        );
      case RouteName.pNumberUpgradePayResult:
        return CupertinoPageRoute(
          builder: (_) => UpgradePayResultPage(settings.arguments as bool),
        );
      case RouteName.certificationPage:
        return CupertinoPageRoute(
            builder: (_) =>
                EnterpriseCertificationPage(settings.arguments as String));
      case RouteName.certificationSuccessPage:
        return CupertinoPageRoute(builder: (_) => CertificationResultPage());
      case RouteName.extentionResultPage:
        return CupertinoPageRoute(builder: (_) => ExtentionResultPage());
      case RouteName.extentioneditResultPage:
        return CupertinoPageRoute(
            builder: (_) =>
                ExtentioneditResultPage(settings.arguments as String));
      case RouteName.noticePage:
        return CupertinoPageRoute(builder: (_) => NoticePage());
      case RouteName.noticeSendPage:
        return CupertinoPageRoute(
            builder: (_) => NoticeSendPage(settings.arguments as dynamic));
      case RouteName.notifacationTemplatepage:
        return CupertinoPageRoute(
            builder: (_) => NotificationTemListPage("95013185189"));
      case RouteName.notificationHistorylistPage:
        return CupertinoPageRoute(
            builder: (_) => NotificationHistoryListPage("95013185189"));
      case RouteName.extensionmanagementPage:
        return CupertinoPageRoute(builder: (_) => ExtensionmanagementPage());
      case RouteName.extensionactivationPage:
        return CupertinoPageRoute(builder: (_) => ExtensionactivationPage());
      case RouteName.extensioneditPage:
        return CupertinoPageRoute(
            builder: (_) => ExtensioneditPage(settings.arguments as dynamic));
      case RouteName.noticeChargePage:
        return CupertinoPageRoute(
            builder: (_) => NoticeChargePage(
                  count: settings.arguments as int,
                ));
      case RouteName.addNoticeTemPage:
        return CupertinoPageRoute(
            builder: (_) => NewNoticeTemPage(settings.arguments as dynamic));
      case RouteName.noticeDataStatisticsPage:
        return CupertinoPageRoute(builder: (_) => DataStatisticsPage());
      case RouteName.noticeDataStatisticsDescPage:
        return CupertinoPageRoute(
            builder: (_) =>
                DataStatisticsDescPage(settings.arguments as dynamic));
      case RouteName.buyExNumPage:
        return CupertinoPageRoute(builder: (_) => BuyExtensionNumPage());
      case RouteName.instructionsPage:
        return CupertinoPageRoute(builder: (_) => InstructionsPage());
      case RouteName.renewExNumPage:
        return CupertinoPageRoute(
            builder: (_) =>
                RenewExtensionNumPage(settings.arguments as ExtensionInfo));
      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}

// Future<bool> isConnected() async {
//   var connectivityResult = await (Connectivity().checkConnectivity());
//   ishavenet = connectivityResult != ConnectivityResult.none;
//   return ishavenet;
// }

/// Pop路由
class PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  PopRoute({required this.child});

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
