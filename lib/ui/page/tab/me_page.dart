import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/home_enterprise_address_model.dart';
import 'package:weihua_flutter/ui/page/setting/query_info_mode.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

///
/// @Desc: 我的界面
/// @Author: zhhli
/// @Date: 2021-03-18
///
class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(S.of(context).tabMe),
        ),
        body: Container(
          height: double.infinity,
          color:
              !context.isBrightness ? Colour.f111111 : Colour.backgroundColor2,
          child: SingleChildScrollView(
            child: Ink(
              color: !context.isBrightness
                  ? Colour.f111111
                  : Colour.backgroundColor2,
              child: Container(
                padding: EdgeInsets.only(top: 17.h),
                child: Consumer<UserModel>(
                    builder: (context, model, child) => Column(
                          children: [
                            _userTitleWidget(context, model),
                            _userListWidget(context, model),
                          ],
                        )),
              ),
            ),
          ),
        ));
  }
}

Widget _userTitleWidget(BuildContext context, UserModel model) {
  ThemeData themeData = Theme.of(context);
  TextTheme textTheme = themeData.textTheme;
  TextStyle subtitle1 = textTheme.subtitle1!;
  TextStyle subtitle2 = textTheme.subtitle2!;

  return Column(
    children: [
      ClipOval(
        child: Image.asset(
          context.isBrightness
              ? ImageHelper.wrapAssets('me_pic_head.png')
              : ImageHelper.wrapAssets('me_pic_head_dark.png'),
        ),
      ),
      SizedBox(
        height: 18.h,
      ),
      Text(
        '${model.user!.mobile}',
        style: subtitle1,
      ),
      SizedBox(
        height: 6.h,
      ),
      Text(
        '手机号',
        style: subtitle2.change(context, color: Colour.cFF999999),
      ),
    ],
  );
}

Widget _userListWidget(BuildContext context, UserModel model) {
  ThemeData themeData = Theme.of(context);
  TextTheme textTheme = themeData.textTheme;
  TextStyle subtitle1 = textTheme.subtitle1!;
  return Container(
    margin: EdgeInsets.only(top: 64.h),
    child: Column(
      children: [
        InkWell(
          onTap: () async {
            Navigator.of(context).pushNamed(RouteName.pNumberOrderManager);
          },
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              margin: EdgeInsets.symmetric(vertical: 24.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(ImageHelper.wrapAssets(
                    "me_order_manager.svg",
                  )),
                  Container(
                    margin: EdgeInsets.only(left: 15.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '订单管理',
                          style: subtitle1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '订单历史记录',
                          style: textTheme.subtitle2!
                              .change(context, color: Colour.hintTextColor),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? ImageHelper.wrapAssets("me_icon_more.svg")
                          : ImageHelper.wrapAssets("me_icon_more_dark.svg")),
                ],
              )),
        ),
        Divider(
          indent: 15.w,
          endIndent: 15.w,
        ),
        InkWell(
          onTap: () async {
            Navigator.of(context).pushNamed(RouteName.whSetting);
          },
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              margin: EdgeInsets.symmetric(vertical: 24.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(ImageHelper.wrapAssets(
                    "me_list_icon_setup.png",
                  )),
                  Container(
                    margin: EdgeInsets.only(left: 15.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).setting,
                          style: subtitle1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          S.of(context).answerMode_tips,
                          style: textTheme.subtitle2!
                              .change(context, color: Colour.hintTextColor),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? ImageHelper.wrapAssets("me_icon_more.svg")
                          : ImageHelper.wrapAssets("me_icon_more_dark.svg")),
                ],
              )),
        ),
        Divider(
          indent: 15.w,
          endIndent: 15.w,
        ),
        InkWell(
          onTap: () async {
            Navigator.of(context).pushNamed(RouteName.instructionsPage);
          },
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              margin: EdgeInsets.symmetric(vertical: 24.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(ImageHelper.wrapAssets(
                    "me_list_icon_instructions.svg",
                  )),
                  Container(
                    margin: EdgeInsets.only(left: 15.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "使用说明",
                          style: subtitle1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '使用App小技巧及详细功能介绍',
                          style: textTheme.subtitle2!
                              .change(context, color: Colour.hintTextColor),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? ImageHelper.wrapAssets("me_icon_more.svg")
                          : ImageHelper.wrapAssets("me_icon_more_dark.svg")),
                ],
              )),
        ),
        Divider(
          indent: 15.w,
          endIndent: 15.w,
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteName.about);
          },
          child: Container(
              padding: EdgeInsets.only(left: 15.w, right: 15.w),
              margin: EdgeInsets.symmetric(vertical: 24.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(ImageHelper.wrapAssets(
                    "me_list_icon_about.png",
                  )),
                  Container(
                    margin: EdgeInsets.only(left: 15.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).about,
                          style: subtitle1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          S.of(context).about_tips,
                          style: textTheme.subtitle2!
                              .change(context, color: Colour.hintTextColor),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? ImageHelper.wrapAssets("me_icon_more.svg")
                          : ImageHelper.wrapAssets("me_icon_more_dark.svg")),
                ],
              )),
        ),
        Divider(
// color: Color(0xffeeeeee),
          indent: 15.w,
          endIndent: 15.w,
        ),
      ],
    ),
  );
}
