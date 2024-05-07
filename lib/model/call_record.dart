import 'package:weihua_flutter/db/base_db_bean.dart';
import 'package:weihua_flutter/model/user.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/contact_repository.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:weihua_flutter/utils/time_util.dart';

///
/// @Desc: 通话记录
/// @Author: zhhli
/// @Date: 2021-03-31
///
class CallRecord extends BaseDbBean {
  String? ownerId;

  String number = "";

  // 是否呼出
  bool isCallOut = true;

  // 是否接通
  bool isConnected = false;
  int callType = 0;
  static const int CAll_OUT = 0;
  static const int CAll_IN = 1;
  static const int CAll_IN_MISSED = 2;
  static const int CAll_OUT_MISSED = 3;

  /// 联系人类型
  ///
  /// 0: unknown， 1：employee， 2： exContact, 3: localContact
  String? contactType = '';
  String? realName = '';

  // 拨号时间 毫秒
  int time = DateTime.now().millisecondsSinceEpoch;

  // 时长 秒
  int duration = 0;

  // 归属地 地区
  String region = '';

  late String name = '';

  // 数据库中的个数
  int total = 1;

  String? _endStamp;
  String? _startStamp;
  String? _accountcode;
  String? _provider;
  String? _bProvince;
  String? _index;
  String? _id;
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
  String? _destination_number;
  String? _caller_id_number;
  String? _billsec;

  String? get endStamp => _endStamp;

  String? get startStamp => _startStamp;

  String? get accountcode => _accountcode;

  String? get destinationNumber =>
      StringUtils.get95WithSpace(_destination_number!);

  String? get calleridNumber => StringUtils.get95WithSpace(_caller_id_number!);

  String? get provider => _provider;

  String? get bProvince => _bProvince ?? '未知';

  String? get bCity => _bCity ?? '';

  String? get province => _province ?? '未知';

  String? get city => _city ?? '';

  String? get areacode => _areacode;

  String? get bProvider => _bProvider;

  String? get answerStamp => _answerStamp;

  String? get recFlag => _recFlag;

  String? get noA => _noA;

  String? get noX => _noX;

  String? get noB => _noB;

  String? get safenumCallDisplay =>
      StringUtils.get95WithSpace(_safenumCallDisplay!);

  String? get billsec => _billsec;

  String? get id => _id;

  String? get index => _index;

  // CallRecord({
  //   this.ownerId = '',
  //   this.number = '',
  //   this.isCallOut = false,
  //   this.isConnected = false,
  //   this.name = '',
  //   this.contactType = '',
  //   this.realName = '',
  // });
  CallRecord(
      {String? endStamp,
      String? startStamp,
      String? accountcode,
      String? id,
      String? index,
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
      String? destination_number,
      String? caller_id_number,
      String? billsec}) {
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
    _destination_number = destination_number;
    _caller_id_number = caller_id_number;
    _billsec = billsec;
    _id = id;
    _index = index;
  }

  CallRecord.out(this.number, this.ownerId) {
    isCallOut = true;
  }

  CallRecord.incoming(this.number, this.ownerId) {
    isCallOut = false;
  }

  String getName() {
    findName(number);
    return name;
  }

  ///noA去登录列表里查询有没有对应的号码
  ///
  void resetData() {
    List<User> ll = accRepo.unifyLoginResult!.numberList
        .where((element) => element.number == noA)
        .toList();

    if (accountcode == "callingservice") {
      if (answerStamp!.isEmpty) {
        callType = CAll_OUT_MISSED;
      } else {
        callType = CAll_OUT;
      }
      isCallOut = true;
      number = noB!;
      if (bProvider == "cmcc")
        _bProvider = "移动";
      else if (bProvider == "cnc")
        _bProvider = "联通";
      else if (bProvider == "ctc")
        _bProvider = "电信";
      else
        _bProvider = "";
      if (bProvince != bCity)
        region = "$bProvince $bCity $bProvider";
      else
        region = "$bProvince $bProvider";
    } else {
      if (ll.isNotEmpty) {
        if (answerStamp!.isEmpty) {
          callType = CAll_OUT_MISSED;
        } else {
          callType = CAll_OUT;
        }
        isCallOut = true;
        number = noB!;
        if (bProvider == "cmcc")
          _bProvider = "移动";
        else if (bProvider == "cnc")
          _bProvider = "联通";
        else if (bProvider == "ctc")
          _bProvider = "电信";
        else
          _bProvider = "";
        if (bProvince != bCity)
          region = "$bProvince $bCity $bProvider";
        else
          region = "$bProvince $bProvider";
      } else {
        if (answerStamp!.isEmpty) {
          callType = CAll_IN_MISSED;
        } else {
          callType = CAll_IN;
        }
        isCallOut = false;
        number = noA!;
        if (provider == "cmcc")
          _provider = "移动";
        else if (provider == "cnc")
          _provider = "联通";
        else if (provider == "ctc")
          _provider = "电信";
        else
          _provider = "";
        if (province != city)
          region = "$province $city $provider";
        else
          region = "$province $provider";
      }
    }
    duration = int.parse(billsec!);
    time = TimeUtil.getTime(startStamp!);
    number = StringUtils.get95WithSpace(number);
    findName(number);
  }

  int getCallType() {
    return callType;
  }

  Future<String> findName(String num) async {
    Map recordInfo = Map();
    recordInfo = (await contactRepo.findName(num));
    name = recordInfo['name'];
    if (name.isEmpty || name == '') name = number;
    return name;
  }

  CallRecord.mockData()
      : ownerId = "1",
        name = "xxxx",
        number = "18812345678",
        region = "北京 移动",
        duration = 20,
        contactType = '0',
        realName = '';

  @override
  String toString() {
    return 'CallRecord{callType: $callType, time: $time, name: $name, safenumCallDisplay: $safenumCallDisplay}';
  }

  CallRecord.fromJson(Map<String, dynamic> map) {
    // ownerId = map['ownerId'];
    // number = map['number'];
    // isCallOut = map['isCallOut'] == 1;
    // isConnected = map['isConnected'] == 1;
    // time = map['time'];
    // duration = map['duration'];
    // total = map['total'];
    // region = map['region'];
    _endStamp = map["end_stamp"];
    _startStamp = map["start_stamp"];
    _accountcode = map["accountcode"];
    _provider = map["provider"];
    _bProvince = map["b_province"];
    _id = map["id"];
    _index = map["index"];
    _bCity = map["b_city"];
    _province = map["province"];
    _city = map["city"];
    _areacode = map["areacode"];
    _bProvider = map["b_provider"];
    _answerStamp = map["answer_stamp"];
    _recFlag = map["rec_flag"];
    _noA = map["no_a"];
    _noX = map["no_x"];
    _noB = map["no_b"];
    _safenumCallDisplay = map["safenum_call_display"];
    _destination_number = map["destination_number"];
    _caller_id_number = map["caller_id_number"];
    _billsec = map["billsec"];
    resetData();
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();

    // map['ownerId'] = ownerId;
    // map['number'] = number;
    // map['isCallOut'] = isCallOut ? 1 : 0;
    // map['isConnected'] = isConnected ? 1 : 0;
    // map['time'] = time;
    // map['duration'] = duration;
    // map['region'] = region;
    // map['total'] = total;
    map["end_stamp"] = _endStamp;
    map["start_stamp"] = _startStamp;
    map["accountcode"] = _accountcode;
    map["provider"] = _provider;
    map["b_province"] = _bProvince;
    map["b_city"] = _bCity;
    map["id"] = _id;
    map["index"] = _index;
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
    map["destination_number"] = _destination_number;
    map["caller_id_number"] = _caller_id_number;
    map["billsec"] = _billsec;
    return map;
  }

// equals

}
