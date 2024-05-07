/// appId : "guizhoudianxin"
/// oid : 12
/// updateType : "1"
/// clientType : "1"
/// bussinessId : 3
/// downloadUrl : "http://39.97.252.66:8090/license/apk/guizhou_v1.1.1.apk"
/// desc : ["dd","ddd"]
/// version : "1.1.2"
/// update : true

class CheckUpdateResult {
  String? _appId;
  int? _oid;
  String? _updateType;
  String? _clientType;
  int? _bussinessId;
  String? _downloadUrl;
  List<String>? _desc;
  String? _version;
  bool? _update;

  String? get appId => _appId;
  int? get oid => _oid;
  String? get updateType => _updateType;
  String? get clientType => _clientType;
  int? get bussinessId => _bussinessId;
  String? get downloadUrl => _downloadUrl;
  List<String>? get desc => _desc;
  String? get version => _version;
  bool get update => _update ?? false;

  CheckUpdateResult(
      {String? appId,
      int? oid,
      String? updateType,
      String? clientType,
      int? bussinessId,
      String? downloadUrl,
      List<String>? desc,
      String? version,
      bool? update}) {
    _appId = appId;
    _oid = oid;
    _updateType = updateType;
    _clientType = clientType;
    _bussinessId = bussinessId;
    _downloadUrl = downloadUrl;
    _desc = desc;
    _version = version;
    _update = update;
  }

  CheckUpdateResult.fromJson(dynamic json) {
    _appId = json["appId"];
    _oid = json["oid"];
    _updateType = json["updateType"];
    _clientType = json["clientType"];
    _bussinessId = json["bussinessId"];
    _downloadUrl = json["downloadUrl"];
    _desc = json["desc"] != null ? json["desc"].cast<String>() : [];
    _version = json["version"];
    _update = json["update"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["appId"] = _appId;
    map["oid"] = _oid;
    map["updateType"] = _updateType;
    map["clientType"] = _clientType;
    map["bussinessId"] = _bussinessId;
    map["downloadUrl"] = _downloadUrl;
    map["desc"] = _desc;
    map["version"] = _version;
    map["update"] = _update;
    return map;
  }

  bool get forceUpdate => int.parse(updateType ?? '0') == 1;
}
