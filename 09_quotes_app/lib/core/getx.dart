import 'dart:async';
import 'package:flutter/material.dart';

/// Lightweight, self-contained implementation of GetX primitives
/// matching the exact API demonstrated in the Udemy Flutter course.

// --- Global Navigation Key ---
final GlobalKey<NavigatorState> _getNavigatorKey = GlobalKey<NavigatorState>();

GlobalKey<NavigatorState> get getNavigatorKey => _getNavigatorKey;

// --- Reactive Primitives ---

/// Extension to enable .obs on any primitive, object, or list
extension ReactiveExtension<T> on T {
  Rx<T> get obs => Rx<T>(this);
}

extension RxListExtension<E> on List<E> {
  RxList<E> get obs => RxList<E>(this);
}

/// Reactive generic wrapper
class Rx<T> {
  T _value;
  final StreamController<T> _controller = StreamController<T>.broadcast();

  Rx(this._value);

  T get value {
    _RxTrackingContext.register(this);
    return _value;
  }

  set value(T val) {
    if (_value != val) {
      _value = val;
      _controller.add(_value);
    }
  }

  Stream<T> get stream => _controller.stream;

  void update(void Function(T? val) fn) {
    fn(_value);
    _controller.add(_value);
  }

  void refresh() {
    _controller.add(_value);
  }

  void close() {
    _controller.close();
  }

  @override
  String toString() => _value.toString();
}

/// Reactive list wrapper
class RxList<E> extends Rx<List<E>> {
  RxList(List<E> initial) : super(List<E>.from(initial));

  int get length {
    _RxTrackingContext.register(this);
    return _value.length;
  }

  bool get isEmpty {
    _RxTrackingContext.register(this);
    return _value.isEmpty;
  }

  bool get isNotEmpty {
    _RxTrackingContext.register(this);
    return _value.isNotEmpty;
  }

  E operator [](int index) {
    _RxTrackingContext.register(this);
    return _value[index];
  }

  void operator []=(int index, E value) {
    _value[index] = value;
    refresh();
  }

  void add(E item) {
    _value.add(item);
    refresh();
  }

  void addAll(Iterable<E> iterable) {
    _value.addAll(iterable);
    refresh();
  }

  bool remove(Object? item) {
    final result = _value.remove(item);
    if (result) refresh();
    return result;
  }

  void clear() {
    _value.clear();
    refresh();
  }

  void assignAll(Iterable<E> iterable) {
    _value.clear();
    _value.addAll(iterable);
    refresh();
  }
}

// --- Tracking Context for Obx ---
class _RxTrackingContext {
  static final List<Set<Rx>> _stack = [];

  static void begin() {
    _stack.add(<Rx>{});
  }

  static void register(Rx rx) {
    if (_stack.isNotEmpty) {
      _stack.last.add(rx);
    }
  }

  static Set<Rx> end() {
    if (_stack.isEmpty) return {};
    return _stack.removeLast();
  }
}

/// Obx widget that rebuilds when any watched Rx value changes
class Obx extends StatefulWidget {
  final Widget Function() builder;

  const Obx(this.builder, {super.key});

  @override
  State<Obx> createState() => _ObxState();
}

class _ObxState extends State<Obx> {
  final List<StreamSubscription> _subscriptions = [];

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }

  void _subscribe(Set<Rx> tracked) {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();

    for (final rx in tracked) {
      final sub = rx.stream.listen((_) {
        if (mounted) setState(() {});
      });
      _subscriptions.add(sub);
    }
  }

  @override
  Widget build(BuildContext context) {
    _RxTrackingContext.begin();
    final widgetTree = widget.builder();
    final tracked = _RxTrackingContext.end();
    _subscribe(tracked);
    return widgetTree;
  }
}

// --- GetxController ---
class GetxController {
  bool _initialized = false;

  void onInit() {
    _initialized = true;
  }

  void onReady() {}

  void onClose() {}

  void update() {
    // Notify controller-level listeners if any
  }
}

// --- Get Dependency Injection & Navigation Singleton ---
class Get {
  static final Map<Type, dynamic> _dependencies = {};

  static T put<T>(T dependency, {String? tag, bool permanent = false}) {
    _dependencies[T] = dependency;
    if (dependency is GetxController && !dependency._initialized) {
      dependency.onInit();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        dependency.onReady();
      });
    }
    return dependency;
  }

  static T find<T>({String? tag}) {
    final dep = _dependencies[T];
    if (dep == null) {
      throw Exception('Get: Instance of $T not found. Call Get.put($T()) first.');
    }
    return dep as T;
  }

  static void reset() {
    for (final dep in _dependencies.values) {
      if (dep is GetxController) {
        dep.onClose();
      }
    }
    _dependencies.clear();
  }

  // Navigation helpers
  static Future<T?>? to<T>(Widget page) {
    return _getNavigatorKey.currentState?.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<T?>? toNamed<T>(String routeName, {dynamic arguments}) {
    return _getNavigatorKey.currentState?.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  static void back<T>([T? result]) {
    _getNavigatorKey.currentState?.pop(result);
  }

  static void snackbar(
    String title,
    String message, {
    Color? backgroundColor,
    Color? colorText,
    Duration duration = const Duration(seconds: 3),
    SnackPosition snackPosition = SnackPosition.bottom,
  }) {
    final context = _getNavigatorKey.currentContext;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: colorText ?? Colors.white)),
            Text(message, style: TextStyle(color: colorText ?? Colors.white70)),
          ],
        ),
        backgroundColor: backgroundColor ?? Colors.black87,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

enum SnackPosition { top, bottom }

/// GetMaterialApp replacing standard MaterialApp
class GetMaterialApp extends StatelessWidget {
  final Widget? home;
  final String? initialRoute;
  final Map<String, WidgetBuilder>? routes;
  final RouteFactory? onGenerateRoute;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final String title;
  final bool debugShowCheckedModeBanner;

  const GetMaterialApp({
    super.key,
    this.home,
    this.initialRoute,
    this.routes,
    this.onGenerateRoute,
    this.theme,
    this.darkTheme,
    this.title = 'GetX App',
    this.debugShowCheckedModeBanner = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _getNavigatorKey,
      home: home,
      initialRoute: initialRoute,
      routes: routes ?? const <String, WidgetBuilder>{},
      onGenerateRoute: onGenerateRoute,
      theme: theme,
      darkTheme: darkTheme,
      title: title,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
    );
  }
}
