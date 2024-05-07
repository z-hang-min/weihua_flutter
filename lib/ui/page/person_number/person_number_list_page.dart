import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/mynum_calloutnum_model.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/myowner_number_model.dart';
import 'package:weihua_flutter/ui/page/tab/tab_navigator.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:weihua_flutter/utils/string_utils.dart';

/// @Desc: 我的个人号列表
///
/// @Author: zhhli
///
/// @Date: 21/7/21
///
MyOwnernumberMode? mynumberModel;
MyCalloutnumMode? calloutnumModel;

class MyPersonNumberListPage extends StatefulWidget {
  final String bindPhone;

  MyPersonNumberListPage(this.bindPhone);
  @override
  _MyPersonNumberListPageState createState() => _MyPersonNumberListPageState();
}

class _MyPersonNumberListPageState extends State<MyPersonNumberListPage> {
  // late List mynumberList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // if (_conectionSubscription != null) {
    //   _conectionSubscription.cancel();
    // _conectionSubscription = null;
    // EasyLoading.dismiss();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Theme.of(context).cardColor,
          title: Text(S.of(context).mynumber),
          leading: new IconButton(
              icon: SvgPicture.asset(ImageHelper.wrapAssets(
                  Theme.of(context).brightness == Brightness.light
                      ? "nav_icon_return.svg"
                      : "nav_icon_return_sel.svg")),
              color: Colors.white,
              onPressed: () {
                if (isLogin)
                  Navigator.pop(context);
                else {
                  isLogin = true;
                  Get.off(TabNavigator(
                    jumpIndex: 0,
                  ));
                }
              }),
        ),
        body: Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            child:
                ProviderWidgetNoConsumer2<MyOwnernumberMode, MyCalloutnumMode>(
              // 提供页面UI model
              model1: MyOwnernumberMode(),
              model2: MyCalloutnumMode(),
              onModelReady: (model1, model2) async {
                mynumberModel = model1;
                calloutnumModel = model2;
                EasyLoading.show();
                await model1.checkLogin(
                    isLogin ? accRepo.user!.mobile! : widget.bindPhone);
                UserModel userModel =
                    Provider.of<UserModel>(context, listen: false);
                if (!isLogin) {
                  if (accRepo.unifyLoginResult!.companyNumberList.isNotEmpty) {
                    userModel.saveUser(
                        accRepo.unifyLoginResult!.companyNumberList[0]);
                  } else {
                    userModel
                        .saveUser(accRepo.unifyLoginResult!.perNumberList[0]);
                  }
                }
                await model1.querymynumberlist().then((value) async {
                  // mynumberList = value;
                  await model2.getcalloutnum(
                      Provider.of<UserModel>(context, listen: false)
                          .user!
                          .mobile!
                          .toString());
                  if (model2.myCalloutnumMap["number"] == "") {
                    await model2.updatecalloutnumstate(
                        Provider.of<UserModel>(context, listen: false)
                            .user!
                            .mobile
                            .toString(),
                        mynumberModel!.mynumberlistList[0]["salesOrder"]
                            ["number"]);
                  }
                });

                // if (model2.isBusy) {
                //   EasyLoading.show();
                // }
                // if (model2.isIdle) {
                EasyLoading.dismiss();
                // }
              },

              child: Column(
                children: [
                  Container(
                      height: 58,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colour.f1A1A1A,
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      ),
                      child: Consumer<MyCalloutnumMode>(
                          builder: (context, model, child) => Visibility(
                              child: InkWell(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 15.w),
                                      Text("当前外呼号码",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.light
                                                ? Colour.guidColor
                                                : Colour.fffffff.withAlpha(60),
                                          )),
                                      SizedBox(width: 20.w),
                                      Container(
                                          child: Text(
                                            (calloutnumModel!.myCalloutnumMap
                                                            .length ==
                                                        0 ||
                                                    mynumberModel!
                                                            .mynumberlistList
                                                            .length ==
                                                        0)
                                                ? ""
                                                : (calloutnumModel!.myCalloutnumMap["number"] == ""
                                                    ? StringUtils.get95WithSpace(
                                                        mynumberModel!
                                                                    .mynumberlistList[0]
                                                                ["salesOrder"]
                                                            ["number"])
                                                    : StringUtils.get95WithSpace(
                                                        calloutnumModel!
                                                            .myCalloutnumMap["number"])),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colour.c0x0F88FF),
                                            textAlign: TextAlign.right,
                                          ),
                                          width: 150.w),
                                      SizedBox(width: 10.w),
                                      Text(
                                        "修改",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.light
                                                ? Colour.cFF666666
                                                : Colour.fffffff.withAlpha(60)),
                                      ),
                                      InkWell(
                                        child: SvgPicture.asset(
                                            context.isBrightness
                                                ? ImageHelper.wrapAssets(
                                                    "me_icon_more.svg")
                                                : ImageHelper.wrapAssets(
                                                    "me_icon_more_dark.svg")),
                                        onTap: () {
                                          // setState(() {
                                          //   Map myNumberMap = {};
                                          //   myNumberMap["calloutNum"] =
                                          //       calloutNumberMap.length == 0
                                          //           ? mynumberList[0]
                                          //               ["salesOrder"]["number"]
                                          //           : calloutNumberMap["number"];
                                          //   myNumberMap["calloutNumList"] =
                                          //       mynumberList;
                                          //   Navigator.pushNamed(context,
                                          //       RouteName.pNumberCalloutNum,
                                          //       arguments: myNumberMap);
                                          // });
                                        },
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      Map myNumberMap = {};
                                      myNumberMap[
                                          "calloutNum"] = (calloutnumModel!
                                                      .myCalloutnumMap.length ==
                                                  0 ||
                                              mynumberModel!.mynumberlistList
                                                      .length ==
                                                  0)
                                          ? ""
                                          : (calloutnumModel!
                                                          .myCalloutnumMap[
                                                      "number"] ==
                                                  ""
                                              ? mynumberModel!
                                                      .mynumberlistList[0]
                                                  ["salesOrder"]["number"]
                                              : calloutnumModel!
                                                  .myCalloutnumMap["number"]);
                                      myNumberMap["calloutNumList"] =
                                          mynumberModel!.mynumberlistList;
                                      Navigator.pushNamed(context,
                                              RouteName.pNumberCalloutNum,
                                              arguments: myNumberMap)
                                          .then((value) {
                                        getRequestCallOutNum();
                                      });
                                    });
                                  })))),
                  SizedBox(height: 10),
                  Consumer<MyOwnernumberMode>(
                      builder: (context, model, child) => Visibility(
                              // visible: !model.showPad &&
                              //     (_record.isCallOut || model.isConnected),
                              child: Row(
                            children: [
                              SizedBox(width: 15.w),
                              Text("我的号码",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Color(0xFF333333)
                                          : Colour.fffffff)),
                              SizedBox(width: 5.w),
                              Text(
                                  "(共${mynumberModel!.mynumberlistList.length}个)",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colour.cFF666666
                                          : Colour.f99ffffff.withAlpha(60)))
                            ],
                          ))),
                  SizedBox(height: 10),
                  Consumer<MyOwnernumberMode>(
                      builder: (context, model, child) => Visibility(
                          // visible: !model.showPad &&
                          //     (_record.isCallOut || model.isConnected),
                          child: Container(
                              height: 470.h,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      mynumberModel!.mynumberlistList.length,
                                  itemBuilder: (context, index) {
                                    return _cellForRow(context, index);
                                  })))),
                  SizedBox(height: 20),
                  _tobuyWidget(context),
                ],
              ),
            )));
  }

  Widget _cellForRow(BuildContext context, int index) {
    return Container(
      height: 150,
      //设置背景图片
      decoration: new BoxDecoration(
        // color: Colors.grey,
        // border: new Border.all(width: 2.0, color: Colors.red),
        // borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
        image: new DecorationImage(
          image:
              new AssetImage(ImageHelper.wrapAssets('mynumber_info_bac.png')),
          //这里是从assets静态文件中获取的，也可以new NetworkImage(）从网络上获取
          centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
        ),
      ),

      margin: EdgeInsets.all(ScreenUtil().setHeight(10)),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(10), ScreenUtil().setHeight(12), 0, 0),
              child: Container(
                // width: ScreenUtil().setWidth(330),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(height: 16.h),
                        Text(
                            dateAndTimeToString(
                                mynumberModel!.mynumberlistList[index]
                                    ["salesOrder"]["validTime"]),
                            textAlign: TextAlign.left,
                            style:
                                Theme.of(context).brightness == Brightness.light
                                    ? TextStyle().change(context,
                                        color: Colour.CCFFFFFF, fontSize: 14)
                                    : TextStyle(color: Colour.f99ffffff)),
                        SizedBox(width: 125.w),
                        Text(
                            "剩余${mynumberModel!.mynumberlistList[index]["salesOrder"]["validDays"]}天",
                            textAlign: TextAlign.left,
                            style:
                                Theme.of(context).brightness == Brightness.light
                                    ? TextStyle().change(context,
                                        color: Colors.white, fontSize: 14)
                                    : TextStyle(color: Colour.fffffff)),
                      ],
                    ),
                    SizedBox(width: 15.w, height: 10.w),
                    Row(
                      children: [
                        Text(
                            StringUtils.get95WithSpace(
                                (mynumberModel!.mynumberlistList[index]
                                    ["salesOrder"]["number"])),
                            textAlign: TextAlign.left,
                            style: Theme.of(context).brightness ==
                                    Brightness.light
                                ? TextStyle().change(context,
                                    color: Colors.white, fontSize: 22)
                                : TextStyle(color: Colors.white, fontSize: 22))
                      ],
                    ),
                    SizedBox(width: 15.w, height: 18.w),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text("黑名单",
                                textAlign: TextAlign.left,
                                style: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? TextStyle().change(context,
                                        color: Colour.CCFFFFFF, fontSize: 12)
                                    : TextStyle(color: Colour.f99ffffff)),
                            SizedBox(width: 47.w, height: 8.w),
                            Text(
                                mynumberModel!.mynumberlistList[index]
                                            ["blacklistValue"] ==
                                        0
                                    ? "未开启"
                                    : "已开启",
                                textAlign: TextAlign.left,
                                style: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? TextStyle().change(context,
                                        color: Colour.CCFFFFFF, fontSize: 14)
                                    : TextStyle(color: Colour.fffffff)),
                          ],
                        ),
                        SizedBox(width: 10.w),
                        Container(
                            child: VerticalDivider(
                                indent: 0.5.w,
                                endIndent: 2.w,
                                thickness: 2.w,
                                width: 36.w,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Color.fromRGBO(255, 255, 255, 0.5)
                                    : Color.fromRGBO(255, 255, 255, 0.5)),
                            height: 40.w),
                        SizedBox(width: 10.w),
                        Column(
                          children: [
                            Text("勿扰",
                                textAlign: TextAlign.left,
                                style: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? TextStyle().change(context,
                                        color: Colour.CCFFFFFF, fontSize: 12)
                                    : TextStyle(color: Colour.f99ffffff)),
                            SizedBox(width: 47.w, height: 8.w),
                            Text(
                                mynumberModel!.mynumberlistList[index]
                                            ["silenceValue"] ==
                                        0
                                    ? "未开启"
                                    : "已开启",
                                textAlign: TextAlign.left,
                                style: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? TextStyle().change(context,
                                        color: Colour.CCFFFFFF, fontSize: 14)
                                    : TextStyle(color: Colour.fffffff)),
                          ],
                        ),
                        SizedBox(width: 100.w),
                        _settingWidget(
                            context,
                            mynumberModel!.mynumberlistList[index]
                                ["salesOrder"])
                      ],
                    )
                  ],
                ),
              )),
          SizedBox(height: ScreenUtil().setHeight(4)),
        ],
      ),
    );
  }

  Widget _settingWidget(BuildContext context, Map info) {
    return SizedBox(
      width: 70.w,
      height: 30.w,
      // ignore: deprecated_member_use
      child: CupertinoButton(
        //为什么要设置左右padding，因为如果不设置，那么会挤压文字空间
        padding: EdgeInsets.symmetric(horizontal: 8),
        //文字颜色
        // textColor: Colour.primaryColor,
        //按钮颜色
        color: Colors.white,
        //画圆角
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(15),
        // ),
        //如果使用FlatButton，必须初始化onPressed这个方法
        onPressed: () {
          Navigator.pushNamed(context, RouteName.pNumberSetting,
                  arguments: info)
              .then((value) {
            getRequestMyNumber();
          });
        },
        child: Text(
          S.of(context).setting,
          style: TextStyle(fontSize: 14),
        ),
        // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  getRequestMyNumber() async {
    await mynumberModel!.querymynumberlist().then((value) async {
      // mynumberList = value;
      await calloutnumModel!.getcalloutnum(
          Provider.of<UserModel>(context, listen: false)
              .user!
              .mobile!
              .toString());
    });
  }

  getRequestCallOutNum() async {
    await calloutnumModel!.getcalloutnum(
        Provider.of<UserModel>(context, listen: false)
            .user!
            .mobile!
            .toString());
  }

  Widget _tobuyWidget(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colour.FFFF8786,
                Colour.FFFF4F4E,
              ],
            ),
            borderRadius: new BorderRadius.circular((25.0))),
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteName.pNumberBuy).then((value) {
              getRequestMyNumber();
            });
            // Navigator.push(
            //     context,
            //     new MaterialPageRoute(
            //       builder: (context) => new MyPersonpayceshiPage()));
            // builder: (context) => new MyPersonpayceshiPage()));
            // FlutterInappPurchase.instance.initialize();
          },
          child: Text(
            S.of(context).tobuynewnumber,
            // style: subtitle1.change(context, color: Colour.fEE4452),
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          style: ButtonStyle(
            //设置按钮的大小
            minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
            //背景颜色
            // backgroundColor: MaterialStateProperty.resolveWith((states) {
            //   // //设置按下时的背景颜色
            //   // if (states.contains(MaterialState.pressed)) {
            //   //   return !context.isBrightness
            //   //       ? Colour.f1A1A1A.withAlpha(400)
            //   //       : Colour.fffffff.withAlpha(400);
            //   // }
            //   //默认不使用背景颜色
            //   return !context.isBrightness ? Colour.FFFFEDEA : Colour.fffffff;
            // }),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ));
  }

  static String dateAndTimeToString(var timestamp) {
    if (timestamp == null || timestamp == "") {
      return "";
    }
    String targetString = "";
    final date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    // final String tmp = date.toString();
    String year = date.year.toString();
    String month = date.month.toString();
    if (date.month <= 9) {
      month = "0" + month;
    }
    String day = date.day.toString();
    if (date.day <= 9) {
      day = "0" + day;
    }
    String hour = date.hour.toString();
    if (date.hour <= 9) {
      hour = "0" + hour;
    }
    String minute = date.minute.toString();
    if (date.minute <= 9) {
      minute = "0" + minute;
    }
    String second = date.second.toString();
    if (date.second <= 9) {
      second = "0" + second;
    }

    targetString = "$year.$month.$day到期";

    return targetString;
  }
}
