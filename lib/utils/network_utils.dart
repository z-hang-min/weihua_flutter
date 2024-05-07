import 'dart:async';

import 'package:weihua_flutter/event/network_change_event.dart';
import 'package:weihua_flutter/service/event_bus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

import 'log.dart';

class NetWorkUtils {
  static Connectivity _connectivity = Connectivity();

  static StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  static Future<void> initConnectivity() async {
    Log.w("initConnectivity");
    ConnectivityResult connectionStatus;
    //平台消息可能会失败，因此我们使用Try/Catch PlatformException。
    try {
      connectionStatus = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = ConnectivityResult.none;
    }
    Log.w("initConnectivity==$connectionStatus");
    if (connectionStatus == ConnectivityResult.none)
      eventBus.fire(NetworkChangeEvent(false));
    else {
      eventBus.fire(NetworkChangeEvent(true));
    }
    change();
  }

  static change() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      Log.w("initConnectivity result==$result");
      if (result == ConnectivityResult.none)
        eventBus.fire(NetworkChangeEvent(false));
      else
        eventBus.fire(NetworkChangeEvent(true));
    });
  }

  static check() async {
    bool isNetWorkValid = await NetWorkUtils.isNetWorkValid();
    eventBus.fire(NetworkChangeEvent(isNetWorkValid));
  }

  static cancle() {
    _connectivitySubscription?.cancel();
  }

  static Future<bool> isNetWorkValid() async {
    ConnectivityResult connectionStatus =
        await _connectivity.checkConnectivity();
    return connectionStatus != ConnectivityResult.none;
  }

  static Future<bool> isNetWorkInValidWithToast() async {
    ConnectivityResult connectionStatus =
        await _connectivity.checkConnectivity();
    if (connectionStatus == ConnectivityResult.none) {
      showToast('网络连接异常，请检查网络或稍后重试');
    }
    return connectionStatus == ConnectivityResult.none;
  }

  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}
