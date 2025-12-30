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

## 🚀 Getting Started

### Installation

```yaml
dependencies:
  reactive_orm: <latest_version>


```
## 🧩 Basic Usage
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

2️⃣ Object-wise Reactivity
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

3️⃣ Field-wise Reactivity
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

## 🔗 Relationship Patterns
Many → One (Aggregation)
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

Many ↔ Many (Shared Models)
class Group extends ReactiveModel {
  final String name;
  final List<Task> tasks;

  Group({required this.name, required this.tasks}) {
    for (final task in tasks) addNested(task);
  }
}


## 🧠 How It Works
- Models extend ReactiveModel.
- Field setters call notifyListeners(fieldName) when the value changes.
- ReactiveBuilder widgets listen to:
- Whole model (object-wise)
- Specific fields (field-wise)
- Nested models propagate changes upward automatically.
- Widgets rebuild safely, respecting Flutter lifecycle.


## 🛣 Roadmap
- Batch updates / transactions
- Async persistence hooks
- Database adapters (optional)
- DevTools / debug inspector
- Optional code generation


## 🧪 Status
- Version: 1.0.0
- Stability: Stable
- Focus: Reactive domain models & scalable state management


## 📌 Summary
`reactive_orm is ideal for:`
- Clean Dart models with fine-grained reactivity
- A Reactive Object–Relationship Model for UI state
- Object-wise and field-wise rebuild control
- Nested and shared models without manual wiring
- Minimal boilerplate with a clear mental model
- A lightweight yet scalable state management solution for Flutter apps

---
## 🆚 Comparison

| Feature                    | setState           | Redux                  | ValueNotifier         | Provider / ChangeNotifier | BLoC                  | Riverpod             | MobX                 | reactive_orm                   |
|----------------------------|--------------------|------------------------|-----------------------|---------------------------|-----------------------|----------------------|----------------------|--------------------------------|
| Plain Dart models          | ⚠️ Widget-bound    | ❌ Reducer-driven       | ⚠️ Wrapped value      | ❌ Extends notifier        | ❌ State classes       | ❌ Provider-based     | ⚠️ Annotated         | ✅ Plain Dart objects           |
| Direct field mutation      | ⚠️ Inside widget   | ❌                      | ⚠️ `value = x`        | ❌                         | ❌                     | ❌                    | ⚠️ Observables       | ✅ `model.field = value`        |
| Automatic UI updates       | ⚠️ Manual call     | ✅                      | ✅                     | ✅                         | ✅                     | ✅                    | ✅                    | ✅                              |
| Field-wise reactivity      | ❌                  | ❌                      | ❌                     | ❌ Object-level            | ❌                     | ❌                    | ✅                    | ✅ Field-wise + object-wise     |
| Multiple widgets listening | ❌                  | ✅                      | Manual wiring         | Manual wiring             | Stream subscriptions  | Provider wiring      | Automatic            | Automatic                      |
| Nested models              | ❌                  | ❌                      | Manual                | ⚠️ Manual                 | ❌                     | ⚠️ Manual            | ⚠️ Manual            | ✅ Built-in                     |
| Relationship support       | ❌                  | ❌                      | ❌                     | ❌                         | ❌                     | ❌                    | ❌                    | ✅ Many → One, Many ↔ Many      |
| Boilerplate                | Very Low           | Very High              | Medium                | Medium                    | High                  | Medium               | Medium               | Minimal, ORM-style             |
| Async-first design         | ❌                  | ⚠️ Middleware          | ❌                     | ⚠️ Optional               | ✅                     | ✅                    | ⚠️ Optional          | ❌                              |
| Immutability required      | ❌                  | ✅                      | ❌                     | ❌                         | ✅                     | ✅                    | ❌                    | ❌                              |
| Mental model               | Widget-local state | Global immutable store | Single reactive value | Observable objects        | Event → State streams | Immutable containers | Observable variables | Live object graph (ORM-style)  |
| Ideal for                  | Tiny local state   | Large predictable apps | Simple values         | Small–medium apps         | Async-heavy logic     | Predictable state    | Explicit reactivity  | Complex reactive domain models |

## In More Brief --------------
### Provider vs reactive_orm
| Feature                    | Provider / ChangeNotifier   | reactive_orm                   |
|----------------------------|-----------------------------|--------------------------------|
| Plain Dart models          | ❌ Extends `ChangeNotifier`  | ✅ Plain Dart objects           |
| Field assignment syntax    | `setX(); notifyListeners()` | `model.field = newValue`       |
| Automatic UI updates       | ✅                           | ✅                              |
| Field-wise reactivity      | ❌ Object-level only         | ✅ Field-wise + object-wise     |
| Multiple widgets listening | Manual provider wiring      | Automatic                      |
| Nested models              | ⚠️ Manual propagation       | ✅ Built-in                     |
| Relationships              | ❌                           | ✅ Many → One, Many ↔ Many      |
| Boilerplate                | Medium                      | Minimal, ORM-style             |
| Ideal for                  | Small–medium apps           | Complex reactive domain models |

### BLoC vs reactive_orm
| Feature               | BLoC                     | reactive_orm              |
|-----------------------|--------------------------|---------------------------|
| State update style    | Events → Streams → State | Direct field mutation     |
| Immutability          | Required                 | Optional / mutable        |
| Boilerplate           | High                     | Minimal                   |
| Field-wise reactivity | ❌                        | ✅                         |
| Nested models         | ❌                        | ✅                         |
| Relationships         | ❌                        | ✅ Many → One, Many ↔ Many |
| Async-first design    | ✅                        | ❌                         |
| Mental model          | Event-driven             | ORM-style object graph    |
| Ideal for             | Complex async flows      | Domain-driven UI state    |

### Riverpod vs reactive_orm
| Feature               | Riverpod                   | reactive_orm              |
|-----------------------|----------------------------|---------------------------|
| State model           | Immutable snapshots        | Live mutable objects      |
| Update syntax         | `state = state.copyWith()` | `model.field = newValue`  |
| Field-wise reactivity | ❌                          | ✅                         |
| Nested models         | ⚠️ Manual                  | ✅ Built-in                |
| Relationships         | ❌                          | ✅ Many → One, Many ↔ Many |
| Boilerplate           | Medium                     | Minimal                   |
| Compile-time safety   | ✅ Strong                   | ⚠️ Runtime                |
| Ideal for             | Predictable state flows    | Relational domain models  |

### MobX vs reactive_orm
| Feature                | MobX                     | reactive_orm               |
|------------------------|--------------------------|----------------------------|
| Reactivity declaration | Annotations + codegen    | Automatic                  |
| Field-wise reactivity  | ✅                        | ✅                          |
| Plain Dart models      | ⚠️ Annotated             | ✅ Plain Dart               |
| Boilerplate            | Medium                   | Minimal                    |
| Nested models          | ⚠️ Manual                | ✅ Built-in                 |
| Relationships          | ❌                        | ✅ Many → One, Many ↔ Many  |
| Tooling required       | Code generation          | None                       |
| Ideal for              | Explicit reactive fields | ORM-style reactive objects |

---

