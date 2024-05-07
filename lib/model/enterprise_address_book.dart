import 'package:weihua_flutter/db/base_db_bean.dart';

/// enterprise : {"enterpriseId":4,"name":"北京天舟通信有限公司"}
/// employees : [{"uId":2570,"name":"前端测试","phone":"13121769260","number95":"950137000","extNumber":"","position":"测试","enterpriseId":4,"orgId":1038,"orgName":"前端测试"},{"uId":2571,"name":"研发部门","phone":"18518443228","number95":"950137900","extNumber":"","position":"研发","enterpriseId":4,"orgId":1037,"orgName":"研发部门"}]

class EnterpriseAddressBook {
  Enterprise? enterprise;
  List<Employee>? employees;

  EnterpriseAddressBook({this.enterprise, this.employees});

  EnterpriseAddressBook.fromJson(dynamic json) {
    enterprise = json["enterprise"] != null
        ? Enterprise.fromJson(json["enterprise"])
        : null;
    if (json["employees"] != null) {
      employees = [];
      json["employees"].forEach((v) {
        employees?.add(Employee.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (enterprise != null) {
      map["enterprise"] = enterprise?.toJson();
    }
    if (employees != null) {
      map["employees"] = employees?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// uId : 2570
/// name : "前端测试"
/// phone : "13121769260"
/// number95 : "950137000"
/// extNumber : ""
/// position : "测试"
/// enterpriseId : 4
/// orgId : 1038
/// orgName : "前端测试"
class Employee extends BaseDbBean {
  // 数据库 用户标识
  String ownerId = "";
  int? uId = -1;
  String name = '';
  String phone = '';
  String number95 = '';
  String extNumber = '';
  String position = '';
  String pinyin = "";
  int? enterpriseId;
  int? orgId;
  String orgName = '';

  Employee(
      {this.uId,
      this.ownerId = "",
      this.name = '',
      this.pinyin = "",
      this.phone = '',
      this.number95 = '',
      this.extNumber = '',
      this.position = '',
      this.enterpriseId,
      this.orgId,
      this.orgName = ''});

  Employee.fromJson(dynamic json) {
    ownerId = json["ownerId"] ?? '';
    uId = json["uId"];
    name = json["name"] ?? '';
    phone = json["phone"] ?? '';
    number95 = json["number95"] ?? '';
    extNumber = json["extNumber"] ?? '';
    pinyin = json["pinyin"] ?? '';
    position = json["position"] ?? '';
    enterpriseId = json["enterpriseId"];
    orgId = json["orgId"];
    orgName = json["orgName"] ?? '';
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["ownerId"] = ownerId;
    map["uId"] = uId;
    map["name"] = name;
    map["pinyin"] = pinyin;
    map["phone"] = phone;
    map["number95"] = number95;
    map["extNumber"] = extNumber;
    map["position"] = position;
    map["enterpriseId"] = enterpriseId;
    map["orgId"] = orgId;
    map["orgName"] = orgName;
    return map;
  }
}

/// enterpriseId : 4
/// name : "北京天舟通信有限公司"

class Enterprise extends BaseDbBean {
  int enterpriseId = -1;
  int outerNumberId = -1;
  String name = '';
  // 数据库 用户标识
  String ownerId = '';

  Enterprise(
      {this.enterpriseId = -1,
      this.ownerId = '',
      this.outerNumberId = -1,
      this.name = ''});

  Enterprise.fromJson(dynamic json) {
    enterpriseId = json["enterpriseId"];
    outerNumberId = json["outerNumberId"];
    ownerId = json["ownerId"] ?? '';
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["enterpriseId"] = enterpriseId;
    map["outerNumberId"] = outerNumberId;
    map["ownerId"] = ownerId;
    map["name"] = name;
    return map;
  }
}
