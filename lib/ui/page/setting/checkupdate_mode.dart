import 'package:weihua_flutter/model/check_update_result.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';
import 'package:weihua_flutter/service/app_http_api.dart';

class CheckUpdateMode extends ViewStateModel {
  Future<CheckUpdateResult?> checkUpdate() async {
    CheckUpdateResult? checkUpdateResult;
    setBusy();
    try {
      checkUpdateResult = await httpApi.checkUpdate();
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
    return checkUpdateResult;
  }
}
