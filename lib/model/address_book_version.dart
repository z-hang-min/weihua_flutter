/// 通讯录版本
///
///  v1是企业通讯录
///
///  v2是分机通讯录
class AddressBookVersion {
  int oid = 0;

  ///  v1是企业通讯录
  late int v1;

  /// v2是分机通讯录
  late int v2;
  late String customName;

  AddressBookVersion(
      {this.customName = "", this.oid = -1, this.v1 = -1, this.v2 = -1});

  AddressBookVersion.mock() {
    oid = -1;
    customName = '';
    v1 = -1;
    v2 = -1;
  }

  AddressBookVersion.fromJson(dynamic json) {
    oid = json["oid"];
    v1 = json["v1"];
    v2 = json["v2"];
    customName = json["customName"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["oid"] = oid;
    map["v1"] = v1;
    map["v2"] = v2;
    map["customName"] = customName;
    return map;
  }

  @override
  String toString() {
    return 'AddressBookVersion{oid: $oid, v1: $v1, v2: $v2, customName: $customName}';
  }
}
