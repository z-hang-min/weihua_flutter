import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoNetWorkPage extends StatefulWidget {
  final String h5url;

  NoNetWorkPage(this.h5url);

  @override
  _NoNetWorkPageState createState() => _NoNetWorkPageState();
}

class _NoNetWorkPageState extends State<NoNetWorkPage> {
  // bool isHasNet = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('请检查网络设置'),
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
        // leading: IconButton(
        //     icon: SvgPicture.asset(ImageHelper.wrapAssets(
        //         Theme.of(context).brightness == Brightness.light
        //             ? "nav_icon_return_white.svg"
        //             : "nav_icon_return_sel.svg")),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     }),

        body: _getnoresultPicWifget(context));
  }

  Widget _getnoresultPicWifget(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 120.h),
        child: Column(
          children: [
            Center(
              child: SvgPicture.asset(
                ImageHelper.wrapAssets(
                    Theme.of(context).brightness == Brightness.light
                        ? "pic_nonetwork.svg"
                        : "pic_nonet_dark.svg"),
                fit: BoxFit.cover,
                width: 320.w,
                height: 320.h,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              '网络不给力',
              style: Theme.of(context).brightness == Brightness.light
                  ? TextStyle(color: Colour.titleColor, fontSize: 16)
                  : TextStyle(color: Color.fromRGBO(255, 255, 255, 0.87)),
            ),
            SizedBox(height: 6.h),
            Text(
              '点击刷新试一下',
              style: Theme.of(context).brightness == Brightness.light
                  ? TextStyle(color: Colour.hintTextColor, fontSize: 16)
                  : TextStyle(color: Color.fromRGBO(255, 255, 255, 0.87)),
            ),
            SizedBox(height: 40.h),
            TextButton(
                child: Text('刷新',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                onPressed: () async {
                  Log.w('ishavenet=====$ishavenet');
                  // var ishavenet = await isConnected();
                  if (ishavenet) {
                    Navigator.of(context).pushReplacementNamed(RouteName.webH5,
                        arguments: widget.h5url);
                  }
                },
                style: ButtonStyle(
                  //设置按钮的大小
                  minimumSize: MaterialStateProperty.all(Size(140.w, 45.h)),
                  //背景颜色
                  //背景颜色
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    //设置按下时的背景颜色
                    if (states.contains(MaterialState.pressed)) {
                      // return Colour.fEE4452.withAlpha(10);
                    }
                    //默认不使用背景颜色
                    return Colour.primaryColor;
                  }),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                )),
          ],
        ));
  }

  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}
