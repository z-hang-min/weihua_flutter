import 'dart:async';

import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/blacklist_model.dart';
import 'package:weihua_flutter/ui/widget/custom_alert_dialog.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weihua_flutter/utils/string_utils.dart';

///
/// @Desc: 我的个人号设置  黑名单
///
/// @Author: zhhli
///
/// @Date: 21/7/21
///
const String kKeyBlacklistState = 'kKeyBlacklistState';
late BlacklistMode temModel;
late String thisnumber;
late String addblacknum = '';
late String addblackremark = '';
List blacklist = [];
List tempblacklist = [];
late int page = 1;

class MyPersonNumberblacklistPage extends StatefulWidget {
  final String number;
  MyPersonNumberblacklistPage(this.number);
  @override
  _MyPersonNumberblacklistPageState createState() =>
      _MyPersonNumberblacklistPageState();
}

class _MyPersonNumberblacklistPageState
    extends State<MyPersonNumberblacklistPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    page = page + 1;
    Map tempblackmap =
        await temModel.queryblacklist(widget.number, page.toString());
    tempblacklist = tempblackmap["items"];
    if (tempblacklist.length > 0) {
      blacklist = blacklist + tempblacklist;
    } else {
      _refreshController.loadNoData();
    }
    _refreshController.refreshCompleted();

    // if failed,use refreshFailed()
    // _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    page = page + 1;
    Map tempblackmap =
        await temModel.queryblacklist(widget.number, page.toString());
    tempblacklist = tempblackmap["items"];
    if (tempblacklist.length > 0) {
      blacklist = blacklist + tempblacklist;
    } else {
      _refreshController.loadNoData();
    }
    _refreshController.refreshCompleted();

    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length + 1).toString());
    // if (mounted) setState(() {});
    // _refreshController.loadComplete();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
    blacklist.clear();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text("黑名单"),
          leading: new IconButton(
              icon: SvgPicture.asset(ImageHelper.wrapAssets(
                  Theme.of(context).brightness == Brightness.light
                      ? "nav_icon_return.svg"
                      : "nav_icon_return_sel.svg")),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ProviderWidget(
            model: new BlacklistMode(),
            onModelReady: (BlacklistMode model) async {
              temModel = model;
              await model.queryblacklist(widget.number, "1");
              page = 1;
              blacklist = model.blacklistMap["items"];
              thisnumber = widget.number;
              // bool disturbset = await model.updatenodisturbstate(95013001, 0);
              // if (keydisturb == false) {
              //   // model.showErrorMessage(context);
              //   // EasyLoading.dismiss();
              // }
            },
            builder: (context, BlacklistMode model, child) {
              if (model.isBusy) {
                EasyLoading.show();
              }
              if (model.isIdle) {
                EasyLoading.dismiss();
              }
              return Column(children: [
                SizedBox(height: 12.h),
                Container(
                  height: 70.h,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        title: Text(
                          '黑名单设置',
                          style: subtitle1.change(context, color: Colour.f18),
                        ),
                        trailing: CupertinoSwitch(
                            value: model.blacklistMap["status"] == 0
                                ? false
                                : true,
                            activeColor: Colour.f0F8FFB,
                            onChanged: (value) {
                              setState(() async {
                                bool blackstate =
                                    await temModel.updateblackliststate(
                                        widget.number, value ? 1 : 0);
                                if (blackstate) {
                                  await model.queryblacklist(
                                      widget.number, "1");
                                  page = 1;
                                }
                              });
                            }),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "开启后，黑名单中的号码给您${StringUtils.get95WithSpace(widget.number)}的来电，将被拦截。",
                  style: subtitle2.change(context,
                      fontSize: 12, color: Colour.hintTextColor),
                ),
                SizedBox(height: 10.h),
                blacklist.length == 0
                    ? Container(
                        width: 350.w,
                        height: 380.h,
                        child: Column(children: [
                          SvgPicture.asset(
                            ImageHelper.wrapAssets(context.isBrightness
                                ? "noblacklist_pic.svg"
                                : "noblacklist_dark_pic.svg"),
                            fit: BoxFit.cover,
                          ),
                          Text('暂无黑名单',
                              style: TextStyle(
                                  fontSize: 16, color: Colour.hintTextColor))
                        ]))
                    : Container(
                        padding: EdgeInsets.only(bottom: 7.h),
                        height: 500.h,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colour.FF1A1A1A,
                        child: SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: WaterDropHeader(),
                            footer: CustomFooter(
                              builder:
                                  (BuildContext context, LoadStatus? mode) {
                                Widget body;
                                if (mode == LoadStatus.idle) {
                                  body = Text("加载中...");
                                } else if (mode == LoadStatus.loading) {
                                  body = CircularProgressIndicator();
                                } else if (mode == LoadStatus.failed) {
                                  body = Text("加载失败！点击重试！");
                                } else if (mode == LoadStatus.canLoading) {
                                  body = Text("加载更多");
                                } else {
                                  body = Text("暂无更多数据");
                                }
                                return Container(
                                  height: 55.0,
                                  child: Center(child: body),
                                );
                              },
                            ),
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            onLoading: _onLoading,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: blacklist.length,
                                itemBuilder: (context, index) {
                                  return _cellForRow(context, index);
                                })),
                      ),
                SizedBox(height: 20.h),
                SizedBox(width: 15.w),
                GestureDetector(
                  onTap: () {
                    show();
                  },
                  child: Container(
                    width: 345.w,
                    height: 45.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colour.primaryColor,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 143.w,
                        ),
                        Container(
                          // width: 345.w,
                          // height: 45.w,
                          child: SvgPicture.asset(
                            ImageHelper.wrapAssets("blacklist_add.svg"),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Container(
                          child: Text(
                            "添加",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]);
            }));
  }

  Widget _cellForRow(BuildContext context, int index) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    return Container(
        height: 68.h,
        child: Column(children: [
          Row(children: [
            SizedBox(width: 15.w),
            Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blacklist[index]["number"],
                      style: subtitle1.change(context,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colour.f18
                                  : Colour.fffffff.withAlpha(87)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      blacklist[index]["remark"],
                      style: subtitle2.change(context,
                          fontSize: 12,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colour.hintTextColor
                                  : Colour.fffffff.withAlpha(38)),
                    ),
                  ],
                ),
                width: 300.w),
            SizedBox(width: 20.w),
            InkWell(
              child: SvgPicture.asset(
                ImageHelper.wrapAssets(
                    Theme.of(context).brightness == Brightness.light
                        ? "blacknumber_delete.svg"
                        : "blacknumber_delete_dark.svg"),
              ),
              onTap: () {
                CustomAlertDialog.showAlertDialog(
                    context,
                    "删除",
                    "确认删除黑名单？",
                    S.of(context).actionCancel,
                    S.of(context).actionConfirm,
                    180, (value) async {
                  if (value == 1) {
                    bool deletestate = await temModel.deleteblacklist(
                        widget.number,
                        blacklist[index]["number"],
                        blacklist[index]["remark"]);
                    if (deletestate) {
                      Map tempblackmap =
                          await temModel.queryblacklist(widget.number, "1");
                      page = 1;
                      setState(() {
                        blacklist = tempblackmap["items"];
                      });
                    }
                    // Navigator.pushReplacementNamed(context, RouteName.login);
                    // logoff(model, model2);
                  }
                }, true);
              },
            )
          ]),
          Divider(
            color: Theme.of(context).brightness == Brightness.light
                ? Colour.cFFEEEEEE
                : Colour.fffffff.withAlpha(10),
            height: 1,
            indent: 15.w,
            endIndent: 1.w,
          )
        ]));
  }

  show() {
    //Future类型,then或者await获取
    showDialog(
        context: context,
        builder: (context) {
          return Log();
        }).then((value) {
      print("$value");
    });
  }
}

class Log extends Dialog {
  // timer(context) {
  // var time = Timer.periodic(Duration(milliseconds: 1500), (t) {
  //   print('执行');
  //   Navigator.pop(context);
  //   t.cancel();
  // });
  // }

  @override
  Widget build(BuildContext context) {
    // timer(context);

    //自定义弹框内容
    return Material(
        type: MaterialType.transparency,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 210.h),
            child: Stack(children: <Widget>[
              Positioned(
                child: Container(
                  width: 320.w,
                  height: 300.h,
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : Colour.f2C2C2C,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(90.w, 16.h, 0, 26.h),
                          child: Row(
                            children: [
                              Text("添加至黑名单",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colour.f333333
                                          : Colour.fffffff)),
                              SizedBox(width: 68.w),
                              InkWell(
                                child: SvgPicture.asset(
                                  ImageHelper.wrapAssets(
                                      "blacklistnum_delete.svg"),
                                ),
                                onTap: () async {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 45.h,
                                width: 280.w,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colour.FF565656,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(22.5)), //边角为5
                                ),
                                child: TextField(
                                  // controller: _decController,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colour.fffffff.withAlpha(87),
                                    fontSize: 14.0,
                                  ),
                                  cursorColor: context.isBrightness
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                                  decoration: InputDecoration(
                                    hintText: '请输入号码',
                                    hintStyle: TextStyle().change(context,
                                        color:
                                            Color.fromRGBO(153, 153, 153, 1.0),
                                        fontSize: 16),
                                    enabledBorder: OutlineInputBorder(
                                      /*边角*/
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(22.5),
                                      ),
                                      borderSide: BorderSide(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Color(0XFFEEEEEE)
                                            : Colour.FF565656, //边线颜色为白色
                                        width: 0.5, //边线宽度为2
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Color(0XFFEEEEEE)
                                            : Colour.FF565656, //边框颜色为白色
                                        width: 0.5, //宽度为5
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(22.5), //边角为30
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(0),
                                  ),
                                  onChanged: (text) {
                                    addblacknum = text;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 45.h,
                                width: 280.w,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colour.FF565656,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(22.5)), //边角为5
                                ),
                                child: TextField(
                                  // controller: _decController,
                                  textAlign: TextAlign.center,
                                  // maxLength: 20,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colour.fffffff.withAlpha(87),
                                    fontSize: 14.0,
                                  ),
                                  cursorColor: context.isBrightness
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                                  decoration: InputDecoration(
                                    hintText: '请输入备注',
                                    hintStyle: TextStyle().change(context,
                                        color:
                                            Color.fromRGBO(153, 153, 153, 1.0),
                                        fontSize: 16),
                                    enabledBorder: OutlineInputBorder(
                                      /*边角*/
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(22.5), //边角为5
                                      ),
                                      borderSide: BorderSide(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Color(0XFFEEEEEE)
                                            : Colour.FF565656, //边线颜色为白色
                                        width: 0.5, //边线宽度为2
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Color(0XFFEEEEEE)
                                            : Colour.FF565656, //边框颜色为白色
                                        width: 0.5, //宽度为5
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(22.5), //边角为30
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(0),
                                  ),
                                  onChanged: (text) {
                                    if (text.isNotEmpty && text.length > 20) {
                                      showToast("超出字数限制");
                                    } else {
                                      addblackremark = text;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16.h),
                        child: GestureDetector(
                          onTap: () async {
                            // _submit();
                            if (addblacknum == '') {
                              showToast('请输入号码');
                            } else {
                              bool addstate = await temModel.addblacklist(
                                  thisnumber, addblacknum, addblackremark);
                              if (addstate) {
                                Map tempblackmap = await temModel
                                    .queryblacklist(thisnumber, '1');
                                page = 1;
                                blacklist = tempblackmap["items"];
                                addblacknum = '';
                                addblackremark = '';
                                Navigator.pop(context);
                              } else {
                                temModel.showErrorMessage(context);
                                EasyLoading.dismiss();
                              }
                            }
                          },
                          child: Container(
                            width: 260.w,
                            height: 45.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0XFF2B95E9),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(22.5)),
                              // gradient: LinearGradient(colors: [
                              //   Color(0xFFFF7F16),
                              //   Color(0xFFEF3500)
                              // ])
                            ),
                            child: Text(
                              '确认',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ])));
  }
}
