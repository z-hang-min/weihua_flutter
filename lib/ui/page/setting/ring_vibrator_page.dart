import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/storage_manager.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const String kKeyToneState = 'kKeyToneState';
const String kVibratorState = 'kVibratorState';

class RingAndVibratorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RingAndVibratorPageState();
}

class _RingAndVibratorPageState extends State {
  var keyTone =
      StorageManager.sharedPreferences!.getBool(kKeyToneState) ?? false;
  var vibrator =
      StorageManager.sharedPreferences!.getBool(kVibratorState) ?? false;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    TextStyle subtitle1 = textTheme.subtitle1!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(S.of(context).ringAndVibrator),
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
        margin: EdgeInsets.all(10),
        height: 136,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text(
                S.of(context).ringtone,
                style: subtitle1.change(context, color: Colour.f18),
              ),
              trailing: CupertinoSwitch(
                  value: keyTone,
                  activeColor: Colour.f0F8FFB,
                  onChanged: (value) {
                    setState(() {
                      keyTone = value;
                      StorageManager.sharedPreferences!
                          .setBool(kKeyToneState, keyTone);
                    });
                  }),
            ),
            Divider(
              height: 1,
              endIndent: 15,
              indent: 15,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colour.c1AFFFFFF
                  : Colour.cffE6E6E6,
            ),
            ListTile(
              title: Text(
                S.of(context).ringVibrator,
                style: subtitle1.change(context, color: Colour.f18),
              ),
              trailing: CupertinoSwitch(
                  value: vibrator,
                  activeColor: Colour.f0F8FFB,
                  onChanged: (value) {
                    setState(() {
                      vibrator = value;
                      StorageManager.sharedPreferences!
                          .setBool(kVibratorState, vibrator);
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
