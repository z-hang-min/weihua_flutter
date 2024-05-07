/// prepayid : "wx261537562180527f3ca0b92dd7ddbd0000"
/// appid : "wx1800eec586c4eb3f"
/// partnerid : "1607307782"
/// package : "Sign=WXPay"
/// noncestr : "cc82b738cf99c7884edccd772eacaf56"
/// timestamp : "1627285076"
/// sign : "F1D9ED7BFC2396D7BE8C36829955759C"

class WxPayOrder {
  String prepayid = '';
  String appid = '';
  String clientappid = '';
  String partnerid = '';
  String package = '';
  String clientpackage = '';
  String noncestr = '';
  String timestamp = '';
  String sign = '';

  WxPayOrder(
      {this.prepayid = '',
      this.appid = '',
      this.partnerid = '',
      this.package = '',
      this.noncestr = '',
      this.timestamp = '',
      this.clientpackage = '',
      this.clientappid = '',
      this.sign = ''});

  WxPayOrder.fromJson(dynamic json) {
    prepayid = json["prepayid"];
    appid = json["appid"];
    clientappid = json["clientappid"];
    clientpackage = json["clientpackage"];
    partnerid = json["partnerid"];
    package = json["package"];
    noncestr = json["noncestr"];
    timestamp = json["timestamp"];
    sign = json["sign"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["prepayid"] = prepayid;
    map["clientappid"] = clientappid;
    map["appid"] = appid;
    map["partnerid"] = partnerid;
    map["clientpackage"] = clientpackage;
    map["package"] = package;
    map["noncestr"] = noncestr;
    map["timestamp"] = timestamp;
    map["sign"] = sign;
    return map;
  }
}
