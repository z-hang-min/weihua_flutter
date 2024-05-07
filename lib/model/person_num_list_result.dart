/// mobile : "13621053799"
/// tSalesNumberReturnApplets : [{"salesOrder":{"id":52,"userId":18,"parentUserId":0,"number":"950133 841217005","price":100,"createTime":1625538315000,"status":1,"payTime":1625538321000,"tradeNo":"1362105379920210706102515373","userName":null,"parentUserName":null,"validTime":1657074321000,"validDays":"335"},"blacklistValue":1,"silenceValue":0},{"salesOrder":{"id":60,"userId":18,"parentUserId":0,"number":"950133 8412174521","price":100,"createTime":1625541599000,"status":1,"payTime":1625541604000,"tradeNo":"1362105379920210706111958800","userName":null,"parentUserName":null,"validTime":1657077604000,"validDays":"335"},"blacklistValue":0,"silenceValue":0},{"salesOrder":{"id":50,"userId":18,"parentUserId":0,"number":"950133 2021841217","price":100,"createTime":1625538160000,"status":1,"payTime":1625538165000,"tradeNo":"1362105379920210706102239968","userName":null,"parentUserName":null,"validTime":1657074165000,"validDays":"335"},"blacklistValue":0,"silenceValue":0}]

class PersonNumListResult {
  String? _mobile;
  List<TSalesNumberReturnApplets>? _tSalesNumberReturnApplets;

  String? get mobile => _mobile;

  List<TSalesNumberReturnApplets>? get tSalesNumberReturnApplets =>
      _tSalesNumberReturnApplets;

  PersonNumListResult(
      {String? mobile,
      List<TSalesNumberReturnApplets>? tSalesNumberReturnApplets}) {
    _mobile = mobile;
    _tSalesNumberReturnApplets = tSalesNumberReturnApplets;
  }

  PersonNumListResult.fromJson(dynamic json) {
    _mobile = json["mobile"];
    if (json["tSalesNumberReturnApplets"] != null) {
      _tSalesNumberReturnApplets = [];
      json["tSalesNumberReturnApplets"].forEach((v) {
        _tSalesNumberReturnApplets!.add(TSalesNumberReturnApplets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["mobile"] = _mobile;
    if (_tSalesNumberReturnApplets != null) {
      map["tSalesNumberReturnApplets"] =
          _tSalesNumberReturnApplets!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// salesOrder : {"id":52,"userId":18,"parentUserId":0,"number":"950133 841217005","price":100,"createTime":1625538315000,"status":1,"payTime":1625538321000,"tradeNo":"1362105379920210706102515373","userName":null,"parentUserName":null,"validTime":1657074321000,"validDays":"335"}
/// blacklistValue : 1
/// silenceValue : 0

class TSalesNumberReturnApplets {
  SalesOrder? _salesOrder;
  int? _blacklistValue;
  int? _silenceValue;

  SalesOrder? get salesOrder => _salesOrder;

  int? get blacklistValue => _blacklistValue;

  int? get silenceValue => _silenceValue;

  TSalesNumberReturnApplets(
      {SalesOrder? salesOrder, int? blacklistValue, int? silenceValue}) {
    _salesOrder = salesOrder;
    _blacklistValue = blacklistValue;
    _silenceValue = silenceValue;
  }

  TSalesNumberReturnApplets.fromJson(dynamic json) {
    _salesOrder = json["salesOrder"] != null
        ? SalesOrder.fromJson(json["salesOrder"])
        : null;
    _blacklistValue = json["blacklistValue"];
    _silenceValue = json["silenceValue"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_salesOrder != null) {
      map["salesOrder"] = _salesOrder!.toJson();
    }
    map["blacklistValue"] = _blacklistValue;
    map["silenceValue"] = _silenceValue;
    return map;
  }
}

/// id : 52
/// userId : 18
/// parentUserId : 0
/// number : "950133 841217005"
/// price : 100
/// createTime : 1625538315000
/// status : 1
/// payTime : 1625538321000
/// tradeNo : "1362105379920210706102515373"
/// userName : null
/// parentUserName : null
/// validTime : 1657074321000
/// validDays : "335"

class SalesOrder {
  int? _id;
  int? _userId;
  int? _parentUserId;
  String? _number;
  int? _price;
  int? _createTime;
  int? _status;
  int? _payTime;
  String? _tradeNo;
  dynamic _userName;
  dynamic _parentUserName;
  int? _validTime;
  String? _validDays;

  int? get id => _id;

  int? get userId => _userId;

  int? get parentUserId => _parentUserId;

  String? get number => _number;

  int? get price => _price;

  int? get createTime => _createTime;

  int? get status => _status;

  int? get payTime => _payTime;

  String? get tradeNo => _tradeNo;

  dynamic get userName => _userName;

  dynamic get parentUserName => _parentUserName;

  int? get validTime => _validTime;

  String? get validDays => _validDays;

  SalesOrder(
      {int? id,
      int? userId,
      int? parentUserId,
      String? number,
      int? price,
      int? createTime,
      int? status,
      int? payTime,
      String? tradeNo,
      dynamic userName,
      dynamic parentUserName,
      int? validTime,
      String? validDays}) {
    _id = id;
    _userId = userId;
    _parentUserId = parentUserId;
    _number = number;
    _price = price;
    _createTime = createTime;
    _status = status;
    _payTime = payTime;
    _tradeNo = tradeNo;
    _userName = userName;
    _parentUserName = parentUserName;
    _validTime = validTime;
    _validDays = validDays;
  }

  SalesOrder.fromJson(dynamic json) {
    _id = json["id"];
    _userId = json["userId"];
    _parentUserId = json["parentUserId"];
    _number = json["number"];
    _price = json["price"];
    _createTime = json["createTime"];
    _status = json["status"];
    _payTime = json["payTime"];
    _tradeNo = json["tradeNo"];
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
    map["userName"] = _userName;
    map["parentUserName"] = _parentUserName;
    map["validTime"] = _validTime;
    map["validDays"] = _validDays;
    return map;
  }
}
