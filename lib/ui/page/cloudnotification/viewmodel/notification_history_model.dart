import 'package:weihua_flutter/model/notification_history_result.dart';
import 'package:weihua_flutter/provider/view_state_refresh_list_model.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';

class NotificationHistoryModel
    extends ViewStateRefreshListModel<NotificationHistory> {
  String mobile = accRepo.user!.mobile!;

  String _callee = '';

  void search(String callee) {
    _callee = callee.trim();
    refresh();
  }

  Future<void> getNotificationHistory(
      int page, int limit, String callee) async {
    setBusy();
    try {
      await salesHttpApi.getNotificationHistory(mobile, page, limit, callee);
      setIdle();
      // return true;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      // return false;
    }
  }

  Future<bool> resendNotification(NotificationHistory history) async {
    setBusy();

    int type;
    if (history.resultIVR != 2 && history.resultMSG == 2) {
      type = 0;
    } else if (history.resultIVR == 2 && history.resultMSG != 2) {
      type = 1;
    } else {
      type = 2;
    }

    try {
      await salesHttpApi.sendNotice(mobile, type, history.caller!,
          history.templateId.toString(), history.callees!);
      setIdle();
      return true;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      return false;
    }
  }

  @override
  Future<List<NotificationHistory>> loadData({int pageNum = 1}) async {
    NotiHistoryResult result = await salesHttpApi.getNotificationHistory(
        mobile, pageNum, pageSize, _callee);
    return result.historyList;
  }
}
