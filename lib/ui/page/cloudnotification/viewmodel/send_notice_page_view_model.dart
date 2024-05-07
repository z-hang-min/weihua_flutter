import 'package:weihua_flutter/get_x/get_view_model.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../model/notification_model_result.dart';

class XSendNoticePageViewModel extends XViewController {
  RxList listNum = [].obs;
  RxList voiceNumList = [].obs;
  RxString number = ''.obs;
  RxString voiceNoticeNumber = ''.obs;
  RxList templateList = [].obs;
  RxBool voiceNoticeChecked = true.obs;
  RxBool msgNoticeChecked = false.obs;
  var isSending = false.obs;
  var checkedModel = NotificationTemple().obs;

  Future<void> getNotificationModel() async {
    asyncHttp(() async {
      NotificationModelResult result = await salesHttpApi
          .getNotificationModel(accRepo.user!.mobile!, 0, 0, status: 1);
      templateList.value = result.dataList;
      if (templateList.isNotEmpty) checkedModel.value = templateList[0];
    });
  }

  NotificationTemple getNotificationModelList(String temId, String content) {
    if (templateList.isEmpty)
      return NotificationTemple(templateId: temId, templateContent: content);
    return templateList.firstWhere((element) => element.templateId == temId);
  }

  int getType() {
    if (voiceNoticeChecked.isFalse && msgNoticeChecked.isTrue) return 1;
    if (voiceNoticeChecked.isTrue && msgNoticeChecked.isTrue) return 2;
    return 0;
  }

  String callee() {
    if (listNum.isEmpty) return '';
    String callee = '';
    listNum.forEach((element) {
      callee = element + "," + callee;
    });
    return callee;
  }

  Future<bool> sendNotice() async {
    // var sendSuccess;
    if (voiceNoticeChecked.isTrue && voiceNoticeNumber.isEmpty) {
      showToast('请选择号码');
      return false;
    }
    if (checkedModel.value.templateId!.isEmpty) {
      showToast('请选择模板');
      return false;
    }
    if (listNum.isEmpty) {
      showToast('请选择接收号码');
      return false;
    }
    isSending.value = true;
    // asyncHttp(() async {
    //   sendSuccess = await salesHttpApi.sendNotice(
    //       '${accRepo.user!.mobile}',
    //       getType(),
    //       '$voiceNoticeNumber',
    //       '${checkedModel.value.templateId}',
    //       callee());
    //   isSending.value = false;
    // });
    setBusy();
    try {
      await salesHttpApi.sendNotice('${accRepo.user!.mobile}', getType(),
          '$voiceNoticeNumber', '${checkedModel.value.templateId}', callee());
      isSending.value = false;
      setIdle();
      return true;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      return false;
    }
  }

  void initData() {
    this.initialized;
    // voiceNumList.add('公共号池（随机号码)');

    accRepo.unifyLoginResult!.perNumberList.forEach((element) {
      voiceNumList.add(element.outerNumber);
    });
    voiceNoticeNumber.value = voiceNumList[0];
    getNotificationModel();
  }

  bool isChecked(String num) {
    bool isChecked = false;
    if (listNum.isNotEmpty) {
      listNum.forEach((element) {
        if (element == num) {
          isChecked = true;
          return;
        }
      });
    }
    return isChecked;
  }

  void delNum(String num) {
    listNum.remove(num);
  }

  void addNum(String num) {
    listNum.add(num);
  }

  void editNum(String num, String newNum) {
    listNum.remove(num);
    listNum.add(newNum);
  }
}
