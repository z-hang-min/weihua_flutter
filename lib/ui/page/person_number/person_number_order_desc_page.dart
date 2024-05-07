import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/model/order_record.dart';
import 'package:weihua_flutter/utils/time_util.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderDescPage extends StatefulWidget {
  final OrderRecord orderRecord;

  OrderDescPage(this.orderRecord);

  @override
  State<StatefulWidget> createState() => _OrderDescState();
}

class _OrderDescState extends State<OrderDescPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle2 = textTheme.subtitle2!;
    return Scaffold(
      appBar: AppBar(
        title: Text('订单详情'),
        backgroundColor: Theme.of(context).cardColor,
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 10.h, right: 10.w, left: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '商品信息',
                style: subtitle2.change(context, color: Colour.f333333),
              ),
              SizedBox(
                height: 15.h,
              ),
              Container(
                padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 12.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: Theme.of(context).cardColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 18.h,
                    ),
                    _itemWidget(
                        context, '商品名称', "${widget.orderRecord.remark}", true),
                    SizedBox(
                      height: 20.h,
                    ),
                    _itemWidget(
                        context, '单价', "¥${widget.orderRecord.price}", true),
                    SizedBox(
                      height: 20.h,
                    ),
                    _itemWidget(
                        context, '数量', "${widget.orderRecord.count}", true),
                    SizedBox(
                      height: 20.h,
                    ),
                    _itemWidget(context, '总计',
                        "¥${widget.orderRecord.getTotalPrice()}", false,
                        color: Colour.fEE4452),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                '订单信息',
                style: subtitle2,
              ),
              SizedBox(
                height: 15.h,
              ),
              Container(
                padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 12.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: Theme.of(context).cardColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 18.h,
                    ),
                    _itemWidget(
                        context, '订单号', "${widget.orderRecord.tradeNo}", true),
                    SizedBox(
                      height: 20.h,
                    ),
                    _itemWidget(
                        context,
                        '下单时间',
                        "${TimeUtil.formatTime(widget.orderRecord.createTime!)}",
                        true),
                    SizedBox(
                      height: 20.h,
                    ),
                    _itemWidget(context, '支付方式',
                        '${widget.orderRecord.getPayType()}', true),
                    SizedBox(
                      height: 20.h,
                    ),
                    _itemWidget(context, '支付时间',
                        "${widget.orderRecord.getPayTime()}", true),
                    SizedBox(
                      height: 20.h,
                    ),
                    _itemWidget(context, '支付状态',
                        "${widget.orderRecord.getPayStatus()}", true),
                    SizedBox(
                      height: 20.h,
                    ),
                    _itemWidget(context, '订单状态',
                        "${widget.orderRecord.getOrderStatus()}", false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemWidget(
      BuildContext context, String title, String desc, bool showLine,
      {Color color = Colour.cFF666666}) {
    if (color == Colour.cFF666666) {
      color = context.isBrightness ? Colour.cFF666666 : Colour.fDEffffff;
    }
    return Column(
      children: [
        Stack(
          children: [
            Text(
              '$title',
              style: TextStyle(
                  height: 1.1,
                  color:
                      context.isBrightness ? Colour.f333333 : Colour.fDEffffff,
                  fontSize: 16),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.only(left: 79.w),
                  child: Text(
                    '$desc',
                    style: TextStyle(height: 1.1, color: color, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ))
          ],
        ),
        SizedBox(
          height: 18.h,
        ),
        Visibility(
          visible: showLine,
          child: Divider(
            // indent: 79.w,
            height: 1.h,
            color: context.isBrightness ? Colour.cFFEEEEEE : Colour.c1AFFFFFF,
          ),
        )
      ],
    );
  }
}
