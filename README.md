# reactive_orm

[![Pub Version](https://img.shields.io/pub/v/reactive_orm)](https://pub.dev/packages/reactive_orm) | [![License: MIT](https://img.shields.io/badge/license-MIT-green)](https://opensource.org/licenses/MIT)

A **lightweight, reactive ORM-style state management package for Flutter**. Update your UI automatically when model properties change — **without `setState`, streams, or boilerplate**.

> Version: 0.0.5 – Stable


---

## 🎬 Demo

![Reactive_ORM Demo](https://raw.githubusercontent.com/PravinKunnure/reactive_orm/main/example/assets/reactive_orm_demo_.gif)

---

## ✨ Core Philosophy

- Models are **plain Dart objects**.
- State changes happen via **normal field mutation**.
- UI reacts **automatically**, with optional field-specific reactivity.
- No `ChangeNotifier`, providers, streams, or extra boilerplate.

---

## ✨ Features

- ✅ Reactive models with automatic UI updates
- ✅ Object-wise reactivity (entire model rebuilds)
- ✅ Field-wise reactivity (only selected fields rebuild)
- ✅ Nested & shared models supported
- ✅ Multiple widgets can listen to the same model

---

## 🆚 Comparison

| Feature                    | ValueNotifier                | reactive_orm                               |
|----------------------------|------------------------------|--------------------------------------------|
| Observes a single field?   | Yes (one notifier per field) | Yes (field-wise) + whole object           |
| Field assignment syntax    | `notifier.value = newValue`  | `model.field = newValue (auto-notifies)`  |
| Multiple widgets listening | Manual wiring                | Automatic                                  |
| Nested models              | Manual                       | Built-in (`addNested`)                     |
| Boilerplate                | Medium → High                | Minimal, ORM-style                         |
| Ideal for                  | Simple values                | Complex reactive models                     |

---

## 🚀 Getting Started

### Installation

```yaml
dependencies:
  reactive_orm: ^0.0.4


🧩 Basic Usage
1️⃣ Create a Reactive Model
import 'package:reactive_orm/reactive_orm.dart';

class Task extends ReactiveModel {
  String _title;
  bool _completed = false;
  String _status = "Idle";

  Task({required String title}) : _title = title;

  String get title => _title;
  set title(String value) {
    if (_title != value) {
      _title = value;
      notifyListeners('title');
    }
  }

  bool get completed => _completed;
  set completed(bool value) {
    if (_completed != value) {
      _completed = value;
      notifyListeners('completed');
    }
  }

  String get status => _status;
  set status(String value) {
    if (_status != value) {
      _status = value;
      notifyListeners('status');
    }
  }
}


2️⃣ Object-wise Reactivity (Whole Object)
Any field change rebuilds the widget:

final task = Task(title: "Object-wise");

ReactiveBuilder<Task>(
  model: task,
  builder: (t) => ListTile(
    title: Text(t.title),
    subtitle: Text(t.status),
    trailing: Checkbox(
      value: t.completed,
      onChanged: (v) => t.completed = v!,
    ),
  ),
);


3️⃣ Field-wise Reactivity (Optimized)
Widget rebuilds only when specified fields change:

final task = Task(title: "Field-wise");

ReactiveBuilder<Task>(
  model: task,
  fields: ['completed', 'status'],
  builder: (t) => ListTile(
    title: Text(t.title),
    subtitle: Text(t.status),
    trailing: Checkbox(
      value: t.completed,
      onChanged: (v) => t.completed = v!,
    ),
  ),
);
- Rebuilds only when completed or status changes.
- Changes to other fields are ignored.

🔗 Relationship Patterns
1-> Many → One (Aggregation)
    Multiple models feed a single reactive observer:
class Dashboard extends ReactiveModel {
  final List<Task> sources;
  Dashboard(this.sources) {
    for (final task in sources) addNested(task);
  }
}

final dashboard = Dashboard([task1, task2]);

ReactiveBuilder<Dashboard>(
  model: dashboard,
  builder: (_) => Text("Dashboard updated"),
);
- ✔ Any task change updates the dashboard automatically.


2-> Many ↔ Many (Shared Models)
    Same model instance used across multiple parents:
class Group extends ReactiveModel {
  final String name;
  final List<Task> tasks;

  Group({required this.name, required this.tasks}) {
    for (final task in tasks) addNested(task);
  }
}

- ✔ One task update reflects everywhere.
- ✔ No duplication or manual syncing required.


🧠 How It Works (High Level)
- Models extend ReactiveModel.
- Field setters call notifyListeners(fieldName) when the value changes.
- ReactiveBuilder widgets listen to either:
- Whole model (object-wise)
- Specific fields (field-wise)
- Nested models propagate changes upward automatically.
- Widgets rebuild safely, respecting Flutter lifecycle.


🛣 Roadmap
- Batch updates / transactions
- Async persistence hooks
- Database adapters
- DevTools / debug inspector
- Optional code generation


🧪 Status
- Version: 0.0.5
- Stability: Stable/No major updates are peding
- Use case: Learning, prototyping, early production experiments


📌 Summary
- reactive_orm is ideal when you want:
- Clean Dart models
- Minimal boilerplate
- ORM-like mental model
- Fine-grained UI reactivity
- No framework lock-in
