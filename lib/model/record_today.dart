/// ivrSuccess : 3
/// ivrFail : 0
/// totalFail : 2
/// totalSuccess : 4
/// msgSuccess : 1
/// msgFail : 2

class RecordToday {
  int _ivrSuccess = 0;
  int _ivrFail = 0;
  int _totalFail = 0;
  int _totalSuccess = 0;
  int _msgSuccess = 0;
  int _msgFail = 0;

  int get ivrSuccess => _ivrSuccess;
  int get ivrFail => _ivrFail;
  int get totalFail => _totalFail;
  int get totalSuccess => _totalSuccess;
  int get msgSuccess => _msgSuccess;
  int get msgFail => _msgFail;

  RecordToday(
      {int ivrSuccess = 0,
      int ivrFail = 0,
      int totalFail = 0,
      int totalSuccess = 0,
      int msgSuccess = 0,
      int msgFail = 0}) {
    _ivrSuccess = ivrSuccess;
    _ivrFail = ivrFail;
    _totalFail = totalFail;
    _totalSuccess = totalSuccess;
    _msgSuccess = msgSuccess;
    _msgFail = msgFail;
  }

  RecordToday.fromJson(dynamic json) {
    _ivrSuccess = json["ivrSuccess"];
    _ivrFail = json["ivrFail"];
    _totalFail = json["totalFail"];
    _totalSuccess = json["totalSuccess"];
    _msgSuccess = json["msgSuccess"];
    _msgFail = json["msgFail"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["ivrSuccess"] = _ivrSuccess;
    map["ivrFail"] = _ivrFail;
    map["totalFail"] = _totalFail;
    map["totalSuccess"] = _totalSuccess;
    map["msgSuccess"] = _msgSuccess;
    map["msgFail"] = _msgFail;
    return map;
  }
}
