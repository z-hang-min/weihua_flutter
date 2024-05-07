import 'package:weihua_flutter/db/base_dao.dart';
import 'package:weihua_flutter/model/local_contact.dart';
import 'package:weihua_flutter/service/function_permission_help.dart';
import 'package:sqflite_common/sqlite_api.dart';

///
/// @Desc: 手机本地联系人
///
/// @Author: zhhli
///
/// @Date: 21/4/14
///
class LocalContactDao extends BaseDao {
  LocalContactDao(Database database) : super(database);

  @override
  String getCreateTableSql() {
    // 'identifier': identifier,
    //     'name': name,
    //     'phone': phone,
    //     'pinyin': pinyin,
    //     'tagIndex': tagIndex,
    //     'img': img
    String sql = '''
    CREATE TABLE $tableName (
        identifier TEXT,
        name TEXT,
        phone TEXT,
        pinyin TEXT,
        tagIndex TEXT,
        img TEXT)
    ''';
    return sql;
  }

  /// 归属所有用户
  @override
  String get ownerId => '';

  /// 无主键
  @override
  String get primaryKey => '';

  @override
  String get tableName => "LocalContact";

  @override
  bool get enable => UserPermissionHelp.enableLocalContact();

  Future<bool> isEmpty() async {
    String sql = "SELECT COUNT(*) FROM $tableName";
    var map = await database.rawQuery(sql);

    int count = map.first["COUNT(*)"] as int;

    log("行数 ${map.toString()}");
    log("无数据 ${count == 0}");

    return count == 0;
  }

  /// 覆盖式 插入
  /// -请确保已排序
  Future<void> replaceAll(List<LocalContact> list) async {
    await database.transaction((txn) async {
      var batch = txn.batch();

      txn.delete(tableName);

      list.forEach((LocalContact element) {
        batch.insert(tableName, element.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);

        log("插入 ${element.toJson()}");
      });

      await batch.commit(continueOnError: true);
    });
  }

  Future<List<LocalContact>> loadList() async {
    if (!enable || !checkDB()) return [];
    // String sql  = "SELECT * FROM  $tableName WHERE pinyin LIKE \'[^#]%\' ORDER BY pinyin ASC";
    // String sql2 = "SELECT * FROM  $tableName WHERE pinyin LIKE \'#%\' ORDER BY pinyin ASC";
    List<Map<String, Object?>> data = await database.query(tableName,
        // where: "pinyin LIKE \'#%\'",
        orderBy: "pinyin,phone ASC");
    List<LocalContact> list = fromJsonList(data);

    // List<Map<String, Object>> data = await database.rawQuery(sql);
    //
    //
    // data = await database.rawQuery(sql2);
    // List<LocalContact> list2 = fromJsonList(data);
    // log("读取联系人:${list.length}  $sql");
    // log("读取联系人#:${list2.length}  $sql2");
    //
    // list.addAll(list2);
    log("读取联系人 ${list.length}");

    return list;
  }

  List<LocalContact> fromJsonList(List<Map<String, Object?>> data) {
    List<LocalContact> list = [];
    data.forEach((element) {
      log("读取联系人 ${element.toString()}");
      var value = LocalContact.fromJson(element);
      list.add(value);
    });

    return list;
  }

  Future<LocalContact?> getLocalContact(String number) async {
    if (!enable || !checkDB()) return null;
    Map<String, dynamic> map = Map();
    map["phone"] = number;

    var data = await queryItems(map: map);
    if (data.length > 0) {
      return LocalContact.fromJson(data.first);
    }
    return null;
  }

  Future<List<LocalContact>> returnSearchResult(String searchKey) async {
    if (searchKey.isEmpty) return [];

    if (!enable || !checkDB()) return [];

    String sqlStr = 'SELECT * FROM $tableName WHERE name LIKE \'%$searchKey%\' '
        'OR pinyin LIKE \'%$searchKey%\' '
        'OR phone LIKE \'%$searchKey%\' '
        'ORDER BY pinyin ASC';
    log("returnSearchResult : $sqlStr");
    List data = await database.rawQuery(sqlStr);

    List<LocalContact> result = [];

    data.forEach((element) {
      log(element.toString());
      result.add(LocalContact.fromJson(element));
    });
    return result;
  }

  Future<bool> save(LocalContact localContact) async {
    if (!enable || !checkDB()) return false;
    LocalContact? tempDb = await getLocalContact(localContact.phone);
    if (tempDb == null) {
      await database.insert(tableName, localContact.toJson());
      log("插入 ${localContact.toJson()}");
    } else {
      await database.update(tableName, localContact.toJson(),
          where: "phone=?",
          whereArgs: [localContact.phone],
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return true;
  }

  Future<bool> delete(String number) async {
    if (!enable || !checkDB()) return false;
    Map<String, dynamic> map = Map();
    map["phone"] = number;
    await deleteItem(map: map);
    return true;
  }
}
