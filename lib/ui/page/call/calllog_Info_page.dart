import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/event/call_list_refresh_event.dart';
import 'package:weihua_flutter/model/call_record.dart';
import 'package:weihua_flutter/model/local_contact.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/service/contact_repository.dart';
import 'package:weihua_flutter/service/event_bus.dart';
import 'package:weihua_flutter/service/function_permission_help.dart';
import 'package:weihua_flutter/ui/page/call/view_model/call_info_model.dart';
import 'package:weihua_flutter/ui/widget/common_widget.dart';
import 'package:weihua_flutter/ui/widget/custom_alert_dialog.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/time_util.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../widget/call_contact_widget.dart';

class CallInfoPage extends StatefulWidget {
  late final CallRecord record;

  CallInfoPage(this.record);

  @override
  _CallInfoPageState createState() => _CallInfoPageState();
}

class _CallInfoPageState extends State<CallInfoPage> {
  int limitCount = 20;
  late CallInfoModel callInfoModel;
  late String number;

  bool _pinned = true;
  bool _snap = true;
  bool _floating = true;

  @override
  void initState() {
    super.initState();
    number = widget.record.number;
    callInfoModel = CallInfoModel(widget.record);
    callInfoModel.refresh(init: true);
  }

  ///显示底部弹框的功能--更多
  ///
  /// unknown 是否是未知联系人
  void showMoreBottomSheet(BuildContext context, bool unknown) {
    List<Widget> widgetList = unknown
        ? [
            BottomItemWidget('新建联系人', onTap: () => _insertNewContact),
            MyDivider(),
            BottomItemWidget('添加到联系人', onTap: () => _addChooseContact),
            MyDivider(),
          ]
        : [];

    widgetList.addAll([
      BottomItemWidget('删除', onTap: () {
        CustomAlertDialog.showAlertDialog(
            context, "提示", "确认删除通话记录？", "取消", "确认", 180, (value) async {
          if (value == 1) {
            EasyLoading.show(status: "删除中");
            await callInfoModel.delRecord(widget.record).then((value) {
              EasyLoading.dismiss();
              if (value) {
                Future.delayed(Duration(milliseconds: 2000), () {
                  showToast("删除成功");
                  eventBus.fire(CallListRefreshEvent(true));
                  Navigator.of(context).pop();
                });
              } else {
                showToast("删除失败");
              }
            });
            // 退出页面
          }
        }, true);
      }),
      BlankDivider(),
      BottomItemWidget('取消')
    ]);

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widgetList,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidgetNoConsumer(
        model: callInfoModel, onModelReady: (model) {}, child: _scf());
  }

  Widget _scf() {
    return Scaffold(
      body: Consumer<CallInfoModel>(
        builder: (_, model, child) {
          return SmartRefresher(
            controller: model.refreshController,
            // header: WaterDropHeader(),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("更多通话记录");
                } else if (mode == LoadStatus.loading) {
                  body = CircularProgressIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("release to load more");
                } else {
                  body = Text("没有更多记录了");
                }
                return Container(
                  height: 58.h,
                  child: Center(child: body),
                  color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
                );
              },
            ),
            onRefresh: model.refresh,
            onLoading: model.loadMore,
            enablePullUp: true,
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                SliverToBoxAdapter(
                  child: Consumer<CallInfoModel>(
                    builder: (_, model, child) {
                      return CallNumberItemWidget(
                          number: number,
                          subTitle: model.numberSubTitle,
                          hasPSTN: UserPermissionHelp.enablePSTNCall() &&
                              !model.isExNumber,
                          hasVoIP: UserPermissionHelp.enableVoIPCall(),
                          isExNumber: model.isExNumber,
                          onRefresh: (_) {
                            Log.d('刷新');
                            callInfoModel.refresh();
                          });
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: BlankDivider(),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 12.h),
                      child: Text("通话记录"),
                      alignment: Alignment.topLeft,
                    ),
                    color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
                  ),
                ),
                Consumer<CallInfoModel>(
                    builder: (context, model, child) => SliverList(
                            delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            CallRecord item = model.list[index];
                            return Container(
                                padding: EdgeInsets.all(0.0),
                                height: 68.h,
                                child: _buildListItem(context, item));
                          },
                          childCount: model.list.length,
                        ))),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Offstage(
        offstage: true,
        child: BottomAppBar(
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Text('pinned'),
                  Switch(
                    onChanged: (bool val) {
                      setState(() {
                        _pinned = val;
                      });
                    },
                    value: _pinned,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const Text('snap'),
                  Switch(
                    onChanged: (bool val) {
                      setState(() {
                        _snap = val;
                        // Snapping only applies when the app bar is floating.
                        _floating = _floating || _snap;
                      });
                    },
                    value: _snap,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const Text('floating'),
                  Switch(
                    onChanged: (bool val) {
                      setState(() {
                        _floating = val;
                        _snap = _snap && _floating;
                      });
                    },
                    value: _floating,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: _pinned,
      snap: _snap,
      floating: _floating,
      expandedHeight: 280.h,
      flexibleSpace: Container(
        height: 280.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: [
              Color.fromRGBO(71, 117, 253, 1.0),
              Color.fromRGBO(69, 143, 249, 1.0),
            ],
          ),
        ),
      ),
      // flexibleSpace: Placeholder(),
      title: Text(''),
      elevation: 0,
      leading: IconButton(
          icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
              ? "nav_icon_return_white.svg"
              : "nav_icon_return_sel.svg")),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context, true);
          }),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset(ImageHelper.wrapAssets("nav_icon_more.svg")),
          onPressed: () async {
            Log.d("点击 顶部更多，显示添加联系人等");
            bool unknown = widget.record.contactType == '0';
            showMoreBottomSheet(context, unknown);
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(215.h),
        child: Stack(
          children: [
            Positioned(
              child: Container(
                height: 215.h,
              ),
            ),
            Positioned(
                top: 68.h,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
                  ),
                  height: 215.h,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      SizedBox(height: 55.h),
                      Consumer<CallInfoModel>(
                          builder: (context, model, child) => Visibility(
                                child: Text(
                                  model.record.name,
                                  style: TextStyle().change(context,
                                      color: Colour.titleColor, fontSize: 24),
                                ),
                              )),
                      SizedBox(height: 6.h),
                      Text(
                        number,
                        style: TextStyle().change(context,
                            color: Colour.titleColor, fontSize: 14),
                      ),
                      SizedBox(height: 33.h),
                      MyDivider(),
                    ],
                  ),
                )),
            Positioned(
              top: 5.h,
              left: 144.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      height: 86.w,
                      width: 86.w,
                      color:
                          context.isBrightness ? Colors.white : Colour.f1A1A1A,
                    ),
                  ),
                  widget.record.realName == ''
                      ? SvgPicture.asset(
                          ImageHelper.wrapAssets("pic_head_unknown.svg"),
                          fit: BoxFit.cover,
                          width: 80.w,
                          height: 80.w,
                        )
                      : Container(
                          alignment: Alignment(0, 0),
                          width: 80.w,
                          height: 80.w,
                          child: Consumer<CallInfoModel>(
                              builder: (context, model, child) => Text(
                                    model.getTitleName(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  )),
                          decoration: new BoxDecoration(
                            color: context.isBrightness
                                ? Color.fromRGBO(135, 191, 255, 1.0)
                                : Color.fromRGBO(176, 184, 193, 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.w)),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Widget _scf1() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          height: 215,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color.fromRGBO(71, 117, 253, 1.0),
                Color.fromRGBO(69, 143, 249, 1.0),
              ],
            ),
          ),
        ),
        // flexibleSpace: Placeholder(),
        title: Text(''),
        elevation: 0,
        backwardsCompatibility: false,
        leading: IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return_white.svg"
                : "nav_icon_return_sel.svg")),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context, true);
            }),
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets("nav_icon_more.svg")),
            onPressed: () async {
              Log.d("点击 顶部更多，显示添加联系人等");
              bool unknown = widget.record.contactType == '0';
              showMoreBottomSheet(context, unknown);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(215.h),
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  height: 215.h,
                ),
              ),
              Positioned(
                  top: 68.h,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                      color:
                          context.isBrightness ? Colors.white : Colour.f1A1A1A,
                    ),
                    height: 215.h,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(height: 55.h),
                        Consumer<CallInfoModel>(
                            builder: (context, model, child) => Visibility(
                                  child: Text(
                                    model.record.name,
                                    style: TextStyle().change(context,
                                        color: Colour.titleColor, fontSize: 24),
                                  ),
                                )),
                        SizedBox(height: 6.h),
                        Text(
                          number,
                          style: TextStyle().change(context,
                              color: Colour.titleColor, fontSize: 14),
                        ),
                        SizedBox(height: 33.h),
                        MyDivider(),
                      ],
                    ),
                  )),
              Positioned(
                top: 5.h,
                left: 144.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: Container(
                        height: 86.w,
                        width: 86.w,
                        color: context.isBrightness
                            ? Colors.white
                            : Colour.f1A1A1A,
                      ),
                    ),
                    widget.record.realName == ''
                        ? SvgPicture.asset(
                            ImageHelper.wrapAssets("pic_head_unknown.svg"),
                            fit: BoxFit.cover,
                            width: 80.w,
                            height: 80.w,
                          )
                        : Container(
                            alignment: Alignment(0, 0),
                            width: 80.w,
                            height: 80.w,
                            child: Consumer<CallInfoModel>(
                                builder: (context, model, child) => Text(
                                      model.getTitleName(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                      ),
                                    )),
                            decoration: new BoxDecoration(
                              color: context.isBrightness
                                  ? Color.fromRGBO(135, 191, 255, 1.0)
                                  : Color.fromRGBO(176, 184, 193, 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.w)),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Consumer<CallInfoModel>(
            builder: (_, model, child) {
              return CallNumberItemWidget(
                  number: number,
                  subTitle: model.numberSubTitle,
                  hasPSTN:
                      UserPermissionHelp.enablePSTNCall() && !model.isExNumber,
                  hasVoIP: UserPermissionHelp.enableVoIPCall(),
                  isExNumber: model.isExNumber,
                  onRefresh: (_) {
                    Log.d('刷新');
                    callInfoModel.refresh();
                  });
            },
          ),
          BlankDivider(),
          Container(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
              child: Text("通话记录"),
              alignment: Alignment.topLeft,
            ),
            color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
          ),
          Consumer<CallInfoModel>(
              builder: (context, model, child) => Visibility(
                      child: Expanded(
                          child: SmartRefresher(
                    controller: model.refreshController,
                    // header: WaterDropHeader(),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus? mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = Text("更多通话记录");
                        } else if (mode == LoadStatus.loading) {
                          body = CircularProgressIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = Text("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = Text("release to load more");
                        } else {
                          body = Text("没有更多记录了");
                        }
                        return Container(
                          height: 58.h,
                          child: Center(child: body),
                          color: context.isBrightness
                              ? Colors.white
                              : Colour.f1A1A1A,
                        );
                      },
                    ),
                    onRefresh: model.refresh,
                    onLoading: model.loadMore,
                    enablePullUp: true,
                    // enablePullDown: true,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(0.0),
                        reverse: false,
                        primary: true,
                        itemExtent: 68.h,
                        shrinkWrap: true,
                        itemCount: model.list.length,
                        cacheExtent: 10.0,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          CallRecord item = model.list[index];

                          return _buildListItem(context, item);
                        }),
                  )))),
        ],
      ),
    );
  }*/

  Widget _buildListItem(BuildContext context, CallRecord item) {
    int callType = item.getCallType();
    String image = ImageHelper.wrapAssets("list_icon_missed.svg");

    if (callType == CallRecord.CAll_OUT) {
      image = ImageHelper.wrapAssets("list_icon_call.svg");
    } else if (callType == CallRecord.CAll_IN) {
      image = ImageHelper.wrapAssets("list_icon_inbound.svg");
    } else if (callType == CallRecord.CAll_OUT_MISSED) {
      image = ImageHelper.wrapAssets("list_icon_missedcall.svg");
    } else if (callType == CallRecord.CAll_IN_MISSED) {
      image = ImageHelper.wrapAssets("list_icon_missed.svg");
    }
    String day = TimeUtil.formatCallTime(item.time).split(' ')[0];

    return Container(
      child: Container(
        height: 68.h,
        color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
        child: Row(
          children: [
            SizedBox(width: 15.w),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 12.h),
                    Text(
                      day,
                      style: TextStyle(
                          color: context.isBrightness
                              ? Colour.f333333
                              : Color.fromRGBO(255, 255, 255, 0.87),
                          fontSize: 14),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: <Widget>[
                        SvgPicture.asset(image),
                        SizedBox(width: 2),
                        Text(TimeUtil.formatTimeDayWithreg(item.time, "HH:mm"),
                            style: TextStyle(
                                color: context.isBrightness
                                    ? Color.fromRGBO(153, 153, 153, 1.0)
                                    : Color.fromRGBO(255, 255, 255, 0.6),
                                fontSize: 14)),
                      ],
                    ),
                    // SizedBox(height: 12.h),
                  ],
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 15.w, 0),
                child: Text(
                    item.duration <= 60
                        ? item.duration.toString() + "秒"
                        : TimeUtil.constructCallTime(item.duration),
                    style: TextStyle(
                        color: context.isBrightness
                            ? Color.fromRGBO(153, 153, 153, 1.0)
                            : Colour.f99ffffff,
                        fontSize: 14))),
          ],
        ),
      ),
    );
  }

  Future _insertNewContact() async {
    LocalContact? localContact = await contactRepo.insertContact(number);

    if (localContact != null) {
      Log.d("_insertContact 添加成功： ${localContact.toJson()}");
      Log.v("刷新 数据");
      callInfoModel.updateName(localContact);
      eventBus.fire(CallListRefreshEvent(true));
    }
  }

  void _addChooseContact() {
    Navigator.of(context)
        .pushNamed(RouteName.chooseContactPage, arguments: callInfoModel.record)
        .then((value) {
      if (value != null) {
        Log.v("刷新 数据");
        LocalContact contact = value as LocalContact;
        callInfoModel.updateName(contact);
      }
    });
  }
}
