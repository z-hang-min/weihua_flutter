import 'package:weihua_flutter/get_x/get_view_model.dart';
import 'package:weihua_flutter/model/user.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/package_item.dart';
import 'package:get/get.dart';

class XUpgradePerNumMode extends XViewController {
  var selectNumIndex = 0.obs;
  var wareInfo = PackageItem().obs;
  List<User> perNumList = [];

  void initData() {
    perNumList = accRepo.unifyLoginResult!.perNumberList;
    getWaresInfo();
  }

  Future<bool> doUpgrade() async {
    var selNum = perNumList[selectNumIndex.value].outerNumber!;
    setBusy();
    try {
      await salesHttpApi.doUpgrade(selNum);
      setIdle();
      return true;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      return false;
    }
  }

  Future getWaresInfo() async {
    setBusy();
    try {
      wareInfo.value = await salesHttpApi.getBusinessWareInfo();
      setIdle();
    } catch (e, s) {
      setIdle();
      setError(e, s);
    }
  }
}
