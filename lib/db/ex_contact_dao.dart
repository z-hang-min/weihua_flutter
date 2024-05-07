import 'package:weihua_flutter/db/base_dao.dart';
import 'package:weihua_flutter/model/ex_contacts_result.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/function_permission_help.dart';
import 'package:sqflite_common/sqlite_api.dart';

///
/// @Desc: 分机联系人
/// @Author: zhhli
/// @Date: 2021-04-13
///
class ExContactDao extends BaseDao {
  ExContactDao(Database database) : super(database);

  @override
  String getCreateTableSql() {
    //   String userName;
    //   String mobile;
    //   String number;
    //   String ownerId;
    String sql = '''CREATE TABLE $tableName (
          userName TEXT,
          pinyin TEXT,
          mobile TEXT,
          number TEXT,
          ownerId TEXT
          )''';
    return sql;
  }

  @override
  String get ownerId => accRepo.outerNumberId;

  // 无主键
  @override
  String get primaryKey => "";

  @override
  String get tableName => "ExContact";

  /// 是否有权限能用
  @override
  bool get enable => UserPermissionHelp.enableExContact();

  Future<void> replaceAll(List<ExContact> list) async {
    await database.transaction((txn) async {
      var batch = txn.batch();

      batch.delete(tableName, where: "ownerId = ?", whereArgs: [ownerId]);

      list.forEach((ExContact element) {
        element.ownerId = ownerId;

        batch.insert(tableName, element.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
        log("插入 ${element.toJson()}");
      });

      await batch.commit(continueOnError: false);
    });
  }

  Future<ExContact?> getExContact(String number) async {
    if (number.isEmpty) return null;
    if (!enable) return null;

    if (!checkDB()) return null;

    String keyStr = 'ownerId=? AND (mobile=? OR number=?)';

    var data = await database.query(
      '$tableName',
      where: keyStr,
      whereArgs: [ownerId, number, number],
    );

    if (data.length > 0) {
      return ExContact.fromJson(data.first);
    }
    return null;
  }

  Future<List<ExContact>> exSearchResult(String searchKey) async {
    if (searchKey.isEmpty) return [];

    if (!enable) return [];

    if (!checkDB()) return [];

    String sqlStr = 'SELECT * FROM [$tableName] WHERE ownerId=\'$ownerId\' '
        'AND (userName LIKE \'%$searchKey%\' '
        'OR pinyin LIKE \'%$searchKey%\' '
        'OR mobile LIKE \'%$searchKey%\' '
        'OR number LIKE \'%$searchKey%\') '
        'ORDER BY pinyin ASC';
    log("returnSearchResult : $sqlStr");
    List data = await database.rawQuery(sqlStr);

    List<ExContact> result = [];

    data.forEach((element) {
      log(element.toString());
      result.add(ExContact.fromJson(element));
    });

    return result;
  }
}
