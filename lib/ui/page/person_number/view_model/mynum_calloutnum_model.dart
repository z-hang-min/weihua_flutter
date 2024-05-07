import 'package:weihua_flutter/model/getmycallnum_result.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';

class MyCalloutnumMode extends ViewStateModel {
  late Map _myCalloutnumMap = {};

  Map get myCalloutnumMap => _myCalloutnumMap;

  void getMyCalloutnumlistValue(Map myCalloutnumMap) {
    _myCalloutnumMap = myCalloutnumMap;
    notifyListeners();
  }

  Future<Map> getcalloutnum(String mobile) async {
    setBusy();
    try {
      GetMyCalloutNumResult result =
          await salesHttpApi.querycallounumList(mobile);
      setIdle();
      notifyListeners();
      getMyCalloutnumlistValue(result.calloutNumList);
      return result.calloutNumList;
    } catch (e) {
      // setError(e, s);
      return {};
    }
  }

  Future<bool> updatecalloutnumstate(String mobile, String number) async {
    String innerNum = '';
    int customID = 0;
    accRepo.unifyLoginResult!.numberList.forEach((element) {
      if (element.outerNumber == number && element.innerNumber == "1000") {
        //总机号相等，且分机为1000，设置外显为总机
        //代表设置的是总机
        number = element.outerNumber!;
        innerNum = element.innerNumber!;
        customID = element.customId!;
      } else if (number == "${element.outerNumber}${element.innerNumber}") {
        //分机总机一样
        number = element.outerNumber!;
        innerNum = element.innerNumber!;
        customID = element.customId!;
      }
    });
    setBusy();
    try {
      await salesHttpApi.updateCalloutNumState(
          mobile,
          number.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
          "$customID",
          innerNum);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      return false;
    }
  }

  Future<bool> cancelcalloutnum(String mobile, String number,String id) async {
    setBusy();
    try {
      await salesHttpApi.cancelaccount(
          mobile, number.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),id);
      setIdle();
      return true;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      return false;
    }
  }
}
