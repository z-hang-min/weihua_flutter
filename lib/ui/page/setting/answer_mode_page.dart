import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/config/storage_manager.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/ui/page/login/login_model.dart';
import 'package:weihua_flutter/ui/page/setting/answer_mode.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

const String kAnswerModeApp = 'kAnswerModeApp';

class AnswerModePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AnswerModePageState();
}

bool _checkFirst =
    StorageManager.sharedPreferences!.getBool(kAnswerModeApp) ?? true;

class _AnswerModePageState extends State<AnswerModePage> {
  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle caption = textTheme.caption!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(S.of(context).answerMode),
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(
                Theme.of(context).brightness == Brightness.light
                    ? "nav_icon_return.svg"
                    : "nav_icon_return_sel.svg")),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: ProviderWidget(
            model: new AnswerMode(),
            onModelReady: (AnswerMode model) async {
              _checkFirst = await model.queryTransfer(
                  accRepo.ownerId, accRepo.outerNumberId);
              if (_checkFirst == false) {
                // model.showErrorMessage(context);
                EasyLoading.dismiss();
              }
            },
            builder: (context, AnswerMode model, child) {
              if (model.isBusy) {
                EasyLoading.show();
              }
              if (model.isIdle) {
                EasyLoading.dismiss();
              }
              return Column(
                children: [
                  Ink(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      color: Theme.of(context).cardColor,
                    ),
                    child: InkWell(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        height: 88,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).answer_mode1, style: subtitle1),
                            Image.asset(
                              _checkFirst
                                  ? ImageHelper.wrapAssets(
                                      "phone_radio_selected.png")
                                  : ImageHelper.wrapAssets(
                                      "phone_radio_unselected.png"),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _checkFirst = !_checkFirst;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Ink(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      color: Theme.of(context).cardColor,
                    ),
                    child: InkWell(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        height: 88,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(S.of(context).answer_mode2,
                                        style: subtitle1),
                                    Text(
                                        "(${StorageManager.sharedPreferences!.getString(kLoginPhone)})",
                                        style: caption.change(context,
                                            color: Colour.hintTextColor,
                                            fontSize: 13)),
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(S.of(context).answer_mode2_tip,
                                    style: caption.change(context,
                                        color: Colour.hintTextColor)),
                              ],
                            ),
                            Image.asset(
                              _checkFirst
                                  ? ImageHelper.wrapAssets(
                                      "phone_radio_unselected.png")
                                  : ImageHelper.wrapAssets(
                                      "phone_radio_selected.png"),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _checkFirst = !_checkFirst;
                        });
                      },
                    ),
                  ),
                  Expanded(flex: 1, child: Container()),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: TextButton(
                      onPressed: () async {
                        bool result = await model.updateTransfer(
                            Provider.of<UserModel>(context, listen: false)
                                .user!
                                .innerNumberId!,
                            Provider.of<UserModel>(context, listen: false)
                                .user!
                                .outerNumberId,
                            _checkFirst ? 0 : 1);
                        Log.d("result:$result");
                        if (!ishavenet) {
                          showToast(S.of(context).viewStateMessageNetworkError);
                        } else {
                          if (result == true) {
                            showToast("保存成功");
                            Navigator.of(context).pop(_checkFirst);
                          } else {
                            showToast("保存失败");
                          }
                        }
                      },
                      child: Text(
                        S.of(context).save,
                        style: Theme.of(context).textTheme.button,
                      ),
                      style: ButtonStyle(
                        //设置按钮的大小
                        minimumSize: MaterialStateProperty.all(
                            Size(double.infinity, 50)),
                        //背景颜色

                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          //设置按下时的背景颜色
                          if (states.contains(MaterialState.pressed)) {
                            return Colour.f0F8FFB.withAlpha(400);
                          }
                          //默认不使用背景颜色
                          return Colour.f0F8FFB;
                        }),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 34,
                  ),
                ],
              );
            }),
      ),
    );
  }
}
