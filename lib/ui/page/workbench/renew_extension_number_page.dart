import 'package:weihua_flutter/config/const_config.dart';
import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/apple_pay_model.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/pay_view_model.dart';
import 'package:weihua_flutter/ui/page/workbench/renew_extnum_result_page.dart';
import 'package:weihua_flutter/ui/page/workbench/viewmodel/renew_extension_num_mode.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/platform_utils.dart';
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

import '../../../model/extension_result.dart';

///
/// @Desc: 发现-分机-续费
///
/// @Author: zm
///
/// @Date: 21/11/16
///
class RenewExtensionNumPage extends StatefulWidget {
  final ExtensionInfo extensionInfo;

  RenewExtensionNumPage(this.extensionInfo);

  @override
  State<StatefulWidget> createState() => _RenewExtensionNumPageState();
}

class _RenewExtensionNumPageState extends State<RenewExtensionNumPage> {
  XRenewExtensionNumMode _xRenewExtensionNumMode = Get.find();

  final XPayViewModel xPayViewModel = Get.put(XPayViewModel());
  String? orderid;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // _xRenewExtensionNumMode.getWareInfo('${widget.extensionInfo.expiryDate}',
    //     '${widget.extensionInfo.orderId}');
    // 监听支付结果
    fluwx.weChatResponseEventHandler.listen((event) async {
      Log.d('zhangmin==${event.errCode}---$payType');
      _xRenewExtensionNumMode.isCreateOrderIng.value = false;
      if (payType != ConstConfig.pay_type_renewext) return;
      payType = -1;
      if (event is fluwx.WeChatPaymentResponse) {
        if (event.errCode == 0) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return RenewExtNumResultPage(
              true,
              _xRenewExtensionNumMode.wareInfo.value,
            );
          }));
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return RenewExtNumResultPage(
              false,
              _xRenewExtensionNumMode.wareInfo.value,
            );
          }));
        }
      }
    });
  }

  @override
  void dispose() {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    xPayViewModel.isCreateOrderIng.value = false;
    closeIosConnection();
    super.dispose();
    // _conectionSubscription = null;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle caption = textTheme.caption!;
    return Scaffold(
      appBar: AppBar(
        title: Text('分机续费'),
        backgroundColor: Theme.of(context).cardColor,
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: [
          Obx(() {
            if (_xRenewExtensionNumMode.isCreateOrderIng.isTrue) {
              EasyLoading.show(status: '正在创建订单');
            } else {
              EasyLoading.dismiss();
            }
            if (_xRenewExtensionNumMode.isError) {
              payType = -1;
              _xRenewExtensionNumMode.isCreateOrderIng.value = false;
              _xRenewExtensionNumMode.showErrorMessage(context);
            }
            if (_xRenewExtensionNumMode.isIdle) {
              EasyLoading.dismiss();
            }

            return SizedBox();
          }),
          Container(
              margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  left: 15.h, right: 15.h, top: 17.h, bottom: 15.h),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '分机数量',
                        style: subtitle1.change(context, color: Colour.f333333),
                      ),
                      Spacer(),
                      Obx(() {
                        return Text(
                          '${_xRenewExtensionNumMode.wareInfo.value.limit}个',
                          style: caption.change(context, fontSize: 16),
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Divider(
                    height: 0.5,
                    color: context.isBrightness
                        ? Colour.cFFEEEEEE
                        : Colour.f0x1AFFFFFF,
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '有效期至',
                        style: subtitle1.change(context, color: Colour.f333333),
                      ),
                      Spacer(),
                      Obx(() {
                        return Text(
                          '${TimeUtil.formatTime2(_xRenewExtensionNumMode.wareInfo.value.validTime)}',
                          style: caption.change(context, fontSize: 16),
                        );
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Divider(
                    height: 0.5,
                    color: context.isBrightness
                        ? Colour.cFFEEEEEE
                        : Colour.f0x1AFFFFFF,
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '金额',
                        style: subtitle1,
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            '¥',
                            style: TextStyle(
                                color: Colour.FFFF4F4E,
                                fontSize: 14.sp,
                                height: 1.6),
                          ),
                          Obx(() {
                            return Text(
                              '${_xRenewExtensionNumMode.wareInfo.value.price}',
                              style: TextStyle(
                                  color: Colour.FFFF4F4E, fontSize: 22.sp),
                            );
                          }),
                          Text(
                            '/年',
                            style: TextStyle(
                                color: Colour.FFFF4F4E,
                                fontSize: 14.sp,
                                height: 1.6),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              )),
          _paymethodWidget(context),
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
          InkWell(onTap: () async {
            if (_xRenewExtensionNumMode.isBusy ||
                _xRenewExtensionNumMode.isCreateOrderIng.isTrue ||
                _xRenewExtensionNumMode.wareInfo.value.limit == 0) {
              return;
            }
            if (Platform.isIOS) {
              EasyLoading.show(
                  status: '购买中,请稍后', maskType: EasyLoadingMaskType.black);
              ApplePayModel applePayModel = ApplePayModel();
              Map payresultMap = await applePayModel.createAppleOrder(
                  accRepo.user!.outerNumber!,
                  accRepo.user!.mobile.toString(),
                  (_xRenewExtensionNumMode.wareInfo.value.price * 100).toInt(),
                  '4',
                  _xRenewExtensionNumMode.wareInfo.value.wareid.toString(),
                  _xRenewExtensionNumMode.wareInfo.value.appgoodid.toString(),
                  '');
              if (applePayModel.isError) {
                applePayModel.showErrorMessage(context);
                EasyLoading.dismiss();
              } else {
                // 获取需要 “恢复购买” 的列表，消耗型商品需要处理
                // List<PurchasedItem>? itemss =
                // await FlutterInappPurchase.instance
                //     .getAvailablePurchases();
                await FlutterInappPurchase.instance
                    .getProducts(AppleProductIdUtils.getAppleProductIdList());
                _requestPurchase(_xRenewExtensionNumMode
                    .wareInfo.value.appgoodid
                    .toString());
                orderid = payresultMap["orderid"].toString();
              }
            } else {
              _xRenewExtensionNumMode
                  .wxPayOrder('${widget.extensionInfo.orderId}');
            }
          }, child: Obx(() {
            return Container(
              height: 45.h,
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
                      colors: _xRenewExtensionNumMode.isBusy ||
                              _xRenewExtensionNumMode.isCreateOrderIng.isTrue ||
                              _xRenewExtensionNumMode.wareInfo.value.limit == 0
                          ? [Colour.FF6C7588, Colour.FF6C7588]
                          : [Colour.FFFFB21B, Colour.FFFF8F01])),
              alignment: Alignment.center,
              child: Text(
                Platform.isIOS ? 'pay续费' : '立即续费',
                style: TextStyle(color: Colour.fffffff),
              ),
            );
          })),
        ],
      ),
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
      // _purchaseUpdatedSubscription.cancel();
      // await FlutterInappPurchase.instance.endConnection;
      if (productItem != null) {
        await FlutterInappPurchase.instance.finishTransaction(productItem);
        // 获取需要 “恢复购买” 的列表，消耗型商品需要处理
// List<PurchasedItem>? itemss =
// await FlutterInappPurchase.instance.getAvailablePurchases();
//         /// 校验
        bool result = await ApplePayModel().queryapplepayresult(
            accRepo.user!.outerNumber.toString(),
            "osinfo",
            productItem.transactionId.toString(),
            productItem.transactionReceipt.toString(),
            _xRenewExtensionNumMode.wareInfo.value.appgoodid,
            (_xRenewExtensionNumMode.wareInfo.value.price * 100).toInt(),
            orderid!,
            '4',
            _xRenewExtensionNumMode.wareInfo.value.validTime.toString(),
            widget.extensionInfo.orderId.toString());
        EasyLoading.dismiss();
        if (result) {
          // _purchaseUpdatedSubscription = null;
          // _purchaseErrorSubscription.cancel();
          // _purchaseErrorSubscription = null;
          xPayViewModel.wxPayResult.value = true;
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return RenewExtNumResultPage(
              true,
              _xRenewExtensionNumMode.wareInfo.value,
            );
          }));
        } else {
          xPayViewModel.wxPayResult.value = false;
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return RenewExtNumResultPage(
              false,
              _xRenewExtensionNumMode.wareInfo.value,
            );
          }));
        }
      }
      // isPaying = false;
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

Widget _paymethodWidget(BuildContext context) {
  ThemeData themeData = Theme.of(context);
  TextTheme textTheme = themeData.textTheme;
  TextStyle subtitle1 = textTheme.subtitle1!;
  return Platform.isIOS
      ? Text('')
      : Container(
          margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 15.h, right: 15.h),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Column(
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
          ));
}
