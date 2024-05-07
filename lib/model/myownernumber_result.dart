class QueryMynumberlistResult {
  List _mynumnerList = [];

  List get mynumnerList => _mynumnerList;

  QueryMynumberlistResult({List mynumnerList = const []}) {
    _mynumnerList = mynumnerList;
  }

  QueryMynumberlistResult.fromJson(dynamic json) {
    _mynumnerList = json["tSalesNumberReturnApplets"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['tSalesNumberReturnApplets'] = _mynumnerList;
    return map;
  }
}
