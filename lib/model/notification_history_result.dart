class NotiHistoryResult {
  int? totalCount = 0;
  int? pageSize;
  int? totalPage;
  int? currPage;
  List<NotificationHistory> historyList = [];

  NotiHistoryResult(
      {this.totalCount,
      this.pageSize,
      this.totalPage,
      this.currPage,
      this.historyList = const []});

  NotiHistoryResult.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    pageSize = json['pageSize'];
    totalPage = json['totalPage'];
    currPage = json['currPage'];
    if (json['list'] != null) {
      historyList = [];
      json['list'].forEach((v) {
        historyList.add(new NotificationHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['pageSize'] = this.pageSize;
    data['totalPage'] = this.totalPage;
    data['currPage'] = this.currPage;
    data['list'] = this.historyList.map((v) => v.toJson()).toList();
    return data;
  }
}

class NotificationHistory {
  ///语音 0: 成功， 1： 失败， 2：未发送
  int? resultIVR;
  int? calleeCount;
  String? createTime;
  String? caller;
  String? callees;
  int? templateId;
  String? sendTemplateContent;
  String? sendTemplateTitle;

  ///短信 0: 成功， 1： 失败， 2：未发送
  int? resultMSG;

  NotificationHistory(
      {this.resultIVR,
      this.calleeCount,
      this.createTime,
      this.caller,
      this.callees,
      this.templateId,
      this.sendTemplateContent,
      this.sendTemplateTitle,
      this.resultMSG});

  NotificationHistory.fromJson(Map<String, dynamic> json) {
    resultIVR = json['resultIVR'];
    calleeCount = json['calleeCount'];
    List timeList = json['createTime'].split(' ');
    createTime =
        "${timeList[0].split('-')[0]}年${timeList[0].split('-')[1]}月${timeList[0].split('-')[2]}日 ${timeList[1]}";
    callees = json['callees'];
    caller = json['caller'];
    templateId = json['templateId'];
    sendTemplateContent = json['sendTemplateContent'];
    sendTemplateTitle = json['sendTemplateTitle'];
    resultMSG = json['resultMSG'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resultIVR'] = this.resultIVR;
    data['calleeCount'] = this.calleeCount;
    data['createTime'] = this.createTime;
    data['callees'] = this.callees;
    data['caller'] = this.caller;
    data['templateId'] = this.templateId;
    data['sendTemplateContent'] = this.sendTemplateContent;
    data['sendTemplateTitle'] = this.sendTemplateTitle;
    data['resultMSG'] = this.resultMSG;
    return data;
  }
}
