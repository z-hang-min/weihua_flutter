import 'package:weihua_flutter/db/base_db_bean.dart';
import 'package:weihua_flutter/utils/string_utils.dart';

/// innerNumberList : [{"userName":"分机1","mobile":"18518443228","number":"1000"}]

class ExContactsResult {
  List<ExContact>? _innerNumberList;

  List<ExContact>? get innerNumberList => _innerNumberList;

  ExContactsResult({List<ExContact>? innerNumberList}) {
    _innerNumberList = innerNumberList;
  }

  ExContactsResult.fromJson(dynamic json) {
    if (json["innerNumberList"] != null) {
      _innerNumberList = [];
      json["innerNumberList"].forEach((v) {
        _innerNumberList?.add(ExContact.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_innerNumberList != null) {
      map["innerNumberList"] =
          _innerNumberList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// 分机联系人
/// userName : "分机1"
/// mobile : "18518443228"
/// number : "1000"
class ExContact extends BaseDbBean {
  String userName = "";
  String pinyin = "";
  String mobile = "";
  String number = "";
  String ownerId = "";

  @override
  String toString() {
    return 'ExContact{userName: $userName, pinyin: $pinyin, mobile: $mobile, number: $number, ownerId: $ownerId}';
  }

  ExContact(
      {this.userName = "",
      this.pinyin = "",
      this.mobile = "",
      this.ownerId = "",
      this.number = ""});

  ExContact.fromJson(dynamic json) {
    userName = json["userName"];
    pinyin = json["pinyin"] ?? StringUtils.getNospacePinyin(userName);
    mobile = json["mobile"];
    number = json["number"];
    ownerId = json["ownerId"] ?? '';
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["userName"] = userName;
    map["pinyin"] = pinyin;
    map["mobile"] = mobile;
    map["number"] = number;
    map["ownerId"] = ownerId;
    return map;
  }
}
