import 'package:weihua_flutter/db/phone_area_db_utils.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';

class QueryAreaMode extends ViewStateModel {
  // Future<String> queryArea(String phone) async {
  //   phone = phone.replaceAll(' ', '');
  //   if (!PhoneAreaDbUtils.isPhoneNum(phone)) return "未知";
  //   QueryAreaResult reult;
  //   setBusy();
  //   try {
  //     reult = await httpApi.queryArea(phone);
  //     setIdle();
  //     if (reult.provinceName == reult.cityName)
  //       return reult.cityName! + " " + reult.agentName!;
  //     else
  //       return reult.provinceName! +
  //           " " +
  //           reult.cityName! +
  //           " " +
  //           reult.agentName!;
  //   } catch (e, s) {
  //     setError(e, s);
  //     setIdle();
  //     print(e);
  //     return "未知";
  //   }
  // }

  Future<String> queryArea(String phone) async {
    phone = phone.replaceAll(' ', '');
    if (!PhoneAreaDbUtils.isPhoneNum(phone)) return " ";
    String reult;
    setBusy();
    try {
      reult = await PhoneAreaDbUtils.getInstance().queryArea(phone);
      setIdle();
      return reult;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      print(e);
      return "未知";
    }
  }
}
