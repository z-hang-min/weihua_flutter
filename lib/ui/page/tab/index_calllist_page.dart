import 'dart:async';
import 'dart:math' as math;

import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/event/call_list_refresh_event.dart';
import 'package:weihua_flutter/event/network_change_event.dart';
import 'package:weihua_flutter/event/refresh_callpadnum_event.dart';
import 'package:weihua_flutter/event/widgetlife_change_event.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/model/call_record.dart';
import 'package:weihua_flutter/model/ex_contacts_result.dart';
import 'package:weihua_flutter/model/local_contact.dart';
import 'package:weihua_flutter/model/user.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/contact_repository.dart';
import 'package:weihua_flutter/service/event_bus.dart';
import 'package:weihua_flutter/ui/helper/refresh_helper.dart';
import 'package:weihua_flutter/ui/page/call/call_widget.dart';
import 'package:weihua_flutter/ui/page/call/view_model/home_call_list_model.dart';
import 'package:weihua_flutter/ui/widget/custom_alert_dialog.dart';
import 'package:weihua_flutter/ui/widget/custom_listview_dialog.dart';
import 'package:weihua_flutter/ui/widget/custom_permission_alert_dialog.dart';
import 'package:weihua_flutter/ui/widget/network_watch.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/platform_utils.dart';
import 'package:weihua_flutter/utils/time_util.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../contact/contact_search_page.dart';

class IndexCallListPage extends StatefulWidget {
  @override
  _CallRecordListPageState createState() => _CallRecordListPageState();
}

class _CallRecordListPageState extends State<IndexCallListPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // 状态保持
  @override
  bool get wantKeepAlive => false;

  HomeCallListModel _homeCallListModel = HomeCallListModel();
  RefreshController _refreshMissedController =
      RefreshController(initialRefresh: false);
  List<SortCondition> _brandSortConditions = [];
  late SortCondition _selectBrandSortCondition;
  GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();

  late StreamSubscription _subscription;
  late StreamSubscription _subscriptionNet;
  late StreamSubscription _subscriptionLife;

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
    _subscriptionNet.cancel();
    _subscriptionLife.cancel();
  }

  @override
  void initState() {
    super.initState();
    _subscription = eventBus.on<CallListRefreshEvent>().listen((event) async {
      _homeCallListModel.refresh(pageFirst: 1);
      _homeCallListModel.updateOnEdit(false);
    });
    _subscriptionNet = eventBus.on<NetworkChangeEvent>().listen((event) async {
      ishavenet = event.hasNet;
      _homeCallListModel.updateNet(event.hasNet);
    });
    _subscriptionLife =
        eventBus.on<WidgetLifeChangeEvent>().listen((event) async {
      if (event.appLifecycleState == AppLifecycleState.resumed) {
        _homeCallListModel.refresh(pageFirst: 1);
      }
    });
  }

  ///号码下拉列表，个人号不展示分机号码
  void initSelectNumData() {
    List<User>? result = accRepo.unifyLoginResult!.numberList;
    _brandSortConditions.add(SortCondition(
        name: '全部号码', isSelected: '全部号码' == _homeCallListModel.title));
    result.forEach((element) {
      if (element.numberType == 1 || element.numberType == 102) {
        _brandSortConditions.add(SortCondition(
            name: element.innerNumber == "1000"
                ? '${element.outerNumber2}'
                : '${element.outerNumber2}${element.innerNumber}',
            isSelected: element.innerNumber == "1000"
                ? '${element.outerNumber2}' == _homeCallListModel.title
                : '${element.outerNumber2}${element.innerNumber}' ==
                    _homeCallListModel.title));
      } else
        _brandSortConditions.add(SortCondition(
            name: '${element.outerNumber2}',
            isSelected: element.outerNumber2 == _homeCallListModel.title));
    });
    _selectBrandSortCondition = _brandSortConditions[0];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<HomeCallListModel>(
        model: HomeCallListModel(),
        onModelReady: (model) async {
          _homeCallListModel = model;
          if (lastNum.isNotEmpty) _homeCallListModel.searchRecord(lastNum);
          model.initData();
          await model.queryDefaultOuterNum().then((value) async {
            initSelectNumData();
          });
        },
        builder: (builder, model, child) {
          return Scaffold(
            appBar: PreferredSize(
              child: AppBar(
                backgroundColor: Theme.of(context).cardColor,
                automaticallyImplyLeading: false,
              ),
              preferredSize: Size.fromHeight(0),
            ),
            floatingActionButton: Visibility(
              visible: !model.showPad && !model.onEdit,
              child: FloatingActionButton(
                onPressed: () {
                  model.updateShowPad(true);
                },
                elevation: 0,
                child: Transform.rotate(
                    angle: math.pi, child: Icon(Icons.dialpad)),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: Stack(
              children: [
                Container(
                    color: Theme.of(context).cardColor,
                    child: Column(
                      children: [
                        _titleWidget(context, model),
                        Container(
                          height: 44.h,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  model.changeTab(0);
                                },
                                child: Container(
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 30.w),
                                  child: Text(
                                    '所有通话',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: model.tab == 0
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: model.tab == 0
                                          ? (Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colour.titleColor
                                              : Colour.fDEffffff)
                                          : (Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colour.hintTextColor
                                              : Colour.f99ffffff),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 16,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colour.cFFEEEEEE
                                    : Colour.c1AFFFFFF,
                              ),
                              InkWell(
                                onTap: () {
                                  model.changeTab(1);
                                },
                                child: Container(
                                    height: double.infinity,
                                    alignment: Alignment.center,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30.w),
                                    child: Text(
                                      '未接来电',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: model.tab == 1
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: model.tab == 1
                                            ? (Theme.of(context).brightness ==
                                                    Brightness.light
                                                ? Colour.titleColor
                                                : Colour.fDEffffff)
                                            : (Theme.of(context).brightness ==
                                                    Brightness.light
                                                ? Colour.hintTextColor
                                                : Colour.f99ffffff),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: !model.hasNet,
                          child: NetWorkWatch(),
                        ),
                        Container(
                          alignment: Alignment.center,
                          color: context.isBrightness
                              ? Colour.c0xFFF7F8FD
                              : Colour.FF111111,
                          height: 10.h,
                        ),
                        Visibility(
                          visible: model.showEmployee,
                          child: _fenjiContactWidget(context, model),
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(
                      top: model.showEmployee
                          ? (!model.hasNet ? 201 : 167.h)
                          : (!model.hasNet ? 132 : 98.h)),
                  color: context.isBrightness
                      ? Colour.c0xFFF7F8FD
                      : Colour.FF111111,
                  child: Stack(
                    children: [
                      // list 列表
                      _buildDataWidget2(context, model),
                      Visibility(
                        visible: model.showEmptyView(),
                        child: _emptyDataWidget(context, model),
                      ),
                      Visibility(
                        visible: model.showPad && !model.onEdit,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: DialPadWidget(
                              onPressedCallPhone: (number) async {
                                _doSysCallOut(context, number, model);
                              },
                              onPressedCallVoIP: (number) {}),
                        ),
                      ),

                      Visibility(
                          visible: model.onEdit,
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: _delWidget(context, model))),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 58.h),
                  child: Stack(
                    children: [
                      GZXDropDownMenu(
                        // controller用于控制menu的显示或隐藏
                        controller: _dropdownMenuController,
                        // 下拉菜单显示或隐藏动画时长
                        animationMilliseconds: 300,
                        // 下拉后遮罩颜色
                        dropdownMenuChanging: (isShow, index) {},
                        dropdownMenuChanged: (isShow, index) {},
                        menus: [
                          GZXDropdownMenuBuilder(
                              dropDownHeight:
                                  _brandSortConditions.length > 0 ? 10 * 61 : 1,
                              dropDownWidget: Container(
                                color: Theme.of(context).cardColor,
                                child: _buildConditionListWidget(
                                    _brandSortConditions, (value) {
                                  _selectBrandSortCondition = value;
                                  _dropdownMenuController.hide();
                                  model.updateTitle(
                                      _selectBrandSortCondition.name);
                                  model.refresh(pageFirst: 1);
                                }),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _titleWidget(BuildContext context, HomeCallListModel model) {
    return Container(
      height: 44.h,
      width: double.infinity,
      padding: EdgeInsets.only(left: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (_dropdownMenuController.isShow)
                _dropdownMenuController.hide();
              else
                _dropdownMenuController.show(0);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(model.title, style: Theme.of(context).textTheme.headline6),
                SizedBox(
                  width: 10.w,
                ),
                Icon(Icons.arrow_drop_down),
                // SvgPicture.asset(
                //     ImageHelper.wrapAssets("icon_selectnum_down.svg"))
              ],
            ),
          ),
          Row(
            children: [
              Visibility(
                  visible: model.showEditIcon(),
                  child: InkWell(
                    onTap: () {
                      if (model.list.isNotEmpty)
                        return model.updateOnEdit(true);
                    },
                    child: SvgPicture.asset(
                        Theme.of(context).brightness == Brightness.light
                            ? ImageHelper.wrapAssets("nav_icon_edit.svg")
                            : ImageHelper.wrapAssets("nav_icon_edit_dark.svg")),
                  )),
              SizedBox(
                width: 24.w,
              ),
              Container(
                margin: const EdgeInsets.only(right: 15),
                alignment: Alignment.center,
                child: model.onEdit
                    ? InkWell(
                        onTap: () {
                          model.updateOnEdit(false);
                        },
                        child: Text(
                          "取消",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .change(context, fontWeight: FontWeight.normal),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              //跳转到搜索页面
                              new MaterialPageRoute(
                                  builder: (context) => new SearchPageWidget(
                                        onSelectcontact: false,
                                      )));
                        },
                        child: SvgPicture.asset(
                          Theme.of(context).brightness == Brightness.light
                              ? ImageHelper.wrapAssets("nav_icon_search.svg")
                              : ImageHelper.wrapAssets(
                                  "nav_icon_search_dark.svg"),
                          fit: BoxFit.contain,
                          height: 24.h,
                          width: 24.w,
                        )),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _delWidget(BuildContext context, HomeCallListModel model) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          //卡片阴影
          BoxShadow(
              color: Colour.f99E4E4E4,
              // offset: Offset(1.0, 1.0),
              blurRadius: 4.0)
        ],
      ),
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              model.setCheckedAll(!model.isCheckedAll());
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  model.isCheckedAll()
                      ? ImageHelper.wrapAssets("phone_radio_selected.svg")
                      : context.isBrightness
                          ? ImageHelper.wrapAssets("phone_radio_unselected.svg")
                          : ImageHelper.wrapAssets(
                              "phone_radio_unselected_dark.svg"),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  model.isCheckedAll() ? "取消全选" : "全选",
                  style: TextStyle(
                      color: context.isBrightness
                          ? Colour.titleColor
                          : Colour.cFFE2E2E2,
                      fontSize: 16),
                ),
              ],
            ),
          ),
          Spacer(),
          Text(
            "已选择" + model.selectedMap.length.toString() + "项",
            style: TextStyle(
                color: Colour.body2Color,
                fontSize: 14,
                fontWeight: FontWeight.normal),
          ),
          Spacer(),
          TextButton(
              onPressed: () {
                if (model.selectedMap.length == 0) {
                  showToast('请先选择通话记录');
                  return;
                }
                CustomAlertDialog.showAlertDialog(
                    context,
                    "'删除'",
                    "确认删除选中的通话记录？",
                    S.of(context).actionCancel,
                    S.of(context).actionConfirm,
                    180, (value) {
                  if (value == 1) {
                    model.deleteSelectedRecords();
                    showToast('删除成功');
                  }
                }, true);
              },
              style: ButtonStyle(
                //设置按钮的大小
                minimumSize: MaterialStateProperty.all(Size(70.w, 34.h)),
                //背景颜色
                //背景颜色
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  //设置按下时的背景颜色
                  if (states.contains(MaterialState.pressed)) {
                    // return Colour.fEE4452.withAlpha(10);
                  }
                  //默认不使用背景颜色
                  return Colour.fEE4452;
                }),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
              ),
              child: Text(
                "删除",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .change(context, color: Colour.backgroundColor2),
              ))
        ],
      ),
    );
  }

  Widget _emptyDataWidget(BuildContext context, HomeCallListModel model) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            height: 109.h,
          ),
          SvgPicture.asset(context.isBrightness
              ? ImageHelper.wrapAssets("img_calllogs_empty.svg")
              : ImageHelper.wrapAssets("img_calllogs_empty_dark.svg")),
          SizedBox(
            height: 10.h,
          ),
          Text(
            "没有通话记录，打个电话试试吧",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }

  Widget _buildDataWidget(BuildContext context, HomeCallListModel model,
      RefreshController controller) {
    model.setRefreshController(controller);
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        //开始滚动
        if (notification is ScrollStartNotification) {
        } else if (notification is ScrollUpdateNotification) {
          model.updateShowPad(false);
        } else if (notification is ScrollEndNotification) {
          //结束滚动
        }
        return false;
      },
      child: SmartRefresher(
        controller: model.refreshController,
        header: WaterDropHeader(),
        footer: RefresherFooter(),
        onRefresh: model.refresh,
        onLoading: model.loadMore,
        enablePullUp: true,
        enablePullDown: true,
        child: _bulidListView(context, model),
      ),
    );
  }

  Widget _buildDataWidget2(BuildContext context, HomeCallListModel model) {
    return PageView(
      scrollDirection: Axis.horizontal,
      reverse: false,
      controller: PageController(
        initialPage: 0,
        viewportFraction: 1,
        keepPage: true,
      ),
      physics: BouncingScrollPhysics(),
      pageSnapping: true,
      onPageChanged: (index) {
        //监听事件
        model.changeTab(index);
      },
      children: [
        _buildDataWidget(context, model, model.refreshController),
        _buildDataWidget(context, model, _refreshMissedController),
      ],
    );
  }

  Widget _fenjiContactWidget(BuildContext context, HomeCallListModel model) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;

    ExContact? exContact = model.exContact;
    return exContact == null
        ? SizedBox()
        : Column(
            children: [
              InkWell(
                  onTap: () async {
                    eventBus
                        .fire(CallPadNumRefreshEvent(model.exContact!.mobile));
                    model.updateShowEmployee(false);
                  },
                  child: Container(
                    height: 68.h,
                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colour.getContactColor(0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.w))),
                              // color: Colors.red,
                              width: 40.w,
                              height: 40.w,
                              child: Center(
                                child: Text(
                                  model.exContact!.userName.substring(
                                      model.exContact!.userName.length - 1,
                                      model.exContact!.userName.length),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                        Positioned(
                            left: 55.w,
                            top: 0,
                            bottom: 0,
                            right: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  exContact.userName,
                                  maxLines: 1,
                                  style: subtitle1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      exContact.mobile,
                                      style: subtitle2,
                                    ),
                                    Text(
                                      '分机号:${exContact.number}',
                                      style: subtitle2,
                                    ),
                                  ],
                                )
                              ],
                            ))
                      ],
                    ),
                  )),
              Divider(
                height: 1,
                color:
                    context.isBrightness ? Colour.dividerColor : Colour.f1A1A1A,
              ),
            ],
          );
  }

  Widget _bulidListView(BuildContext context, HomeCallListModel model) {
    return ListView.builder(
        itemCount: model.getCurrentList().length,
        itemBuilder: (context, index) {
          CallRecord item = model.getCurrentList()[index];
          return Column(
            children: [
              InkWell(
                  onTap: () async {
                    model.onEdit
                        ? model.addSelected(item)
                        : Navigator.of(context)
                            .pushNamed(RouteName.callInfoPage, arguments: item);
                  },
                  onLongPress: () async {
                    model.updateShowPad(false);
                    bool containLocalContact =
                        item.contactType == '0' ? false : true;
                    List<String> list = containLocalContact
                        ? ['删除']
                        : [
                            '新建联系人',
                            '添加联系人',
                            '删除',
                          ];
                    model.onEdit
                        ? model.addSelected(item)
                        : ListViewDialog.showCustomDialog(context, list)
                            .then((title) {
                            if (title == '新建联系人') {
                              _insertContact(item.number);
                              //关闭弹框
                            } else if (title == '添加联系人') {
                              //关闭弹框
                              Navigator.of(context)
                                  .pushNamed(RouteName.chooseContactPage,
                                      arguments: item)
                                  .then((value) {
                                _homeCallListModel.refresh(pageFirst: 1);
                              });
                            } else if (title == '删除') {
                              CustomAlertDialog.showAlertDialog(
                                  context,
                                  "'删除'",
                                  "确认删除选中的通话记录？",
                                  S.of(context).actionCancel,
                                  S.of(context).actionConfirm,
                                  180, (value) {
                                if (value == 1) model.deleteRecord(item);
                              }, true);
                            }
                          });
                  },
                  onDoubleTap: model.onEdit
                      ? () {
                          model.addSelected(item);
                        }
                      : null,
                  child: _buildItem(context, model, item)),
              Divider(
                height: 1,
                color:
                    context.isBrightness ? Colour.dividerColor : Colour.f1A1A1A,
              ),
            ],
          );
          // return Text(item.toString());
        });
  }

  Widget _buildItem(
      BuildContext context, HomeCallListModel model, CallRecord record) {
    int callType = record.getCallType();
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    TextStyle caption = textTheme.caption!;
    Log.d("${record.toString()}");
    return Container(
      height: 75.h,
      color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        children: [
          Visibility(
            visible: model.onEdit,
            child: Container(
              margin: EdgeInsets.only(right: 15.w),
              child: SvgPicture.asset(model.isChecked(record)
                  ? ImageHelper.wrapAssets("phone_radio_selected.svg")
                  : context.isBrightness
                      ? ImageHelper.wrapAssets("phone_radio_unselected.svg")
                      : ImageHelper.wrapAssets(
                          "phone_radio_unselected_dark.svg")),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    callType == CallRecord.CAll_OUT
                        ? ImageHelper.wrapAssets("list_icon_call.svg")
                        : (callType == CallRecord.CAll_IN
                            ? ImageHelper.wrapAssets("list_icon_inbound.svg")
                            : (callType == CallRecord.CAll_OUT_MISSED
                                ? ImageHelper.wrapAssets(
                                    "list_icon_missedcall.svg")
                                : (callType == CallRecord.CAll_IN_MISSED
                                    ? ImageHelper.wrapAssets(
                                        "list_icon_missed.svg")
                                    : ImageHelper.wrapAssets(
                                        "list_icon_missed.svg")))),
                    width: 14.w,
                    height: 14.w,
                  ),
                  SizedBox(width: 11.w),
                  Text(
                    record.name,
                    style: callType == CallRecord.CAll_IN_MISSED
                        ? TextStyle(
                            fontSize: 16,
                            color: Colour.fEE4452,
                            fontWeight: FontWeight.bold)
                        : subtitle1.change(context,
                            fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  SizedBox(width: 26.w),
                  Text(
                    record.region,
                    style: caption.change(context, color: Colour.c0xFF6B7686),
                  ),
                  Visibility(
                      visible: record.region != " " && record.region.isNotEmpty,
                      child: SizedBox(
                        width: 11.w,
                      )),
                  Text(
                    record.duration == 0
                        ? '  '
                        : (record.duration <= 60
                            ? record.duration.toString() + "秒"
                            : TimeUtil.constructCallTime(record.duration)),
                    style: caption.change(context, color: Colour.c0x0F88FF),
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          // Spacer(flex: 2),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                TimeUtil.formatCallTimeWithreg(record.time),
                style: subtitle2.change(context, color: Colour.hintTextColor),
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  SvgPicture.asset(
                      ImageHelper.wrapAssets("icon_blue_iphone.svg")),
                  SizedBox(
                    width: 3.w,
                  ),
                  Text(
                    // model.title == '全部'
                    //     ? record.isCallOut
                    //         ? "${record.calleridNumber!}"
                    //         : "${record.destinationNumber!}"
                    //     : '${model.title}',
                    '${model.getDisplayNum(record)}',
                    style: subtitle2.change(context, color: Colour.c0xFF6B7686),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  _buildConditionListWidget(
      items, void itemOnTap(SortCondition sortCondition)) {
    return ListView.separated(
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
        return gestureDetector(items, index, itemOnTap, context);
      },
    );
  }

  GestureDetector gestureDetector(items, int index,
      void itemOnTap(SortCondition sortCondition), BuildContext context) {
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
        //            color: Colors.blue,
        height: 61.h,
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
                      ? Colour.primaryColor
                      : context.isBrightness
                          ? Colour.cFF212121
                          : Colors.white,
                ),
              ),
            ),
            goodsSortCondition.isSelected
                ? SvgPicture.asset(
                    ImageHelper.wrapAssets("icon_selectnum_checked.svg"))
                : SizedBox(),
            SizedBox(
              width: 15.w,
            ),
          ],
        ),
      ),
    );
  }

  void _doSysCallOut(
      BuildContext context, String number, HomeCallListModel model) async {
    if (Platform.isIOS) {
      _sysCall(number);
      return;
    }
    if (!await Permission.phone.isGranted) {
      CustomPermissionAlertDialog.showAlertDialog(
          context,
          S.of(context).open_permission_call,
          Theme.of(context).brightness == Brightness.light
              ? 'icon_call.svg'
              : 'icon_call_dark.svg', (value) async {
        if (await Permission.phone.request().isGranted) {
          _sysCall(number);
        }
      }, true);
    } else {
      _sysCall(number);
    }
  }

  Future<void> _sysCall(String number) async {
    Log.e('zhangmin--$number');
    if (!number.startsWith('95013')) number = "95013" + number;
    String url = 'tel:' + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// 新建联系人
  Future _insertContact(String number) async {
    LocalContact? localContact = await contactRepo.insertContact(number);
    if (localContact != null) {
      Log.d("_insertContact 添加成功： ${localContact.toJson()}");
      _homeCallListModel.refresh(pageFirst: 1);
    }
  }
}

class SortCondition {
  String name;
  bool isSelected;

  SortCondition({
    required this.name,
    required this.isSelected,
  });
}
