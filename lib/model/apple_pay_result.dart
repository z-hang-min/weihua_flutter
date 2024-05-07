class GetapplepayordertResult {
  Map _applepayorder = {};

  Map get applepayorder => _applepayorder;

  GetapplepayordertResult({Map blackMap = const {}}) {
    _applepayorder = blackMap;
  }

  GetapplepayordertResult.fromJson(dynamic json) {
    _applepayorder = json;
  }
}
