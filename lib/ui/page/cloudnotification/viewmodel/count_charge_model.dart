import 'package:weihua_flutter/config/const_config.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/get_x/get_view_model.dart';
import 'package:weihua_flutter/model/wx_pay_order.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/package_item.dart';
import 'package:get/get.dart';

class XCountChargeModel extends XViewController {
  var wxPay = WxPayOrder().obs;
  var wxPayResult = false.obs;
  var selectBusiness = ''.obs;
  var selectBusinessIndex = -1.obs;
  var isCreateOrderIng = false.obs;

  Future<void> wxPayOrder(PackageItem packageItem) async {
    isCreateOrderIng.value = true;
    asyncHttp(() async {
      var result = await salesHttpApi.createWxPayOrder(
          accRepo.unifyLoginResult!.perNumberList[0].outerNumber!,
          accRepo.user!.mobile!,
          packageItem.price,
          3,
          pname: '${packageItem.name}',
          businessid: '0',
          wareid: '${packageItem.id}');
      wxPay.value = result;
      wxPay.refresh();
      payType = ConstConfig.pay_type_charge;
      salesHttpApi.doWxpay(result);
    });
  }
}
