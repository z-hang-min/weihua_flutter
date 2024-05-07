import 'package:weihua_flutter/config/const_config.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/get_x/get_view_model.dart';
import 'package:weihua_flutter/model/renew_num_package.dart';
import 'package:weihua_flutter/model/wx_pay_order.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:get/get.dart';

class XRenewNumMode extends XViewController {
  var wxPay = WxPayOrder().obs;
  var wxPayResult = false.obs;
  var selectBusiness = ''.obs;
  var selectBusinessIndex = 0.obs;
  var reNewPack = ReNewNumPackage().obs;
  var isCreateOrderIng = false.obs;

  Future<void> wxPayOrder(String businessid, String perNum) async {
    asyncHttp(() async {
      isCreateOrderIng.value = true;
      var result = await salesHttpApi.createWxPayOrder(
          StringUtils.isNotEmptyString(perNum)
              ? perNum
              : accRepo.user!.outerNumber!,
          accRepo.user!.mobile!,
          reNewPack.value.price,
          StringUtils.isNotEmptyString(perNum) ? 6 : 2,
          businessid: StringUtils.isNotEmptyString(perNum) ? '0' : businessid,
          wareid: '${reNewPack.value.wareid}');
      wxPay.value = result;
      wxPay.refresh();
      // isCreateOrderIng.value = false;
      payType = ConstConfig.pay_type_renew;
      salesHttpApi.doWxpay(result);
    });
  }

  void initData(String num) async {
    asyncHttp(() async {
      ReNewNumPackage result = await salesHttpApi.getRenewExtNumPack(
          StringUtils.isEmptyString(num) ? accRepo.user!.outerNumber! : num);
      reNewPack.value = result;
    });
  }

  void getCurrent() async {
    // asyncHttp(() async {
    //   CurrentPackage result = await salesHttpApi
    //       .getCurrentPackageResult(accRepo.user!.outerNumber!);
    //   currentPac.value = result;
    //   currTime.value = reNewPack.value.validtime + currentPac.value.validTime;
    // });
  }
}
