import 'package:weihua_flutter/model/enterprise_nameandaddress_result.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:weihua_flutter/model/enterprise_certification_result.dart';

class EnterPriseCertificationMode extends ViewStateModel {
  String enterpriseImageurl = "";
  EnterpriseCertificationResult? enterCerRsult;
NamgeandAddressResult? nameAndAdressReult;
  Future<bool> updateEnterpriseCertification(
      String name,
      String creditcode,
      String license,
      String contact,
      String mobile,
      String tel,
      String update) async {
    setBusy();
    try {
      salesHttpApi.setenterpriseCertification(
          name, creditcode, license, contact, mobile, tel, update);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      return false;
    }
  }
  
  Future<void> getEnterNameAddress(
      String outnumber) async {
    setBusy();
    try {
     nameAndAdressReult = await salesHttpApi.getenterNameAddress(outnumber);
     notifyListeners();
      setIdle();
    } catch (e, s) {
      setError(e, s);
      setIdle();
    }
  }

  Future<bool> setEnterNameAddress(
      String outnumber, String name, String address) async {
    setBusy();
    try {
      await salesHttpApi.setenterNameAddress(outnumber, name, address);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      return false;
    }
  }

  Future<void> getenterpriseCertification(String businessid) async {
    setBusy();
    try {
      enterCerRsult = await salesHttpApi.getenterpriseCertification(businessid);
      setIdle();
      // notifyListeners();

      // return true;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      // return false;
    }
  }

  Future<bool> uploadImage(String imagePath) async {
    setBusy();
    try {
      enterpriseImageurl = await salesHttpApi.upLoadImg(imagePath);
      notifyListeners();
      setIdle();
      return true;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      return false;
    }
  }
}
