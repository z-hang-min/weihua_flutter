import 'package:weihua_flutter/get_x/xview_state_refresh_list_model.dart';
import 'package:weihua_flutter/model/record_detail_list_result.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:get/get.dart';

class XDataStatisticsViewModel
    extends XViewStateRefreshListModel<RecordDetail> {
  var sendType = 2.obs;
  var statisticType = 1.obs;
  var recentDateType = 4.obs;

  @override
  Future<List<RecordDetail>> loadData({int pageNum = 1}) async {
    List<RecordDetail> listData = await salesHttpApi.getRecordDetailListResult(
        accRepo.user!.mobile!,
        pageNum,
        sendType.value,
        statisticType.value,
        recentDateType.value);
    asyncHttp(() async {});
    return listData;
  }
}
