/*
 * @Author: your name
 * @Date: 2020-11-30 15:03:52
 * @LastEditTime: 2021-03-09 11:16:09
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /app-station-flutter/lib/model/contact_info_model.dart
 */

import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';

/// 表字段 (identifier TEXT, name TEXT, tagIndex TEXT, namePinyin TEXT, phoneNumber TEXT, bgColor TEXT, iconData TEXT, img TEXT, id TEXT, firstletter TEXT, isShowSuspension TEXT )'
class ContactInfo extends ISuspensionBean {
  /// id
  String identifier;

  /// 姓名
  String name;

  /// 1234.。。
  late String tagIndex;

  /// 姓名拼音
  late String namePinyin;

  /// 电话号码
  String phoneNumber;

  Color? bgColor;
  IconData? iconData;

  /// 图片URL
  String? img;

  String? id;

  /// A~Z
  late String firstletter = '*';

  ContactInfo({
    this.identifier = "",
    this.name = "",
    this.tagIndex = "",
    this.namePinyin = "*",
    this.phoneNumber = "",
    this.bgColor,
    this.iconData,
    this.img,
    this.id,
  });

  ContactInfo.fromJson(Map<String, dynamic> json)
      : identifier = json['identifier'],
        name = json['name'],
        img = json['img'],
        phoneNumber = json['phoneNumber'],
        id = json['id']?.toString(),
        firstletter = json['firstletter'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'identifier': identifier,
        'name': name,
        'phoneNumber': phoneNumber,
        'img': img,
        'firstletter': firstletter,
        'tagIndex': tagIndex,
        'namePinyin': namePinyin,
        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => firstletter;

  @override
  String toString() => json.encode(this);
}
