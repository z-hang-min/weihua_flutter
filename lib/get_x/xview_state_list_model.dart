import 'package:get/get.dart';

import 'get_view_model.dart';

/// 基于
abstract class XViewStateListModel<T> extends XViewController {
  /// 页面数据
  List list = [].obs;

  /// 第一次进入页面loading skeleton
  initData() async {
    setBusy();
    refresh(init: true);
  }

  // 下拉刷新
  refresh({bool init = false}) async {
    try {
      List<T> data = await loadData();
      if (data.isEmpty) {
        list.clear();
        setEmpty();
      } else {
        onCompleted(data);
        list.clear();
        list.addAll(data);
        setIdle();
      }
    } catch (e, s) {
      if (init) list.clear();
      setError(e, s);
    }
  }

  // 加载数据
  Future<List<T>> loadData();

  onCompleted(List<T> data) {}
}
