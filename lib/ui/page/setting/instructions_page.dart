//
//  Created by zm on 2022/3/30 .

//  Describe ：注释说明信息
//
import 'package:weihua_flutter/config/const_config.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/resource_mananger.dart';
import '../../../config/router_manger.dart';

class InstructionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InstructionsPageState();
}

class _InstructionsPageState extends State<InstructionsPage> {
  List<_InstruItem> _list = [];

  @override
  void initState() {
    super.initState();
    _list.add(_InstruItem("icon_instructions_call.svg", "通话", "查看详细说明",
        "${ConstConfig.http_api_url_sales}/sales/manual/call?modeType="));
    _list.add(_InstruItem("icon_instructions_contact.svg", "联系人", "查看详细说明",
        "${ConstConfig.http_api_url_sales}/sales/manual/contact?modeType="));
    _list.add(_InstruItem("icon_instructions_callcenter.svg", "联络中心", "查看详细说明",
        "${ConstConfig.http_api_url_sales}/sales/manual/call_center?modeType="));
    _list.add(_InstruItem("icon_instructions_number.svg", "个人号", "查看详细说明",
        "${ConstConfig.http_api_url_sales}/sales/manual/person_num?modeType="));
    _list.add(_InstruItem(
        "icon_instructions_personalcenter.svg",
        "个人中心",
        "查看详细说明",
        "${ConstConfig.http_api_url_sales}/sales/manual/my?modeType="));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          '使用说明',
        ),
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: GridView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) => _itemWidget(_list[index]),
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 11))),
    );
  }

  Widget _itemWidget(_InstruItem item) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    return InkWell(
      onTap: () {
        Get.toNamed(RouteName.webH5,
            arguments: "${item.jumpUrl}${context.isBrightness ? 0 : 1}");
      },
      child: Container(
        padding: EdgeInsets.only(top: 17.h, right: 10.w),
        width: 172.w,
        height: 184.h,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: Column(
          children: [
            SvgPicture.asset(ImageHelper.wrapAssets(item._icon)),
            SizedBox(
              height: 15.h,
            ),
            Text(
              item._name,
              style: subtitle1,
            ),
            Text(
              item._des,
              style: subtitle2.copyWith(color: Colour.FFAFB6BC),
            ),
            SizedBox(
              height: 16.h,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SvgPicture.asset(
                  ImageHelper.wrapAssets('icon_instruction_more.svg')),
            )
          ],
        ),
      ),
    );
  }
}

class _InstruItem {
  String _icon = "";
  String _name = "";
  String _des = "";
  String _jumpUrl = "";

  String get icon => _icon;

  String get name => _name;

  String get des => _des;

  String get jumpUrl => _jumpUrl;

  _InstruItem(this._icon, this._name, this._des, this._jumpUrl);
}
