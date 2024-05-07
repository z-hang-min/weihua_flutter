import 'package:weihua_flutter/model/apple_pay_result.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';

class ApplePayModel extends ViewStateModel {
  Map _disturbResultMap = {};

  Map get disturbResultMap => _disturbResultMap;

  void updateDisturbValue(Map distrub) {
    _disturbResultMap = distrub;
    notifyListeners();
  }

//0:购买号码，1:号码升级，2:续费，3:语音通知次数，4:分机续费，5:购买新分机，
  Future<Map> createAppleOrder(String number, String bindPhone, int price,
      String ptype, String wareid, String appgoodid,String pname) async {
    setBusy();
    try {
      GetapplepayordertResult result = await salesHttpApi.createApplePayOrder(
          number, bindPhone, price, ptype, wareid, appgoodid,pname);
      setIdle();
      updateDisturbValue(result.applepayorder);
      return result.applepayorder;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      return {};
    }
  }

  Future<bool> queryapplepayresult(
      String num,
      String osinfo,
      String transactionid,
      String receiptdata,
      String appgoodid,
      int fee,
      String orderid,
      String ptype,
      String validtime,
      String groupid) async {
    setBusy();
    try {
      await salesHttpApi.queryapplepayresult(num, osinfo, transactionid,
          receiptdata, appgoodid, fee, orderid, ptype, validtime, groupid);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      return false;
    }
  }
}
