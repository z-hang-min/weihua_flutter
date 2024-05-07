class GetMyCalloutNumResult {
  Map _calloutNumList = {};

  Map get calloutNumList => _calloutNumList;

  GetMyCalloutNumResult({Map blackList = const {}}) {
    _calloutNumList = calloutNumList;
  }

  GetMyCalloutNumResult.fromJson(dynamic json) {
    _calloutNumList = json;
  }

  // Map<String, dynamic> toJson() {
  //   var map = <String, dynamic>{};
  //   map['items'] = _calloutNumList;
  //   return map;
  // }
}
