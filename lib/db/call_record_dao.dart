import 'package:weihua_flutter/model/call_record.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/contact_repository.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:sqflite/sqflite.dart';

import 'base_dao.dart';

///
/// @Desc: 通话记录 首页分组，每个号码一条
///
/// 通过这个关联 CallRecordItemDao，操作每个号码对应的所有记录
///
/// @Author: zhhli
///
/// @Date: 2021-03-31
///
class CallRecordDao extends BaseDao {
  CallRecordDao(Database database) : super(database);

  @override
  String getCreateTableSql() {
    String sql = '''CREATE TABLE $tableName (
          number TEXT PRIMARY KEY,
          ownerId TEXT,
          time INTEGER,
          isCallOut INTEGER,
          isConnected INTEGER,
          duration INTEGER,
          region TEXT,
          total INTEGER
          )''';

    return sql;
  }

  @override
  String get tableName => "CallRecord";

  @override
  get primaryKey => "number";

  @override
  String get ownerId => accRepo.ownerId;

  Future<List<CallRecord>> pageListTest({int start = 0, int limit = 20}) async {
    String sql = "select *,count(number) from $tableName as m "
        "group by m.number order By time DESC "
        "limit $limit offset $start;";

    log("分页分组查询 $sql");
    List<Map<String, Object?>> data = await database.rawQuery(sql);

    List<CallRecord> list = await fromJsonList(data);
    return list;
  }

  Future<List<CallRecord>> pageList({int start = 0, int limit = 20}) async {
    List<Map<String, Object?>> data = await database.query(tableName,
        where: "ownerId=?",
        whereArgs: [ownerId],
        limit: limit,
        offset: start,
        orderBy: "time DESC");
    log("分页查询 start $start, limit: $limit");
    List<CallRecord> list = await fromJsonList(data);
    return list;
  }

  Future<CallRecord?> querySameNumber(String number) async {
    List<Map<String, Object?>> data = await database.query(tableName,
        where: "number=? AND ownerId=?",
        whereArgs: [number, ownerId],
        limit: 1);
    log("querySameNumber number $number");
    List<CallRecord> list = await fromJsonList(data);
    if (list.isEmpty) {
      return null;
    } else {
      return list[0];
    }
  }

  Future<List<CallRecord>> fromJsonList(List<Map<String, Object?>> data) async {
    List<CallRecord> list = [];
    data.forEach((element) {
      log(element.toString());
      var value = CallRecord.fromJson(element);

      list.add(value);
    });

    for (int i = 0; i < list.length; i++) {
      CallRecord element = list[i];
      Map recordInfo = Map();
      recordInfo = (await contactRepo.findName(element.number));
      String name = recordInfo['name'];
      String realName = recordInfo['realName'];
      String type = recordInfo['contactType'];
      element.name = name;
      element.realName = realName;
      element.contactType = type;
      log("通话记录 查找名字： ${element.number} : $name");
    }

    return list;
  }

  Future<List> returnSearchResult(String searchKey) async {
    if (!checkDB()) return [];

    String sqlStr =
        ' SELECT * FROM [$tableName] WHERE ownerId=\'$ownerId\' ORDER BY name ASC';
    List suggestionList = [];

    if (searchKey.isNotEmpty) {
      sqlStr =
          'SELECT * FROM [$tableName] WHERE ownerId=\'$ownerId\' AND number LIKE \'%$searchKey%\'';
      List<Map<String, dynamic>> numMaps = [];
      numMaps = await database.rawQuery(sqlStr);
      List numList = [];
      numList = List.generate(numMaps.length, (i) {
        // return t.fromJson(maps[i]);
        return CallRecord.fromJson(numMaps[i]);
      });
      if (numList.length > 0) {
        suggestionList.addAll(numList);
      }
    }

    return suggestionList;
  }

  /// 搜索通话记录
  /// size -1, 表示搜索所有
  Future<List<CallRecord>> search(String key, int size) async {
    bool isLoadAll = size == -1;

    List<CallRecord> result = [];

    // if(key.startsWith(RegExp(r"^[0-9]+"))){
    //   // 纯数字开头
    //   return searchNumber(key, size);
    // }

    List<Map<String, Object?>> data = await database.query(tableName,
        where: "ownerId=?", whereArgs: [ownerId], orderBy: "time DESC");

    log("load all callRecord size: ${data.length} ");
    List<CallRecord> listDB = [];

    data.forEach((element) {
      var value = CallRecord.fromJson(element);
      listDB.add(value);
    });

    Map<String, CallRecord> mapCacheDB = Map();
    Map<String, CallRecord> mapCacheResult = Map();

    // 匹配顺序 名字、拼音、号码

    // 名字
    for (CallRecord record in listDB) {
      // 填入名字
      Map recordInfo = Map();
      recordInfo = (await contactRepo.findName(record.number));
      record.name = recordInfo['name'];
      record.realName = recordInfo['realName'];
      record.contactType = recordInfo['contactType'];
      mapCacheDB[record.number] = record; // 填入缓存，下次不再找名字

      if (record.name.contains(key)) {
        mapCacheResult[record.number] = record;
        result.add(record);

        if (!isLoadAll && result.length == size) {
          return result;
        }
      }
    }

    // 匹配拼音
    for (CallRecord record in listDB) {
      // 判断是否 已在结果中
      CallRecord? temp = mapCacheResult[record.number];
      if (temp != null) {
        // 说明已在 结果中, 接着找下一个
        continue;
      }
      String pinyin = StringUtils.getNospacePinyin(record.name);

      if (pinyin.contains(key)) {
        mapCacheResult[record.number] = record;
        result.add(record);

        if (!isLoadAll && result.length == size) {
          return result;
        }
      }
    }

    // 匹配号码
    for (CallRecord record in listDB) {
      // 判断是否 已在结果中
      CallRecord? temp = mapCacheResult[record.number];
      if (temp != null) {
        // 说明已在 结果中, 接着找下一个
        continue;
      }

      if (record.number.contains(key)) {
        mapCacheResult[record.number] = record;
        result.add(record);

        if (!isLoadAll && result.length == size) {
          return result;
        }
      }
    }

    return result;
  }

  /// 号码 搜索通话记录
  Future<List<CallRecord>> searchNumber(String number, int size) async {
    String numberKey = "\'%$number%\'";

    String sqlStr = 'SELECT * FROM [$tableName] '
        'WHERE ownerId=\'$ownerId\' '
        'AND number LIKE $numberKey '
        'ORDER BY time DESC';

    if (size > 0) {
      sqlStr += " limit $size";
    }

    log("查询 $sqlStr");

    var data = await database.rawQuery(sqlStr);

    log("load all callRecord size: ${data.length} ");
    List<CallRecord> list = await fromJsonList(data);

    return list;
  }
}
