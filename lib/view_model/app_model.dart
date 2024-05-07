import 'dart:io';

import 'package:weihua_flutter/config/net/pgyer_api.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';
import 'package:weihua_flutter/service/app_repository.dart';
import 'package:weihua_flutter/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kAppFirstEntry = 'kAppFirstEntry';

// 主要用于app启动相关
class AppModel with ChangeNotifier {
  bool isFirst = false;

  loadIsFirstEntry() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    isFirst = sharedPreferences.getBool(kAppFirstEntry) ?? true;
    notifyListeners();
  }
}

class AppUpdateModel extends ViewStateModel {
  Future<AppUpdateInfo?> checkUpdate() async {
    AppUpdateInfo? appUpdateInfo;
    setBusy();
    try {
      var appVersion = await PlatformUtils.getAppVersion();
      appUpdateInfo =
          await AppRepository.checkUpdate(Platform.operatingSystem, appVersion);
      setIdle();
    } catch (e, s) {
      setIdle();
      setError(e, s);
    }
    return appUpdateInfo;
  }
}
