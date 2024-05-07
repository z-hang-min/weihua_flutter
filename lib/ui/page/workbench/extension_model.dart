// import 'package:weihua_flutter/config/storage_manager.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:weihua_flutter/model/extension_result.dart';

class ExtensionInfoMode extends ViewStateModel {
  String enterpriseImageurl = "";
  List<ExtensionResult>? extensionRsult;
  String? _changePhone;

  String? get changePhone => _changePhone;

 Future<void> ischangePhone(String phone) async {
   _changePhone = phone; 
   notifyListeners(); 
  }

  Future<void> getextensionmanagementInfo(String number) async {
    setBusy();
    try {
      extensionRsult = await salesHttpApi.getextensionmanagementInfo(number);
      setIdle();
    } catch (e, s) {
      setError(e, s);
      setIdle();
    }
  }

  Future<bool> editboactiveExtension(
      String outnumber, String innernumber, String name, String oid) async {
    setBusy();
    try {
      await salesHttpApi.editnoactiveExtension(
          outnumber, innernumber, name, oid);
      setIdle();
      return true;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      return false;
    }
  }

  Future<bool> editactiveExtension(String outnumber, String innernumber,
      String name, String oid, String mobile, String code) async {
    setBusy();
    try {
      await salesHttpApi.editactiveExtension(
          outnumber, innernumber, name, oid, mobile, code);
      setIdle();
      return true;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      return false;
    }
  }

  Future<bool> activeExtension(
      String outnumber, String oid, String mobile, String code) async {
    setBusy();
    try {
      await salesHttpApi.activeExtension(outnumber, oid, mobile, code);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      return false;
    }
  }

  Future<bool> deleteExtension(String outnumber, String oid) async {
    setBusy();
    try {
      await salesHttpApi.deleteExtension(outnumber, oid);
      setIdle();
      return true;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      return false;
    }
  }

  Future<bool> sendextensionCode(mobile) async {
    setBusy();
    try {
      await salesHttpApi.sendBindCode(mobile);
      setIdle();
      return true;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      return false;
    }
  }
}
