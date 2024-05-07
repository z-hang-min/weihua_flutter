import 'dart:io';

import 'package:weihua_flutter/config/net/base_api.dart';
import 'package:weihua_flutter/generated/l10n.dart';
import 'package:weihua_flutter/provider/view_state.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

///
/// @Desc:
///
/// @Author: zhhli
///
/// @Date: 21/7/21
///
class XViewController extends GetxController {

  /// 当前的页面状态,默认为busy,可在viewModel的构造方法中指定;
  late Rx<ViewState> _viewState;

  final String codeCancelError = "code_cancel";

  /// 根据状态构造
  ///
  /// 子类可以在构造函数指定需要的页面状态
  /// FooModel():super(viewState:ViewState.busy);
  XViewController({ViewState? viewState}) {
    if (viewState != null) {
      _viewState = viewState.obs;
    } else {
      _viewState = ViewState.idle.obs;
    }
    // debugPrint('ViewStateModel---constructor--->$runtimeType');
  }

  /// ViewState
  ViewState get viewState => _viewState.value;

  set viewState(ViewState viewState) {
    _viewStateError = null;
    _viewState.value = viewState;
    _viewState.refresh();
    // notifyListeners();
  }

  /// ViewStateError
  ViewStateError? _viewStateError;

  ViewStateError? get viewStateError => _viewStateError;

  /// 以下变量是为了代码书写方便,加入的get方法.严格意义上讲,并不严谨
  ///
  /// get
  bool get isBusy => viewState == ViewState.busy;

  bool get isIdle => viewState == ViewState.idle;

  bool get isEmpty => viewState == ViewState.empty;

  bool get isError => viewState == ViewState.error;

  /// set
  void setIdle() {
    viewState = ViewState.idle;
  }

  void setBusy() {
    viewState = ViewState.busy;
  }

  void setEmpty() {
    viewState = ViewState.empty;
  }

  /// [e]分类Error和Exception两种
  void setError(e, stackTrace, {String message = ""}) {
    ViewStateErrorType errorType = ViewStateErrorType.defaultError;

    /// 见https://github.com/flutterchina/dio/blob/master/README-ZH.md#dioerrortype
    if (e is DioError) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        // timeout
        errorType = ViewStateErrorType.networkTimeOutError;
        message = e.error;
      } else if (e.type == DioErrorType.response) {
        // incorrect status, such as 404, 503...
        message = e.error;
      } else if (e.type == DioErrorType.cancel) {
        // to be continue...
        message = e.error;
      } else {
        // dio将原error重新套了一层
        e = e.error;
        if (e is UnAuthorizedException) {
          stackTrace = null;
          errorType = ViewStateErrorType.unauthorizedError;
        } else if (e is NotSuccessException) {
          stackTrace = null;
          message = e.message;
        } else if (e is SocketException) {
          errorType = ViewStateErrorType.networkTimeOutError;
          message = e.message;
        } else {
          message = e.message;
        }
      }
    }
    viewState = ViewState.error;
    _viewStateError = ViewStateError(
      errorType,
      message: message,
      errorMessage: e.toString(),
    );
    printErrorStack(e, stackTrace);
    onError(_viewStateError!);
  }

  void onError(ViewStateError viewStateError) {}

  /// 显示错误消息
  showErrorMessage(context, {String? message}) {
    if (viewStateError != null || message != null) {
      if (viewStateError!.isNetworkTimeOut) {
        message ??= S.of(context).viewStateMessageNetworkError;
      } else {
        message ??= viewStateError!.message;
      }
      Future.microtask(() {
        if (codeCancelError != message) {
          showToast(message ?? '', context: context);
        }
        Future.delayed(
          const Duration(milliseconds: 1),
          () => setIdle(),
        );
        setIdle();
      });
    }
  }

  @override
  String toString() {
    return 'BaseModel{_viewState: $viewState, _viewStateError: $_viewStateError}';
  }

  @override
  void dispose() {
    // debugPrint('view_state_model dispose -->$runtimeType');
    super.dispose();
  }

  Future<bool> asyncHttp(AsyncHttpFunction asyncHttpCallback) async {
    setBusy();
    try {
      await asyncHttpCallback();
      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      // setIdle();
      return false;
    }
  }
}

typedef AsyncHttpFunction = Future<void> Function();
