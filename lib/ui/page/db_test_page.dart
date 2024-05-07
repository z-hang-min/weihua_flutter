import 'package:weihua_flutter/db/db_widget.dart';
import 'package:flutter/material.dart';

///
/// @Desc: 数据库查看
/// @Author: zhhli
/// @Date: 2021-03-31
///
class DbTestPage extends StatefulWidget {
  @override
  _DbTestPageState createState() => _DbTestPageState();
}

class _DbTestPageState extends State<DbTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("数据库查看"),
      ),
      body: DbTestWidget(),
    );
  }
}
