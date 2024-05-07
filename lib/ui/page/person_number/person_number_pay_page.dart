import 'package:weihua_flutter/config/const_config.dart';
import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/apple_pay_model.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/buy_view_model.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/pay_view_model.dart';
import 'package:weihua_flutter/ui/widget/custom_editphone_dialog.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/platform_utils.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:weihua_flutter/utils/apple_productid.dart';

/// @Desc: 支付购买新号码
///
/// @Author: zhhli
///
/// @Date: 21/7/21
///
String orderid = "";

class PayPersonNumberPage extends StatefulWidget {
  @override
  _PayPersonNumberPageState createState() => _PayPersonNumberPageState();
}

class _PayPersonNumberPageState extends State<PayPersonNumberPage> {
  final XPayViewModel xPayViewModel = Get.put(XPayViewModel());
  final XBuyViewModel xBuyViewModel = Get.find();

  // late StreamSubscription _conectionSubscription;
  // late StreamSubscription _purchaseUpdatedSubscription;
  // late StreamSubscription _purchaseErrorSubscription;

  @override
  void initState() {
    super.initState();
    if (isLogin) xPayViewModel.bindPhone.value = accRepo.user!.mobile!;
    initPlatformState();
    // 监听支付结果
    fluwx.weChatResponseEventHandler.listen((event) async {
      xPayViewModel.isCreateOrderIng.value = false;
      Log.d("1==$payType");
      if (payType != ConstConfig.pay_type_buyNum) return;
      payType = -1;
      if (event is fluwx.WeChatPaymentResponse) {
        // 支付成功
        if (event.errCode == 0) {
          Log.d("2");
          xPayViewModel.wxPayResult.value = true;
          // xPayViewModel.checkLogin(
          //     isLogin ? accRepo.user!.mobile! : xPayViewModel.bindPhone.value,
          //     xBuyViewModel.number.value);
          Get.offNamed(RouteName.pNumberPayResult, arguments: true);
        } else {
          Log.d("3");
          xPayViewModel.wxPayResult.value = false;
          Get.toNamed(RouteName.pNumberPayResult, arguments: false);
        }
      }
      // 关闭弹窗
    });
  }

  @override
  void dispose() {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    xPayViewModel.isCreateOrderIng.value = false;
    closeIosConnection();
    fluwx.weChatResponseEventHandler.distinct();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    var color = Colour.f0F8FFB;
    TextStyle textStyle = Theme.of(context).textTheme.caption!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(S.of(context).btn_buy),
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        color: context.isBrightness ? Colour.c0xFFF7F8FD : Colour.FF111111,
        padding: EdgeInsets.only(top: 10.h, left: 10.h, right: 10.h),
        child: Column(
          children: [
            Obx(() {
              if (xPayViewModel.isCreateOrderIng.isTrue) {
                EasyLoading.show(status: '正在创建订单');
              } else {
                EasyLoading.dismiss();
              }
              if (xPayViewModel.isError) {
                xPayViewModel.showErrorMessage(context);
                xPayViewModel.isCreateOrderIng.value = false;
              }
              return SizedBox();
            }),
            Container(
              width: double.infinity,
              height: 120.h,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 120.h,
                    child: SvgPicture.asset(
                      ImageHelper.wrapAssets("paynum_bg.svg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 21.h, left: 15.w, right: 15.w, bottom: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "95号码",
                              style: subtitle1.change(context,
                                  color: Colour.backgroundColor2),
                            ),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "重选号码",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colour.backgroundColor2),
                                  ),
                                  SvgPicture.asset(
                                    ImageHelper.wrapAssets(
                                        "me_icon_more_white.svg"),
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Text(
                          "${xBuyViewModel.number}",
                          style: subtitle1.change(context,
                              fontSize: 22, color: Colour.backgroundColor2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 15.h, right: 15.h),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: _orderDecWidger(context),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Obx(() {
                  return Text(
                    '拨打此号码，绑定手机${StringUtils.formatMobileStar(xPayViewModel.bindPhone.value)}将收到来电',
                    textAlign: TextAlign.left,
                    style: textStyle.change(context, color: Colour.cFF999999),
                  );
                })),
            SizedBox(
              height: 20.h,
            ),
            Platform.isAndroid
                ? Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 15.h, right: 15.h),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: _paymethodWidger(context),
                  )
                : Text(""),
            SizedBox(
              height: 40.h,
            ),
            Spacer(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Obx(() {
                return CupertinoButton(
                    borderRadius: BorderRadius.circular(23),
                    padding: EdgeInsets.all(1),
                    color: Colour.f0F8FFB,
                    disabledColor: Colour.f0F8FFB.withAlpha(100),
                    child: Container(
                      height: 45.h,
                      alignment: Alignment.center,
                      child: Text(
                        '确认',
                        style: TextStyle(color: Colour.fffffff),
                      ),
                    ),
                    onPressed: xPayViewModel.isCreateOrderIng.isTrue
                        ? null
                        : () async {
                            if (xPayViewModel.bindPhone.isEmpty) {
                              showToast("请先绑定手机号");
                            } else {
                              if (Platform.isAndroid) {
                                xPayViewModel.wxPayOrder(
                                    xBuyViewModel.number.value,
                                    xBuyViewModel.perResult.value.price);
                              } else {
                                EasyLoading.show(
                                    status: '购买中,请稍后',
                                    maskType: EasyLoadingMaskType.black);
                                ApplePayModel applePayModel = ApplePayModel();
                                Map payresultMap =
                                    await applePayModel.createAppleOrder(
                                        xBuyViewModel.number.value,
                                        xPayViewModel.bindPhone.toString(),
                                        (xBuyViewModel.perResult.value.price *
                                                100)
                                            .toInt(),
                                        '0',
                                        '',
                                        xBuyViewModel.perResult.value.appgoodid
                                            .toString(),
                                        '');
                                if (applePayModel.isError) {
                                  applePayModel.showErrorMessage(context);
                                  EasyLoading.dismiss();
                                } else {
                                  // 获取需要 “恢复购买” 的列表，消耗型商品需要处理
                                  // List<PurchasedItem>? itemss =
                                  //     await FlutterInappPurchase.instance
                                  //         .getAvailablePurchases();
                                  await FlutterInappPurchase.instance
                                      .getProducts(AppleProductIdUtils
                                          .getAppleProductIdList());
                                  _requestPurchase(xBuyViewModel
                                      .perResult.value.appgoodid
                                      .toString());
                                  orderid = payresultMap["orderid"].toString();
                                }
                              }
                            }
                          });
              }),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  '点击确认，表示同意',
                  style: textStyle,
                ),
                InkWell(
                  child: Text(
                    S.of(context).user_agreement,
                    style: TextStyle(color: color, fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteName.webH5,
                        arguments:
                            "${ConstConfig.user_agreement}${Theme.of(context).brightness == Brightness.light ? 0 : 1}");
                  },
                ),
                InkWell(
                  child: Text(
                    S.of(context).privacy_agreement,
                    style: TextStyle(color: color, fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteName.webH5,
                        arguments:
                            "${ConstConfig.privacy}${Theme.of(context).brightness == Brightness.light ? 0 : 1}");
                  },
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderDecWidger(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    return Column(
      children: [
        SizedBox(
          height: 18.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "通讯服务费",
              style:
                  textTheme.subtitle1!.change(context, color: Colour.f333333),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '¥',
                  style: new TextStyle(
                      fontSize: 14.0,
                      // textBaseline: TextBaseline.alphabetic,
                      color: Colour.fEE4452),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Obx(() {
                  return Text(
                    '${xBuyViewModel.perResult.value.price}',
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        // textBaseline: TextBaseline.alphabetic,
                        color: Colour.fEE4452),
                    // textAlign: TextAlign.start,
                  );
                }),
                SizedBox(
                  width: 6.w,
                ),
                Text(
                  '/年',
                  style: new TextStyle(
                      fontSize: 14.0,
                      // textBaseline: TextBaseline.alphabetic,
                      color: Colour.fEE4452),
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 18.h,
        ),
        Divider(
          height: 0.5.h,
          color: context.isBrightness ? Colour.cFFEEEEEE : Colour.f0x1AFFFFFF,
        ),
        SizedBox(
          height: 18.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "号码有效期至",
              style:
                  textTheme.subtitle1!.change(context, color: Colour.f333333),
            ),
            Obx(() {
              return Text(
                '${xBuyViewModel.validtime}',
                style: context.isBrightness
                    ? textTheme.bodyText2!.change(context, fontSize: 16)
                    : TextStyle(color: Colour.f99ffffff, fontSize: 16),
              );
            }),
          ],
        ),
        SizedBox(
          height: 18.h,
        ),
        Divider(
          height: 0.5.h,
          color: context.isBrightness ? Colour.cFFEEEEEE : Colour.f0x1AFFFFFF,
        ),
        SizedBox(
          height: 18.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "绑定手机号",
              style:
                  textTheme.subtitle1!.change(context, color: Colour.f333333),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() {
                  return Text(
                    '${StringUtils.formatMobileStar(xPayViewModel.bindPhone.value)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, color: Colour.cFF666666, height: 1.1),
                  );
                }),
                SizedBox(
                  width: 15.w,
                ),
                InkWell(
                    onTap: () {
                      AlertEditPhoneDialog.showAlertDialog(
                          context, xPayViewModel.bindPhone.value, (phone) {},
                          (phone) {
                        showToast("验证码验证成功");
                        xPayViewModel.bindPhone.value = phone;
                      }, false);
                    },
                    child: Text(
                      xPayViewModel.bindPhone.isEmpty ? "绑定" : '更改',
                      style: TextStyle(
                          fontSize: 16, color: Colour.c0x0F88FF, height: 1.1),
                    )),
                SvgPicture.asset(
                    Theme.of(context).brightness == Brightness.light
                        ? ImageHelper.wrapAssets("me_icon_more.svg")
                        : ImageHelper.wrapAssets("me_icon_more_dark.svg")),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 18.h,
        ),
      ],
    );
  }

  Widget _paymethodWidger(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Column(
      children: [
        InkWell(
          onTap: () async {
            xPayViewModel.changePay();
          },
          child: Container(
              margin: EdgeInsets.only(top: 17.h, bottom: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImageHelper.wrapAssets("icon_wechatpay.svg"),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    '微信',
                    style: subtitle1,
                  ),
                  Spacer(),
                  Obx(() {
                    return SvgPicture.asset(
                      xPayViewModel.wechatPayChecked.value
                          ? ImageHelper.wrapAssets("phone_radio_selected.svg")
                          : context.isBrightness
                              ? ImageHelper.wrapAssets(
                                  "phone_radio_unselected.svg")
                              : ImageHelper.wrapAssets(
                                  "phone_radio_unselected_dark.svg"),
                    );
                  }),
                ],
              )),
        ),
        // Divider(
        //   // color: Color(0xffeeeeee),
        //   indent: 36.w,
        // ),
        // InkWell(
        //   onTap: () async {
        //     xPayViewModel.changePay();
        //   },
        //   child: Container(
        //       margin: EdgeInsets.only(top: 15.h, bottom: 16.h),
        //       child: Row(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           SvgPicture.asset(
        //             ImageHelper.wrapAssets("icon_alipay.svg"),
        //           ),
        //           SizedBox(
        //             width: 10.w,
        //           ),
        //           Text(
        //             '支付宝',
        //             style: subtitle1,
        //           ),
        //           Spacer(),
        //           Obx(() {
        //             return SvgPicture.asset(
        //               !xPayViewModel.wechatPayChecked.value
        //                   ? ImageHelper.wrapAssets("phone_radio_selected.svg")
        //                   : context.isBrightness
        //                       ? ImageHelper.wrapAssets(
        //                           "phone_radio_unselected.svg")
        //                       : ImageHelper.wrapAssets(
        //                           "phone_radio_unselected_dark.svg"),
        //             );
        //           })
        //         ],
        //       )),
        // ),
      ],
    );
  }

  Future<void> initPlatformState() async {
    // prepare
    var result = await FlutterInappPurchase.instance.initialize();
    print('result: $result');
    await clearTransaction();
    // 判断容器是否加载
    if (!mounted) return;
    // 更新购买订阅消息
    FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      if (productItem != null) {
        // await FlutterInappPurchase.instance.finishTransaction(productItem);
        // 获取需要 “恢复购买” 的列表，消耗型商品需要处理
// List<PurchasedItem>? itemss =
// await FlutterInappPurchase.instance.getAvailablePurchases();
//         /// 校验
        bool result = await ApplePayModel().queryapplepayresult(
            xBuyViewModel.number.value,
            "osinfo",
            productItem.transactionId.toString(),
            productItem.transactionReceipt.toString(),
            xBuyViewModel.appgoodid,
            (xBuyViewModel.perResult.value.price * 100).toInt(),
            orderid,
            '0',
            '',
            '');
        EasyLoading.dismiss();
        await FlutterInappPurchase.instance.finishTransaction(productItem);
        if (result) {
          // _purchaseUpdatedSubscription = null;
          // _purchaseErrorSubscription.cancel();
          // _purchaseErrorSubscription = null;
          xPayViewModel.wxPayResult.value = true;
          // xPayViewModel.checkLogin(
          //     isLogin ? accRepo.user!.mobile! : xPayViewModel.bindPhone.value,
          //     xBuyViewModel.number.value);
          Get.offNamed(RouteName.pNumberPayResult, arguments: true);
        } else {
          xPayViewModel.wxPayResult.value = false;
          Get.toNamed(RouteName.pNumberPayResult, arguments: false);
        }
      }
      // isPaying = false;
      print('purchase-updated: $productItem');
    });
    // 购买报错订阅消息
    FlutterInappPurchase.purchaseError.listen((purchaseError) async {
      EasyLoading.dismiss();
      // _purchaseUpdatedSubscription.cancel();
      print('purchase-error: $purchaseError');
    });
  }

  void _requestPurchase(String productid) {
    FlutterInappPurchase.instance.requestPurchase(productid);
  }

  /// 关闭iOS支付连接
  void closeIosConnection() async {
    await FlutterInappPurchase.instance.finalize();
  }

  /// 销毁之前的订单，否则无法多次购买
  Future clearTransaction() async {
    return FlutterInappPurchase.instance.clearTransactionIOS();
  }
}
