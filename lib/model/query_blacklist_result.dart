class QueryBlacklistResult {
  Map _blackMap = {};

  Map get blackListResult => _blackMap;

  QueryBlacklistResult({Map blackMap = const {}}) {
    _blackMap = blackMap;
  }

  QueryBlacklistResult.fromJson(dynamic json) {
    _blackMap = json;
  }

  // Map<String, dynamic> toJson() {
  //   var map = <String, dynamic>{};
  //   map['items'] = _blackMap;
  //   return map;
  // }
}
