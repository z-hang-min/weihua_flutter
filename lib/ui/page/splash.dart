import 'dart:async';

import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  var _count = 2;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  void _startTimer() {
    _timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        if (_count <= 1) {
          //为1跳转
          nextPage(context);
          _timer?.cancel();
          _timer = null;
        } else {
          _count--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Stack(fit: StackFit.expand, children: <Widget>[
          Image.asset(ImageHelper.wrapAssets('img_start.png'),
              fit: BoxFit.fill),
          // Positioned(
          //   bottom: 86,
          //   left: 0,
          //   right: 0,
          //   child: Column(
          //     children: [
          //       Text(
          //         '走进微话，让生活更精彩',
          //         style: TextStyle(color: Colors.white, fontSize: 26),
          //       ),
          //       SizedBox(
          //         height: 35,
          //       ),
          //       SafeArea(
          //         child: InkWell(
          //           onTap: () {
          //             nextPage(context);
          //           },
          //           child: Container(
          //             width: 230,
          //             height: 53,
          //             alignment: Alignment.center,
          //             margin: EdgeInsets.only(bottom: 20),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(40),
          //               color: Colors.white,
          //             ),
          //             child: Text(
          //               '马上体验',
          //               style:
          //                   TextStyle(color: Color(0xff228CFF), fontSize: 18),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ]),
      ),
    );
  }
}

void nextPage(context) {
  UserModel userModel = Provider.of<UserModel>(context, listen: false);
  if (userModel.hasUser) {
    Navigator.of(context).pushReplacementNamed(RouteName.tab);
  } else {
    Navigator.of(context).pushReplacementNamed(RouteName.login);
  }
}
