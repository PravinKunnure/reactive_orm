import 'package:example/models/task.dart';
import 'package:flutter/material.dart';
import 'package:reactive_orm/reactive_orm.dart';

/// -------------------
/// Models
/// -------------------

class ReactiveTaskList extends ReactiveModel {
  final List<Task> items = [];

  void add(Task task) {
    items.add(task);
    addNested(task); // listen to task changes
    task.status = "Task Added ➕";
    notifyListeners();
  }

  void remove(Task task) {
    items.remove(task);
    task.status = "Task Removed ❌";
    notifyListeners();
  }
}

/// -------------------
/// Main App
/// -------------------

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Task task1 = Task(title: "Build Reactive ORM");
  final Task task2 = Task(title: "Write Documentation");
  final Task task3 = Task(title: "Test Flutter App");

  final ReactiveTaskList taskList = ReactiveTaskList();

  @override
  Widget build(BuildContext context) {
    taskList.add(task1);
    taskList.add(task2);
    taskList.add(task3);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Reactive ORM Demo with Status")),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              /// 1️⃣ Single Task with status
              ReactiveBuilder<Task>(
                model: task1,
                builder: (task) => ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.status),
                  trailing: Checkbox(
                    value: task.completed,
                    onChanged: (val) => task.completed = val!,
                  ),
                ),
              ),

              Divider(),

              /// 2️⃣ Reactive List with operation status
              Expanded(
                child: ReactiveBuilder<ReactiveTaskList>(
                  model: taskList,
                  builder: (list) => ListView.builder(
                    itemCount: list.items.length,
                    itemBuilder: (_, index) {
                      final t = list.items[index];
                      return ReactiveBuilder<Task>(
                        model: t,
                        fields: ['completed', 'status'],
                        builder: (task) => ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.status),
                          trailing: Checkbox(
                            value: task.completed,
                            onChanged: (val) => task.completed = val!,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: "toggle",
              onPressed: () {
                task1.completed = !task1.completed;
              },
              tooltip: "Toggle Completion",
              child: Icon(Icons.check),
            ),
            SizedBox(height: 12),
            FloatingActionButton(
              heroTag: "add",
              onPressed: () {
                final newTask = Task(
                  title: "New Task ${taskList.items.length + 1}",
                );
                taskList.add(newTask);
              },
              tooltip: "Add Task",
              child: Icon(Icons.add),
            ),
            SizedBox(height: 12),
            FloatingActionButton(
              heroTag: "remove",
              onPressed: () {
                if (taskList.items.isNotEmpty) {
                  taskList.remove(taskList.items.last);
                }
              },
              tooltip: "Remove Last Task",
              child: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}

///Try Version
// import 'package:example/models/task.dart';
// import 'package:flutter/material.dart';
// import 'package:reactive_orm/reactive_orm.dart';
//
//
// // Project Model with nested tasks
// class Project extends ReactiveModel {
//   String _name;
//   final List<Task> tasks;
//
//   Project({required String name, required this.tasks}) : _name = name {
//     // Listen to all task changes
//     for (var task in tasks) {
//       task.addListener(() => notifyListeners('tasks'));
//     }
//   }
//
//   String get name => _name;
//   set name(String value) {
//     if (_name != value) {
//       _name = value;
//       notifyListeners('name');
//     }
//   }
// }
//
// // Reactive list example
// class ReactiveTaskList extends ReactiveModel {
//   final List<Task> items = [];
//
//   void add(Task task) {
//     items.add(task);
//     task.addListener(() => notifyListeners());
//     notifyListeners();
//   }
//
//   void remove(Task task) {
//     items.remove(task);
//     task.removeListener(() => notifyListeners());
//     notifyListeners();
//   }
// }
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   final Task task1 = Task(title: "Build Reactive ORM");
//   final Task task2 = Task(title: "Write Documentation");
//   final Project project = Project(name: "Flutter App", tasks: []);
//
//   final ReactiveTaskList taskList = ReactiveTaskList();
//
//   MyApp({super.key}) {
//     project.tasks.add(task1);
//     project.tasks.add(task2);
//     taskList.add(task1);
//     taskList.add(task2);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Reactive ORM Demo")),
//         body: Column(
//           children: [
//             // 1️⃣ Single Task ReactiveBuilder
//             ReactiveBuilder<Task>(
//               model: task1,
//               builder: (task) => ListTile(
//                 title: Text(task.title),
//                 trailing: Checkbox(
//                   value: task.completed,
//                   onChanged: (val) => task.completed = val!,
//                 ),
//               ),
//             ),
//
//             // 2️⃣ Multiple Widgets Listening to the same model
//             ReactiveBuilder<Task>(
//               model: task1,
//               builder: (task) => Text(
//                 task.completed ? "Task Done ✅" : "Task Pending ❌",
//               ),
//             ),
//
//             Divider(),
//
//             // 3️⃣ Nested Project Example
//             ReactiveBuilder<Project>(
//               model: project,
//               builder: (proj) => Column(
//                 children: [
//                   Text("Project: ${proj.name}", style: TextStyle(fontSize: 18)),
//                   ...proj.tasks.map((t) => ReactiveBuilder<Task>(
//                     model: t,
//                     builder: (task) => ListTile(
//                       title: Text(task.title),
//                       trailing: Checkbox(
//                         value: task.completed,
//                         onChanged: (val) => task.completed = val!,
//                       ),
//                     ),
//                   )),
//                 ],
//               ),
//             ),
//
//             Divider(),
//
//             // 4️⃣ Reactive List Example
//             Expanded(
//               child: ReactiveBuilder<ReactiveTaskList>(
//                 model: taskList,
//                 builder: (list) => ListView.builder(
//                   itemCount: list.items.length,
//                   itemBuilder: (_, index) {
//                     final t = list.items[index];
//                     return ReactiveBuilder<Task>(
//                       model: t,
//                       builder: (task) => ListTile(
//                         title: Text(task.title),
//                         trailing: Checkbox(
//                           value: task.completed,
//                           onChanged: (val) => task.completed = val!,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             task1.completed = !task1.completed;
//           },
//           child: Icon(Icons.check),
//         ),
//       ),
//     );
//   }
// }

///Version 0.0.1
// import 'package:example/models/task.dart';
// import 'package:flutter/material.dart';
// import 'package:reactive_orm/reactive_orm.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   final Task myTask = Task(title: "Build Reactive ORM");
//
//   MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Reactive ORM Demo")),
//         body: Center(
//           child: ReactiveBuilder<Task>(
//             model: myTask,
//             builder: (task) => ListTile(
//               title: Text(task.title),
//               trailing: Checkbox(
//                 value: task.completed,
//                 onChanged: (val) => task.completed = val!,
//               ),
//             ),
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             myTask.completed = !myTask.completed;
//           },
//           child: Icon(Icons.check),
//         ),
//       ),
//     );
//   }
// }
