import 'package:weihua_flutter/model/share_msg_result.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/platform_utils.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluwx/fluwx.dart';
import 'package:oktoast/oktoast.dart';

class ShareHelper {
  static Future<bool> shareToSms(BuildContext context, String sms) async {
    if (Platform.isAndroid) sms = sms.replaceAll('&', '%26');
    // var _result = await launchSms(
    //   message: sms,
    // ).catchError((onError) {
    //   print(onError);
    // });
    // print(_result);
    return true;
  }

  static Future<void> doWeChatShare(
      BuildContext context, ShareMsgResult shareMsgResult) async {
    var result = await isWeChatInstalled;
    if (!result) {
      showToast("无法打开微信 请检查是否安装了微信");
      return;
    }
    //分享后打开的图文连接
    String linkUrl = "${shareMsgResult.url}";
    //分享的小图片
    String imageUrl = "${shareMsgResult.image}";

    /// 分享到好友
    var model = WeChatShareWebPageModel(
      //链接
      linkUrl,
      //标点
      title: "${shareMsgResult.title}",
      description: '${shareMsgResult.contentWx}',
      //小图
      thumbnail: WeChatImage.network(imageUrl),
      //微信消息
      scene: WeChatScene.SESSION,
    );

    shareToWeChat(model).then((value) {});
  }
}
