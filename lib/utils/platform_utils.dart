import 'dart:async';
import 'dart:io';

import 'package:weihua_flutter/utils/platform_utils.dart';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

export 'dart:io';

/// 是否是生产环境
const bool inProduction = const bool.fromEnvironment("dart.vm.product");

class PlatformUtils {
  static Future<PackageInfo> getAppPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getBuildNum() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  static Future getDeviceInfo() async {
    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // if (Platform.isAndroid) {
    //   return await deviceInfo.androidInfo;
    // } else if (Platform.isIOS) {
    //   return await deviceInfo.iosInfo;
    // } else {
    //   return null;
    // }
  }
}
