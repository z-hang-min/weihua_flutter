import 'package:weihua_flutter/config/const_config.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/get_x/get_view_model.dart';
import 'package:weihua_flutter/model/wx_pay_order.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/package_item.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class XBuyExtensionNumMode extends XViewController {
  var wxPay = WxPayOrder().obs;
  var wxPayResult = false.obs;
  var isCreateOrderIng = false.obs;
  Future<void> wxPayOrder(PackageItem packageItem) async {
    isCreateOrderIng.value = true;
    asyncHttp(() async {
      var result = await salesHttpApi.createWxPayOrder(
          accRepo.user!.outerNumber!,
          accRepo.user!.mobile!,
          packageItem.price,
          5,
          pname: '${packageItem.name}',
          businessid: '0',
          wareid: '${packageItem.id}');
      wxPay.value = result;
      wxPay.refresh();
      payType = ConstConfig.pay_type_buyext;
      salesHttpApi.doWxpay(result);
    });
  }
}
