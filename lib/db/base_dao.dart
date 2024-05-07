import 'package:weihua_flutter/db/base_db_bean.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:sqflite/sqflite.dart';

///
/// @Desc: 数据库操作
/// @Author: zhhli
/// @Date: 2021-04-01
///
abstract class BaseDao<T extends BaseDbBean> {
  Database database;

  BaseDao(this.database);

  String get tableName;

  String get primaryKey;

  String get ownerId;

  /// 是否有权限能用
  bool get enable => true;

  String getCreateTableSql();

  void log(String log) {
    Log.d("数据库操作 $tableName >>> $log");
  }

  bool checkDB() {
    return database.isOpen;
  }

  Future<void> createTable() async {
    String sql = getCreateTableSql();
    Log.d("创建表 $sql");
    return await database.execute(sql);
  }

  Future<void> dropTable() async {
    Log.d("删除表 ");
    return await database.execute("DROP TABLE $tableName");
  }

  Future<int> insert(T data) async {
    if (!checkDB()) return -1;

    Map<String, Object?> modelMap = data.toJson();
    Log.d("插入数据 $modelMap");

    // 插入操作
    return await database.insert(tableName, modelMap);
  }

  /// 删除数据
  Future<int> deleteItem<T>({Map<String, dynamic>? map}) async {
    if (!checkDB()) return -1;
    if (map == null) {
      int count = await database.delete('$tableName');
      log("删除数据 $tableName ($count) ：All");
      return count;
    } else {
      String keyStr = "";
      List<Object> args = [];
      map.forEach((key, value) {
        if (keyStr.isEmpty) {
          keyStr = key + " = ?";
        } else {
          keyStr = keyStr + ' AND ' + key + " = ?";
        }
        args.add(value);
      });
      // 删除数据
      // int count = await db.delete(tableTodo, where: 'columnId = ?', whereArgs: [id]);
      int count = await database.delete(
        '$tableName',
        where: keyStr,
        whereArgs: args,
      );
      log("删除数据 ($count) ：$map");
      return count;
    }
  }

// 更新数据
  Future<int> update(T t, String key, Object value) async {
    if (!checkDB()) return 0;

    // 更新数据
    int count = await database.update(
      tableName,
      t.toJson(),
      where: (key + " = ?"),
      whereArgs: [value],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    log("更新数据 ($count) ：$key:${value.toString()} \n ${t.toJson()}");
    return count;
  }

  // 更新数据
  Future<int> replace(T t) async {
    if (!checkDB()) return 0;

    // 更新数据
    int count = await database.insert(
      tableName,
      t.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    log("更新数据 ($count) ：} \n ${t.toJson()}");
    return count;
  }

  // 查询数据
  Future<List<Map<String, dynamic>>> queryItems(
      {Map<String, dynamic>? map}) async {
    if (!enable || !checkDB()) return [];

    List<Map<String, dynamic>> data = [];

    if (map == null) {
      data = await database.query('$tableName');
      log("查询数据 (${data.length}) ：\n ${data.toString}");
    } else {
      String keyStr = "";
      List<Object> args = [];
      map.forEach((key, value) {
        if (keyStr.isEmpty) {
          keyStr = "$key=?";
        } else {
          keyStr = '$keyStr  AND $key=?';
        }
        args.add(value);
      });
      // 删除数据
      // int count = await db.delete(tableTodo, where: 'columnId = ?', whereArgs: [id]);
      data = await database.query(
        '$tableName',
        where: keyStr,
        whereArgs: args,
      );
      log("查询数据  sql keyStr: $keyStr \t args: ${args.toString()}");
      log("查询数据  (${data.length}) ：$map \n ${data.toString}");
    }

    List<Map<String, dynamic>> dataCopy = [];

    // copy
    data.forEach((element) {
      Map<String, dynamic> item = Map.from(element);
      dataCopy.add(item);
    });

    return dataCopy;
  }
}
