import 'package:weihua_flutter/utils/string_utils.dart';

import 'functionList.dart';

class User {
  String? _customName;
  String? _address;
  String? _sipId;
  String? _sipPwd;
  int? _innerNumberId;
  int? _numberType;

  /// 分机号
  String? _innerNumber;
  int? _outerNumberId;

  /// 外显号码（总机号，或者特殊设置的外形号码）
  String? _outerNumber;
  int? _admin;
  int? _customId;
  String? _userName;
  String? _mobile;
  String? _serverIp;
  int? _serverPort;
  int? _type;
  String? _typeName;
  String? _typeImage;
  String? _rootPath;
  String? _rootPath2;
  List<PermissionData> _functionList = [];

  String? get customName => _customName;

  String? get address => _address;

  String? get sipId => _sipId;

  String? get sipPwd => _sipPwd;

  int? get innerNumberId => _innerNumberId;

  int? get numberType => _numberType;

  String? get innerNumber => _innerNumber;

  int get outerNumberId => _outerNumberId ?? -1;

  String? get outerNumber => _outerNumber;
  String? get outerNumber2 => StringUtils.get95WithSpace(outerNumber!);

  String? get number => getNum();

  int? get admin => _admin;

  int? get customId => _customId;

  String? get userName => _userName;

  String? get mobile => _mobile;

  String? get serverIp => _serverIp;

  int? get serverPort => _serverPort;

  int? get type => _type;

  String? get typeName => _typeName;

  String? get typeImage => _typeImage;

  String? get rootPath => _rootPath;

  String? get rootPath2 => _rootPath2;

  List<PermissionData> get functionList => _functionList;

// set 方法
  set mobile(value) {
    this._mobile = value;
  }

  set functionList(value) {
    this._functionList = value;
  }

  String? getNum() {
    if (numberType == 1 || numberType == 102)
      return outerNumber2! + innerNumber!;
    return outerNumber2;
  }

  User.mockData()
      : _serverIp = "777",
        _userName = "name",
        _mobile = "18811321020",
        _sipId = "123123",
        _sipPwd = "123456",
        _outerNumber = "965535",
        _type = 1,
        _rootPath2 = "1";

  User.fromJson(dynamic json) {
    _customName = json["customName"];
    _address = json["address"];
    _sipId = json["sipId"];
    _sipPwd = json["sipPwd"];
    _innerNumberId = json["innerNumberId"];
    _numberType = json["numberType"];
    _innerNumber = json["innerNumber"];
    _outerNumberId = json["outerNumberId"];
    _outerNumber = json["outerNumber"];
    _admin = json["admin"];
    _customId = json["customId"];
    _userName = json["userName"];
    _mobile = json["mobile"];
    _serverIp = json["serverIp"];
    _serverPort = json["serverPort"];
    _type = json["type"];
    _typeName = json["typeName"];
    _typeImage = json["typeImage"];
    _rootPath = json["rootPath"];
    _rootPath2 = json["rootPath2"];
    if (json["functionList"] != null) {
      _functionList = [];
      json["functionList"].forEach((v) {
        _functionList.add(PermissionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["customName"] = _customName;
    map["address"] = _address;
    map["sipId"] = _sipId;
    map["sipPwd"] = _sipPwd;
    map["innerNumberId"] = _innerNumberId;
    map["numberType"] = _numberType;
    map["innerNumber"] = _innerNumber;
    map["outerNumberId"] = _outerNumberId;
    map["outerNumber"] = _outerNumber;
    map["admin"] = _admin;
    map["customId"] = _customId;
    map["userName"] = _userName;
    map["mobile"] = _mobile;
    map["serverIp"] = _serverIp;
    map["serverPort"] = _serverPort;
    map["type"] = _type;
    map["typeName"] = _typeName;
    map["typeImage"] = _typeImage;
    map["rootPath"] = _rootPath;
    map["rootPath2"] = _rootPath2;
    map["functionList"] = _functionList.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  String toString() {
    return 'User{_customName: $_customName,_address:$_address, _sipId: $_sipId, _sipPwd: $_sipPwd, _innerNumberId: $_innerNumberId, _numberType: $_numberType, _innerNumber: $_innerNumber, _outerNumberId: $_outerNumberId, _outerNumber: $_outerNumber, _admin: $_admin, _customId: $_customId, _userName: $_userName, _mobile: $_mobile, _serverIp: $_serverIp, _serverPort: $_serverPort, _type: $_type, _typeName: $_typeName, _typeImage: $_typeImage, _rootPath: $_rootPath, _rootPath2: $_rootPath2}';
  }
}
