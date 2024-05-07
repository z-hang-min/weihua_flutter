import 'package:weihua_flutter/utils/time_util.dart';

class ExtensionResult {
  int? total;
  int? unused;
  List<ExtensionInfo>? extensionInfo;

  ExtensionResult({this.total, this.unused, this.extensionInfo});

  ExtensionResult.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    unused = json['unused'];
    if (json['rows'] != null) {
      extensionInfo = [];
      json['rows'].forEach((v) {
        extensionInfo!.add(new ExtensionInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['unused'] = this.unused;
    if (this.extensionInfo != null) {
      data['rows'] = this.extensionInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExtensionInfo {
  String? expiryDate;
  bool? def;
  String? expiryDateForm;
  String? number;
  String? orderId;
  String? mobile;
  int? active;
  int? oid;
  int? status;
  String? userName;

  ExtensionInfo(
      {this.expiryDate,
      this.def,
      this.expiryDateForm,
      this.number,
      this.orderId,
      this.mobile,
      this.active,
      this.oid,
      this.status,
      this.userName});

  ExtensionInfo.fromJson(Map<String, dynamic> json) {
    expiryDate = json['expiryDate'];
    def = json['def'];
    expiryDateForm =
        TimeUtil.formatTime2(int.parse(json['expiryDate'])).toString();
    number = json['number'];
    orderId = json['orderId'];
    mobile = json['mobile'];
    active = json['active'];
    oid = json['oid'];
    status = json['status'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expiryDate'] = this.expiryDate;
    data['def'] = this.def;
    data['number'] = this.number;
    data['orderId'] = this.orderId;
    data['mobile'] = this.mobile;
    data['active'] = this.active;
    data['oid'] = this.oid;
    data['status'] = this.status;
    data['userName'] = this.userName;
    return data;
  }
}
