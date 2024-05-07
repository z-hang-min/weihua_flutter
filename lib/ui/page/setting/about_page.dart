import 'package:weihua_flutter/config/const_config.dart';
import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/model/check_update_result.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/ui/page/setting/checkupdate_mode.dart';
import 'package:weihua_flutter/ui/widget/button_progress_indicator.dart';
import 'package:weihua_flutter/ui/widget/update_dialog.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  var appVersion;
  var appName;

  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = packageInfo.version;
      appName = packageInfo.appName;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    TextTheme textTheme = themeData.textTheme;

    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle caption = textTheme.caption!;
    return Scaffold(
      appBar: AppBar(
        title: new Text(S.of(context).about),
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(
                Theme.of(context).brightness == Brightness.light
                    ? "nav_icon_return.svg"
                    : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(92),
            ),
            Center(
              child: SvgPicture.asset(
                ImageHelper.wrapAssets("logo.svg"),
                fit: BoxFit.cover,
                width: 90,
                height: 90,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "$appName",
              style: subtitle1.change(context, color: Colour.f18),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Text(
                "V$appVersion",
                style: caption,
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(121),
            ),
            CheckBtn(),
            Expanded(
              child: Container(),
              flex: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteName.webH5,
                        arguments:
                            "${ConstConfig.user_agreement}${Theme.of(context).brightness == Brightness.light ? 0 : 1}");
                  },
                  child: Text(
                    S.of(context).user_agreement,
                    style: TextStyle(fontSize: 12, color: Colour.f0F8FFB),
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteName.webH5,
                        arguments:
                            "${ConstConfig.privacy}${Theme.of(context).brightness == Brightness.light ? 0 : 1}");
                  },
                  child: Text(
                    S.of(context).privacy_agreement,
                    style: TextStyle(fontSize: 12, color: Colour.f0F8FFB),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                '客服电话  950138008',
                style: caption.change(context, fontSize: 12),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                S.of(context).about_copyright_txt,
                style: caption.change(context, fontSize: 12),
              ),
            ),
            SizedBox(
              height: 35,
            )
          ],
        ),
      ),
    );
  }
}

class CheckBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
        model: CheckUpdateMode(),
        builder: (_, CheckUpdateMode model, __) => TextButton(
              child: model.isBusy
                  ? ButtonProgressIndicator()
                  : Text(
                      S.of(context).appUpdateCheckNew,
                      style: TextStyle(fontSize: 16, color: Colour.f0F8FFB),
                    ),
              style: ButtonStyle(
                //设置按钮的大小
                minimumSize: MaterialStateProperty.all(Size(148, 40)),
                //背景颜色

                side: MaterialStateProperty.all(
                  BorderSide(color: Colour.f0F8FFB, width: 0.5),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              onPressed: model.isBusy
                  ? null
                  : () async {
                      CheckUpdateResult? appUpdateInfo =
                          await model.checkUpdate();
                      if (appUpdateInfo != null && appUpdateInfo.update) {
                        UpdateDialog.showUpdateDialog(context, appUpdateInfo);
                      } else {
                        showToast(S.of(context).appUpdateLeastVersion);
                      }
                    },
            ));
  }
}
