import 'package:weihua_flutter/model/call_record.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'base_dao.dart';

///
/// @Desc: 通话记录 逐条记录
///
/// @Author: zhhli
///
/// @Date: 21/4/22
///
class CallRecordItemDao extends BaseDao {
  CallRecordItemDao(Database database) : super(database);

  @override
  String getCreateTableSql() {
    String sql = '''CREATE TABLE $tableName (
          time INTEGER PRIMARY KEY,
          ownerId TEXT,
          number TEXT,
          isCallOut INTEGER,
          isConnected INTEGER,
          duration INTEGER,
          region TEXT,
          total INTEGER
          )''';

    return sql;
  }

  @override
  String get tableName => "CallRecordItemDao";

  @override
  get primaryKey => "time";

  @override
  String get ownerId => accRepo.ownerId;

  Future<List<CallRecord>> querySameNumber(String number) async {
    List<Map<String, Object?>> data = await database.query(tableName,
        where: "number=? AND ownerId=?",
        whereArgs: [number, ownerId],
        orderBy: "time DESC");
    log("查询querySameNumber number $number");
    List<CallRecord> list = await fromJsonList(data);
    return list;
  }

  Future<List<CallRecord>> pageSameNumberList(
      String number, int start, int limit) async {
    List<Map<String, Object?>> data = await database.query(tableName,
        where: "number=? AND ownerId=?",
        whereArgs: [number, ownerId],
        orderBy: "time DESC",
        limit: limit,
        offset: start);
    log("queryLimitSameNumber number $number");
    List<CallRecord> list = await fromJsonList(data);
    return list;
  }

  Future<List<CallRecord>> fromJsonList(List<Map<String, Object?>> data) async {
    List<CallRecord> list = [];
    data.forEach((element) {
      log(element.toString());
      var value = CallRecord.fromJson(element);
      list.add(value);
    });

    return list;
  }
}
