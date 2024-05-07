import 'package:weihua_flutter/model/nodisturb_result.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';

class NodisturbMode extends ViewStateModel {
  Map _disturbResultMap = {};

  Map get disturbResultMap => _disturbResultMap;

  void updateDisturbValue(Map distrub) {
    _disturbResultMap = distrub;
    notifyListeners();
  }

  Future<Map> querynodistrub(String number) async {
    setBusy();
    try {
      NodisturbResult result = await salesHttpApi
          .querynodistrub(number.replaceAll(new RegExp(r"\s+\b|\b\s"), ""));
      setIdle();
      updateDisturbValue(result.disturbResultMap);
      return result.disturbResultMap;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      return {};
    }
  }

  Future<bool> updatenodisturbstate(String number, int status) async {
    setBusy();
    try {
      await salesHttpApi.updatenodisturbstate(
          number.replaceAll(new RegExp(r"\s+\b|\b\s"), ""), status);
      setIdle();
      // updateTransferValue(transfer);
      // StorageManager.sharedPreferences!
      //     .setBool(kAnswerModeApp, transfer == 0 ? true : false);
      return true;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      return false;
    }
  }

  Future<bool> nodisturbset(
      String number, String start, String end, String weeks) async {
    setBusy();
    try {
      await salesHttpApi.nodisturbset(
          number.replaceAll(new RegExp(r"\s+\b|\b\s"), ""), start, end, weeks);
      setIdle();
      // updateDisturbValue(_distrub);
      // StorageManager.sharedPreferences!
      //     .setBool('DisturbState', _distrub == 0 ? true : false);
      return true;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      return false;
    }
  }
}
