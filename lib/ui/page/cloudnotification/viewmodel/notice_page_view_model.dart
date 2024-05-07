import 'package:weihua_flutter/get_x/get_view_model.dart';
import 'package:weihua_flutter/model/record_today.dart';
import 'package:weihua_flutter/model/search_send_times_result.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:get/get.dart';

class XNoticePageViewModel extends XViewController {
  var recordToday = RecordToday().obs;
  var searchTimes = SearchSendTimesResult().obs;

  void getRecordToday() {
    asyncHttp(() async {
      RecordToday result =
          await salesHttpApi.getRecordTodayResult(accRepo.user!.mobile!);
      recordToday.value = result;
    });
  }

  void searchSendTimes() {
    asyncHttp(() async {
      SearchSendTimesResult result =
          await salesHttpApi.searchSendTimes(accRepo.user!.mobile!);
      searchTimes.value = result;
    });
  }
}
