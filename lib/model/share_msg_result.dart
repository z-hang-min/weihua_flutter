/// content_sms : "北京天舟通信（130****0000）邀请您加入微话，点击链接 http://192.168.106.72:8022/sales/page?outnumber=95013345678&oid=12，激活后使用。"
/// image : "http://oa.95013.com:10018/weihua-person/share/4a82d3dd-d99a-499d-9240-a83e2b67d3f1.jpg"
/// content_wx : "111ttt"
/// title : "111ttt"
/// url : "http://192.168.106.72:8022/sales/page?outnumber=95013345678&oid=12"

class ShareMsgResult {
  ShareMsgResult({
    String contentSms = '',
    String image = '',
    String contentWx = '',
    String title = '',
    String url = '',
  }) {
    _contentSms = contentSms;
    _image = image;
    _contentWx = contentWx;
    _title = title;
    _url = url;
  }

  ShareMsgResult.fromJson(dynamic json) {
    _contentSms = json['content_sms'];
    _image = json['image'];
    _contentWx = json['content_wx'];
    _title = json['title'];
    _url = json['url'];
  }
  String _contentSms = '';
  String _image = '';
  String _contentWx = '';
  String _title = '';
  String _url = '';

  String get contentSms => _contentSms;
  String get image => _image;
  String get contentWx => _contentWx;
  String get title => _title;
  String get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['content_sms'] = _contentSms;
    map['image'] = _image;
    map['content_wx'] = _contentWx;
    map['title'] = _title;
    map['url'] = _url;
    return map;
  }
}
