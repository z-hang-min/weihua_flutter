import 'dart:io';

import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/ui/widget/app_update.dart';
import 'package:weihua_flutter/utils/platform_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ChangeLogPage extends StatefulWidget {
  @override
  _ChangeLogPageState createState() => _ChangeLogPageState();
}

class _ChangeLogPageState extends State<ChangeLogPage> {
  late ValueNotifier versionNotifier;

  @override
  void initState() {
    versionNotifier = ValueNotifier<String>('');
    PackageInfo.fromPlatform().then((packageInfo) {
      versionNotifier.value =
          '${packageInfo.version}(${packageInfo.buildNumber})';
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
            valueListenable: versionNotifier,
            builder: (ctx, value, child) =>
                Text(S.of(context).appUpdateCheckUpdate + ' v$value')),
      ),
      body: SafeArea(
        child: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 75),
            child: ChangeLogView(),
          ),
          Positioned(
            left: 30,
            right: 30,
            bottom: 8,
            child: Platform.isIOS
                ? CupertinoButton(
                    color: Theme.of(context).colorScheme.onSecondary,
                    child: Text(S.of(context).close),
                    onPressed: () {
                      Navigator.pop(context);
                    })
                : AppUpdateButton(),
          )
        ]),
      ),
    );
  }
}

class ChangeLogView extends StatefulWidget {
  @override
  _ChangeLogViewState createState() => _ChangeLogViewState();
}

class _ChangeLogViewState extends State<ChangeLogView> {
  late String? _changelog;

  @override
  void initState() {
    rootBundle.loadString("CHANGELOG.md").then((data) {
      setState(() {
        _changelog = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_changelog == null) {
      // return ViewStateBusyWidget();
      return Container();
    }
    return Markdown(data: _changelog!);
  }
}
