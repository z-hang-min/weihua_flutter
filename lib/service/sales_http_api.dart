import 'dart:convert';

import 'package:weihua_flutter/config/const_config.dart';
import 'package:weihua_flutter/config/net/base_api.dart';
import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/model/apple_pay_result.dart';
import 'package:weihua_flutter/model/call_record.dart';
import 'package:weihua_flutter/model/current_package.dart';
import 'package:weihua_flutter/model/enterprise_certification_result.dart';
import 'package:weihua_flutter/model/enterprise_info_result.dart';
import 'package:weihua_flutter/model/extension_result.dart';
import 'package:weihua_flutter/model/get_banner_result.dart';
import 'package:weihua_flutter/model/get_business_list_reslt.dart';
import 'package:weihua_flutter/model/getmycallnum_result.dart';
import 'package:weihua_flutter/model/myownernumber_result.dart';
import 'package:weihua_flutter/model/nodisturb_result.dart';
import 'package:weihua_flutter/model/notification_history_result.dart';
import 'package:weihua_flutter/model/notification_model_result.dart';
import 'package:weihua_flutter/model/order_record.dart';
import 'package:weihua_flutter/model/order_record_result.dart';
import 'package:weihua_flutter/model/per_num_check_result.dart';
import 'package:weihua_flutter/model/person_num_list_result.dart';
import 'package:weihua_flutter/model/query_blacklist_result.dart';
import 'package:weihua_flutter/model/query_default_outer_num_result.dart';
import 'package:weihua_flutter/model/record_detail_list_result.dart';
import 'package:weihua_flutter/model/record_today.dart';
import 'package:weihua_flutter/model/renew_num_package.dart';
import 'package:weihua_flutter/model/search_send_times_result.dart';
import 'package:weihua_flutter/model/share_msg_result.dart';
import 'package:weihua_flutter/model/ware_info_result.dart';
import 'package:weihua_flutter/model/enterprise_nameandaddress_result.dart';
import 'package:weihua_flutter/model/wx_pay_order.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/ui/page/person_number/view_model/package_item.dart';
import 'package:weihua_flutter/utils/log.dart';
import 'package:weihua_flutter/utils/platform_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:oktoast/oktoast.dart';
import 'package:path/path.dart';

import '../config/net/app_http_config.dart';

///
/// @Desc: 接口定义
/// @Author: zhhli
/// @Date: 2021-03-24
///

final SalesHttpApi salesHttpApi = SalesHttpApi();

class SalesHttpApi {
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

  void doWxpay(WxPayOrder wxPayOrder) async {
    if (!await fluwx.isWeChatInstalled) {
      showToast("请先安装微信App");
      return;
    }

    fluwx
        .payWithWeChat(
          appId: '${wxPayOrder.clientappid}',
          partnerId: '${wxPayOrder.partnerid}',
          prepayId: '${wxPayOrder.prepayid}',
          packageValue: '${wxPayOrder.clientpackage}',
          nonceStr: '${wxPayOrder.noncestr}',
          timeStamp: int.parse(wxPayOrder.timestamp),
          sign: '${wxPayOrder.sign}',
        )
        .then((data) {});
  }

  ///wareid：套餐id,paytype:支付类型，2表示微信
  ///ptype 产品类型，0:购买号码，1:号码升级，2:续费，3:语音通知次数，4:分机续费 5:购买分机
  ///type 终端类型，type=1时为h5,type=2时为客户端APP
  Future<WxPayOrder> createWxPayOrder(
      String num, String phone, double myprice, int ptype,
      {String wareid = '',
      String businessid = '',
      String orderid = '',
      int validtime = 0,
      String pname = ''}) async {
    num=num.replaceAll(' ', '');
    payType = 0;
    int currentPrice = (myprice * 100).toInt();
    Map<String, dynamic>? queryParameters = {
      'id': "0",
      'number': num,
      'mobile': phone,
      'price': currentPrice,
      'type': "2",
      'ptype': "$ptype",
      'paytype': 2,
    };
    Map<String, dynamic>? queryParametersnew = {};
    if (wareid.isNotEmpty && orderid.isEmpty) {
      //次数充值，号码续费，购买分机
      queryParametersnew = {
        'pname': '$pname',
        'wareid': wareid,
        'businessid': businessid,
      };
    } else if (orderid.isNotEmpty) {
      //分机续费
      queryParametersnew = {
        'orderid': orderid,
        'validtime': validtime,
        'wareid': wareid,
      };
    }
    queryParameters.addAll(queryParametersnew);
    var response = await _http.post(
        '${ConstConfig.http_api_url_sales}/sales/order/create',
        queryParameters: queryParameters);
    var result = WxPayOrder.fromJson(response.data);

    return result;
  }

  //默认外呼号码
  //mobile:手机号
  Future<QueryDefaultOuterNumResult> queryDefaultOuterNum(String mobile) async {
    var response = await _http.post(
        '${ConstConfig.http_api_url_sales}/sales/number/queryDefault',
        queryParameters: {
          'mobile': mobile,
        });
    var result = QueryDefaultOuterNumResult.fromJson(response.data);

    return result;
  }

  // 外呼号码口-状态设置
  //mobile:手机号
  //number：95号码
  Future<void> updateCalloutNumState(
      String mobile, String number, String customId, String inner) async {
    await _http.post(
        '${ConstConfig.http_api_url_sales}/sales/number/updateDefault',
        queryParameters: {
          'mobile': mobile,
          'number': number,
          'inner': inner = inner.replaceAll(" ", ''),
          'id': customId = customId.replaceAll(" ", ''),
        });
    return null;
  }

  // 我的个人号列表接口/外呼号码列表
//number：所有95号拼成的字符串 "950133185104,950133136582,950133190104,950133195105,950133185246,950133185247,950133185247,950133185248,950133185249,950133185240,950133185250,950133199999,950133199997"
  Future<PersonNumListResult> queryMynumberList(String numbers) async {
    var response = await _http.get(
        '${ConstConfig.http_api_url_sales}/sales/number/list',
        queryParameters: {
          'numbers': numbers,
        });
    var result = PersonNumListResult.fromJson(response.data);
    return result;
  }

  //查询通话记录 uids:95号吗 '95013770010'
  Future<List<CallRecord>> loadCallRecordFClound(
      String uids, int size, int page) async {
    var rep = await _http.get(
        "${ConstConfig.http_api_url_sales}/sales/cdr/app/list",
        queryParameters: {"uids": uids, "size": size, 'page': page});
    var temp = rep.data as List;
    List<CallRecord> result = [];
    result = temp.map((callrecord) => CallRecord.fromJson(callrecord)).toList();
    return result;
  }

//删除通话记录 id：通话记录接口返回的索引id  index：通话记录接口返回的索引index
  Future<bool> delCallRecordFClound(String id, String index) async {
    var rep = await _http.get(
        "${ConstConfig.http_api_url_sales}/sales/cdr/app/update",
        queryParameters: {"id": id, "index": index});
    Log.d(rep.data);
    return true;
  }

  //查询该号码状态 number：购买号码时输入的95号

  Future<PerNumCheckResult> checkNum(
      String number, CancelToken? cancelToken) async {
    var response = await _http.get(
        "${ConstConfig.http_api_url_sales}/sales/regexp",
        queryParameters: {
          "number": number,
          'source': Platform.isAndroid ? 0 : 1
        },
        cancelToken: cancelToken);
    Log.d(response.toString());
    var result = PerNumCheckResult.fromJson(response.data);
    return result;
  }

//发送验证码
  Future<void> sendBindCode(String phone) async {
    await _http.get("${ConstConfig.http_api_url_sales}/sales/sendCode",
        queryParameters: {"phone": phone});
    return null;
  }

//phone：手机号 pageCode：验证码
  Future<void> register(String phone, String code) async {
    await _http.get("${ConstConfig.http_api_url_sales}/sales/register",
        queryParameters: {"phone": phone, "pageCode": code, "openid": ''});
    return null;
  }

  // 我的个人号列表接口/外呼号码列表
  //number：所有95号拼成的字符串 "950133185104,950133136582,950133190104,950133195105,950133185246,950133185247,950133185247,950133185248,950133185249,950133185240,950133185250,950133199999,950133199997"
  Future<QueryMynumberlistResult> querymynumberlist(String numbers) async {
    var response = await _http.get(
        join('${ConstConfig.http_api_url_sales}/sales/number/list'),
        queryParameters: {
          'numbers': numbers,
        });
    var result = QueryMynumberlistResult.fromJson(response.data);
    return result;
  }

  //默认外呼号码
  //mobile：手机号
  Future<GetMyCalloutNumResult> querycallounumList(String mobile) async {
    var response = await _http.post(
        join('${ConstConfig.http_api_url_sales}/sales/number/queryDefault'),
        queryParameters: {
          'mobile': mobile,
        });
    var result = GetMyCalloutNumResult.fromJson(response.data);

    return result;
  }

  // 注销账号
  //mobile：手机号
  //number：95号 ‘950133190104’
  Future<dynamic> cancelaccount(String mobile, String number,String id) async {
    var response = await _http.post(
        join('${ConstConfig.http_api_url_sales}/sales/number/unBind'),
        queryParameters: {
          'mobile': mobile,
          'number': number,
          'id':id,
        });
    return response.data;
  }

  // 黑名单接口-状态设置
  //owner:要设置黑名单的号码
  //status:0 关闭 1打开
  Future<void> updateblackliststate(String owner, int status) async {
    await _http.get(
        join('${ConstConfig.http_api_url_sales}/sales/black/status/update'),
        queryParameters: {
          'owner': owner,
          'status': status,
        });
    return null;
  }

  // 黑名单接口-添加 owner：95号码 number：黑名单号码 remark：备注名称
  Future<void> addblacklist(String owner, String number, String remark) async {
    await _http.get(join('${ConstConfig.http_api_url_sales}/sales/black/add'),
        queryParameters: {
          'owner': owner,
          'number': number,
          'remark': remark,
        });
    return null;
  }

  // 黑名单接口-删除 owner：95号码 number：黑名单号码 remark：备注名称
  Future<void> deleteblacklist(
      String owner, String number, String remark) async {
    await _http.get(
        join('${ConstConfig.http_api_url_sales}/sales/black/delete'),
        queryParameters: {
          'owner': owner,
          'number': number,
          'remark': remark,
        });
    return null;
  }

  // 黑名单接口-分页查询 owner：95号码
  Future<QueryBlacklistResult> queryblacklist(String owner, String page) async {
    var response = await _http.get(
        join('${ConstConfig.http_api_url_sales}/sales/black/list'),
        queryParameters: {
          'owner': owner,
          'page': page,
        });
    var result = QueryBlacklistResult.fromJson(response.data);
    return result;
  }

  //勿扰-设置 number：95号码 start：开始时间‘17:47’ end：结束时间：‘07:00’ weeks：循环周期 ‘1,2,3,4,5,6,7’
  Future<void> nodisturbset(
      String number, String start, String end, String weeks) async {
    await _http.get(
        join('${ConstConfig.http_api_url_sales}/sales/silence/setup'),
        queryParameters: {
          'number': number,
          'start': start,
          'end': end,
          'weeks': weeks,
        });
    return null;
  }

  //勿扰-开关状态设置 number：95号码  status：0（关闭）1（打开）
  Future<void> updatenodisturbstate(String number, int status) async {
    await _http.get(
        join('${ConstConfig.http_api_url_sales}/sales/silence/status/update'),
        queryParameters: {
          'number': number,
          'status': status,
        });

    return null;
  }

  //勿扰-状态获取 number：95号码
  Future<NodisturbResult> querynodistrub(String number) async {
    var response = await _http.get(
        join('${ConstConfig.http_api_url_sales}/sales/silence/info'),
        queryParameters: {
          'number': number,
        });
    var result = NodisturbResult.fromJson(response.data);
    return result;
  }

  //苹果支付-创建订单 num：95号码 mobile：手机号 price：价格（单位：分） ptype：套餐类型（0:购买号码，1:号码升级，2:续费，3:语音通知次数，4:分机续费，5:购买新分机） wareid：订单id appgoodid：产品id
  Future<GetapplepayordertResult> createApplePayOrder(
      String num,
      String phone,
      int price,
      String ptype,
      String wareid,
      String appgoodid,
      String pname) async {
    var response = await _http.post(
        '${ConstConfig.http_api_url_sales}/sales/order/iap/create',
        queryParameters: {
          'id': "0",
          'number': num,
          'mobile': phone,
          'price': "$price",
          'ptype': ptype,
          'wareid': wareid,
          'appgoodid': appgoodid,
          'pname': pname != '' ? pname : '',
        });
    var result = GetapplepayordertResult.fromJson(response.data);

    return result;
  }

  //苹果支付-验证支付结果 uid：95号 transactionid，receiptdata：苹果支付返回参数 appgoodid：产品id fee：价格 orderid：订单id ptype：套餐类型 validtime：分机续费到期时间 groupid：分机续费分组的id
  Future<GetapplepayordertResult> queryapplepayresult(
      String num,
      String osinfo,
      String transactionid,
      String receiptdata,
      String appgoodid,
      int fee,
      String orderid,
      String ptype,
      String validtime,
      String groupid) async {
    var response = await _http.post(
        '${ConstConfig.http_api_url_sales}/sales/iap/buy',
        queryParameters: {
          'uid': num,
          'osinfo': ConstConfig.osinfo,
          'transactionid': transactionid,
          'receiptdata': receiptdata,
          'appgoodid': appgoodid,
          'fee': fee,
          'orderid': orderid,
          'ptype': ptype,
          'validtime': validtime,
          'groupid': groupid,
        });
    var result = GetapplepayordertResult.fromJson(response.data);

    return result;
  }

  //查询订单记录
  Future<List<OrderRecord>> loadOrderRecordFClound(
      String mobile, int size, int page) async {
    var rep = await _http.get(
        "${ConstConfig.http_api_url_sales}/sales/order/list",
        queryParameters: {"mobile": mobile, "size": size, 'page': page});
    // var temp = rep.data as List;
    // List<OrderRecord> result = [];
    // result =
    //     temp.map((orderRecord) => OrderRecord.fromJson(orderRecord)).toList();
    var result = OrderRecordResult.fromJson(rep.data);
    List<OrderRecord> resultList = [];
    resultList = result.list!;
    return resultList;
  }

//获取已认证的企业
  Future<GetBusinessListReslt> getBusinessListReslt(String mobile) async {
    var rep = await _http.get(
        "${ConstConfig.http_api_url_sales}/sales/business/list",
        queryParameters: {"tel": mobile});
    var result = GetBusinessListReslt.fromJson(rep.data);
    return result;
  }

//获取套餐列表 channel：渠道 iOS（whInner_ios：分机套餐 whUpgrade_ios：升级套餐 whRenew_ios：续费套餐 whVoice_ios：语音通知套餐）
//获取套餐列表 channel：渠道 安卓（'whUpgrade'：升级套餐 'whRenew'：续费套餐 'whVoice'：语音通知套餐 'whInner'：分机套餐）
  Future<List<PackageItem>> getPackagesListResult(String channel) async {
    var rep = await _http
        .get("${ConstConfig.http_api_url_sales}/sales/business/wares/list",
            // "http://192.168.106.72:8025/sales/business/wares/list",
            queryParameters: {"channel": channel});
    var temp = rep.data as List;
    List<PackageItem> result = [];
    result = temp.map((item) => PackageItem.fromJson(item)).toList();
    return result;
  }

  ///获取套餐信息，默认取升级套餐的信息
  ///http://whtest.95013.com:8022/sales/business/ware/info?channel=whUpgrade&wareid=1
  ///whRenew&wareid=141
  Future<PackageItem> getBusinessWareInfo(
      // {String channel = 'whRenew', String wareid = '141'}) async {
      {String channel = 'whUpgrade',
      String wareid = 'app'}) async {
    var rep = await _http.get(
        "${ConstConfig.http_api_url_sales}/sales/business/ware/info",
        queryParameters: {"channel": channel, "wareid": wareid});
    var result = PackageItem.fromJson(rep.data);
    return result;
  }

  //企业名称和地址上传 outnumber：分机号 name：企业名称 address：地址
  Future<void> setenterNameAddress(
      String outnumber, String name, String address) async {
    await _http.get(
        join('${ConstConfig.http_api_url_sales}/sales/business/updatecustom'),
        queryParameters: {
          'outnumber': outnumber,
          'name': name,
          'address': address,
        });
    return null;
  }

  //企业名称和地址获取 outnumber：分机号
  Future<NamgeandAddressResult> getenterNameAddress(String outnumber) async {
    var response = await _http.get(
        join('${ConstConfig.http_api_url_sales}/sales/business/getcustom'),
        queryParameters: {
          'outnumber': outnumber,
        });
    var result = NamgeandAddressResult.fromJson(response.data);
    return result;
  }

  //企业认证-提交审核 name：企业名称  creditcode：社会统一信用代码 license：营业执照 contact：联系人姓名 mobile：联系人手机号 tel：用户手机号 update：0（无企业信息）1（有企业信息）
  Future<void> setenterpriseCertification(
      String name,
      String creditcode,
      String license,
      String contact,
      String mobile,
      String tel,
      String update) async {
    await _http.get(
        join('${ConstConfig.http_api_url_sales}/sales/business/verify'),
        queryParameters: {
          'name': name,
          'creditcode': creditcode,
          'license': license,
          'contact': contact,
          'mobile': mobile,
          'tel': tel,
          'type': accRepo.user!.numberType,
          'number': accRepo.user!.outerNumber,
          'update': update
        });
    return null;
  }

  //企业认证-获取企业认证信息 businessid：企业id
  Future<EnterpriseCertificationResult> getenterpriseCertification(
      String businessid) async {
    var response = await _http.post(
        join('${ConstConfig.http_api_url_sales}/sales/business/get'),
        queryParameters: {
          'businessid': businessid,
        });
    var result = EnterpriseCertificationResult.fromJson(response.data);

    return result;
  }

  //获取个人号和企业号信息
  Future<List<NumberInfo>> getAllNumbersInfo(String mobile) async {
    var response = await _http.post(
        join('${ConstConfig.http_api_url_sales}/sales/business/info'),
        queryParameters: {
          'mobile': mobile,
        });
    var temp = response.data as List;
    List<NumberInfo> result = [];
    result = temp
        .map((allNumberInfo) => NumberInfo.fromJson(allNumberInfo))
        .toList();
    return result;
  }

  //获取分机管理信息 number：95号
  Future<List<ExtensionResult>> getextensionmanagementInfo(
      String number) async {
    var response = await _http.post(
        join('${ConstConfig.http_api_url_sales}/sales/ext/manage'),
        queryParameters: {
          'number': number,
        });
    var temp = response.data as List;
    List<ExtensionResult> result = [];
    result = temp
        .map((extensionInfo) => ExtensionResult.fromJson(extensionInfo))
        .toList();
    return result;
  }

  // 编辑分机(未激活) outnumber：总机号 innernumber：分机号 name：分机名称 oid：分机id
  Future<void> editnoactiveExtension(
      String outnumber, String innernumber, String name, String oid) async {
    await _http.get(join('${ConstConfig.http_api_url_sales}/sales/ext/edit'),
        queryParameters: {
          'outnumber': outnumber,
          'innernumber': innernumber,
          'name': name,
          'oid': oid,
        });
    return null;
  }

  // 编辑分机(已激活) outnumber：总机号 innernumber：分机号 name：分机名称 oid：分机id mobile：手机号 code：验证码
  Future<void> editactiveExtension(String outnumber, String innernumber,
      String name, String oid, String mobile, String code) async {
    await _http.get(join('${ConstConfig.http_api_url_sales}/sales/ext/save'),
        queryParameters: {
          'outnumber': outnumber,
          'innernumber': innernumber,
          'name': name,
          'oid': oid,
          'mobile': mobile,
          'code': code,
        });
    return null;
  }

  //激活分机 outnumber：总机号 oid：分机id mobile：手机号 code：验证码
  Future<void> activeExtension(
      String outnumber, String oid, String mobile, String code) async {
    await _http.get(join('${ConstConfig.http_api_url_sales}/sales/ext/active'),
        queryParameters: {
          'outnumber': outnumber,
          'oid': oid,
          'mobile': mobile,
          'code': code,
        });
    return null;
  }

  //删除分机 outnumber：总机号 oid：分机id
  Future<void> deleteExtension(String outnumber, String oid) async {
    await _http.get(join('${ConstConfig.http_api_url_sales}/sales/ext/remove'),
        queryParameters: {
          'outnumber': outnumber,
          'oid': oid,
        });
    return null;
  }

//。。。省略。。。
  Future<String> upLoadImg(String imagePath) async {
    String imageurl = "";
    // if (imagePath == null) {
    //   return;
    // }
    var name =
        imagePath.substring(imagePath.lastIndexOf("/") + 1, imagePath.length);
    FormData formdata = FormData.fromMap(
      {
        "file": await MultipartFile.fromFile(
          imagePath,
          filename: name,
        )
      },
    );

    BaseOptions option = new BaseOptions(
        contentType: 'multipart/form-data', responseType: ResponseType.plain);

    Dio dio = new Dio(option);
    //application/json
    try {
      var respone = await _http.post(
          '${ConstConfig.http_api_url_sales}/sales/business/upload',
          data: formdata,
          queryParameters: {"file": name});
      if (respone.statusCode == 200) {
        // showtoast('图片上传成功');
        imageurl = respone.data["url"];
        //  result = EnterPriseCertificationResult.fromJson(respone.data);
      }
    } catch (e) {
      print("e:" + e.toString() + "   head=" + dio.options.headers.toString());
    }
    return imageurl;
  }

  //云通知，获取今天的通知详情
  Future<RecordToday> getRecordTodayResult(String mobile) async {
    var response = await _http.post(
        join('${ConstConfig.http_api_url_sales}/sales/recordToday'),
        queryParameters: {
          'mobile': mobile,
        });
    var result = RecordToday.fromJson(response.data);

    return result;
  }

  //云通知，获取剩余次充值
  Future<SearchSendTimesResult> searchSendTimes(String mobile) async {
    var response = await _http.post(
        join('${ConstConfig.http_api_url_sales}/sales/searchSendTimes'),
        queryParameters: {
          'mobile': mobile,
        });
    var result = SearchSendTimesResult.fromJson(response.data);

    return result;
  }

  //云通知，获取历史记录 callee：95号
  Future<NotiHistoryResult> getNotificationHistory(
      String mobile, int page, int limit, String callee) async {
    var response = await _http.post(
        join('${ConstConfig.http_api_url_sales}/sales/recordHistoryDetail'),
        queryParameters: {
          'mobile': mobile,
          'page': page,
          'limit': limit,
          'callee': callee,
        });
    var result = NotiHistoryResult.fromJson(response.data);

    return result;
  }

  //云通知，模版查询 status：取审核通过的模版
  Future<NotificationModelResult> getNotificationModel(
      String mobile, int page, int limit,
      {int status = -1}) async {
    var response = await _http.post(
        join('${ConstConfig.http_api_url_sales}/sales/template/queryListApp'),
        queryParameters: status == -1
            ? {
                'mobile': mobile,
                'page': page,
                'limit': limit,
              }
            : {'mobile': mobile, 'status': status});
    var result = NotificationModelResult.fromJson(response.data);

    return result;
  }

  //云通知，新增模版 templateName：新增模板名称 templateContent：新增模版内容
  Future<void> addNotificationModel(
      String mobile, String templateName, String templateContent) async {
    await _http.post(
        join(
            '${ConstConfig.http_api_url_sales}/sales/template/createTemplateApp'),
        queryParameters: {
          'mobile': mobile,
          'templateName': templateName,
          'templateContent': templateContent,
        });
    // var result = NotiHistoryResult.fromJson(response.data);
  }

  //云通知，更改模版 templateName：更改模版名称 templateContent：更改内容 templateId：模版id
  Future<void> updateNotificationModel(String mobile, String templateName,
      String templateContent, String templateId) async {
    await _http.post(
        join(
            '${ConstConfig.http_api_url_sales}/sales/template/updateTemplateApp'),
        queryParameters: {
          'mobile': mobile,
          'templateName': templateName,
          'templateContent': templateContent,
          'templateId': templateId,
        });
    // var result = NotiHistoryResult.fromJson(response.data);
    return null;
  }

  //云通知，删除模版 templateId：模版id
  Future<void> deleteNotificationTemplate(
      String mobile, String templateId) async {
    await _http.post(
        join(
            '${ConstConfig.http_api_url_sales}/sales/template/deleteTemplateApp'),
        queryParameters: {
          'mobile': mobile,
          'templateId': templateId,
        });
  }

  //云通知，试听 text：模版内容
  Future<String> textToVoice(String mobile, String text) async {
    var response = await _http.post(
        join('${ConstConfig.http_api_url_sales}/sales/template/textToVoice'),
        queryParameters: {
          'mobile': mobile,
          'text': text,
        });
    return response.data;
  }

  //获取当前套餐
  Future<CurrentPackage> getCurrentPackageResult(String number) async {
    var response = await _http.post(
        join('${ConstConfig.http_api_url_sales}/sales/business/wares/current'),
        // join('http://192.168.106.72:8025/sales/business/wares/current'),
        queryParameters: {
          'number': number,
        });
    var result = CurrentPackage.fromJson(response.data);

    return result;
  }

  Future<List<RecordDetail>> getRecordDetailListResult(String mobile, int page,
      int sendType, int statisticType, int recentDateType) async {
    var response = await _http.post(
        join('${ConstConfig.http_api_url_sales}/sales/recordDetail'),
        queryParameters: {
          'mobile': mobile,
          'page': page,
          'sendType': sendType,
          'limit': 10,
          'statisticType': statisticType,
          'recentDateType': recentDateType,
        });
    var result = RecordDetailListResult.fromJson(response.data);

    return result.list;
  }

  //http://localhost:8022/sales/announcement/send?mobile=15043211581&number=950133123342&templateId=1&callee=13011111111,13011111112，type：0语音 1短信 2两者
  /// templateId：模版id
  /// number：发送号码
  /// callee：接收号码
  /// type：通知类型：0语音通知 1短信通知 2语音通知+短信通知
  /// templateId：模版：id
  Future<void> sendNotice(String mobile, int type, String number,
      String templateId, String callee) async {
    await _http.post(
        join('${ConstConfig.http_api_url_sales}/sales/announcement/send'),
        queryParameters: {
          'mobile': mobile,
          'type': type,
          'number': number,
          'templateId': templateId,
          'callee': callee,
        });
    return null;
  }

  //http://39.97.232.211:8070/ipcboss/dianhuaju/app/banner/query
  Future<GetBannerResult> getBanner() async {
    var response = await _http
        .get(join('${accRepo.httpUrlPath}/dianhuaju/app/banner/query'));
    var result = GetBannerResult.fromJson(response.data);
    return result;
  }

  ///获取号码续费套餐
  Future<ReNewNumPackage> getRenewExtNumPack(String number) async {
    number=number.replaceAll(' ', '');
    var response = await _http.get(
        join('${ConstConfig.http_api_url_sales}/sales/business/wares/renew'),
        queryParameters: {
          "number": number,
          'source': Platform.isAndroid ? 0 : 1
        });
    var result = ReNewNumPackage.fromJson(response.data);
    return result;
  }

  ///升级到企业联络中心
  Future<void> doUpgrade(String number) async {
    await _http.get(
        join('${ConstConfig.http_api_url_sales}/sales/business/upgrade'),
        queryParameters: {"number": number, 'mobile': accRepo.user!.mobile!});
  }

  ///获取分享内容
  ///http://192.168.106.72:8022/sales/share/info?outnumber=95013345678&mobile=13011110000&oid=12
  Future<ShareMsgResult> getShareMsg(String oid) async {
    var response = await _http.get(
        join('${ConstConfig.http_api_url_sales}/sales/share/info'),
        queryParameters: {
          "outnumber": accRepo.user!.outerNumber!,
          'mobile': accRepo.user!.mobile!,
          'oid': oid
        });
    return ShareMsgResult.fromJson(response.data);
  }

  ///分机续费 获取套餐信息 validtime：过期时间
  ///http://localhost:8022/sales/ext/ware/info?number=950133587929
  Future<WareInfoResult> getWareInfo(String validtime, String orderId) async {
    var response = await _http.get(
        join('${ConstConfig.http_api_url_sales}/sales/ext/ware/info'),
        queryParameters: {
          "number": accRepo.user!.outerNumber!,
          "validtime": validtime,
          "orderid": orderId,
          'source': Platform.isAndroid ? 0 : 1
        });
    return WareInfoResult.fromJson(response.data);
  }
}
