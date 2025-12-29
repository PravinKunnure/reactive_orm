# reactive_orm

[![Pub Version](https://img.shields.io/pub/v/reactive_orm)](https://pub.dev/packages/reactive_orm) | [![License: MIT](https://img.shields.io/badge/license-MIT-green)](https://opensource.org/licenses/MIT)

> ⚠️ **Note:** `reactive_orm` stands for a **Reactive Object–Relationship Model**.  
> It is **not a database ORM**.  
> It is a lightweight, field-level **state management solution** for Flutter UI, inspired by ORM-style modeling of objects and relationships — fully in-memory and UI-focused.

---

## 🎬 Demo

![Reactive_ORM Demo](https://raw.githubusercontent.com/PravinKunnure/reactive_orm/main/example/assets/reactive_orm_demo_.gif)

---

## ✨ Core Philosophy

- Models are **plain Dart objects**
- State changes happen via **normal field mutation**
- UI reacts **automatically**, with optional field-specific reactivity
- No `ChangeNotifier`, providers, streams, or extra boilerplate
- Supports **object-wise**, **field-wise**, and **nested reactivity**
- ORM-inspired design:
  - Objects represent application state
  - Relationships define propagation (Many → One, Many ↔ Many)
  - Reactivity keeps the UI in sync

---

## ✨ Features

- ✅ Reactive models with automatic UI updates
- ✅ Object-wise reactivity (entire model rebuilds)
- ✅ Field-wise reactivity (only selected fields rebuild)
- ✅ Nested & shared models supported
- ✅ Many → One and Many ↔ Many relationships
- ✅ Multiple widgets can listen to the same model
- ✅ Minimal boilerplate
- ✅ ORM-style mental model (Objects + Relationships)

---

## 🆚 Comparison

| Feature                    | ValueNotifier                | reactive_orm                               |
|----------------------------|------------------------------|--------------------------------------------|
| Observes a single field?   | Yes (one notifier per field) | Yes (field-wise) + whole object            |
| Field assignment syntax    | `notifier.value = newValue`  | `model.field = newValue` (auto-notifies)   |
| Multiple widgets listening | Manual wiring                | Automatic                                  |
| Nested models              | Manual                       | Built-in (`addNested`)                     |
| Relationships              | ❌                            | ✅ Many → One, Many ↔ Many                  |
| Boilerplate                | Medium → High                | Minimal, ORM-style                         |
| Ideal for                  | Simple values                | Complex reactive domain models             |

---

## 🚀 Getting Started

### Installation

```yaml
dependencies:
  reactive_orm: ^0.0.7

```

---

### 🧩 Basic Usage

#### 1️⃣ Create a Reactive Model

```dart
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
```

---

#### 2️⃣ Object-wise Reactivity (Whole Object)

Any field change rebuilds the widget:

```dart
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
```

---

#### 3️⃣ Field-wise Reactivity (Optimized)

Widget rebuilds only when specified fields change:

```dart
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
```

- Rebuilds only when `completed` or `status` changes.
- Changes to other fields are ignored.

---

### 🔗 Relationship Patterns

#### 1-> Many → One (Aggregation)

Multiple models feed a single reactive observer:

```dart
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
```

- ✔ Any task change updates the dashboard automatically.

#### 2-> Many ↔ Many (Shared Models)

Same model instance used across multiple parents:

```dart
class Group extends ReactiveModel {
  final String name;
  final List<Task> tasks;

  Group({required this.name, required this.tasks}) {
    for (final task in tasks) addNested(task);
  }
}
```

- ✔ One task update reflects everywhere.
- ✔ No duplication or manual syncing required.

---

## 🧠 How It Works (High Level)

- Models extend `ReactiveModel`.
- Field setters call `notifyListeners(fieldName)` when the value changes.
- `ReactiveBuilder` widgets listen to either:
    - Whole model (object-wise)
    - Specific fields (field-wise)
- Nested models propagate changes upward automatically.
- Widgets rebuild safely, respecting Flutter lifecycle.

---

## 🛣 Roadmap

- Batch updates / transactions
- Async persistence hooks
- Database adapters (optional)
- DevTools / debug inspector
- Optional code generation

---

## 🧪 Status

- Version: 0.0.7
- Stability: Stable / suitable for prototyping and early production
- Use case: Learning, prototyping, early production experiments

---

## 📌 Summary

`reactive_orm` is ideal when you want:

- Clean Dart models with fine-grained reactivity
- A Reactive Object–Relationship Model for UI state
- Object-wise and field-wise rebuild control
- Nested and shared models without manual wiring
- Minimal boilerplate with a clear mental model
- A lightweight yet scalable state management solution for Flutter apps