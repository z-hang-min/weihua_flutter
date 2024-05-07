import 'package:weihua_flutter/model/enterprise_address_book.dart';
import 'package:weihua_flutter/model/ex_contacts_result.dart';
import 'package:weihua_flutter/model/local_contact.dart';
import 'package:weihua_flutter/service/contact_repository.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';

///
/// @Desc: 主界面 联系人包装，用于显示UI如，主界面联系人列表
///
/// @Author: zhhli
///
/// @Date: 21/4/15
///
class ContactUIInfo with ISuspensionBean {
  static const String headTag = "↑";

  /// 姓名
  late String name;

  /// A~Z
  late String tagIndex;

  /// 姓名拼音
  late String pinyin;

  /// 号码
  late String phone = "";

  Color? bgColor;
  IconData? iconData;

  /// 图片URL
  String? img;

  /// 头像 文字
  late String firstLetter;

  /// 1  LocalContact
  /// 2  Employee
  /// 3  分机联系人
  /// 4  Enterprise
  /// 5  分机联系人title
  /// 6  类别分组 title
  late ContactType type;

  OtherTitleType? otherTitleType;

  dynamic data;

  @override
  String getSuspensionTag() {
    return tagIndex;
  }

  // String _getFirstLetter() {
  //   String result = "#";
  //   if (pinyin.isNotEmpty) {
  //     result = pinyin.substring(0, 1).toUpperCase();
  //   }
  //   return result;
  // }

  ContactUIInfo.fromEmployee(Employee employee) {
    phone = employee.phone;
    name = employee.name;
    pinyin = getPinyin(name);
    tagIndex = getTagIndex(pinyin);
    type = ContactType.employee;
    data = employee;
  }

  ContactUIInfo.fromLocalContact(LocalContact localContact) {
    name = localContact.name;
    phone = localContact.phone;
    pinyin = localContact.pinyin;
    tagIndex = localContact.tagIndex;
    type = ContactType.localContact;
    data = localContact;
  }

  ContactUIInfo.fromExContact(ExContact exContact) {
    name = exContact.userName;
    phone = exContact.mobile;
    pinyin = getPinyin(name);
    tagIndex = getTagIndex(pinyin);
    type = ContactType.exContact;
    data = exContact;
  }

  ContactUIInfo.fromEnterprise(Enterprise enterprise) {
    name = enterprise.name;
    phone = "组织架构";
    img = "contact_icon_enterprise.png";
    pinyin = StringUtils.getNospacePinyin(name);
    tagIndex = headTag;
    type = ContactType.other;
    otherTitleType = OtherTitleType.enterpriseTitle;
    data = enterprise;
  }

  ContactUIInfo.fromExContactTitle() {
    name = "企业分机";
    phone = "列表详情";
    img = "contact_icon_telephone.png";
    pinyin = headTag;
    tagIndex = headTag;
    type = ContactType.other;
    otherTitleType = OtherTitleType.exContactTitle;
    data = name;
  }

  /// 类别分组 title
  ContactUIInfo.fromTitle(String title) {
    name = title;
    pinyin = headTag;
    tagIndex = headTag;
    type = ContactType.other;
    otherTitleType = OtherTitleType.title;
    data = name;
  }
}

/// 联系人 类型
/// 1  LocalContact
/// 2  Employee
/// 3  分机联系人
///
enum ContactType { other, localContact, employee, exContact, unknownContact }

enum OtherTitleType {
  /// 普通类别分组 标题
  title,

  /// 企业分组标题
  enterpriseTitle,

  ///分机联系人title
  exContactTitle,
}
