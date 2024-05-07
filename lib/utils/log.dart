import 'package:logger/logger.dart';
import 'package:stack_trace/stack_trace.dart';

///
/// @Desc:
/// @Author: zhhli
/// @Date: 2021-03-23
///
class Log {
  Log._();

  static final _logger = Logger(
    // printer: PrettyPrinter(methodCount: 0),
    printer: SimplePrinter(),
  );

  static void v(Object message) {
    _logger.v(message);
  }

  static void d(Object message) {
    _logger.d(message);
  }

  static void w(Object message) {
    _logger.w(message);
  }

  static void e(Object message) {
    _logger.e(message);
  }

  /// 智能在 debug 时调用，用完删除，否则 无法打包release版本
  static void eTrace({String tag = "zzzzzzzzzzzz"}) {
    final chain = Chain.forTrace(StackTrace.current);
// 拿出其中一条信息
    final frames = chain.toTrace().frames;
    for (var frame in frames) {
      if (frame.uri.toString().startsWith("package:app_phone_flutter")) {
        Log.e("$tag：${frame.location} ${frame.member}");
      }
    }
    Log.e("$tag ：=======================================");
  }
}
