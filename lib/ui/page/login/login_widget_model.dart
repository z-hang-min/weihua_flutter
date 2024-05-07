import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:flutter/material.dart';

///
/// @Desc: login ui 布局部分
/// @Author: zhhli
/// @Date: 2021-03-22
///
class LoginWidgetModel extends ChangeNotifier {
  var _clickable = false;
  var _checkedAgreement = false;

  var _clearPhone = false;
  var _clearCode = false;

  var _phone = "";
  var _code = "";

  static final _codeText = "获取验证码";
  var _tick = 0;
  var _tickText = _codeText;

  // 显示获取语音验证码
  var _showAudioCodeText = false;

  get loginClickable => _clickable;

  get checkedAgreement => _checkedAgreement;

  get clearPhone => _clearPhone;
  get clearCode => _clearCode;

  get tick => _tick;

  get tickText => _tickText;
  get showAudioCodeText => _showAudioCodeText;

  void updateClickable(bool clickable) {
    _clickable = clickable;
    notifyListeners();
  }

  void updateChecked(bool checked) {
    _checkedAgreement = checked;
    notifyListeners();
  }

  void updatePhone(String phone) {
    _phone = phone;
    _clearPhone = StringUtils.isNotEmptyString(_phone);
    _verify();
  }

  void updateCode(String code) {
    _code = code;
    _clearCode = StringUtils.isNotEmptyString(_code);
    _verify();
  }

  void _verify() {
    var phone = StringUtils.isNotEmptyString(_phone);
    var code = StringUtils.isNotEmptyString(_code);
    //_clickable = phone && code && _checked;
    _clickable = phone && code;
    notifyListeners();
  }

  void updateTick(int tick) {
    _tick = tick;

    if (_tick == 0) {
      _tickText = _codeText;
    } else if (_tick == 40) {
      updateAudioTick(0);
    } else {
      _tickText = '$_tick s';
    }
    notifyListeners();
  }

  void updateAudioTick(int tick) {
    _showAudioCodeText = tick == 0;

    notifyListeners();
  }
}
