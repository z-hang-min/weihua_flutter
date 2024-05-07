/// price : 10
/// limit : 10
/// validTime : 19993085550000

class WareInfoResult {
  WareInfoResult({
    String appgoodid = '',
    int price = 0,
    int limit = 0,
    int validTime = 0,
    int wareid = 0,
  }) {
    _appgoodid = appgoodid;
    _price = price;
    _limit = limit;
    _validTime = validTime;
    _wareid = wareid;
  }

  WareInfoResult.fromJson(dynamic json) {
    _appgoodid = json['appgoodid'];
    _price = json['price'];
    _limit = json['limit'];
    _validTime = json['validTime'];
    _wareid = json['wareid'];
  }
  String _appgoodid = '';
  int _price = 0;
  int _limit = 0;
  int _validTime = 0;
  int _wareid = 0;

  String get appgoodid => _appgoodid;

  double get price => _price / 100;
  int get limit => _limit;
  int get validTime => _validTime;
  int get wareid => _wareid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['appgoodid'] = appgoodid;
    map['price'] = _price;
    map['limit'] = _limit;
    map['validTime'] = _validTime;
    map['wareid'] = _wareid;
    return map;
  }
}
