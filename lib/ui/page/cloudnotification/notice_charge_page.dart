import 'package:weihua_flutter/config/const_config.dart';
import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/notice_charge_result_page.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/viewmodel/count_charge_model.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/viewmodel/notice_page_view_model.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/apple_pay_model.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/package_item.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/package_list_mode.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/pay_view_model.dart';
import 'package:weihua_flutter/ui/widget/XFDashedLine.dart';
import 'package:weihua_flutter/utils/platform_utils.dart';
import 'package:weihua_flutter/utils/apple_productid.dart';
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

class NoticeChargePage extends StatefulWidget {
  final int count;

  NoticeChargePage({this.count = 0});

  @override
  State<StatefulWidget> createState() => _NoticeChargePageState();
}

class _NoticeChargePageState extends State<NoticeChargePage> {
  XCountChargeModel _chargeModel = XCountChargeModel();
  XPackageListMode _xPackageListMode = XPackageListMode();
  XNoticePageViewModel xNoticePageViewModel = Get.find();
  final XPayViewModel xPayViewModel = Get.put(XPayViewModel());

  String orderid = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _xPackageListMode.getPackageList(
        Platform.isIOS ? 'whVoice_ios' : ConstConfig.package_type_count);
    // 监听支付结果
    fluwx.weChatResponseEventHandler.listen((event) async {
      _chargeModel.isCreateOrderIng.value = false;
      if (payType != ConstConfig.pay_type_charge) return;
      payType = -1;
      if (event is fluwx.WeChatPaymentResponse) {
        if (event.errCode == 0) {
          xNoticePageViewModel.searchSendTimes();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return NoticeChargeResultPage(
              true,
              _xPackageListMode.getCheckItem()!,
            );
          }));
        } else
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return NoticeChargeResultPage(
              false,
              _xPackageListMode.getCheckItem()!,
            );
          }));
      }
    });
  }

  @override
  void dispose() {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    closeIosConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('次数充值'),
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            if (_chargeModel.isCreateOrderIng.isTrue) {
              EasyLoading.show(status: '正在创建订单');
            } else {
              EasyLoading.dismiss();
            }
            // if (_xPackageListMode.isBusy) EasyLoading.show(status: '加载数据');
            // if (_xPackageListMode.isError)
            //   _xPackageListMode.showErrorMessage(context);
            // if (_xPackageListMode.isIdle) EasyLoading.dismiss();
            return SizedBox();
          }),
          Visibility(
              visible: widget.count == 0,
              child: Container(
                height: 48.h,
                padding: EdgeInsets.only(left: 30.w),
                color: context.isBrightness
                    ? Colour.F19F75854
                    : Colour.c0xFF7C2B2A,
                child: Row(
                  children: [
                    SvgPicture.asset(
                        ImageHelper.wrapAssets('icon_notice_tip.svg')),
                    SizedBox(
                      width: 15.w,
                    ),
                    Text(
                      '为了不影响您正常发送通知，请尽快购买次数',
                      style: subtitle2,
                    )
                  ],
                ),
              )),
          Container(
            height: 112.h,
            padding: EdgeInsets.only(top: 10.h, right: 10.w, left: 10.w),
            child: Stack(
              children: [
                SvgPicture.asset(
                  ImageHelper.wrapAssets('icon_notice_charge_topbg.svg'),
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned(
                    top: 18.h,
                    left: 15.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '剩余发送数',
                          style: subtitle1.change(context, color: Colors.white),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Text(
                              '${widget.count}',
                              style: subtitle1.change(context,
                                  fontSize: 40, color: Colors.white, height: 1),
                            ),
                            Text(
                              ' 次',
                              style: subtitle1.change(context,
                                  color: Colors.white, height: 1),
                            )
                          ],
                        )
                      ],
                    )),
              ],
            ),
          ),
          Container(
            color: Theme.of(context).cardColor,
            margin: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15.w, top: 20.h, bottom: 15.h),
                  child: Text(
                    '选择套餐',
                    style: subtitle1.change(context, color: Colour.f333333),
                  ),
                ),
                Container(
                  height: 151.h,
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  child: Obx(() {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _xPackageListMode.packageItemList.length,
                      itemBuilder: (
                        context,
                        index,
                      ) {
                        return _itemContent(context,
                            _xPackageListMode.packageItemList[index], index);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          Platform.isIOS
              ? Text('')
              : Container(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(6)),
                  margin: EdgeInsets.only(left: 15.w, top: 20.h, right: 15.h),
                  child: _paymethodWidget(context),
                ),
          Spacer(),
          Container(
            padding: EdgeInsets.only(
                top: 15.h, left: 15.w, right: 15.w, bottom: 35.h),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(6)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '点击支付，表示您已同意',
                      style: TextStyle(fontSize: 14, color: Colour.cFF666666),
                    ),
                    InkWell(
                      child: Text(
                        '《用户协议》',
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
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () async {
                    if (_xPackageListMode.getCheckItem()!.id == -1 ||
                        _xPackageListMode.getCheckItem()!.price == 0.0) {
                      return;
                    } else if (Platform.isIOS) {
                      EasyLoading.show(
                          status: '购买中,请稍后',
                          maskType: EasyLoadingMaskType.black);
                      ApplePayModel applePayModel = ApplePayModel();
                      Map payresultMap = await applePayModel.createAppleOrder(
                          accRepo
                              .unifyLoginResult!.perNumberList[0].outerNumber!,
                          accRepo.user!.mobile.toString(),
                          (_xPackageListMode.getCheckItem()!.price * 100)
                              .toInt(),
                          '3',
                          _xPackageListMode.getCheckItem()!.id.toString(),
                          _xPackageListMode
                              .getCheckItem()!
                              .appgoodid
                              .toString(),
                          _xPackageListMode.getCheckItem()!.name.toString());
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
                        _requestPurchase(_xPackageListMode
                            .getCheckItem()!
                            .appgoodid
                            .toString());
                        orderid = payresultMap["orderid"].toString();
                      }
                    } else {
                      _chargeModel
                          .wxPayOrder(_xPackageListMode.getCheckItem()!);
                    }
                  },
                  child: Obx(() {
                    return Container(
                      alignment: Alignment.center,
                      height: 50.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                              //渐变位置
                              begin: Alignment.topCenter, //右上
                              end: Alignment.bottomCenter, //左下
                              stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                              //渐变颜色[始点颜色, 结束颜色]
                              colors: _xPackageListMode.getCheckItem() !=
                                          null &&
                                      !_xPackageListMode.isBusy &&
                                      _xPackageListMode.getCheckItem()!.price !=
                                          0.0
                                  ? [Colour.FFFCAE0C, Colour.FFFB9305]
                                  : [Colour.FF6C7588, Colour.FF6C7588])),
                      child: Text(
                        Platform.isIOS
                            ? 'Pay支付(${_xPackageListMode.getCheckItem()!.price}元)'
                            : '去支付(${_xPackageListMode.getCheckItem()!.price}元)',
                        style: TextStyle(
                            color: Colour.backgroundColor2, fontSize: 16),
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemContent(
      BuildContext context, PackageItem packageItem, int index) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return GestureDetector(
        onTap: () {
          _xPackageListMode.checkedIndex.value = index;
        },
        child: Container(
          width: 107.w,
          height: 114.h,
          // color: Colour.fEE4452,
          child: Stack(
            children: [
              Obx(() {
                return Positioned(
                  left: 5,
                  top: 10,
                  child: _xPackageListMode.checkedIndex.value == index
                      ? SvgPicture.asset(
                          ImageHelper.wrapAssets(context.isBrightness
                              ? 'bg_frame.svg'
                              : 'bg_frame_black.svg'),
                          alignment: Alignment.center,
                          fit: BoxFit.fill,
                        )
                      : SvgPicture.asset(
                          ImageHelper.wrapAssets(context.isBrightness
                              ? 'bg_frame_unselect.svg'
                              : 'bg_frame_unselect_black.svg'),
                          fit: BoxFit.fill,
                        ),
                );
              }),
              Visibility(
                  visible: index == 0,
                  child: Positioned(
                    left: 0,
                    top: 0,
                    child: SvgPicture.asset(
                      ImageHelper.wrapAssets('icon_tuijian.svg'),
                    ),
                  )),
              Positioned(
                left: 5.w,
                right: Platform.isIOS ? 10.w : 5.w,
                top: 24.h,
                child: Container(
                  // width: 92.w,
                  // height: 95.h,
                  alignment: Alignment.topCenter,
                  // color: Colour.FFFE9F00,
                  child: Column(
                    children: [
                      Text(
                        '${packageItem.remark}',
                        style: subtitle1.change(context,
                            color: Colour.f333333, fontSize: 14),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${packageItem.sms}',
                            style: TextStyle(
                                color: context.isBrightness
                                    ? Colour.f333333
                                    : Colour.fDEffffff,
                                fontSize: 24,
                                textBaseline: TextBaseline.alphabetic),
                          ),
                          Text(
                            '次',
                            style: TextStyle(
                                color: context.isBrightness
                                    ? Colour.f333333
                                    : Colour.fDEffffff,
                                fontSize: 12,
                                textBaseline: TextBaseline.alphabetic),
                          )
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 11.h),
                          width: 63.w,
                          child: XFDashedLine(
                            axis: Axis.horizontal,
                            count: 15,
                            dashedWidth: 3,
                            dashedHeight: 1,
                            color: context.isBrightness
                                ? Colour.FFE8E8E8
                                : Colour.c1AFFFFFF,
                          )),
                      SizedBox(
                        height: 9.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            ImageHelper.wrapAssets('icon_money.svg'),
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                            '${packageItem.price}',
                            style: TextStyle(
                              color: Colour.FFF25643,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
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
                      // ?
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
        // Divider(
        //   // color: Color(0xffeeeeee),
        //   indent: 36.w,
        // ),
        // InkWell(
        //   onTap: () async {},
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
        //           SvgPicture.asset(
        //             !true
        //                 ? ImageHelper.wrapAssets("phone_radio_selected.svg")
        //                 : context.isBrightness
        //                     ? ImageHelper.wrapAssets(
        //                         "phone_radio_unselected.svg")
        //                     : ImageHelper.wrapAssets(
        //                         "phone_radio_unselected_dark.svg"),
        //           )
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
            accRepo.unifyLoginResult!.perNumberList[0].outerNumber!,
            "osinfo",
            productItem.transactionId.toString(),
            productItem.transactionReceipt.toString(),
            _xPackageListMode.getCheckItem()!.appgoodid.toString(),
            (_xPackageListMode.getCheckItem()!.price * 100).toInt(),
            orderid,
            '3',
            '',
            '');
        EasyLoading.dismiss();
        await FlutterInappPurchase.instance.finishTransaction(productItem);
        if (result) {
          // _purchaseUpdatedSubscription = null;
          // _purchaseErrorSubscription.cancel();
          // _purchaseErrorSubscription = null;
          xPayViewModel.wxPayResult.value = true;
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return NoticeChargeResultPage(
              true,
              _xPackageListMode.getCheckItem()!,
            );
          }));
        } else {
          xPayViewModel.wxPayResult.value = false;
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return NoticeChargeResultPage(
              false,
              _xPackageListMode.getCheckItem()!,
            );
          }));
        }
      }
      // isPaying = false;
      print('purchase-updated: $productItem');
    });
    // 购买报错订阅消息
    // _purchaseErrorSubscription =
    FlutterInappPurchase.purchaseError.listen((purchaseError) {
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
