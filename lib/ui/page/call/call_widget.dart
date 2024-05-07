import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/config/storage_manager.dart';
import 'package:weihua_flutter/event/refresh_callpadnum_event.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/event_bus.dart';
import 'package:weihua_flutter/ui/page/call/view_model/home_call_list_model.dart';
import 'package:weihua_flutter/ui/page/setting/ring_vibrator_page.dart';
import 'package:weihua_flutter/utils/audio_players_manager.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
// import 'package:vibration/vibration.dart';

///
/// @Desc: call 相关 widget
/// @Author: zhhli
/// @Date: 2021-03-29
///
String lastNum = '';

class CallWidget {}

class DialPadItem {
  String title;
  String desc;

  DialPadItem(this.title, this.desc);

  static List<DialPadItem> list() {
    return [
      DialPadItem("1", ""),
      DialPadItem("2", "ABC"),
      DialPadItem("3", "DEF"),
      DialPadItem("4", "GHI"),
      DialPadItem("5", "JKL"),
      DialPadItem("6", "MNO"),
      DialPadItem("7", "PQRS"),
      DialPadItem("8", "TUV"),
      DialPadItem("9", "WXYZ"),
      DialPadItem("*", ""),
      DialPadItem("0", "+"),
      DialPadItem("#", ""),
    ];
  }
}

class DialPadWidget extends StatefulWidget {
  final void Function(String) onPressedCallPhone;
  final void Function(String) onPressedCallVoIP;

  DialPadWidget({
    Key? key,
    required this.onPressedCallPhone,
    required this.onPressedCallVoIP,
  }) : super(key: key);

  @override
  _DialPadWidgetState createState() => _DialPadWidgetState();
}

class _DialPadWidgetState extends State<DialPadWidget> {
  TextEditingController _controller = TextEditingController();
  var list = DialPadItem.list();
  var number = "";
  var checkNUm = "";

  @override
  void initState() {
    super.initState();
    _controller.text = lastNum;
    number = lastNum;
    eventBus.on<CallPadNumRefreshEvent>().listen((event) async {
      setState(() {
        _controller.text = event.num;
        number = event.num;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      decoration: context.isBrightness
          ? BoxDecoration(
              color: Colour.backgroundColor2,
              boxShadow: [
                //卡片阴影
                BoxShadow(
                    color: Colour.f99E4E4E4,
                    // offset: Offset(1.0, 1.0),
                    blurRadius: 4.0)
              ],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)))
          : BoxDecoration(
              gradient: LinearGradient(
                  //渐变位置
                  begin: Alignment.topCenter, //右上
                  end: Alignment.bottomCenter, //左下
                  stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                  //渐变颜色[始点颜色, 结束颜色]
                  colors: [Colour.f2C2C2C, Colour.f1E1E1E]),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              boxShadow: [
                  //卡片阴影
                  BoxShadow(
                      color: Colour.f99E4E4E4,
                      // offset: Offset(2.0, 2.0),
                      blurRadius: 4.0)
                ]),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          InkWell(
            onTap: () {
              Provider.of<HomeCallListModel>(context, listen: false)
                  .updateShowPad(false);
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 5),
              child: SvgPicture.asset(
                ImageHelper.wrapAssets("call_pad_pull_down.svg"),
              ),
            ),
          ),
          Visibility(
            visible: _controller.text.isNotEmpty,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: context.isBrightness
                      ? Colour.widgetBackColor
                      : Colour.c1AFFFFFF,
                  borderRadius: BorderRadius.circular(4.0)),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: AutoSizeText(
                      _controller.text,
                      style: TextStyle(
                        color: context.isBrightness
                            ? Colour.f333333
                            : Colour.f21ffffff,
                        fontSize: 35,
                        height: 1.0,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Positioned(
                    right: 15.w,
                    top: 5,
                    bottom: 5,
                    child: GestureDetector(
                        onLongPress: () {
                          if (number.isEmpty) {
                            return;
                          }
                          clearCallNum(context);
                        },
                        onTap: () {
                          number = number.substring(0, number.length - 1);
                          _controller.text =
                              StringUtils.formatMobile344(number);
                          lastNum = number;
                          Provider.of<HomeCallListModel>(context, listen: false)
                              .searchRecord(number);
                          if (number.isEmpty) {
                            Provider.of<HomeCallListModel>(context,
                                    listen: false)
                                .clearSearch();
                          }
                        },
                        child: SvgPicture.asset(
                          ImageHelper.wrapAssets("call_pad_delete.svg"),
                        )),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 17.h),
          Container(
              alignment: Alignment.center,
              child: Container(
                height: 23.h,
                width: double.infinity,
                margin: EdgeInsets.only(left: 55.w, right: 55.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  color: Colour.f0F8FFB.withAlpha(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '当前外呼显示号码：',
                      style: TextStyle(
                          color: Colour.FF999999, fontSize: 12, height: 1),
                    ),
                    Consumer<HomeCallListModel>(
                        builder: (context, model, child) => Text(
                              '${model.defaultOuterNum} ',
                              style: TextStyle(
                                  color: context.isBrightness
                                      ? Colour.cFF212121
                                      : Colour.fDEffffff,
                                  fontSize: 12,
                                  height: 1),
                            )),
                  ],
                ),
              )),
          SizedBox(height: 14.h),
          Container(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 12,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //横轴元素个数
                  crossAxisCount: 3,
                  //纵轴间距
                  mainAxisSpacing: 5.0,
                  //横轴间距
                  crossAxisSpacing: 5.0,
                  //子组件宽高长度比例
                  childAspectRatio: 2),
              itemBuilder: (BuildContext context, int index) {
                var item = list[index];

                return Container(
                  width: 5.0,
                  child: InkWell(
                    onTap: () async {
                      if (StorageManager.sharedPreferences!
                              .getBool(kVibratorState) ??
                          false) {
                        // bool has =
                        //     await Vibration.hasAmplitudeControl() ?? false;
                        // if (has) {
                        //   Vibration.vibrate(duration: 1000, amplitude: 255);
                        // } else {
                        //   Vibration.vibrate(duration: 100);
                        // }
                      }
                      if (StorageManager.sharedPreferences!
                              .getBool(kKeyToneState) ??
                          false) {
                        // if (item.title == '*') {
                        //   AudioPlayersManager.playerAudioMedia("dtmf-s.aif");
                        // } else if (item.title == '#') {
                        //   AudioPlayersManager.playerAudioMedia("dtmf-j.aif");
                        // } else {
                        //   AudioPlayersManager.playerAudioMedia(
                        //       "dtmf-" + item.title + ".aif");
                        // }
                      }
                      number += item.title;
                      _controller.text = StringUtils.formatMobile344(number);
                      lastNum = number;
                      Provider.of<HomeCallListModel>(context, listen: false)
                          .searchRecord(number);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(item.title,
                            style: theme.textTheme.subtitle1!.change(context,
                                color: Colour.f18, fontSize: 30)),
                        Text(
                          item.desc,
                          style: TextStyle(
                              color: Colour.hintTextColor, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _callChooseNumBtn(context),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget _callChooseNumBtn(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      child: Consumer<HomeCallListModel>(
          builder: (context, model, child) => Container(
                // height: 80.h,
                child: Stack(
                  children: [
                    Positioned(
                        left: 30.w,
                        top: 18.h,
                        child: InkWell(
                          onTap: () async {
                            await showBottomCheckNumDialog(
                                model, context, theme);
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                ImageHelper.wrapAssets(
                                    "icon_change_callpad.svg"),
                                fit: BoxFit.none,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                '切换外呼号码',
                                style: TextStyle(
                                    fontSize: 10, color: Colour.FF999999),
                              )
                            ],
                          ),
                        )),
                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          if (number.isNotEmpty) {
                            if (number.length == 4 || number.length == 3) {
                              //如果使用分机对应的总机号码拨打，则直接调用系统键盘进行呼叫
                              // 如果使用个人号码或者其他总机号码拨打时，toast提示“请使用95013xxx拨打”（分机对应的总机号码），不调用系统键盘
                              // if (model.defaultOuterNum !=
                              //     accRepo.user!.outerNumber) {
                              //   showToast('请使用${accRepo.user!.outerNumber}拨打');
                              //   return;
                              // } else {
                              if (model.showEmployee) {
                                number = model.exContact!.mobile;
                                model.updateShowEmployee(false);
                              }

                              // }
                            }
                            if (model.defaultOuterNum.isEmpty) {
                              showToast("当前外呼号码为空，请设置后重试");
                              return;
                            }
                            widget.onPressedCallPhone(number);
                            clearCallNum(context);
                          } else {
                            showToast('当前无号码，无法呼叫');
                          }
                        },
                        child: SvgPicture.asset(
                          ImageHelper.wrapAssets("icon_call_callpad.svg"),
                          fit: BoxFit.none,
                          // width: 74.w,
                          // height: 74.h,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40.w,
                      top: 17.h,
                      child: InkWell(
                        onTap: () async {
                          Provider.of<HomeCallListModel>(context, listen: false)
                              .updateShowPad(false);
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              ImageHelper.wrapAssets("icon_closed_callpad.svg"),
                              fit: BoxFit.none,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              '隐藏',
                              style: TextStyle(
                                  fontSize: 10, color: Colour.FF999999),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
    );
  }

  Future<void> showBottomCheckNumDialog(
      HomeCallListModel model, BuildContext context, ThemeData theme) async {
    checkNUm = model.defaultOuterNum;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context1, setBottomSheetDialogState) {
              return Container(
                  height: model.getUserList().isNotEmpty
                      ? model.getUserList().length * 58 + 182
                      : 182,
                  padding: EdgeInsets.only(
                      left: 20.w, right: 20.w, top: 17.h, bottom: 6.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          child: Text(
                            '取消',
                            style: theme.textTheme.subtitle2!
                                .change(context, fontSize: 16),
                          ),
                          onTap: () {
                            Get.back();
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          '选择外呼号码',
                          style: theme.textTheme.headline6,
                        ),
                      ),
                      Positioned(
                          top: 68.h,
                          left: 0,
                          right: 0,
                          bottom: 58.h,
                          child: ListView.builder(
                            itemBuilder: (context1, i) {
                              String num = model.getUserList()[i].innerNumber ==
                                      "1000"
                                  ? '${model.getUserList()[i].outerNumber2!}'
                                  : '${model.getUserList()[i].number!}';
                              return model.getUserList()[i].numberType == 101
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Visibility(
                                            visible: i == 0,
                                            child: Container(
                                              child: Text(
                                                '个人号',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: context.isBrightness
                                                        ? Colour.f333333
                                                        : Colour.fDEffffff),
                                              ),
                                              padding:
                                                  EdgeInsets.only(bottom: 15.h),
                                            )),
                                        InkWell(
                                          onTap: () {
                                            setBottomSheetDialogState(() {
                                              checkNUm =
                                                  '${model.getUserList()[i].number!}';
                                            });
                                            model.updateSetDefaultOuterNum(
                                                model.getUserList()[i].number!);
                                          },
                                          child: Container(
                                            height: 50.h,
                                            margin:
                                                EdgeInsets.only(bottom: 10.h),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w),
                                            decoration: BoxDecoration(
                                                color: _getColor(
                                                    context,
                                                    checkNUm ==
                                                        model
                                                            .getUserList()[i]
                                                            .number),
                                                border: Border.all(
                                                    color: checkNUm ==
                                                            model
                                                                .getUserList()[
                                                                    i]
                                                                .number
                                                        ? Colour.f0F8FFB
                                                        : (context.isBrightness
                                                            ? Colour.FFF9F9F9
                                                            : Colors
                                                                .transparent),
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${model.getUserList()[i].number}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: context
                                                              .isBrightness
                                                          ? Colour.f333333
                                                          : Colour.fDEffffff),
                                                ),
                                                SvgPicture.asset(
                                                  checkNUm ==
                                                          model
                                                              .getUserList()[i]
                                                              .number
                                                      ? ImageHelper.wrapAssets(
                                                          "phone_radio_selected.svg")
                                                      : context.isBrightness
                                                          ? ImageHelper.wrapAssets(
                                                              "phone_radio_unselected.svg")
                                                          : ImageHelper.wrapAssets(
                                                              "phone_radio_unselected_dark.svg"),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Visibility(
                                            visible:
                                                model.getUserList().length -
                                                        model
                                                            .getComUserList()
                                                            .length ==
                                                    i,
                                            child: Container(
                                              child: Text(
                                                '联络中心号码',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: context.isBrightness
                                                        ? Colour.f333333
                                                        : Colour.fDEffffff),
                                              ),
                                              padding:
                                                  EdgeInsets.only(bottom: 15.h),
                                            )),
                                        InkWell(
                                          onTap: () {
                                            setBottomSheetDialogState(() {
                                              checkNUm = num;
                                            });
                                            model.updateSetDefaultOuterNum(num);
                                          },
                                          child: Container(
                                            height: 50.h,
                                            margin:
                                                EdgeInsets.only(bottom: 10.h),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w),
                                            decoration: BoxDecoration(
                                                color: _getColor(
                                                    context, checkNUm == num),
                                                border: Border.all(
                                                    color: checkNUm == num
                                                        ? Colour.f0F8FFB
                                                        : (context.isBrightness
                                                            ? Colour.FFF9F9F9
                                                            : Colors
                                                                .transparent),
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '$num',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: context
                                                              .isBrightness
                                                          ? Colour.f333333
                                                          : Colour.fDEffffff),
                                                ),
                                                SvgPicture.asset(
                                                  checkNUm == num
                                                      ? ImageHelper.wrapAssets(
                                                          "phone_radio_selected.svg")
                                                      : context.isBrightness
                                                          ? ImageHelper.wrapAssets(
                                                              "phone_radio_unselected.svg")
                                                          : ImageHelper.wrapAssets(
                                                              "phone_radio_unselected_dark.svg"),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                            },
                            itemCount: model.getUserList().length,
                          )), //
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            alignment: Alignment.center,
                            height: 45.h,
                            width: 158.w,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  minimumSize: Size(158.w, 45.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(23.0),
                                  ),
                                  side: BorderSide(
                                      width: 1, color: Colour.f0F8FFB),
                                  backgroundColor: context.isBrightness
                                      ? Colour.fffffff
                                      : theme.cardColor),
                              onPressed: () {
                                Get.toNamed(RouteName.pNumberBuy);
                              },
                              child: Text(
                                '使用新号码',
                                style: TextStyle(
                                    fontSize: 16, color: Colour.f0F8FFB),
                              ),
                            ),
                          )),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                            height: 45.h,
                            width: 158.w,
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              borderRadius: BorderRadius.circular(23),
                              color: Colour.f0F8FFB,
                              disabledColor: Colour.f0F8FFB.withAlpha(100),
                              onPressed: () async {
                                await model
                                    .updateCalloutNumState(checkNUm)
                                    .then((value) {
                                  if (value) {
                                    Get.back();
                                  } else {
                                    showToast("设置外呼号码失败");
                                  }
                                });
                              },
                              child: Container(
                                child: Text(
                                  '确认',
                                  style: theme.textTheme.subtitle1!
                                      .change(context, color: Colour.fffffff),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ));
            },
          );
        });
  }

  void clearCallNum(BuildContext context) {
    number = "";
    Provider.of<HomeCallListModel>(context, listen: false).clearSearch();
    lastNum = "";
    _controller.clear();
  }

  Color _getColor(BuildContext context, bool isCheced) {
    if (isCheced) {
      if (context.isBrightness)
        return Colour.backgroundColor2;
      else
        return Colour.f0x1AFFFFFF;
    } else {
      if (context.isBrightness)
        return Colour.FFF9F9F9;
      else
        return Colour.f0x1AFFFFFF;
    }
  }
}

///通话界面数字键盘

class CallingDialPadWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _CallingDialPadWidget();
}

class _CallingDialPadWidget extends State<CallingDialPadWidget> {
  TextEditingController _controller = TextEditingController();
  var number = "";

  var _dialItemList = DialPadItem.list();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Container(
          alignment: Alignment.center,
          child: AutoSizeText(
            _controller.text,
            style: TextStyle(
              color: Colour.backgroundColor2,
              fontSize: 30,
            ),
            maxLines: 1,
          ),
        ),
        SizedBox(height: 84.h),
        Container(
          height: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 35),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 12,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //横轴元素个数
                crossAxisCount: 3,
                //纵轴间距
                mainAxisSpacing: 10,
                //横轴间距
                crossAxisSpacing: 5,
                //子组件宽高长度比例
                childAspectRatio: 362 / 262),
            itemBuilder: (BuildContext context, int index) {
              var item = _dialItemList[index];
              return new Material(
                color: Colors.transparent,
                child: InkResponse(
                  highlightShape: BoxShape.circle,
                  radius: 28.0,
                  onTap: () {
                    setState(() {
                      if (mounted) {
                        number += item.title;
                        _controller.text = number;
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          new Border.all(color: Color(0x33ffffff), width: 2),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(item.title,
                        style: TextStyle().change(context,
                            color: Colour.backgroundColor2, fontSize: 30)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
