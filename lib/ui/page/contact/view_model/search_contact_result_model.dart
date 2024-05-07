import 'package:weihua_flutter/db/call_record_dao.dart';
import 'package:weihua_flutter/db/db_core.dart';
import 'package:weihua_flutter/db/enterprise_address_book_dao.dart';
import 'package:weihua_flutter/db/ex_contact_dao.dart';
import 'package:weihua_flutter/db/local_contact_dao.dart';
import 'package:weihua_flutter/model/call_record.dart';
import 'package:weihua_flutter/provider/view_state_list_model.dart';

class SearchContactModel extends ViewStateListModel {
  CallRecordDao _callDao = DbCore.getInstance().callRecordDao;
  EmployeeDao _employeeDao = DbCore.getInstance().employeeDao;
  ExContactDao _exContactDao = DbCore.getInstance().exContactDao;
  LocalContactDao _localContactDao = DbCore.getInstance().localContactDao;

  List<Map> searchResultList = [];

  Map<String, List<Map>> cache = Map();

  @override
  Future<List> loadData() async {
    // recordList = await _dao.pageListTest();
    // contactList = await getOldContactListFromLocalFile();
    return [];
  }

  Future<void> search(String searchKey) async {
    // setBusy();
    if (searchKey.isEmpty) {
      // 不要用clear
      searchResultList = [];
      setIdle();
      return;
    }

    List<Map>? temp = cache[searchKey];
    if (temp != null) {
      // 缓存
      searchResultList = [];
      searchResultList.addAll(temp);
      setIdle();
      return;
    }

    List<Map> resultList = [];
    //通话记录
    List<CallRecord> callList = await _callDao.search(searchKey, -1);
    if (callList.isNotEmpty) {
      Map callMap = new Map();
      callMap['name'] = '最近通话';
      callMap['list'] = callList;

      resultList.add(callMap);
    }

    //企业联系人
    List employeeList = await _employeeDao.returnSearchResult(searchKey);
    if (employeeList.isNotEmpty) {
      Map map = new Map();
      map['name'] = '企业联系人';
      map['list'] = employeeList;

      resultList.add(map);
    }

    //分机联系人exSearchResult
    List exContactList = await _exContactDao.exSearchResult(searchKey);
    if (exContactList.isNotEmpty) {
      Map map = new Map();
      map['name'] = '分机联系人';
      map['list'] = exContactList;

      resultList.add(map);
    }

    //本机联系人
    List localContactList =
        await _localContactDao.returnSearchResult(searchKey);
    if (localContactList.isNotEmpty) {
      Map map = new Map();
      map['name'] = '本机联系人';
      map['list'] = localContactList;

      resultList.add(map);
    }

    searchResultList = [];
    searchResultList.addAll(resultList);
    cache[searchKey] = resultList;

    setIdle();
  }
}
