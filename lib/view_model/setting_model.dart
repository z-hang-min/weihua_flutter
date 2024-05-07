import 'package:weihua_flutter/config/storage_manager.dart';
import 'package:flutter/cupertino.dart';

/// 使用原生WebView
const String kUseWebViewPlugin = 'kUseWebViewPlugin';

class UseWebViewPluginModel extends ChangeNotifier {
  get value =>
      StorageManager.sharedPreferences!.getBool(kUseWebViewPlugin) ?? false;

  switchValue() {
    StorageManager.sharedPreferences!.setBool(kUseWebViewPlugin, !value);
    notifyListeners();
  }
}
