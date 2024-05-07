import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/model/check_update_result.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

///created by zm
///on 2021/3/26
///description:版本更新提示弹窗
class UpdateDialog extends Dialog {
  final CheckUpdateResult checkUpdateResult;

  UpdateDialog({required this.checkUpdateResult});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle headline6 = textTheme.headline6!;
    TextStyle bodyText2 = textTheme.bodyText2!;
    TextStyle button = textTheme.button!;
    return Center(
      child: Container(
        width: 300,
        height: 316,
        child: Stack(
          children: <Widget>[
            SvgPicture.asset(Theme.of(context).brightness == Brightness.light
                ? ImageHelper.wrapAssets('bg_pop_normal.svg')
                : ImageHelper.wrapAssets('bg_pop.svg')),
            Container(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 90, bottom: 6),
                    child: Text(
                      S.of(context).checkUpdate_title,
                      style: headline6.change(context, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "V${checkUpdateResult.version}",
                    style: bodyText2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 90,
                      margin: EdgeInsets.symmetric(horizontal: 33),
                      child: SingleChildScrollView(
                        child: Text(
                          descStr(checkUpdateResult.desc),
                          style: bodyText2,
                          textAlign: TextAlign.left,
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Container(
                    height: 40,
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: !(checkUpdateResult.forceUpdate),
                          child: TextButton(
                            child: Text(
                              S.of(context).actionCancel,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colour.f0F8FFB
                                      : Colour.fDEffffff),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colour.ffff4f5f.withAlpha(400);
                                }
                                return Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.white
                                    : Colors.transparent;
                              }),
                              minimumSize:
                                  MaterialStateProperty.all(Size(120, 40)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(23),
                                    side: BorderSide(
                                        width: 0.5,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colour.f0F8FFB
                                            : Colors.white)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colour.f0F8FFB.withAlpha(400);
                                }
                                return Colour.f0F8FFB;
                              }),
                              minimumSize:
                                  MaterialStateProperty.all(Size(120, 40)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(23),
                                ),
                              ),
                            ),
                            child: Text(
                              S.of(context).appUpdateActionUpdate,
                              style: button,
                            ),
                            onPressed: () {
                              launch(checkUpdateResult.downloadUrl!);
                              if (checkUpdateResult.forceUpdate) return;
                              Navigator.of(context).pop(true);
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static showUpdateDialog(
      BuildContext context, CheckUpdateResult checkUpdateResult) {
    return showDialog(
        barrierDismissible: !checkUpdateResult.forceUpdate,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            child: UpdateDialog(checkUpdateResult: checkUpdateResult),
            onWillPop: () async {
              return !checkUpdateResult.forceUpdate;
            },
          );
        });
  }

  static String descStr(List<String>? desclist) {
    String desc = "";
    desclist?.forEach((f) {
      desc = desc + f + "\n";
    });
    return desc;
  }
}
