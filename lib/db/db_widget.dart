import 'package:weihua_flutter/model/call_record.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:flutter/material.dart';
// import 'package:sqlite_viewer/sqlite_viewer.dart';

// import 'package:sqlite_viewer/sqlite_viewer.dart';

import 'db_core.dart';

///
/// @Desc: 数据库测试页面
/// @Author: zhhli
/// @Date: 2021-04-01
///
class DbTestWidget extends StatelessWidget {
  final DbCore _core = DbCore.getInstance();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (_) => DatabaseList()));
          },
          child: Text("查看"),
        ),
        TextButton(
          onPressed: () {
            _core.openDb("test");
          },
          child: Text("初始化"),
        ),
        TextButton(
          onPressed: () {
            // _core.callRecordDao.cr;
            _core.callRecordDao.createTable();
          },
          child: Text("创建表"),
        ),
        TextButton(
          onPressed: () {
            _core.callRecordDao.dropTable();
          },
          child: Text("删除表"),
        ),
        TextButton(
          onPressed: () {
            CallRecord record = CallRecord.mockData();
            _core.callRecordDao.insert(record);
          },
          child: Text("插入"),
        ),
        TextButton(
          onPressed: () {
            _core.callRecordDao.deleteItem();
          },
          child: Text("删除所有"),
        ),
        TextButton(
          onPressed: () {
            Map<String, Object> map = Map();
            map["number"] = "18812345677";
            _core.callRecordDao.deleteItem(map: map);
          },
          child: Text("删除部分"),
        ),
        TextButton(
          onPressed: () {
            CallRecord record = CallRecord.mockData();
            record.number = "18812345677";
            _core.callRecordDao.update(record, "number", "18812345678");
          },
          child: Text("更新"),
        ),
        TextButton(
          onPressed: () async {
            var list = await _core.callRecordDao.queryItems();
            list.forEach((element) {
              Log.d(element);
            });
          },
          child: Text("查询"),
        ),
        TextButton(
          onPressed: () async {
            // var list = await _core.callRecordDao.pageList(start: 28, limit: 27);
            var list =
                await _core.callRecordDao.pageListTest(start: 0, limit: 27);
            list.forEach((element) {
              Log.d(element);
            });
          },
          child: Text("分页查询"),
        ),
      ],
    );
  }
}
