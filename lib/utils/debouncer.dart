import 'dart:async';

///
/// @Desc: 去抖动器
///
/// use：
///
/// final _debouncor = Debouncer();
/// final _debouncor = Debouncer(delay：const Duration(milliseconds: 500));
///
/// _debouncer(() {
///      // your action
/// })
///
/// @Author: zhhli
///
/// @Date: 21/8/30
///
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 300)});

  call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  cancel() {
    _timer?.cancel();
  }
}
