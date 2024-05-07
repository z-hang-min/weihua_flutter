import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/model/enterprise_address_book.dart';
import 'package:weihua_flutter/model/ex_contacts_result.dart';
import 'package:weihua_flutter/model/local_contact.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/function_permission_help.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/contact_info_view_model.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/contact_ui.dart';
import 'package:weihua_flutter/ui/widget/call_contact_widget.dart';
import 'package:weihua_flutter/ui/widget/common_widget.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

String contactInfoAre = '未知';

class ContactInfoPage extends StatefulWidget {
  final ContactUIInfo info;

  ContactInfoPage(this.info);

  @override
  _ContactInfoPageState createState() => _ContactInfoPageState();
}

class _ContactInfoPageState extends State<ContactInfoPage> {
  late ContactInfoViewModel _viewModel;
  late ContactUIInfo info;

  @override
  void initState() {
    super.initState();

    info = widget.info;
    _viewModel = ContactInfoViewModel(widget.info);
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidgetNoConsumer<ContactInfoViewModel>(
      model: _viewModel,
      child: Scaffold(
        appBar: AppBar(
           elevation: 0,
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
          title: Text(''),
          leading: IconButton(
              icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                  ? "nav_icon_return_white.svg"
                  : "nav_icon_return_sel.svg")),
              onPressed: () {
                Navigator.pop(context);
              }),
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
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color.fromRGBO(71, 117, 253, 1.0),
                          Color.fromRGBO(69, 143, 249, 1.0),
                        ],
                      ),
                    ),
                    height: 215.h,
                    // width: 375,
                  ),
                ),
                Positioned(
                  top: 68.h,
                  child: Stack(
                    children: [
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                            color: context.isBrightness
                                ? Colors.white
                                : Colour.f1A1A1A,
                          ),
                          height: 166.h,
                          width: 375.w,
                          child: Column(
                            children: [
                              SizedBox(height: 55.h),
                              Text(
                                _viewModel.getName(),
                                style: TextStyle().change(context,
                                    color: Colour.titleColor, fontSize: 24),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                _viewModel.getNameSubTitle(),
                                style: TextStyle().change(context,
                                    color: Colour.titleColor, fontSize: 14),
                              ),
                              SizedBox(height: 20.h),
                              MyDivider(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 144.w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipOval(
                        child: Container(
                          height: 86.w,
                          width: 86.w,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colour.f1A1A1A,
                        ),
                      ),
                      Container(
                        alignment: Alignment(0, 0),
                        width: 80.w,
                        height: 80.w,
                        child: Text(
                          _viewModel.getHead(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        decoration: new BoxDecoration(
                          color: widget.info.bgColor,
                          borderRadius: BorderRadius.all(Radius.circular(40.w)),
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
          children: _listNumber(),
        ),
      ),
    );
  }

  List<Widget> _listNumber() {
    bool hasPSTN = UserPermissionHelp.enablePSTNCall();
    bool hasVoIP = UserPermissionHelp.enableVoIPCall();

    List<Widget> list = [];
    // 员工 号码
    if (_viewModel.employee != null) {
      Employee employee = _viewModel.employee!;

      if (employee.extNumber.isNotEmpty) {
        list.add(CallNumberItemWidget(
            number: employee.extNumber,
            subTitle: '分机号',
            hasPSTN: false,
            hasVoIP: hasVoIP,
            isExNumber: true,
            onRefresh: (_) {}));
      }
      if (employee.phone.isNotEmpty) {
        list.add(Consumer<ContactInfoViewModel>(
          builder: (_, model, child) {
            return CallNumberItemWidget(
                number: employee.phone,
                subTitle: _viewModel.area,
                hasPSTN: hasPSTN,
                hasVoIP: hasVoIP,
                isExNumber: false,
                onRefresh: (_) {});
          },
        ));
      }
      if (employee.number95.isNotEmpty) {
        list.add(CallNumberItemWidget(
            number: employee.number95,
            subTitle: _viewModel.area,
            hasPSTN: hasPSTN,
            hasVoIP: hasVoIP,
            isExNumber: false,
            onRefresh: (_) {}));
      }

      list.add(SizedBox(height: 10.h));
      list.add(_buildEmployeeOrgInfo(employee));
    }

    // 分机联系人 号码
    if (_viewModel.exContact != null) {
      ExContact exContact = _viewModel.exContact!;
      if (exContact.number.isNotEmpty) {
        list.add(CallNumberItemWidget(
            number: exContact.number,
            subTitle: '分机号',
            hasPSTN: false,
            hasVoIP: hasVoIP,
            isExNumber: true,
            onRefresh: (_) {}));
      }
      if (exContact.mobile.isNotEmpty) {
        list.add(Consumer<ContactInfoViewModel>(
          builder: (_, model, child) {
            return CallNumberItemWidget(
                number: exContact.mobile,
                subTitle: _viewModel.area,
                hasPSTN: hasPSTN,
                hasVoIP: hasVoIP,
                isExNumber: false,
                onRefresh: (_) {});
          },
        ));
      }
    }

    // 本地联系人 号码
    if (_viewModel.localContact != null) {
      LocalContact localContact = _viewModel.localContact!;
      if (localContact.phone.isNotEmpty) {
        list.add(Consumer<ContactInfoViewModel>(
          builder: (_, model, child) {
            return CallNumberItemWidget(
                number: localContact.phone,
                subTitle: _viewModel.area,
                hasPSTN: hasPSTN,
                hasVoIP: hasVoIP,
                isExNumber: false,
                onRefresh: (_) {});
          },
        ));
      }
    }

    return list;
  }

  Widget _buildEmployeeOrgInfo(Employee employee) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
        decoration: BoxDecoration(
          color: context.isBrightness ? Colors.white : Colour.f1A1A1A,
        ),
        // height: 68.h,
        // width: 375.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(employee.orgName,
                textAlign: TextAlign.left,
                style: Theme.of(context).brightness == Brightness.light
                    ? TextStyle()
                        .change(context, color: Colour.titleColor, fontSize: 16)
                    : TextStyle(color: Color.fromRGBO(255, 255, 255, 1.0))),
            SizedBox(
              height: 4.h,
            ),
            Text(accRepo.getAddressBookVersion().customName,
                // textAlign: TextAlign.left,
                style: Theme.of(context).brightness == Brightness.light
                    ? TextStyle().change(context,
                        color: Colour.hintTextColor, fontSize: 14)
                    : TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6))),
          ],
        ));
  }
}
