import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/model/call_record.dart';
import 'package:weihua_flutter/model/enterprise_address_book.dart';
import 'package:weihua_flutter/model/ex_contacts_result.dart';
import 'package:weihua_flutter/model/local_contact.dart';
import 'package:weihua_flutter/ui/page/contact/contact_info_page.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/contact_ui.dart';
import 'package:weihua_flutter/utils/string_utils.dart';
import 'package:weihua_flutter/utils/time_util.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchMoreResultPage extends StatefulWidget {
  final Map allresult;

  final bool onSelectcontact;

  SearchMoreResultPage(
      {required this.allresult, required this.onSelectcontact});

  @override
  _SearchMoreResultState createState() => _SearchMoreResultState();
}

class _SearchMoreResultState extends State<SearchMoreResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.allresult['name']),
        leading: new IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              return Navigator.pop(context);
            }),
      ),
      body: ListView.builder(
        itemCount: widget.allresult['list'].length,
        itemBuilder: (BuildContext context, int index) =>
            widget.allresult['name'] == '最近通话'
                ? _buildrecordListItem(
                    context,
                    widget.allresult['list'],
                    index,
                  )
                : _buildAllListItem(widget.allresult, index),
      ),
    );
  }

  Widget _buildAllListItem(Map itemMap, int index) {
    Widget widget = Container();
    String title = itemMap['name'];
    var data = itemMap['list'][index];
    if (title == '本机联系人') {
      widget = _buildLocalContactItem(data, index);
    } else if (title == '企业联系人') {
      widget = _buildEmployeeItem(data, index);
    } else if (title == '分机联系人') {
      widget = _buildExContactItem(data, index);
    }
    return widget;
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
                          children:
                              getTextSpanList(true, name, searchContent: ''))),
                  SizedBox(width: 10),
                  RichText(
                      text:
                          TextSpan(children: getTextSpanList(true, topNumber)))
                ],
              )),
          subtitle: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: RichText(
                  text: TextSpan(
                      children: getTextSpanList(false, bottomNumber)))),
          contentPadding: EdgeInsets.fromLTRB(15, 0, 35, 0),
          selected: false,
          onTap: () {
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
          }),
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
        style: context.isBrightness
            ? TextStyle()
                .change(context, color: Color.fromRGBO(33, 33, 33, 1.0))
            : TextStyle(
                color: Color.fromRGBO(255, 255, 255, isTitle ? 0.87 : 0.6)),
      ));
    }
    return textSpanList;
  }

//
  Widget _buildrecordListItem(
      BuildContext context, List<dynamic> callrecordList, int index) {
    return _buildRecordListItemcontainer(callrecordList[index]);
  }

  Container _buildRecordListItemcontainer(CallRecord record) {
    int callType = record.getCallType();
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    TextStyle caption = textTheme.caption!;
    return Container(
      height: 68.h,
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: InkWell(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.number,
                  style: callType == CallRecord.CAll_IN_MISSED
                      ? TextStyle(color: Colour.fEE4452, fontSize: 16)
                      : subtitle1,
                ),
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
                    Text(record.region),
                  ],
                ),
              ],
            ),
            Spacer(),
            // Spacer(flex: 2),
            InkWell(
              onTap: () async {
                // model.onEdit
                //     ? model.addSelected(record)
                //     : await Navigator.pushNamed(context, RouteName.callingPage,
                //             arguments: record)
                //         .then((value) {
                //         Provider.of<HomeCallListModel>(context, listen: false)
                //             .refresh();
                //         Log.v("刷新 数据");
                //       });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    TimeUtil.formatCallTime(record.time),
                    style:
                        subtitle2.change(context, color: Colour.hintTextColor),
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
                      color: Theme.of(context).brightness == Brightness.light
                          ? Color(0xfff4f5f8)
                          : Color.fromRGBO(17, 17, 17, 0.6),
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
            )
          ],
        ),
        onTap: () {
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
}
