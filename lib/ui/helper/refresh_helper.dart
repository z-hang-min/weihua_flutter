import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///
/// @Desc:
/// @Author: zhhli
/// @Date: 2021-04-08
///
///

/// 通用的footer
///
/// 由于国际化需要context的原因,所以无法在[RefreshConfiguration]配置
class RefresherFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClassicFooter(
      // failedText: 'failedText',
      // idleText: 'idleText',
      loadingText: '加载中...',
      // noDataText: "已展示最近一年的通话记录，没有更多了",
      noDataText: " ",
      canLoadingText: "下拉查看更多通话记录",
    );
  }
}
