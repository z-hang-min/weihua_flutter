import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/model/order_record.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/ordermanager_view_model.dart';
import 'package:weihua_flutter/utils/time_util.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrderManagerState();
}

class _OrderManagerState extends State<OrderManagerPage> {
  XOrderManagerViewModel xOrderManagerViewModel =
      Get.put(XOrderManagerViewModel());
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    xOrderManagerViewModel.initData();
    xOrderManagerViewModel.setRefreshController(_refreshController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('订单记录'),
        backgroundColor: Theme.of(context).cardColor,
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Obx(() {
        return xOrderManagerViewModel.list.isEmpty
            ? Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Text('没有订单记录'),
              )
            : Container(
                margin: EdgeInsets.only(top: 10.h),
                height: MediaQuery.of(context).size.height,
                color: context.isBrightness
                    ? Colour.backgroundColor2
                    : Colour.FF111111,
                child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: WaterDropHeader(),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus? mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  ImageHelper.wrapAssets('me_icon_pullup.svg')),
                              Text("上滑加载更多")
                            ],
                          );
                        } else if (mode == LoadStatus.loading) {
                          body = CircularProgressIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = Text("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  ImageHelper.wrapAssets('me_icon_pullup.svg')),
                              Text("上滑加载更多")
                            ],
                          );
                        } else if (mode == LoadStatus.noMore) {
                          body = Text("没有更多数据了");
                        } else {
                          body = Text('');
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    controller: xOrderManagerViewModel.refreshController,
                    onRefresh: xOrderManagerViewModel.refresh,
                    onLoading: xOrderManagerViewModel.loadMore,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: xOrderManagerViewModel.list.length,
                        itemBuilder: (context, index) {
                          return _itemWidget(
                              context, xOrderManagerViewModel.list[index]);
                        })),
              );
      }),
    );
  }

  Widget _itemWidget(BuildContext context, OrderRecord orderRecord) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(RouteName.pNumberOrderManagerDesc,
            arguments: orderRecord);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${orderRecord.remark}',
                  style: subtitle1,
                ),
                Text(
                  '¥${orderRecord.price}',
                  style: subtitle1,
                )
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${TimeUtil.formatTimeWithreg(orderRecord.createTime!, "yyyy年MM月dd日 HH:mm")}',
                  style: subtitle2.change(context, color: Colour.cFF999999),
                ),
                Text(
                  '${orderRecord.getOrderStatus()}',
                  style: TextStyle(
                      fontSize: 14, color: orderRecord.getOrderStatusColor()),
                )
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
