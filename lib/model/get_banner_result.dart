/// personList : [{"pic":"http://39.97.232.211:8090/ipcboss/resources/images/weihua/person.png","url":"http://192.168.106.72:8022/sales/banner/person","type":1,"sort":1}]
/// centreList : [{"pic":"http://39.97.232.211:8090/ipcboss/resources/images/weihua/centre.png","url":"http://192.168.106.72:8022/sales/banner/contact?id=1%","type":0,"sort":1}]

class GetBannerResult {
  List<BannerInfo> _personList = [];
  List<BannerInfo> _centreList = [];

  List<BannerInfo> get personList => _personList;
  List<BannerInfo> get centreList => _centreList;

  GetBannerResult(
      {required List<BannerInfo> personList,
      required List<BannerInfo> centreList}) {
    _personList = personList;
    _centreList = centreList;
  }

  GetBannerResult.fromJson(dynamic json) {
    if (json["personList"] != null) {
      _personList = [];
      json["personList"].forEach((v) {
        _personList.add(BannerInfo.fromJson(v));
      });
    }
    if (json["centreList"] != null) {
      _centreList = [];
      json["centreList"].forEach((v) {
        _centreList.add(BannerInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["personList"] = _personList.map((v) => v.toJson()).toList();
    map["centreList"] = _centreList.map((v) => v.toJson()).toList();
    return map;
  }
}

/// pic : "http://39.97.232.211:8090/ipcboss/resources/images/weihua/centre.png"
/// url : "http://192.168.106.72:8022/sales/banner/contact?id=1%"
/// type : 0
/// sort : 1

class BannerInfo {
  String _pic = '';
  String _url = '';
  int _type = 0;
  int _sort = 0;

  String get pic => _pic;
  String get url => _url;
  int get type => _type;
  int get sort => _sort;

  BannerInfo({String pic = '', String url = '', int type = 0, int sort = 0}) {
    _pic = pic;
    _url = url;
    _type = type;
    _sort = sort;
  }

  BannerInfo.fromJson(dynamic json) {
    _pic = json["pic"];
    _url = json["url"];
    _type = json["type"];
    _sort = json["sort"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["pic"] = _pic;
    map["url"] = _url;
    map["type"] = _type;
    map["sort"] = _sort;
    return map;
  }

  @override
  String toString() {
    return 'BannerInfo{_pic: $_pic, _url: $_url, _type: $_type, _sort: $_sort}';
  }
}

/// pic : "http://39.97.232.211:8090/ipcboss/resources/images/weihua/person.png"
/// url : "http://192.168.106.72:8022/sales/banner/person"
/// type : 1
/// sort : 1
