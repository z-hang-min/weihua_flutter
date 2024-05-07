/// number : "1234"

class QueryDefaultOuterNumResult {
  String _number = "";

  String get number => _number;

  QueryDefaultOuterNumResult({required String number}) {
    _number = number;
  }

  QueryDefaultOuterNumResult.fromJson(dynamic json) {
    _number = json["number"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["number"] = _number;
    return map;
  }
}
