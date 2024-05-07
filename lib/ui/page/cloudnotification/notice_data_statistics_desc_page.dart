import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DataStatisticsDescPage extends StatefulWidget {
  final dynamic historyinforesult;
  DataStatisticsDescPage(this.historyinforesult);
  @override
  State<StatefulWidget> createState() => _DataStatisticsDescPageState();
}

class _DataStatisticsDescPageState extends State<DataStatisticsDescPage> {
  List<Widget> listWidget = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('记录详情'),
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([_contentWidget(context)])),
            ],
          ),
          Positioned(
            left: 15.w,
            right: 15.w,
            bottom: 20.h,
            child: CupertinoButton(
              borderRadius: BorderRadius.circular(25),
              padding: EdgeInsets.all(1),
              color: Colour.f0F8FFB,
              disabledColor: Colour.f0F8FFB.withAlpha(100),
              child: Container(
                height: 50.h,
                alignment: Alignment.center,
                child: Text(
                  '重发',
                  style: TextStyle(color: Colour.fffffff),
                ),
              ),
              onPressed: () {
                Get.offNamed(RouteName.noticeSendPage,
                    arguments: widget.historyinforesult);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _contentWidget(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Container(
      color: Theme.of(context).cardColor,
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.only(top: 18.h, left: 15.w, right: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '接收号码：',
                style: TextStyle(
                    color: context.isBrightness
                        ? Colour.cFF999999
                        : Colour.f99ffffff,
                    height: 1.1,
                    fontSize: 14),
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                widget.historyinforesult!.calleeCount.toString(),
                style: TextStyle(
                  color: Colour.f0F8FFB,
                  fontSize: 14,
                  height: 1.1,
                ),
              ),
              Text(
                '个',
                style: TextStyle(
                    color: context.isBrightness
                        ? Colour.cFF999999
                        : Colour.f99ffffff,
                    height: 1.1,
                    fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Wrap(
            children: [
              for (int i = 0; i < widget.historyinforesult!.calleeCount; i++)
                _itemWidget(context, widget.historyinforesult!.callees, i)
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Divider(),
          SizedBox(
            height: 18.h,
          ),
          Text(
            '发送内容：',
            style: TextStyle(
                color:
                    context.isBrightness ? Colour.cFF999999 : Colour.f99ffffff,
                height: 1.1,
                fontSize: 14),
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(ImageHelper.wrapAssets('icon_data_fail.svg')),
              SizedBox(
                width: 5.w,
              ),
              Text(
                widget.historyinforesult!.sendTemplateTitle,
                style: subtitle1,
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            padding: EdgeInsets.all(10.w),
            margin: EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: context.isBrightness
                  ? Colour.backgroundColor
                  : Colour.f2C2C2C,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              " 模版内容:${widget.historyinforesult!.sendTemplateContent}",
              style: TextStyle(
                  color:
                      context.isBrightness ? Colour.FF6C7588 : Colour.f99ffffff,
                  fontSize: 12),
            ),
          ),
          SizedBox(
            height: 18.h,
          ),
          Divider(),
          SizedBox(
            height: 18.h,
          ),
          Text(
            '状态：',
            style: TextStyle(
                color:
                    context.isBrightness ? Colour.cFF999999 : Colour.f99ffffff,
                height: 1.1,
                fontSize: 14),
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              widget.historyinforesult.resultIVR == 2
                  ? Text("")
                  : Row(children: [
                      SvgPicture.asset(ImageHelper.wrapAssets(
                          widget.historyinforesult.resultIVR == 0
                              ? 'icon_data_success.svg'
                              : 'icon_data_2.svg')),
                      Text(
                          widget.historyinforesult.resultIVR == 0
                              ? '语音通知成功'
                              : '语音通知失败',
                          style: TextStyle(
                              color: widget.historyinforesult.resultIVR == 0
                                  ? Colour.FF19BA6C
                                  : Colour.FFF25643,
                              fontSize: 14))
                    ]),
              SizedBox(
                width: 10.w,
              ),
              widget.historyinforesult.resultMSG == 2
                  ? Text("")
                  : Row(children: [
                      SvgPicture.asset(ImageHelper.wrapAssets(
                          widget.historyinforesult.resultMSG == 0
                              ? 'icon_data_success.svg'
                              : 'icon_data_2.svg')),
                      Text(
                          widget.historyinforesult.resultMSG == 0
                              ? '短信通知成功'
                              : '短信通知失败',
                          style: TextStyle(
                              color: widget.historyinforesult.resultMSG == 0
                                  ? Colour.FF19BA6C
                                  : Colour.FFF25643,
                              fontSize: 14)),
                    ]),
            ],
          ),
          SizedBox(
            height: 18.h,
          ),
          Divider(),
          SizedBox(
            height: 18.h,
          ),
          Text(
            '发送时间：',
            style: TextStyle(
                color:
                    context.isBrightness ? Colour.cFF999999 : Colour.f99ffffff,
                height: 1.1,
                fontSize: 14),
          ),
          SizedBox(
            height: 15.h,
          ),
          Text(
            widget.historyinforesult!.createTime,
            style: TextStyle(
                color: context.isBrightness ? Colour.f333333 : Colors.white),
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }

  Widget _itemWidget(BuildContext context, String num, int index) {
    List temp = num.split(',');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      margin: EdgeInsets.only(right: 6.w, top: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: context.isBrightness ? Colors.transparent : Colour.f0F8FFB,
              width: 1),
          color: context.isBrightness ? Colour.ffff4f5f : Colors.transparent),
      child: Text(
        temp[index],
        style: TextStyle(
          color: Colour.f0F8FFB,
          fontSize: 14,
          height: 1.1,
        ),
      ),
    );
  }
}
