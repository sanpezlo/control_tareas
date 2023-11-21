import 'dart:convert';

import 'package:control_tareas/data/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:control_tareas/pages/home.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({Key? key}) : super(key: key);

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final _keyForm = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final priorityController = TextEditingController();

  final listPriority = [
    priorityName(Priority.high),
    priorityName(Priority.medium),
    priorityName(Priority.low)
  ];

  @override
  void initState() {
    super.initState();
    dateController.text = DateTime.now().toString().split(" ")[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva tarea"),
      ),
      body: fullBody(),
    );
  }

  Widget fullBody() {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: ListView(
              children: [buildForm()],
            )));
  }

  Widget buildForm() {
    return Form(
        key: _keyForm,
        child: ListView(shrinkWrap: true, children: [
          titleField(),
          const SizedBox(
            height: 20,
          ),
          descriptionField(),
          const SizedBox(
            height: 20,
          ),
          dateFild(),
          const SizedBox(
            height: 20,
          ),
          priorityField(),
          const SizedBox(
            height: 20,
          ),
          addButton(),
          const SizedBox(
            height: 10,
          ),
          backButton()
        ]));
  }

  Widget titleField() {
    return TextFormField(
      controller: titleController,
      decoration: const InputDecoration(
        filled: true,
        labelText: "Nombre",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "El nombre es requerido";
        }
        if (value.length < 3) {
          return "El nombre debe tener al menos 3 caracteres";
        }

        return null;
      },
    );
  }

  Widget descriptionField() {
    return TextFormField(
      controller: descriptionController,
      maxLines: 3,
      decoration: const InputDecoration(
        filled: true,
        labelText: "Descripción",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "La descripción es requerida";
        }

        if (value.length < 10) {
          return "La descripción debe tener al menos 10 caracteres";
        }
        return null;
      },
    );
  }

  Widget dateFild() {
    return TextFormField(
      controller: dateController,
      decoration: const InputDecoration(
          filled: true,
          labelText: "Fecha de expiración",
          prefixIcon: Icon(Icons.calendar_today)),
      readOnly: true,
      onTap: () {
        _selectDate();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "La fecha es requerida";
        }

        if (DateTime.parse(value).isBefore(DateTime.now())) {
          return "La fecha debe ser mayor a la actual";
        }
        return null;
      },
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 2));

    if (picked != null) {
      dateController.text = picked.toString().split(" ")[0];
    }
  }

  Widget priorityField() {
    return DropdownMenu(
      width: MediaQuery.of(context).size.width - 60,
      controller: priorityController,
      initialSelection: priorityName(Priority.low),
      dropdownMenuEntries:
          listPriority.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(
          value: value,
          label: value,
        );
      }).toList(),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
      ),
    );
  }

  Widget addButton() {
    return ElevatedButton(
        onPressed: () async {
          if (_keyForm.currentState!.validate()) {
            final task = Task(
                title: titleController.text,
                description: descriptionController.text,
                date: DateTime.parse(dateController.text),
                priority: priorityFromName(priorityController.text),
                isDone: false);

            final tasksSession = await SessionManager().get("tasks");
            if (tasksSession == null) {
              await SessionManager().set("tasks", jsonEncode([task.toJson()]));
            } else {
              final tasks = (tasksSession as List<dynamic>)
                  .map((e) => Task.fromJson(e as Map<String, dynamic>))
                  .toList();

              tasks.add(task);

              final tasksJson = tasks.map((e) => e.toJson()).toList();

              await SessionManager().set("tasks", jsonEncode(tasksJson));
            }

            // ignore: use_build_context_synchronously
            Navigator.pushNamedAndRemoveUntil(
                context, "/home", (route) => false);
          }
        },
        child: const Text("Agregar"));
  }

  Widget backButton() {
    return TextButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
        },
        child: const Text("Atras"));
  }
}
