import 'package:weihua_flutter/config/const_config.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/get_x/get_view_model.dart';
import 'package:weihua_flutter/model/ware_info_result.dart';
import 'package:weihua_flutter/model/wx_pay_order.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class XRenewExtensionNumMode extends XViewController {
  var wxPay = WxPayOrder().obs;
  var wareInfo = WareInfoResult().obs;
  var wxPayResult = false.obs;
  var isCreateOrderIng = false.obs;

  Future<void> wxPayOrder(String orderid) async {
    isCreateOrderIng.value = true;
    asyncHttp(() async {
      var result = await salesHttpApi.createWxPayOrder(
          accRepo.user!.outerNumber!,
          accRepo.user!.mobile!,
          wareInfo.value.price,
          4,
          validtime: wareInfo.value.validTime,
          wareid: '${wareInfo.value.wareid}',
          orderid: orderid);
      wxPay.value = result;
      wxPay.refresh();
      payType = ConstConfig.pay_type_renewext;
      salesHttpApi.doWxpay(result);
    });
  }

  Future<WareInfoResult?> getWareInfo(String validtime, String orderId) async {
    setBusy();
    try {
      wareInfo.value = await salesHttpApi.getWareInfo(validtime, orderId);

      setIdle();
      return wareInfo.value;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      return null;
    }
  }
}
