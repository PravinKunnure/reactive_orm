import 'package:example/models/task.dart';
import 'package:flutter/material.dart';
import 'package:reactive_orm/reactive_orm.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Task myTask = Task(title: "Build Reactive ORM");

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Reactive ORM Demo")),
        body: Center(
          child: ReactiveBuilder<Task>(
            model: myTask,
            builder: (task) => ListTile(
              title: Text(task.title),
              trailing: Checkbox(
                value: task.completed,
                onChanged: (val) => task.completed = val!,
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            myTask.completed = !myTask.completed;
          },
          child: Icon(Icons.check),
        ),
      ),
    );
  }
}
