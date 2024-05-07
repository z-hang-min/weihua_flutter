/// number : "9501312345"
/// sells : 800000
/// price : 500000
/// appgoodid : "onwernum.p18"
/// avg_price : "41666.00"
/// validtime : 1660631402130
/// avg_sells : "66666.67"
/// status : 0
class PerNumCheckResult {
  String? _number;
  int _sells = 0;
  int _price = 0;
  String _appgoodid = '0';
  String _avgPrice = '0';
  int? _validtime;
  String _avgSells = '0';
  int? _status;
  String _seckill = '0';

  String? get number => _number;

  double get sells => _sells / 100;

  double get price => _price / 100;

  String get appgoodid => _appgoodid;

  String get avgPrice => _avgPrice;

  int? get validtime => _validtime;

  String get avgSells => _avgSells;

  int? get status => _status;
  String get seckill => _seckill;

  PerNumCheckResult(
      {String? number,
      int sells = 0,
      int price = 0,
      String appgoodid = '0',
      String avgPrice = '0',
      int? validtime,
      String avgSells = '0',
      int? status,
      String seckill = "0"}) {
    _number = number;
    _sells = sells;
    _price = price;
    _appgoodid = appgoodid;
    _avgPrice = avgPrice;
    _validtime = validtime;
    _avgSells = avgSells;
    _status = status;
    _seckill = seckill;
  }

  PerNumCheckResult.fromJson(dynamic json) {
    _number = json["number"];
    _sells = json["sells"];
    _price = json["price"];
    _appgoodid = json["appgoodid"] ?? "0";
    _avgPrice = json["avg_price"];
    _validtime = json["validtime"];
    _avgSells = json["avg_sells"];
    _status = json["status"];
    _seckill = json["seckill"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["number"] = _number;
    map["sells"] = _sells;
    map["price"] = _price;
    map["appgoodid"] = _appgoodid;
    map["avg_price"] = _avgPrice;
    map["validtime"] = _validtime;
    map["avg_sells"] = _avgSells;
    map["status"] = _status;
    map["seckill"] = _seckill;
    return map;
  }
}
