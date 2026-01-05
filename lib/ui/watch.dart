import 'package:flutter/widgets.dart';
import 'package:reactive_orm/reactive_orm.dart';

extension ReactiveWatch<T extends ReactiveModel> on T {
  Widget watch(Widget Function(T model) builder, {List<Symbol>? fields}) {
    return ReactiveBuilder<T>(model: this, fields: fields, builder: builder);
  }
}
