# reactive_orm

[![Pub Version](https://img.shields.io/pub/v/reactive_orm)](https://pub.dev/packages/reactive_orm) | [![License: MIT](https://img.shields.io/badge/license-MIT-green)](https://opensource.org/licenses/MIT)

> ⚠️ **Note:** `reactive_orm` stands for a **Reactive Object–Relationship Model**.  
> It is **not a database ORM**.  
> It is a lightweight, field-level **state management solution** for Flutter UI, inspired by ORM-style modeling of objects and relationships — fully in-memory and UI-focused.

---

## What’s New in v1.2.0

- **watchField()**: field-level UI reactivity without `ReactiveBuilder`.
- **watchComputed()**: rebuild UI based on derived / computed values.
- **ReactiveMap<K, V>**: reactive key–value collections.
- **Relationship helpers**: helpers for Many → One and Many ↔ Many model wiring.
- **Debug inspection support**: introspect listeners, nested models, and rebuilds.
- Internal folder re-organization for long-term extensibility.
- Fully backward-compatible with v1.1.x.


---

## 🎬 Demo

![Reactive_ORM Demo](https://raw.githubusercontent.com/PravinKunnure/reactive_orm/main/example/assets/reactive_orm_demo_.gif)

---

## ✨ Core Philosophy

- Models are **plain Dart objects**.
- State changes happen via **normal field mutation**.
- UI reacts **automatically**, with optional field-specific reactivity.
- No `ChangeNotifier`, providers, streams, or extra boilerplate.
- Supports **object-wise**, **field-wise**, and **nested reactivity**.
- ORM-inspired design:
  - Objects represent application state
  - Relationships define propagation (Many → One, Many ↔ Many)
  - Reactivity keeps the UI in sync

---


## ✨ Features
- ✅ Reactive models with automatic UI updates
- ✅ Object-wise reactivity (`watch`)
- ✅ Field-wise reactivity (`watchField`)
- ✅ Computed reactivity (`watchComputed`)
- ✅ ReactiveList & ReactiveMap collections
- ✅ Nested & shared models
- ✅ Many → One and Many ↔ Many relationships
- ✅ Debug inspection support
- ✅ Minimal boilerplate, no codegen required
- ✅ ORM-style object graph mental model


---

## 🚀 Getting Started

### Installation

```yaml
dependencies:
  reactive_orm: <latest_one>
```

## 🧩 Basic Usage
1️⃣ Create a Reactive Model:

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
        notifyListeners(#title); // ✅ Symbol, not String
      }
    }
    
    bool get completed => _completed;
    set completed(bool value) {
      if (_completed != value) {
        _completed = value;
        notifyListeners(#completed);
      }
    }
    
    String get status => _status;
      set status(String value) {
        if (_status != value) {
          _status = value;
          notifyListeners(#status);
        }
      }
    }



2️⃣ Object-wise Reactivity with watch()

    final task = Task(title: "Object-wise");
    
    task.watch(
        (t) => ListTile(
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
      fields: [#completed, #status], // ✅ Symbol-based
        builder: (t) => ListTile(
        title: Text(t.title),
          subtitle: Text(t.status),
          trailing: Checkbox(
          value: t.completed,
          onChanged: (v) => t.completed = v!,
        ),
      ),
    );

4️⃣ ReactiveList Example

    final ReactiveList<String> fruits = ReactiveList(["Apple", "Banana"]); 

    fruits.watch(
    (list) => Column(
    children: list.value.map((e) => Text(e)).toList(),
    ),
    );

    fruits.add("Orange"); // automatically rebuilds UI

5️⃣ ReactiveMap Example

    final ReactiveMap<String, int> scores = ReactiveMap({"A": 1, "B": 2});
    
      scores.watch(
      (map) => Column(
        children: map.value.entries
          .map((e) => Text("${e.key} → ${e.value}"))
          .toList(),
        ),
      );

    scores.put("C", 3); // automatically rebuilds UI


## 🔗 Relationship Patterns
- Many → One (Aggregation)
    
      class Dashboard extends ReactiveModel {
          final List<Task> sources;
          Dashboard(this.sources) {
          for (final task in sources) addNested(task); }
          }

        final dashboard = Dashboard([task1, task2]);
        
        ReactiveBuilder<Dashboard>(
        model: dashboard,
        builder: (_) => Text("Dashboard updated"),
        );

- Many ↔ Many (Shared Models)


    class Group extends ReactiveModel {
    final String name;
    final List<Task> tasks;
    
    Group({required this.name, required this.tasks}) {
      for (final task in tasks) addNested(task);
      }
    }



## 🧠 How It Works
- Models extend ReactiveModel.
- Field setters call notifyListeners(#field) when the value changes.
- ReactiveBuilder widgets listen to:
- Whole model (object-wise)
- Specific fields (field-wise)
- Nested models propagate changes upward automatically
- Widgets rebuild safely, respecting Flutter lifecycle


## Roadmap

### v1.3.x (Experimental)
- Annotation-based metadata
- Optional code generation (models & relationships)
- Compile-time safety for fields & relations

### v1.4.x
- Advanced DevTools (graph visualization, rebuild tracing)
- Performance profiling helpers


## 📌 Summary

`reactive_orm` is ideal for:

- Clean Dart models with fine-grained reactivity
- A Reactive Object–Relationship Model for UI state
- Object-wise and field-wise rebuild control
- Nested and shared models without manual wiring
- Minimal boilerplate with a clear mental model
- A lightweight yet scalable state management solution for Flutter apps


## 🆚 Comparison of State Management Approaches

| Feature                    | setState           | Provider / ChangeNotifier | ValueNotifier          | BLoC                       | Riverpod                | MobX                 | reactive_orm                   |
|----------------------------|--------------------|---------------------------|------------------------|----------------------------|-------------------------|----------------------|--------------------------------|
| Plain Dart models          | ⚠️ Widget-bound    | ❌ Extends notifier        | ⚠️ Wrapped value       | ❌ State classes            | ❌ Immutable snapshots   | ⚠️ Annotated         | ✅ Plain Dart objects           |
| Direct field mutation      | ⚠️ Inside widget   | ❌                         | ⚠️ `value = x`         | ❌                          | ❌                       | ⚠️ Observable        | ✅ `model.field = value`        |
| Automatic UI updates       | ⚠️ Manual          | ✅                         | ✅                      | ✅                          | ✅                       | ✅                    | ✅                              |
| Field-wise reactivity      | ❌                  | ❌                         | ❌                      | ❌                          | ❌                       | ✅                    | ✅ Field-wise + object-wise     |
| Multiple widgets listening | ❌                  | Manual wiring             | Manual                 | Stream subscriptions       | Provider wiring         | Automatic            | Automatic                      |
| Nested models              | ❌                  | ⚠️ Manual                 | Manual                 | ❌                          | ⚠️ Manual               | ⚠️ Manual            | ✅ Built-in                     |
| Relationships              | ❌                  | ❌                         | ❌                      | ❌                          | ❌                       | ❌                    | ✅ Many → One / Many ↔ Many     |
| Boilerplate                | Very Low           | Medium                    | Medium                 | High                       | Medium                  | Medium               | Minimal / ORM-style            |
| Immutability required      | ❌                  | ❌                         | ❌                      | ✅                          | ✅                       | ⚠️ Optional          | ❌                              |
| Mental model               | Widget-local state | Observable objects        | Single reactive value  | Event → State streams      | Immutable containers    | Observable variables | Live object graph (ORM-style)  |
| Ideal for                  | Tiny local state   | Small–medium apps         | Simple reactive values | Async-heavy / event-driven | Predictable state       | Explicit reactivity  | Complex reactive domain models |

