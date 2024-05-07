/// end_stamp : "2021-07-28 09:35:20"
/// start_stamp : "2021-07-28 09:35:18"
/// accountcode : "callingservice"
/// provider : "cmcc"
/// b_province : "广东"
/// b_city : "广州"
/// province : "北京"
/// city : "北京"
/// areacode : "010"
/// b_provider : "cnc"
/// answer_stamp : ""
/// rec_flag : "0"
/// no_a : "13911334545"
/// no_x : "9501313693000619"
/// no_b : "13693000619"
/// safenum_call_display : "950133458888"
/// billsec : "0"

class CloundCallRecord {
  String? _endStamp;
  String? _startStamp;
  String? _accountcode;
  String? _provider;
  String? _bProvince;
  String? _bCity;
  String? _province;
  String? _city;
  String? _areacode;
  String? _bProvider;
  String? _answerStamp;
  String? _recFlag;
  String? _noA;
  String? _noX;
  String? _noB;
  String? _safenumCallDisplay;
  int? _billsec;

  String? get endStamp => _endStamp;
  String? get startStamp => _startStamp;
  String? get accountcode => _accountcode;
  String? get provider => _provider;
  String? get bProvince => _bProvince;
  String? get bCity => _bCity;
  String? get province => _province;
  String? get city => _city;
  String? get areacode => _areacode;
  String? get bProvider => _bProvider;
  String? get answerStamp => _answerStamp;
  String? get recFlag => _recFlag;
  String? get noA => _noA;
  String? get noX => _noX;
  String? get noB => _noB;
  String? get safenumCallDisplay => _safenumCallDisplay;
  int? get billsec => _billsec;

  CloundCallRecord(
      {String? endStamp,
      String? startStamp,
      String? accountcode,
      String? provider,
      String? bProvince,
      String? bCity,
      String? province,
      String? city,
      String? areacode,
      String? bProvider,
      String? answerStamp,
      String? recFlag,
      String? noA,
      String? noX,
      String? noB,
      String? safenumCallDisplay,
      int? billsec}) {
    _endStamp = endStamp;
    _startStamp = startStamp;
    _accountcode = accountcode;
    _provider = provider;
    _bProvince = bProvince;
    _bCity = bCity;
    _province = province;
    _city = city;
    _areacode = areacode;
    _bProvider = bProvider;
    _answerStamp = answerStamp;
    _recFlag = recFlag;
    _noA = noA;
    _noX = noX;
    _noB = noB;
    _safenumCallDisplay = safenumCallDisplay;
    _billsec = billsec;
  }

  CloundCallRecord.fromJson(dynamic json) {
    _endStamp = json["end_stamp"];
    _startStamp = json["start_stamp"];
    _accountcode = json["accountcode"];
    _provider = json["provider"];
    _bProvince = json["b_province"];
    _bCity = json["b_city"];
    _province = json["province"];
    _city = json["city"];
    _areacode = json["areacode"];
    _bProvider = json["b_provider"];
    _answerStamp = json["answer_stamp"];
    _recFlag = json["rec_flag"];
    _noA = json["no_a"];
    _noX = json["no_x"];
    _noB = json["no_b"];
    _safenumCallDisplay = json["safenum_call_display"];
    _billsec = json["billsec"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["end_stamp"] = _endStamp;
    map["start_stamp"] = _startStamp;
    map["accountcode"] = _accountcode;
    map["provider"] = _provider;
    map["b_province"] = _bProvince;
    map["b_city"] = _bCity;
    map["province"] = _province;
    map["city"] = _city;
    map["areacode"] = _areacode;
    map["b_provider"] = _bProvider;
    map["answer_stamp"] = _answerStamp;
    map["rec_flag"] = _recFlag;
    map["no_a"] = _noA;
    map["no_x"] = _noX;
    map["no_b"] = _noB;
    map["safenum_call_display"] = _safenumCallDisplay;
    map["billsec"] = _billsec;
    return map;
  }

  @override
  String toString() {
    return 'CloundCallRecord{_endStamp: $_endStamp, _startStamp: $_startStamp, _accountcode: $_accountcode, _provider: $_provider, _bProvince: $_bProvince, _bCity: $_bCity, _province: $_province, _city: $_city, _areacode: $_areacode, _bProvider: $_bProvider, _answerStamp: $_answerStamp, _recFlag: $_recFlag, _noA: $_noA, _noX: $_noX, _noB: $_noB, _safenumCallDisplay: $_safenumCallDisplay, _billsec: $_billsec}';
  }

  // 是否呼出
  bool isCallOut = true;
  String number = "";
  String region = "";

  // 是否接通
  bool isConnected = false;
  int callType = 0;
  static const int CAll_OUT = 0;
  static const int CAll_IN = 1;
  static const int CAll_IN_MISSED = 2;
  static const int CAll_OUT_MISSED = 3;
  int getCallType() {
    if (isCallOut) {
      return isConnected ? CAll_OUT : CAll_OUT_MISSED;
    } else
      return isConnected ? CAll_IN : CAll_IN_MISSED;
  }
}
