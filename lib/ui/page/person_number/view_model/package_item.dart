/// locallen : 100
/// price : 10
/// record : 10
/// originalprice : 0
/// name : "微话开户套餐"
/// id : 1
/// inner : 10

class PackageItem {
  dynamic _locallen = 0;
  int _price = 0;
  dynamic _record = 0;
  int _originalprice = 0;
  String _name = '';
  dynamic _appgoodid = '';
  int _id = -1;
  dynamic _inner = 0;
  dynamic _sms = 0;
  dynamic _remark;
  dynamic _validtime = 0;
  int get locallen => _locallen == null ? 0 : _locallen;
  double get price => _price / 100;
  int get record => _record == null ? 0 : _record;
  int get originalprice => _originalprice;
  String get name => _name;

  String get appgoodid => _appgoodid;

  String get remark => _remark;
  int get sms => _sms;
  int get validtime => _validtime;
  int get id => _id;
  int get inner => _inner == null ? 0 : _inner;

  PackageItem(
      {int locallen = 0,
      int price = 0,
      int record = 20,
      int originalprice = 0,
      String name = '',
      String appgoodid = '',
      dynamic remark = '',
      int sms = 0,
      dynamic validtime = 0,
      int id = -1,
      int inner = 5}) {
    _locallen = locallen;
    _price = price;
    _record = record;
    _originalprice = originalprice;
    _name = name;
    _id = id;
    _inner = inner;
    _remark = remark;
    _sms = sms;
    _validtime = validtime;
  }

  PackageItem.fromJson(dynamic json) {
    _locallen = json["locallen"];
    _price = json["price"];
    _record = json["record"];
    _originalprice = json["originalprice"];
    _name = json["name"];
    _appgoodid = json['appgoodid'];
    _id = json["id"];
    _inner = json["inner"];
    _remark = json["remark"];
    _sms = json["sms"];
    _validtime = json["validtime"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["locallen"] = _locallen;
    map["price"] = _price;
    map["records"] = _record;
    map["originalprice"] = _originalprice;
    map["name"] = _name;
    map['appgoodid'] = _appgoodid;
    map["id"] = _id;
    map["inner"] = _inner;
    map["sms"] = _sms;
    map["validtime"] = _validtime;
    map["remark"] = _remark;
    return map;
  }
}
