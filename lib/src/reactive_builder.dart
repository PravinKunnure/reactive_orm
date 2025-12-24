import 'package:flutter/material.dart';
import 'reactive_model.dart';

class ReactiveBuilder<T extends ReactiveModel> extends StatefulWidget {
  final T model;
  final Widget Function(T model) builder;
  final List<String>? fields; // optional field filter

  const ReactiveBuilder({
    required this.model,
    required this.builder,
    this.fields,
    super.key,
  });

  @override
  ReactiveBuilderState<T> createState() => ReactiveBuilderState<T>();
}

class ReactiveBuilderState<T extends ReactiveModel> extends State<ReactiveBuilder<T>> {
  void _onChange() => setState(() {});

  @override
  void initState() {
    super.initState();
    if (widget.fields != null) {
      for (var f in widget.fields!) {
        widget.model.addListener(_onChange, field: f);
      }
    } else {
      widget.model.addListener(_onChange); // listen to all fields
    }
  }

  @override
  void dispose() {
    if (widget.fields != null) {
      for (var f in widget.fields!) {
        widget.model.removeListener(_onChange, field: f);
      }
    } else {
      widget.model.removeListener(_onChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(widget.model);
}




///Try Version
// import 'package:flutter/material.dart';
// import 'reactive_model.dart';
//
// class ReactiveBuilder<T extends ReactiveModel> extends StatefulWidget {
//   final T model;
//   final Widget Function(T model) builder;
//   final List<String>? fields; // optional list of fields to listen to
//
//   const ReactiveBuilder({
//     required this.model,
//     required this.builder,
//     this.fields,
//     super.key,
//   });
//
//   @override
//   ReactiveBuilderState<T> createState() => ReactiveBuilderState<T>();
// }
//
// class ReactiveBuilderState<T extends ReactiveModel> extends State<ReactiveBuilder<T>> {
//   void _onChange() => setState(() {});
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.fields != null) {
//       for (var field in widget.fields!) {
//         widget.model.addListener(_onChange, field: field);
//       }
//     } else {
//       widget.model.addListener(_onChange); // listens to all fields
//     }
//   }
//
//   @override
//   void dispose() {
//     if (widget.fields != null) {
//       for (var field in widget.fields!) {
//         widget.model.removeListener(_onChange, field: field);
//       }
//     } else {
//       widget.model.removeListener(_onChange);
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.builder(widget.model);
//   }
// }




///Version 0.0.1
/*
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
*/
