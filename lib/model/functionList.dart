/// {
//     "functionList": [
//         {
//             "code": "pstnCall",
//             "oid": 1,
//             "name": "PSTN呼叫",
//             "type": 1
//         },
//         {
//             "code": "voipCall",
//             "oid": 2,
//             "name": "VOIP呼叫",
//             "type": 1
//         },
//         {
//             "code": "voipAnswer",
//             "oid": 3,
//             "name": "VOIP接听",
//             "type": 1
//         },
//         {
//             "code": "customContacts",
//             "oid": 4,
//             "name": "企业通讯录",
//             "type": 1
//         },
//         {
//             "code": "innerContacts",
//             "oid": 5,
//             "name": "分机通讯录",
//             "type": 1
//         },
//         {
//             "code": "mobileContacts",
//             "oid": 6,
//             "name": "本机通讯录",
//             "type": 1
//         },
//         {
//             "code": "accountSwitch",
//             "oid": 7,
//             "name": "账号切换",
//             "type": 1
//         },
//         {
//             "code": "answerType",
//             "oid": 8,
//             "name": "接听方式",
//             "type": 1
//         },
//         {
//             "code": "innerManage",
//             "oid": 9,
//             "name": "分机管理",
//             "type": 1
//         },
//         {
//             "code": "addAddon",
//             "oid": 10,
//             "name": "增加分机时增加总机对应分钟数",
//             "type": 1
//         },
//         {
//             "code": "outerMinute",
//             "oid": 11,
//             "name": "剩余分钟数-总机",
//             "type": 1
//         },
//         {
//             "code": "innerMinute",
//             "oid": 12,
//             "name": "剩余分钟数-分机",
//             "type": 1
//         },
//         {
//             "code": "customInfoManage",
//             "oid": 13,
//             "name": "企业信息管理",
//             "type": 1
//         }
//     ]
// }

/// 用户功能权限

class PermissionData {
  String? _code;
  int? _oid;
  String? _name;
  int? _type;

  String? get code => _code;
  int? get oid => _oid;
  String? get name => _name;
  int? get type => _type;

  PermissionData({String? code, int? oid, String? name, int? type}) {
    _code = code;
    _oid = oid;
    _name = name;
    _type = type;
  }

  PermissionData.fromJson(dynamic json) {
    _code = json["code"];
    _oid = json["oid"];
    _name = json["name"];
    _type = json["type"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["oid"] = _oid;
    map["name"] = _name;
    map["type"] = _type;
    return map;
  }
}
