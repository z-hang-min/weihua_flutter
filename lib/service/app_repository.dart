import 'package:weihua_flutter/config/net/pgyer_api.dart';
import 'package:weihua_flutter/model/user.dart';
import 'package:flutter/cupertino.dart';

import 'app_http_api.dart';

/// App相关接口
class AppRepository {
  static Future<AppUpdateInfo?> checkUpdate(
      String platform, String version) async {
    debugPrint('检查更新,当前版本为===>$version');
    var response = await http
        .post('app/check', queryParameters: {'buildVersion': version});
    var result = AppUpdateInfo.fromMap(response.data);
    if (result.buildHaveNewVersion ?? false) {
      debugPrint('发现新版本===>${result.buildVersion}');
      //return result;
    }
    debugPrint('没有发现新版本');
    return null;
  }
}
