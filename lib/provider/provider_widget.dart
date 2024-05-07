import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Provider封装类
///
/// 方便数据初始化
///
///
/// ProviderWidget<LoginModel>(
//    model: LoginModel(),
//    builder: (context, model, child) {
//      return Text("123");
//    }
//  )
///
class ProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  final ValueWidgetBuilder<T> builder;
  final T model;
  final Widget? child;
  final Function(T model)? onModelReady;
  final bool autoDispose;

  ProviderWidget({
    Key? key,
    required this.builder,
    required this.model,
    this.child,
    this.onModelReady,
    this.autoDispose = true,
  }) : super(key: key);

  _ProviderWidgetState<T> createState() => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends ChangeNotifier>
    extends State<ProviderWidget<T>> {
  late T model;

  @override
  void initState() {
    model = widget.model;
    widget.onModelReady?.call(model);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      // https://flutter.cn/docs/development/data-and-backend/state-mgmt/simple#consumer
      // Consumer widget 唯一必须的参数就是 builder。
      // 当 ChangeNotifier 发生变化的时候会调用 builder 这个函数。
      //（换言之，当你在模型中调用 notifyListeners() 时，所有和 Consumer 相关的 builder 方法都会被调用。）
      // builder 在被调用的时候会用到三个参数。
      // 第一个是 context。在每个 build 方法中都能找到这个参数。
      // 第二个参数是 ChangeNotifier 的实例。它是我们最开始就能得到的实例。你可以通过该实例定义 UI 的内容。
      // 第三个参数是 child，用于优化目的。如果 Consumer 下面有一个庞大的子树，
      // 当模型发生改变的时候，该子树 并不会 改变，那么你就可以仅仅创建它一次，然后通过 builder 获得该实例。
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}

class ProviderWidget2<A extends ChangeNotifier, B extends ChangeNotifier>
    extends StatefulWidget {
  final Widget Function(BuildContext context, A model1, B model2, Widget? child)
      builder;
  final A model1;
  final B model2;
  final Widget? child;
  final Function(A model1, B model2)? onModelReady;
  final bool autoDispose;

  ProviderWidget2({
    Key? key,
    required this.builder,
    required this.model1,
    required this.model2,
    this.child,
    this.onModelReady,
    this.autoDispose = true,
  }) : super(key: key);

  _ProviderWidgetState2<A, B> createState() => _ProviderWidgetState2<A, B>();
}

class _ProviderWidgetState2<A extends ChangeNotifier, B extends ChangeNotifier>
    extends State<ProviderWidget2<A, B>> {
  late A model1;
  late B model2;

  @override
  void initState() {
    model1 = widget.model1;
    model2 = widget.model2;
    widget.onModelReady?.call(model1, model2);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      model1.dispose();
      model2.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<A>.value(value: model1),
          ChangeNotifierProvider<B>.value(value: model2),
        ],
        child: Consumer2<A, B>(
          builder: widget.builder,
          child: widget.child,
        ));
  }
}

/// 不带 Consumer
class ProviderWidgetNoConsumer<T extends ChangeNotifier>
    extends StatefulWidget {
  // final Builder builder;
  final T model;
  final Widget child;
  final Function(T model)? onModelReady;
  final bool autoDispose;

  ProviderWidgetNoConsumer({
    Key? key,
    // @required this.builder,
    required this.model,
    required this.child,
    this.onModelReady,
    this.autoDispose = true,
  }) : super(key: key);

  _ProviderWidgetNoConsumerState<T> createState() =>
      _ProviderWidgetNoConsumerState<T>();
}

class _ProviderWidgetNoConsumerState<T extends ChangeNotifier>
    extends State<ProviderWidgetNoConsumer<T>> {
  late T model;

  @override
  void initState() {
    model = widget.model;
    widget.onModelReady?.call(model);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: widget.child,
    );
  }
}

class ProviderWidgetNoConsumer2<A extends ChangeNotifier,
    B extends ChangeNotifier> extends StatefulWidget {
  // final Widget Function(BuildContext context, A model1, B model2, Widget child)
  // builder;
  final A model1;
  final B model2;
  final Widget? child;
  final Function(A model1, B model2)? onModelReady;
  final bool autoDispose;

  ProviderWidgetNoConsumer2({
    Key? key,
    // @required this.builder,
    required this.model1,
    required this.model2,
    this.child,
    this.onModelReady,
    this.autoDispose = true,
  }) : super(key: key);

  _ProviderWidgetNoConsumerState2<A, B> createState() =>
      _ProviderWidgetNoConsumerState2<A, B>();
}

class _ProviderWidgetNoConsumerState2<A extends ChangeNotifier,
    B extends ChangeNotifier> extends State<ProviderWidgetNoConsumer2<A, B>> {
  late A model1;
  late B model2;

  @override
  void initState() {
    model1 = widget.model1;
    model2 = widget.model2;
    widget.onModelReady?.call(model1, model2);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      model1.dispose();
      model2.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<A>.value(
          value: model1,
          child: widget.child,
        ),
        ChangeNotifierProvider<B>.value(
          value: model2,
          child: widget.child,
        ),
      ],
      // child: Consumer2<A, B>(
      //   builder: widget.builder,
      //   child: widget.child,
      // )
      child: widget.child,
    );
  }
}
