import 'package:weihua_flutter/config/storage_manager.dart';
import 'package:weihua_flutter/model/enterprise_info_result.dart';
import 'package:weihua_flutter/model/query_info_result.dart';
import 'package:weihua_flutter/model/query_login_num_iscancel.dart';
import 'package:weihua_flutter/model/unify_login_result.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/app_http_api.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/home_enterprise_address_model.dart';
import 'package:weihua_flutter/ui/page/login/login_model.dart';
import 'package:weihua_flutter/view_model/user_model.dart';

class QueryInfoMode extends ViewStateModel {
  String? businessId = '';
  int? nullstatus;
  int? morebusinessStatus;
  String? morebusinessId = '';
  String? numberType = '';

  // late Map _infoStrMap = {};
  // Map get infoStrMap => _infoStrMap;

  // void getinfoStrMapValue(Map infoStrMap) {
  //   _infoStrMap = infoStrMap;
  //   notifyListeners();
  // }
  List? thisenterpriseList = [];

  final UserModel userModel;
  final HomeBusinessContactModel? homeBusinessContactModel;

  QueryInfoMode(this.userModel, {this.homeBusinessContactModel});

  Future<QueryInfoResult?> queryInfo() async {
    QueryInfoResult? queryInfoResult;
    setBusy();
    try {
      queryInfoResult = await httpApi.queryInfo(
          userModel.user!.innerNumberId!, userModel.user!.outerNumberId);
      if (queryInfoResult != null) {
        userModel.user!.mobile = queryInfoResult.mobile;
        userModel.saveFunctionList(queryInfoResult.functionList);
        homeBusinessContactModel?.updateEnterprise(queryInfoResult.customName!);
      }
      StorageManager.sharedPreferences!
          .setString(kLoginPhone, userModel.user!.mobile ?? '');
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
    return queryInfoResult;
  }

  Future<void> checkLogin() async {
    setBusy();
    try {
      UnifyLoginResult unifyLoginResult =
          await httpApi.checkLogin(userModel.user!.mobile!);
      userModel.saveUnifyLoginResult(unifyLoginResult);
      setIdle();
    } catch (e, s) {
      setIdle();
      setError(e, s);
    }
    return null;
  }

  Future<LoginNumCancelResult?> queryLoginNumIsCancel(
      String mobile, int innerNumberId, int outerNumberId) async {
    LoginNumCancelResult? result;
    setBusy();
    try {
      result = await httpApi.queryLoginNumIsCancel(
          mobile, innerNumberId, outerNumberId);
      setIdle();
    } catch (e, s) {
      setError(e, s);
      setIdle();
    }
    return result;
  }

  Future<void> getinfoString(bool result) async {
    List<NumberInfo> enterpriseList =
        StorageManager.localStorage.getItem("enterpriseList");
    for (int i = 0; i < enterpriseList.length; i++) {
      if (enterpriseList[i].number == accRepo.user!.outerNumber!) {
        numberType = enterpriseList[i].numberType;
        if (enterpriseList[i].businessInfos.length == 0) {
          businessId = "";
          nullstatus = enterpriseList[i].status;
        } else if (enterpriseList[i].businessInfos.length == 1) {
          thisenterpriseList!.clear();
          thisenterpriseList!.add(enterpriseList[i].businessInfos);
          businessId =
              enterpriseList[i].businessInfos[0].businessInfoId.toString();
        } else if (enterpriseList[i].businessInfos.length == 2) {
          thisenterpriseList!.clear();
          for (int j = 0; j < enterpriseList[i].businessInfos.length; j++) {
            thisenterpriseList!.add(enterpriseList[i].businessInfos[j]);
            if (enterpriseList[i].businessInfos[j].status == 1) {
              businessId =
                  enterpriseList[i].businessInfos[j].businessInfoId.toString();
            } else {
              morebusinessId =
                  enterpriseList[i].businessInfos[j].businessInfoId.toString();
              morebusinessStatus = enterpriseList[i].businessInfos[j].status;
            }
          }
        }
      }
    }

    // infoStrMap['businessId'] = businessId;
    // infoStrMap['nullstatus'] = nullstatus;
    // infoStrMap['morebusinessId'] = morebusinessId;
    // infoStrMap['numberType'] = numberType;
    // infoStrMap['morebusinessStatus'] = morebusinessStatus;
    notifyListeners();
    // getinfoStrMapValue(infoStrMap);
  }
}
