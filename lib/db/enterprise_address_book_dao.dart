import 'package:weihua_flutter/db/base_dao.dart';
import 'package:weihua_flutter/model/enterprise_address_book.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/function_permission_help.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

///
/// @Desc:
/// @Author: zhhli
/// @Date: 2021-04-12
///
class EnterpriseDao extends BaseDao {
  EnterpriseDao(Database database) : super(database);

  @override
  String getCreateTableSql() {
    // int enterpriseId;
    //   int outerNumberId;
    //   String name;
    String sql = '''CREATE TABLE $tableName (
          enterpriseId INTEGER PRIMARY KEY,
          outerNumberId INTEGER,
          ownerId TEXT,
          name TEXT
          )''';
    return sql;
  }

  @override
  String get primaryKey => "enterpriseId";

  @override
  String get tableName => "Enterprise";

  @override
  String get ownerId => accRepo.ownerId;

  Future<Enterprise?> getEnterprise(int outerNumberId) async {
    Map<String, dynamic> map = Map();
    map["outerNumberId"] = outerNumberId;

    var data = await queryItems(map: map);
    if (data.length > 0) {
      return Enterprise.fromJson(data.first);
    }
    return null;
  }
}

class EmployeeDao extends BaseDao {
  EmployeeDao(Database database) : super(database);

  @override
  String getCreateTableSql() {
    //int uId;
    //   String name;
    //   String phone;
    //   String number95;
    //   String extNumber;
    //   String position;
    //   int enterpriseId;
    //   int orgId;
    //   String orgName;
    // uId INTEGER PRIMARY KEY,
    String sql = '''CREATE TABLE $tableName (
          uId INTEGER PRIMARY KEY,
          ownerId TEXT,
          name TEXT,
          pinyin TEXT,
          phone TEXT,
          number95 TEXT,
          extNumber TEXT,
          position TEXT,
          enterpriseId INTEGER,
          orgId INTEGER,
          orgName TEXT
          )''';
    return sql;
  }

  @override
  String get primaryKey => "uId";

  @override
  String get tableName => "Employee";

  @override
  String get ownerId => accRepo.outerNumberId;

  /// 是否有权限能用
  @override
  bool get enable => UserPermissionHelp.enableEnterpriseContact();

  Future<void> replaceAll(List<Employee> list, int enterpriseId) async {
    await database.transaction((txn) async {
      var batch = txn.batch();
      batch.delete(tableName,
          where: "enterpriseId = ?", whereArgs: [enterpriseId]);

      list.forEach((Employee element) {
        element.ownerId = ownerId;

        batch.insert(tableName, element.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      });

      await batch.commit(continueOnError: true);
    });
  }

  Future<Employee?> getEmployee(String number) async {
    if (!enable) return null;

    if (!checkDB()) return null;

    String keyStr = 'ownerId=? and (phone=? or number95=? or extNumber=?)';

    var data = await database.query(
      '$tableName',
      where: keyStr,
      whereArgs: [ownerId, number, number, number],
    );

    if (data.length > 0) {
      return Employee.fromJson(data.first);
    }
    return null;
  }

  Future<List<Employee>> returnSearchResult(String searchKey) async {
    if (searchKey.isEmpty) return [];

    if (!enable) return [];

    if (!checkDB()) return [];

    String sqlStr = 'SELECT * FROM $tableName WHERE ownerId=\'$ownerId\' '
        'AND (name LIKE \'%$searchKey%\' '
        'OR pinyin LIKE \'%$searchKey%\' '
        'OR phone LIKE \'%$searchKey%\' '
        'OR number95 LIKE \'%$searchKey%\' '
        'OR extNumber LIKE \'%$searchKey%\') '
        'ORDER BY pinyin ASC';

    log("returnSearchResult : $sqlStr");

    List data = await database.rawQuery(sqlStr);

    List<Employee> result = [];
    data.forEach((element) {
      log(element.toString());
      result.add(Employee.fromJson(element));
    });

    return result;
  }
}
