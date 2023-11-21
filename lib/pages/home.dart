import 'package:control_tareas/data/task.dart';
import 'package:control_tareas/pages/new_task.dart';
import 'package:control_tareas/pages/pepe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Control de tareas"),
      ),
      body: FutureBuilder(
        future: tasks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return fullBody(snapshot.data as List<Task>);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, "/new-task", (route) => false);

          // if (task != null) {
          //   setState(() {
          //     tasks.add(task);
          //     tasks.sort((a, b) => a.compareTo(b));
          //   });
          // }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget fullBody(List<Task> tasks) {
    return ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            child: ListTile(
              tileColor:
                  tasks[index].isDone ? Colors.grey[300] : Colors.grey[50],
              title: Text(
                tasks[index].description,
              ),
              subtitle: Text(tasks[index].date.toString().split(" ")[0]),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(tasks[index].priorityName),
                const SizedBox(width: 10),
                Checkbox(
                    value: tasks[index].isDone,
                    onChanged: (value) {
                      setState(() {
                        tasks[index].isDone = value!;
                      });
                    })
              ]),
              leading: Text(
                tasks[index].title ?? "",
              ),
              onTap: () {
                showTask(context, tasks[index]);
              },
              onLongPress: () {
                setState(() {
                  tasks.removeAt(index);
                });
              },
            ),
          );
        },
        itemCount: tasks.length);
  }

  void showTask(BuildContext context, Task task) {
    showDialog(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, setLocalState) {
              return AlertDialog(
                title: Center(child: Text(task.title ?? "")),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(task.description),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(task.date.toString().split(" ")[0]),
                        Text(task.priorityName),
                        Checkbox(
                            value: task.isDone,
                            onChanged: (value) {
                              setState(() {
                                setLocalState(() {
                                  task.isDone = value!;
                                });
                              });
                            })
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () {
                        setState(() {
                          // tasks.remove(task);
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text("Eliminar")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Aceptar")),
                ],
              );
            }));
  }

  Future<List<Task>> getTasks() async {
    // await Future.delayed(const Duration(seconds: 2));

    final taskSession = await SessionManager().get("tasks");
    if (taskSession == null) {
      return [];
    } else {
      return (taskSession as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    // return [
    //   Task(
    //       title: "Pepe",
    //       description: "asd asd asdasdasdas",
    //       date: DateTime.now(),
    //       priority: Priority.high,
    //       isDone: false),
    //   Task(
    //       title: "Plinio",
    //       description: "Cuadrado",
    //       date: DateTime.now(),
    //       priority: Priority.low,
    //       isDone: false)
    // ];
  }
}
