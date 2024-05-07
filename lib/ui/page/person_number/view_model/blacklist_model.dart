import 'package:weihua_flutter/model/query_blacklist_result.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';

class BlacklistMode extends ViewStateModel {
  late Map _blacklistMap = {};

  Map get blacklistMap => _blacklistMap;

  void updateblacklistValue(Map distrub) {
    _blacklistMap = distrub;
    notifyListeners();
  }

  Future<Map> queryblacklist(String owner, String page) async {
    setBusy();
    try {
      QueryBlacklistResult result = await salesHttpApi.queryblacklist(
          owner.replaceAll(new RegExp(r"\s+\b|\b\s"), ""), page);
      setIdle();
      updateblacklistValue(result.blackListResult);
      return result.blackListResult;
    } catch (e) {
      // setError(e, s);
      return {};
    }
  }

  Future<bool> updateblackliststate(String owner, int status) async {
    setBusy();
    try {
      await salesHttpApi.updateblackliststate(
          owner.replaceAll(new RegExp(r"\s+\b|\b\s"), ""), status);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      return false;
    }
  }

  Future<bool> addblacklist(String owner, String number, String remark) async {
    setBusy();
    try {
      await salesHttpApi.addblacklist(
          owner.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
          number.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
          remark);
      setIdle();
      return true;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      return false;
    }
  }

  Future<bool> deleteblacklist(
      String owner, String number, String remark) async {
    setBusy();
    try {
      await salesHttpApi.deleteblacklist(
          owner.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
          number.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
          remark);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      return false;
    }
  }
}
