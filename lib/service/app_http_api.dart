import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:weihua_flutter/config/net/base_api.dart';
import 'package:weihua_flutter/model/address_book_version.dart';
import 'package:weihua_flutter/model/check_update_result.dart';
import 'package:weihua_flutter/model/enterprise_address_book.dart';
import 'package:weihua_flutter/model/ex_contacts_result.dart';
import 'package:weihua_flutter/model/query_area_reult.dart';
import 'package:weihua_flutter/model/query_info_result.dart';
import 'package:weihua_flutter/model/query_login_num_iscancel.dart';
import 'package:weihua_flutter/model/query_transfer_result.dart';
import 'package:weihua_flutter/model/query_workbench_result.dart';
import 'package:weihua_flutter/model/unify_login_result.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/utils/file_storage_utils.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/platform_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config/net/app_http_config.dart';

///
/// @Desc: 接口定义
/// @Author: zhhli
/// @Date: 2021-03-24
///

final HttpApi httpApi = HttpApi();

class HttpApi {
  // 接口配置
  final HttpApp _http = HttpApp();

  get timestampNow => DateTime.now().millisecondsSinceEpoch.toString();

  static const _secret = "E70F39875BC5BAC9518F7721A7FBEF80";

  //获取签名
  static getSign([List<dynamic> values = const []]) {
    String str = "";

    values.forEach((element) {
      str += element.toString();
    });
    str = str + _secret;
    String s = md5.convert(utf8.encode((str).toString())).toString();
    return s.toUpperCase();
  }

  ///发送验证码接口 0数字验证吗，1语音
  Future<void> sendCode(String mobile, int codeType) async {
    await _http.get('dianhuaju/app/account/sendcode', queryParameters: {
      'mobile': mobile,
      'codeType': codeType,
      'sign': getSign([mobile]),
    });
  }

  Future<UnifyLoginResult> login(String phone, String pwd) async {
    Log.d('登录===>$phone, pwd: $pwd');
    var rep =
        await _http.get('dianhuaju/app/account/unifyLogin', queryParameters: {
      "mobile": phone,
      "code": pwd,
      'sign': getSign([phone, pwd]),
    });

    var result = UnifyLoginResult.fromJson(rep.data);
    Log.d(rep.data.toString());

    return result;
  }

  ///切换账号，查询用户账号列表
  Future<UnifyLoginResult> checkLogin(String phone) async {
    var rep =
        await _http.get('dianhuaju/app/account/checkLogin', queryParameters: {
      "mobile": phone,
      'sign': getSign([phone]),
    });

    var result = UnifyLoginResult.fromJson(rep.data);
    Log.d(rep.data.toString());

    return result;
  }

  //查询登录号码是否被注销
  Future<LoginNumCancelResult> queryLoginNumIsCancel(
      String mobile, int innerNumberId, int outerNumberId) async {
    var response = await _http.get(
        join(accRepo.httpUrlPath, 'dianhuaju/app/login/checkExist'),
        queryParameters: {
          'mobile': mobile,
          'innerNumberId': innerNumberId,
          'outerNumberId': outerNumberId,
          'sign': getSign([innerNumberId, outerNumberId]),
        });
    var result = LoginNumCancelResult.fromJson(response.data);
    return result;
  }

  Future<CheckUpdateResult> checkUpdate() async {
    int clientType = 1;
    var appVersion = await PlatformUtils.getAppVersion();
    if (Platform.isIOS) {
      clientType = 0;
    }
    var response = await _http.get(
        join(accRepo.httpUrlPath, 'dianhuaju/app/version/query'),
        queryParameters: {
          'appId': "whapp",
          'clientType': clientType,
          'version': appVersion,
          'sign': getSign(["whapp", clientType, appVersion]),
        });
    var result = CheckUpdateResult.fromJson(response.data);
    return result;
  }

  ///查询登陆用户信息
  Future<QueryInfoResult?> queryInfo(
      int innerNumberId, int outerNumberId) async {
    var response = await _http.get(
        join(accRepo.httpUrlPath, 'dianhuaju/app/login/queryInfo'),
        queryParameters: {
          'innerNumberId': innerNumberId,
          'outerNumberId': outerNumberId,
          'sign': getSign([innerNumberId, outerNumberId]),
        });
    var result = QueryInfoResult.fromJson(response.data);
    return result;
  }

  ///接听方式查询接口
  ///dianhuaju/app/inner/number/queryTransfer
  Future<QueryTransferResult> queryTransfer(
      String innerNumberId, String outerNumberId) async {
    var response = await _http.get(
        join(accRepo.httpUrlPath, 'dianhuaju/app/inner/number/queryTransfer'),
        queryParameters: {
          'innerNumberId': innerNumberId,
          'outerNumberId': outerNumberId,
          'sign': getSign([innerNumberId, outerNumberId]),
        });
    var result = QueryTransferResult.fromJson(response.data);
    return result;
  }

//工作台数据获取
  Future<QueryWorkBenchResult> queryWorkBench(
      int innerNumberId, int outerNumberId, bool light) async {
    String source = Platform.isIOS ? 'ios_1' : 'android_1';

    var response = await _http.get(
        join(accRepo.httpUrlPath, 'dianhuaju/app/function/query'),
        queryParameters: {
          'innerNumberId': innerNumberId,
          'outerNumberId': outerNumberId,
          'source': source,
          'modeType': light ? 0 : 1,
          'sign': getSign([innerNumberId, outerNumberId]),
        });
    var result = QueryWorkBenchResult.fromJson(response.data);
    return result;
  }

  //企业联系人数据接口
  Future<EnterpriseAddressBook> queryBusinessContact(int outerNumberId) async {
    var response = await _http.get(
        join(accRepo.httpUrlPath, 'dianhuaju/outer/number/query'),
        queryParameters: {
          'outerNumberId': outerNumberId,
          'sign': getSign([outerNumberId]),
        });
    var result = EnterpriseAddressBook.fromJson(response.data);
    return result;
  }

  //分机联系人数据接口
  Future<ExContactsResult> queryExtensionContact(int outerNumberId) async {
    var response = await _http.get(
        join(accRepo.httpUrlPath, 'dianhuaju/app/inner/number/query'),
        queryParameters: {
          'outerNumberId': outerNumberId,
          'sign': getSign([outerNumberId]),
        });
    var result = ExContactsResult.fromJson(response.data);
    return result;
  }

  //查询企业和分机联系人版本
  Future<AddressBookVersion> queryContactVersion(int outerNumberId) async {
    var response = await _http.get(
        join(accRepo.httpUrlPath, 'weihua/contact/version/query'),
        queryParameters: {
          'outerNumberId': outerNumberId,
          'sign': getSign([outerNumberId]),
        });
    var result = AddressBookVersion.fromJson(response.data);
    return result;
  }

  Future<void> updateTransfer(
      int innerNumberId, int outerNumberId, int transfer) async {
    await _http.get(
        join(accRepo.httpUrlPath, 'dianhuaju/app/inner/number/updateTransfer'),
        queryParameters: {
          'innerNumberId': innerNumberId,
          'outerNumberId': outerNumberId,
          'transfer': transfer,
          'sign': getSign([innerNumberId, outerNumberId]),
        });
    return null;
  }

  ///废弃
  ///查询号码归属地接口
  Future<QueryAreaResult> queryArea(String mobile) async {
    var response = await _http.get(
        join(accRepo.httpUrlPath, 'weihua/service/queryArea'),
        queryParameters: {
          'mobile': mobile,
          'sign': getSign([mobile]),
        });
    var result = QueryAreaResult.fromJson(response.data);
    return result;
  }

  downloadFile(String fileURl, {String savePath = ""}) async {
    if (fileURl.startsWith("http//")) {
      fileURl = fileURl.replaceAll("http", "http:");
    }
    if (fileURl.startsWith("https//")) {
      fileURl = fileURl.replaceFirst("https", "https:");
    }
    Dio dio = Dio();
    if (fileURl.contains("sound/record") && fileURl.contains("zip")) {
      savePath = fileURl.substring(fileURl.indexOf("record"));
    }
    try {
      if (savePath.isEmpty) {
        int nowTime = DateTime.now().millisecondsSinceEpoch;
        File file = await SHFileStorageUtils.getSaveFile("$nowTime.zip");
        savePath = file.path;
      } else {
        File file = await SHFileStorageUtils.getSaveFile(savePath);
        savePath = file.path;
      }
      Log.w("savePath==$savePath");
      //3、使用 dio 下载文件
      Response response = await dio.download(fileURl, savePath,
          onReceiveProgress: (receivedBytes, totalBytes) {
        if (receivedBytes > 0 && receivedBytes == totalBytes) {
          if (Platform.isAndroid) {
            showToast("下载成功,请前往我的文件夹download/records目录下查看");
          } else {
            showToast("下载成功,请前往我的文件夹微话records目录下查看");
          }
        }
      });
      if (response.statusCode == 200) {
        print('下载请求成功');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> downloadFileFromH5(String fileURl,
      {String savePath = ""}) async {
    //1、权限检查
    Log.w("fileURl==$fileURl");
    if (await Permission.storage.isGranted) {
      downloadFile(fileURl);
    } else {
      if (await Permission.storage.request().isGranted) {
        downloadFile(fileURl);
      } else {
        openAppSettings();
      }
    }
  }

  // 中诚世纪 接口参数
  static Map<String, dynamic> getMapZCSJ() {
    Random random = new Random();
    String result = "";
    for (int i = 0; i < 7; i++) {
      result += random.nextInt(10).toString();
    }

    var userId = '12';
    int timeStamp1 = DateTime.now().microsecondsSinceEpoch;
    String timeStamp = (timeStamp1 ~/ 1000).toString();
    String randomStr = result;
    String encryption = timeStamp.substring(timeStamp.length - 4);
    String str = timeStamp + randomStr + encryption;
    // String signature = EncryptUtil.toMD5(EncryptUtil.getSha1(str));
    String sha1Str = sha1.convert(utf8.encode(str)).toString();
    String signature = md5.convert(utf8.encode(sha1Str)).toString();
    signature = signature.toUpperCase();

    var map = HashMap<String, dynamic>();
    map["signature"] = signature;
    map["timeStamp"] = timeStamp; //时间戳
    map["randomStr"] = randomStr; //随机值
    map["Encryption"] = encryption; //加密值
    map["user_id"] = userId;

    return map;
  }
}
