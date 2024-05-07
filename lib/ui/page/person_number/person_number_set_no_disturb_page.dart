import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/nodisturb_model.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// const String kKeyDisTurbState = 'kKeyDisTurbState';
late String temStartTime = "00:00";
late String temStopTime = "24:00";
List weekChoose = [];
late String weeksvalue = "";
// late Map disturbresult = {};
NodisturbMode? nodisturbModel;

class MyPersonNumbernodisturbPage extends StatefulWidget {
  String number;
  MyPersonNumbernodisturbPage(this.number);
  @override
  _MyPersonNumbernodisturbPageState createState() =>
      _MyPersonNumbernodisturbPageState();
}

class _MyPersonNumbernodisturbPageState
    extends State<MyPersonNumbernodisturbPage> {
  // var keydisturb =
  //     StorageManager.sharedPreferences!.getBool(kKeyDisTurbState) ?? false;
  late bool ischoose = false;
  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
  }

  List dateName = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(S.of(context).notrubleset),
          leading: new IconButton(
              icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                  ? "nav_icon_return.svg"
                  : "nav_icon_return_sel.svg")),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 10.h),
          child: ProviderWidget(
              model: new NodisturbMode(),
              onModelReady: (NodisturbMode model) async {
                nodisturbModel = model;
                await model.querynodistrub(widget.number);
                if (nodisturbModel!.disturbResultMap.length > 0) {
                  weekChoose = nodisturbModel!.disturbResultMap["weeks"];
                  // bool statusnow = nodisturbModel!.disturbResultMap["status"] == 0 ? false : true;
                  // StorageManager.sharedPreferences!
                  //     .setBool(kKeyDisTurbState, statusnow);
                  temStartTime = nodisturbModel!.disturbResultMap["start"];
                  temStopTime = nodisturbModel!.disturbResultMap["end"];
                  // bool disturbset = await model.updatenodisturbstate(95013001, 0);
                  // if (keydisturb == false) {
                  // model.showErrorMessage(context);
                  // EasyLoading.dismiss();
                  // }
                  // temStartTime = disturbresult["start"];
                  // temStopTime = disturbresult["end"];
                }
              },
              builder: (context, NodisturbMode model, child) {
                if (model.isBusy) {
                  EasyLoading.show();
                }
                if (model.isIdle) {
                  EasyLoading.dismiss();
                }
                return Column(
                  children: [
                    _nodistrubleWidget(context, model),
                    SizedBox(height: 10.w),
                    _starttime(context),
                    Divider(
                      // color: Color(0xffeeeeee),
                      height: 0,
                      indent: 45.w,
                      endIndent: 15.w,
                    ),
                    _stoptime(context),
                    Divider(
                      // color: Color(0xffeeeeee),
                      height: 0,
                      indent: 45.w,
                      endIndent: 15.w,
                    ),
                    model.disturbResultMap.length > 0
                        ? _repeat(
                            context, model.disturbResultMap["weeksname"], model)
                        : Text(""),
                  ],
                );
              }),
        ));
  }

  Widget _nodistrubleWidget(BuildContext context, NodisturbMode model) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle2 = textTheme.subtitle2!;
    return Ink(
      decoration: new BoxDecoration(
        // borderRadius: BorderRadius.all(Radius.circular(6.0)),
        color: Theme.of(context).cardColor,
      ),
      child: InkWell(
        child: Container(
          height: 78.h,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 15,
              ),
              Row(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).notrubleset,
                      style: TextStyle(
                          fontSize: 16,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colour.f333333
                                  : Colour.fffffff.withAlpha(87)),
                      // style: subtitle1.change(context, color: Colour.f18),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "开启后，在设置时间段内将不会收到来电。",
                      style: subtitle2.change(context,
                          fontSize: 12,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colour.hintTextColor
                                  : Colour.fffffff.withAlpha(38)),
                    ),
                  ],
                ),
                SizedBox(width: 60.w),
                CupertinoSwitch(
                    value: nodisturbModel!.disturbResultMap["status"] == 0
                        ? false
                        : true,
                    activeColor: Colour.f0F8FFB,
                    onChanged: (value) {
                      setState(() async {
                        // nodisturbModel!.disturbResultMap["status"] = value;
                        bool updateresult = await model.updatenodisturbstate(
                            widget.number, value ? 1 : 0);
                        if (updateresult) {
                          await model.querynodistrub(widget.number);
                          // StorageManager.sharedPreferences!
                          //     .setBool(kKeyDisTurbState, keydisturb);
                        }
                      });
                    }),
              ])
            ],
          ),
        ),
      ),
    );
  }

  Widget _starttime(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Ink(
      decoration: new BoxDecoration(
        // borderRadius: BorderRadius.all(Radius.circular(6.0)),
        color: Theme.of(context).cardColor,
      ),
      child: InkWell(
        child: Container(
          height: 58.h,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SvgPicture.asset(ImageHelper.wrapAssets("icon_blacklistset.svg")),
              SizedBox(
                width: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "开始时间",
                    style: subtitle1.change(context,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colour.f18
                            : Colour.fffffff.withAlpha(87)),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(width: 175.w),
                  Container(
                    width: 77.w,
                    child: Text(
                      temStartTime,
                      style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colour.primaryColor
                                  : Colour.FF0F88FF,
                          fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),

              SvgPicture.asset(context.isBrightness
                  ? ImageHelper.wrapAssets("me_icon_more.svg")
                  : ImageHelper.wrapAssets("me_icon_more_dark.svg")),
            ],
          ),
        ),
        onTap: () {
          // DatePicker.showTime12hPicker(context, showTitleActions: true,locale: LocaleType.zh,
          //     onChanged: (date) {
          //   // startTime = date as String;
          //   // print('change $date in time zone ' +
          //   //     date.timeZoneOffset.inHours.toString());
          // }, onConfirm: (date) async {
          //   setState(() {
          //     temStartTime = date.toString().substring(11, 16);
          //   });
          //   if (weekChoose.length > 0) {
          //     for (int i = 0; i < weekChoose.length; i++) {
          //       if (i == 0) {
          //         weeksvalue = weekChoose[i];
          //       } else {
          //         weeksvalue = weeksvalue + "," + weekChoose[i];
          //       }
          //     }
          //   } else {}
          //   bool nodisturbset = await nodisturbModel!.nodisturbset(
          //       widget.number, temStartTime, temStopTime, weeksvalue);
          //   if (nodisturbset) {
          //     nodisturbModel!.querynodistrub(widget.number);
          //     if (nodisturbModel!.isBusy) {
          //       EasyLoading.show();
          //     }
          //     if (nodisturbModel!.isIdle) {
          //       EasyLoading.dismiss();
          //     }
          //   }
          //
          //   // print('confirm $date');
          // }, currentTime: DateTime.now());
        },
      ),
    );
  }

  Widget _stoptime(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Ink(
      decoration: new BoxDecoration(
        // borderRadius: BorderRadius.all(Radius.circular(6.0)),
        color: Theme.of(context).cardColor,
      ),
      child: InkWell(
        child: Container(
          height: 58.h,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "结束时间",
                    style: subtitle1.change(context,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colour.f18
                            : Colour.fffffff.withAlpha(87)),
                  ),
                  SizedBox(width: 175.w),
                  Container(
                      width: 77.w,
                      child: Text(
                        DateTime(int.parse(temStopTime.replaceAll(':', "")))
                                .difference(DateTime(int.parse(
                                    temStartTime.replaceAll(':', ""))))
                                .inSeconds
                                .isNegative
                            ? '次日$temStopTime'
                            : temStopTime,
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colour.primaryColor
                                    : Colour.FF0F88FF,
                            fontSize: 16),
                        textAlign: TextAlign.right,
                      ))
                ],
              ),
              SvgPicture.asset(context.isBrightness
                  ? ImageHelper.wrapAssets("me_icon_more.svg")
                  : ImageHelper.wrapAssets("me_icon_more_dark.svg")),
            ],
          ),
        ),
        onTap: () {
          // DatePicker.showTime12hPicker(context, showTitleActions: true,locale: LocaleType.zh,
          //     onChanged: (date) {
          //   print('change $date in time zone ' +
          //       date.timeZoneOffset.inHours.toString());
          // }, onConfirm: (date) async {
          //   print('confirm $date');
          //   setState(() {
          //     temStopTime = date.toString().substring(11, 16);
          //   });
          //   if (weekChoose.length > 0) {
          //     for (int i = 0; i < weekChoose.length; i++) {
          //       if (i == 0) {
          //         weeksvalue = weekChoose[i];
          //       } else {
          //         weeksvalue = weeksvalue + "," + weekChoose[i];
          //       }
          //     }
          //   } else {}
          //   bool nodisturbset = await nodisturbModel!.nodisturbset(
          //       widget.number, temStartTime, temStopTime, weeksvalue);
          //   if (nodisturbset) {
          //     nodisturbModel!.querynodistrub(widget.number);
          //     if (nodisturbModel!.isBusy) {
          //       EasyLoading.show();
          //     }
          //     if (nodisturbModel!.isIdle) {
          //       EasyLoading.dismiss();
          //     }
          //   }
          // }, currentTime: DateTime.now());
        },
      ),
    );
  }

  Widget _repeat(BuildContext context, String weeks, NodisturbMode model) {
    // StateSetter _nosetter;
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    return Ink(
      decoration: new BoxDecoration(
        // borderRadius: BorderRadius.all(Radius.circular(6.0)),
        color: Theme.of(context).cardColor,
      ),
      child: InkWell(
        child: Container(
          height: 58.h,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "重复",
                    style: subtitle1.change(context,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colour.f18
                            : Colour.fffffff.withAlpha(87)),
                  ),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    // _nosetter = setState;
                    return Container(
                        padding: EdgeInsets.all(2.w),
                        child: Text(
                          weeks,
                          textAlign: TextAlign.right,
                          style: subtitle2.change(context,
                              color: Theme.of(context).brightness == Brightness.light
                            ? Colour.f18
                            : Colour.fffffff.withAlpha(87), fontSize: 16),
                        ),
                        width: 283.w);
                  })
                ],
              ),
              // Spacer(),
              SvgPicture.asset(context.isBrightness
                  ? ImageHelper.wrapAssets("me_icon_more.svg")
                  : ImageHelper.wrapAssets("me_icon_more_dark.svg")),
            ],
          ),
        ),
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Stack(children: <Widget>[
                  Container(
                    height: 20.0,
                    width: double.infinity,
                    color: Colors.black54,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colour.f2C2C2C,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        )),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return _cellForRow(context, index, model);
                      }),
                ]);
              });
        },
      ),
    );
  }

  Widget _cellForRow(BuildContext context, int index, NodisturbMode model) {
    StateSetter _setter;
    return Container(
        child: index == 0
            ? new ListTile(
                leading: InkWell(
                    child: Text("取消",
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colour.cFF212121
                                    : Colour.fffffff.withAlpha(60))),
                    onTap: () =>
                        Navigator.of(context).pushNamed(RouteName.login)),
                title: Container(
                  padding: EdgeInsets.only(left: 118.w),
                  child: Text("重复",
                      style: TextStyle(
                          fontSize: 18,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colour.cFF212121
                                  : Colour.fffffff)),
                ),

                // contentPadding: EdgeInsets.only(left: 267.w),
                onTap: () {},
              )
            : index == 8
                ? Container(
                    padding: EdgeInsets.all(15.h),
                    child: TextButton(
                      onPressed: () async {
                        if (weekChoose.length > 0) {
                          for (int i = 0; i < weekChoose.length; i++) {
                            if (i == 0) {
                              weeksvalue = weekChoose[i];
                            } else {
                              weeksvalue = weeksvalue + "," + weekChoose[i];
                            }
                          }
                        } else {}

                        bool nodisturbset = await model.nodisturbset(
                            widget.number,
                            temStartTime,
                            temStopTime,
                            weeksvalue);
                        if (nodisturbset) {
                          model.querynodistrub(widget.number);
                          if (model.isBusy) {
                            EasyLoading.show();
                          }
                          if (model.isIdle) {
                            EasyLoading.dismiss();
                          }
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        "确认",
                        // style: subtitle1.change(context, color: Colour.fEE4452),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ButtonStyle(
                        //设置按钮的大小
                        minimumSize: MaterialStateProperty.all(
                            Size(double.infinity, 50)),
                        //背景颜色
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          //设置按下时的背景颜色
                          if (states.contains(MaterialState.pressed)) {
                            return !context.isBrightness
                                ? Color.fromRGBO(15, 136, 255, 1.0)
                                : Color.fromRGBO(15, 136, 255, 1.0);
                          }
                          //默认不使用背景颜色
                          return !context.isBrightness
                              ? Color.fromRGBO(15, 136, 255, 1.0)
                              : Color.fromRGBO(15, 136, 255, 1.0);
                        }),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  )
                : StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                    _setter = setState;
                    print('YM------子控件刷新');
                    return new ListTile(
                      title: new Text(dateName[index - 1],
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colour.cFF212121
                                  : Colour.fffffff)),
                      trailing: SvgPicture.asset(
                        getweekchoose(index.toString())
                            ? ImageHelper.wrapAssets("phone_radio_selected.svg")
                            : context.isBrightness
                                ? ImageHelper.wrapAssets(
                                    "phone_radio_unselected.svg")
                                : ImageHelper.wrapAssets(
                                    "phone_radio_unselected_dark.svg"),
                      ),
                      // contentPadding: EdgeInsets.all(267.w),
                      onTap: () {
                        _setter(() {});
                        // setState(() {
                        if (!getweekchoose(index.toString())) {
                          weekChoose.add(index.toString());
                        } else {
                          weekChoose.remove(index.toString());
                        }
                        // });
                      },
                    );
                  }));
  }

  static bool getweekchoose(String name) {
    bool isweekchoose = false;
    weekChoose.remove("");
    for (var i = 0; i < weekChoose.length; i++) {
      if (weekChoose[i] == name) {
        isweekchoose = true;
      }
    }
    return isweekchoose;
  }
}
