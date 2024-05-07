import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/ui/page/workbench/enterprise_certification_model.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';

bool isupdatePic = false;
bool issuccess = true;
late String enterpriseName = "";
late String enterprisecreditcode = "";
late String enterpriselicense = "";
late String enterpriseContact = "";
late String enterprisemobile = "";
// late String enterprisetel= "";
List enterpriseinfo = [
  "businessName",
  "businessId",
  "businessLicense",
  "contactName",
  "tel"
];
List enterpriseinfoName = ["企业名称", "社会统一信用代码", "营业执照（加盖公章）", "联系人姓名", "联系人手机号"];
List enterpriseinfoInfo = [
  "请输入企业名称",
  "请输入社会统一信用代码",
  "请输入营业执照（加盖公章）",
  "请输入联系人姓名",
  "请输入联系人手机号"
];
late EnterPriseCertificationMode menterprisemodel;

class EnterpriseCertificationPage extends StatefulWidget {
  // dynamic? enterCerRsult;
  final String? bussId;

  EnterpriseCertificationPage(this.bussId);
  @override
  _EnterpriseCertificationPageState createState() =>
      _EnterpriseCertificationPageState();
}

class _EnterpriseCertificationPageState
    extends State<EnterpriseCertificationPage>
    with AutomaticKeepAliveClientMixin {
  var _imgPath;
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    enterpriseName = "";
    enterprisecreditcode = "";
    enterpriselicense = "";
    enterpriseContact = "";
    enterprisemobile = "";
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text("企业认证",
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colour.cFF212121
                      : Colour.fffffff.withAlpha(87))),
          leading: new IconButton(
              icon: SvgPicture.asset(ImageHelper.wrapAssets(
                  Theme.of(context).brightness == Brightness.light
                      ? "nav_icon_return.svg"
                      : "nav_icon_return_sel.svg")),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ProviderWidget(
            model: new EnterPriseCertificationMode(),
            onModelReady: (EnterPriseCertificationMode model) async {
              menterprisemodel = model;
              if (widget.bussId != "") {
                model.getenterpriseCertification(widget.bussId!);
              }
            },
            builder: (context, EnterPriseCertificationMode model, child) {
              if (model.isBusy) {
                EasyLoading.show();
              }
              if (model.isIdle) {
                EasyLoading.dismiss();
              }
              return Column(
                children: [
                  model.enterCerRsult == null
                      ? Text("")
                      : (model.enterCerRsult!.item!.remarks == '' ||
                              model.enterCerRsult!.item!.remarks == null)
                          ? Text("")
                          : Container(
                              width: 375.w,
                              height: 70.h,
                              padding: EdgeInsets.all(0),
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Color.fromRGBO(247, 235, 233, 1.0)
                                  : Colour.c0xFF7C2B2A,
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(16.w, 0, 0, 0),
                                    child: SvgPicture.asset(
                                      ImageHelper.wrapAssets(Theme.of(context)
                                                  .brightness ==
                                              Brightness.light
                                          ? "icon_certification_tishi.svg"
                                          : 'icon_certification_tishi_dark.svg'),
                                    ),
                                  ),
                                  SizedBox(width: 15.w),
                                  Container(
                                      width: 308.w,
                                      height: 50.h,
                                      child: Text(
                                        "认证失败，${model.enterCerRsult!.item!.remarks}，请更改后 重新提交，如有疑问，请联系客服950138008",
                                        style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colour.cFF666666
                                              : Colour.fffffff.withAlpha(87),
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.left,
                                      ))
                                ],
                              )),
                  SizedBox(height: 10.h),
                  GestureDetector(
                      // 触摸收起键盘
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Container(
                          height: model.enterCerRsult == null
                              ? 600.h
                              : (model.enterCerRsult!.item!.remarks == '' ||
                                      model.enterCerRsult!.item!.remarks ==
                                          null)
                                  ? 600.h
                                  : 550.h,
                          child: Scaffold(
                              body: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return _cellForRow(context, index);
                                  })))),
                  Container(
                    padding: EdgeInsets.all(15.h),
                    child: TextButton(
                      onPressed: () async {
                        if (enterpriseName == "" ||
                            enterprisecreditcode == "" ||
                            enterpriselicense == "" ||
                            enterpriseContact == "" ||
                            enterprisemobile == "") {
                          showToast("请将信息补全再提交");
                        } else {
                          if (model.enterCerRsult != null) {
                            if (enterpriseName ==
                                    model.enterCerRsult!.item!.businessName &&
                                enterprisecreditcode ==
                                    model.enterCerRsult!.item!.businessId &&
                                enterpriseContact ==
                                    model.enterCerRsult!.item!.contactName &&
                                enterprisemobile ==
                                    model.enterCerRsult!.item!.contactMobile) {
                              Navigator.pushNamed(
                                  context, RouteName.certificationSuccessPage);
                            } else {
                              bool enterpriseResult =
                                  await model.updateEnterpriseCertification(
                                      enterpriseName,
                                      enterprisecreditcode,
                                      enterpriselicense,
                                      enterpriseContact,
                                      enterprisemobile,
                                      accRepo.user!.mobile!,
                                      model.enterCerRsult == null ? "0" : "1");
                              if (model.isBusy) {
                                EasyLoading.show();
                              }
                              if (model.isIdle) {
                                if (enterpriseResult == true) {
                                  Navigator.pushNamed(context,
                                      RouteName.certificationSuccessPage);
                                } else {
                                  showToast("提交失败");
                                }
                                EasyLoading.dismiss();
                              }
                            }
                          } else {
                            bool enterpriseResult =
                                await model.updateEnterpriseCertification(
                                    enterpriseName,
                                    enterprisecreditcode,
                                    enterpriselicense,
                                    enterpriseContact,
                                    enterprisemobile,
                                    accRepo.user!.mobile!,
                                    "0");
                            if (model.isBusy) {
                              EasyLoading.show();
                            }
                            if (model.isIdle) {
                              if (enterpriseResult == true) {
                                Navigator.pushNamed(context,
                                    RouteName.certificationSuccessPage);
                              } else {
                                showToast("提交失败");
                              }
                              EasyLoading.dismiss();
                            }
                          }
                        }
                      },
                      child: Text(
                        "提交",
                        // style: subtitle1.change(context, color: Colour.fEE4452),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ButtonStyle(
                        //设置按钮的大小
                        minimumSize: MaterialStateProperty.all(
                            Size(double.infinity, 50.w)),
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
                ],
              );
            }));
  }

  Map<String, TextEditingController> textCtrlList = {};

  Widget _cellForRow(BuildContext context, int index) {
    String enterprisetext = "";
    if (menterprisemodel.enterCerRsult != null) {
      if (index == 0) {
        enterprisetext = menterprisemodel.enterCerRsult!.item!.businessName!;
        enterpriseName = enterprisetext;
      } else if (index == 1) {
        enterprisetext = menterprisemodel.enterCerRsult!.item!.businessId!;
        enterprisecreditcode = enterprisetext;
      } else if (index == 2) {
        enterprisetext = menterprisemodel.enterCerRsult!.item!.businessLicense!;
        enterpriselicense = enterprisetext;
      } else if (index == 3) {
        enterprisetext = menterprisemodel.enterCerRsult!.item!.contactName!;
        enterpriseContact = enterprisetext;
      } else if (index == 4) {
        enterprisetext = menterprisemodel.enterCerRsult!.item!.contactMobile!;
        enterprisemobile = enterprisetext;
      }
    }

    var infoCtrl = textCtrlList[index.toString()];

    if (infoCtrl == null) {
      infoCtrl = TextEditingController(text: enterprisetext);
      textCtrlList[index.toString()] = infoCtrl;
    } else {
      infoCtrl.text = enterprisetext;
    }

    return index == 2
        ? (isupdatePic
            ? _hanvecertification(context)
            : _nocertification(context))
        : Container(
            width: 375.w,
            height: 125.h,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Text(
                    enterpriseinfoName[index],
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colour.FF333333
                            : Colour.fffffff,
                        fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                  width: 355.w,
                ),
                SizedBox(height: 15.h),
                getcellc(context, index, infoCtrl),
              ],
            ));
  }

  Widget getcellc(
      BuildContext context, int index, TextEditingController infoCtrl) {
    return Container(
        width: 355.w,
        height: 58.h,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colour.f1A1A1A,
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
        child: TextField(
          controller: infoCtrl,
          textAlign: TextAlign.start,
          maxLines: 1,
          maxLength: index == 0
              ? 30
              : index == 3
                  ? 20
                  : 100,
          autocorrect: true,
          autofocus: false,
          cursorColor: context.isBrightness
              ? Theme.of(context).primaryColor
              : Colors.white,
          decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(0, 15.h, 0, 15.h),
            counterText: "",
            hintText: enterpriseinfoInfo[index],
            // labelText: widget.enterCerRsult!.businessName,
            hintStyle: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colour.cFF999999
                    : Colour.fffffff.withAlpha(38)),
          ),
          keyboardType: TextInputType.text,
          onChanged: (text) {
            if (index == 0) {
              enterpriseName = text;
            } else if (index == 1) {
              enterprisecreditcode = text;
            }
            //  else if(index == 3){
            //   enterpriselicense = text;}
            else if (index == 3) {
              enterpriseContact = text;
            } else if (index == 4) {
              enterprisemobile = text;
            }
            // else if(index == 6){enterprisetel = text;}
          },
          onEditingComplete: () {},
        ));
  }

  Widget _nocertification(BuildContext context) {
    return Container(
        width: 375.w,
        height: 400.h,
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(left: 10.w),
            child: Text(
              "营业执照（加盖公章）",
              style: TextStyle(color: Colour.FF333333, fontSize: 16),
              textAlign: TextAlign.left,
            ),
            width: 355.w,
          ),
          SizedBox(height: 15.h),
          _enterpriseImageWidget(context),
        ]));
  }

  Widget _enterpriseImageWidget(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Container(
      width: 355.w,
      height: 330.h,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colour.f1A1A1A,
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
      ),
      // padding: EdgeInsets.fromLTRB(10.w, 15.h, 10.w, 0),
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20.w, 30.w, 0, 0),
              width: 178.w,
              height: 130.w,
              child: InkWell(
                  child: menterprisemodel.enterpriseImageurl == ""
                      ? menterprisemodel.enterCerRsult == null
                          ? Image.asset(ImageHelper.wrapAssets(
                              'business_license_default.png'))
                          : menterprisemodel
                                      .enterCerRsult!.item!.businessLicense ==
                                  ""
                              ? Image.asset(ImageHelper.wrapAssets(
                                  'business_license_default.png'))
                              : Image.network(
                                  menterprisemodel
                                      .enterCerRsult!.item!.businessLicense!,
                                  fit: BoxFit.contain)
                      : Image.network(menterprisemodel.enterpriseImageurl,
                          fit: BoxFit.contain),
                  onTap: () async {
                    // var image = await ImagePicker()
                    //     .pickImage(source: ImageSource.camera);
                    // setState(() {
                    //   _imgPath = image;
                    // });
                  }),
            ),
            SizedBox(height: 20.w),
            Container(
                padding: EdgeInsets.fromLTRB(27.w, 0, 27.w, 0),
                child: Text(
                  "证件必须完整清晰且在有效期内，大小不超过5M (若已办理三证合一，请上传最新的营业执照)",
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colour.cFF999999
                          : Colour.fffffff.withAlpha(60)),
                )),
            Container(
                padding: EdgeInsets.fromLTRB(30.w, 0.w, 0, 0),
                child: TextButton(
                  child: Text(
                    "拍照/上传照片",
                    style: TextStyle(fontSize: 16, color: Colour.f0F8FFB),
                  ),
                  style: ButtonStyle(
                    //设置按钮的大小
                    minimumSize: MaterialStateProperty.all(Size(104.w, 2.w)),
                    //背景颜色
                    side: MaterialStateProperty.all(
                      BorderSide(color: Colour.f0F8FFB, width: 0.5),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isDismissible: true,
                        isScrollControlled: false,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) {
                          return Ink(
                            height: 188.h,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  child: Container(
                                    height: 58.h,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "拍照",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: (context.isBrightness
                                              ? Colour.titleColor
                                              : Colour.fDEffffff)),
                                    ),
                                  ),
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    var image = await ImagePicker()
                                        .pickImage(source: ImageSource.camera);
                                    setState(() {
                                      _imgPath = image;
                                    });
                                    if (_imgPath != null) {
                                      bool result = await menterprisemodel
                                          .uploadImage(_imgPath.path);
                                      if (result) {
                                      } else {
                                        menterprisemodel
                                            .showErrorMessage(context);
                                        EasyLoading.dismiss();
                                      }
                                      enterpriselicense =
                                          menterprisemodel.enterpriseImageurl;
                                    }
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  endIndent: 15,
                                  indent: 15,
                                  color: !context.isBrightness
                                      ? Colour.c1AFFFFFF
                                      : Colour.cffE6E6E6,
                                ),
                                InkWell(
                                  child: Container(
                                    height: 58.h,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "从手机相册选择",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: (context.isBrightness
                                              ? Colour.titleColor
                                              : Colour.fDEffffff)),
                                    ),
                                  ),
                                  onTap: () async {
                                    Navigator.of(context).pop();
                                    var image = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    setState(() {
                                      _imgPath = image;
                                    });
                                    if (_imgPath != null) {
                                      EasyLoading.show();
                                      bool result = await menterprisemodel
                                          .uploadImage(_imgPath.path);
                                      if (result) {
                                      } else {
                                        menterprisemodel
                                            .showErrorMessage(context);
                                        EasyLoading.dismiss();
                                      }
                                      enterpriselicense =
                                          menterprisemodel.enterpriseImageurl;
                                    }
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  endIndent: 15,
                                  indent: 15,
                                  color: !context.isBrightness
                                      ? Colour.c1AFFFFFF
                                      : Colour.cffE6E6E6,
                                ),
                                Container(
                                  height: 10.h,
                                  color: !context.isBrightness
                                      ? Colour.cFF1E1E1E
                                      : Colour.cFFF7F8F9,
                                ),
                                InkWell(
                                  child: Container(
                                    child: Text(
                                      "取消",
                                      style: subtitle1,
                                    ),
                                    height: 58.h,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                            ),
                          );
                        });
                  },
                ))
          ],
        ),
      ),
    );
  }

  Widget _hanvecertification(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Container(
        height: 228.h,
        child: Column(children: [
          SizedBox(width: 15.w),
          Text(
            "营业执照（加盖公章）",
            textAlign: TextAlign.left,
            style: TextStyle(color: Colour.FF333333, fontSize: 16),
          ),
          SizedBox(height: 15.h),
          Container(
              width: 355.w,
              height: 176.h,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colour.f1A1A1A,
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
              ),
              padding: EdgeInsets.fromLTRB(10.w, 15.h, 10.w, 0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15.w),
                    child: SvgPicture.asset(
                        ImageHelper.wrapAssets("nav_icon_return_sel.svg")),
                  ),
                  SizedBox(width: 20.w),
                  Container(
                      padding: EdgeInsets.only(top: 100.h),
                      child: Column(
                        children: [
                          InkWell(
                              child: Text(
                                "更改",
                                style: TextStyle(color: Colour.FF167AFF),
                              ),
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    isDismissible: true,
                                    isScrollControlled: false,
                                    backgroundColor: Colors.transparent,
                                    builder: (BuildContext context) {
                                      return Ink(
                                        height: 174.h,
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              child: Container(
                                                height: 58.h,
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "拍照",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: (context
                                                              .isBrightness
                                                          ? Colour.titleColor
                                                          : Colour.fDEffffff)),
                                                ),
                                              ),
                                              onTap: () async {
                                                var image = await ImagePicker()
                                                    .pickImage(
                                                        source:
                                                            ImageSource.camera);
                                                setState(() {
                                                  _imgPath = image;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            Divider(
                                              height: 1,
                                              endIndent: 15,
                                              indent: 15,
                                              color: !context.isBrightness
                                                  ? Colour.c1AFFFFFF
                                                  : Colour.cffE6E6E6,
                                            ),
                                            InkWell(
                                              child: Container(
                                                height: 58.h,
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "从手机相册选择",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: (context
                                                              .isBrightness
                                                          ? Colour.titleColor
                                                          : Colour.fDEffffff)),
                                                ),
                                              ),
                                              onTap: () async {
                                                var image = await ImagePicker()
                                                    .pickImage(
                                                        source: ImageSource
                                                            .gallery);
                                                setState(() {
                                                  _imgPath = image;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            Divider(
                                              height: 1,
                                              endIndent: 15,
                                              indent: 15,
                                              color: !context.isBrightness
                                                  ? Colour.c1AFFFFFF
                                                  : Colour.cffE6E6E6,
                                            ),
                                            Container(
                                              height: 10.h,
                                              color: !context.isBrightness
                                                  ? Colour.cFF1E1E1E
                                                  : Colour.cFFF7F8F9,
                                            ),
                                            InkWell(
                                              child: Container(
                                                child: Text(
                                                  "取消",
                                                  style: subtitle1,
                                                ),
                                                height: 58.h,
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            topRight: Radius.circular(25),
                                          ),
                                        ),
                                      );
                                    });
                              }),
                          SizedBox(height: 0.5),
                          Divider(
                            height: 1,
                            endIndent: 20.w,
                            indent: 80.w,
                            color: Colour.FF167AFF,
                          ),
                        ],
                      ))
                ],
              ))
        ]));
  }
}
