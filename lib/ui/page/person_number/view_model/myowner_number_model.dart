import 'package:weihua_flutter/model/myownernumber_result.dart';
import 'package:weihua_flutter/model/unify_login_result.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/app_http_api.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';

late String allNumberStr;

class MyOwnernumberMode extends ViewStateModel {
  late List _mynumberlistList = [];
  late UnifyLoginResult unifyLoginResult;
  List get mynumberlistList => _mynumberlistList;

  void updatemynmberlistValue(List mynumberlistList) {
    _mynumberlistList = mynumberlistList;
    notifyListeners();
  }

  Future<bool> checkLogin(String mobile) async {
    // curNum = curNum.replaceAll(" ", '');
    setBusy();
    try {
      unifyLoginResult = await httpApi.checkLogin(mobile);
      accRepo.saveUnifyLoginResult(unifyLoginResult);
      // unifyLoginResult.numberList.forEach((element) {
      //   String outNum = element.outerNumber!.replaceAll(" ", '');
      //   if (outNum == curNum) {
      //     accRepo.saveUser(element);
      //   } else {
      //     accRepo.saveUser(unifyLoginResult.numberList[0]);
      //   }
      // });

      setIdle();
      return true;
    } catch (e, s) {
      setIdle();
      setError(e, s);
    }
    return false;
  }

  Future<List> querymynumberlist() async {
    setBusy();
    try {
      if (unifyLoginResult.perNumberList.length > 0) {
        for (int i = 0; i < unifyLoginResult.perNumberList.length; i++) {
          if (i == 0) {
            allNumberStr = unifyLoginResult.perNumberList[i].outerNumber!;
          } else {
            allNumberStr = allNumberStr +
                "," +
                (unifyLoginResult.perNumberList[i].outerNumber!);
          }
        }
      }
      QueryMynumberlistResult result = await salesHttpApi.querymynumberlist(
          allNumberStr.replaceAll(new RegExp(r"\s+\b|\b\s"), ""));
      setIdle();
      notifyListeners();
      updatemynmberlistValue(result.mynumnerList);
      return result.mynumnerList;
    } catch (e, s) {
      setError(e, s);

      return [];
    }
  }
}
