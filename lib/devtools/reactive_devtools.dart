import '../core/reactive_model.dart';
import 'package:flutter/material.dart';

class ReactiveInspector extends StatelessWidget {
  final ReactiveModel model;

  const ReactiveInspector({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Reactive Model: ${model.runtimeType}'),
      children: [
        ...model.fieldListeners.keys.map(
          (f) => Text(
            'Field: $f, listeners: ${model.fieldListeners[f]?.length ?? 0}',
          ),
        ),
        Text(
          'Nested models: ${model.nestedModels.map((e) => e.runtimeType).join(", ")}',
        ),
      ],
    );
  }
}
