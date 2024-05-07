
import 'package:weihua_flutter/get_x/get_view_model.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:weihua_flutter/utils/timer_util.dart';
import 'package:get/get.dart';

///
/// @Desc: 更改绑定手机号 view model
///
/// @Author: zm
///
///
class XEditPhoneViewModel extends XViewController {
  RxString number = "".obs;
  RxString editPhone = "".obs;
  RxString code = "".obs;
  RxInt tick = 0.obs;

// 定时器相关
  // 验证码计时器
  TimerUtil? _timerUtil;
  TimerUtil? _timerAudioCode;

  int _totalTime = 60 * 1000;

  void startTimer() {
    _timerUtil = TimerUtil(mTotalTime: _totalTime);
    _timerUtil!.setOnTimerTickCallback((millisUntilFinished) {
      double _tick = millisUntilFinished / 1000;
      if (_tick == 0) {
        _timerUtil?.cancel();
      }
      tick.value = _tick.toInt();
    });

    _timerAudioCode = TimerUtil(mTotalTime: 20 * 1000);
    _timerAudioCode!.setOnTimerTickCallback((millisUntilFinished) {
      double _tick = millisUntilFinished / 1000;
      if (_tick == 0) {
        _timerAudioCode?.cancel();
      }
      tick.value = _tick.toInt();
    });
    _timerUtil?.updateTotalTime(_totalTime);
  }

  bool isTimerActive() {
    if (_timerUtil == null) return false;
    return _timerUtil!.isActive();
  }

  void stopTimer() {
    _timerUtil?.cancel();
    _timerUtil = null;
    _timerAudioCode?.cancel();
    _timerAudioCode = null;
  }

  void clearCache() {
    number.value = "";
    editPhone.value = "";
    code.value = "";
  }

  Future<bool> sendCode() async {
    return asyncHttp(() async {
      await salesHttpApi.sendBindCode(editPhone.value);
    });
  }

  Future<bool> register() async {
    return asyncHttp(() async {
      await salesHttpApi.register(editPhone.value, code.value);
    });
  }
}
