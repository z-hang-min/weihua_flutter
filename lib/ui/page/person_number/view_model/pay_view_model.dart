import 'package:weihua_flutter/config/const_config.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/get_x/get_view_model.dart';
import 'package:weihua_flutter/model/unify_login_result.dart';
import 'package:weihua_flutter/model/wx_pay_order.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/app_http_api.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:get/get.dart';

///
/// @Desc: 购买订单详情页面 view model
///
/// @Author: zm
///
///
class XPayViewModel extends XViewController {
  RxString editPhone = "".obs;
  RxString number = "".obs;
  RxString code = "".obs;
  RxString bindPhone = "".obs;
  RxBool btnBuy = false.obs;
  RxBool wechatPayChecked = true.obs;
  var wxPay = WxPayOrder().obs;
  var wxPayResult = false.obs;
  var isCreateOrderIng = false.obs;

  Future<WxPayOrder> wxPayOrder(String number, double price) async {
    isCreateOrderIng.value = true;
    asyncHttp(() async {
      var result = await salesHttpApi.createWxPayOrder(
          number, bindPhone.value, price, 0);
      wxPay.value = result;
      wxPay.refresh();
      payType = ConstConfig.pay_type_buyNum;
      salesHttpApi.doWxpay(result);
    });
    return wxPay.value;
  }



  void changePay() {
    wechatPayChecked.value = !wechatPayChecked.value;
  }

  void clearCache() {
    bindPhone.value = "";
    editPhone.value = "";
    code.value = "";
    btnBuy.value = false;
    wechatPayChecked.value = true;
  }
}
