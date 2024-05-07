class NodisturbResult {
  late List weekname = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
  late List weeklist = ["1", "2", "3", "4", "5"];

  late Map _disturbResultMap;
  Map get disturbResultMap => _disturbResultMap;

  NodisturbResult({Map disturbResultMap = const {}}) {
    _disturbResultMap = disturbResultMap;
  }

  NodisturbResult.fromJson(dynamic json) {
    json["weeks"].sort();
    List weeks = [];
    if (json["weeks"].length == 7) {
      weeks.add('每天');
    } else if (json["weeks"].length == 5 &&
        json["weeks"].toString() == weeklist.toString()) {
      weeks.add('工作日');
    } else if (json["weeks"].length == 1 && json["weeks"][0] == '') {
      weeks.add('永不');
    } else {
      for (var i = 0; i < json["weeks"].length; i++) {
        for (var j = 1; j < 8; j++) {
          if (json["weeks"][i] == j.toString()) {
            weeks.add(weekname[j - 1]);
          }
        }
      }
    }
    late String weeksnameValue;
    if (weeks.length > 0) {
      for (int i = 0; i < weeks.length; i++) {
        if (i == 0) {
          weeksnameValue = weeks[i];
        } else {
          weeksnameValue = weeksnameValue + "," + weeks[i];
        }
      }
    }
    _disturbResultMap = json;
    _disturbResultMap["weeksname"] = weeksnameValue;
  }

  // Map<String, dynamic> toJson() {
  //   var map = <String, dynamic>{};
  //   map['functionList'] = _disturbResultMap;
  //   return map;
  // }
}
