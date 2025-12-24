# reactive_orm

A lightweight **reactive ORM-style state management package for Flutter** that allows UI to automatically rebuild when model properties change — without `setState`, streams, or boilerplate.

This package focuses on:
- Simple, natural Dart models
- Automatic reactivity on property mutation
- Clean and minimal API

> ⚠️ This is an **early alpha (v0.0.1)** release. APIs may change.

---

## ✨ Features

- Reactive models with automatic UI updates
- No `setState`, `ChangeNotifier`, or streams
- Simple and readable API
- Widget-level rebuild control using `ReactiveBuilder`
- Multiple widgets can listen to the same model

---

| Feature                    | `ValueNotifier`                | `reactive_orm`                               |
| -------------------------- | ------------------------------ | -------------------------------------------- |
| Observes a single field?   | Yes, one notifier per field    | No, whole object is reactive                 |
| Field assignment syntax    | `notifier.value = newValue`    | `model.field = newValue`                     |
| Multiple widgets listening | Manual setup for each notifier | Automatic for same model instance            |
| Boilerplate                | More for complex models        | Minimal, ORM-style                           |
| Ideal for                  | Simple single values           | Complex models with multiple reactive fields |



## 🚀 Getting Started

### Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  reactive_orm: ^0.0.1




🧩 Basic Usage
1. Create a reactive model
class Task extends ReactiveModel {
  String title;
  bool completed;

  Task({required this.title, this.completed = false});
}

2. Use it in your UI
final Task myTask = Task(title: "Build Reactive ORM");

ReactiveBuilder<Task>(
  model: myTask,
  builder: (task) => ListTile(
    title: Text(task.title),
    trailing: Checkbox(
      value: task.completed,
      onChanged: (val) => task.completed = val!,
    ),
  ),
);

3. Mutate the model (UI updates automatically)
myTask.completed = !myTask.completed;


No setState() required.

🧠 How It Works (High-Level)

Models extend a reactive base class

Property mutations notify listeners automatically

ReactiveBuilder listens to the model and rebuilds when changes occur

Listeners are disposed safely with widget lifecycle

🛣 Roadmap

Planned features for future versions:

Field-level reactivity

Batch updates

Async persistence support

Database adapters

DevTools support

🧪 Status
Version: 0.0.1

Stability: Experimental

API: Subject to change

