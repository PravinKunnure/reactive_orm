import 'package:flutter/material.dart';
import 'package:reactive_orm/reactive_orm.dart';

class ReactiveSelector<T extends ReactiveModel, V> extends StatefulWidget {
  final T model;
  final Symbol? field; // optional
  final V Function(T model) selector;
  final Widget Function(V value) builder;

  const ReactiveSelector({
    required this.model,
    required this.selector,
    required this.builder,
    this.field,
    super.key,
  });

  @override
  State<ReactiveSelector<T, V>> createState() => _ReactiveSelectorState<T, V>();
}

class _ReactiveSelectorState<T extends ReactiveModel, V>
    extends State<ReactiveSelector<T, V>> {
  late V value;

  void _onChange() {
    setState(() {
      value = widget.selector(widget.model);
    });
  }

  @override
  void initState() {
    super.initState();
    value = widget.selector(widget.model);
    widget.model.addListener(_onChange, field: widget.field);
  }

  @override
  void dispose() {
    widget.model.removeListener(_onChange, field: widget.field);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(value);
  }
}
