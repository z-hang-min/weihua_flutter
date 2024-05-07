import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/mynum_calloutnum_model.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:weihua_flutter/utils/string_utils.dart';

late String calloutnumChoose = "";
late bool ischoose = false;

class MyPersonNumbercalloutNumPage extends StatefulWidget {
  final Map calloutNumMap;
  MyPersonNumbercalloutNumPage(this.calloutNumMap);

  @override
  _MyPersonNumbercalloutNumPageState createState() =>
      _MyPersonNumbercalloutNumPageState();
}

class _MyPersonNumbercalloutNumPageState
    extends State<MyPersonNumbercalloutNumPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    calloutnumChoose = '';
    ischoose = false;
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          "默认外呼号码",
        ),
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
          // padding: EdgeInsets.only(top: 10.h),
          child: ProviderWidget(
              model: new MyCalloutnumMode(),
              onModelReady: (MyCalloutnumMode model) async {},
              builder: (context, MyCalloutnumMode model, child) {
                return Column(
                  children: [
                    Container(
                        height: 40.h,
                        padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 0),
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colour.FFFFF9ED
                            : Colour.FF1A1A1A,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              ImageHelper.wrapAssets(
                                  "icon_calloutnum_tishi.svg"),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              "拨打95013+被叫号码，被叫来电为您的95013号码",
                              style: TextStyle(
                                color: Colour.FFFE9F00,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            )
                          ],
                        )),
                    Container(
                        height: 660.h,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                widget.calloutNumMap["calloutNumList"].length ==
                                        0
                                    ? 0
                                    : widget.calloutNumMap["calloutNumList"]
                                                .length ==
                                            1
                                        ? 1
                                        : widget.calloutNumMap["calloutNumList"]
                                                .length +
                                            1,
                            itemBuilder: (
                              context,
                              index,
                            ) {
                              return _cellForRow(
                                  context,
                                  index,
                                  model,
                                  widget
                                      .calloutNumMap["calloutNumList"].length);
                            }))
                  ],
                );
              })),
    );
  }

  Widget _cellForRow(
      BuildContext context, int index, MyCalloutnumMode model, int itemcount) {
    // StateSetter _setter;
    return Container(
        padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 5.h),
        height: 78.h,
        width: 375.w,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colour.f1A1A1A,
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
          child: itemcount == 0
              ? null
              : itemcount == 1
                  ? new ListTile(
                      title: new Text(
                          StringUtils.get95WithSpace((widget.calloutNumMap["calloutNumList"])[index]
                              ["salesOrder"]["number"])),
                      trailing: SvgPicture.asset(
                          ImageHelper.wrapAssets("phone_radio_selected.svg")),
                      // contentPadding: EdgeInsets.all(267.w),
                      onTap: () {
                        // setState(() {
                        //   if (calloutnumChoose !=
                        //       widget.calloutNumList[index]["salesOrder"]
                        //           ["number"]) {
                        //     calloutnumChoose = widget.calloutNumList[index]
                        //         ["salesOrder"]["number"];
                        //   } else {
                        //     calloutnumChoose = "";
                        //   }
                        // });
                      },
                    )
                  : index == widget.calloutNumMap["calloutNumList"].length
                      ? Container(
                          padding: EdgeInsets.all(10.h),
                           color:Colour.backgroundColor,
                          child: TextButton(
                            onPressed: () async {
                              bool calloutnumset =
                                  await model.updatecalloutnumstate(
                                      Provider.of<UserModel>(context,
                                              listen: false)
                                          .user!
                                          .mobile
                                          .toString(),
                                      calloutnumChoose);
                              if (calloutnumset) {
                                showToast("设置成功");
                                // Map calloutNumberMap = await model.getcalloutnum(
                                //     Provider.of<UserModel>(context, listen: false)
                                //         .user!
                                //         .mobile!
                                //         .toString());
                                Navigator.pop(context, true);
                              } else {
                                showToast("设置外呼号码失败");
                              }
                              if (model.isBusy) {
                                EasyLoading.show();
                              }
                              if (model.isIdle) {
                                EasyLoading.dismiss();
                              }
                            },
                            child: Text(
                              "确认",
                              // style: subtitle1.change(context, color: Colour.fEE4452),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
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
                      :
                      // StatefulBuilder(
                      // builder: (BuildContext context) {
                      // _setter = setState;
                      // print('YM------子控件刷新');
                      new ListTile(
                          title: new Text(
                              StringUtils.get95WithSpace((widget.calloutNumMap["calloutNumList"])[index]
                                  ["salesOrder"]["number"])),
                          trailing: SvgPicture.asset(
                            widget.calloutNumMap["calloutNum"]
                                            .replaceAll(' ', '') ==
                                        widget.calloutNumMap["calloutNumList"]
                                                [index]["salesOrder"]["number"]
                                            .replaceAll(' ', '') &&
                                    !ischoose
                                ? ImageHelper.wrapAssets(
                                    "phone_radio_selected.svg")
                                : calloutnumChoose ==
                                        widget.calloutNumMap["calloutNumList"]
                                                [index]["salesOrder"]["number"]
                                            .replaceAll(' ', '')
                                    ? ImageHelper.wrapAssets(
                                        "phone_radio_selected.svg")
                                    : context.isBrightness
                                        ? ImageHelper.wrapAssets(
                                            "phone_radio_unselected.svg")
                                        : ImageHelper.wrapAssets(
                                            "phone_radio_unselected_dark.svg"),
                          ),
                          // contentPadding: EdgeInsets.all(267.w),
                          onTap: () {
                            // _setter(() {});
                            setState(() {
                              ischoose = true;
                              if (calloutnumChoose !=
                                  widget.calloutNumMap["calloutNumList"][index]
                                          ["salesOrder"]["number"]
                                      .replaceAll(' ', '')) {
                                calloutnumChoose = widget
                                    .calloutNumMap["calloutNumList"][index]
                                        ["salesOrder"]["number"]
                                    .replaceAll(' ', '');
                              } else {
                                calloutnumChoose = "";
                              }
                            });
                          },
                        ),
        ));
  }
}
