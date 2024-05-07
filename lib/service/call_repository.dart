import 'package:weihua_flutter/model/call_record.dart';

///
/// @Desc: 通话记录 数据管理
/// @Author: zhhli
/// @Date: 2021-03-31
///
class CallRepository {
  CallRepository._();

  static final _instance = CallRepository._();

  factory CallRepository.getInstance() => _instance;

  List<CallRecord> list(String number) {
    List<CallRecord> list = [];

    for (var i = 0; i < 10; i++) {
      list.add(CallRecord.mockData()..time -= i * 20 * 1000 * 1000);
    }
    return list;
  }
}
