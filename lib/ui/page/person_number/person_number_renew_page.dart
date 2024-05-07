import 'package:weihua_flutter/config/const_config.dart';
import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/ui/page/person_number/person_number_renew_result_page.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/apple_pay_model.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/pay_view_model.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/renew_num_mode.dart';
import 'package:weihua_flutter/ui/page/workbench/enterprise_info_page.dart';
import 'package:weihua_flutter/utils/platform_utils.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:weihua_flutter/utils/time_util.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:get/get.dart';
import 'package:weihua_flutter/utils/apple_productid.dart';

///
/// @Desc: 号码续费
///
/// @Author: zm
///
/// @Date: 21/8/18
///
class RenewPersonNumberPage extends StatefulWidget {
  final Map mapInfo;
  RenewPersonNumberPage(this.mapInfo);

  @override
  _RenewPayPersonNumberPageState createState() =>
      _RenewPayPersonNumberPageState();
}

class _RenewPayPersonNumberPageState extends State<RenewPersonNumberPage> {
  XRenewNumMode xRenewNumMode = XRenewNumMode();
  final XPayViewModel xPayViewModel = Get.put(XPayViewModel());

  String orderid = "";
  String num = "";
  @override
  void initState() {
    super.initState();
    num = widget.mapInfo['number'];
    if (StringUtils.isEmptyString(num)) {
      num = accRepo.user!.outerNumber2!;
    }
    xRenewNumMode.initData(widget.mapInfo['number']);
    initPlatformState();

    // 监听支付结果
    fluwx.weChatResponseEventHandler.listen((event) async {
      xRenewNumMode.isCreateOrderIng.value = false;

      if (payType != ConstConfig.pay_type_renew) return;
      if (event is fluwx.WeChatPaymentResponse) {
        // 支付成功
        if (event.errCode == 0) {
          xRenewNumMode.getCurrent();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return RenewPayResultPage(
              true,
              num: '$num',
              time:
                  '${TimeUtil.formatTime2(xRenewNumMode.reNewPack.value.validtime)}',
            );
          }));
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return RenewPayResultPage(
              false,
            );
          }));
        }
      }
      // 关闭弹窗
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('续费'),
        backgroundColor: Theme.of(context).cardColor,
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
        width: double.infinity,
        padding: EdgeInsets.only(top: 15.h),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10.w, right: 10.w),
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Obx(() {
                    if (xRenewNumMode.isBusy) {
                      EasyLoading.show(status: '正在加载数据...');
                    }
                    if (xRenewNumMode.isCreateOrderIng.isTrue) {
                      EasyLoading.show(status: '正在创建订单');
                    }
                    if (xRenewNumMode.isCreateOrderIng.isFalse) {
                      EasyLoading.dismiss();
                    }
                    if (xRenewNumMode.isError) {
                      xRenewNumMode.isCreateOrderIng.value = false;
                      xRenewNumMode.showErrorMessage(context);
                    }
                    return SizedBox();
                  }),
                  Container(
                    padding: EdgeInsets.only(left: 15.h, right: 15.h),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: _orderDecWidger(context),
                  )
                ],
              ),
            ),
            Platform.isIOS
                ? Text('')
                : Container(
                    margin: EdgeInsets.only(right: 10.w, top: 10, left: 10.w),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 15.h, right: 15.h),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: _paymethodWidget(context),
                  ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '点击续费，表示您已同意',
                  style: TextStyle(fontSize: 14, color: Colour.cFF666666),
                ),
                InkWell(
                  child: Text(
                    '《服务协议》',
                    style: TextStyle(fontSize: 14, color: Colour.f0F8FFB),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteName.webH5,
                        arguments:
                            "${ConstConfig.user_agreement}${Theme.of(context).brightness == Brightness.light ? 0 : 1}");
                  },
                )
              ],
            ),
            InkWell(
              child: Obx(() {
                return Container(
                  height: 40.h,
                  margin: EdgeInsets.only(
                      top: 10.h, bottom: 20.h, left: 15.w, right: 15.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                          //渐变位置
                          begin: Alignment.topCenter, //右上
                          end: Alignment.bottomCenter, //左下
                          //渐变颜色[始点颜色, 结束颜色]
                          colors: !xRenewNumMode.isBusy &&
                                  xRenewNumMode.isCreateOrderIng.isFalse
                              ? [Colour.FFFFB21B, Colour.FFFF8F01]
                              : [Colour.FF6C7588, Colour.FF6C7588])),
                  alignment: Alignment.center,
                  child: Text(
                    Platform.isIOS ? 'Pay续费' : '立即续费',
                    style: TextStyle(color: Colour.fffffff),
                  ),
                );
              }),
              onTap: () async {
                if (xRenewNumMode.isCreateOrderIng.isTrue) return;
                if (Platform.isIOS) {
                  EasyLoading.show(
                      status: '购买中,请稍后', maskType: EasyLoadingMaskType.black);
                  ApplePayModel applePayModel = ApplePayModel();
                  Map payresultMap = await applePayModel.createAppleOrder(
                      num,
                      accRepo.user!.mobile!,
                      (xRenewNumMode.reNewPack.value.price * 100).toInt(),
                      '6',
                      xRenewNumMode.reNewPack.value.wareid.toString(),
                      xRenewNumMode.reNewPack.value.appgoodid.toString(),
                      xRenewNumMode.reNewPack.value.name.toString());
                  if (applePayModel.isError) {
                    applePayModel.showErrorMessage(context);
                    EasyLoading.dismiss();
                  } else {
                    // 获取需要 “恢复购买” 的列表，消耗型商品需要处理
                    // List<PurchasedItem>? itemss =
                    //     await FlutterInappPurchase.instance
                    //         .getAvailablePurchases();
                    await FlutterInappPurchase.instance.getProducts(
                        AppleProductIdUtils.getAppleProductIdList());
                    _requestPurchase(
                        xRenewNumMode.reNewPack.value.appgoodid.toString());
                    orderid = payresultMap["orderid"].toString();
                  }
                } else {
                  xRenewNumMode.wxPayOrder(widget.mapInfo['businessid'],
                      '${widget.mapInfo['number']}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderDecWidger(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle caption = textTheme.caption!;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.h,
        ),
        Text(
          '$num',
          style: subtitle1.change(context, fontSize: 22),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "号码有效期至：",
              style: textTheme.caption!.change(context, fontSize: 14),
            ),
            Obx(() {
              return Text(
                '${TimeUtil.formatTime2(xRenewNumMode.reNewPack.value.current)}',
                style: textTheme.caption!.change(context, fontSize: 14),
              );
            })
          ],
        ),
        SizedBox(
          height: 18.h,
        ),
        Stack(
          children: [
            Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: double.infinity,
                  height: 100.h,
                  child: context.isBrightness
                      ? SvgPicture.asset(
                          ImageHelper.wrapAssets('img_taocan_renew.svg'),
                          fit: BoxFit.fill,
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: Colour.c1AFFFFFF,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                        ),
                )),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              height: 100.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Obx(() {
                            return Text(
                              '${xRenewNumMode.reNewPack.value.name}',
                              style: subtitle1,
                            );
                          }),
                          SizedBox(
                            width: 6.w,
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 1.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: LinearGradient(
                                    //渐变位置
                                    begin: Alignment.topCenter, //右上
                                    end: Alignment.bottomCenter, //左下
                                    //渐变颜色[始点颜色, 结束颜色]
                                    colors: [
                                      Colour.FFFF8786,
                                      Colour.FFFF4F4E
                                    ])),
                            child: Text(
                              '特惠',
                              style: TextStyle(
                                  fontSize: 12, color: Colour.fffffff),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Obx(() {
                            return Text(
                              '¥${xRenewNumMode.reNewPack.value.sells}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colour.FF999999,
                                decoration: TextDecoration.lineThrough,
                              ),
                            );
                          }),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            '¥',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colour.FFFF4F4E,
                              textBaseline: TextBaseline.ideographic,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Obx(() {
                            return Text(
                              '${xRenewNumMode.reNewPack.value.price}',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colour.FFFF4F4E,
                                textBaseline: TextBaseline.ideographic,
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Obx(() {
                    return Text(
                      '号码有效期将至${TimeUtil.formatTime2(xRenewNumMode.reNewPack.value.validtime)}',
                      style: caption.change(context, fontSize: 14),
                    );
                  })
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }

  Widget _paymethodWidget(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Column(
      children: [
        InkWell(
          onTap: () async {},
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
                  SvgPicture.asset(
                      // true
                      //     ?
                      ImageHelper.wrapAssets("phone_radio_selected.svg")
                      // : context.isBrightness
                      //     ? ImageHelper.wrapAssets(
                      //         "phone_radio_unselected.svg")
                      //     : ImageHelper.wrapAssets(
                      //         "phone_radio_unselected_dark.svg"),
                      )
                ],
              )),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    closeIosConnection();
    super.dispose();
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
      // _purchaseUpdatedSubscription.cancel();
      // await FlutterInappPurchase.instance.endConnection;
      if (productItem != null) {
        //    _purchaseUpdatedSubscription.cancel();
        // await FlutterInappPurchase.instance.endConnection;
        // 获取需要 “恢复购买” 的列表，消耗型商品需要处理
// List<PurchasedItem>? itemss =
// await FlutterInappPurchase.instance.getAvailablePurchases();
//         /// 校验
        bool result = await ApplePayModel().queryapplepayresult(
            accRepo.unifyLoginResult!.perNumberList[0].outerNumber2!,
            "osinfo",
            productItem.transactionId.toString(),
            productItem.transactionReceipt.toString(),
            xRenewNumMode.reNewPack.value.appgoodid.toString(),
            (xRenewNumMode.reNewPack.value.price * 100).toInt(),
            orderid,
            '6',
            '',
            '');
        EasyLoading.dismiss();
        await FlutterInappPurchase.instance.finishTransaction(productItem);
        if (result) {
          // _purchaseUpdatedSubscription = null;
          // _purchaseErrorSubscription.cancel();
          // _purchaseErrorSubscription = null;
          xPayViewModel.wxPayResult.value = true;
          xRenewNumMode.getCurrent();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return RenewPayResultPage(
              true,
              num: '$num',
              time:
                  '${TimeUtil.formatTime2(xRenewNumMode.reNewPack.value.validtime)}',
            );
          }));
        } else {
          xPayViewModel.wxPayResult.value = false;
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return RenewPayResultPage(
              false,
            );
          }));
        }
      }
      print('purchase-updated: $productItem');
    });
    // 购买报错订阅消息
    FlutterInappPurchase.purchaseError.listen((purchaseError) async {
      EasyLoading.dismiss();
      // _purchaseUpdatedSubscription.cancel();
      // FlutterInappPurchase.instance.endConnection;
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
