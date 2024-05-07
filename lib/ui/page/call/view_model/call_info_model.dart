import 'package:weihua_flutter/db/call_record_dao.dart';
import 'package:weihua_flutter/db/call_record_item_dao.dart';
import 'package:weihua_flutter/db/db_core.dart';
import 'package:weihua_flutter/db/enterprise_address_book_dao.dart';
import 'package:weihua_flutter/db/ex_contact_dao.dart';
import 'package:weihua_flutter/event/call_list_refresh_event.dart';
import 'package:weihua_flutter/model/call_record.dart';
import 'package:weihua_flutter/model/enterprise_address_book.dart';
import 'package:weihua_flutter/model/ex_contacts_result.dart';
import 'package:weihua_flutter/model/local_contact.dart';
import 'package:weihua_flutter/provider/view_state_refresh_list_model.dart';
import 'package:weihua_flutter/service/event_bus.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';

///
/// @Desc: 通话详情
/// @Author: zhhli
/// @Date: 2021-04-11
///
class CallInfoModel extends ViewStateRefreshListModel {
  CallRecordDao _dao = DbCore.getInstance().callRecordDao;
  CallRecordItemDao _itemDao = DbCore.getInstance().callRecordItemDao;

  CallRecord record;

  // 是否是分机号
  bool isExNumber = false;

  // 号码表示，显示为手机归属地、分机号、空
  String numberSubTitle = '';

  CallInfoModel(this.record) {
    numberSubTitle = record.region;

    if (record.contactType == "2") {
      _findExHasExNumber();
    }

    if (record.contactType == "1") {
      _findEmHasExNumber();
    }
  }

  Future _findEmHasExNumber() async {
    EmployeeDao dao = DbCore.getInstance().employeeDao;
    Employee? employee = await dao.getEmployee(record.number);
    if (employee != null && record.number == employee.extNumber) {
      isExNumber = true;
      numberSubTitle = '分机号';
      notifyListeners();
    }
  }

  Future _findExHasExNumber() async {
    ExContactDao dao = DbCore.getInstance().exContactDao;
    ExContact? exContact = await dao.getExContact(record.number);
    if (exContact != null && record.number == exContact.number) {
      isExNumber = true;
      numberSubTitle = '分机号';
      notifyListeners();
    }
  }

  @override
  Future<List> loadData({int pageNum = 0}) async {
    pageSize = 8;
    int start = pageSize * pageNum;
    List<CallRecord> list =
        await _itemDao.pageSameNumberList(record.number, start, pageSize);
    list.add(record);
    return list;
  }

  String getName() {
    return record.name;
  }

  String getTitleName() {
    String name = getName();
    return name.substring(name.length - 1);
  }

  Future<void> deleteRecord() async {
    Map<String, Object> map = Map();
    map["number"] = record.number;
    await _dao.deleteItem(map: map);
    await _itemDao.deleteItem(map: map);

    eventBus.fire(CallListRefreshEvent(true));
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

  void updateName(LocalContact contact) {
    record.name = contact.name;
    notifyListeners();
    eventBus.fire(CallListRefreshEvent(true));
  }
}
