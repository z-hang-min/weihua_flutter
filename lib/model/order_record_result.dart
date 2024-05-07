import 'package:weihua_flutter/model/order_record.dart';

/// totalCount : 6
/// pageSize : 20
/// totalPage : 1
/// currPage : 1
/// list : [{"id":974,"userId":170,"parentUserId":0,"number":"950133185186","price":1,"createTime":1628822536000,"status":0,"payTime":1628822548000,"tradeNo":"1851844322820210813104215905","remark":"购买号码950133185186","count":1,"payType":0,"userName":null,"parentUserName":null,"validTime":null,"validDays":null},{"id":972,"userId":170,"parentUserId":0,"number":"950133185185","price":1,"createTime":1628822496000,"status":1,"payTime":1628822514000,"tradeNo":"1851844322820210813104136253","remark":null,"count":null,"payType":null,"userName":null,"parentUserName":null,"validTime":null,"validDays":null},{"id":970,"userId":170,"parentUserId":0,"number":"950133185183","price":1,"createTime":1628822457000,"status":1,"payTime":1628822482000,"tradeNo":"1851844322820210813104056615","remark":null,"count":null,"payType":null,"userName":null,"parentUserName":null,"validTime":null,"validDays":null},{"id":968,"userId":170,"parentUserId":0,"number":"950133185182","price":1,"createTime":1628822191000,"status":1,"payTime":1628822204000,"tradeNo":"1851844322820210813103630933","remark":null,"count":null,"payType":null,"userName":null,"parentUserName":null,"validTime":null,"validDays":null},{"id":966,"userId":170,"parentUserId":0,"number":"950133185181","price":1,"createTime":1628822097000,"status":1,"payTime":1628822109000,"tradeNo":"1851844322820210813103456592","remark":null,"count":null,"payType":null,"userName":null,"parentUserName":null,"validTime":null,"validDays":null},{"id":904,"userId":170,"parentUserId":0,"number":"950133185185","price":1,"createTime":1628666089000,"status":0,"payTime":null,"tradeNo":"1851844322820210811151448858","remark":null,"count":null,"payType":null,"userName":null,"parentUserName":null,"validTime":null,"validDays":null}]

class OrderRecordResult {
  int _totalCount = 0;
  int _pageSize = 0;
  int _totalPage = 0;
  int _currPage = 0;
  List<OrderRecord> _list = [];

  int get totalCount => _totalCount;
  int get pageSize => _pageSize;
  int get totalPage => _totalPage;
  int get currPage => _currPage;
  List<OrderRecord>? get list => _list;

  OrderRecordResult(
      {required int totalCount,
      required int pageSize,
      required int totalPage,
      required int currPage,
      List<OrderRecord>? list}) {
    _totalCount = totalCount;
    _pageSize = pageSize;
    _totalPage = totalPage;
    _currPage = currPage;
    _list = list!;
  }

  OrderRecordResult.fromJson(dynamic json) {
    _totalCount = json["totalCount"];
    _pageSize = json["pageSize"];
    _totalPage = json["totalPage"];
    _currPage = json["currPage"];
    if (json["list"] != null) {
      _list = [];
      json["list"].forEach((v) {
        _list.add(OrderRecord.fromJson(v));
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
