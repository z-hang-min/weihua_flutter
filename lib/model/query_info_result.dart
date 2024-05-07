import 'functionList.dart';

/// admin : 0
/// customId : 10
/// customName : "糊涂Jonny"
/// functionList : [{"code":"pstnCall","name":"PSTN呼叫","oid":1,"type":1},{"code":"voipCall","name":"VOIP呼叫","oid":2,"type":1},{"code":"voipAnswer","name":"VOIP接听","oid":3,"type":1},{"code":"customContacts","name":"企业通讯录","oid":4,"type":1},{"code":"innerContacts","name":"分机通讯录","oid":5,"type":1},{"code":"mobileContacts","name":"本机通讯录","oid":6,"type":1},{"code":"accountSwitch","name":"账号切换","oid":7,"type":1},{"code":"answerType","name":"接听方式","oid":8,"type":1},{"code":"innerManage","name":"分机管理","oid":9,"type":1},{"code":"addAddon","name":"增加分机时增加总机对应分钟数","oid":10,"type":1},{"code":"outerMinute","name":"剩余分钟数-总机","oid":11,"type":1},{"code":"innerMinute","name":"剩余分钟数-分机","oid":12,"type":1},{"code":"customInfoManage","name":"企业信息管理","oid":13,"type":1}]
/// innerNumber : "1002"
/// innerNumberId : 60
/// mobile : "18811321040"
/// outerNumber : "95013744499"
/// outerNumberId : 10
/// rootPath : "http://39.97.232.211:8070/ipcboss"
/// rootPath2 : "http://39.97.232.211:8090/ipcboss"
/// serverIp : "39.97.232.211"
/// serverPort : 6080
/// sipId : "11100001072"
/// sipPwd : "KehKOIpR"
/// type : 1
/// typeImage : "http://39.97.232.211:8090/ipcboss/resources/images/dianhuaju/app/shangwuhao.png"
/// typeName : "微话"
/// userName : "李1002"

class QueryInfoResult {
  int? admin;
  int? customId;
  String? customName;
  List<PermissionData>? functionList;
  String? innerNumber;
  int? innerNumberId;
  String? mobile;
  String? outerNumber;
  int? outerNumberId;
  String? rootPath;
  String? rootPath2;
  String? serverIp;
  int? serverPort;
  String? sipId;
  String? sipPwd;
  int? type;
  String? typeImage;
  String? typeName;
  String? userName;

  QueryInfoResult(
      {this.admin,
      this.customId,
      this.customName,
      this.functionList,
      this.innerNumber,
      this.innerNumberId,
      this.mobile,
      this.outerNumber,
      this.outerNumberId,
      this.rootPath,
      this.rootPath2,
      this.serverIp,
      this.serverPort,
      this.sipId,
      this.sipPwd,
      this.type,
      this.typeImage,
      this.typeName,
      this.userName});

  QueryInfoResult.fromJson(dynamic json) {
    admin = json["admin"];
    customId = json["customId"];
    customName = json["customName"];
    if (json["functionList"] != null) {
      functionList = [];
      json["functionList"].forEach((v) {
        functionList?.add(PermissionData.fromJson(v));
      });
    }
    innerNumber = json["innerNumber"];
    innerNumberId = json["innerNumberId"];
    mobile = json["mobile"];
    outerNumber = json["outerNumber"];
    outerNumberId = json["outerNumberId"];
    rootPath = json["rootPath"];
    rootPath2 = json["rootPath2"];
    serverIp = json["serverIp"];
    serverPort = json["serverPort"];
    sipId = json["sipId"];
    sipPwd = json["sipPwd"];
    type = json["type"];
    typeImage = json["typeImage"];
    typeName = json["typeName"];
    userName = json["userName"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["admin"] = admin;
    map["customId"] = customId;
    map["customName"] = customName;
    if (functionList != null) {
      map["functionList"] = functionList?.map((v) => v.toJson()).toList();
    }
    map["innerNumber"] = innerNumber;
    map["innerNumberId"] = innerNumberId;
    map["mobile"] = mobile;
    map["outerNumber"] = outerNumber;
    map["outerNumberId"] = outerNumberId;
    map["rootPath"] = rootPath;
    map["rootPath2"] = rootPath2;
    map["serverIp"] = serverIp;
    map["serverPort"] = serverPort;
    map["sipId"] = sipId;
    map["sipPwd"] = sipPwd;
    map["type"] = type;
    map["typeImage"] = typeImage;
    map["typeName"] = typeName;
    map["userName"] = userName;
    return map;
  }
}
