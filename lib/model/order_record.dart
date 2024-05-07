import 'package:weihua_flutter/utils/time_util.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/material.dart';

/// id : 904
/// userId : 170
/// parentUserId : 0
/// number : "950133185185"
/// price : 1
/// createTime : 1628666089000
/// status : 0
/// payTime : null
/// tradeNo : "1851844322820210811151448858"
/// remark : null
/// count : null
/// payType : null
/// userName : null
/// parentUserName : null
/// validTime : null
/// validDays : null

class OrderRecord {
  int? _id;
  int? _userId;
  int? _parentUserId;
  String? _number;
  int? _price;
  int? _createTime;
  int? _status; //0 未支付；1 支付成功；2 支付失败；3 线下支付
  dynamic _payTime = '0';
  String? _tradeNo;
  dynamic _remark = '';
  dynamic _count = 1;
  dynamic _payType = 0; //payType,支付方式，0：微信，1：苹果支付
  dynamic _userName = '';
  dynamic _parentUserName;
  dynamic _validTime;
  dynamic _validDays;

  int? get id => _id;

  int? get userId => _userId;

  int? get parentUserId => _parentUserId;

  String? get number => _number;

  double? get price => (_price! / 100).toDouble();

  int? get createTime => _createTime;

  int? get status => _status;

  dynamic get payTime => _payTime;

  String? get tradeNo => _tradeNo;

  dynamic get remark => _remark;

  dynamic get count => _count;

  dynamic get payType => _payType;

  dynamic get userName => _userName;

  dynamic get parentUserName => _parentUserName;

  dynamic get validTime => _validTime;

  dynamic get validDays => _validDays;

  OrderRecord(
      {int? id,
      int? userId,
      int? parentUserId,
      String? number,
      int? price,
      int? createTime,
      int? status,
      dynamic payTime,
      String? tradeNo,
      dynamic remark,
      dynamic count,
      dynamic payType,
      dynamic userName,
      dynamic parentUserName,
      dynamic validTime,
      dynamic validDays}) {
    _id = id;
    _userId = userId;
    _parentUserId = parentUserId;
    _number = number;
    _price = price;
    _createTime = createTime;
    _status = status;
    _payTime = payTime;
    _tradeNo = tradeNo;
    _remark = remark;
    _count = count;
    _payType = payType;
    _userName = userName;
    _parentUserName = parentUserName;
    _validTime = validTime;
    _validDays = validDays;
  }

  String getPayType() {
    if (_payType == 1) return '苹果支付';
    return '微信';
  }

  String getPayTime() {
    if (_payTime == null) return '';
    return TimeUtil.formatTime(_payTime);
  }

  String getPayStatus() {
    if (_status == 0 || _status == 2) return '未支付';
    if (_status == 1 || _status == 3 || _status == 4) return '已支付';
    return '未支付';
  }

  double getTotalPrice() {
    if (_count != null && _price != null) {
      return _count * price;
    }
    return 0;
  }

  String getOrderStatus() {
    if (_status == 0 || _status == 2) return '未支付';
    if (_status == 1 || _status == 3) return '已完成';
    return '已完成';
  }

  Color getOrderStatusColor() {
    if (_status == 0 || _status == 2) return Colour.c0xF72626;
    if (_status == 1 || _status == 3) return Colour.FF19BA6C;
    return Colour.cFF999999;
  }

  OrderRecord.fromJson(dynamic json) {
    _id = json["id"];
    _userId = json["userId"];
    _parentUserId = json["parentUserId"];
    _number = json["number"];
    _price = json["price"];
    _createTime = json["createTime"];
    _status = json["status"];
    _payTime = json["payTime"];
    _tradeNo = json["tradeNo"];
    _remark = json["remark"];
    _count = json["count"];
    _payType = json["payType"];
    _userName = json["userName"];
    _parentUserName = json["parentUserName"];
    _validTime = json["validTime"];
    _validDays = json["validDays"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["userId"] = _userId;
    map["parentUserId"] = _parentUserId;
    map["number"] = _number;
    map["price"] = _price;
    map["createTime"] = _createTime;
    map["status"] = _status;
    map["payTime"] = _payTime;
    map["tradeNo"] = _tradeNo;
    map["remark"] = _remark;
    map["count"] = _count;
    map["payType"] = _payType;
    map["userName"] = _userName;
    map["parentUserName"] = _parentUserName;
    map["validTime"] = _validTime;
    map["validDays"] = _validDays;
    return map;
  }
}
