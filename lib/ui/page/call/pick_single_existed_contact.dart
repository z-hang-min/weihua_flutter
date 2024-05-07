import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/model/call_record.dart';
import 'package:weihua_flutter/model/local_contact.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/service/contact_repository.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/contact_ui.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/home_enterprise_address_model.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

///
/// @Desc:
///
/// @Author: zhhli
///
/// @Date: 21/4/16
///
class PickContactPage extends StatefulWidget {
  final CallRecord onecallRecord;
  PickContactPage({Key? key, required this.onecallRecord}) : super(key: key);
  @override
  _PickContactPageState createState() => _PickContactPageState();
}

class _PickContactPageState extends State<PickContactPage> {
  Future _editContact(LocalContact data) async {
    LocalContact? localContact =
        await contactRepo.editContact(data, widget.onecallRecord.number);

    if (localContact != null) {
      //更新联系人
      Log.d("editContact editContact 成功： ${localContact.toJson()}");
    }

    Navigator.of(context).pop(localContact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(S.of(context).tabContact),
        centerTitle: true,
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(
                Theme.of(context).brightness == Brightness.light
                    ? "nav_icon_return.svg"
                    : "nav_icon_return_sel.svg")),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Consumer<UserModel>(
        builder: (context, userModel, child) =>
            ProviderWidget<HomeBusinessContactModel>(
                model: Provider.of<HomeBusinessContactModel>(context,
                    listen: false),
                autoDispose: false,
                onModelReady: (model) async {
                  // 先加载数据库数据
                  model.loadDataFromDb(reLoadLocalDb: true);

                  // 重新读系统联系人
                  if (await Permission.contacts.isGranted) {
                    model.reloadNativeLocalContact();
                  } else {
                    if (await Permission.contacts.request().isGranted) {
                      model.reloadNativeLocalContact();
                    }
                  }
                },
                builder: (context, model, child) {
                  if (model.isBusy) {
                    EasyLoading.show();
                  }
                  if (model.isIdle) {
                    EasyLoading.dismiss();
                  }

                  List<ContactUIInfo> contactList = model.uiLocalList;
                  Log.d("刷新联系人列表 ${contactList.length}");
                  return AzListView(
                    data: contactList,
                    itemCount: contactList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        _buildListItem(
                      context,
                      contactList,
                      index,
                      defHeaderBgColor: Color(0xFFE5E5E5),
                    ),
                    physics: BouncingScrollPhysics(),
                    // 悬停
                    susItemBuilder: (BuildContext context, int index) =>
                        _buildSusItem(context, contactList, index),
                    indexBarData: [...kIndexBarData],
                    indexBarOptions: _buildIndexBarOptions(),
                  );
                }),
      ),
    );
  }

  /// 构建侧边导航样式
  IndexBarOptions _buildIndexBarOptions() {
    return IndexBarOptions(
      needRebuild: true,
      ignoreDragCancel: true,
      // downTextStyle: TextStyle(fontSize: 12, color: Colors.white),
      // downItemDecoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
      indexHintWidth: 80,
      indexHintHeight: 80,
      indexHintDecoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageHelper.wrapAssets('tab_letter_tip.png')),
          fit: BoxFit.none,
        ),
      ),
    );
  }

  /// 构建联系人分组widget
  Container _buildGroupTitleContainer(ContactUIInfo info) => Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
              height: 40,
              alignment: Alignment.centerLeft,
              child: Text(info.name)),
        ),
      );

  /// 构建字母分组条目布局
  static Widget _buildSusItem(
      BuildContext context, List<ContactUIInfo> contactList, int index,
      {double susHeight = 30}) {
    String tag = contactList[index].getSuspensionTag();
    if (tag == ContactUIInfo.headTag) {
      return Container();
    }
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 15.0),
      color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
      alignment: Alignment.centerLeft,
      child: Text(
        '$tag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: context.isBrightness ? Color(0xFF333333) : Colors.white,
        ),
      ),
    );
  }

  /// 构建联系人信息条目
  Widget _buildListItem(
    BuildContext context,
    List<ContactUIInfo> contactList,
    int index, {
    Color? defHeaderBgColor,
  }) {
    ContactUIInfo info = contactList[index];
    if (info.type == ContactType.other &&
        info.otherTitleType == OtherTitleType.title) {
      return _buildGroupTitleContainer(info);
    }
    // if(info.type == 4 || info.type == 5){
    //   _buildBaseListItemcontainer(info);
    // }

    return _buildBaseListItemContainer(info, index);
  }

  Container _buildBaseListItemContainer(ContactUIInfo info, int index) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colour.f1A1A1A,
      ),
      padding: EdgeInsets.all(0),
      child: ListTile(
        leading: SizedBox(
          child: info.img == null
              ? Container(
                  decoration: BoxDecoration(
                      color: Colour.getContactColor(index),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  // color: Colors.red,
                  width: ScreenUtil().setWidth(40),
                  height: ScreenUtil().setWidth(40),
                  child: Center(
                    child: Text(
                      info.name
                          .substring(info.name.length - 1, info.name.length),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
              : Image.asset(ImageHelper.wrapAssets(info.img!)),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Text(
            info.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Text(
            info.phone,
            maxLines: 1,
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(15, 0, 35, 0),
        selected: false,

        ///如果选中列表的 item 项，那么文本和图标的颜色将成为主题的主颜色
        onTap: () async {
          LocalContact data = info.data as LocalContact;
          await _editContact(data);
        },
        onLongPress: () {},
      ),
    );
  }
}
