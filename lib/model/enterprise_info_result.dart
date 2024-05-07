// class AllNumberInfoResult {
//   String? number;
//   String? numberType;
//   String? businessName;
//   int? businessInfoId;

//   AllNumberInfoResult(
//       {this.number, this.numberType, this.businessName, this.businessInfoId});

//   AllNumberInfoResult.fromJson(Map<String, dynamic> json) {
//     number = json['number'];
//     numberType = json['numberType'];
//     businessName = json['businessName'];
//     businessInfoId = json['businessInfoId'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['number'] = this.number;
//     data['numberType'] = this.numberType;
//     data['businessName'] = this.businessName;
//     data['businessInfoId'] = this.businessInfoId;
//     return data;
//   }

//   @override
//   String toString() {
//     return 'AllNumberInfoResult{number: $number, numberType: $numberType, businessName: $businessName, businessInfoId: $businessInfoId}';
//   }
// }

class NumberInfo {
  // 0:审核中 1:审核通过 2:审核未通过
  List<BusinessInfos> businessInfos = [];
  String number = "";
  String? inner;
  String? numberType;
  String? customName;

  // (0:新建，1:审核通过 2:审核未通过，，3:认证完成)
  int? status;

  NumberInfo(
      {this.businessInfos = const [], this.number = "", this.numberType});

  NumberInfo.fromJson(Map<String, dynamic> json) {
    if (json['businessInfos'] != null) {
      businessInfos = [];
      json['businessInfos'].forEach((v) {
        businessInfos.add(new BusinessInfos.fromJson(v));
      });
    }
    number = json['number'] ?? "";
    inner = json['inner'];
    numberType = json['numberType'];
    customName = json['customName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessInfos'] =
        this.businessInfos.map((v) => v.toJson()).toList();
    data['number'] = this.number;
    data['inner'] = this.inner;
    data['numberType'] = this.numberType;
    data['customName'] = this.customName;
    data['status'] = this.status;
    return data;
  }

  bool isPersonNumber() {
    return numberType == "101";
  }

  bool isEnterpriseNumber() {
    return numberType == "102" || numberType == "1";
  }
}

class BusinessInfos {
  String businessName = "";
  int businessInfoId = -1;
  // 0:审核中 1:审核通过 2:审核未通过, 3:认证完成
  int status = 0;

  BusinessInfos(
      {this.businessName = "", this.businessInfoId = -1, this.status = 0});

  BusinessInfos.fromJson(Map<String, dynamic> json) {
    businessName = json['businessName'] ?? "";
    businessInfoId = json['businessInfoId'] ?? -1;
    status = json['status'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessName'] = this.businessName;
    data['businessInfoId'] = this.businessInfoId;
    data['status'] = this.status;
    return data;
  }

  /// 完成认证
  bool enableUse() {
    int i = status;
    return i == 1 || i == 3;
  }
}
