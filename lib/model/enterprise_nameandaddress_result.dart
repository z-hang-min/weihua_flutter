class NamgeandAddressResult {
  String address = '';
  String name = '';

  NamgeandAddressResult({this.address = '', this.name = ''});

  NamgeandAddressResult.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['name'] = this.name;
    return data;
  }
}