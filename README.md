# reactive_orm

A lightweight **reactive ORM-style state management package for Flutter** that allows UI to automatically rebuild when model properties change — without `setState`, streams, or boilerplate.

It is designed to feel like working with **plain Dart models**, while still getting **fine-grained UI reactivity**.

> ⚠️ **Early Alpha (v0.0.3)**  
> APIs are experimental and may change.

---

## 🎬 Demo
![Reactive_ORM Demo](https://raw.githubusercontent.com/PravinKunnure/reactive_orm/main/example/assets/reactive_orm_demo.mov)

---

## ✨ Core Philosophy

- Models are plain Dart objects
- State changes happen via normal field mutation
- UI reacts automatically
- No providers, no contexts, no streams

---

## ✨ Features

- ✅ Reactive models with automatic UI updates
- ✅ Object-wise reactivity (entire model)
- ✅ Field-wise reactivity (specific properties only)
- ✅ Multiple widgets can listen to the same model
- ✅ Nested & shared models supported
- ❌ No `setState`
- ❌ No `ChangeNotifier`
- ❌ No streams

---


## 🆚 Comparison

| Feature                    | ValueNotifier                | reactive_orm                    |
|----------------------------|------------------------------|---------------------------------|
| Observes a single field?   | Yes (one notifier per field) | Yes (field-wise) + whole object |
| Field assignment syntax    | `notifier.value = newValue`  | `model.field = newValue`        |
| Multiple widgets listening | Manual wiring                | Automatic                       |
| Nested models              | Manual                       | Built-in (`addNested`)          |
| Boilerplate                | Medium → High                | Minimal, ORM-style              |
| Ideal for                  | Simple values                | Complex reactive models         |

---

## 🚀 Getting Started

### Installation

```yaml
dependencies:
  reactive_orm: ^0.0.3



🧩 Basic Usage


1️⃣ Create a Reactive Model
class Task extends ReactiveModel {
  String _title;
  bool _completed = false;

  Task({required String title}) : _title = title;

  String get title => _title;
  set title(String value) {
    _title = value;
    notifyListeners('title');
  }

  bool get completed => _completed;
  set completed(bool value) {
    _completed = value;
    notifyListeners('completed');
  }
}


2️⃣ Object-wise Reactivity (default)
Any field change rebuilds the widget
final task = Task(title: "Object-wise");
ReactiveBuilder<Task>(
  model: task,
  builder: (t) => ListTile(
    title: Text(t.title),
    trailing: Checkbox(
      value: t.completed,
      onChanged: (v) => t.completed = v!,
    ),
  ),
);
-Rebuilds when:
 title changes
 completed changes
 any other field changes


3️⃣ Field-wise Reactivity (optimized)
Widget rebuilds only when specified fields change
final task = Task(title: "Field-wise");
ReactiveBuilder<Task>(
  model: task,
  fields: ['completed'],
  builder: (t) => Checkbox(
    value: t.completed,
    onChanged: (v) => t.completed = v!,
  ),
);

-Rebuilds only when:
 completed changes 
 ❌ title changes are ignored




🔗 Relationship Patterns
🔹 Many → One (Aggregation)

Multiple models feed a single reactive observer.

class Dashboard extends ReactiveModel {
  Dashboard(List<Task> tasks) {
    for (final t in tasks) {
      addNested(t);
    }
  }
}

ReactiveBuilder<Dashboard>(
  model: dashboard,
  builder: (_) => Text("Dashboard updated"),
);


✔ Any task change updates the dashboard

🔹 Many ↔ Many (Shared Models)

Same model instance used across multiple parents.

class Group extends ReactiveModel {
  Group(List<Task> tasks) {
    for (final t in tasks) {
      addNested(t);
    }
  }
}


✔ One task update reflects everywhere
✔ No duplication
✔ No syncing logic



🧠 How It Works (High Level)

Models extend ReactiveModel

Field setters call notifyListeners(fieldName)

ReactiveBuilder listens to:

Whole model (object-wise)

Specific fields (field-wise)

Nested models propagate changes upward

Widgets rebuild safely with lifecycle awareness

🛣 Roadmap

Planned improvements:

Batch updates / transactions

Async persistence hooks

Database adapters

DevTools / debug inspector

Code generation (optional)

🧪 Status

Version: 0.0.3

Stability: Experimental / Alpha

Use case: Learning, prototyping, early production experiments

📌 Summary

reactive_orm is ideal when you want:

-Clean Dart models

-Minimal boilerplate

-ORM-like mental model

-Fine-grained UI reactivity

-No framework lock-in

