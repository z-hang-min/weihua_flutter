import 'dart:io';

import 'package:weihua_flutter/utils/log.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

// ignore: non_constant_identifier_names
String DB_NAME = "regins.db";

const _ID = "_id";
const PROVINCE = "province";
const DISTRICT = "district";
const CITYCODE = "citycode";
const OPERATOR = "operator";
const ALPHA = "alpha";
const NUMBER_AREA = "未知";
const LOG_TAG = "NumberAreaUtil";
const CITYINDEX = "cityindex";
// 数据库中各个表名
const CITIES_TABLE_NAME = "cities";
const TELEPHONE_AREA_TABLE_NAME = "telephoneArea";

const PROVINCENAME = "ProvinceName";
const CITYNAME = "CityName";
const AGENTNAME = "AgentName";
const PHONE_AREA_TABLE_NAME = "areaphonelist";

// 存储以13，15，17,18开头的手机号号段和对应归属地索引
const SECTIONS_TABLE13 = "sections13";
const SECTIONS_TABLE14 = "sections14";
const SECTIONS_TABLE15 = "sections15";
const SECTIONS_TABLE17 = "sections17";
const SECTIONS_TABLE18 = "sections18";

/// 数据库存储
class PhoneAreaDbUtils {
  PhoneAreaDbUtils._();

  // 数据库路径
  String databasesPath = "";
  String databasesPathOld = "";

  // 数据库
  Database? database;

  // 数据库版本
  int dbVersion = 6;

  static PhoneAreaDbUtils? _dbUtils;
  Map<String, String> cache = Map();

  /// 单例模式
  static PhoneAreaDbUtils getInstance() {
    if (null == _dbUtils) _dbUtils = PhoneAreaDbUtils._();
    return _dbUtils!;
  }

  /// 打开数据库 建表
  Future openPhoneAreaDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, DB_NAME);
// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", DB_NAME));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    database = await openDatabase(path, readOnly: true);
  }

  Future<String> queryArea(String phone) async {
    String area = "未知";
    String section = phone.substring(0, 7);
    List<Map> list = await database!.query(PHONE_AREA_TABLE_NAME,
        columns: [PROVINCENAME, CITYNAME, AGENTNAME],
        where: "Phone =?",
        whereArgs: [section]);
    list.forEach((element) {
      String province = element[PROVINCENAME];
      String cityNAme = element[CITYNAME];
      String agent = element[AGENTNAME];
      if (province == cityNAme)
        area = cityNAme + " " + agent;
      else
        area = province + " " + cityNAme + " " + agent;
    });
    return area;
  }

  Future<String> _query(String phone) async {
    int index = await getIndex(phone);
    String area = "";
    List<Map> list = await database!.query(CITIES_TABLE_NAME,
        columns: [_ID, PROVINCE, DISTRICT, CITYCODE],
        where: _ID + "=?",
        whereArgs: [index]);
    Log.w("zhangmin list=${list.toString()}");
    list.forEach((element) {
      String province = element['province'];
      String district = element['district'];
      if (province == district)
        area = district;
      else
        area = province + " " + district;
    });
    Log.w("zhangmin area=$area");
    return area;
  }

  Future<int> getIndex(String phoneNumber) async {
    int index = 0;
    int id = 0;
    String? table;
    String section = phoneNumber.substring(2, 7);
    if (phoneNumber.startsWith("13")) {
      table = SECTIONS_TABLE13;
    } else if (phoneNumber.startsWith("14")) {
      table = SECTIONS_TABLE14;
    } else if (phoneNumber.startsWith("15")) {
      table = SECTIONS_TABLE15;
    } else if (phoneNumber.startsWith("17")) {
      table = SECTIONS_TABLE17;
    } else if (phoneNumber.startsWith("18")) {
      table = SECTIONS_TABLE13;
    }
    if (table == null) {
      return 0;
    }
    List<Map> list = await database!.query(table,
        columns: ["max(_id)"], where: "_id <= ?", whereArgs: [section]);
    if (list.isEmpty) return 0;
    list.forEach((map) {
      id = map['max(_id)'];
    });
    List<Map> list2 = await database!
        .query(table, columns: [CITYINDEX], where: "_id= ?", whereArgs: [id]);
    list2.forEach((map) {
      index = map['cityindex'];
    });
    return index;
  }

  static bool isPhoneNum(String phone) {
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    return exp.hasMatch(phone);
  }

  Future<String> getAreaNameByNumber(String phone) async {
    if (phone.isEmpty) return "";
    String area = "未知";
    if (cache.containsKey(phone)) {
      area = cache[phone]!;
      return area;
    }

    if (isPhoneNum(phone)) {
      String result = await _query(phone);
      cache[phone] = result;
      return result;
    }

    return area;
  }

  /// 关闭数据库
  closeDb() async {
    // 如果数据库存在，而且数据库没有关闭，先关闭数据库
    if (null != database && database!.isOpen) {
      await database!.close();
      database = null;
    }
  }
}
