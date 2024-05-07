/// provinceName : "北京"
/// agentName : "电信"
/// cityName : "北京"

class QueryAreaResult {
  String? provinceName;
  String? agentName;
  String? cityName;

  QueryAreaResult({this.provinceName, this.agentName, this.cityName});

  QueryAreaResult.fromJson(dynamic json) {
    provinceName = json["provinceName"];
    agentName = json["agentName"];
    cityName = json["cityName"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["provinceName"] = provinceName;
    map["agentName"] = agentName;
    map["cityName"] = cityName;
    return map;
  }
}
