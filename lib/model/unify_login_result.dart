import 'package:weihua_flutter/model/user.dart';

/// numberList : [{"customName":"18801291412","sipId":"11100001016","sipPwd":"ojOPMP3a","innerNumberId":12,"innerNumber":"1000","outerNumberId":3,"outerNumber":"95013770008","admin":1,"customId":3,"userName":"分机1","mobile":"18801291412","serverIp":"39.97.232.211","serverPort":6080,"type":1,"typeName":"微话","typeImage":"http://39.97.232.211:8090/ipcboss/resources/images/dianhuaju/app/shangwuhao.png","rootPath":"http://39.97.232.211:8070/ipcboss","rootPath2":"http://39.97.232.211:8090/ipcboss","functionList":[{"code":"pstnCall","oid":1,"name":"PSTN呼叫","type":1},{"code":"voipCall","oid":2,"name":"VOIP呼叫","type":1},{"code":"voipAnswer","oid":3,"name":"VOIP接听","type":1},{"code":"customContacts","oid":4,"name":"企业通讯录","type":1},{"code":"innerContacts","oid":5,"name":"分机通讯录","type":1},{"code":"mobileContacts","oid":6,"name":"本机通讯录","type":1},{"code":"accountSwitch","oid":7,"name":"账号切换","type":1},{"code":"answerType","oid":8,"name":"接听方式","type":1},{"code":"innerManage","oid":9,"name":"分机管理","type":1},{"code":"addAddon","oid":10,"name":"增加分机时增加总机对应分钟数","type":1},{"code":"outerMinute","oid":11,"name":"剩余分钟数-总机","type":1},{"code":"innerMinute","oid":12,"name":"剩余分钟数-分机","type":1},{"code":"customInfoManage","oid":13,"name":"企业信息管理","type":1}]},{"customName":"18801291412","sipId":"11100001017","sipPwd":"ZgXsFC3h","innerNumberId":13,"innerNumber":"1001","outerNumberId":3,"outerNumber":"95013770008","admin":1,"customId":3,"userName":"分机","mobile":"18801291412","serverIp":"39.97.232.211","serverPort":6080,"type":1,"typeName":"微话","typeImage":"http://39.97.232.211:8090/ipcboss/resources/images/dianhuaju/app/shangwuhao.png","rootPath":"http://39.97.232.211:8070/ipcboss","rootPath2":"http://39.97.232.211:8090/ipcboss","functionList":[{"code":"pstnCall","oid":1,"name":"PSTN呼叫","type":1},{"code":"voipCall","oid":2,"name":"VOIP呼叫","type":1},{"code":"voipAnswer","oid":3,"name":"VOIP接听","type":1},{"code":"customContacts","oid":4,"name":"企业通讯录","type":1},{"code":"innerContacts","oid":5,"name":"分机通讯录","type":1},{"code":"mobileContacts","oid":6,"name":"本机通讯录","type":1},{"code":"accountSwitch","oid":7,"name":"账号切换","type":1},{"code":"answerType","oid":8,"name":"接听方式","type":1},{"code":"innerManage","oid":9,"name":"分机管理","type":1},{"code":"addAddon","oid":10,"name":"增加分机时增加总机对应分钟数","type":1},{"code":"outerMinute","oid":11,"name":"剩余分钟数-总机","type":1},{"code":"innerMinute","oid":12,"name":"剩余分钟数-分机","type":1},{"code":"customInfoManage","oid":13,"name":"企业信息管理","type":1}]}]
/// updatePwd : 0

class UnifyLoginResult {
  List<User> _numberList = [];
  int _updatePwd = 0;

  List<User> get numberList => _numberList;

  List<User> get perNumberList => getPerNumList();

  List<User> get companyNumberList => getCompanyNumList();

  int get updatePwd => _updatePwd;

  UnifyLoginResult({List<User> numberList = const [], int updatePwd = 0}) {
    _numberList = numberList;
    _updatePwd = updatePwd;
  }

  List<User> getPerNumList() {
    if (numberList.isEmpty) return [];
    return numberList.where((element) => element.numberType == 101).toList();
  }

  List<User> getCompanyNumList() {
    return numberList
        .where(
            (element) => element.numberType == 102 || element.numberType == 1)
        .toList();
  }

  UnifyLoginResult.fromJson(dynamic json) {
    if (json["numberList"] != null) {
      _numberList = [];
      json["numberList"].forEach((v) {
        _numberList.add(User.fromJson(v));
      });
    }
    _updatePwd = json["updatePwd"] ?? 0;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["numberList"] = _numberList.map((v) => v.toJson()).toList();
    map["updatePwd"] = _updatePwd;
    return map;
  }
}
