import 'package:weihua_flutter/config/storage_manager.dart';
import 'package:weihua_flutter/model/unify_login_result.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';
import 'package:weihua_flutter/service/app_http_api.dart';
import 'package:weihua_flutter/view_model/user_model.dart';

///
/// @Desc: 登录模块
/// @Author: zhhli
/// @Date: 2021-03-22
///
///

const String kLoginPhone = 'kLoginPhone';

class LoginModel extends ViewStateModel {
  final UserModel userModel;

  //
  //
  LoginModel(this.userModel);

  String? getLoginPhone() {
    return StorageManager.sharedPreferences!.getString(kLoginPhone);
  }

  Future<UnifyLoginResult?> login(loginName, password) async {
    setBusy();
    try {
      var user = await httpApi.login(loginName, password);

      userModel.saveUnifyLoginResult(user);
      // StorageManager.sharedPreferences
      //     .setString(kLoginPhone, userModel.user.phone);
      setIdle();
      return user;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      return null;
    }
  }

  Future<bool> sendCode(mobile, codeType) async {
    setBusy();
    try {
      await httpApi.sendCode(mobile, codeType);
      setIdle();
      return true;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      return false;
    }
  }
// Future<bool> logout() async {
//   if (!userModel.hasUser) {
//     //防止递归
//     return false;
//   }
//   setBusy();
//   try {
//     // await httpApi.logout(userModel.user.id.toString());
//     userModel.clearUser();
//     setIdle();
//     return true;
//   } catch (e, s) {
//     setError(e,s);
//     return false;
//   }
// }

}
