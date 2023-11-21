import 'package:control_tareas/pages/home.dart';
import 'package:control_tareas/pages/new_task.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/home",
      routes: {
        '/home': (context) => const Home(),
        "/new-task": (context) => const NewTaskPage(),
      },
    );
  }
}
