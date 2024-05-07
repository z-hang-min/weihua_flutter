import 'package:weihua_flutter/db/base_db_bean.dart';
import 'package:azlistview/azlistview.dart';

///
/// @Desc: 手机本机联系人
///
/// @Author: zhhli
///
/// @Date: 21/4/14
///
class LocalContact extends BaseDbBean with ISuspensionBean {
  /// id
  String identifier;

  /// 姓名
  String name;

  /// 姓名拼音
  late String pinyin;

  /// 电话号码
  String phone;

  /// 图片URL
  String? img;

  // UI 索引
  String tagIndex = "#";

  LocalContact(
      {this.identifier = "",
      this.name = "",
      this.pinyin = "",
      this.phone = "",
      this.img,
      this.tagIndex = "#"});

  LocalContact.fromJson(Map<String, dynamic> json)
      : identifier = json['identifier'],
        name = json['name'],
        pinyin = json['pinyin'],
        img = json['img'],
        tagIndex = json['tagIndex'],
        phone = json['phone'];

  /// 添加联系人首字母属性值

  String getFirstLetter() {
    String result = "#";
    if (pinyin.length > 0) {
      result = pinyin.substring(0, 1).toUpperCase();
    }
    return result;
  }

  @override
  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'name': name,
        'phone': phone,
        'pinyin': pinyin,
        'tagIndex': tagIndex,
        'img': img
      };

  @override
  String getSuspensionTag() {
    return tagIndex;
  }
}
