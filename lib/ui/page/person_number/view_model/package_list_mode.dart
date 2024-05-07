import 'package:weihua_flutter/get_x/get_view_model.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/package_item.dart';
import 'package:get/get.dart';

class XPackageListMode extends XViewController {
  var selectBusiness = ''.obs;
  var packageList = [].obs;
  var checkedIndex = 0.obs;
  var packageItemList = [].obs;

  PackageItem? getCheckItem() {
    if (packageItemList.isEmpty) return new PackageItem();
    return packageItemList[checkedIndex.value];
  }

  void getPackageList(String channel) {
    asyncHttp(() async {
      var businessResult = await salesHttpApi.getPackagesListResult(channel);
      packageItemList.value = businessResult;
    });
  }

  void clearCash() {
    packageItemList.clear();
  }
}
