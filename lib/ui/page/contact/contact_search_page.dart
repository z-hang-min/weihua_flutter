import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/config/storage_manager.dart';
import 'package:weihua_flutter/model/call_record.dart';
import 'package:weihua_flutter/model/enterprise_address_book.dart';
import 'package:weihua_flutter/model/ex_contacts_result.dart';
import 'package:weihua_flutter/model/local_contact.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/ui/page/contact/contact_info_page.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/contact_ui.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/search_contact_result_model.dart';
import 'package:weihua_flutter/ui/widget/custom_alert_dialog.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:weihua_flutter/utils/time_util.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'search_listview.dart';
import 'search_more_result_page.dart';

class SearchPageWidget extends StatefulWidget {
  final bool onSelectcontact;

  SearchPageWidget({Key? key, required this.onSelectcontact}) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPageWidget> {
  String searchStr = "";
  List<String> history = [];
  static const String headTag = "↑";
  late SearchContactModel searchContactModel;
  final TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    List<String>? list =
        StorageManager.sharedPreferences!.getStringList('historysearch');
    history = list ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidgetNoConsumer<SearchContactModel>(
        model: SearchContactModel(),
        onModelReady: (model) {
          model.loadData();
          searchContactModel = model;
        },
        child: Container(
          color: context.isBrightness ? Colors.white : Colour.f111111,
          child: Column(
            children: <Widget>[
              Consumer<SearchContactModel>(builder: (context, model, child) {
                return _buildSearchTitleWidget(context);
              }),
              Container(
                child: Consumer<SearchContactModel>(
                    builder: (context, model, child) {
                  return _bodyWidgets(context);
                }),
              ),
            ],
          ),
        ));
  }

  /// 搜索栏
  Widget _buildSearchTitleWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
              margin: EdgeInsets.fromLTRB(15.w, 44.h, 0, 0),
              padding: EdgeInsets.symmetric(vertical: 0.h),
              height: 44.h,
              // width: 294.w,
              decoration: BoxDecoration(
                color: context.isBrightness
                    ? Colour.cFFF7F8F9
                    : Colour.f0x1AFFFFFF,
                borderRadius: BorderRadius.all(Radius.circular(18.0)),
              ),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextFormField(
                    controller: controller,
                    cursorColor: Color.fromRGBO(25, 186, 108, 1.0),
                    // cursorHeight: 18.h,
                    autofocus: true,
                    maxLines: 1,
                    minLines: 1,
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                    textInputAction: TextInputAction.search,
                    style: TextStyle(fontSize: 14),
                    // inputFormatters: [
                    //   LengthLimitingTextInputFormatter(25) //限制长度
                    // ],
                    decoration: InputDecoration(
                        filled: false,
                        // contentPadding: EdgeInsets.fromLTRB(0, -0.h, 0, 0),
                        contentPadding: EdgeInsets.all(0),
                        hintText: ' 请输入姓名或号码',
                        hintStyle: TextStyle().change(context,
                            color: Color.fromRGBO(153, 153, 153, 1.0),
                            fontSize: 14),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: new OutlineInputBorder(
                          //没有焦点时
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: new OutlineInputBorder(
                          //有焦点时
                          borderSide: BorderSide.none,
                        ),
                        prefixIconConstraints: BoxConstraints(
                            //添加内部图标之后，图标和文字会有间距，实现这个方法，不用写任何参数即可解决
                            ),
                        prefixIcon: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 8),
                          child: SvgPicture.asset(
                              ImageHelper.wrapAssets("search_icon.svg"),
                              fit: BoxFit.cover,
                              width: 20.w,
                              height: 20.w),
                          // myIcon is a 48px-wide widget.
                        )),

                    onFieldSubmitted: (String value) {
                      saveHistoryData();
                      // print("点击了键盘上 ${value}");
                    },
                    onChanged: (value) {
                      Log.d("搜索输入 $value");
                      searchStr = value.trim();
                      searchContactModel.search(searchStr);
                    },
                  ),
                  //清空按钮
                  Visibility(
                    child: IconButton(
                        iconSize: 20.w,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(0.w),
                        icon: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 8),
                          child: SvgPicture.asset(
                              ImageHelper.wrapAssets(
                                  "search_icon_deleteall.svg"),
                              fit: BoxFit.cover,
                              width: 20.w,
                              height: 20.w),
                          // myIcon is a 48px-wide widget.
                        ),
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              controller.text = "";
                              searchStr = "";
                            });
                          }
                        }),
                    visible: controller.text.length == 0 ? false : true,
                  )
                ],
              )),
        ),
        Container(
          child: TextButton(
            child: Text(
              '取消',
              style: context.isBrightness
                  ? TextStyle().change(context,
                      color: Color.fromRGBO(33, 33, 33, 1.0),
                      fontSize: 18,
                      fontWeight: FontWeight.normal)
                  : TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.87),
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
            ),
            onPressed: () {
              controller.clear();
              Navigator.pop(context);
            },
          ),
          margin: EdgeInsets.fromLTRB(0, 44.h, 0, 0),
        ),
      ],
    );
  }

  Widget _bodyWidgets(BuildContext context) {
    if (searchStr == '') {
      return _historyDisplay(context);
    } else {
      return _realTimeSearch(context, searchStr);
    }
  }

  ///默认显示历史记录
  Widget _historyDisplay(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    "搜索历史",
                    style: context.isBrightness
                        ? TextStyle().change(context,
                            color: Colour.hintTextColor, fontSize: 16)
                        : TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.87),
                            fontSize: 16),
                  )),
              Visibility(
                child: IconButton(
                  icon: SvgPicture.asset(
                      ImageHelper.wrapAssets("search_icon_delete.svg")),
                  onPressed: () {
                    CustomAlertDialog.showAlertDialog(
                        context, "提示", "确认清空历史记录？", "取消", "确认", 180, (value) {
                      if (value == 1) {
                        setState(() {
                          controller.text = "";
                          history.clear();
                          StorageManager.sharedPreferences!
                              .remove('historysearch');
                        });
                        // Navigator.of(context).pop();
                      }
                    }, true);
                  },
                ),
                visible: history.length == 0 ? false : true,
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Wrap(
            spacing: 10.h,
            children: history.map((item) {
              return _historyItem(item);
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// 历史搜索记录条目
  Widget _historyItem(String value) {
    return InkWell(
      child: Chip(
          backgroundColor:
              context.isBrightness ? Colour.cFFF7F8F9 : Colour.f0x1AFFFFFF,
          label: Text(value),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      onTap: () {
        setState(() {
          //更新到搜索框
          controller.text = value;
          searchStr = controller.text;
          searchContactModel.search(searchStr);
        });
      },
    );
  }

  Widget _realTimeSearch(BuildContext context, String key) {
    SearchContactModel model = searchContactModel;

    return Expanded(
      child: Visibility(
        child: (model.searchResultList.isEmpty)
            ? _emptyPicWidget(context)
            : new NotificationListener(
                onNotification: (ScrollNotification note) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  return true;
                },
                child: _buildGroupTableView(context)),
      ),
    );
  }

  /// 每个分组，显示最大条数
  final int maxRowSize = 5;

  Widget _buildGroupTableView(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: GroupTableView(
        style: ViewStyle.plain,
        itemBuilder: _buildListItem,
        numberOfSections: searchContactModel.searchResultList.length,
        numberOfRowsInSection: (int section) {
          List list = searchContactModel.searchResultList[section]["list"];
          int len = list.length;
          return len > maxRowSize ? maxRowSize : len;
        },
        sectionFooterBuilder: (context, section) {
          Map itemMap = searchContactModel.searchResultList[section];
          List list = itemMap["list"];
          int len = list.length;
          return Column(children: [
            // 显示更多
            Visibility(
              visible: len > maxRowSize,
              child: Container(
                  color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
                  height: 44.h,
                  width: 375.w,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(132.w, 0, 0, 0),
                      child: TextButton(
                        clipBehavior: Clip.none,
                        child: _searchMoreItem(context, itemMap["name"]),
                        onPressed: () async {
                          saveHistoryData();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchMoreResultPage(
                                      allresult: searchContactModel
                                          .searchResultList[section],
                                      onSelectcontact: widget.onSelectcontact,
                                    )),
                          ).then((value) {
                            if (value != null) {
                              Navigator.pop(context, value);
                            }
                          });
                        },
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 14, color: Colors.red)),
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      ImageHelper.wrapAssets(context.isBrightness
                          ? "search_icon_more.svg"
                          : "search_icon_more_sel.svg"),
                      fit: BoxFit.cover,
                      width: 14.w,
                      height: 14.h,
                    ),
                  ])),
            ),
            Visibility(
              // 最后一个分组，不显示分割条
              visible: section < searchContactModel.searchResultList.length - 1,
              child: Container(
                color: context.isBrightness ? Colour.cFFF7F8F9 : Colour.f111111,
                width: 375.w,
                height: 10.h,
              ),
            )
          ]);
        },
        sectionHeaderBuilder: (BuildContext context, int section) {
          String title = searchContactModel.searchResultList[section]["name"];
          return Container(
            color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
            // height: height,
            child: Padding(
              // 条目名称，本机联系人等
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Text(title,
                  style: context.isBrightness
                      ? TextStyle().change(context,
                          color: Colour.hintTextColor, fontSize: 14)
                      : TextStyle(color: Colour.f99ffffff, fontSize: 14)),
            ),
          );
        },
      ),
    );
  }

  Widget _emptyPicWidget(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 80.h),
        child: Column(
          children: [
            Center(
              child: SvgPicture.asset(
                ImageHelper.wrapAssets(context.isBrightness
                    ? "pic_noresult.svg"
                    : "no_searchreult_sel.svg"),
                fit: BoxFit.cover,
                width: 320.w,
                height: 320.h,
              ),
            ),
            Text(
              '无搜索结果',
              style: context.isBrightness
                  ? TextStyle().change(context, fontSize: 16)
                  : TextStyle(color: Color.fromRGBO(255, 255, 255, 0.87)),
            )
          ],
        ));
  }

  Widget _buildListItem(BuildContext context, IndexPath indexPath) {
    Widget widget = Container();
    Map itemMap = searchContactModel.searchResultList[indexPath.section];
    String title = itemMap['name'];
    var data = itemMap['list'][indexPath.row];

    if (title == '最近通话') {
      widget = _buildRecordItem(data);
    } else if (title == '本机联系人') {
      widget = _buildLocalContactItem(data, indexPath.row);
    } else if (title == '企业联系人') {
      widget = _buildEmployeeItem(data, indexPath.row);
    } else if (title == '分机联系人') {
      widget = _buildExContactItem(data, indexPath.row);
    }
    return widget;
  }

  Container _buildRecordItem(CallRecord record) {
    int callType = record.getCallType();
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    TextStyle subtitle2 = textTheme.subtitle2!;
    TextStyle caption = textTheme.caption!;
    return Container(
      height: 68.h,
      color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: InkWell(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   record.number,
                //   style: callType == CallRecord.CAll_IN_MISSED
                //       ? subtitle1.change(context, color: Colour.fEE4452)
                //       : subtitle1,
                // ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: RichText(
                        text: TextSpan(
                            children: getTextSpanList(true, record.name,
                                searchContent: searchStr,
                                callType: callType)))),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    SvgPicture.asset(callType == CallRecord.CAll_OUT
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
                                        "list_icon_missed.svg"))))),
                    SizedBox(width: 3.w),
                    Text(record.region,
                        style: context.isBrightness
                            ? TextStyle().change(context,
                                color: Colour.hintTextColor, fontSize: 14)
                            : TextStyle(color: Colour.f99ffffff)),
                  ],
                ),
              ],
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  TimeUtil.formatCallTime(record.time),
                  style: context.isBrightness
                      ? subtitle2.change(context, color: Colour.hintTextColor)
                      : TextStyle(color: Colour.f99ffffff),
                ),
                SizedBox(height: 6.h),
                Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(
                    minWidth: 38.w,
                    minHeight: 18.h,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: context.isBrightness
                        ? Color(0xfff4f5f8)
                        : Color.fromRGBO(26, 26, 26, 1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    record.duration <= 60
                        ? record.duration.toString() + "秒"
                        : TimeUtil.constructTime(record.duration),
                    style: caption.change(context, color: Color(0xff6B7686)),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          saveHistoryData();
          if (widget.onSelectcontact) {
            Navigator.pop(context,
                StringUtils.getMap2JsonSting(record.name, record.number));
          } else {
            Navigator.of(context)
                .pushNamed(RouteName.callInfoPage, arguments: record);
          }
        },
      ),
    );
  }

  Container _buildLocalContactItem(LocalContact localContact, int index) {
    String name = localContact.name;

    String head = name.substring(name.length - 1, name.length);

    ContactUIInfo info = ContactUIInfo.fromLocalContact(localContact);
    info.bgColor = Colour.getContactColor(index);

    return _buildItem(head, name, '', localContact.phone, info);
  }

  Container _buildEmployeeItem(Employee employee, int index) {
    String name = employee.name;
    String phone = employee.phone;

    String head = name.isNotEmpty ? name : phone;
    head = head.isEmpty ? '' : head.substring(head.length - 1, head.length);

    String orgName = employee.orgName;

    ContactUIInfo info = ContactUIInfo.fromEmployee(employee);
    info.bgColor = Colour.getContactColor(index);

    return _buildItem(head, name, employee.phone, orgName, info);
  }

  Container _buildExContactItem(ExContact exContact, int index) {
    String name = exContact.userName;
    String phone = exContact.number;

    String head = name.isNotEmpty ? name : phone;
    head = head.isEmpty ? '' : head.substring(head.length - 1, head.length);

    ContactUIInfo info = ContactUIInfo.fromExContact(exContact);
    info.bgColor = Colour.getContactColor(index);

    return _buildItem(head, name, exContact.number, exContact.mobile, info);
  }

  Container _buildItem(String head, String name, String topNumber,
      String bottomNumber, ContactUIInfo info) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
      ),
      padding: EdgeInsets.all(0),
      child: ListTile(
        leading: Container(
            decoration: BoxDecoration(
                color: info.bgColor,
                borderRadius: BorderRadius.all(Radius.circular(20.w))),
            // color: Colors.red,
            width: 40.w,
            height: 40.w,
            child: Center(
              child: Text(
                head,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            )),
        title: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              children: [
                RichText(
                    text: TextSpan(
                        children: getTextSpanList(true, name,
                            searchContent: searchStr))),
                SizedBox(width: 10),
                RichText(
                    text: TextSpan(
                        children: getTextSpanList(true, topNumber,
                            searchContent: searchStr)))
              ],
            )),
        subtitle: Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: RichText(
                text: TextSpan(
                    children: getTextSpanList(false, bottomNumber,
                        searchContent: searchStr)))),
        contentPadding: EdgeInsets.fromLTRB(15, 0, 35, 0),
        selected: false,
        onTap: () {
          saveHistoryData();
          if (widget.onSelectcontact) {
            Navigator.pop(
                context, StringUtils.getMap2JsonSting(info.name, info.phone));
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactInfoPage(info),
              ),
            );
          }
        },
      ),
    );
  }

  List<TextSpan> getTextSpanList(
    bool isTitle,
    String textContent, {
    String searchContent = '',
    String frontContent = '',
    int fontSize = 17,
    int callType = 0,
  }) {
    List<TextSpan> textSpanList = [];

    if (frontContent.isEmpty == false) {
      textSpanList.add(TextSpan(
          text: frontContent,
          style: TextStyle(color: Color.fromRGBO(25, 186, 108, 1.0))));
    }

    ///搜索内容不为空并且 显示内容中存在与搜索内容相同的文字
    if (searchContent.isEmpty == false && textContent.contains(searchContent)) {
      List<Map> _strMapList = [];
      bool _isContains = true;
      while (_isContains) {
        int startIndex = textContent.indexOf(searchContent);
        String showStr = textContent.substring(
            startIndex, startIndex + searchContent.length);
        Map _strMap;
        if (startIndex > 0) {
          String normalStr = textContent.substring(0, startIndex);
          _strMap = Map();
          _strMap['content'] = normalStr;
          _strMap['isHighlight'] = false;
          _strMapList.add(_strMap);
        }
        _strMap = Map();
        _strMap['content'] = showStr;
        _strMap['isHighlight'] = true;
        _strMapList.add(_strMap);
        textContent = textContent.substring(
            startIndex + searchContent.length, textContent.length);

        _isContains = textContent.contains(searchContent);
        if (!_isContains && textContent != '') {
          _strMap = Map();
          _strMap['content'] = textContent;
          _strMap['isHighlight'] = false;
          _strMapList.add(_strMap);
        }
      }

      _strMapList.forEach((map) {
        textSpanList.add(TextSpan(
            text: map['content'],
            style: map['isHighlight']
                ? TextStyle(color: Color.fromRGBO(25, 186, 108, 1.0))
                : (callType == CallRecord.CAll_IN_MISSED
                    ? TextStyle(
                        color: Colour.fEE4452,
                      )
                    : (context.isBrightness
                        ? TextStyle().change(context,
                            color: Color.fromRGBO(33, 33, 33, 1.0))
                        : TextStyle(
                            color: Color.fromRGBO(
                                255, 255, 255, isTitle ? 0.87 : 0.6))))));
      });
    } else {
      ///正常显示所有文字
      textSpanList.add(TextSpan(
        text: textContent,
        style: callType == CallRecord.CAll_IN_MISSED
            ? TextStyle(
                color: Colour.fEE4452,
              )
            : (context.isBrightness
                ? TextStyle()
                    .change(context, color: Color.fromRGBO(33, 33, 33, 1.0))
                : TextStyle(
                    color:
                        Color.fromRGBO(255, 255, 255, isTitle ? 0.87 : 0.6))),
      ));
    }
    return textSpanList;
  }

  Widget _searchMoreItem(BuildContext context, String title) {
    String resultString = '';
    if (title == '最近通话') {
      resultString = '更多最近通话';
    } else if (title == '本机联系人') {
      resultString = '更多本机联系人';
    } else if (title == '企业联系人') {
      resultString = '更多企业联系人';
    } else if (title == '分机联系人') {
      resultString = '更多分机联系人';
    }
    return Text(resultString,
        style: context.isBrightness
            ? TextStyle().change(context, fontSize: 14, color: Colour.cFF666666)
            : TextStyle(color: Colour.f99ffffff));
  }

  /// 保存搜索历史记录
  void saveHistoryData() {
    if (controller.text.trim().isNotEmpty) {
      history.insert(0, controller.text);
      history = history.toSet().toList();
    }
    if (history.length > 20) {
      history.removeLast();
    }
    StorageManager.sharedPreferences!.setStringList('historysearch', history);
  }
}
