import 'package:weihua_flutter/config/const_config.dart';
import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/apple_pay_model.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/package_item.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/package_list_mode.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/pay_view_model.dart';
import 'package:weihua_flutter/ui/page/workbench/buy_extnum_result_page.dart';
import 'package:weihua_flutter/ui/page/workbench/viewmodel/buy_extension_num_mode.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/platform_utils.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:weihua_flutter/utils/apple_productid.dart';

///
/// @Desc: 发现-分机-购买分机
///
/// @Author: zm
///
/// @Date: 21/11/16
///
class BuyExtensionNumPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BuyExtensionNumPageState();
}

class _BuyExtensionNumPageState extends State {
  XPackageListMode _xPackageListMode = new XPackageListMode();
  XBuyExtensionNumMode _xBuyExtensionNumMode = new XBuyExtensionNumMode();

  final XPayViewModel xPayViewModel = Get.put(XPayViewModel());

  // final XBuyViewModel xBuyViewModel = Get.find();

  String? orderid;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _xPackageListMode.getPackageList(
        Platform.isIOS ? 'whInner_ios' : ConstConfig.package_type_inner);
    // 监听支付结果
    fluwx.weChatResponseEventHandler.listen((event) async {
      _xBuyExtensionNumMode.isCreateOrderIng.value = false;
      Log.d('zhangmin==${event.errCode}');
      if (payType != ConstConfig.pay_type_buyext) return;
      payType = -1;
      if (event is fluwx.WeChatPaymentResponse) {
        if (event.errCode == 0) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return BuyExtNumResultPage(
              true,
              _xPackageListMode.getCheckItem()!,
            );
          }));
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return BuyExtNumResultPage(
              false,
              _xPackageListMode.getCheckItem()!,
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
    // _conectionSubscription.cancel();
    closeIosConnection();
    // _conectionSubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Scaffold(
      appBar: AppBar(
        title: Text('购买'),
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
            if (_xBuyExtensionNumMode.isCreateOrderIng.isTrue) {
              EasyLoading.show(status: '正在创建订单');
            } else {
              EasyLoading.dismiss();
            }
            if (_xBuyExtensionNumMode.isError) {
              payType = -1;
              _xBuyExtensionNumMode.isCreateOrderIng.value = false;
              _xBuyExtensionNumMode.showErrorMessage(context);
            }
            if (_xBuyExtensionNumMode.isIdle) {
              EasyLoading.dismiss();
            }

            return SizedBox();
          }),
          _packListWidget(context, _xPackageListMode),
          Container(
              margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  left: 15.h, right: 15.h, top: 17.h, bottom: 15.h),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Row(
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
                          '${_xPackageListMode.getCheckItem()!.price}',
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
              )),
          _paymethodWidget(context),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '点击支付，表示您已同意',
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
                        colors: _xBuyExtensionNumMode.isBusy ||
                                _xBuyExtensionNumMode.isCreateOrderIng.isTrue ||
                                _xPackageListMode.getCheckItem() == null ||
                                _xPackageListMode.getCheckItem()!.price == 0
                            ? [Colour.FF6C7588, Colour.FF6C7588]
                            : [Colour.FFFFB21B, Colour.FFFF8F01])),
                alignment: Alignment.center,
                child: Text(
                  Platform.isIOS
                      ? 'pay支付（${_xPackageListMode.getCheckItem()!.price}元）'
                      : '去支付（${_xPackageListMode.getCheckItem()!.price}元）',
                  style: TextStyle(color: Colour.fffffff),
                ),
              );
            }),
            onTap: () async {
              if (_xBuyExtensionNumMode.isBusy ||
                  _xBuyExtensionNumMode.isCreateOrderIng.isTrue ||
                  _xPackageListMode.getCheckItem() == null ||
                  _xPackageListMode.getCheckItem()!.price == 0) {
                return;
              }
              if (Platform.isIOS) {
                EasyLoading.show(
                    status: '购买中,请稍后', maskType: EasyLoadingMaskType.black);
                ApplePayModel applePayModel = ApplePayModel();
                Map payresultMap = await applePayModel.createAppleOrder(
                    accRepo.user!.outerNumber.toString(),
                    accRepo.user!.mobile.toString(),
                    (_xPackageListMode.getCheckItem()!.price * 100).toInt(),
                    '5',
                    _xPackageListMode.getCheckItem()!.id.toString(),
                    _xPackageListMode.getCheckItem()!.appgoodid.toString(),
                    _xPackageListMode.getCheckItem()!.name.toString());
                if (applePayModel.isError) {
                  applePayModel.showErrorMessage(context);
                  EasyLoading.dismiss();
                } else {
                  // 获取需要 “恢复购买” 的列表，消耗型商品需要处理
                  // List<PurchasedItem>? itemss =
                  //     await FlutterInappPurchase.instance
                  //         .getAvailablePurchases();
                  await FlutterInappPurchase.instance
                      .getProducts(AppleProductIdUtils.getAppleProductIdList());
                  _requestPurchase(
                      _xPackageListMode.getCheckItem()!.appgoodid.toString());
                  orderid = payresultMap["orderid"].toString();
                }
              } else {
                _xBuyExtensionNumMode
                    .wxPayOrder(_xPackageListMode.getCheckItem()!);
              }
            },
          ),
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
        // 获取需要 “恢复购买” 的列表，消耗型商品需要处理
// List<PurchasedItem>? itemss =
// await FlutterInappPurchase.instance.getAvailablePurchases();
//         /// 校验
        bool result = await ApplePayModel().queryapplepayresult(
            accRepo.user!.outerNumber.toString(),
            "osinfo",
            productItem.transactionId.toString(),
            productItem.transactionReceipt.toString(),
            _xPackageListMode.getCheckItem()!.appgoodid,
            (_xPackageListMode.getCheckItem()!.price * 100).toInt(),
            orderid!,
            '5',
            '',
            '');
        EasyLoading.dismiss();
        if (result) {
          // _purchaseUpdatedSubscription = null;
          // _purchaseErrorSubscription.cancel();
          // _purchaseErrorSubscription = null;
          xPayViewModel.wxPayResult.value = true;
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return BuyExtNumResultPage(
              true,
              _xPackageListMode.getCheckItem()!,
            );
          }));
        } else {
          xPayViewModel.wxPayResult.value = false;
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return BuyExtNumResultPage(
              false,
              _xPackageListMode.getCheckItem()!,
            );
          }));
        }
        await FlutterInappPurchase.instance.finishTransaction(productItem);
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
          ));
}

Widget _packListWidget(BuildContext context, XPackageListMode packageListMode) {
  ThemeData themeData = Theme.of(context);
  TextTheme textTheme = themeData.textTheme;
  TextStyle subtitle1 = textTheme.subtitle1!;
  return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 15.w, right: 5.w, top: 15.h, bottom: 15.h),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '选择分机',
            style: subtitle1.change(context),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.h),
            height: 80.h,
            child: Obx(() {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: packageListMode.packageItemList.length,
                itemBuilder: (
                  context,
                  index,
                ) {
                  return _itemContent(
                      context,
                      packageListMode.packageItemList[index],
                      index,
                      packageListMode);
                },
              );
            }),
          ),
        ],
      ));
}

Widget _itemContent(BuildContext context, PackageItem packageItem, int index,
    XPackageListMode packageListMode) {
  ThemeData theme = Theme.of(context);
  TextTheme textTheme = theme.textTheme;
  TextStyle subtitle1 = textTheme.subtitle1!;

  return Stack(
    children: [
      InkWell(
        child: Obx(() {
          return Container(
            alignment: Alignment.center,
            height: 72.h,
            margin: EdgeInsets.only(right: 10.w, top: 13.h, left: 5.w),
            decoration: BoxDecoration(
                border: Border.all(
                    color: packageListMode.checkedIndex.value == index
                        ? Colour.c0xF25643
                        : context.isBrightness
                            ? Colour.cFFEEEEEE
                            : Colour.c1AFFFFFF,
                    width: 1)),
            width: 102.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${packageItem.name}',
                  overflow: TextOverflow.ellipsis,
                  style: subtitle1.change(context, fontSize: 14, height: 1.6),
                ),
                Text(
                  '${packageItem.remark}',
                  style: subtitle1.change(context, fontSize: 12, height: 1.1),
                )
              ],
            ),
          );
        }),
        onTap: () {
          packageListMode.checkedIndex.value = index;
        },
      ),
      Visibility(
          visible: index == 0,
          child: Positioned(
            left: 0,
            top: 0,
            child: SvgPicture.asset(
              ImageHelper.wrapAssets('icon_tuijian.svg'),
            ),
          )),
    ],
  );
}
