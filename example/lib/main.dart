import 'package:flutter/material.dart';
import 'package:reactive_orm/reactive_orm.dart';

///Version 1.1.0 New Version Example

/// =====================================================
/// TASK MODEL
/// =====================================================
class Task extends ReactiveModel {
  String _title;
  bool _completed = false;
  String _status = "Idle";

  Task({required String title}) : _title = title;

  String get title => _title;
  set title(String value) {
    if (_title != value) {
      _title = value;
      notifyListeners(#title);
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

/// =====================================================
/// MANY → ONE MODEL (DASHBOARD)
/// Adds: computed field + reaction (large app pattern)
/// =====================================================
class Dashboard extends ReactiveModel {
  final List<Task> tasks;

  Dashboard(this.tasks) {
    for (final t in tasks) {
      addNested(t);
    }

    /// 🔔 Reaction (side-effect only)
    reaction(() => completedCount, (count) {
      if (count == tasks.length) {
        debugPrint("🎉 Dashboard: all tasks completed");
      }
    });
  }

  /// ✅ Computed field (derived, no storage)
  int get completedCount => tasks.where((t) => t.completed).length;
}

/// =====================================================
/// MANY ↔ MANY MODEL (GROUP)
/// =====================================================
class Group extends ReactiveModel {
  final String name;
  final List<Task> tasks;

  Group({required this.name, required this.tasks}) {
    for (final t in tasks) {
      addNested(t);
    }
  }
}

/// =====================================================
/// APP
/// =====================================================
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// -----------------------------------------------------
  /// DEMO TASKS
  /// -----------------------------------------------------
  final Task objectWise = Task(title: "Object-wise Reactivity");
  final Task fieldWise = Task(title: "Field-wise Reactivity");

  final Task manyA = Task(title: "Many → One : A");
  final Task manyB = Task(title: "Many → One : B");

  late final Dashboard dashboard;
  late final Group group1;
  late final Group group2;

  @override
  void initState() {
    super.initState();

    dashboard = Dashboard([manyA, manyB]);

    group1 = Group(name: "Group 1", tasks: [objectWise, fieldWise]);
    group2 = Group(name: "Group 2", tasks: [fieldWise, manyA]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reactive ORM – Small → Large Demo")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          /// =====================================================
          /// 1️⃣ OBJECT-WISE
          /// =====================================================
          const Text(
            "1️⃣ Object-wise Reactivity",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ReactiveBuilder<Task>(
            model: objectWise,
            builder: (task) {
              debugPrint("🔄 Object-wise rebuild");
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.status),
                trailing: Checkbox(
                  value: task.completed,
                  onChanged: (v) => task.completed = v!,
                ),
              );
            },
          ),
          const Divider(),

          /// =====================================================
          /// 2️⃣ FIELD-WISE
          /// =====================================================
          const Text(
            "2️⃣ Field-wise Reactivity",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ReactiveBuilder<Task>(
            model: fieldWise,
            fields: [#completed, #status],
            builder: (task) {
              debugPrint("🎯 Field-wise rebuild");
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.status),
                trailing: Checkbox(
                  value: task.completed,
                  onChanged: (v) => task.completed = v!,
                ),
              );
            },
          ),
          const Divider(),

          /// =====================================================
          /// 3️⃣ MANY → ONE
          /// =====================================================
          const Text(
            "3️⃣ Many → One",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ReactiveBuilder<Dashboard>(
            model: dashboard,
            builder: (d) {
              debugPrint("📡 Dashboard rebuilt");
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("A completed: ${manyA.completed}"),
                  Text("B completed: ${manyB.completed}"),
                  Text("Completed count: ${d.completedCount}"),
                ],
              );
            },
          ),
          const Divider(),

          /// =====================================================
          /// 4️⃣ MANY ↔ MANY
          /// =====================================================
          const Text(
            "4️⃣ Many ↔ Many",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ReactiveBuilder<Group>(
            model: group1,
            builder: (g) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  g.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ...g.tasks.map((t) => Text("• ${t.title}: ${t.completed}")),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ReactiveBuilder<Group>(
            model: group2,
            builder: (g) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  g.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ...g.tasks.map((t) => Text("• ${t.title}: ${t.completed}")),
              ],
            ),
          ),
          const Divider(),

          /// =====================================================
          /// 5️⃣ REACTIVE SELECTOR
          /// =====================================================
          const Text(
            "5️⃣ Reactive Selector",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ReactiveSelector<Task, String>(
            model: objectWise,
            field: #title,
            selector: (t) => t.title,
            builder: (title) => Text("Title only: $title"),
          ),
        ],
      ),

      /// =====================================================
      /// ACTIONS
      /// =====================================================
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "obj",
            tooltip: "Toggle Object-wise",
            onPressed: () => objectWise.completed = !objectWise.completed,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "field",
            tooltip: "Toggle Field-wise",
            onPressed: () => fieldWise.completed = !fieldWise.completed,
            child: const Icon(Icons.filter_alt),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "many",
            tooltip: "Toggle Many → One",
            onPressed: () => manyA.completed = !manyA.completed,
            child: const Icon(Icons.merge),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "title",
            tooltip: "Change Title",
            onPressed: () {
              objectWise.title = objectWise.title == "Object-wise Reactivity"
                  ? "Updated Title"
                  : "Object-wise Reactivity";
            },
            child: const Icon(Icons.text_fields),
          ),
        ],
      ),
    );
  }
}

///Version 1.0.1 Example Deprecated
// import 'package:flutter/material.dart';
// import 'package:reactive_orm/reactive_orm.dart';
//
// /// -------------------
// /// Task Model
// /// -------------------
// class Task extends ReactiveModel {
//   String _title;
//   bool _completed = false;
//   String _status = "Idle";
//
//   Task({required String title}) : _title = title;
//
//   String get title => _title;
//   set title(String value) {
//     if (_title != value) {
//       _title = value;
//       notifyListeners(#title);
//     }
//   }
//
//   bool get completed => _completed;
//   set completed(bool value) {
//     if (_completed != value) {
//       _completed = value;
//       notifyListeners(#completed);
//     }
//   }
//
//   String get status => _status;
//   set status(String value) {
//     if (_status != value) {
//       _status = value;
//       notifyListeners(#status);
//     }
//   }
// }
//
// /// -------------------
// /// MANY → ONE Model
// /// -------------------
// class Dashboard extends ReactiveModel {
//   final List<Task> sources;
//
//   Dashboard(this.sources) {
//     for (final task in sources) {
//       addNested(task);
//     }
//   }
// }
//
// /// -------------------
// /// MANY ↔ MANY Model
// /// -------------------
// class Group extends ReactiveModel {
//   final String name;
//   final List<Task> tasks;
//
//   Group({required this.name, required this.tasks}) {
//     for (final task in tasks) {
//       addNested(task);
//     }
//   }
// }
//
// /// -------------------
// /// App
// /// -------------------
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(home: HomePage());
//   }
// }
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   /// =====================================================
//   /// DEMO TASKS
//   /// =====================================================
//   final Task objectWise = Task(title: "Object-wise Reactivity");
//   final Task fieldWise = Task(title: "Field-wise Reactivity");
//
//   final Task manyA = Task(title: "Many → One : A");
//   final Task manyB = Task(title: "Many → One : B");
//
//   late final Dashboard dashboard;
//   late final Group group1;
//   late final Group group2;
//
//   @override
//   void initState() {
//     super.initState();
//
//     dashboard = Dashboard([manyA, manyB]);
//
//     group1 = Group(name: "Group 1", tasks: [objectWise, fieldWise]);
//     group2 = Group(name: "Group 2", tasks: [fieldWise, manyA]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Reactive ORM – Patterns Demo")),
//       body: ListView(
//         padding: const EdgeInsets.all(12),
//         children: [
//           /// =====================================================
//           /// 1️⃣ OBJECT-WISE
//           /// =====================================================
//           const Text(
//             "1️⃣ Object-wise (Whole Object Reacts)",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           ReactiveBuilder<Task>(
//             model: objectWise,
//             builder: (task) {
//               debugPrint("🔄 Object-wise rebuild");
//               return ListTile(
//                 title: Text(task.title),
//                 subtitle: Text(task.status),
//                 trailing: Checkbox(
//                   value: task.completed,
//                   onChanged: (v) => task.completed = v!,
//                 ),
//               );
//             },
//           ),
//           const Divider(),
//
//           /// =====================================================
//           /// 2️⃣ FIELD-WISE
//           /// =====================================================
//           const Text(
//             "2️⃣ Field-wise (Only selected fields react)",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           ReactiveBuilder<Task>(
//             model: fieldWise,
//             fields: [#completed, #status],
//             builder: (task) {
//               debugPrint("🎯 Field-wise rebuild");
//               return ListTile(
//                 title: Text(task.title),
//                 subtitle: Text(task.status),
//                 trailing: Checkbox(
//                   value: task.completed,
//                   onChanged: (v) => task.completed = v!,
//                 ),
//               );
//             },
//           ),
//           const Divider(),
//
//           /// =====================================================
//           /// 3️⃣ MANY → ONE
//           /// =====================================================
//           const Text(
//             "3️⃣ Many → One (Multiple models → Single observer)",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           ReactiveBuilder<Dashboard>(
//             model: dashboard,
//             builder: (_) {
//               debugPrint("📡 Dashboard rebuilt");
//               return Column(
//                 children: [
//                   Text("A: ${manyA.completed}"),
//                   Text("B: ${manyB.completed}"),
//                 ],
//               );
//             },
//           ),
//           const Divider(),
//
//           /// =====================================================
//           /// 4️⃣ MANY ↔ MANY
//           /// =====================================================
//           const Text(
//             "4️⃣ Many ↔ Many (Shared models)",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           ReactiveBuilder<Group>(
//             model: group1,
//             builder: (g) => Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   g.name,
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 ...g.tasks.map((t) => Text("• ${t.title} → ${t.completed}")),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           ReactiveBuilder<Group>(
//             model: group2,
//             builder: (g) => Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   g.name,
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 ...g.tasks.map((t) => Text("• ${t.title} → ${t.completed}")),
//               ],
//             ),
//           ),
//           const Divider(),
//
//           /// =====================================================
//           /// 5️⃣ REACTIVE SELECTOR (Title Field)
//           /// =====================================================
//           const Text(
//             "5️⃣ Reactive Selector (Title Only)",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           ReactiveSelector<Task, String>(
//             model: objectWise,
//             field: #title,
//             selector: (task) => task.title,
//             builder: (title) => Text("Title: $title"),
//           ),
//         ],
//       ),
//
//       /// =====================================================
//       /// ACTIONS
//       /// =====================================================
//       floatingActionButton: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           FloatingActionButton(
//             heroTag: "obj",
//             tooltip: "Toggle Object-wise",
//             onPressed: () {
//               objectWise.completed = !objectWise.completed;
//             },
//             child: const Icon(Icons.refresh),
//           ),
//           const SizedBox(height: 10),
//           FloatingActionButton(
//             heroTag: "field",
//             tooltip: "Toggle Field-wise",
//             onPressed: () {
//               fieldWise.completed = !fieldWise.completed;
//             },
//             child: const Icon(Icons.filter_alt),
//           ),
//           const SizedBox(height: 10),
//           FloatingActionButton(
//             heroTag: "many",
//             tooltip: "Toggle Many → One",
//             onPressed: () {
//               manyA.completed = !manyA.completed;
//             },
//             child: const Icon(Icons.merge),
//           ),
//           const SizedBox(height: 10),
//           FloatingActionButton(
//             heroTag: "title",
//             tooltip: "Change Object-wise Title",
//             onPressed: () {
//               objectWise.title = objectWise.title == "Object-wise Reactivity"
//                   ? "Updated Title"
//                   : "Object-wise Reactivity";
//             },
//             child: const Icon(Icons.text_fields),
//           ),
//         ],
//       ),
//     );
//   }
// }
