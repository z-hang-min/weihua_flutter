/// transfer : 1

class QueryTransferResult {
  int _transfer = 0;

  int get transfer => _transfer;

  QueryTransferResult({int transfer = 0}) {
    _transfer = transfer;
  }

  QueryTransferResult.fromJson(dynamic json) {
    _transfer = json["transfer"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["transfer"] = _transfer;
    return map;
  }
}
