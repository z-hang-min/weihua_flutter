class EnterpriseCertificationResult {
  Item? item;
  int? status;

  EnterpriseCertificationResult({this.item, this.status});

  EnterpriseCertificationResult.fromJson(Map<String, dynamic> json) {
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.item != null) {
      data['item'] = this.item!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Item {
  int? id;
  String? tel;
  String? businessName;
  String? businessId;
  String? businessLicense;
  String? contactName;
  String? contactMobile;
  String? remarks;
  int? status;
  String? reviewer;
  int? createTime;
  int? updateTime;
  Null statusStr;

  Item(
      {this.id,
      this.tel,
      this.businessName,
      this.businessId,
      this.businessLicense,
      this.contactName,
      this.contactMobile,
      this.remarks,
      this.status,
      this.reviewer,
      this.createTime,
      this.updateTime,
      this.statusStr});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tel = json['tel'];
    businessName = json['businessName'];
    businessId = json['businessId'];
    businessLicense = json['businessLicense'];
    contactName = json['contactName'];
    contactMobile = json['contactMobile'];
    remarks = json['remarks'];
    status = json['status'];
    reviewer = json['reviewer'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    statusStr = json['statusStr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tel'] = this.tel;
    data['businessName'] = this.businessName;
    data['businessId'] = this.businessId;
    data['businessLicense'] = this.businessLicense;
    data['contactName'] = this.contactName;
    data['contactMobile'] = this.contactMobile;
    data['remarks'] = this.remarks;
    data['status'] = this.status;
    data['reviewer'] = this.reviewer;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['statusStr'] = this.statusStr;
    return data;
  }
}
