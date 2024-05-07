// class QueryWorkBenchResult {
//   List _workbenchList = [];

//   List get workbenchList => _workbenchList;

//   QueryWorkBenchResult({List workbenchList = const []}) {
//     _workbenchList = workbenchList;
//   }

//   QueryWorkBenchResult.fromJson(dynamic json) {
//     _workbenchList = json["functionList"];
//   }

//   Map<String, dynamic> toJson() {
//     var map = <String, dynamic>{};
//     map['functionList'] = _workbenchList;
//     return map;
//   }
// }

class QueryWorkBenchResult {
  List<TitleFunctionData>? functionList;

  QueryWorkBenchResult({required this.functionList});

  QueryWorkBenchResult.fromJson(Map<String, dynamic> json) {
    if (json['functionList'] != null) {
      functionList =  [];
      json['functionList'].forEach((v) {
        functionList!.add(new TitleFunctionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.functionList != null) {
      data['functionList'] = this.functionList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TitleFunctionData {
  int? oid;
  int? businessId;
  int? parentId;
  String? name;
  String? url;
  String? picture;
  int? sort;
  int? level;
  int? admin;
  String? functionCode;
  bool? active;
  List<InfoItem>? list;

  TitleFunctionData(
      {this.oid,
      this.businessId,
      this.parentId,
      this.name,
      this.url,
      this.picture,
      this.sort,
      this.level,
      this.admin,
      this.functionCode,
      this.active,
      this.list});

  TitleFunctionData.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    businessId = json['businessId'];
    parentId = json['parentId'];
    name = json['name'];
    url = json['url'];
    picture = json['picture'];
    sort = json['sort'];
    level = json['level'];
    admin = json['admin'];
    functionCode = json['functionCode'];
    active = json['active'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list!.add(new InfoItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oid'] = this.oid;
    data['businessId'] = this.businessId;
    data['parentId'] = this.parentId;
    data['name'] = this.name;
    data['url'] = this.url;
    data['picture'] = this.picture;
    data['sort'] = this.sort;
    data['level'] = this.level;
    data['admin'] = this.admin;
    data['functionCode'] = this.functionCode;
    data['active'] = this.active;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InfoItem {
  int? oid;
  int? businessId;
  int? parentId;
  String? name;
  String? url;
  String? picture;
  int? sort;
  int? level;
  int? admin;
  String? functionCode;
  bool? active;
 

  InfoItem(
      {this.oid,
      this.businessId,
      this.parentId,
      this.name,
      this.url,
      this.picture,
      this.sort,
      this.level,
      this.admin,
      this.functionCode,
      this.active,
      });

  InfoItem.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    businessId = json['businessId'];
    parentId = json['parentId'];
    name = json['name'];
    url = json['url'];
    picture = json['picture'];
    sort = json['sort'];
    level = json['level'];
    admin = json['admin'];
    functionCode = json['functionCode'];
    active = json['active'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oid'] = this.oid;
    data['businessId'] = this.businessId;
    data['parentId'] = this.parentId;
    data['name'] = this.name;
    data['url'] = this.url;
    data['picture'] = this.picture;
    data['sort'] = this.sort;
    data['level'] = this.level;
    data['admin'] = this.admin;
    data['functionCode'] = this.functionCode;
    data['active'] = this.active;
  
    return data;
  }
}


////  =================
///
class WorkBenchItemGroup{
String title= "";
List<WorkBenchItem> list =[];

WorkBenchItemGroup.person(){
  title ="";
  list = [
    WorkBenchItem(title:"我的号码",url: "http://39.97.232.211:8090/ipcboss/weihua/call_mode?outerNumberId=75&innerNumberId=468&modeType=0",picture:'' ),
    WorkBenchItem(title:"云通知",url:"http://39.97.232.211:8090/ipcboss/weihua/call_mode?outerNumberId=75&innerNumberId=468&modeType=0",picture: ""),
  ];
}

WorkBenchItemGroup.enterpriseInfo(TitleFunctionData data){
  title = data.name?? "";

  data.list?.forEach((item) {
    list.add(WorkBenchItem.from(item));
  });
}
}

class WorkBenchItem{
String title= "";
String picture= "";
String url= "";

WorkBenchItem({this.title ="", this.picture = "", this.url =""});
// WorkBenchItem(this.title ="", this.picture = "", this.url ="")

WorkBenchItem.from(InfoItem item){
  title = item.name ?? "";
  picture = item.picture??"";
  url = item.url ?? "";

}
}


