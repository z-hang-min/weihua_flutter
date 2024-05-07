class NotificationModelResult {
  int? totalCount = 0;
  int? pageSize;
  int? totalPage;
  int? currPage;
  List<NotificationTemple> dataList=[];

  NotificationModelResult(
      {this.totalCount,
      this.pageSize,
      this.totalPage,
      this.currPage,
      this.dataList= const []});

  NotificationModelResult.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    currPage = json['currPage'];
    if (json['list'] != null) {
      dataList = [];
      json['list'].forEach((v) {
        dataList.add(new NotificationTemple.fromJson(v));
        dataList.sort(
            (left, right) => left.createTime!.compareTo(right.createTime!));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['pageSize'] = this.pageSize;
    data['totalPage'] = this.totalPage;
    data['currPage'] = this.currPage;
    data['list'] = this.dataList.map((v) => v.toJson()).toList();
    return data;
  }
}

class NotificationTemple {
  String? createTime;
  String? templateName;
  String? templateContent;
  String? templateId = '';
  int? status;

  NotificationTemple(
      {this.createTime,
      this.templateName = '货物送达模板',
      this.templateContent = '天舟通信快递已经送到配送点，请及时领取',
      this.templateId = '',
      this.status});

  NotificationTemple.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    templateName = json['templateName'];
    templateContent = json['templateContent'];
    templateId = json['templateId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['templateName'] = this.templateName;
    data['templateContent'] = this.templateContent;
    data['templateId'] = this.templateId;
    data['status'] = this.status;
    return data;
  }
}
