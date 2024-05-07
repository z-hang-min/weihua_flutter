import 'package:weihua_flutter/model/functionList.dart';
import 'package:weihua_flutter/service/account_repository.dart';

///
/// @Desc:
///
/// @Author: zhhli
///
/// @Date: 21/5/19
///
/// {
//     "functionList": [
//         {
//             "code": "pstnCall",
//             "oid": 1,
//             "name": "PSTN呼叫",
//             "type": 1
//         },
//         {
//             "code": "voipCall",
//             "oid": 2,
//             "name": "VOIP呼叫",
//             "type": 1
//         },
//         {
//             "code": "voipAnswer",
//             "oid": 3,
//             "name": "VOIP接听",
//             "type": 1
//         },
//         {
//             "code": "customContacts",
//             "oid": 4,
//             "name": "企业通讯录",
//             "type": 1
//         },
//         {
//             "code": "innerContacts",
//             "oid": 5,
//             "name": "分机通讯录",
//             "type": 1
//         },
//         {
//             "code": "mobileContacts",
//             "oid": 6,
//             "name": "本机通讯录",
//             "type": 1
//         },
//         {
//             "code": "accountSwitch",
//             "oid": 7,
//             "name": "账号切换",
//             "type": 1
//         },
//         {
//             "code": "answerType",
//             "oid": 8,
//             "name": "接听方式",
//             "type": 1
//         },
//         {
//             "code": "innerManage",
//             "oid": 9,
//             "name": "分机管理",
//             "type": 1
//         },
//         {
//             "code": "addAddon",
//             "oid": 10,
//             "name": "增加分机时增加总机对应分钟数",
//             "type": 1
//         },
//         {
//             "code": "outerMinute",
//             "oid": 11,
//             "name": "剩余分钟数-总机",
//             "type": 1
//         },
//         {
//             "code": "innerMinute",
//             "oid": 12,
//             "name": "剩余分钟数-分机",
//             "type": 1
//         },
//         {
//             "code": "customInfoManage",
//             "oid": 13,
//             "name": "企业信息管理",
//             "type": 1
//         }
//     ]
// }

class PermissionType {
  /// PSTN 呼叫
  static const pstnCall = "pstnCall";
  static const voipCall = "voipCall";
  static const voipAnswer = "voipAnswer";

  /// 企业通讯录
  static const customContacts = "customContacts";

  /// 分机通讯录
  static const innerContacts = "innerContacts";

  /// 本机通讯录
  static const mobileContacts = "mobileContacts";

  /// 账号切换
  static const accountSwitch = "accountSwitch";

  /// 接听方式
  static const answerType = "answerType";

  /// 分机管理
  static const innerManage = "innerManage";

  /// 增加分机时增加总机对应分钟数
  static const addAddon = "addAddon";

  /// 剩余分钟数-总机
  static const outerMinute = "outerMinute";

  /// 剩余分钟数-分机
  static const innerMinute = "innerMinute";

  /// 企业信息管理
  static const customInfoManage = "customInfoManage";
}

class UserPermissionHelp {
  UserPermissionHelp._();

  /// 企业通讯录
  static bool enableEnterpriseContact() =>
      accRepo.unifyLoginResult!.getCompanyNumList().length > 0 &&
      enable(PermissionType.customContacts);

  /// 分机通讯录
  static bool enableExContact() =>
      accRepo.unifyLoginResult!.getCompanyNumList().length > 0 &&
      enable(PermissionType.innerContacts);

  /// 本机通讯录
  static bool enableLocalContact() =>
      enable(PermissionType.mobileContacts) || true;

  /// VoIP呼出权限
  static bool enableVoIPCall() => enable(PermissionType.voipCall);

  /// PSTN 呼出权限
  static bool enablePSTNCall() => enable(PermissionType.pstnCall);

  /// 呼出权限
  static bool enableCall() => enablePSTNCall() || enableVoIPCall();

  /// 接听方式
  static bool enableAnswerType() => enable(PermissionType.answerType);

  /// 账号切换
  static bool enableAccountSwitch() => enable(PermissionType.accountSwitch);

  static bool enable(String code) {
    if (accRepo.user == null) return false;
    for (PermissionData element in accRepo.user!.functionList) {
      if (code == element.code) {
        bool has = element.type == 1;
        return has;
      }
    }
    return false;
  }

  static PermissionData? getData(String code, {bool checkEnable = true}) {
    if (accRepo.user == null) return null;
    for (PermissionData element in accRepo.user!.functionList) {
      if (code == element.code) {
        if (checkEnable) {
          bool has = element.type == 1;
          return has ? element : null;
        } else {
          return element;
        }
      }
    }
    return null;
  }
}
