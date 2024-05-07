import 'dart:async';

import 'package:weihua_flutter/db/db_core.dart';
import 'package:weihua_flutter/db/enterprise_address_book_dao.dart';
import 'package:weihua_flutter/db/ex_contact_dao.dart';
import 'package:weihua_flutter/db/local_contact_dao.dart';
import 'package:weihua_flutter/event/call_list_refresh_event.dart';
import 'package:weihua_flutter/model/address_book_version.dart';
import 'package:weihua_flutter/model/enterprise_address_book.dart';
import 'package:weihua_flutter/model/ex_contacts_result.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/app_http_api.dart';
import 'package:weihua_flutter/service/contact_repository.dart';
import 'package:weihua_flutter/service/event_bus.dart';
import 'package:weihua_flutter/service/function_permission_help.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/contact_ui.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:oktoast/oktoast.dart';

///
/// @Desc: 主界面 加载 企业联系人 view_mode
/// @Author: zhhli
/// @Date: 2021-04-13
///
///

class HomeBusinessContactModel extends ViewStateModel {
  bool _hasNet = true;

  bool get hasNet => _hasNet;

  bool _haveButton = false;

  bool get haveButton => _haveButton;

 bool _infoView = false;

  bool get infoView => _infoView;

  int _tab = 0;

  int get tab => _tab;

  LocalContactDao _localContactDao = DbCore.getInstance().localContactDao;

  EnterpriseDao _enterpriseDao = DbCore.getInstance().enterpriseDao;
  EmployeeDao _employeeDao = DbCore.getInstance().employeeDao;
  ExContactDao _exContactDao = DbCore.getInstance().exContactDao;
  late UserModel _userModel;

  /// page 页面数据
  var uiList = <ContactUIInfo>[];
  var uiLocalList = <ContactUIInfo>[];

  HomeBusinessContactModel(this._userModel);

  /// 从数据库中读取数据，加快首次页面加载
  Future<void> loadDataFromDb({bool reLoadLocalDb = false}) async {
    var list = <ContactUIInfo>[];

    // Enterprise? enterprise =
    //     await _enterpriseDao.getEnterprise(accRepo.user?.outerNumberId ?? -1);
    // if (enterprise != null) {
    //   // 判断权限，有企业时，顶部
    //   if ((UserPermissionHelp.enableEnterpriseContact() ||
    //       UserPermissionHelp.enableExContact()))
    //     list.add(ContactUIInfo.fromTitle("企业联系人"));
    //   if (UserPermissionHelp.enableEnterpriseContact())
    //     list.add(ContactUIInfo.fromEnterprise(enterprise));
    //   if (UserPermissionHelp.enableExContact())
    //     list.add(ContactUIInfo.fromExContactTitle());
    // }
    if (uiLocalList.isEmpty) {
      // 首次加载，加快显示
      uiList = list;
      notifyListeners();
    }
    // 为空 或者 需要刷新，重新加载
    if ((uiLocalList.isEmpty || reLoadLocalDb) &&
        UserPermissionHelp.enableLocalContact()) {
      var tempLocalList = await _loadLocalContactListDb();

      // if (tempLocalList.isNotEmpty) {
      //   SuspensionUtil.setShowSuspensionStatus(tempLocalList);
      //   // 顶部 本机联系人 title ,索引为 第一个联系人
      //   ContactUIInfo title = ContactUIInfo.fromTitle("本机联系人");
      //   // title.tagIndex = tempLocalList.first.tagIndex;
      //   tempLocalList.insert(0, title);
      // }

      uiLocalList = tempLocalList;
    }
    if (UserPermissionHelp.enableLocalContact()) {
      list.addAll(uiLocalList);
    }

    uiList = list;

    notifyListeners();
  }

  /// 读取数据库 本机联系人，已排好序
  Future<List<ContactUIInfo>> _loadLocalContactListDb() async {
    var localList = await _localContactDao.loadList();
    var tempLocalList =
        localList.map((e) => ContactUIInfo.fromLocalContact(e)).toList();
    return tempLocalList;
  }

  /// 从系统中重新加载 本机联系人
  Future<void> reloadNativeLocalContact() async {
    if (readNativeRunning == true) {
      // 正在读取中
      return;
    }

    readNativeRunning = true;

    // 读取 联系人并，保存数据库
    Stream stream = contactRepo.loadNativeContacts();

    // StreamSubscription subscription = controller.stream.listen(print);

    stream.listen((event) {
      Log.e("message 加载联系人。。。。。。");
      loadDataFromDb(reLoadLocalDb: true);
      readNativeRunning = event;
    });
  }

  /// 查询 企业联系人版本，更新企业联系人，分机号数据

  Future<bool> queryBusinessContactVersion() async {
    // setBusy();
    int? outerNumberId = accRepo.user?.outerNumberId;
    if (outerNumberId == null) {
      return false;
    }
    try {
      var version = await httpApi.queryContactVersion(outerNumberId);
      AddressBookVersion localVersion = accRepo.getAddressBookVersion();
      Log.d("AddressBookVersion local  ${localVersion.toJson()}");
      Log.d("AddressBookVersion net    ${version.toJson()}");
      bool refreshCallLogs =
          version.v1 != localVersion.v1 || version.v2 != localVersion.v2;
      if (version.customName != localVersion.customName) {
        //更新企业名称
        localVersion.customName = version.customName;
        await updateEnterprise(version.customName);
      }
      if (version.v1 != localVersion.v1) {
        bool load = await _loadEnterpriseAddressBook(outerNumberId);
        if (load) {
          localVersion.v1 = version.v1;
        }
      }

      if (version.v2 != localVersion.v2) {
        bool load = await _loadExContacts(outerNumberId);
        if (load) {
          localVersion.v2 = version.v2;
        }
      }
      accRepo.saveAddressBookVersion(localVersion);

      loadDataFromDb(reLoadLocalDb: false);
      if (refreshCallLogs) {
        eventBus.fire(CallListRefreshEvent(true));
      }

      setIdle();
    } catch (e, s) {
      loadDataFromDb(reLoadLocalDb: false);
      setError(e, s);
      // setIdle();
      return false;
    }
    return true;
  }

  Future<bool> _loadEnterpriseAddressBook(int outerNumberId) async {
    try {
      EnterpriseAddressBook enterpriseAddressBook =
          await httpApi.queryBusinessContact(outerNumberId);
      // 保存数据
      enterpriseAddressBook.enterprise!.ownerId = _enterpriseDao.ownerId;
      await _enterpriseDao.replace(enterpriseAddressBook.enterprise!);

      enterpriseAddressBook.employees!.forEach((Employee element) {
        element.pinyin = StringUtils.getNospacePinyin(element.name);
      });

      await _employeeDao.replaceAll(enterpriseAddressBook.employees!,
          enterpriseAddressBook.enterprise!.enterpriseId);
    } catch (e, s) {
      setError(e, s);
      return false;
    }
    return true;
  }

  Future<bool> _loadExContacts(int outerNumberId) async {
    try {
      ExContactsResult exContactsResult =
          await httpApi.queryExtensionContact(outerNumberId);

      exContactsResult.innerNumberList?.forEach((element) {
        element.pinyin = StringUtils.getNospacePinyin(element.userName);
      });
      // 保存数据
      await _exContactDao.replaceAll(exContactsResult.innerNumberList!);
    } catch (e, s) {
      setError(e, s);
      return false;
    }
    return true;
  }

  Future<void> updateEnterprise(String name) async {
    Enterprise? enterprise =
        await _enterpriseDao.getEnterprise(accRepo.user?.outerNumberId ?? -1);
    if (enterprise == null || name == enterprise.name) {
      return;
    }
    enterprise.name = name;
    _enterpriseDao.replace(enterprise);
    notifyListeners();
  }

  Map<String, ContactUIInfo> _selectedMap = Map();

  get selectedMap => _selectedMap;

  bool isChecked(ContactUIInfo contactUIInfo) {
    if (_selectedMap.isEmpty) return false;
    return _selectedMap.containsKey(contactUIInfo.phone);
  }

  void addSelected(ContactUIInfo contactUIInfo) {
    if (_selectedMap.containsKey(contactUIInfo.phone))
      _selectedMap.remove(contactUIInfo.phone);
    else if (_selectedMap.length > 100) {
      showToast('最多可同时给100个号码发送');
      return;
    } else
      _selectedMap[contactUIInfo.phone] = contactUIInfo;
    notifyListeners();
  }

  ContactUIInfo? getContactLocal(String num) {
    var uiInfo;
    uiLocalList.forEach((element) {
      if (element.phone == num) uiInfo = element;
    });
    return uiInfo;
  }

  void reSetSelected(List<dynamic> contactUIInfo) {
    clearSelected();

    if (contactUIInfo.isEmpty) return;
    contactUIInfo.forEach((element) {
      ContactUIInfo? contact = getContactLocal(element);
      if (contact != null) _selectedMap[element] = contact;
    });
  }

  void clearSelected() {
    _selectedMap.clear();
    notifyListeners();
  }

  void changeContactTab(int tab) {
    _tab = tab;
    changeBackButton(false);
    notifyListeners();
  }
  void changeBackButton(bool haveButton) {
    _haveButton = haveButton;
    notifyListeners();
  }
  void changeInfoView(bool infoView) {
_infoView = infoView;
    notifyListeners();
  }
}
