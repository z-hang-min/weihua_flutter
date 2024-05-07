import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/model/user.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/home_enterprise_address_model.dart';
import 'package:weihua_flutter/ui/page/setting/query_info_mode.dart';
import 'package:weihua_flutter/ui/page/workbench/enterprise_certification_model.dart';
import 'package:weihua_flutter/utils/time_util.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

String? tel;
String? businessName;
// String? businessId;
String? businessLicense;
String? contactName;
String? contactMobile;
String? remarks;
int? status;
String? reviewer;
int? createTime;
int? updateTime;
String? numberType = "";
List enterpriseinfoName = [
  "企业名称",
  "社会统一信用代码",
  "营业执照（加盖公章）",
  "联系人姓名",
  "联系人手机号",
  "认证时间"
];
// List enterpriseinfoKey = ["businessName", "businessLicense", "businessId", "contactName", "tel","createTime"];
QueryInfoMode? queryInfoModel;
EnterPriseCertificationMode? menterprisemodel;
String? changeValue;

class EnterpriseMoreInfoPage extends StatefulWidget {
  final String businessid;

  EnterpriseMoreInfoPage(this.businessid);

  @override
  _EnterpriseMoreInfoPageState createState() => _EnterpriseMoreInfoPageState();
}

class _EnterpriseMoreInfoPageState extends State<EnterpriseMoreInfoPage> {
  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            "企业信息",
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colour.cFF212121
                    : Colour.fffffff.withAlpha(87)),
          ),
          leading: new IconButton(
              icon: SvgPicture.asset(ImageHelper.wrapAssets(
                  Theme.of(context).brightness == Brightness.light
                      ? "nav_icon_return.svg"
                      : "nav_icon_return_sel.svg")),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ProviderWidget2<EnterPriseCertificationMode, QueryInfoMode>(
            model1: EnterPriseCertificationMode(),
            model2: QueryInfoMode(Provider.of<UserModel>(context),
                homeBusinessContactModel: Provider.of<HomeBusinessContactModel>(
                    context,
                    listen: false)),
            onModelReady: (EnterPriseCertificationMode model1,
                QueryInfoMode model2) async {
              menterprisemodel = model1;
              queryInfoModel = model2;

              numberType = accRepo.user!.numberType.toString();
              if (widget.businessid != "null") {
                model1.getenterpriseCertification(widget.businessid);
              }
            },
            builder: (context, model1, model2, child) {
              if (model1.isBusy) {
                EasyLoading.show();
              }

              if (model1.isIdle) {
                EasyLoading.dismiss();
              }
              return Container(
                  padding: EdgeInsets.fromLTRB(10.w, 10.w, 0.w, 5.w),
                  width: 365.w,
                  height: 710.h,
                  child: Column(children: [
                    _enterprisename(
                        context, "显示名称", accRepo.user!.customName.toString()),
                    SizedBox(height: 10.h),
                    _enterprisename(
                        context, "公司地址", accRepo.user!.address!.toString()),
                    SizedBox(height: 10.h),
                    // (numberType == "1" && widget.businessid == "")
                    //     ? _noenterprise(context)
                    //     :
                    _hanveEnterprise(context),
                  ]));
            }));
  }

  Widget _enterprisename(BuildContext context, String title, String info) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colour.f1A1A1A,
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        child: Row(children: [
          SizedBox(width: 15.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: subtitle2.change(context,
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colour.hintTextColor
                        : Colour.fffffff.withAlpha(60)),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                info,
                style: subtitle1.change(context,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colour.f18
                        : Colour.fffffff.withAlpha(87)),
              ),
            ],
          ),
          SizedBox(height: 50.w),
          Spacer(),
          accRepo.user!.admin == 0
              ? Text("")
              : InkWell(
                  child: Container(
                      padding: EdgeInsets.only(right: 18.w),
                      child: SvgPicture.asset(
                        ImageHelper.wrapAssets("enterpriseinfo_edit.svg"),
                      )),
                  onTap: () {
                    if (title == '显示名称') {
                      showcenterDialog("公司名称", "请输入公司名称");
                    } else {
                      showcenterDialog("公司地址", "请输入公司地址");
                    }
                  },
                )
        ]),
        height: 87.h);
  }

  showcenterDialog(String title, String info) {
    //Future类型,then或者await获取
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
              title: Text(
                title,
                style: TextStyle(color: Colour.FF333333, fontSize: 18),
              ),
              content: Column(
                children: [
                  CupertinoTextField(
                    placeholder: info,
                    onChanged: (value) {
                      changeValue = value;
                    },
                  )
                ],
              ),
              actions: [
                CupertinoDialogAction(
                    child: Text("取消"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                CupertinoDialogAction(
                  child: Text("确定"),
                  onPressed: () async {
                    if (menterprisemodel == null) {
                    } else {
                      if (title == "公司名称") {
                        await menterprisemodel!.setEnterNameAddress(
                            accRepo.user!.outerNumber.toString(),
                            changeValue!,
                            "");
                      } else {
                        await menterprisemodel!.setEnterNameAddress(
                            accRepo.user!.outerNumber.toString(),
                            "",
                            changeValue!);
                      }
                      await queryInfoModel!.checkLogin();
                      List<User> unifyLoginList =
                          Provider.of<UserModel>(context, listen: false)
                              .unifyLoginResult
                              .numberList;
                      for (int i = 0; i < unifyLoginList.length; i++) {
                        if (unifyLoginList[i].outerNumber ==
                            accRepo.user!.outerNumber) {
                          Provider.of<UserModel>(context, listen: false)
                              .saveUser(unifyLoginList[i]);
                        }
                      }
                    }

                    Navigator.pop(context);
                  },
                )
              ]);
        }).then((value) {
      print("$value");
    });
  }

  // Widget _noenterprise(BuildContext context) {
  //   return Container(
  //       width: 365.w,
  //       height: 479.h,
  //       decoration: BoxDecoration(
  //         color: Theme.of(context).brightness == Brightness.light
  //             ? Colors.white
  //             : Colour.f1A1A1A,
  //         borderRadius: BorderRadius.all(Radius.circular(6.0)),
  //       ),
  //       child: Column(children: [
  //         SizedBox(height: 56.h),
  //         Text("欢迎进行企业认证", style: TextStyle(color: Colors.black, fontSize: 24)),
  //         SizedBox(height: 5.h),
  //         Text("企业认证成功后，开启专属企业服务!",
  //             style: TextStyle(color: Colour.cFF666666, fontSize: 14)),
  //         SizedBox(height: 38.h, width: 78.w),
  //         SvgPicture.asset(
  //             ImageHelper.wrapAssets("mange_icon_attestation.svg")),
  //         _attestationWidget(context),
  //       ]));
  // }

  Widget _hanveEnterprise(BuildContext context) {
    return Container(
        width: 365.w,
        height: 480.h,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colour.f1A1A1A,
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        child: Column(
          children: [
            SizedBox(height: 21.h),
            Row(
              children: [
                SizedBox(width: 14.w),
                Text("企业认证信息",
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colour.FF6B7685
                            : Colour.fffffff.withAlpha(87),
                        fontSize: 16)),
                SizedBox(width: 15.w),
                menterprisemodel!.enterCerRsult == null
                    ? Text("")
                    : menterprisemodel!.enterCerRsult!.item!.status == 1
                        ? Text("")
                        : menterprisemodel!.enterCerRsult!.item!.status == 2
                            ? Container(
                                padding: EdgeInsets.all(2.w),
                                color: Colour.FFFEE7E5,
                                width: 50.w,
                                height: 20.w,
                                child: Text(
                                  "未通过",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colour.FFF25643, fontSize: 12),
                                ))
                            : Container(
                                padding: EdgeInsets.all(2.w),
                                color: Color.fromRGBO(252, 173, 12, 0.1),
                                width: 50.w,
                                height: 20.w,
                                child: Text(
                                  "审核中",
                                  style: TextStyle(
                                      color: Colour.FFFCAD0C, fontSize: 12),
                                  textAlign: TextAlign.center,
                                )),
                SizedBox(width: 80.w),
                Spacer(),
                accRepo.user!.admin == 0
                    ? Text("")
                    : Container(
                        padding: EdgeInsets.only(right: 15.w),
                        child: TextButton(
                          child: Text(
                            "重新认证",
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colour.f0F8FFB
                                    : Colour.FF239BFF),
                          ),
                          style: ButtonStyle(
                            //设置按钮的大小
                            minimumSize:
                                MaterialStateProperty.all(Size(80.w, 26.w)),
                            //背景颜色
                            side: MaterialStateProperty.all(
                              BorderSide(color: Colour.f0F8FFB, width: 0.5),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          onPressed: () {
                            // if(menterprisemodel!.enterCerRsult!.status == 0){
                            //     showToast("企业正在审核中，暂时无法重新认证。");
                            // }else{
                            Navigator.pushNamed(
                                context, RouteName.certificationPage,
                                arguments: widget.businessid);
                            // }
                          },
                        )
                        // new OutlineButton(
                        //   borderSide: new BorderSide(color: Colour.FF239BFF),
                        //   child: new Text(
                        //     '重新认证',
                        //     style:
                        //         new TextStyle(color: Colour.FF239BFF, fontSize: 14),
                        //   ),
                        //   onPressed: () {},
                        // ),
                        // width: 100.w,
                        // height: 26.w,
                        )
              ],
            ),
            SizedBox(height: 12.h),
            Container(
                height: 380.h,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return _cellForRow(context, index);
                    }))
          ],
        ));
  }

  Widget _cellForRow(BuildContext context, int index) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    String enterPriseInfo = "";
    if (menterprisemodel!.enterCerRsult == null) {
    } else {
      if (index == 0) {
        enterPriseInfo =
            menterprisemodel!.enterCerRsult!.item!.businessName.toString();
      } else if (index == 1) {
        enterPriseInfo =
            menterprisemodel!.enterCerRsult!.item!.businessId.toString();
      } else if (index == 2) {
        enterPriseInfo =
            menterprisemodel!.enterCerRsult!.item!.businessLicense.toString();
      } else if (index == 3) {
        enterPriseInfo =
            menterprisemodel!.enterCerRsult!.item!.contactName.toString();
      } else if (index == 4) {
        enterPriseInfo =
            menterprisemodel!.enterCerRsult!.item!.contactMobile.toString();
      } else if (index == 5) {
        int? enterPriseInfos =
            menterprisemodel!.enterCerRsult!.item!.createTime;
        enterPriseInfo =
            TimeUtil.formatTime(enterPriseInfos!).toString().split(" ")[0];
      }
    }
    return index == 2
        ? Container(
            height: 128.h,
            child: Row(
              children: [
                SizedBox(width: 15.w),
                Text(
                  enterpriseinfoName[index],
                  style: Theme.of(context).brightness == Brightness.light
                      ? subtitle1.change(context, color: Colour.f18)
                      : TextStyle(
                          color: Colour.fffffff.withAlpha(60), fontSize: 16),
                ),
                Spacer(),
                InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return myHomePageWight(context, enterPriseInfo);
                      }));
                    },
                    child: Container(
                      width: 140.w,
                      height: 99.h,
                      child: Image.network(enterPriseInfo, fit: BoxFit.contain),
                      padding: EdgeInsets.only(right: 15.w),
                    ))
              ],
            ))
        : Container(
            height: 58.h,
            child: Column(
              children: [
                Row(children: [
                  SizedBox(width: 15.w),
                  Text(
                    enterpriseinfoName[index],
                    style: Theme.of(context).brightness == Brightness.light
                        ? subtitle1.change(context, color: Colour.f18)
                        : TextStyle(
                            color: Colour.fffffff.withAlpha(60), fontSize: 16),
                  ),
                  Spacer(),
                  Container(
                    child: Text(
                      enterPriseInfo,
                      style: Theme.of(context).brightness == Brightness.light
                          ? subtitle2.change(context,
                              fontSize: 14, color: Colour.f18)
                          : TextStyle(
                              color: Colour.fffffff.withAlpha(87),
                              fontSize: 16),
                    ),
                    padding: EdgeInsets.only(right: 15.w),
                  )
                ]),
                SizedBox(height: 16.h),
                Divider(
                  height: 1,
                  endIndent: 15,
                  indent: 15,
                  color: !context.isBrightness
                      ? Colour.c1AFFFFFF
                      : Colour.cffE6E6E6,
                ),
              ],
            ));
  }

  // Widget _attestationWidget(BuildContext context) {
  //   return TextButton(
  //     onPressed: () {
  //       Navigator.pushNamed(context, RouteName.certificationPage,
  //           arguments: '');
  //     },
  //     child: Text(
  //       "立即认证",
  //       // style: subtitle1.change(context, color: Colour.fEE4452),
  //       style: TextStyle(fontSize: 16, color: Colors.white),
  //     ),
  //     style: ButtonStyle(
  //       //设置按钮的大小
  //       minimumSize: MaterialStateProperty.all(Size(185.w, 50.w)),

  //       //背景颜色

  //       backgroundColor: MaterialStateProperty.resolveWith((states) {
  //         return Colour.c0x0F88FF;
  //       }),
  //       shape: MaterialStateProperty.all(
  //         RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(25),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget myHomePageWight(BuildContext context, String url) {
    return InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: ExtendedImageGesturePageView.builder(
          itemBuilder: (BuildContext context, int index) {
            var item = url;
            Widget image = ExtendedImage.network(
              item,
              fit: BoxFit.contain,
              mode: ExtendedImageMode.gesture,
            );
            image = Container(
              child: image,
              padding: EdgeInsets.all(5.0),
            );
            if (index == 0) {
              return Hero(
                tag: item + index.toString(),
                child: image,
              );
            } else {
              return image;
            }
          },
          itemCount: 1,
          // onPageChanged: (int index) {
          //   currentIndex = index;
          //   rebuild.add(index);
          // },
          controller: ExtendedPageController(
            initialPage: 0,
          ),
          scrollDirection: Axis.horizontal,
        ));
  }
}
