// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

class BlocManager {
  static final Map<Type, Object> _instances = {};
  static final Map<Type, int> _refCounts = {};

  /// Get or create a Bloc instance
  static T getBloc<T>(T Function() create) {
    if (!_instances.containsKey(T)) {
      _instances[T] = create()!;
      _refCounts[T] = 0;
    }
    _refCounts[T] = (_refCounts[T] ?? 0) + 1;
    return _instances[T] as T;
  }

  /// Release a Bloc instance and close it if no longer used
  static void releaseBloc<T>() {
    if (_refCounts.containsKey(T) && _refCounts[T]! > 0) {
      _refCounts[T] = _refCounts[T]! - 1;
      if (_refCounts[T] == 0) {
        (_instances[T] as BlocBase).close();
        _instances.remove(T);
        _refCounts.remove(T);
      }
    }
  }
}

class GlobalBlocProvider<T extends BlocBase> extends SingleChildStatefulWidget {
  final T Function() create;
  final Widget? child;

  const GlobalBlocProvider({super.key, required this.create, this.child});

  @override
  _GlobalBlocProviderState<T> createState() => _GlobalBlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    return BlocProvider.of<T>(context);
  }
}

class _GlobalBlocProviderState<T extends BlocBase>
    extends SingleChildState<GlobalBlocProvider<T>> {
  late final T _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocManager.getBloc<T>(widget.create);
  }

  @override
  void dispose() {
    BlocManager.releaseBloc<T>();
    super.dispose();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return BlocProvider<T>.value(
      value: _bloc,
      child: child ?? widget.child,
    );
  }
}
