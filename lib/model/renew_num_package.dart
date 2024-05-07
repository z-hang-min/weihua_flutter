/// number : "950133123772"
/// seckill : "1"
/// sells : 2
/// price : 1
/// name : "升级-套餐1"
/// validtime : 1668653193458

class ReNewNumPackage {
  ReNewNumPackage({
    String number = '',
    String seckill = '',
    String wareid = '',
    String appgoodid = '',
    int sells = 0,
    int price = 0,
    String name = '',
    int validtime = 0,
    int current = 0,
  }) {
    _number = number;
    _wareid = wareid;
    _appgoodid = appgoodid;
    _seckill = seckill;
    _sells = sells;
    _price = price;
    _name = name;
    _validtime = validtime;
    _current = current;
  }

  ReNewNumPackage.fromJson(dynamic json) {
    _number = json['number'];
    _seckill = json['seckill'];
    _wareid = json['wareid'];
    _appgoodid = json['appgoodid'];
    _sells = json['sells'];
    _price = json['price'];
    _name = json['name'];
    _validtime = json['validtime'];
    _current = json['current'];
  }
  String _number = '';
  String _seckill = '';
  String _wareid = '';
  dynamic _appgoodid = '';
  int _sells = 0;
  int _price = 0;
  String _name = '';
  int _validtime = 0;
  int _current = 0;

  String get number => _number;
  String get wareid => _wareid;
  String get appgoodid => _appgoodid;
  String get seckill => _seckill;
  double get sells => _sells / 100;
  double get price => _price / 100;
  String get name => _name;
  int get validtime => _validtime;
  int get current => _current;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['number'] = _number;
    map['wareid'] = _wareid;
    map['appgoodid'] = _appgoodid;
    map['seckill'] = _seckill;
    map['sells'] = _sells;
    map['price'] = _price;
    map['name'] = _name;
    map['validtime'] = _validtime;
    map['current'] = _current;
    return map;
  }
}
