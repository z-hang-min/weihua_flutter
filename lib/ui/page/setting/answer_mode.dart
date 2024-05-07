import 'package:weihua_flutter/config/storage_manager.dart';
import 'package:weihua_flutter/model/query_transfer_result.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';
import 'package:weihua_flutter/service/app_http_api.dart';

import 'answer_mode_page.dart';

class AnswerMode extends ViewStateModel {
  int _transfer = 0;

  int get transfer => _transfer;

  void updateTransferValue(int transfer) {
    _transfer = transfer;
    notifyListeners();
  }

  Future<bool> queryTransfer(String innerNumberId, String outerNumberId) async {
    setBusy();
    try {
      QueryTransferResult result =
          await httpApi.queryTransfer(innerNumberId, outerNumberId);
      setIdle();
      updateTransferValue(result.transfer);
      return result.transfer == 0;
    } catch (e, s) {
      setError(e, s);
      return false;
    }
  }

  Future<bool> updateTransfer(
      int innerNumberId, int outerNumberId, int transfer) async {
    setBusy();
    try {
      await httpApi.updateTransfer(innerNumberId, outerNumberId, transfer);
      setIdle();
      updateTransferValue(transfer);
      StorageManager.sharedPreferences!
          .setBool(kAnswerModeApp, transfer == 0 ? true : false);
      return true;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      return false;
    }
  }
}
