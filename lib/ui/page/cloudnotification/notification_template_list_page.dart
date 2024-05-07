import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/model/notification_model_result.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/ui/widget/custom_alert_dialog.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'viewmodel/notification_temple_model.dart';

///
/// @Desc: 通知模版
/// @Author: zhhli
/// @Date: 2021-03-18
///

class NotificationTemListPage extends StatefulWidget {
  final String number;

  NotificationTemListPage(this.number);

  @override
  _NotificationTemListPageState createState() =>
      _NotificationTemListPageState();
}

class _NotificationTemListPageState extends State<NotificationTemListPage> {
  NotificationTempleModel _model = NotificationTempleModel();

  @override
  void initState() {
    super.initState();
    _model.refresh(init: true);
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text("通知模版"),
          leading: new IconButton(
              icon: SvgPicture.asset(ImageHelper.wrapAssets(
                  Theme.of(context).brightness == Brightness.light
                      ? "nav_icon_return.svg"
                      : "nav_icon_return_sel.svg")),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ProviderWidget(
            model: _model,
            builder: (context, NotificationTempleModel model, child) {
              if (model.isBusy) {
                EasyLoading.show();
              }
              if (model.isIdle) {
                EasyLoading.dismiss();
              }

              return Column(children: [
                SizedBox(height: 12.h),
                // flase
                //     ? Container(
                //         child: SvgPicture.asset(
                //           ImageHelper.wrapAssets(context.isBrightness
                //               ? "noblacklist_pic.svg"
                //               : "noblacklist_pic.svg"),
                //           fit: BoxFit.cover,
                //           width: 320.w,
                //           height: 320.h,
                //         ),
                //       )
                // :
                Container(
                  padding: EdgeInsets.only(bottom: 7.h),
                  height: 620.h,
                  // color: Colors.white,
                  child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: WaterDropHeader(),
                      footer: CustomFooter(
                        builder: (BuildContext context, LoadStatus? mode) {
                          Widget body;
                          if (mode == LoadStatus.idle) {
                            body = Text("加载中...");
                          } else if (mode == LoadStatus.loading) {
                            body = CircularProgressIndicator();
                          } else if (mode == LoadStatus.failed) {
                            body = Text("加载失败！点击重试！");
                          } else if (mode == LoadStatus.canLoading) {
                            body = Text("加载更多");
                          } else {
                            body = Text("暂无更多数据");
                          }
                          return Container(
                            height: 53.0,
                            child: Center(child: body),
                          );
                        },
                      ),
                      controller: _model.refreshController,
                      onRefresh: _model.refresh,
                      onLoading: _model.loadMore,
                      child: _model.isEmpty
                          ? Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.fromLTRB(
                                        78.w, 153.h, 78.w, 0),
                                    child: SvgPicture.asset(
                                        ImageHelper.wrapAssets(
                                            "notification_nomodel.svg"))),
                                SizedBox(
                                  height: 9.h,
                                ),
                                Text(
                                  "暂无模版内容",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16, color: Colour.cFF999999),
                                )
                              ],
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _model.list.length,
                              itemBuilder: (context, index) {
                                return _cellForRow(context, index, model);
                              })),
                ),
                SizedBox(width: 15.w, height: 20.h),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.addNoticeTemPage)
                        .then((value) {
                      _model.refresh();
                    });
                  },
                  child: Container(
                    width: 345.w,
                    height: 45.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colour.primaryColor,
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      child: Text(
                        "新增模版",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ]);
            }));
  }

  Widget _cellForRow(
      BuildContext context, int index, NotificationTempleModel model) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    NotificationTemple temple = _model.list[index];

    return Container(
        margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
        padding:
            EdgeInsets.only(top: 0.h, left: 15.w, bottom: 15.h, right: 15.w),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colour.f1A1A1A,
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // color: Colors.teal,
              child: Row(
                children: [
                  Container(
                    // 最大宽度
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 2,
                    ),
                    child: Text(
                      temple.templateName.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: subtitle1.change(context, color: Colour.f18),
                    ),
                  ),
                  SizedBox(width: 7.w),
                  Container(
                      // padding: EdgeInsets.only(top: 2.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? (temple.status == 0 || temple.status == 4)
                                ? Colour.FFFCAD0C.withAlpha(10)
                                : temple.status == 1
                                    ? Colour.FF19BA6C.withAlpha(10)
                                    : Colour.FFFEE7E5
                            : (temple.status == 0 || temple.status == 4)
                                ? Colour.FFFCAD0C.withAlpha(38)
                                : temple.status == 1
                                    ? Colour.FF19BA6C.withAlpha(38)
                                    : Colour.FFFEE7E5.withAlpha(38),
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      ),
                      child: (temple.status == 0 || temple.status == 4)
                          ? Text("审核中",
                              style: TextStyle(
                                  color: Colour.FFFCAD0C, fontSize: 12),
                              textAlign: TextAlign.center)
                          : temple.status == 1
                              ? Text("已通过",
                                  style: TextStyle(
                                      color: Colour.FF19BA6C, fontSize: 12),
                                  textAlign: TextAlign.center)
                              : Text("未通过",
                                  style: TextStyle(
                                      color: Colour.FFF25643, fontSize: 12),
                                  textAlign: TextAlign.center)),

                  //占位，撑开
                  Spacer(),
                  // Opacity 隐藏时，实现占位
                  Opacity(
                    opacity:
                        temple.status != 0 && temple.status != 4 ? 1.0 : 0.0,
                    child: InkWell(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 10.w),
                          child: SvgPicture.asset(
                            ImageHelper.wrapAssets("enterpriseinfo_edit.svg"),
                            width: 16.w,
                          )),
                      onTap: () {
                        Navigator.pushNamed(context, RouteName.addNoticeTemPage,
                                arguments: temple)
                            .then((value) {
                          _model.refresh();
                        });
                      },
                    ),
                  ),
                  Opacity(
                    opacity:
                        temple.status != 0 && temple.status != 4 ? 1.0 : 0.0,
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.h, horizontal: 10.w),
                        child: SvgPicture.asset(
                          ImageHelper.wrapAssets("blacknumber_delete.svg"),
                          width: 16.w,
                        ),
                      ),
                      onTap: () {
                        CustomAlertDialog.showAlertDialog(
                            context,
                            "删除",
                            "确认删除此模版？",
                            S.of(context).actionCancel,
                            S.of(context).actionConfirm,
                            180, (value) async {
                          if (value == 1) {
                            bool result =
                                await model.deleteNotificationModel(temple);
                            if (result == true) {
                              showToast("删除模版成功");
                            } else {
                              showToast("删除模版失败");
                            }
                          }
                        }, true);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
                height: 1.h,
                color: context.isBrightness
                    ? Colour.dividerColor
                    : Colour.c1AFFFFFF),
            SizedBox(height: 15.h),
            Container(
              // 最小高度 40.h
              constraints: BoxConstraints(minHeight: 40.h),
              child: Text(
                temple.templateContent.toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colour.cFF666666
                        : Colour.fffffff.withAlpha(60),
                    fontSize: 14),
              ),
            ),
          ],
        ));
  }
}
