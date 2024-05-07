import 'package:weihua_flutter/db/db_core.dart';
import 'package:weihua_flutter/db/ex_contact_dao.dart';
import 'package:weihua_flutter/model/call_record.dart';
import 'package:weihua_flutter/model/ex_contacts_result.dart';
import 'package:weihua_flutter/model/query_default_outer_num_result.dart';
import 'package:weihua_flutter/model/user.dart';
import 'package:weihua_flutter/provider/view_state_refresh_list_model.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/contact_repository.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:weihua_flutter/ui/page/call/call_widget.dart';
import 'package:weihua_flutter/ui/page/call/view_model/query_area_mode.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';

///
/// @Desc: 通话记录列表
/// @Author: zhhli
/// @Date: 2021-03-30
///
class HomeCallListModel extends ViewStateRefreshListModel<CallRecord> {
  bool _hasVoIP = true;
  bool _hasNet = true;

  bool get hasVoIP => _hasVoIP;

  bool get hasNet => _hasNet;

  bool _showPad = true;
  bool _showEmployee = false;
  String _callPadNum = '';
  ExContact? exContact;
  bool _onEdit = false;
  bool _checkAll = false;
  int _tab = 0;
  String _title = "${accRepo.currentCallTilte}";
  String _defaultOuterNum = "暂无号码";
  String _setDefaultOuterNum = "暂无号码";
  QueryAreaMode _areaMode = QueryAreaMode();

  bool get showPad => _showPad;

  String get callPadNum => _callPadNum;

  bool get showEmployee => _showEmployee;

  int get tab => _tab;

  String get title => _title;

  String get defaultOuterNum =>
      _defaultOuterNum.isEmpty ? '' : _defaultOuterNum;

  String get sefaultOuterNum => _setDefaultOuterNum;

  bool get onEdit => _onEdit;
  Map<String, CallRecord> _selectedMap = Map();
  Map<String, String> _selectedName = Map();

  List<CallRecord> _callMissedRecordList = [];
  List<CallRecord> showList = [];
  bool _search = false;

  bool get search => _search;

  get selectedMap => _selectedMap;

  get callMissedRecordList => _callMissedRecordList;

  Map<String, List<CallRecord>> _searchMap = Map();

  @override
  initData() async {
    setBusy();

    await refresh(init: true, pageFirst: 1);
    // 读完通话记录。再刷新通讯录
    if (await Permission.contacts.isGranted) {
      _loadNativeContacts();
    }
  }

  ///显示编辑按钮
  bool showEditIcon() {
    return _onEdit == false && list.isNotEmpty;
  }

  ///切换所有/未接来电
  void changeTab(int tab) {
    _tab = tab;
    _callMissedRecordList.clear();
    if (tab == 1) {
      list.forEach((element) {
        if (element.getCallType() == CallRecord.CAll_IN_MISSED)
          _callMissedRecordList.add(element);
      });
    }
    updateOnEdit(false);
  }

  String getDisplayNum(CallRecord record) {
    String name = title;
    if (title == '全部号码') {
      if (record.isCallOut) {
        name = record.safenumCallDisplay ?? record.calleridNumber!;
      } else
        name = record.destinationNumber!;
    }
    if (name.length <= 4) {
      //号码小于等于4，说明是分机互拨打
      name = record.name;
    } else {
      accRepo.unifyLoginResult!.numberList.forEach((element) {
        String number = '${element.outerNumber2}${element.innerNumber}';
        if (number == name && element.innerNumber == '1000') {
          name = element.outerNumber2!;
        }
      });
    }

    return name;
  }

  ///更新顶部号码
  void updateTitle(String title) {
    if (title.isEmpty) return;
    _title = title;
    if (_onEdit) updateOnEdit(false);
    accRepo.saveCurrentCallTilte(title);
    notifyListeners();
  }

  ///网络状态更新
  void updateNet(bool enable) {
    _hasNet = enable;
    notifyListeners();
  }

  void _loadNativeContacts() {
    if (readNativeRunning == true) {
      // 正在读取中
      return;
    }
    // 读取 联系人并，保存数据库
    Stream stream = contactRepo.loadNativeContacts();

    stream.listen((event) {
      readNativeRunning = event;
      // refresh(pageFirst: 1);
    });
  }

  List<CallRecord> getCurrentList() {
    if (_search) {
      return showList;
    } else {
      if (_tab == 1) return _callMissedRecordList;
      return list;
    }
  }

  void updateShowPad(bool show) {
    _showPad = show;
    notifyListeners();
  }

  bool showEmptyView() {
    if (search) return false; //T9输入号码
    return (tab == 0 && list.isEmpty) ||
        (tab == 1 && callMissedRecordList.isEmpty);
  }

  void updateOnEdit(bool onEdit) {
    _onEdit = onEdit;
    _selectedMap.clear();
    if (onEdit) {
      findEmployee('');
      clearSearch();
    }
    notifyListeners();
  }

  setCheckedAll(bool all) {
    _selectedMap.clear();
    _checkAll = all;
    if (all) {
      if (tab == 1) {
        callMissedRecordList.forEach((element) {
          _selectedMap[element.time.toString()] = element;
        });
      } else {
        list.forEach((element) {
          _selectedMap[element.time.toString()] = element;
        });
      }
    }
    notifyListeners();
  }

  bool isCheckedAll() {
    if (_selectedMap.isEmpty) return false;
    return _selectedMap.length ==
        (tab == 1 ? callMissedRecordList.length : list.length);
  }

  bool isChecked(CallRecord callRecord) {
    if (_selectedMap.isEmpty) return false;
    return _selectedMap.containsKey(callRecord.time.toString());
  }

  void addSelected(CallRecord callRecord) {
    if (_selectedMap.containsKey(callRecord.time.toString()))
      _selectedMap.remove(callRecord.time.toString());
    else
      _selectedMap[callRecord.time.toString()] = callRecord;
    notifyListeners();
  }

  @override
  Future<List<CallRecord>> loadData({int pageNum = 1, String num = ""}) async {
    if (tab == 1 && pageNum == 1)
      _callMissedRecordList.clear(); //未接来电，下拉刷新时先清空旧数据
    pageSize = 20;
    updateOnEdit(false);
    if (num.isEmpty) num = title;
    if (num == "全部号码") {
      accRepo.unifyLoginResult!.numberList.forEach((element) {
        if (element.innerNumber == '1000')
          num = "${element.outerNumber2},$num";
        else
          num = "${element.number},$num";
      });
    }
    num = num.replaceAll(' ', '');
    // accRepo.unifyLoginResult!.numberList.forEach((element) {
    //   if (element.number == num) num = element.outerNumber2!;
    // });
    List<CallRecord> listtem =
        await salesHttpApi.loadCallRecordFClound(num, pageSize, pageNum);
    listtem = await getList(listtem);
    if (_checkAll) {
      listtem.forEach((element) {
        _selectedMap[element.time.toString()] = element;
      });

      notifyListeners();
    }

    return listtem;
  }

  ///企业通讯录--->分机--->本机通讯录 匹配名字
  Future<List<CallRecord>> getList(List<CallRecord> test) async {
    for (var i = 0; i < test.length; i++) {
      CallRecord element = test[i];
      if (_selectedName.isNotEmpty &&
          _selectedName.containsKey(element.number)) {
        element.name = _selectedName[element.number]!;
      } else {
        Map recordInfo = Map();
        recordInfo = await contactRepo.findName(element.number);
        String name = recordInfo['name'];
        if (name.isEmpty || name == '') name = element.number;
        // _selectedName[element.number] = name;
        element.name = name;
      }
      if (element.region == ' ' || element.region.isEmpty) {
        element.region = await _areaMode.queryArea(element.number);
      }
    }

    return test;
  }

  @override
  onCompleted(List<CallRecord> data) async {
    if (tab == 1) {
      // _callMissedRecordList.clear();
      data.forEach((element) {
        if (element.getCallType() == CallRecord.CAll_IN_MISSED) {
          _callMissedRecordList.add(element);
        }
      });
      notifyListeners();
    }
  }

  ///删除单条通话记录
  Future<void> deleteRecord(CallRecord record) async {
    await delRecord(record).then((value) {
      if (value) {
        _selectedMap.remove(record);
        CallRecord del = record;
        list.forEach((value) {
          if (record.time == value.time) del = value;
        });
        list.remove(del);
        _callMissedRecordList.forEach((value) {
          if (record.time == value.time) del = value;
        });
        _callMissedRecordList.remove(del);
        if (search) {
          _searchMap.clear();
          showList.clear();
          _search = false;
          lastNum = '';
        }
        notifyListeners();
      } else {
        showToast('删除失败');
      }
    });
  }

  ///删除选中的记录
  void deleteSelectedRecords() {
    if (_selectedMap.isEmpty) return;
    _selectedMap.forEach((key, value) {
      deleteRecord(value);
    });
    _selectedMap.clear();
    updateOnEdit(false);
    notifyListeners();
  }

  Future<bool> delRecord(CallRecord callRecord) async {
    try {
      await salesHttpApi.delCallRecordFClound(
          callRecord.id!, callRecord.index!);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      print(e);
    }
    return false;
  }

  ///从本地缓存的记录列表中查询通话记录
  Future<List<CallRecord>> searchRecord(String number) async {
    if (number.length == 4 || number.length == 3) {
      findEmployee(number);
    } else {
      findEmployee('');
    }
    List<CallRecord> result = [];
    _search = true;
    List<CallRecord>? temp = _searchMap[number];
    if (temp != null) {
      resetShowList(temp);
      return temp;
    }

    for (String key in _searchMap.keys) {
      // 在现有的缓存中查找
      if (number.contains(key)) {
        List<CallRecord> temp = _searchMap[key] ?? [];
        for (CallRecord record in temp) {
          if (record.number.contains(number)) {
            result.add(record);
          }
        }
        // 存入缓存
        _searchMap[number] = result;
        resetShowList(result);
        return result;
      }
    }

    // result = await _dao.searchNumber(number, -1);
    list.forEach((element) {
      if (element.number.contains(number)) {
        result.add(element);
      }
    });

    // 存入缓存
    _searchMap[number] = result;
    resetShowList(result);
    return result;
  }

  void clearSearch() {
    _searchMap.clear();
    showList.clear();
    _search = false;
    lastNum = '';
    notifyListeners();
  }

  void resetShowList(List<CallRecord> temp) {
    showList.clear();
    showList.addAll(temp);
    notifyListeners();
  }

  /// 点击呼叫时，清除缓存
  void clearSearchCache() {
    _searchMap.clear();
  }

  List<User> getUserList() {
    List<User> userList = [];
    userList.addAll(accRepo.unifyLoginResult!.perNumberList);
    userList.addAll(getComUserList());
    return userList;
  }

//联络中心号码1000的，直接显示总机号
  List<User> getComUserList() {
    List<User> userList = [];
    List<String> userList3 = [];
    List<User> userList2 = accRepo.unifyLoginResult!.companyNumberList;
    // userList2.forEach((element) {
    //   Log.e(
    //       "zhangminouterNumber2==${element.outerNumber2}---${element.innerNumber}");
    //   userList3.add(element.number!);
    // });
    // userList3 = userList3.toSet().toList();
    // userList3.forEach((element) {
    //   userList
    //       .add(userList2.firstWhere((element2) => element2.number == element));
    // });
    return userList2;
  }

  ///查询外呼号码，分机1000的默认显示总机号码
  Future<QueryDefaultOuterNumResult?> queryDefaultOuterNum() async {
    setBusy();
    try {
      QueryDefaultOuterNumResult result =
          await salesHttpApi.queryDefaultOuterNum(accRepo.user!.mobile!);
      if (result.number == "" || result.number.isEmpty) {
        User user = accRepo.unifyLoginResult!.numberList[0];
        String resetNum = user.outerNumber2!;
        updateCalloutNumState(resetNum);
      } else {
        String displayNum = StringUtils.get95WithSpace(result.number);
        accRepo.unifyLoginResult!.numberList.forEach((element) {
          String number = '${element.outerNumber2}${element.innerNumber}';
          if (number == displayNum && element.innerNumber == '1000') {
            displayNum = element.outerNumber2!;
          }
        });
        updateDefaultOuterNum(displayNum);
      }

      setIdle();
      return result;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      print(e);
    }
    return null;
  }

  ///设置外呼号码，分机1000的总机号码，设置的时候加上分机1000
  Future<bool> updateCalloutNumState(String number) async {
    String displayNum = number;
    String innerNum = '';
    int customID = 0;
    accRepo.unifyLoginResult!.numberList.forEach((element) {
      if (element.outerNumber2 == number && element.innerNumber == "1000") {
        //总机号相等，且分机为1000，设置外显为总机
        //代表设置的是总机
        number = element.outerNumber2!;
        innerNum = element.innerNumber!;
        customID = element.customId!;
      } else if (number == "${element.outerNumber2}${element.innerNumber}") {
        //分机总机一样
        number = element.outerNumber2!;
        innerNum = element.innerNumber!;
        customID = element.customId!;
      }
    });

    setBusy();
    try {
      await salesHttpApi.updateCalloutNumState(
          accRepo.user!.mobile!, number, "$customID", innerNum);
      updateDefaultOuterNum(displayNum);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      return false;
    }
  }

  void updateDefaultOuterNum(String num) {
    // if (num.isNotEmpty) num = num.replaceAll(' ', '');
    _defaultOuterNum = num;
    updateSetDefaultOuterNum(num);
    notifyListeners();
  }

  void updateSetDefaultOuterNum(String num) {
    _setDefaultOuterNum = num;
    notifyListeners();
  }

  void updateShowPadNum(String num) {
    _callPadNum = num;
    lastNum = num;
    notifyListeners();
  }

  ///是否展示分机联系人
  void updateShowEmployee(bool show) {
    _showEmployee = show;
    notifyListeners();
  }

  ///在拨号盘输入3/四位数字时，查看对应企业中是否有分机号码
  /// 如果有，置顶显示分机对应信息，点击条目可把分机对应的手机号自动填入号码输入框中
  ///没有则不显示，只显示匹配的通话记录
  /// 在输入4位数字，如果有对应的分机，则在拨打电话时，拨打的号码替换为95013+分机绑定的手机号
  /// 如果使用分机对应的总机号码拨打，则直接调用系统键盘进行呼叫
  /// 如果使用个人号码或者其他总机号码拨打时，toast提示“请使用95013xxx拨打”（分机对应的总机号码），不调用系统键盘
  Future<void> findEmployee(String number) async {
    ExContactDao _exContactDao = DbCore.getInstance().exContactDao;
    exContact = await _exContactDao.getExContact(number);
    _showEmployee = exContact != null;
    Log.d(_showEmployee);
    if (exContact != null) Log.d(exContact.toString());
    notifyListeners();
  }
}
