import 'package:flutter/material.dart';
import 'reactive_model.dart';

class ReactiveBuilder<T extends ReactiveModel> extends StatefulWidget {
  final T model;
  final Widget Function(T model) builder;

  const ReactiveBuilder({
    required this.model,
    required this.builder,
    super.key,
  });

  @override
  ReactiveBuilderState<T> createState() => ReactiveBuilderState<T>();
}

class ReactiveBuilderState<T extends ReactiveModel>
    extends State<ReactiveBuilder<T>> {
  @override
  void initState() {
    super.initState();
    widget.model.addListener(_onModelChange);
  }

  void _onModelChange() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.model.removeListener(_onModelChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(widget.model);
  }
}
