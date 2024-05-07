import 'package:weihua_flutter/get_x/get_view_model.dart';
import 'package:weihua_flutter/model/share_msg_result.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class XShareMsgMode extends XViewController {
  var shareMsg = ShareMsgResult().obs;

  Future<void> getShareMsg(String oid) async {
    asyncHttp(() async {
      shareMsg.value = await salesHttpApi.getShareMsg(oid);
    });
  }
}
