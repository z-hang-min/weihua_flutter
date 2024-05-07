/// remainingTimes : 998

class SearchSendTimesResult {
  int _remainingTimes = 0;

  int get remainingTimes => _remainingTimes;

  SearchSendTimesResult({int remainingTimes = 0}) {
    _remainingTimes = remainingTimes;
  }

  SearchSendTimesResult.fromJson(dynamic json) {
    _remainingTimes = json["remainingTimes"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["remainingTimes"] = _remainingTimes;
    return map;
  }
}
