import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NetWorkWatch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _NetWorkWatchState();
}

class _NetWorkWatchState extends State {
  var connectivityResult = new Connectivity().checkConnectivity();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      color: Theme.of(context).brightness == Brightness.light
          ? Colour.c0x29F75854
          : Colour.c0xFF7C2B2A,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(ImageHelper.wrapAssets('ic_network_tip.svg')),
          SizedBox(width: 15.w),
          Text(
            '当前网络不可用，请检查你的网络设置',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colour.subtitle2Color
                  : Colour.f99ffffff,
            ),
          ),
        ],
      ),
    );
  }
}
