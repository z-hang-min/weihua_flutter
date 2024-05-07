import 'package:weihua_flutter/db/call_record_dao.dart';
import 'package:weihua_flutter/db/call_record_item_dao.dart';
import 'package:weihua_flutter/db/enterprise_address_book_dao.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'ex_contact_dao.dart';
import 'local_contact_dao.dart';

///
/// @Desc: 数据库核心
/// @Author: zhhli
/// @Date: 2021-04-01
///
DbCore dbCore = DbCore.getInstance();

class DbCore {
  DbCore._();

  // 数据库路径
  String databasesPath = '';
  late String dbName;

  // 数据库
  Database? database;

  // 数据库版本
  int dbVersion = 1;

  static DbCore? _dbCore;

  late CallRecordDao callRecordDao;
  late CallRecordItemDao callRecordItemDao;
  late EnterpriseDao enterpriseDao;
  late EmployeeDao employeeDao;
  late ExContactDao exContactDao;
  late LocalContactDao localContactDao;

  static DbCore getInstance() {
    if (null == _dbCore) _dbCore = DbCore._();
    return _dbCore!;
  }

  /// 打开数据库
  Future openDb(String dbName) async {
    // 如果数据库路径不存在，赋值
    if (databasesPath.isEmpty) databasesPath = await getDatabasesPath();

    Log.d('databasesPath : $databasesPath');

    // 如果数据库存在，而且数据库没有关闭，先关闭数据库
    closeDb();
    this.dbName = dbName;

    Log.d("正在打开据库 $dbName");
    database = await openDatabase(join(databasesPath, dbName + '.db'),
        version: dbVersion, onCreate: (Database db, int version) async {
      callRecordDao = CallRecordDao(db);
      callRecordItemDao = CallRecordItemDao(db);
      enterpriseDao = EnterpriseDao(db);
      employeeDao = EmployeeDao(db);
      exContactDao = ExContactDao(db);
      localContactDao = LocalContactDao(db);

      Log.d("正在创建数据库表");
      // 通话记录表
      await callRecordDao.createTable();
      await callRecordItemDao.createTable();
      await enterpriseDao.createTable();
      await employeeDao.createTable();
      await exContactDao.createTable();
      await localContactDao.createTable();
    }, onUpgrade: (Database db, int oldVersion, int newVersion) {
      // 版本更新可能牵扯到重新插入表、删除表、表中字段变更-具体更新相关sql语句进行操作
    }, onOpen: (Database db) {
      callRecordDao = CallRecordDao(db);
      callRecordItemDao = CallRecordItemDao(db);
      enterpriseDao = EnterpriseDao(db);
      employeeDao = EmployeeDao(db);
      exContactDao = ExContactDao(db);
      localContactDao = LocalContactDao(db);

      Log.d("已打开数据库 $dbName");
    });
  }

  /// 关闭数据库
  closeDb() async {
    // 如果数据库存在，而且数据库没有关闭，先关闭数据库
    if (null != database && database!.isOpen) {
      await database!.close();
      database = null;
    }
  }

  deleteDb() async {
    // 如果数据库路径不存在，赋值
    if (databasesPath.isEmpty) databasesPath = await getDatabasesPath();

    await deleteDatabase(join(databasesPath, dbName + '.db'));
  }
}
