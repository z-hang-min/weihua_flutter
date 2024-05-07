/// items : [{"id":4,"tel":"13011111111","businessName":"321","businessId":"3333","businessLicense":"333","contactName":"222","contactMobile":"123","remarks":null,"status":0,"reviewer":null,"createTime":1630374226000,"updateTime":1630374226000}]

class GetBusinessListReslt {
  List<Items> _items = [];

  List<Items> get items => _items;
  int _status = 0;
  int get status => _status;
  GetBusinessListReslt({required List<Items> items, required int status}) {
    _items = items;
    _status = status;
  }

  GetBusinessListReslt.fromJson(dynamic json) {
    if (json["items"] != null) {
      _items = [];
      json["items"].forEach((v) {
        _items.add(Items.fromJson(v));
      });
    }
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["items"] = _items.map((v) => v.toJson()).toList();
    map["status"] = _status;
    return map;
  }
}

/// id : 4
/// tel : "13011111111"
/// businessName : "321"
/// businessId : "3333"
/// businessLicense : "333"
/// contactName : "222"
/// contactMobile : "123"
/// remarks : null
/// status : 0
/// reviewer : null
/// createTime : 1630374226000
/// updateTime : 1630374226000

class Items {
  int _id = 0;
  String _tel = '';
  String _businessName = '';
  String _businessId = '';
  String _businessLicense = '';
  String _contactName = '';
  String _contactMobile = '';
  dynamic _remarks;
  int _status = 0;
  dynamic _reviewer;
  int _createTime = 0;
  int _updateTime = 0;

  int get id => _id;
  String get tel => _tel;
  String get businessName => _businessName;
  String get businessId => _businessId;
  String get businessLicense => _businessLicense;
  String get contactName => _contactName;
  String get contactMobile => _contactMobile;
  dynamic get remarks => _remarks;
  int get status => _status;
  dynamic get reviewer => _reviewer;
  int get createTime => _createTime;
  int get updateTime => _updateTime;

  Items(
      {int id = 0,
      String tel = '',
      String businessName = '',
      String businessId = '',
      String businessLicense = '',
      String contactName = '',
      String contactMobile = '',
      dynamic remarks,
      int status = 0,
      dynamic reviewer,
      int createTime = 0,
      int updateTime = 0}) {
    _id = id;
    _tel = tel;
    _businessName = businessName;
    _businessId = businessId;
    _businessLicense = businessLicense;
    _contactName = contactName;
    _contactMobile = contactMobile;
    _remarks = remarks;
    _status = status;
    _reviewer = reviewer;
    _createTime = createTime;
    _updateTime = updateTime;
  }

  @override
  String toString() {
    return 'Items{_businessName: $_businessName}';
  }

  Items.fromJson(dynamic json) {
    _id = json["id"];
    _tel = json["tel"];
    _businessName = json["businessName"];
    _businessId = json["businessId"];
    _businessLicense = json["businessLicense"];
    _contactName = json["contactName"];
    _contactMobile = json["contactMobile"];
    _remarks = json["remarks"];
    _status = json["status"];
    _reviewer = json["reviewer"];
    _createTime = json["createTime"];
    _updateTime = json["updateTime"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["tel"] = _tel;
    map["businessName"] = _businessName;
    map["businessId"] = _businessId;
    map["businessLicense"] = _businessLicense;
    map["contactName"] = _contactName;
    map["contactMobile"] = _contactMobile;
    map["remarks"] = _remarks;
    map["status"] = _status;
    map["reviewer"] = _reviewer;
    map["createTime"] = _createTime;
    map["updateTime"] = _updateTime;
    return map;
  }
}
