import 'package:weihua_flutter/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static showLoginDialog(context) async {
    return await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(S.of(context).needLogin),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    S.of(context).actionCancel,
                  ),
                ),
                CupertinoDialogAction(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(S.of(context).actionConfirm),
                ),
              ],
            ));
  }
}
