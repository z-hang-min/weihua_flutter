import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/model/functionList.dart';
import 'package:weihua_flutter/model/unify_login_result.dart';
import 'package:weihua_flutter/model/user.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/ui/page/call/call_widget.dart';
import 'package:flutter/cupertino.dart';

class UserModel extends ChangeNotifier {
  User? get user => accRepo.user;

  UnifyLoginResult get unifyLoginResult => accRepo.unifyLoginResult!;

  bool get hasUser => user != null;

  bool get hasLoginResult => unifyLoginResult != null;

  UserModel();

  saveUser(User user) {
    accRepo.saveUser(user);
    notifyListeners();
  }

  saveUnifyLoginResult(UnifyLoginResult unifyLoginResult) {
    accRepo.saveUnifyLoginResult(unifyLoginResult);
    notifyListeners();
  }

  saveFunctionList(List<PermissionData>? _functionList) {
    user?.functionList = _functionList;
    notifyListeners();
  }

  /// 清除持久化的用户数据
  clearUser() {
    accRepo.clearUser();
    lastNum = '';
    isLogin = false;
    payType = 0;
    // notifyListeners();
  }
}
