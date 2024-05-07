import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/model/record_detail_list_result.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/viewmodel/data_statistics_view_model.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DataStatisticsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DataStatisticsPageState();
}

class SortCondition {
  String name;
  bool isSelected;
  int type;

  SortCondition({this.name = '', this.isSelected = false, this.type = 1});
}

class _DataStatisticsPageState extends State<DataStatisticsPage> {
  XDataStatisticsViewModel xDataStatisticsViewModel =
      XDataStatisticsViewModel();
  List<String> _dropDownHeaderItemStrings = ['选择时间', '统计类型', '发送方式'];
  List<SortCondition> _sortConditions1 = [];
  List<SortCondition> _sortConditions2 = [];
  List<SortCondition> _sortConditions3 = [];
  late SortCondition _selectSortCondition1;
  late SortCondition _selectSortCondition2;
  late SortCondition _selectSortCondition3;
  GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();

  String _dropdownMenuChange = '';

  @override
  void initState() {
    super.initState();
    xDataStatisticsViewModel.initData();
    xDataStatisticsViewModel.setRefreshController(_refreshController);
    _sortConditions1
        .add(SortCondition(name: '最近一个月', isSelected: true, type: 1));
    _sortConditions1
        .add(SortCondition(name: '最近三个月', isSelected: false, type: 2));
    // _sortConditions1.add(SortCondition(name: '最近半年', isSelected: false));
    _sortConditions1
        .add(SortCondition(name: '最近一年', isSelected: false, type: 3));
    _sortConditions1
        .add(SortCondition(name: '最近三年', isSelected: false, type: 4));

    _selectSortCondition1 = _sortConditions1[0];

    _sortConditions2.add(SortCondition(name: '按日', isSelected: true, type: 1));
    _sortConditions2.add(SortCondition(name: '按月', isSelected: false, type: 2));
    _sortConditions2.add(SortCondition(name: '按年', isSelected: false, type: 3));

    _selectSortCondition2 = _sortConditions2[0];

    _sortConditions3
        .add(SortCondition(name: '全部方式', isSelected: true, type: 2));
    _sortConditions3
        .add(SortCondition(name: '语音通知', isSelected: false, type: 0));
    _sortConditions3
        .add(SortCondition(name: '短信通知', isSelected: false, type: 1));

    _selectSortCondition3 = _sortConditions3[0];
  }

  @override
  void dispose() {
    super.dispose();
    if (EasyLoading.isShow) EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text('数据统计'),
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Stack(
        key: _stackKey,
        children: <Widget>[
          Column(
            children: <Widget>[
              Obx(() {
                if (xDataStatisticsViewModel.isBusy)
                  EasyLoading.show(status: '加载数据');
                if (xDataStatisticsViewModel.isError)
                  xDataStatisticsViewModel.showErrorMessage(context);
                if (xDataStatisticsViewModel.isIdle) EasyLoading.dismiss();
                return SizedBox();
              }),
              GZXDropDownHeader(
                borderWidth: 0,
                height: 44.h,
                dividerColor: context.isBrightness
                    ? Colors.white
                    : Theme.of(context).cardColor,
                color: Theme.of(context).cardColor,
                // 下拉的头部项，目前每一项，只能自定义显示的文字、图标、图标大小修改
                items: [
                  GZXDropDownHeaderItem(
                    _dropDownHeaderItemStrings[0],
                    style: TextStyle(
                        color: _dropDownHeaderItemStrings[0] != '选择时间'
                            ? Colour.f0F8FFB
                            : context.isBrightness
                                ? Colour.f333333
                                : Colour.fDEffffff,
                        fontSize: 14),
                  ),
                  GZXDropDownHeaderItem(
                    _dropDownHeaderItemStrings[1],
                    style: TextStyle(
                        color: _dropDownHeaderItemStrings[1] != '统计类型'
                            ? Colour.f0F8FFB
                            : context.isBrightness
                                ? Colour.f333333
                                : Colour.fDEffffff,
                        fontSize: 14),
                  ),
                  GZXDropDownHeaderItem(
                    _dropDownHeaderItemStrings[2],
                    style: TextStyle(
                        color: _dropDownHeaderItemStrings[2] != '发送方式'
                            ? Colour.f0F8FFB
                            : context.isBrightness
                                ? Colour.f333333
                                : Colour.fDEffffff,
                        fontSize: 14),
                    // style: ,
                  ),
                ],
                // GZXDropDownHeader对应第一父级Stack的key
                stackKey: _stackKey,
                // controller用于控制menu的显示或隐藏
                controller: _dropdownMenuController,
                // 当点击头部项的事件，在这里可以进行页面跳转或openEndDrawer
                onItemTap: (index) {
                  // if (index == 3) {
                  //   _dropdownMenuController.hide();
                  // }
                },
//                // 头部边框颜色
                borderColor: Theme.of(context).cardColor,
                dropDownStyle: TextStyle(
                  fontSize: 14,
                  color: Colour.FF0F88FF,
                ),
                style: subtitle1.change(context,
                    color: Colour.f333333, fontSize: 14),
                iconColor:
                    context.isBrightness ? Colour.f333333 : Colour.f61ffffff,
//                // 下拉时图标颜色
                iconDropDownColor:
                    context.isBrightness ? Colour.f333333 : Colour.f61ffffff,
              ),
              Obx(() {
                return Visibility(
                    visible: xDataStatisticsViewModel.list.isNotEmpty,
                    replacement: Column(
                      children: [
                        SizedBox(
                          height: 90.h,
                        ),
                        SvgPicture.asset(ImageHelper.wrapAssets(
                            context.isBrightness
                                ? 'icon_no_data.svg'
                                : 'icon_no_data_black.svg')),
                        Text(
                          '暂无相关统计数据',
                          style:
                              TextStyle(fontSize: 16, color: Colour.cFF999999),
                        )
                      ],
                    ),
                    child: Expanded(
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
                                SvgPicture.asset(ImageHelper.wrapAssets(
                                    'me_icon_pullup.svg')),
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
                                SvgPicture.asset(ImageHelper.wrapAssets(
                                    'me_icon_pullup.svg')),
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
                      controller: xDataStatisticsViewModel.refreshController,
                      onRefresh: xDataStatisticsViewModel.refresh,
                      onLoading: xDataStatisticsViewModel.loadMore,
                      child: ListView.builder(
                          itemCount: xDataStatisticsViewModel.list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return itemWidget(
                                xDataStatisticsViewModel.list[index]);
                          }),
                    )));
              }),
            ],
          ),
          // 下拉菜单
          GZXDropDownMenu(
            // controller用于控制menu的显示或隐藏
            controller: _dropdownMenuController,
            // 下拉菜单显示或隐藏动画时长
            animationMilliseconds: 300,
            // 下拉后遮罩颜色
//          maskColor: Theme.of(context).primaryColor.withOpacity(0.5),
//          maskColor: Colors.red.withOpacity(0.5),
            dropdownMenuChanging: (isShow, index) {
              setState(() {
                _dropdownMenuChange = '(正在${isShow ? '显示' : '隐藏'}$index)';
                print(_dropdownMenuChange);
              });
            },
            dropdownMenuChanged: (isShow, index) {
              setState(() {
                _dropdownMenuChange = '(已经${isShow ? '显示' : '隐藏'}$index)';
                print(_dropdownMenuChange);
              });
            },
            // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
            menus: [
              GZXDropdownMenuBuilder(
                  dropDownHeight: 58.0 * _sortConditions1.length,
                  dropDownWidget:
                      _buildConditionListWidget(_sortConditions1, (value) {
                    _selectSortCondition1 = value;
                    _dropDownHeaderItemStrings[0] = _selectSortCondition1.name;
                    _dropdownMenuController.hide();
                    xDataStatisticsViewModel.recentDateType.value =
                        _selectSortCondition1.type;
                    // xDataStatisticsViewModel.mobile.value = '18801291412';
                    xDataStatisticsViewModel.refresh(init: true);
                    setState(() {});
                  })),
              GZXDropdownMenuBuilder(
                  dropDownHeight: 58.0 * _sortConditions2.length,
                  dropDownWidget:
                      _buildConditionListWidget(_sortConditions2, (value) {
                    _selectSortCondition2 = value;
                    _dropDownHeaderItemStrings[1] = _selectSortCondition2.name;
                    _dropdownMenuController.hide();
                    xDataStatisticsViewModel.statisticType.value =
                        _selectSortCondition2.type;
                    xDataStatisticsViewModel.refresh(init: true);
                    setState(() {});
                  })),
              GZXDropdownMenuBuilder(
                  dropDownHeight: 58.0 * _sortConditions3.length,
                  dropDownWidget:
                      _buildConditionListWidget(_sortConditions3, (value) {
                    _selectSortCondition3 = value;
                    _dropDownHeaderItemStrings[2] = _selectSortCondition3.name;
                    _dropdownMenuController.hide();
                    xDataStatisticsViewModel.sendType.value =
                        _selectSortCondition3.type;
                    xDataStatisticsViewModel.refresh(init: true);
                    setState(() {});
                  })),
            ],
          ),
        ],
      ),
    );
  }

  Widget itemWidget(RecordDetail recordDetail) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        height: 102.h,
        decoration: BoxDecoration(
            color: themeData.cardColor, borderRadius: BorderRadius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${recordDetail.createTime}',
              style: subtitle1.change(context,
                  color: Colour.f333333, fontSize: 14),
            ),
            SizedBox(
              height: 17.h,
            ),
            Divider(
              height: 1.h,
              color:
                  context.isBrightness ? Colour.cFFEEEEEE : Colour.f0x1AFFFFFF,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '累计数量 ',
                      style: subtitle1.change(
                        context,
                        fontSize: 14,
                        height: 1.1,
                        color: Colour.f333333,
                      ),
                    ),
                    Text(
                      '${recordDetail.total}',
                      style: subtitle1.change(
                        context,
                        fontSize: 16,
                        height: 1.1,
                        color: Colour.f333333,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '发送成功 ',
                      style: subtitle2.change(context,
                          color: Colour.cFF999999, height: 1.1),
                    ),
                    Text(
                      '${recordDetail.successCount}',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.1,
                        color: Colour.FF19BA6C,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '发送失败 ',
                      style: subtitle2.change(context,
                          color: Colour.cFF999999, height: 1.1),
                    ),
                    Text(
                      '${recordDetail.failCount}',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.1,
                        color: Colour.FFF25845,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildConditionListWidget(
      items, void itemOnTap(SortCondition sortCondition)) {
    return Container(
      color: Theme.of(context).cardColor,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        // item 的个数
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 1.0,
          endIndent: 15.w,
          indent: 15.w,
          color: context.isBrightness ? Colour.cFFEEEEEE : Colour.f0x1AFFFFFF,
        ),
        // 添加分割线
        itemBuilder: (BuildContext context, int index) {
          SortCondition goodsSortCondition = items[index];
          return GestureDetector(
            onTap: () {
              for (var value in items) {
                value.isSelected = false;
              }
              goodsSortCondition.isSelected = true;

              itemOnTap(goodsSortCondition);
            },
            child: Container(
              color: Theme.of(context).cardColor,
              height: 58,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 15.w,
                  ),
                  Expanded(
                    child: Text(
                      goodsSortCondition.name,
                      style: TextStyle(
                        color: goodsSortCondition.isSelected
                            ? Colour.f0F8FFB
                            : context.isBrightness
                                ? Colour.f333333
                                : Colour.fDEffffff,
                      ),
                    ),
                  ),
                  goodsSortCondition.isSelected
                      ? Icon(
                          Icons.check,
                          color: Colour.f0F8FFB,
                          size: 16,
                        )
                      : SizedBox(),
                  SizedBox(
                    width: 16,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
