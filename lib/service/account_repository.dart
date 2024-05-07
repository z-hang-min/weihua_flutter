import 'package:weihua_flutter/config/storage_manager.dart';
import 'package:weihua_flutter/model/address_book_version.dart';
import 'package:weihua_flutter/model/enterprise_info_result.dart';
import 'package:weihua_flutter/model/person_num_list_result.dart';
import 'package:weihua_flutter/model/unify_login_result.dart';
import 'package:weihua_flutter/model/user.dart';

///
/// @Desc: 账号信息管理
/// @Author: zhhli
/// @Date: 2021-04-13
///
///

AccountRepository accRepo = AccountRepository.getInstance();

class AccountRepository {
  static const String kUser = 'kUser';
  static const String kLoginResult = 'kLoginResult';
  static const String kPersonNumListResult = 'kPersonNumListResult';
  static const String kAPPIsAgreeProt = 'kAPPIsAgreeProt';

  String get _kAddressBookVersion => 'kAddressBookVersion_$outerNumberId';

  static AccountRepository? _reps;

  static AccountRepository getInstance() {
    if (null == _reps) _reps = AccountRepository._();
    return _reps!;
  }

  AccountRepository._() {
    var userMap = StorageManager.localStorage.getItem(kUser);
    _user = userMap != null ? User.fromJson(userMap) : null;

    var kLoginResultMap = StorageManager.localStorage.getItem(kLoginResult);
    if (kLoginResultMap != null)
      _unifyLoginResult = UnifyLoginResult.fromJson(kLoginResultMap);
  }

  // String _httpUrlPath = "";

  UnifyLoginResult? _unifyLoginResult;
  PersonNumListResult? _personNumListResult;
  User? _user;

  User? get user => _user;

  UnifyLoginResult? get unifyLoginResult => _unifyLoginResult;

  PersonNumListResult? get personNumListResult => _personNumListResult;

  bool get hasUser => user != null;

  bool get hasLoginResult => unifyLoginResult != null;

  // 数据库 当前用户Id
  String get ownerId => _user?.innerNumberId!.toString() ?? '';

  String get outerNumberId => _user?.outerNumberId.toString() ?? '';

  String get customName => _user?.customName! ?? '';

  String get httpUrlPath => _user?.rootPath ?? '';

  String? get currentCallTilte => getCurrentCallTilte();

  // AddressBookVersion _bookVersion;

  // AddressBookVersion get bookVersion => _bookVersion;

  saveUser(User user) {
    _user = user;
    StorageManager.localStorage.setItem(kUser, user);
    saveCurrentCallTilte("全部号码");
  }

  saveCurrentCallTilte(String title) {
    StorageManager.localStorage.setItem('title', title);
  }

  String getCurrentCallTilte() {
    if (StorageManager.localStorage.getItem('title') == null) {
      saveCurrentCallTilte('全部号码');
    }
    return StorageManager.localStorage.getItem('title');
  }

  String getH5UrlOrganizationTeam(bool isBrightness, {int chooseType = 0}) {
    var modeType = isBrightness ? 0 : 1;
    // return 'http://192.168.108.36:8080/boss/weihua/organization_team?outerNumberId=10&modeType=$modeType&chooseType=$chooseType';
    return "${_user?.rootPath2}/weihua/organization_team?outerNumberId=${_user?.outerNumberId}&modeType=$modeType&chooseType=$chooseType&pid=0";
  }

  String getH5UrlExtension(bool isBrightness, {int chooseType = 0}) {
    var modeType = isBrightness ? 0 : 1;
    // return 'http://192.168.108.36:8080/boss/weihua/extension?outerNumberId=10&modeType=$modeType&chooseType=$chooseType';
    return "${_user?.rootPath2}/weihua/extension?outerNumberId=${_user?.outerNumberId}&modeType=$modeType&chooseType=$chooseType";
  }

  String getH5UrlExtensionInfoPage(
      String mobile, String number, String username, bool isBrightness) {
    var modeType = isBrightness ? 0 : 1;
    return "${_user!.rootPath2}/weihua/user_info?"
        "mobile=$mobile&number=$number&userName=$username"
        "&outerNumberId=${_user!.outerNumberId}&modeType=$modeType";
  }

  saveUnifyLoginResult(UnifyLoginResult unifyLoginResult) {
    _unifyLoginResult = unifyLoginResult;
    StorageManager.localStorage.setItem(kLoginResult, _unifyLoginResult);
  }

  savePersonNumListResult(List<NumberInfo> _personalList) {
    StorageManager.localStorage.setItem("personalList", _personalList);
  }

  int getAccountSize() {
    return _unifyLoginResult?.numberList.length ?? 0;
  }

  /// 清除持久化的用户数据
  clearUser() {
    _user = null;
    _unifyLoginResult = null;
    StorageManager.localStorage.deleteItem(kUser);
    StorageManager.localStorage.deleteItem(kLoginResult);
    StorageManager.localStorage.deleteItem('personalList');
  }

  saveAPPIsAgreeProt(bool agree) {
    StorageManager.localStorage.setItem(kAPPIsAgreeProt, agree);
  }

  bool getAPPIsAgreeProt() {
    if (StorageManager.localStorage.getItem(kAPPIsAgreeProt) == null)
      return false;
    return StorageManager.localStorage.getItem(kAPPIsAgreeProt);
  }

  saveAddressBookVersion(AddressBookVersion version) {
    StorageManager.localStorage.setItem(_kAddressBookVersion, version);
  }

  AddressBookVersion getAddressBookVersion() {
    var kAddressBookVersionMap =
        StorageManager.localStorage.getItem(_kAddressBookVersion);
    AddressBookVersion bookVersion = kAddressBookVersionMap != null
        ? AddressBookVersion.fromJson(kAddressBookVersionMap)
        : AddressBookVersion.mock();
    return bookVersion;
  }

  clearAddressBookVersion() {
    StorageManager.localStorage.deleteItem(_kAddressBookVersion);
  }
}
