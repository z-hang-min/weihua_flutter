import 'package:weihua_flutter/config/net/base_api.dart';
import 'package:weihua_flutter/get_x/get_view_model.dart';
import 'package:weihua_flutter/model/wx_pay_order.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:weihua_flutter/model/per_num_check_result.dart';
import 'package:weihua_flutter/utils/time_util.dart';
import 'package:get/get.dart';

///
/// @Desc: 购买个人号码 view model
///
/// @Author: zhhli
///
/// @Date: 21/7/21
///
class XBuyViewModel extends XViewController {
  RxString number = "".obs;
  RxBool tipShow = false.obs;
  RxBool btnBuy = false.obs;
  RxBool ivDelShow = false.obs;
  String appgoodid = "";
  RxString validtime = " ".obs;
  var wxPay = WxPayOrder().obs;
  var perResult = PerNumCheckResult().obs;

  CancelToken? _cancelToken;
  var perNumCheckResult = PerNumCheckResult(
    number: "",
    status: 0,
    price: 0,
    validtime: 0,
    avgPrice: '0',
    sells: 0,
    avgSells: '0',
    seckill: '0',
    appgoodid: "",
  );

  void resetData() {
    tipShow.value = false;
    btnBuy.value = false;
    perResult.value = PerNumCheckResult();
  }

  Future<void> checkNumber(String numbertext) async {
    number.value = numbertext;

    if (numbertext.isEmpty) {
      resetData();
      return;
    }

    _cancelToken?.cancel(codeCancelError);
    _cancelToken = CancelToken();

    setBusy();
    try {
      tipShow.value = false;
      PerNumCheckResult result =
          await salesHttpApi.checkNum(numbertext, _cancelToken);
      if (number.isEmpty) return;
      perNumCheckResult = result;
      tipShow.value = (result.status == 1 ? true : false);
      btnBuy.value = !tipShow.value;
      validtime.value = TimeUtil.formatTimeDot(result.validtime ?? 0);
      ivDelShow.value = true;
      appgoodid = result.appgoodid;
      perResult.value = result;
      setIdle();
    } catch (e, s) {
      setError(e, s);
      // setIdle();
      resetData();
    }
  }
}
