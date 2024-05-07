import 'package:weihua_flutter/model/enterprise_address_book.dart';
import 'package:weihua_flutter/model/ex_contacts_result.dart';
import 'package:weihua_flutter/model/local_contact.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';
import 'package:weihua_flutter/ui/page/call/view_model/query_area_mode.dart';
import 'package:weihua_flutter/ui/page/contact/view_model/contact_ui.dart';
import 'package:weihua_flutter/utils/string_utils.dart';

///
/// @Desc: 联系人详情
///
/// @Author: zhhli
///
/// @Date: 21/6/2
///
class ContactInfoViewModel extends ViewStateModel {
  ContactUIInfo info;
  QueryAreaMode _areaMode = QueryAreaMode();

  Employee? employee;
  ExContact? exContact;
  LocalContact? localContact;

  String area = '';
  String _head = '';
  String subtitle = '';

  ContactInfoViewModel(this.info) {
    String phone = info.phone;
    if (info.type == ContactType.employee) {
      employee = info.data as Employee;
      subtitle = employee!.position;

      phone = employee!.phone;

      _head = employee!.name;
    }

    if (info.type == ContactType.exContact) {
      exContact = info.data as ExContact;
      subtitle = exContact!.number;
      phone = exContact!.mobile;
      _head = exContact!.userName;
    }

    if (info.type == ContactType.localContact) {
      localContact = info.data as LocalContact;
      subtitle = localContact!.phone;
      _head = localContact!.name;
    }

    if (StringUtils.isMobileNumber(phone)) {
      _queryArea(phone);
    }
  }

  String getHead() {
    if (_head.isNotEmpty) {
      return _head.substring(_head.length - 1, _head.length);
    }
    return '';
  }

  String getName() {
    return info.name;
  }

  String getNameSubTitle() {
    return subtitle;
  }

  Future _queryArea(String phone) async {
    area = await _areaMode.queryArea(phone);
    notifyListeners();
  }
}
