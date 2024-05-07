class LoginNumCancelResult {
  String? exist;

  LoginNumCancelResult({this.exist});

  LoginNumCancelResult.mock() {
    exist = "";
  }

  LoginNumCancelResult.fromJson(dynamic json) {
    exist = json["exist"].toString();
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["exist"] = exist;
    return map;
  }

  /// 账号被删除取消，不可用
  bool isCancel() {
    return "1" == exist;
  }
}
