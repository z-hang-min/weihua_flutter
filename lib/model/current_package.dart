/// addon : 100
/// record : 10
/// name : "微话开户套餐"
/// validTime : "2022-09-14"
/// inner : 10

class CurrentPackage {
  int _addon = 0;
  int _record = 0;
  String _name = '';
  int _validTime = 0;
  int _inner = 0;

  int get addon => _addon;
  int get record => _record;
  String get name => _name;
  int get validTime => _validTime;
  int get inner => _inner;

  CurrentPackage(
      {int addon = 0,
      int record = 0,
      String name = '',
      int validTime = 0,
      int inner = 0}) {
    _addon = addon;
    _record = record;
    _name = name;
    _validTime = validTime;
    _inner = inner;
  }

  CurrentPackage.fromJson(dynamic json) {
    _addon = json["addon"];
    _record = json["record"];
    _name = json["name"];
    _validTime = json["validTime"];
    _inner = json["inner"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["addon"] = _addon;
    map["record"] = _record;
    map["name"] = _name;
    map["validTime"] = _validTime;
    map["inner"] = _inner;
    return map;
  }
}
