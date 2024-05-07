import 'dart:async';

import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/event/network_change_event.dart';
import 'package:weihua_flutter/model/get_banner_result.dart';
import 'package:weihua_flutter/model/user.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/event_bus.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/home_enterprise_address_model.dart';
import 'package:weihua_flutter/ui/page/setting/query_info_mode.dart';
import 'package:weihua_flutter/ui/widget/network_watch.dart';
import 'package:weihua_flutter/ui/widget/widget_banner.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/network_utils.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'view_model/workbench_model.dart';
import 'package:weihua_flutter/utils/string_utils.dart';

const String kAnswerModeApp = 'kAnswerModeApp';
int worckbenchtab = 0;

///
/// @Desc: 首页通话记录列表
/// @Author: zhhli
/// @Date: 2021-03-18
///
// WorkbenchModel? _workbenchModel;

class WorkbenchWorkPage extends StatefulWidget {
  @override
  _WorkbenchWorkPageState createState() => _WorkbenchWorkPageState();
}

class _WorkbenchWorkPageState extends State<WorkbenchWorkPage> {
  // List workbenchList = [];

  GlobalKey<ScaffoldState> _globalKeyState = GlobalKey();

  User get workUser => accRepo.user!;

  WorkbenchModel _workbenchModel = WorkbenchModel();
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    // image.add(
    //     'http://39.97.232.211:8090/ipcboss/resources/images/weihua/workbench_icon_call@2x.png');
    // image.add(
    //     "http://39.97.232.211:8090/ipcboss/resources/images/weihua/workbench_icon_effective.png");
    // image.add(
    //     "http://39.97.232.211:8090/ipcboss/resources/images/weihua/workbench_icon_manage.png");
    // image.add(
    //     "http://39.97.232.211:8090/ipcboss/resources/images/weihua/workbench_icon_effective.png");
    NetWorkUtils.initConnectivity();

    _subscription = eventBus.on<NetworkChangeEvent>().listen((event) async {
      ishavenet = event.hasNet;
      if (!ishavenet) {
        _workbenchModel.updateNet(ishavenet);
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    NetWorkUtils.cancle();
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
        model: _workbenchModel,
        onModelReady: (WorkbenchModel model) async {
          model.getBanner();
          model.getAllNumberInfo(context.isBrightness);
        },
        builder: (context, WorkbenchModel model, child) {
          if (model.isError) {
            model.showErrorMessage(context);
          }

          if (model.isBusy) {
            EasyLoading.show();
          }
          if (model.isIdle) {
            EasyLoading.dismiss();
          }

          return Scaffold(
              key: _globalKeyState,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                bottom: PreferredSize(
                    preferredSize: Size.fromHeight(0.h),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10.w),
                          height: 44.h,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Opacity(
                                opacity: model.enterpriseList.length > 0 &&
                                        model.tab == 0
                                    ? 1
                                    : 0,
                                child: IconButton(
                                  icon: SvgPicture.asset(ImageHelper.wrapAssets(
                                      context.isBrightness
                                          ? "nav_icon_switch.svg"
                                          : "nav_icon_switch_dark.svg")),
                                  onPressed: () {
                                    if (model.tab == 0) {
                                      _globalKeyState.currentState!
                                          .openDrawer();
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 5.w),
                              (model.enterpriseList.length != 0 &&
                                      model.personalList.length != 0)
                                  ? Row(
                                      children: [
                                        InkWell(
                                            onTap: () async {
                                              model.changeWorkbenchTab(0);
                                              model.queryWorkBench(workUser,
                                                  context.isBrightness);
                                            },
                                            child: _buildEnterprise(model, 2)),
                                        InkWell(
                                            onTap: () {
                                              model.changeWorkbenchTab(1);
                                            },
                                            child: _buildPerson(model, 2))
                                      ],
                                    )
                                  : (model.enterpriseList.length == 0 &&
                                          model.personalList.length != 0)
                                      ? _buildPerson(model, 1)
                                      : (model.enterpriseList.length != 0 &&
                                              model.personalList.length == 0)
                                          ? _buildEnterprise(model, 1)
                                          : Text(""),
                              // SizedBox(width: 30.w),
                              // _buildSearch(),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: NetWorkWatch(),
                        )
                      ],
                    )),
              ),
              drawer: (model.enterpriseList.length == 0 || model.tab == 1)
                  ? null
                  : Drawer(child: MyDrawerWidget()),
              body: model.hasNet
                  ? _getEnterpriseWorkbenchInfoWidget(context, model)
                  : _getNoResultPicWifget(context));
        });
  }

  Widget _buildEnterprise(WorkbenchModel model, int tabcount) {
    return Container(
      height: double.infinity,
      alignment: Alignment.center,
      padding: tabcount == 2
          ? EdgeInsets.symmetric(horizontal: 30.w)
          : EdgeInsets.only(left: 93.w),
      child: Column(mainAxisAlignment: MainAxisAlignment.start,
        children: [
      Text(
        '联络中心',
        style: TextStyle(
          fontSize: model.tab == 0 ? 18 : 16,
          fontWeight: FontWeight.normal,
          color: (Theme.of(context).brightness == Brightness.light
              ? model.tab == 0
                  ? Colour.cFF212121
                  : Colour.hintTextColor
              : model.tab == 0
                  ? Colour.fffffff
                  : Colour.f99ffffff),
        ),
      ),
      
      Container(width:model.tab == 0 ?25.w:0.w ,height: 10.w, child: Divider(
              height: 10.w,
              indent: 2.w,
              endIndent: 2.w,
              thickness: 2.0,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colour.primaryColor
                  : Colour.primaryColor),)
      ],)
    );
  }

  Widget _buildPerson(WorkbenchModel model, int tabcount) {
    return Container(
        height: double.infinity,
        alignment: Alignment.center,
        padding: tabcount == 2
            ? EdgeInsets.symmetric(horizontal: 30.w)
            : EdgeInsets.only(left: 150.w),
        child: Column(children: [
        Text(
          '个人号',
          style: TextStyle(
            fontSize: (model.tab == 1 || tabcount == 1) ? 18 : 16,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).brightness == Brightness.light
                ? (model.tab == 1 || tabcount == 1)
                    ? Colour.cFF212121
                    : Colour.hintTextColor
                : (model.tab == 1 || tabcount == 1)
                    ? Colour.fffffff
                    : Colour.f99ffffff,
          ),
        ),
        Container(width:model.tab == 1 ?25.w:0.w ,height: 10.w, child: Divider(
              height: 10.w,
              indent: 2.w,
              endIndent: 2.w,
              thickness: 2.0,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colour.primaryColor
                  : Colour.primaryColor),)])
        );
  }

  Widget _getEnterpriseWorkbenchInfoWidget(
      BuildContext context, WorkbenchModel model) {
    return model.uiGroupList.isEmpty
        ? Container(
            alignment: Alignment.center,
            child: Text(
              '暂无数据',
              style: TextStyle().change(context,
                  color: Theme.of(context).primaryColor, fontSize: 12),
            ),
          )
        : Column(
            children: [
              // Container(
              //   margin: EdgeInsets.only(left: 10.w, top: 10.h, right: 10.w),
              //   // padding: EdgeInsets.all(10),
              //   child: CustomSwiperBanner(
              //       images: model.tab == 0
              //           ? model.comBannerList
              //           : model.perBannerList,
              //       onTapCallback: (info) {
              //         if (info.url.contains('mobile=1%')) {
              //           Get.toNamed(RouteName.webH5,
              //               arguments: info.url
              //                   .replaceAll('1%', '${accRepo.user!.mobile}'));
              //         } else {
              //           Get.toNamed(RouteName.webH5, arguments: info.url);
              //         }
              //         // if (index == 0) {
              //         //   Get.toNamed(RouteName.webH5,
              //         //       arguments:
              //         //           'http://192.168.106.72:8022/sales/banner/contact?id=${_workbenchModel!.getBusinessId()}');
              //         // } else {
              //         //   Get.toNamed(RouteName.webH5,
              //         //       arguments:
              //         //           'http://192.168.106.72:8022/sales/banner/person');
              //         // }
              //       }),
              // ),
              _getBannerWidget(context,
                  model.tab == 0 ? model.comBannerList : model.perBannerList),
              Expanded(
                  child: ListView.builder(
                      itemCount:
                          model.uiGroupList.length, //告诉ListView总共有多少个cell
                      itemBuilder: _cellForRow //使用_cellForRow回调返回每个cell
                      ))
            ],
          );
  }

  Widget _getBannerWidget(BuildContext context, List<BannerInfo> bannerInfos) {
    final size = MediaQuery.of(context).size;
    final width = size.width - 30;
    return Container(
        height: 94.h,
        padding:
            EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 0.h),
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => Container(
            width: 10.w,
          ),
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, i) {
            return InkWell(
              onTap: () {
                BannerInfo info = bannerInfos[i];
                if (info.url.contains('mobile=1%')) {
                  Get.toNamed(RouteName.webH5,
                      arguments:
                          info.url.replaceAll('1%', '${accRepo.user!.mobile}'));
                } else {
                  Get.toNamed(RouteName.webH5, arguments: info.url);
                }
              },
              child: Container(
                child: Image.network(
                  '${bannerInfos[i].pic}',
                  fit: BoxFit.contain,
                  width: width / 2,
                ),
              ),
            );
          },
        ));
  }

  Widget _getNoResultPicWifget(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 30.h),
        child: Column(
          children: [
            Center(
              child: SvgPicture.asset(
                ImageHelper.wrapAssets(
                    Theme.of(context).brightness == Brightness.light
                        ? "pic_nonetwork.svg"
                        : "pic_nonet_dark.svg"),
                fit: BoxFit.cover,
                width: 320.w,
                height: 320.h,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              '网络不给力',
              style: Theme.of(context).brightness == Brightness.light
                  ? TextStyle(color: Colour.titleColor, fontSize: 16)
                  : TextStyle(color: Color.fromRGBO(255, 255, 255, 0.87)),
            ),
            SizedBox(height: 6.h),
            Text(
              '点击刷新试一下',
              style: Theme.of(context).brightness == Brightness.light
                  ? TextStyle(color: Colour.hintTextColor, fontSize: 16)
                  : TextStyle(color: Color.fromRGBO(255, 255, 255, 0.87)),
            ),
            SizedBox(height: 40.h),
            TextButton(
                child: Text('刷新',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                onPressed: () async {
                  Log.w('ishavenet=====$ishavenet');
                  // var ishavenet = await isConnected();
                  if (ishavenet) {
                    Log.w('ishavenet==$ishavenet');
                    if (ishavenet) {
                      // QueryWorkBenchResult? workbenchResults;
                      _workbenchModel.queryWorkBench(
                          workUser, context.isBrightness);
                      // workbenchList = workbenchResults?.workbenchList ?? [];
                      _workbenchModel.updateNet(ishavenet);
                    }
                  }
                },
                style: ButtonStyle(
                  //设置按钮的大小
                  minimumSize: MaterialStateProperty.all(Size(140.w, 45.h)),
                  //背景颜色
                  //背景颜色
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    //设置按下时的背景颜色
                    if (states.contains(MaterialState.pressed)) {
                      // return Colour.fEE4452.withAlpha(10);
                    }
                    //默认不使用背景颜色
                    return Colour.primaryColor;
                  }),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                )),
          ],
        ));
  }

  Widget _cellForRow(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colour.f1A1A1A,
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
      ),
      margin: EdgeInsets.all(ScreenUtil().setHeight(10)),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15),
                  ScreenUtil().setHeight(12), ScreenUtil().setWidth(15), 0),
              child: Row(
                children: [
                  Container(
                    // width: ScreenUtil().setWidth(200),
                    child: Text(
                        _workbenchModel.uiGroupList[index].title == '企业账户信息'
                            ? StringUtils.get95WithSpace(accRepo.user!.outerNumber!)
                            : _workbenchModel.uiGroupList[index].title,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).brightness == Brightness.light
                            ? TextStyle().change(context,
                                color: Colour.hintTextColor, fontSize: 14)
                            : TextStyle(color: Colour.f99ffffff)),
                  ),
                  Spacer(),
                  Container(
                    // width: ScreenUtil().setWidth(100),
                    child: Text(
                        _workbenchModel.uiGroupList[index].title == '企业账户信息'
                            ? accRepo.user!.customName!
                            : '',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).brightness == Brightness.light
                            ? TextStyle().change(context,
                                color: Colour.hintTextColor, fontSize: 14)
                            : TextStyle(color: Colour.f99ffffff)),
                  )
                ],
              )),
          SizedBox(height: ScreenUtil().setHeight(4)),
          Divider(
              // height: 1.0,
              indent: 15.w,
              endIndent: 15.w,
              thickness: 1.0,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colour.cFFEEEEEE
                  : Colour.f0x1AFFFFFF),
          SizedBox(height: ScreenUtil().setHeight(19)),
          Container(
              padding: EdgeInsets.fromLTRB(10.w, 0, 15.w, 0),
              child: GridView.builder(
                shrinkWrap: true,
                // 处理listview嵌套报错
                physics: NeverScrollableScrollPhysics(),
                // 处理GridView中滑动父级Listview无法滑动
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 0,
                  crossAxisCount: 4,
                  childAspectRatio: 325.w / 400.h,
                ),
                itemCount: _workbenchModel.uiGroupList[index].list.length,
                itemBuilder: (context, indexs) {
                  return Container(
                    alignment: Alignment.center,
                    child: InkWell(
                      child: Column(
                        children: [
                          Container(
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setWidth(40),
                              child: _workbenchModel.uiGroupList[index]
                                          .list[indexs].picture ==
                                      ""
                                  ? SvgPicture.asset(ImageHelper.wrapAssets(
                                      _workbenchModel.uiGroupList[index]
                                                  .list[indexs].title ==
                                              "我的号码"
                                          ? "icon_workbench_mynum.svg"
                                          : "icon_workbench_tongzhi.svg"))
                                  : Image.network(_workbenchModel
                                      .uiGroupList[index]
                                      .list[indexs]
                                      .picture)),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          Text(
                              _workbenchModel
                                  .uiGroupList[index].list[indexs].title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? TextStyle().change(context,
                                      color: Color.fromRGBO(33, 33, 33, 1.0),
                                      fontSize: 14)
                                  : TextStyle(
                                      color:
                                          Color.fromRGBO(255, 255, 255, 0.87))),
                        ],
                      ),
                      onTap: () async {
                        if (_workbenchModel
                                .uiGroupList[index].list[indexs].title ==
                            "我的号码") {
                          Navigator.pushNamed(context, RouteName.pNumberList ,arguments: accRepo.user!.mobile);
                        } else if (_workbenchModel
                                .uiGroupList[index].list[indexs].title ==
                            "企业信息") {
                          Navigator.pushNamed(
                            context,
                            RouteName.enterprisePage,
                          );
                        } else if (_workbenchModel
                                .uiGroupList[index].list[indexs].title ==
                            "续费") {
                          if (!accRepo.user!.number!.startsWith('95013 3')) {
                            showToast('当前号码不能续费，请联系客服');
                            return;
                          }
                          Map<String, dynamic> routeParams = {'businessid': _workbenchModel.getBusinessId(),"number":''};
                          Navigator.pushNamed(context, RouteName.pNumberRenew,
                              arguments: routeParams);

                          // Navigator.pushNamed(context, RouteName.buyExNumPage);
                        } else if (_workbenchModel
                                .uiGroupList[index].list[indexs].title ==
                            "云通知") {
                          Navigator.pushNamed(context, RouteName.noticePage);
                        } else if (_workbenchModel
                                .uiGroupList[index].list[indexs].title ==
                            "分机") {
                          Navigator.pushNamed(
                              context, RouteName.extensionmanagementPage);
                        } else {
                          Navigator.of(context).pushNamed(RouteName.webH5,
                              arguments: _workbenchModel
                                  .uiGroupList[index].list[indexs].url);
                        }

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => WebviewPage(
                        //         data: workbenchList[index]['list'][indexs]['url']),
                        //   ),
                        // );
                      },
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}

class MyDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WorkbenchModel _workbenchModel =
        Provider.of<WorkbenchModel>(context, listen: false);

    return ProviderWidget(
        model: QueryInfoMode(Provider.of<UserModel>(context),
            homeBusinessContactModel:
                Provider.of<HomeBusinessContactModel>(context, listen: false)),
        onModelReady: (QueryInfoMode model) async {
          model.checkLogin();
        },
        builder: (context, QueryInfoMode model, child) {
          //  if (model.isBusy) {
          //   EasyLoading.show();
          // }
          // if (model.isIdle) {
          //   EasyLoading.dismiss();
          // }
          return Container(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colour.FF191919,
              child: Column(children: [
                Container(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colour.FF191919,
                    padding: EdgeInsets.fromLTRB(0, 40.h, 0, 43.h),
                    child: Text("切换企业",
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colour.fffffff,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left)),
                Container(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colour.FF191919,
                    height: 622.h,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _workbenchModel.enterpriseList.length,
                        itemBuilder: (context, index) {
                          return _enterpriseCellForRow(context, index);
                        }))
              ]));
        });
  }

  Widget _enterpriseCellForRow(BuildContext context, int index) {
    WorkbenchModel _workbenchModel =
        Provider.of<WorkbenchModel>(context, listen: false);

    String busnissname = "";
    busnissname = _workbenchModel.enterpriseList[index].customName ?? "";

    StateSetter _setter;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      _setter = setState;
      return InkWell(
          child: Ink(
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              color: Theme.of(context).cardColor,
            ),
            child: InkWell(
              child: Container(
                height: 78.h,
                width: 375.w / 3 * 2,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(ImageHelper.wrapAssets(
                        _workbenchModel.isCurrentEnterpriseNumber(index)
                            ? 'icon_enterprise_select.svg'
                            : 'enterpriseicon__unselect.svg')),
                    SizedBox(width: 4.w),
                    Row(children: [
                      Container(
                        width: 160.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              busnissname,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: context.isBrightness
                                      ? (_workbenchModel
                                              .isCurrentEnterpriseNumber(index))
                                          ? Colour.FF0F88FF
                                          : Colour.f333333
                                      : (_workbenchModel
                                              .isCurrentEnterpriseNumber(index))
                                          ? Colour.FF0F88FF
                                          : Colour.fffffff),
                              // style: subtitle1.change(context, color: Colour.f18),
                            ),
                            SizedBox(
                              height: 7.h,
                            ),
                            Text(
                              _workbenchModel.enterpriseList[index].inner == ''
                                  ? '(号码:${StringUtils.get95WithSpace(_workbenchModel.enterpriseList[index].number)})'
                                  : "总机号:${StringUtils.get95WithSpace(_workbenchModel.enterpriseList[index].number)}\n分机号:${_workbenchModel.enterpriseList[index].inner}",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: context.isBrightness
                                      ? _workbenchModel
                                              .isCurrentEnterpriseNumber(index)
                                          ? Colour.FF0F88FF
                                          : Colour.hintTextColor
                                      : _workbenchModel
                                              .isCurrentEnterpriseNumber(index)
                                          ? Colour.FF0F88FF
                                          : Colour.FF999999),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      InkWell(
                        child: Container(
                            padding: EdgeInsets.only(right: 10.w),
                            child:
                                _workbenchModel.isCurrentEnterpriseNumber(index)
                                    ? SvgPicture.asset(ImageHelper.wrapAssets(
                                        "enterprise_icon_select.svg"))
                                    : Text("")),
                        // contentPadding: EdgeInsets.all(267.w),
                      ),
                    ])
                  ],
                ),
              ),
            ),
          ),
          onTap: () async {
            List<User> unifyLoginList =
                Provider.of<UserModel>(context, listen: false)
                    .unifyLoginResult
                    .numberList;
            for (int i = 0; i < unifyLoginList.length; i++) {
              if (unifyLoginList[i].outerNumber ==
                      _workbenchModel.enterpriseList[index].number &&
                  unifyLoginList[i].innerNumber ==
                      _workbenchModel.enterpriseList[index].inner) {
                Provider.of<UserModel>(context, listen: false)
                    .saveUser(unifyLoginList[i]);

                await _workbenchModel.queryWorkBench(
                    accRepo.user!, context.isBrightness);
                accRepo.clearAddressBookVersion();
                Provider.of<HomeBusinessContactModel>(context, listen: false)
                    .queryBusinessContactVersion();
              }
            }
            isLogin = true;
            _setter(() {});
            // Provider.of<VoIPModel>(context, listen: false).initSipAccount();
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     RouteName.tab, (Route<dynamic> route) => false);
          });
    });
  }
}
