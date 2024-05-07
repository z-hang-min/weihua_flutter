import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/event/widgetlife_change_event.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/model/check_update_result.dart';
import 'package:weihua_flutter/model/query_login_num_iscancel.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/event_bus.dart';
import 'package:weihua_flutter/ui/page/call/call_widget.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/home_enterprise_address_model.dart';
import 'package:weihua_flutter/ui/page/setting/checkupdate_mode.dart';
import 'package:weihua_flutter/ui/page/setting/query_info_mode.dart';
import 'package:weihua_flutter/ui/page/tab/index_calllist_page.dart';
import 'package:weihua_flutter/ui/page/tab/me_page.dart';
import 'package:weihua_flutter/ui/page/tab/workbench_page.dart';
import 'package:weihua_flutter/ui/widget/custom_permission_alert_dialog.dart';
import 'package:weihua_flutter/ui/widget/update_dialog.dart';
import 'package:weihua_flutter/utils/network_utils.dart';
import 'package:weihua_flutter/utils/platform_utils.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'home_contact_list_page.dart';

List<Widget> pages = <Widget>[
  IndexCallListPage(),
  HomeContactListPage(
    onSelectcontact: false,
  ),
  WorkbenchWorkPage(),
  MePage(),
];

class TabNavigator extends StatefulWidget {
  final int jumpIndex;

  TabNavigator({Key? key, this.jumpIndex = 0}) : super(key: key);

  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator>
    with WidgetsBindingObserver {
  var _pageController = PageController();
  int _selectedIndex = 0;
  DateTime? _lastPressed;
  HomeBusinessContactModel? _homeBusinessContactModel;
  QueryInfoMode? _infoMode;

  @override
  Widget build(BuildContext context) {
    bool dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (_lastPressed == null ||
              DateTime.now().difference(_lastPressed!) > Duration(seconds: 1)) {
            //两次点击间隔超过1秒则重新计时
            _lastPressed = DateTime.now();
            return false;
          }
          return true;
        },
        child:
            ProviderWidgetNoConsumer2<QueryInfoMode, HomeBusinessContactModel>(
                model1: QueryInfoMode(Provider.of<UserModel>(context),
                    homeBusinessContactModel:
                        Provider.of<HomeBusinessContactModel>(context,
                            listen: false)),
                model2:
                    HomeBusinessContactModel(Provider.of<UserModel>(context)),
                onModelReady: (model1, model2) {
                  _infoMode = model1;
                  _homeBusinessContactModel = model2;
                  checkAccount(checkPer: true);
                },
                child: PageView.builder(
                  itemBuilder: (ctx, index) => pages[index],
                  itemCount: pages.length,
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {},
                )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 3,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: dark ? Colour.f21ffffff : Colour.titleColor,
        //未选择item的颜色
        unselectedItemColor: dark ? Colour.fA5ffffff : Color(0xffAFB6BC),
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(dark
                ? ImageHelper.wrapAssets('tab_item_phone_selected_dark.svg')
                : ImageHelper.wrapAssets('tab_item_phone_selected.svg')),
            icon: SvgPicture.asset(dark
                ? ImageHelper.wrapAssets('tab_item_phone_unselected_dark.svg')
                : ImageHelper.wrapAssets('tab_item_phone_unselected.svg')),
            label: S.of(context).tabCall,
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(dark
                ? ImageHelper.wrapAssets('tab_item_contact_selected_dark.svg')
                : ImageHelper.wrapAssets('tab_item_contact_selected.svg')),
            icon: SvgPicture.asset(dark
                ? ImageHelper.wrapAssets('tab_item_contact_unselected_dark.svg')
                : ImageHelper.wrapAssets('tab_item_contact_unselected.svg')),
            label: S.of(context).tabContact,
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(dark
                ? ImageHelper.wrapAssets('tab_item_workbench_selected_dark.svg')
                : ImageHelper.wrapAssets('tab_item_workbench_selected.svg')),
            icon: SvgPicture.asset(dark
                ? ImageHelper.wrapAssets(
                    'tab_item_workbench_unselected_dark.svg')
                : ImageHelper.wrapAssets('tab_item_workbench_unselected.svg')),
            label: S.of(context).tabWorkbench,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(dark
                ? ImageHelper.wrapAssets('tab_item_me_unselected_dark.svg')
                : ImageHelper.wrapAssets('tab_item_me_unselected.svg')),
            activeIcon: SvgPicture.asset(dark
                ? ImageHelper.wrapAssets('tab_item_me_selected_dark.svg')
                : ImageHelper.wrapAssets('tab_item_me_selected.svg')),
            label: S.of(context).tabMe,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.jumpIndex);

    NetWorkUtils.initConnectivity();
    WidgetsBinding.instance.addObserver(this);
    _selectedIndex = widget.jumpIndex;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      NetWorkUtils.check();
      checkAccount(checkPer: false);
    }
    eventBus.fire(WidgetLifeChangeEvent(state));
  }

  ///检查账号是否存在，查询账号信息，查询通讯录
  Future checkAccount({bool checkPer = false}) async {
    if (lastNum.isNotEmpty) return;
    if (accRepo.hasUser) {
      LoginNumCancelResult? loginState = await _infoMode?.queryLoginNumIsCancel(
          accRepo.user!.mobile!,
          accRepo.user!.innerNumberId!,
          accRepo.user!.outerNumberId);
      if (loginState == null) {
        _infoMode?.showErrorMessage(context);
      } else if (loginState.isCancel()) {
        Navigator.pushReplacementNamed(context, RouteName.login);
        Provider.of<UserModel>(context, listen: false).clearUser();
      } else {
        if (checkPer) {
          checkUpdate(context);
          _checkPermissons(context);
        }
      }
      _infoMode?.queryInfo();
      _infoMode?.checkLogin();
      _homeBusinessContactModel?.queryBusinessContactVersion();
    }
  }

  @override
  void dispose() {
    NetWorkUtils.cancle();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  checkUpdate(BuildContext context) async {
    CheckUpdateResult? appUpdateInfo = await CheckUpdateMode().checkUpdate();
    if (appUpdateInfo?.update ?? false) {
      await UpdateDialog.showUpdateDialog(context, appUpdateInfo!);
    }
  }

  _checkPermissons(BuildContext context) {
    _checkContactsPermission(context);
    if (Platform.isAndroid) {
      _checkPhonePermission(context);
    }
  }

  _checkContactsPermission(BuildContext context) async {
    HomeBusinessContactModel model =
        Provider.of<HomeBusinessContactModel>(context, listen: false);
    if (await Permission.contacts.isGranted) {
      model.reloadNativeLocalContact();
      model.loadDataFromDb(reLoadLocalDb: true);
    } else {
      CustomPermissionAlertDialog.showAlertDialog(
          context,
          S.of(context).open_permission_contact,
          Theme.of(context).brightness == Brightness.light
              ? 'icon_mail.svg'
              : 'icon_mail_dark.svg', (value) async {
        if (await Permission.contacts.request().isGranted) {
          model.reloadNativeLocalContact();
          // model.queryBusinessContactVersion();
          model.loadDataFromDb(reLoadLocalDb: true);
        } else {
          openAppSettings();
        }
      }, true);
    }
  }

  _checkPhonePermission(BuildContext context) async {
    if (!await Permission.phone.isGranted) {
      CustomPermissionAlertDialog.showAlertDialog(
          context,
          S.of(context).open_permission_call,
          Theme.of(context).brightness == Brightness.light
              ? 'icon_call.svg'
              : 'icon_call_dark.svg', (value) async {
        if (await Permission.phone.request().isGranted) {}
      }, true);
    } else {}
  }
}
