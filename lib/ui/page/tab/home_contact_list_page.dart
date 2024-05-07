import 'dart:io';

import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/ui/helper/web_js_helper.dart';
import 'package:weihua_flutter/ui/page/contact/contact_info_page.dart';
import 'package:weihua_flutter/ui/page/contact/contact_search_page.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/contact_ui.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/home_enterprise_address_model.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

///
/// @Desc:
///
/// @Author: zhhli
///
/// @Date: 21/4/16

class HomeContactListPage extends StatefulWidget {
  bool onSelectcontact;
  bool multipleChoice;

  HomeContactListPage(
      {Key? key, required this.onSelectcontact, this.multipleChoice = false})
      : super(key: key);

  @override
  _HomeContactListPageState createState() => _HomeContactListPageState();
}

class _HomeContactListPageState extends State<HomeContactListPage> {
  late WebViewController _webController;
  String title = "网页加载中...";
  String nowUrl = "";
  bool showCancle = false;
  String backUrl = "";
  late HomeBusinessContactModel contactModel;
  late PageController _pageController;
  int _index = 0;

  WebHandleHelp help = WebHandleHelp();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _index,
      viewportFraction: 1,
      keepPage: true,
    );
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    help.regist(WebHandleCall());
    help.regist(WebHandleContact());
    help.regist(WebHandleCommon());

    help.regist(WebHandleCallBack(onBackUrl: (backUrl2) {
      backUrl = backUrl2;
    }, onNewTitle: (newTitle) {
      //
    }, onShowCancel: (showCancle2) {
      showCancle = showCancle2;
    }));
  }

  @override
  void dispose() {
    super.dispose();
    contactModel.changeContactTab(0);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, userModel, child) => ProviderWidget<
              HomeBusinessContactModel>(
          model: Provider.of<HomeBusinessContactModel>(context),
          autoDispose: false,
          onModelReady: (model) async {
            contactModel = model;
            model.changeInfoView(false);
            // 先加载数据库数据
            model.loadDataFromDb(reLoadLocalDb: true);
            // 查询企业联系人通讯录版本，获取 企业联系人信息
            model.queryBusinessContactVersion();

            // 重新读系统联系人
            if (await Permission.contacts.isGranted) {
              model.reloadNativeLocalContact();
            } else {
              if (await Permission.contacts.request().isGranted) {
                model.reloadNativeLocalContact();
              }
            }
          },
          builder: (context, model, child) {
            if (model.isBusy) {
              EasyLoading.show();
            }
            if (model.isIdle) {
              EasyLoading.dismiss();
            }

            List<ContactUIInfo> contactList = model.uiList;
            Log.d("刷新联系人列表 ${contactList.length}");
            return Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                flexibleSpace: Container(
                  // height: 83.8.h,
                  decoration: BoxDecoration(
                    // border: Border( bottom: BorderSide(width: 0.0,color: Colors.red)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: model.infoView
                          ? [
                              Color.fromRGBO(71, 117, 253, 1.0),
                              Color.fromRGBO(69, 143, 249, 1.0),
                            ]
                          : context.isBrightness
                              ? [
                                  Colors.white,
                                  Colors.white,
                                ]
                              : [
                                  Colors.black,
                                  Colors.black,
                                ],
                    ),
                  ),
                ),
                leading: Visibility(
                  visible:
                      //  (model.tab == 1 || model.tab == 2)
                      //     ? true
                      //     :
                      model.haveButton
                          ? true
                          : widget.onSelectcontact
                              ? true
                              : false,
                  child: new IconButton(
                      icon: SvgPicture.asset(ImageHelper.wrapAssets(
                          contactModel.infoView
                              ? (context.isBrightness
                                  ? "nav_icon_return_white.svg"
                                  : "nav_icon_return_sel.svg")
                              : Theme.of(context).brightness == Brightness.light
                                  ? "nav_icon_return.svg"
                                  : "nav_icon_return_sel.svg")),
                      onPressed: () {
                        // Navigator.pop(context);

                        onBack(context);
                      }),
                ),
                title: widget.onSelectcontact
                    ? contactModel.infoView
                        ? Text('')
                        : Text('选择联系人')
                    : Text(model.infoView ? '' : S.of(context).tabContact),
                centerTitle: true,
                actions: [
                  _buildSearch(),
                ],
                bottom: PreferredSize(
                    preferredSize: Size.fromHeight(widget.multipleChoice
                        ? 0
                        : contactModel.infoView
                            ? 0.h
                            : 44.h),
                    child: Column(
                      children: [
                        // 顶部导航
                        Visibility(
                          visible: widget.multipleChoice == false,
                          child: Container(
                            decoration: BoxDecoration(
                                // border: Border( top: BorderSide(width: 0.0,color: Colors.black)),
                                ),
                            height: contactModel.infoView ? 0.h : 44.h,
                            alignment: Alignment.center,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [0, 1, 2].map((index) {
                                  var title = "";
                                  if (index == 0) {
                                    title = "本机联系人";
                                  } else if (index == 1) {
                                    title = "企业联系人";
                                  } else {
                                    title = "分机联系人";
                                  }
                                  return InkWell(
                                    onTap: () {
                                      model.changeContactTab(index);
                                      _pageController.animateToPage(index,
                                          duration: Duration(
                                              milliseconds: 16), //跳转的间隔时间
                                          curve: Curves.fastOutSlowIn);
                                      if (index != 0) {
                                        _webController.loadUrl(getUrl(index));
                                      }
                                      nowUrl = getUrl(model.tab);
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: model.tab == index
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: model.tab == index
                                              ? (context.isBrightness
                                                  ? Colour.titleColor
                                                  : Colour.fDEffffff)
                                              : (context.isBrightness
                                                  ? Colour.hintTextColor
                                                  : Colour.f99ffffff),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList()),
                          ),
                        )
                        // Visibility(
                        //   visible: !model.hasNet,
                        //   child: NetWorkWatch(),
                        // )
                      ],
                    )),
              ),
              body: PageView(
                scrollDirection: Axis.horizontal,
                reverse: false,
                controller: _pageController,
                physics: widget.multipleChoice
                    ? NeverScrollableScrollPhysics()
                    : (nowUrl.contains('organization_info') ||
                            nowUrl.contains('user_info'))
                        ? NeverScrollableScrollPhysics()
                        : BouncingScrollPhysics(),
                pageSnapping: true,
                onPageChanged: (index) {
                  model.changeContactTab(index);
                  if (index != 0) {
                    _webController.loadUrl(getUrl(index));
                  }
                },
                children: [
                  Visibility(
                      visible: model.tab == 0,
                      child: Container(
                          padding: EdgeInsets.only(top: 0.h),
                          child: _buildLocalContactWidget(context))),
                  Offstage(
                      offstage: widget.multipleChoice || model.tab == 0,
                      child:
                          Container(child: _buildWebView(context, getUrl(1)))),
                  Offstage(
                      offstage: widget.multipleChoice || model.tab == 0,
                      child:
                          Container(child: _buildWebView(context, getUrl(2)))),
                ],
              ),
            );
          }),
    );
  }

  /// 构建侧边导航样式
  IndexBarOptions _buildIndexBarOptions() {
    return IndexBarOptions(
      needRebuild: true,
      ignoreDragCancel: true,

      // downTextStyle: TextStyle(fontSize: 12, color: Colors.white),
      // downItemDecoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
      indexHintWidth: 80,
      indexHintHeight: 80,
      indexHintDecoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageHelper.wrapAssets('tab_letter_tip.png')),
          fit: BoxFit.none,
        ),
      ),
    );
  }

  /// 构建联系人分组widget
  Container _buildGroupTitleContainer(ContactUIInfo info) => Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
              height: 40,
              alignment: Alignment.centerLeft,
              child: Text(info.name)),
        ),
      );

  /// 构建字母分组条目布局
  static Widget _buildSusItem(
      BuildContext context, List<ContactUIInfo> contactList, int index,
      {double susHeight = 30}) {
    String tag = contactList[index].getSuspensionTag();
    if (tag == ContactUIInfo.headTag || index == 0) {
      return Container();
    }
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 15.0),
      color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
      alignment: Alignment.centerLeft,
      child: Text(
        '$tag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: context.isBrightness ? Color(0xFF333333) : Colors.white,
        ),
      ),
    );
  }

  /// 构建搜索按钮布局
  Widget _buildSearch() {
    return widget.multipleChoice
        ? Container()
        : InkWell(
            child: SvgPicture.asset(
              ImageHelper.wrapAssets(context.isBrightness
                  ? 'nav_icon_search.svg'
                  : 'nav_icon_search_dark.svg'),
              width: 44,
              height: contactModel.infoView ? 0 : 44,
              fit: BoxFit.none,
              // color: theme.brightness == Brightness.dark
              //     ? theme.accentColor
              //     : theme.primaryColor,

              colorBlendMode: BlendMode.srcIn,
            ),
            onTap: () async {
              Navigator.push(
                  context,
                  //跳转到搜索页面
                  new MaterialPageRoute(
                      builder: (context) => new SearchPageWidget(
                            onSelectcontact: widget.onSelectcontact,
                          ))).then((value) {
                if (widget.onSelectcontact && value != null) {
                  Navigator.pop(context, value);
                }
              });

              // Navigator.pushNamed(context, RouteName.dbTestPage);
            },
          );
  }

  /// 构建联系人信息条目
  Widget _buildListItem(
    HomeBusinessContactModel model,
    BuildContext context,
    List<ContactUIInfo> contactList,
    int index, {
    Color? defHeaderBgColor,
  }) {
    ContactUIInfo info = contactList[index];

    if (info.type == ContactType.other &&
        info.otherTitleType == OtherTitleType.title) {
      return _buildGroupTitleContainer(info);
    }
    // if(info.type == 4 || info.type == 5){
    //   _buildBaseListItemcontainer(info);
    // }

    return _itemWidget(model, info, index);
  }

  Container _buildBaseListItemContainer(ContactUIInfo info, int index) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
      ),
      padding: EdgeInsets.all(0),
      child: ListTile(
        leading: SizedBox(
          child: info.img == null
              ? Container(
                  decoration: BoxDecoration(
                      color: Colour.getContactColor(index),
                      borderRadius: BorderRadius.all(Radius.circular(20.w))),
                  // color: Colors.red,
                  width: 40.w,
                  height: 40.w,
                  child: Center(
                    child: Text(
                      info.name
                          .substring(info.name.length - 1, info.name.length),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
              : Image.asset(ImageHelper.wrapAssets(info.img!)),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Text(
            info.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Text(
            info.phone,
            maxLines: 1,
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(15, 0, 35, 0),
        selected: false,

        ///如果选中列表的 item 项，那么文本和图标的颜色将成为主题的主颜色
        onTap: () {
          // showToast("${model.name} ${model.phoneNumber}");
          // if (model.phoneNumber == '组织架构') {
          if (info.type == ContactType.other &&
              OtherTitleType.enterpriseTitle == info.otherTitleType) {
            Log.d(accRepo.getH5UrlOrganizationTeam(context.isBrightness));
            Navigator.of(context)
                .pushNamed(RouteName.webH5,
                    arguments: accRepo.getH5UrlOrganizationTeam(
                        context.isBrightness,
                        chooseType: widget.onSelectcontact ? 1 : 0))
                .then((value) {
              if (widget.onSelectcontact && value != null) {
                Navigator.pop(context, value);
              }
            });
            // } else if (model.phoneNumber == '列表详情') {
          } else if (info.type == ContactType.other &&
              OtherTitleType.exContactTitle == info.otherTitleType) {
            Log.d(accRepo.getH5UrlExtension(context.isBrightness));

            Navigator.of(context)
                .pushNamed(RouteName.webH5,
                    arguments: accRepo.getH5UrlExtension(context.isBrightness,
                        chooseType: widget.onSelectcontact ? 1 : 0))
                .then((value) {
              if (widget.onSelectcontact && value != null) {
                Navigator.pop(context, value);
              }
            });
          } else {
            if (widget.onSelectcontact) {
              Navigator.pop(
                  context, StringUtils.getMap2JsonSting(info.name, info.phone));
            } else {
              info.bgColor = Colour.getContactColor(index);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactInfoPage(info),
                ),
              );
            }
          }
        },
        onLongPress: () {},
      ),
    );
  }

  Widget _itemWidget(
      HomeBusinessContactModel model, ContactUIInfo info, int index) {
    return InkWell(
      onTap: () {
        // showToast("${model.name} ${model.phoneNumber}");
        // if (model.phoneNumber == '组织架构') {
        if (widget.multipleChoice) {
          if (info.type == ContactType.other)
            return;
          else {
            model.addSelected(info);
            return;
          }
        }
        if (info.type == ContactType.other &&
            OtherTitleType.enterpriseTitle == info.otherTitleType) {
          Log.d(accRepo.getH5UrlOrganizationTeam(context.isBrightness));
          Navigator.of(context)
              .pushNamed(RouteName.webH5,
                  arguments: accRepo.getH5UrlOrganizationTeam(
                      context.isBrightness,
                      chooseType: widget.onSelectcontact ? 1 : 0))
              .then((value) {
            if (widget.onSelectcontact && value != null) {
              Navigator.pop(context, value);
            }
          });
          // } else if (model.phoneNumber == '列表详情') {
        } else if (info.type == ContactType.other &&
            OtherTitleType.exContactTitle == info.otherTitleType) {
          Log.d(accRepo.getH5UrlExtension(context.isBrightness));

          Navigator.of(context)
              .pushNamed(RouteName.webH5,
                  arguments: accRepo.getH5UrlExtension(context.isBrightness,
                      chooseType: widget.onSelectcontact ? 1 : 0))
              .then((value) {
            if (widget.onSelectcontact && value != null) {
              Navigator.pop(context, value);
            }
          });
        } else {
          if (widget.onSelectcontact) {
            Navigator.pop(
                context, StringUtils.getMap2JsonSting(info.name, info.phone));
          } else {
            info.bgColor = Colour.getContactColor(index);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactInfoPage(info),
              ),
            );
          }
        }
      },
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
        ),
        padding: EdgeInsets.all(0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 15.w,
            ),
            Visibility(
              visible: widget.multipleChoice &&
                  info.type == ContactType.localContact,
              child: Container(
                margin: EdgeInsets.only(right: 15.w),
                child: InkWell(
                  onTap: () {
                    model.addSelected(info);
                  },
                  child: SvgPicture.asset(
                    model.isChecked(info)
                        ? ImageHelper.wrapAssets("phone_radio_selected.svg")
                        : context.isBrightness
                            ? ImageHelper.wrapAssets(
                                "phone_radio_unselected.svg")
                            : ImageHelper.wrapAssets(
                                "phone_radio_unselected_dark.svg"),
                  ),
                ),
              ),
            ),
            SizedBox(
              child: info.img == null
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colour.getContactColor(index),
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.w))),
                      // color: Colors.red,
                      width: 40.w,
                      height: 40.w,
                      child: Center(
                        child: Text(
                          info.name.substring(
                              info.name.length - 1, info.name.length),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ))
                  : Image.asset(ImageHelper.wrapAssets(info.img!)),
            ),
            SizedBox(
              width: 15.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  info.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  info.phone,
                  maxLines: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onBack(BuildContext context) {
    var model = Provider.of<HomeBusinessContactModel>(context, listen: false);
    if (nowUrl.contains('organization_team')) {
      if (title == '组织架构') {
        Navigator.pop(context);
      } else {
        _webController.evaluateJavascript('backteam()');
      }
    } else if (nowUrl.contains('organization_info')) {
      model.changeInfoView(false);
      _webController.evaluateJavascript('backinfo()');
    } else if (nowUrl.contains('user_info')) {
      _webController.goBack();
      model.changeInfoView(false);
    } else {
      Navigator.pop(context);
    }
    // if (backUrl.isEmpty) {
    //   if (contactModel.tab == 0) {
    //     if (widget.onSelectcontact == true) {
    //       Navigator.pop(context);
    //     }
    //   } else {
    //     // _changeTitle();
    //     _webController.currentUrl().then((value) {
    //       Log.d("current url : {$value}");
    //       Log.d("getUrl(1) : ${getUrl(1)}");
    //       Log.d("getUrl(2) : ${getUrl(2)}");
    //       if (value != getUrl(1) && value != getUrl(2)) {
    //         _webController.goBack();
    //       } else {
    //         if (widget.onSelectcontact == true) {
    //           Navigator.pop(context);
    //         }
    //       }

    //       return value;
    //     });
    //   }
    // } else {
    //   _webController.loadUrl(backUrl);
    //   backUrl = "";
    // }
  }

  Widget _buildLocalContactWidget(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    var model = Provider.of<HomeBusinessContactModel>(context, listen: false);

    List<ContactUIInfo> contactList = model.uiList;

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      child: Stack(
        children: [
          AzListView(
            data: contactList,
            itemCount: contactList.length,
            itemBuilder: (BuildContext context, int index) => _buildListItem(
              model,
              context,
              contactList,
              index,
              defHeaderBgColor: Color(0xFFE5E5E5),
            ),
            physics: BouncingScrollPhysics(),
            // 悬停
            susItemBuilder: (BuildContext context, int index) =>
                _buildSusItem(context, contactList, index),
            indexBarData: [...kIndexBarData],
            indexBarOptions: _buildIndexBarOptions(),
          ),
          Visibility(
              visible: widget.multipleChoice,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      //卡片阴影
                      BoxShadow(
                          color: Colour.f99E4E4E4,
                          // offset: Offset(1.0, 1.0),
                          blurRadius: 4.0)
                    ],
                  ),
                  padding:
                      EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h),
                  height: 65.h,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        '已选择 ',
                        style: subtitle2,
                      ),
                      Text(
                        '${model.selectedMap.length.toString()}',
                        style: subtitle2.change(context, color: Colour.f0F8FFB),
                      ),
                      Text(
                        '/ ${model.uiLocalList.length}个联系人',
                        style: subtitle2,
                      ),
                      Spacer(),
                      TextButton(
                          style: ButtonStyle(
                            //设置按钮的大小
                            minimumSize:
                                MaterialStateProperty.all(Size(70.w, 34.h)),
                            //背景颜色
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              //设置按下时的背景颜色
                              if (states.contains(MaterialState.pressed)) {
                                return Colour.f0F8FFB.withAlpha(100);
                              }
                              //默认不使用背景颜色
                              return Colour.f0F8FFB;
                            }),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Get.back(result: model.selectedMap);
                          },
                          child: Text(
                            '确认',
                            style: subtitle1.change(context,
                                fontSize: 14, color: Colour.backgroundColor2),
                          ))
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildWebView(BuildContext context, String url) {
    return Container(
        alignment: Alignment.center,
        child: WebView(
          onWebViewCreated: (WebViewController webViewController) {
            _webController = webViewController;
          },
          debuggingEnabled: true,
          onWebResourceError: (error) {
            // Log.d(e);
          },
          onPageFinished: (url) async {
            Log.d("onPageFinished :$url");
            title = await _webController.getTitle() ?? '';
            nowUrl = url;
            _changeTitle(title);
            if (nowUrl.contains('organization_info') ||
                nowUrl.contains('user_info')) {
              var model =
                  Provider.of<HomeBusinessContactModel>(context, listen: false);

              model.changeInfoView(true);
            }else if(nowUrl.contains('organization_team') ||
                nowUrl.contains('extension')){
                 var model =
                  Provider.of<HomeBusinessContactModel>(context, listen: false);

              model.changeInfoView(false); 

            }
          },
          onPageStarted: (url) {
            Log.d("onPageStarted :$url");
          },
          initialUrl: url,
          gestureRecognizers: [
            Factory(() => VerticalDragGestureRecognizer()), // 指定WebView只处理垂直手势。
          ].toSet(),
          //JS执行模式 是否允许JS执行
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith("refreshtitle://")) {
              String newtitle = request.url.substring(15);
              newtitle = Uri.decodeComponent(newtitle);
              setState(() {
                title = newtitle;
              });
              _changeTitle(title);
            }
            return help.handle(context, _webController, request);
          },
        ));
  }

  _changeTitle(String title) async {
    var model = Provider.of<HomeBusinessContactModel>(context, listen: false);

    if (title == '组织架构' || title == '分机') {
      model.changeBackButton(false);
    } else {
      model.changeBackButton(true);
    }
    // print(title);
  }

  String getUrl(int tab) {
    if (tab == 1) {
      return accRepo.getH5UrlOrganizationTeam(context.isBrightness,
          chooseType: widget.onSelectcontact ? 1 : 0);
    } else {
      return accRepo.getH5UrlExtension(context.isBrightness,
          chooseType: widget.onSelectcontact ? 1 : 0);
    }
  }
}
