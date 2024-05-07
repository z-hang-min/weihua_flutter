import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/model/extension_result.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/ui/helper/share_helper.dart';
import 'package:weihua_flutter/ui/page/contact/search_listview.dart';
import 'package:weihua_flutter/ui/page/workbench/extension_model.dart';
import 'package:weihua_flutter/ui/page/workbench/viewmodel/renew_extension_num_mode.dart';
import 'package:weihua_flutter/ui/page/workbench/viewmodel/share_msg_mode.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluwx/fluwx.dart';
import 'package:get/get.dart';

///
/// @Desc: 分机管理
///
/// @Author: zhx
///
/// @Date: 21/7/21
///

class ExtensionmanagementPage extends StatefulWidget {
  @override
  _ExtensionmanagementPageState createState() =>
      _ExtensionmanagementPageState();
}

class _ExtensionmanagementPageState extends State<ExtensionmanagementPage> {
  late ExtensionInfoMode extensionmodel;
  XShareMsgMode shareMsgMode = XShareMsgMode();
  XRenewExtensionNumMode _xRenewExtensionNumMode =
      Get.put(XRenewExtensionNumMode());

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    weChatResponseEventHandler.listen((res) {
      if (res is WeChatShareResponse) {
        // if (res.isSuccessful) Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text("分机管理"),
          leading: new IconButton(
              icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                  ? "nav_icon_return.svg"
                  : "nav_icon_return_sel.svg")),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: _buildGroupTableView(context));
  }

  Widget _buildGroupTableView(BuildContext context) {
    return ProviderWidget(
        model: new ExtensionInfoMode(),
        onModelReady: (ExtensionInfoMode model) async {
          extensionmodel = model;
          model
              .getextensionmanagementInfo(accRepo.user!.outerNumber.toString());
        },
        builder: (context, ExtensionInfoMode model, child) {
          if (model.isBusy) {
            EasyLoading.show();
          }
          if (model.isIdle) {
            EasyLoading.dismiss();
          }
          return model.extensionRsult == null
              ? Text('')
              : Container(
                  width: 375.w,
                  height: 726.h,
                  padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: GroupTableView(
                      style: ViewStyle.plain,
                      itemBuilder: _buildListItem,
                      numberOfSections: model.extensionRsult!.length + 1,
                      numberOfRowsInSection: (int section) {
                        return section == 0
                            ? 0
                            : model.extensionRsult![section - 1].extensionInfo!
                                .length;
                      },
                      sectionFooterBuilder: (context, section) {
                        return Container(height: 0, child: Text(''));
                      },
                      sectionHeaderBuilder:
                          (BuildContext context, int section) {
                        return section == 0
                            ? Container(
                                decoration: BoxDecoration(
                                  color: context.isBrightness
                                      ? Colors.white
                                      : Colour.f1A1A1A,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0)),
                                ),
                                child: Column(children: [
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 30.h, 0, 30.h),
                                      child: Row(children: [
                                        Expanded(
                                          child: Column(children: [
                                            Text('分机总数',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.light
                                                        ? Colour.cFF666666
                                                        : Colors.white)),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: 150.w,
                                                      ),
                                                      child: Text(
                                                          model
                                                              .extensionRsult![
                                                                  0]
                                                              .total
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 30,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colour
                                                                      .cFF212121
                                                                  : Colors
                                                                      .white))),
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          top: 10.h),
                                                      child: Text('个',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colour
                                                                      .cFF666666
                                                                  : Colors
                                                                      .white)))
                                                ])
                                          ]),
                                        ),
                                        Container(
                                          width: 1,
                                          height: 50.h,
                                          color: context.isBrightness
                                              ? Colour.cFFEEEEEE
                                              : Colour.c1AFFFFFF,
                                        ),
                                        Expanded(
                                          child: Container(
                                              child: Column(children: [
                                            Text('剩余可用',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.light
                                                        ? Colour.cFF666666
                                                        : Colors.white)),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: 150.w,
                                                      ),
                                                      child: Text(
                                                          model
                                                              .extensionRsult![
                                                                  0]
                                                              .unused
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 30,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colour
                                                                      .FF0086F5
                                                                  : Colour
                                                                      .FF0086F5))),
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          top: 10.h),
                                                      child: Text('个',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? Colour
                                                                      .cFF666666
                                                                  : Colors
                                                                      .white)))
                                                ])
                                          ])),
                                        )
                                      ])),
                                  Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colour.FFFF8786,
                                            Colour.FFFF4F4E,
                                          ],
                                        ),
                                        borderRadius:
                                            new BorderRadius.circular((25.0))),
                                    child: TextButton(
                                      onPressed: () async {
                                        await Get.toNamed(
                                                RouteName.buyExNumPage)!
                                            .then((value) {
                                          getRequest();
                                        });
                                      },
                                      child: Text(
                                        '购买分机',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                        //设置按钮的大小
                                        minimumSize: MaterialStateProperty.all(
                                            Size(304.w, 40.h)),
                                        visualDensity: VisualDensity.compact,
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '分机用户可登录微话APP',
                                      style: TextStyle(
                                          color: context.isBrightness
                                              ? Colour.FF999999
                                              : Colour.FF565656,
                                          fontSize: 12),
                                    ),
                                    padding:
                                        EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
                                  )
                                ]))
                            : Container(
                                child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 18.h, 0, 13.h),
                                    child: Row(
                                      children: [
                                        Text(
                                            "到期时间：${model.extensionRsult![section - 1].extensionInfo![0].expiryDateForm}",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? Colour.f333333
                                                    : Colour.FF999999,
                                                fontSize: 14)),
                                        Spacer(),
                                        Container(
                                            padding:
                                                EdgeInsets.only(right: 0.w),
                                            child: model
                                                        .extensionRsult![
                                                            section - 1]
                                                        .extensionInfo![0]
                                                        .def ==
                                                    true
                                                ? Text('')
                                                : Container(
                                                    width: 60.w,
                                                    height: 24.w,
                                                    child: CupertinoButton(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13),
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      color: Colour.FFFF8E12,
                                                      disabledColor: Colour
                                                          .f0F8FFB
                                                          .withAlpha(100),
                                                      child: Text(
                                                        '续费',
                                                        style: TextStyle(
                                                            color:
                                                                Colour.fffffff,
                                                            fontSize: 14),
                                                      ),
                                                      onPressed: () async {
                                                        await _xRenewExtensionNumMode
                                                            .getWareInfo(
                                                                '${model.extensionRsult![section - 1].extensionInfo![0].expiryDate}',
                                                                '${model.extensionRsult![section - 1].extensionInfo![0].orderId}')
                                                            .then((value) {
                                                          if (value != null) {
                                                            Get.toNamed(
                                                                    RouteName
                                                                        .renewExNumPage,
                                                                    arguments: model
                                                                        .extensionRsult![
                                                                            section -
                                                                                1]
                                                                        .extensionInfo![0])!
                                                                .then((value) {
                                                              getRequest();
                                                            });
                                                          }
                                                        });
                                                        if (_xRenewExtensionNumMode
                                                            .isError) {
                                                          _xRenewExtensionNumMode
                                                              .showErrorMessage(
                                                                  context);
                                                        }
                                                      },
                                                    ),
                                                  ))
                                      ],
                                    )),
                              );
                      },
                    ),
                  ));
        });
  }

  Widget _buildListItem(BuildContext context, IndexPath indexPath) {
    ExtensionResult result =
        extensionmodel.extensionRsult![indexPath.section - 1];
    ExtensionInfo info = result.extensionInfo![indexPath.row];
    return Container(
        padding: EdgeInsets.fromLTRB(0.w, 5.h, 0.w, 5.h),
        child: Container(
            decoration: BoxDecoration(
              color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
            ),
            child: Row(children: [
              Container(
                padding: EdgeInsets.fromLTRB(15.w, 17.h, 15.w, 17.h),
                constraints: BoxConstraints(
                  maxWidth: 250.w,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                            constraints: BoxConstraints(
                              maxWidth: 160.w,
                            ),
                            child: Text(
                              info.status == 0
                                  ? ''
                                  : '${info.userName}-${info.number}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: context.isBrightness
                                      ? Colour.cFF212121
                                      : Colour.FF999999),
                            )),
                        SizedBox(width: info.status == 0 ? 0 : 12.w),
                        Container(
                            // padding: EdgeInsets.only(top: 1.h),
                            decoration: BoxDecoration(
                              color: context.isBrightness
                                  ? (info.status == 1 || info.number == '1000')
                                      ? Colour.FF0086F5
                                      : Colour.FF8AA0C2
                                  : (info.status == 1 || info.number == '1000')
                                      ? Colour.FF0086F5
                                      : Colour.FFFEE7E5.withAlpha(38),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.0)),
                            ),
                            height: 18.w,
                            width: 44.w,
                            child: (info.status == 1 || info.number == '1000')
                                ? CupertinoButton(
                                    padding: EdgeInsets.all(0),
                                    // color: Colour.FFFF8E12,
                                    disabledColor:
                                        Colour.f0F8FFB.withAlpha(100),
                                    onPressed: null,
                                    child: Text('已激活',
                                        style: TextStyle(
                                            color: Colour.fffffff,
                                            fontSize: 12)))
                                // Container(
                                //     padding: EdgeInsets.all(0),
                                //     child: Text("已激活",
                                //         style: TextStyle(
                                //             color: Colors.white,
                                //             fontSize: 12),
                                //         textAlign: TextAlign.center))
                                : CupertinoButton(
                                    padding: EdgeInsets.all(0),
                                    // color: Colour.FFFF8E12,
                                    disabledColor:
                                        Colour.f0F8FFB.withAlpha(100),
                                    onPressed: null,
                                    child: Text(
                                        info.status == 0 ? '未使用' : "未激活",
                                        style: TextStyle(
                                            color: Colour.fffffff,
                                            fontSize: 12)))),
                        // Container(
                        //     padding: EdgeInsets.all(1.w),
                        //     child: Text(info.status == 0?'未使用':"未激活",
                        //         style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 12),
                        //         textAlign: TextAlign.center))),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      child: Text(
                        '绑定手机 ${info.mobile}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: context.isBrightness
                                ? Colour.cFF666666
                                : Colour.FF999999,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              // Container(
              //     padding: EdgeInsets.fromLTRB(0, 34.h, 0.w, 34.h),
              //     child: Row(
              //       children: [
              Opacity(
                  opacity: info.status == 2 ? 1.0 : 0.0,
                  child: InkWell(
                    child: Container(
                        padding: EdgeInsets.all(10.w),
                        child: SvgPicture.asset(
                          ImageHelper.wrapAssets(context.isBrightness
                              ? "extension_share.svg"
                              : "extension_share_dark.svg"),
                        )),
                    onTap: () {
                      shareMsgMode.getShareMsg('${info.oid!}').then((value) {
                        showModalBottomSheet(
                            context: context,
                            isDismissible: true,
                            isScrollControlled: false,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return Container(
                                  height: 258.h,
                                  decoration: BoxDecoration(
                                    color: context.isBrightness
                                        ? Colors.white
                                        : Colour.cFF2c2c2c,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    ),
                                  ),
                                  child: Container(
                                      child: Column(children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(top: 20.w),
                                      child: Text("分享",
                                          style: TextStyle(
                                              color: context.isBrightness
                                                  ? Colour.cFF666666
                                                  : Colour.fffffff,
                                              fontSize: 14)),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  ShareHelper.shareToSms(
                                                      context,
                                                      shareMsgMode.shareMsg
                                                          .value.contentSms);
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  child: SvgPicture.asset(
                                                    ImageHelper.wrapAssets(Theme
                                                                    .of(context)
                                                                .brightness ==
                                                            Brightness.light
                                                        ? "share_message.svg"
                                                        : "share_message_dark.svg"),
                                                  ),
                                                  // margin: EdgeInsets.all(20.h),

                                                  margin: EdgeInsets.all(5.h),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  ShareHelper.doWeChatShare(
                                                      context,
                                                      shareMsgMode
                                                          .shareMsg.value);
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  child: SvgPicture.asset(
                                                    ImageHelper.wrapAssets(Theme
                                                                    .of(context)
                                                                .brightness ==
                                                            Brightness.light
                                                        ? "share_wechat.svg"
                                                        : "share_wechat_dark.svg"),
                                                  ),
                                                  // margin: EdgeInsets.all(20.h),

                                                  margin: EdgeInsets.all(5.h),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                        child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Center(
                                            child: Text("短信",
                                                style: TextStyle(
                                                    color: context.isBrightness
                                                        ? Colour.f333333
                                                        : Colour.FF999999,
                                                    fontSize: 14)),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text("微信好友",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.light
                                                        ? Colour.f333333
                                                        : Colour.FF999999,
                                                    fontSize: 14)),
                                          ),
                                        ),
                                      ],
                                    )),
                                    SizedBox(height: 40.h),
                                    OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: Size(345.w, 50.h),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          side: BorderSide(
                                              width: 0.5,
                                              color: context.isBrightness
                                                  ? Colour.cFFEEEEEE
                                                  : Colour.c1AFFFFFF),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          '取消',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: context.isBrightness
                                                  ? Colour.FF333333
                                                  : Colour.fffffff),
                                        ))
                                  ])));
                            });
                      });
                    },
                  )),
              InkWell(
                  child: Container(
                      padding: EdgeInsets.all(10.w),
                      child: SvgPicture.asset(
                        ImageHelper.wrapAssets(context.isBrightness
                            ? "enterpriseinfo_edit.svg"
                            : "enterpriseinfo_edit_dark.svg"),
                      )),
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.extensioneditPage,
                            arguments: info)
                        .then((value) {
                      getRequest();
                    });
                  })
            ])));
  }

  getRequest() async {
    await extensionmodel
        .getextensionmanagementInfo(accRepo.user!.outerNumber.toString());
  }
}
