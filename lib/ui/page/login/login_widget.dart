import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

///
/// @Desc: 登录页 小部件
/// @Author: zhhli
/// @Date: 2021-03-22
///

class LoginLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        return InkWell(
          child: child,
        );
      },
      child: Hero(
        tag: 'loginLogo',
        child: SvgPicture.asset(
          ImageHelper.wrapAssets('logo.svg'),
          width: 90,
          height: 90,
          fit: BoxFit.fill,
          // color: theme.brightness == Brightness.dark
          //     ? theme.accentColor
          //     : theme.primaryColor,

          colorBlendMode: BlendMode.srcIn,
        ),
      ),
    );
  }
}
