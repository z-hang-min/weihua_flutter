import 'dart:convert';

import 'package:weihua_flutter/db/db_core.dart';
import 'package:weihua_flutter/db/enterprise_address_book_dao.dart';
import 'package:weihua_flutter/db/ex_contact_dao.dart';
import 'package:weihua_flutter/db/local_contact_dao.dart';
import 'package:weihua_flutter/event/call_list_refresh_event.dart';
import 'package:weihua_flutter/model/enterprise_address_book.dart';
import 'package:weihua_flutter/model/ex_contacts_result.dart';
import 'package:weihua_flutter/model/local_contact.dart';
import 'package:weihua_flutter/utils/custom_transcoding.dart';
import 'package:weihua_flutter/utils/file_storage_utils.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:weihua_flutter/utils/time_util.dart';
// import 'package:flutter_contact/contacts.dart';

import 'event_bus.dart';

///
/// @Desc: 联系人数据
///
/// @Author: zhhli
///
/// @Date: 2021/4/14
ContactRepository contactRepo = ContactRepository.getInstance();
bool readNativeRunning = false;

class ContactRepository {
  static ContactRepository? _reps;

  static ContactRepository getInstance() {
    if (null == _reps) _reps = ContactRepository._();
    return _reps!;
  }

  ContactRepository._();

  /// 联系人插件服务
  // ContactService _contactService = UnifiedContacts;

  LocalContactDao _localContactDao = dbCore.localContactDao;
  EmployeeDao _employeeDao = dbCore.employeeDao;
  ExContactDao _exContactDao = dbCore.exContactDao;

  /// 企业通讯录--->分机--->本机通讯录
  Future<Map> findName(String number) async {
    Map contactMap = Map();
    contactMap['name'] = number;
    contactMap['realName'] = '';
    contactMap['contactType'] = '0';
    Employee? employee = await _employeeDao.getEmployee(number);
    if (employee != null) {
      contactMap['name'] = employee.name;
      contactMap['realName'] = employee.name;
      contactMap['contactType'] = '1';
      return contactMap;
    }

    ExContact? exContact = await _exContactDao.getExContact(number);
    if (exContact != null) {
      contactMap['name'] = exContact.userName;
      contactMap['realName'] = exContact.userName;
      contactMap['contactType'] = '2';
      return contactMap;
    }

    LocalContact? localContact = await _localContactDao.getLocalContact(number);
    if (localContact != null) {
      contactMap['name'] = localContact.name;
      contactMap['realName'] = localContact.name;
      contactMap['contactType'] = '3';
      return contactMap;
    }

    return contactMap;
  }

  /// 通过原生 读取本机联系人 返回 false，表示读取结束
  Stream<bool> loadNativeContacts() async* {
    // var startTime = currentTimeMillis();
    //
    // // 是否空表
    // bool isEmptyTable = await _localContactDao.isEmpty();
    //
    // List<LocalContact> list = [];
    //
    // final contacts = _contactService.listContacts(
    //     withUnifyInfo: false,
    //     withThumbnails: false,
    //     withHiResPhoto: false,
    //     sortBy: ContactSortOrder.firstName());
    //
    // while (await contacts.moveNext()) {
    //   Contact? contact = await contacts.current;
    //   if (contact == null) {
    //     continue;
    //   }
    //
    //   List<LocalContact> temp = contact.map2LocalContact();
    //   list.addAll(temp);
    //
    //   Log.d(
    //       "isEmptyTable $isEmptyTable：${list.length}  ${list.length % 100 == 0}");
    //
    //   // 判读，发送数据
    //   if (isEmptyTable) {
    //     if (list.length == 20 || list.length % 100 == 0) {
    //       // 先加载部分
    //       Log.e("先加载部分 手机 读取联系人 ${list.length}======");
    //       // 此处还可以优化，只插入新加载的
    //       _localContactDao.replaceAll(list);
    //       yield true;
    //     }
    //   }
    // }
    //
    // final fileName = 'oldLocalContactsData.txt';
    //
    // // 检查本地联系人缓存文件是否需要更新
    // String encodeStr =
    //     SHCustomTranscoding.encodeStringWithChineseTranscode(json.encode(list));
    // String oldEncodeStr = "";
    //
    // bool exist = await SHFileStorageUtils.isFileExist(fileName);
    // if (!exist) {
    //   // 不存在，则保存数据
    //   await SHFileStorageUtils.saveString(encodeStr, fileName);
    //   // 排序 A-Z sort.
    //   // SuspensionUtil.sortListBySuspensionTag(list);
    //   await _localContactDao.replaceAll(list);
    //   Log.d("通讯录 首次保存数据库 ");
    // } else {
    //   oldEncodeStr = await SHFileStorageUtils.getFileString(fileName);
    //   bool need = encodeStr != oldEncodeStr || oldEncodeStr.isEmpty;
    //   Log.d("通讯录 是否更新数据库 $need");
    //
    //   if (need) {
    //     // 更新保存数据
    //     await SHFileStorageUtils.saveString(encodeStr, fileName);
    //     // 排序 A-Z sort.
    //     // SuspensionUtil.sortListBySuspensionTag(list);
    //
    //     await _localContactDao.replaceAll(list);
    //   }
    // }
    //
    // Log.d("加载 NativeContacts 数据总耗时"
    //     " ${currentTimeMillis() - startTime} 毫秒；"
    //     "联系人总数： ${list.length}");
    // // 结束
    // readNativeRunning = false;
    // eventBus.fire(CallListRefreshEvent(true));
    yield false;
  }

  Future<bool> isExContact(String number) async {
    ExContact? exContact = await _exContactDao.getExContact(number);
    if (exContact != null) {
      return true;
    }
    return false;
  }

  /// 新建联系人
  Future<LocalContact?> insertContact(String number) async {
    // Item item = Item(label: '电话号码', value: number);
    // Contact contactData = Contact(
    //   phones: [item],
    // );
    //
    // Contact? contact = await Contacts.openContactInsertForm(contactData);
    // List<LocalContact> list = contact?.map2LocalContact() ?? [];
    //
    // if (list.isNotEmpty) {
    //   LocalContact localContact = list[0];
    //   bool success = await _localContactDao.save(localContact);
    //   // 判断操作过程中，保存的是否是 传入的号码
    //   success = success && (number == localContact.phone);
    //   return success ? localContact : null;
    // }

    return null;
  }

  /// 编辑成功，返回 number 对应的联系人
  /// 若编辑过程中，number被修改，则返回 null
  Future<LocalContact?> editContact(LocalContact data, String number) async {
    // Contact? contact =
    //     await _contactService.openContactEditForm(data.identifier);
    // List<LocalContact> list = contact?.map2LocalContact() ?? [];
    //
    // if (list.isEmpty) {
    //   // 未保存成功
    //   return null;
    // } else {
    //   LocalContact? result;
    //   bool isInList = false;
    //   for (LocalContact localContact in list) {
    //     bool same = number == localContact.phone;
    //
    //     bool success = await _localContactDao.save(localContact);
    //     // 判断操作过程中，保存的是否是 传入的号码
    //     success = success && same;
    //     result = success ? localContact : null;
    //
    //     // 检查 原来的号码是否被删除
    //     isInList = isInList || data.phone == localContact.phone;
    //   }
    //
    //   if (!isInList) {
    //     await _localContactDao.delete(data.phone);
    //     Log.e("删除  ${data.toJson()}");
    //   }
    //
    //   return result;
    // }
  }
}

// extension ContactExt on Contact {
//   /// givenName/first 教名/首名 等同于first name是名，教名。如字面意思，父母或者教父给起的名字。
//   /// middleName 是名和姓之间的名字，是父母或亲戚所取，一般取长者的名或姓。
//   /// familyName/lastName/surname 姓 姓氏,家族名FAMILY是家庭的意思，姓是家庭共有的，可以这样理解。
//   /// firstname/givenname/thepersonelname/christianname+middlename+lastname/familyname/surname=full name
//   ///
//   /// 译文：教名、首名+中间名+姓氏=全名
//   String getName() {
//     // String familyNameStr = familyName.isNullOrEmpty ? '' : familyName;
//     // String givenNameStr = givenName.isNullOrEmpty ? '' : givenName;
//     String familyNameStr = familyName ?? '';
//     String givenNameStr = givenName ?? '';
//
//     if (familyNameStr == givenNameStr) familyNameStr = '';
//     String nameStr = displayName ?? '';
//     nameStr = nameStr.isEmpty ? (familyNameStr + givenNameStr) : nameStr;
//
//     return nameStr;
//   }
//
//   /// 去除 空格， 86开头
//   String formatPhone(String numberStr) {
//     String str = numberStr.replaceAll(" ", "");
//     str = numberStr.replaceAll("-", "");
//     str = str.replaceFirst("+86", "");
//
//     return str;
//   }
//
//   List<LocalContact> map2LocalContact() {
//     List<LocalContact> list = [];
//
//     LocalContact localContact = LocalContact();
//
//     localContact.identifier = identifier ?? "";
//     // localContact.phone = contact.getPhone();
//     localContact.name = getName();
//     localContact.pinyin = getPinyin(localContact.name);
//
//     localContact.tagIndex = getTagIndex(localContact.pinyin);
//
//     if (phones.isNotEmpty) {
//       // 处理多个号码
//       for (var item in phones) {
//         // 复制 新的
//         LocalContact tempLocal =
//             LocalContact.fromJson(json.decode(json.encode(localContact)));
//         tempLocal.phone = formatPhone(item.value!.replaceAll(' ', ''));
//
//         if (tempLocal.name.isEmpty) {
//           // 名字 空
//           tempLocal.name = tempLocal.phone;
//           localContact.pinyin = getPinyin(tempLocal.name);
//         }
//
//         list.add(tempLocal);
//
//         Log.d("手机 读取联系人 ：${localContact.toJson()}");
//       }
//     }
//
//     return list;
//   }
// }

const Tag = "#";
final tagReg = RegExp("[A-Z]");

/// 获取 pinyin, 不是 [A-Z] 开头，则 { + pinyin, { > z
String getPinyin(String name) {
  if (name.isEmpty) {
    name = "#";
  }
  String pinyin = StringUtils.getNospacePinyin(name);

  String tag = pinyin.substring(0, 1).toUpperCase();
  if (tagReg.hasMatch(tag)) {
    // "[A-Z]"
    return pinyin;
  } else {
    return "{" + pinyin;
  }
}

String getTagIndex(String pinyin) {
  if (pinyin.isEmpty) {
    return "#";
  }

  String tag = pinyin.substring(0, 1).toUpperCase();

  if (tagReg.hasMatch(tag)) {
    // "[A-Z]"
    return tag;
  } else {
    return "#";
  }
}
