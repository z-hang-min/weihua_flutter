import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/ui/helper/share_helper.dart';
import 'package:weihua_flutter/ui/page/workbench/viewmodel/share_msg_mode.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

///
/// @Desc: 激活结果
///
/// @Author: zxh
///
/// @Date: 21/11/22
///
class ExtentioneditResultPage extends StatefulWidget {
  final String oid;

  ExtentioneditResultPage(this.oid);

  @override
  _ExtentioneditResultPageState createState() =>
      _ExtentioneditResultPageState();
}

class _ExtentioneditResultPageState extends State<ExtentioneditResultPage> {
  XShareMsgMode shareMsgMode = XShareMsgMode();

  @override
  void initState() {
    super.initState();
    shareMsgMode.getShareMsg(widget.oid);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('成功'),
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                ..pop()
                ..pop();
            }),
      ),
      body: Container(
          color: context.isBrightness ? Colour.c0xFFF7F8FD : Colour.f1A1A1A,
          width: double.infinity,
          padding: EdgeInsets.only(top: 60.h, left: 10.h, right: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                  ImageHelper.wrapAssets('buy_result_success.svg')),
              SizedBox(
                height: 20.h,
              ),
              Text(
                '创建分机成功',
                style: subtitle1.change(context, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 280.h,
              ),
              Row(
                children: [
                 Container(
                   width: 135.w,
                            child: Divider(
                                indent: 120.w,
                                endIndent: 5.w,
                                thickness: 1.w,
                                height: 20.w,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colour.FFD8D8D8
                                    : Color.fromRGBO(255, 255, 255, 0.5)),
                            ),
                  Text(
                    '当前分机未激活',
                    style: TextStyle(
                        color: context.isBrightness
                            ? Colour.FF333333
                            : Colour.FF999999),
                  ),
                 Container(
                   width: 130.w,
                            child: Divider(
                                indent: 5.w,
                                endIndent: 115.w,
                                thickness: 1.w,
                                height: 20.w,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colour.FFD8D8D8
                                    : Color.fromRGBO(255, 255, 255, 0.5)),
                            ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                '通过以下方式通知使用人激活后，分机可正常使用',
                style: TextStyle(
                    color: context.isBrightness
                        ? Colour.FF999999
                        : Colour.FF999999),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                  width: 355.w,
                  height: 144.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colour.f1A1A1A,
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                child: Container(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 15.h),
                                    child: SvgPicture.asset(
                                      ImageHelper.wrapAssets(
                                          context.isBrightness
                                              ? "share_message.svg"
                                              : "share_message_dark.svg"),
                                    ),
                                    // margin: EdgeInsets.all(14),
                                  ),
                                  margin: EdgeInsets.all(5.h),
                                ),
                                onTap: () {
                                  ShareHelper.shareToSms(context,
                                      shareMsgMode.shareMsg.value.contentSms);
                                },
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                child: Container(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 15.h),
                                    child: SvgPicture.asset(
                                      ImageHelper.wrapAssets(
                                          Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? "share_wechat.svg"
                                              : "share_wechat_dark.svg"),
                                    ),
                                    // margin: EdgeInsets.all(20.h),
                                  ),
                                  margin: EdgeInsets.all(5.h),
                                ),
                                onTap: () {
                                  ShareHelper.doWeChatShare(
                                      context, shareMsgMode.shareMsg.value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: Text("短信",
                                    style: TextStyle(
                                        color: context.isBrightness
                                            ? Colour.f333333
                                            : Colour.FF999999,
                                        fontSize: 14)),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text("微信好友",
                                    style: TextStyle(
                                        color: context.isBrightness
                                            ? Colour.f333333
                                            : Colour.FF999999,
                                        fontSize: 14)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          )),
    );
  }
}
