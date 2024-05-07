import 'package:weihua_flutter/get_x/xview_state_refresh_list_model.dart';
import 'package:weihua_flutter/model/order_record.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:weihua_flutter/utils/log.dart';

class XOrderManagerViewModel extends XViewStateRefreshListModel<OrderRecord> {
  @override
  Future<List<OrderRecord>> loadData({int pageNum = 1}) async {
    Log.d("loadMoreData");
    List<OrderRecord> listData = await salesHttpApi.loadOrderRecordFClound(
        // '18518443228', pageSize, pageNum);
        '${accRepo.user!.mobile}',
        pageSize,
        pageNum);
    asyncHttp(() async {});
    return listData;
  }
}
