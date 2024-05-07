/// totalCount : 2
/// pageSize : 10
/// totalPage : 1
/// currPage : 1
/// list : [{"failCount":2,"createTime":"2021年09月16日","successCount":4,"totalCount":6},{"failCount":0,"createTime":"2021年09月15日","successCount":1,"totalCount":1}]

class RecordDetailListResult {
  int _totalCount = 0;
  int _pageSize = 0;
  int _totalPage = 0;
  int _currPage = 0;
  List<RecordDetail> _list = [];

  int get totalCount => _totalCount;
  int get pageSize => _pageSize;
  int get totalPage => _totalPage;
  int get currPage => _currPage;
  List<RecordDetail> get list => _list;

  RecordDetailListResult(
      {int totalCount = 0,
      int pageSize = 0,
      int totalPage = 0,
      int currPage = 0,
      required List<RecordDetail> list}) {
    _totalCount = totalCount;
    _pageSize = pageSize;
    _totalPage = totalPage;
    _currPage = currPage;
    _list = list;
  }

  RecordDetailListResult.fromJson(dynamic json) {
    _totalCount = json["totalCount"];
    _pageSize = json["pageSize"];
    _totalPage = json["totalPage"];
    _currPage = json["currPage"];
    if (json["list"] != null) {
      _list = [];
      json["list"].forEach((v) {
        _list.add(RecordDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["totalCount"] = _totalCount;
    map["pageSize"] = _pageSize;
    map["totalPage"] = _totalPage;
    map["currPage"] = _currPage;
    map["list"] = _list.map((v) => v.toJson()).toList();
    return map;
  }
}

/// failCount : 2
/// createTime : "2021年09月16日"
/// successCount : 4
/// totalCount : 6

class RecordDetail {
  int _failCount = 0;
  String _createTime = '';
  int _successCount = 0;
  int _total = 0;

  int get failCount => _failCount;
  String get createTime => _createTime;
  int get successCount => _successCount;
  int get total => _total;

  RecordDetail(
      {int failCount = 0,
      String createTime = '',
      int successCount = 0,
      int totalCount = 0}) {
    _failCount = failCount;
    _createTime = createTime;
    _successCount = successCount;
    _total = totalCount;
  }

  RecordDetail.fromJson(dynamic json) {
    _failCount = json["failCount"];
    _createTime = json["createTime"];
    _successCount = json["successCount"];
    _total = json["total"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["failCount"] = _failCount;
    map["createTime"] = _createTime;
    map["successCount"] = _successCount;
    map["total"] = _total;
    return map;
  }
}
