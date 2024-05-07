import 'dart:convert';

import 'package:weihua_flutter/utils/platform_utils.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter/foundation.dart';

export 'package:dio/dio.dart';

// 必须是顶层函数
_parseAndDecode(String response) {
  /// 由于 接口返回  content-type: text/html; charset=UTF-8
  /// 无法进入 json 解析器
  /// 为了防止 content-type: application/json; charset=utf-8 ，在 dio中自动解析
  /// 统一返回 string
  /// 在 ResponseInterceptor 中进行解析
  return response;
  // return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

abstract class BaseHttp extends DioForNative {
  BaseHttp() {
    /// 初始化 加入app通用处理
    (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    interceptors
      ..add(HeaderInterceptor())
      ..add(ResponseInterceptor())
      ..add(LogInterceptor(requestBody: true, responseBody: true));
    init();
  }

  void init();
}

/// 添加常用Header
class HeaderInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.connectTimeout = 1000 * 45;
    options.receiveTimeout = 1000 * 45;

    var appVersion = await PlatformUtils.getAppVersion();
    var version = Map()
      ..addAll({
        'appVerison': appVersion,
      });
    options.headers['version'] = version;
    options.headers['platform'] = Platform.operatingSystem;
    // return options;

    super.onRequest(options, handler);
  }
}

class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    var data = response.data;
    response.data = jsonDecode(data);
    super.onResponse(response, handler);
  }
}

/// 子类需要重写
abstract class BaseResponseData {
  int code = 0;
  String message = '';
  dynamic data;

  bool get success;

  BaseResponseData({this.code = 0, this.message = '', this.data});

  @override
  String toString() {
    return 'BaseRespData{code: $code, message: $message, data: $data}';
  }
}

/// 接口的code没有返回为true的异常
class NotSuccessException implements Exception {
  String message = '';

  NotSuccessException.fromRespData(BaseResponseData respData) {
    message = respData.message;
  }

  @override
  String toString() {
    return 'NotExpectedException{respData: $message}';
  }
}

/// 用于未登录等权限不够,需要跳转授权页面
class UnAuthorizedException implements Exception {
  const UnAuthorizedException();

  @override
  String toString() => 'UnAuthorizedException';
}
