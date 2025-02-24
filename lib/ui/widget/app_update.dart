import 'dart:async';
import 'dart:io';

import 'package:weihua_flutter/config/net/pgyer_api.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:weihua_flutter/view_model/app_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'button_progress_indicator.dart';

class AppUpdateButton extends StatelessWidget {
  Widget build(BuildContext context) {
    return ProviderWidget<AppUpdateModel>(
      model: AppUpdateModel(),
      builder: (_, model, __) => CupertinoButton(
        color: Theme.of(context).colorScheme.onSecondary,
        child: model.isBusy
            ? ButtonProgressIndicator()
            : Text(S.of(context).appUpdateCheckUpdate),
        onPressed: model.isBusy
            ? null
            : () async {
                AppUpdateInfo? appUpdateInfo = await model.checkUpdate();
                if (appUpdateInfo != null &&
                    (appUpdateInfo.buildHaveNewVersion ?? false)) {
                  bool result =
                      await showUpdateAlertDialog(context, appUpdateInfo);
                  if (result == true) downloadApp(context, appUpdateInfo);
                } else {
                  showToast(S.of(context).appUpdateLeastVersion);
                }
              },
      ),
    );
  }
}

Future checkAppUpdate(BuildContext context) async {
  if (!Platform.isAndroid) return;
  AppUpdateInfo? appUpdateInfo = await AppUpdateModel().checkUpdate();
  if (appUpdateInfo != null && (appUpdateInfo.buildHaveNewVersion ?? false)) {
    bool result = await showUpdateAlertDialog(context, appUpdateInfo);
    if (result == true) downloadApp(context, appUpdateInfo);
  }
}

/// App更新提示框
showUpdateAlertDialog(context, AppUpdateInfo appUpdateInfo) async {
  var forceUpdate = appUpdateInfo.needForceUpdate ?? false;
  return await showDialog(
      context: context,
      builder: (context) => WillPopScope(
            onWillPop: () async {
              return !forceUpdate;
            },
            child: AlertDialog(
              title: Text(S
                  .of(context)
                  .appUpdateFoundNewVersion(appUpdateInfo.buildVersion!)),
              content: StringUtils.isNotEmptyString(
                      appUpdateInfo.buildUpdateDescription)
                  ? Text(appUpdateInfo.buildUpdateDescription!)
                  : null,
              actions: <Widget>[
                if (!forceUpdate)
                  CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text(S.of(context).actionCancel),
                  ),
                CupertinoButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    S.of(context).appUpdateActionUpdate,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ),
              ],
            ),
          ));
}

Future downloadApp(BuildContext context, AppUpdateInfo appUpdateInfo) async {
  var url = appUpdateInfo.downloadURL;
  var extDir = await getExternalStorageDirectory();
  debugPrint('extDir path: ${extDir?.path}');
  String apkPath =
      '${extDir?.path}/FunAndroid_${appUpdateInfo.buildVersion}_${appUpdateInfo.buildVersionNo}_${appUpdateInfo.buildBuildVersion}.apk';
  File file = File(apkPath);
  debugPrint('apkPath path: ${file.path}');
  if (!file.existsSync()) {
    // 没有下载过
    if (await showDownloadDialog(context, url, apkPath) ?? false) {
      OpenFile.open(apkPath);
    }
  } else {
    var reDownload = await showReDownloadAlertDialog(context);
    //因为点击android的返回键,关闭dialog时的返回值为null
    if (reDownload != null) {
      if (reDownload) {
        //重新下载
        if (await showDownloadDialog(context, url, apkPath) ?? false) {
          OpenFile.open(apkPath);
        }
      } else {
        //直接安装
        OpenFile.open(apkPath);
      }
    }
  }
}

showDownloadDialog(context, url, path) async {
  DateTime? lastBackPressed;
  CancelToken cancelToken = CancelToken();
  bool downloading = false;
  return await showCupertinoDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            if (lastBackPressed == null ||
                DateTime.now().difference(lastBackPressed!) >
                    Duration(seconds: 1)) {
              //两次点击间隔超过1秒则重新计时
              lastBackPressed = DateTime.now();
              showToast(S.of(context).appUpdateDoubleBackTips,
                  position: ToastPosition.bottom);
              return false;
            }
            cancelToken.cancel();
            showToast(S.of(context).appUpdateDownloadCanceled,
                position: ToastPosition.bottom);
            return true;
          },
          child: CupertinoAlertDialog(
            title: Text(S.of(context).appUpdateDownloading),
            content: Builder(
              builder: (context) {
                debugPrint('Downloader Builder');
                ValueNotifier notifier = ValueNotifier(0.0);
                if (!downloading) {
                  downloading = true;
                  Dio().download(url, path, cancelToken: cancelToken,
                      onReceiveProgress: (progress, total) {
                    debugPrint('value--${progress / total}');
                    notifier.value = progress / total;
                  }).then((Response response) {
                    Navigator.pop(context, true);
                  }).catchError((onError) {
                    showToast(S.of(context).appUpdateDownloadFailed);
                  });
                }
                return ValueListenableBuilder(
                  valueListenable: notifier,
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(
                        value: value as double,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      });
}

showReDownloadAlertDialog(context) async {
  return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text(S.of(context).appUpdateReDownloadContent),
            actions: <Widget>[
              CupertinoButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  S.of(context).actionCancel,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  S.of(context).appUpdateActionDownloadAgain,
                ),
              ),
              CupertinoButton(
                onPressed: () async {
                  Navigator.of(context).pop(false);
                },
                child: Text(S.of(context).appUpdateActionInstallApk),
              ),
            ],
          ));
}
