import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/model/user.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SwitchAccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SwitchAccountPagetate();
}

class _SwitchAccountPagetate extends State<SwitchAccountPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).accountManagement),
        backgroundColor: Theme.of(context).cardColor,
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(
                Theme.of(context).brightness == Brightness.light
                    ? "nav_icon_return.svg"
                    : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Scrollbar(
        child: _listViewBuilder(),
      ),
    );
  }

  /// ListView.builder
  Widget _listViewBuilder() {
    return Consumer<UserModel>(
        builder: (context, model, child) => ListView.builder(
              //无分割线
              itemBuilder: (context, i) {
                return _buildListData(
                    model, model.unifyLoginResult.numberList[i]);
              },
              itemCount: model.unifyLoginResult.numberList.length,
            ));
  }

  Widget _buildListData(UserModel model, User user) {
    return Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Ink(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            color: Theme.of(context).cardColor,
          ),
          child: InkWell(
            child: Container(
              height: 68,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? ImageHelper.wrapAssets("number_icon_personal.svg")
                          : ImageHelper.wrapAssets(
                              "number_icon_personal_dark.svg")),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${user.outerNumber}${user.innerNumber}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Visibility(
                    visible: model.user?.sipId == user.sipId,
                    child: Image.asset(
                      ImageHelper.wrapAssets("label_currentuse.png"),
                    ),
                  ),
                  Spacer(),
                  Image.asset(
                    model.user?.sipId == user.sipId
                        ? ImageHelper.wrapAssets("phone_radio_selected.png")
                        : ImageHelper.wrapAssets("phone_radio_unselected.png"),
                  )
                ],
              ),
            ),
            onTap: () {
              // AddressBookVersion _bookVersion=AddressBookVersion.mock();
              // accRepo.saveAddressBookVersion(_bookVersion);
              model.saveUser(user);
              isLogin = true;
              Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteName.tab, (Route<dynamic> route) => false);
            },
          ),
        ));
  }
}
