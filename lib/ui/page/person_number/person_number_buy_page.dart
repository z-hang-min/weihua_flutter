import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/ui/page/person_number/person_number_pay_page.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/buy_view_model.dart';
import 'package:weihua_flutter/utils/debouncer.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

///
/// @Desc: 购买新号码
///
/// @Author: zhhli
///
/// @Date: 21/7/21
///
class BuyPersonNumberPage extends StatefulWidget {
  @override
  _BuyPersonNumberPageState createState() => _BuyPersonNumberPageState();
}

class _BuyPersonNumberPageState extends State<BuyPersonNumberPage> {
  XBuyViewModel buyViewModel = Get.put(XBuyViewModel());
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextEditingController _numCtrl = TextEditingController();
    final FocusNode focusNode = FocusNode();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(S.of(context).page_buy_num),
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
              buyViewModel.resetData();
            }),
      ),
      body: GestureDetector(
          onTap: () {
            focusNode.unfocus();
          },
          child: Container(
            color: context.isBrightness ? Colour.c0xFFF7F8FD : Colour.FF111111,
            padding: EdgeInsets.only(top: 10.h, left: 10.h, right: 10.h),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(
                      top: 13.h, left: 15.h, right: 15.h, bottom: 19.h),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return Text(
                          buyViewModel.number.isEmpty ? "选择专属95服务号" : '购买95号码',
                          style:
                              subtitle1.change(context, color: Colour.f333333),
                        );
                      }),
                      SizedBox(
                        height: 13.h,
                      ),
                      Divider(
                        height: 1.h,
                        color: context.isBrightness
                            ? Colour.cFFEEEEEE
                            : Colour.c1AFFFFFF,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "950133",
                            style: TextStyle(
                                fontSize: 24, color: Colour.c0x0F88FF),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              focusNode: focusNode,
                              controller: _numCtrl,
                              textAlign: TextAlign.start,
                              style: subtitle1.change(context,
                                  fontSize: 24, color: Colour.f333333),
                              maxLines: 1,
                              maxLength: 6,
                              minLines: 1,
                              autofocus: true,
                              cursorColor: context.isBrightness
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: new OutlineInputBorder(
                                  //没有焦点时
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: new OutlineInputBorder(
                                  //有焦点时
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.all(0),
                                disabledBorder: new OutlineInputBorder(
                                  //有焦点时
                                  borderSide: BorderSide.none,
                                ),
                                errorBorder: new OutlineInputBorder(
                                  //有焦点时
                                  borderSide: BorderSide.none,
                                ),
                                focusedErrorBorder: new OutlineInputBorder(
                                  //有焦点时
                                  borderSide: BorderSide.none,
                                ),
                                counterText: "",
                                hintText: "请输入喜欢的数字",
                                hintStyle: subtitle1.change(context,
                                    fontSize: 20, color: Colour.c0xCCCCCC),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (text) {
                                Log.d('input==$text');
                                if (text.isEmpty) {
                                  _numCtrl.text = '';
                                  buyViewModel.resetData();
                                }
                                // 防抖
                                _debouncer(() {
                                  if (_numCtrl.text.isNotEmpty)
                                    buyViewModel
                                        .checkNumber("950133" + _numCtrl.text);
                                });
                              },
                            ),
                          ),
                          Obx(() {
                            return Visibility(
                                visible: buyViewModel.number.isNotEmpty,
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Semantics(
                                    label: '清空',
                                    hint: '清空输入框',
                                    child: GestureDetector(
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: SvgPicture.asset(
                                            ImageHelper.wrapAssets(
                                                'login_icon_delete.svg')),
                                      ),
                                      onTap: () {
                                        _numCtrl.text = '';
                                        buyViewModel.checkNumber('');
                                      },
                                    ),
                                  ),
                                ));
                          }),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Obx(() {
                        return Visibility(
                          visible: buyViewModel.tipShow.value,
                          child: Text(
                            "您输入的号码已被占用，请重新输入",
                            style: textTheme.subtitle2!
                                .change(context, color: Colour.c0xF72626),
                          ),
                        );
                      })
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                      left: 15.w, right: 15.w, top: 13.h, bottom: 19.h),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "通讯服务费",
                        style: textTheme.subtitle1!
                            .change(context, color: Colour.f333333),
                      ),
                      SizedBox(
                        height: 13.h,
                      ),
                      Divider(
                        height: 1.h,
                        color: context.isBrightness
                            ? Colour.cFFEEEEEE
                            : Colour.c1AFFFFFF,
                      ),
                      SizedBox(
                        height: 17.h,
                      ),
                      _priceContent(context),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Spacer(),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40.w,
                          height: 0.5.h,
                          color: context.isBrightness
                              ? Colour.c0xCCCCCC
                              : Colour.c1AFFFFFF,
                        ),
                        SizedBox(
                          width: 8.h,
                        ),
                        Text(
                          '温馨提示',
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colour.f333333
                                  : Colour.f61ffffff),
                        ),
                        SizedBox(
                          width: 8.h,
                        ),
                        Container(
                          width: 40.w,
                          height: 0.5.h,
                          color: context.isBrightness
                              ? Colour.c0xCCCCCC
                              : Colour.c1AFFFFFF,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '可联系商务人员咨询 ',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colour.cFF999999
                                  : Colour.f61ffffff,
                              height: 1.1),
                        ),
                        Text(
                          '950138006 ',
                          style: TextStyle(
                              fontSize: 12,
                              // decoration: TextDecoration.underline,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colour.c0xFF0085FF
                                  : Colour.c0xFF0085FF,
                              height: 1.1),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                ),
                Obx(() {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: CupertinoButton(
                      borderRadius: BorderRadius.circular(23),
                      padding: EdgeInsets.all(1),
                      color: Colour.f0F8FFB,
                      disabledColor: Colour.f0F8FFB.withAlpha(100),
                      child: Container(
                        height: 45.h,
                        alignment: Alignment.center,
                        child: Text(
                          S.of(context).btn_buy,
                          style: buyViewModel.btnBuy.value
                              ? TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary)
                              : TextStyle(color: Colour.fffffff),
                        ),
                      ),
                      onPressed: !buyViewModel.btnBuy.value
                          ? null
                          : () {
                              Log.d(_numCtrl.text);
                              Get.to(PayPersonNumberPage(),
                                  arguments: buyViewModel.perNumCheckResult);
                            },
                    ),
                  );
                }),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          )),
    );
  }

  Widget _priceContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '¥',
                    style: TextStyle(
                        height: 1.1, color: Colour.FFFF4F4E, fontSize: 16),
                  ),
                  Obx(() {
                    if (buyViewModel.isError) {
                      buyViewModel.showErrorMessage(context);
                    }
                    if (buyViewModel.isIdle) {
                      EasyLoading.dismiss();
                    }

                    return SizedBox();
                  }),
                  Obx(() => Text(
                        '${buyViewModel.perResult.value.price}',
                        style: new TextStyle(
                            fontSize: 24,
                            textBaseline: TextBaseline.alphabetic,
                            height: 1.1,
                            color: Colour.FFFF4F4E),
                        textAlign: TextAlign.start,
                      )),
                  Text(
                    '/年',
                    style: new TextStyle(
                        height: 1.1, color: Colour.FFFF4F4E, fontSize: 16),
                  ),
                  Obx(() {
                    return Visibility(
                      visible: buyViewModel.perResult.value.seckill == '1',
                      child: Container(
                        margin: EdgeInsets.only(left: 3.w),
                        height: 45.h,
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 16.h,
                          width: 41.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colour.FFFFA917,
                                  Colour.FFFF8D12,
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(100),
                                  bottomLeft: Radius.circular(1),
                                  topRight: Radius.circular(100),
                                  bottomRight: Radius.circular(100))),
                          child: Text(
                            '秒杀价',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              Container(
                width: 100.w,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      '平均',
                      style: TextStyle(
                          height: 1.1, color: Colour.cFF666666, fontSize: 14),
                    ),
                    Obx(() => Text(
                          '¥${buyViewModel.perResult.value.avgPrice}',
                          style: new TextStyle(
                              fontSize: 16,
                              textBaseline: TextBaseline.alphabetic,
                              height: 1.1,
                              color: Colour.FFFF4F4E),
                          textAlign: TextAlign.start,
                        )),
                    Text(
                      '/月',
                      style: new TextStyle(
                          height: 1.1, color: Colour.FFFF4F4E, fontSize: 16),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                return Text(
                  "¥${buyViewModel.perResult.value.sells}/年",
                  style: TextStyle(
                      color: Colour.cFF999999,
                      decoration: TextDecoration.lineThrough,
                      fontSize: 14,
                      decorationThickness: 2,
                      decorationColor: Colour.cFF999999),
                );
              }),
              Container(
                  width: 100.w,
                  alignment: Alignment.centerLeft,
                  child: Obx(() {
                    return Text(
                      "¥${buyViewModel.perResult.value.avgSells}/月",
                      style: TextStyle(
                          color: Colour.cFF999999,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 14,
                          decorationThickness: 2,
                          decorationColor: Colour.cFF999999),
                    );
                  })),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debouncer.cancel();
    super.dispose();
    buyViewModel.resetData();
    if (EasyLoading.isShow) EasyLoading.dismiss();
  }
}
