import 'package:weihua_flutter/config/const_config.dart';
import 'package:weihua_flutter/utils/log.dart';

import 'base_api.dart';

///
/// @Desc: 接口配置
/// @Author: zhhli
/// @Date: 2021-03-24
///
class HttpApp extends BaseHttp {
  @override
  void init() {
    options.baseUrl = "${ConstConfig.http_api_url}/ipcboss/";
    interceptors.add(ApiInterceptor(this));
  }
}

class ApiInterceptor extends InterceptorsWrapper {
  HttpApp httpApp;

  ApiInterceptor(this.httpApp);

  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);
    Log.d('---api-request--->url--> ${options.baseUrl}${options.path}' +
        ' queryParameters: ${options.queryParameters}');
  }

  @override
  onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    ResponseData result = ResponseData.fromJson(response.data);
    if (result.success) {
      response.data = result.data;
      //return httpApp.resolve(response);
      return handler.next(response);
    } else {
      throw NotSuccessException.fromRespData(result);
    }
  }
}

class ResponseData extends BaseResponseData {
  // 错误代码， 0 表示执行成功，其他表示失败
  bool get success => result == "true";

  String result = '';

  ResponseData.fromJson(Map<String, dynamic> json) {
    code = int.parse(json['code']);
    message = json['msg'] ?? '';
    result = json['result'] ?? 'true';
    data = json['data'];
  }
}
