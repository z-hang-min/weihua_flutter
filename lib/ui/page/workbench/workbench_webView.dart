import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/service/app_http_api.dart';
import 'package:weihua_flutter/ui/page/call/call_widget.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/home_enterprise_address_model.dart';
import 'package:weihua_flutter/ui/page/tab/home_contact_list_page.dart';
import 'package:weihua_flutter/ui/page/tab/tab_navigator.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/platform_utils.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  final String data;

  WebviewPage(this.data);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  late WebViewController _controller;
  String title = "网页加载中...";
  String lastUrl = "";
  bool showCancle = false;
  String backUrl = "";

  // final FocusNode _pwdNode = FocusNode();
  String wichPage = "普通页";

  _getTitle() async {
    Log.d("正在打开h5: " + widget.data);
    title = await _controller.getTitle() ?? '';

    print(title);
  }

  @override
  void initState() {
    lastUrl = widget.data;
    super.initState();
    // Enable virtual display.
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: wichPage == "普通页"
          ? AppBar(
              title: Text(title),
              leading: new IconButton(
                icon: SvgPicture.asset(ImageHelper.wrapAssets(
                    Theme.of(context).brightness == Brightness.light
                        ? "nav_icon_return.svg"
                        : "nav_icon_return_sel.svg")),
                color: Colors.white,
                onPressed: () {
                  onBack(context);
                },
              ),
              actions: <Widget>[
                Visibility(
                  visible: showCancle,
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "取消",
                        style: TextStyle(fontSize: 16, color: Colour.f1A1A1A),
                      ),
                    ),
                    onTap: () {
                      _controller.evaluateJavascript('multipleCancel()');
                      setState(() {
                        showCancle = false;
                      });
                    },
                  ),
                )
              ],
            )
          : AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color.fromRGBO(71, 117, 253, 1.0),
                      Color.fromRGBO(69, 143, 249, 1.0),
                    ],
                  ),
                ),
              ),
              title: Text(''),
              elevation: 0,
              leading: IconButton(
                icon: SvgPicture.asset(ImageHelper.wrapAssets(
                    Theme.of(context).brightness == Brightness.light
                        ? "nav_icon_return_white.svg"
                        : "nav_icon_return_sel.svg")),
                onPressed: () {
                  onBack(context);
                },
              ),
            ),
      body: WillPopScope(
          onWillPop: () async {
            onBack(context);
            return false;
          },
          child: Container(
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Colors.transparent,
                        width: wichPage == "详情页" ? 1 : 0)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: wichPage == "详情页"
                      ? [
                          Color.fromRGBO(71, 117, 253, 1.0),
                          Color.fromRGBO(69, 143, 249, 1.0),
                        ]
                      : [
                          Color.fromRGBO(71, 117, 253, 0),
                          Color.fromRGBO(69, 143, 249, 0),
                        ],
                ),
              ),
              child: Stack(
                children: [
                  // TextField(
                  //   focusNode: _pwdNode,
                  //   autofocus: false,
                  // ),
                  Center(
                      child: WebView(
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller = webViewController;
                    },
                    debuggingEnabled: true,
                    onPageFinished: (url) {
                      setState(() {
                        _getTitle();
                        if (url.contains("organization_info") ||
                            url.contains("user_info")) {
                          wichPage = "详情页";
                        } else {
                          wichPage = "普通页";
                        }
                      });
                    },
                    initialUrl: widget.data,
                    //JS执行模式 是否允许JS执行
                    javascriptMode: JavascriptMode.unrestricted,
                    navigationDelegate: (NavigationRequest request) {
                      if (request.url.startsWith("gotologinpage://")) {
                        _logOut();
                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith("appcall://")) {
                        print("即将拨打语音通话 ${request.url.substring(10)}");
                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith("telcall://")) {
                        print("即将拨打普通通话 ${request.url.substring(10)}");
                        _doSysCallOut(context, request.url.substring(10));
                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith("refreshcontacts://")) {
                        Log.d("刷新联系人");
                        _refreshContacts();
                        return NavigationDecision.prevent;
                      } else if (request.url
                          .startsWith("refreshcustomname://")) {
                        String name = request.url.substring(20);
                        name = Uri.decodeComponent(name);
                        _refreshCustomName(context, name);
                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith("hidekeyboard://")) {
                        //全部小写
                        _hideKeyboard(context);
                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith("querynetwork://")) {
                        String state = request.url.substring(15);
                        _controller
                            .evaluateJavascript('network($ishavenet,$state)');
                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith("refreshtitle://")) {
                        String newtitle = request.url.substring(15);
                        newtitle = Uri.decodeComponent(newtitle);
                        setState(() {
                          title = newtitle;
                        });
                        return NavigationDecision.prevent;
                      } else if (Platform.isAndroid &&
                          request.url.contains("weihua/organization")) {
                        _controller.loadUrl(request.url, headers: {
                          "Referer": lastUrl,
                        });
                        lastUrl = request.url;
                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith("selectcontact://")) {
                        //打开联系人界面
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => HomeContactListPage(
                            onSelectcontact: true,
                          ),
                        ))
                            .then((value) {
                          Log.d("selectcontact==$value");
                          _controller.evaluateJavascript(
                              "receiveAppChooseData($value)");
                        });
                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith("h5contact://")) {
                        Log.d("h5contact ==${request.url}");
                        //H5返回给flutter数据
                        String h5contact = request.url.substring(12);
                        // h5contact = Uri.decodeComponent(h5contact);
                        Log.d("h5contact ==$h5contact");
                        Navigator.pop(context, h5contact);
                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith("downloadfromh5://")) {
                        String h5Url = request.url.substring(17);
                        // h5Url = Uri.decodeComponent(h5Url);
                        Log.d("h5Url==$h5Url");
                        if (h5Url.isEmpty) return NavigationDecision.prevent;

                        httpApi.downloadFile(h5Url);
                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith("jumpworkbench://")) {
                        //关闭H5页面
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => TabNavigator(
                        //     jumpIndex: 2,
                        //   ),
                        // ));
                        Navigator.pop(context);
                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith("showcancle://")) {
                        setState(() {
                          showCancle = !showCancle;
                        });
                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith("setbackurl://")) {
                        String fileURl = request.url.substring(13);
                        if (fileURl.startsWith("http//")) {
                          fileURl = fileURl.replaceAll("http", "http:");
                        }
                        if (fileURl.startsWith("https//")) {
                          fileURl = fileURl.replaceFirst("https", "https:");
                        }

                        // backUrl = "http://39.97.232.211:8090" + fileURl;
                        backUrl = fileURl;
                        Log.d("backUrl==$backUrl");
                        Log.d("url==${request.url}");
                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith("reexamine://")) {
                        String bussinessId = request.url.substring(12);
                        bussinessId = Uri.decodeComponent(bussinessId);
                        Navigator.pushNamed(
                            context, RouteName.certificationPage,
                            arguments: bussinessId);
                        // Navigator.of(context).push(
                        //     MaterialPageRoute(builder: (BuildContext context) {
                        //   return EnterpriseCertificationPage(
                        //     null,
                        //     bussId: '$bussinessId',
                        //   );
                        // }));
                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith("upgradenum://")) {
                        Get.toNamed(RouteName.pNumberUpgrade);
                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith("buynum://")) {
                        Get.toNamed(RouteName.pNumberBuy);
                        return NavigationDecision.prevent;
                      } else if (request.url.startsWith("renew://")) {
                        Get.toNamed(RouteName.pNumberRenew);
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    },
                  )),
                ],
              ))),
    );
  }

  void onBack(BuildContext context) {
    if (backUrl.isEmpty) {
      _controller.canGoBack().then((value) {
        showCancle = false;
        if (value) {
          if (title == "多人接听模式") {
            _controller.loadUrl(widget.data);
            _controller.evaluateJavascript("clearSessionStorage()");
            // _controller.clearCache();
          } else if (title == "来电模式") {
            Navigator.pop(context);
          } else {
            _controller.goBack();
          }
        } else {
          return Navigator.pop(context);
        }
      });
    } else {
      _controller.loadUrl(backUrl);
      backUrl = "";
    }
  }

  ///隐藏H5键盘
  _hideKeyboard(BuildContext context) {
    // FocusScope.of(context).requestFocus(_pwdNode);
    // Future.delayed(Duration(milliseconds: 500), () {
    //   _pwdNode.unfocus();
    // });
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  _logOut() {
    Provider.of<UserModel>(context, listen: false).clearUser();
    Navigator.pushNamed(context, RouteName.login);
  }

  void _doSysCallOut(BuildContext context, String number) async {
    lastNum = number;
    Get.off(TabNavigator(
      jumpIndex: 0,
    ));
    // if (Platform.isIOS) {
    //   _sysCall(number);
    //   return;
    // }
    // if (!await Permission.phone.isGranted) {
    //   CustomPermissionAlertDialog.showAlertDialog(
    //       context,
    //       S.of(context).open_permission_call,
    //       Theme.of(context).brightness == Brightness.light
    //           ? 'icon_call.svg'
    //           : 'icon_call_dark.svg', (value) async {
    //     if (await Permission.phone.request().isGranted) {
    //       _sysCall(number);
    //     }
    //   }, true);
    // } else {
    //   _sysCall(number);
    // }
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

  _refreshContacts() {
    Provider.of<HomeBusinessContactModel>(context, listen: false)
        .queryBusinessContactVersion();
  }

  _refreshCustomName(BuildContext context, String name) {
    Provider.of<HomeBusinessContactModel>(context, listen: false)
        .updateEnterprise(name);
  }
}
