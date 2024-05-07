import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/service/app_http_api.dart';
import 'package:weihua_flutter/ui/page/call/call_widget.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/home_enterprise_address_model.dart';
import 'package:weihua_flutter/ui/page/tab/home_contact_list_page.dart';
import 'package:weihua_flutter/ui/page/tab/tab_navigator.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/view_model/user_model.dart';


/// h5 js 交互帮助类
/// 
/// 
/// help.regist(WebHandleCall());
/// help.regist(WebHandleContact());
/// help.regist(WebHandleCommon());
///
/// help.regist(WebHandleCallBack(onBackUrl: (backUrl2) {
///   backUrl = backUrl2;
/// }, onNewTitle: (newTitle) {
///   //
/// }, onShowCancel: (showCancle2) {
///   showCancle = showCancle2;
/// }));
/// 
/// 
/// help.handle(context, _webController, request)
class WebHandleHelp {
  List<WebHandle> list = [];

  void regist(WebHandle handle) {
    list.add(handle);
  }

  NavigationDecision handle(BuildContext context, WebViewController controller,
      NavigationRequest request) {
    for (var item in list) {
      NavigationDecision decision = item.handle(context, controller, request);
      if (decision == NavigationDecision.prevent) {
        return decision;
      }
    }

    return NavigationDecision.navigate;
  }
}

abstract class WebHandle {
  NavigationDecision handle(BuildContext context, WebViewController controller,
      NavigationRequest request);
}


/// 通话相关
class WebHandleCall extends WebHandle {
  @override
  NavigationDecision handle(BuildContext context, WebViewController controller,
      NavigationRequest request) {
    if (request.url.startsWith("appcall://")) {
      print("即将拨打语音通话 ${request.url.substring(10)}");
      return NavigationDecision.prevent;
    }

    if (request.url.startsWith("telcall://")) {
      print("即将拨打普通通话 ${request.url.substring(10)}");
      _doSysCallOut(context, request.url.substring(10));
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  void _doSysCallOut(BuildContext context, String number) async {
    lastNum = number;
    Get.off(
        TabNavigator(
          jumpIndex: 0,
        ),
        preventDuplicates: false);
  }

  // Future<void> _sysCall(String number) async {
  //   if (!number.startsWith('95013')) number = "95013" + number;
  //   String url = 'tel:' + number;
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}


/// 联系人相关
class WebHandleContact extends WebHandle {
  @override
  NavigationDecision handle(BuildContext context, WebViewController controller,
      NavigationRequest request) {
    if (request.url.startsWith("refreshcontacts://")) {
      Log.d("刷新联系人");
      _refreshContacts(context);
      return NavigationDecision.prevent;
    }

    if (request.url.startsWith("refreshcustomname://")) {
      String name = request.url.substring(20);
      name = Uri.decodeComponent(name);
      _refreshCustomName(context, name);
      return NavigationDecision.prevent;
    }

    if (request.url.startsWith("selectcontact://")) {
      //打开联系人界面
      Navigator.of(context)
          .push(MaterialPageRoute(
        builder: (context) => HomeContactListPage(
          onSelectcontact: true,
        ),
      ))
          .then((value) {
        Log.d("selectcontact==$value");
        controller.evaluateJavascript("receiveAppChooseData($value)");
      });
      return NavigationDecision.prevent;
    }
      if (request.url.startsWith("h5contact://")) {
        Log.d("h5contact ==${request.url}");
        //H5返回给flutter数据
        String h5contact = request.url.substring(12);
        // h5contact = Uri.decodeComponent(h5contact);
        Log.d("h5contact ==$h5contact");
        Navigator.pop(context, h5contact);
        return NavigationDecision.prevent;
      }

    return NavigationDecision.navigate;
  }

  _refreshContacts(BuildContext context) {
    Provider.of<HomeBusinessContactModel>(context, listen: false)
        .queryBusinessContactVersion();
  }

  _refreshCustomName(BuildContext context, String name) {
    Provider.of<HomeBusinessContactModel>(context, listen: false)
        .updateEnterprise(name);
  }
}

/// 一般性 交互
/// 待进一步细分
class WebHandleCommon extends WebHandle {
  String lastUrl = "";

  @override
  NavigationDecision handle(BuildContext context, WebViewController controller,
      NavigationRequest request) {
    if (request.url.startsWith("gotologinpage://")) {
      _logOut(context);
      return NavigationDecision.prevent;
    }

    if (request.url.startsWith("hidekeyboard://")) {
      //全部小写
      _hideKeyboard(context);
      return NavigationDecision.prevent;
    }

    if (request.url.startsWith("querynetwork://")) {
      String state = request.url.substring(15);
      controller.evaluateJavascript('network($ishavenet,$state)');
      return NavigationDecision.prevent;
    }

    if (Platform.isAndroid && request.url.contains("weihua/organization")) {
      controller.loadUrl(request.url, headers: {
        "Referer": lastUrl,
      });
      lastUrl = request.url;
      return NavigationDecision.prevent;
    }

    if (request.url.startsWith("downloadfromh5://")) {
      String h5Url = request.url.substring(17);
      // h5Url = Uri.decodeComponent(h5Url);
      Log.d("h5Url==$h5Url");
      if (h5Url.isEmpty) return NavigationDecision.prevent;

      httpApi.downloadFile(h5Url);
      return NavigationDecision.prevent;
    }
    if (request.url.startsWith("jumpworkbench://")) {
      //关闭H5页面
      Navigator.pop(context);
      return NavigationDecision.prevent;
    }

    if (request.url.startsWith("reexamine://")) {
      String bussinessId = request.url.substring(12);
      bussinessId = Uri.decodeComponent(bussinessId);
      Navigator.pushNamed(context, RouteName.certificationPage,
          arguments: bussinessId);

      return NavigationDecision.prevent;
    }

    if (request.url.startsWith("upgradenum://")) {
      Get.toNamed(RouteName.pNumberUpgrade);
      return NavigationDecision.prevent;
    }

    if (request.url.startsWith("buynum://")) {
      Get.toNamed(RouteName.pNumberBuy);
      return NavigationDecision.prevent;
    }

    if (request.url.startsWith("renew://")) {
      Get.toNamed(RouteName.pNumberRenew);
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  ///隐藏H5键盘
  _hideKeyboard(BuildContext context) {
    // FocusScope.of(context).requestFocus(_pwdNode);
    // Future.delayed(Duration(milliseconds: 500), () {
    //   _pwdNode.unfocus();
    // });
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  _logOut(BuildContext context) {
    Provider.of<UserModel>(context, listen: false).clearUser();
    Navigator.pushNamed(context, RouteName.login);
  }
}

typedef OnNewTitleCallback = void Function(String title);
typedef OnShowCancelCallback = void Function(bool showCancel);
typedef OnBackUrlCallback = void Function(String backUrl);

/// 带有回调的 交互
class WebHandleCallBack extends WebHandle {
  String lastUrl = "";
  bool showCancel = false;

  @override
  NavigationDecision handle(BuildContext context, WebViewController controller,
      NavigationRequest request) {
    if (request.url.startsWith("refreshtitle://")) {
      String newtitle = request.url.substring(15);
      newtitle = Uri.decodeComponent(newtitle);
      onNewTitle(newtitle);
      return NavigationDecision.prevent;
    }

    if (request.url.startsWith("showcancle://")) {
      onShowCancel(!showCancel);
      return NavigationDecision.prevent;
    }

    if (request.url.startsWith("setbackurl://")) {
      String fileURl = request.url.substring(13);
      if (fileURl.startsWith("http//")) {
        fileURl = fileURl.replaceAll("http", "http:");
      }
      if (fileURl.startsWith("https//")) {
        fileURl = fileURl.replaceFirst("https", "https:");
      }

      // backUrl = "http://39.97.232.211:8090" + fileURl;
      String backUrl = fileURl;
      onBackUrl(fileURl);
      Log.d("backUrl==$backUrl");
      Log.d("url==${request.url}");
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  OnNewTitleCallback onNewTitle;
  OnShowCancelCallback onShowCancel;
  OnBackUrlCallback onBackUrl;

  WebHandleCallBack({
    required this.onNewTitle,
    required this.onShowCancel,
    required this.onBackUrl,
  });
}
