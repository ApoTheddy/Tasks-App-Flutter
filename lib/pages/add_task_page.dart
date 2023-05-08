import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_sapp/models/response_database.dart';
import 'package:task_sapp/models/task.dart';
import 'package:task_sapp/controllers/task.dart';
import 'package:task_sapp/utils/additional_functions.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage(
      {super.key, required this.reloadHome, required this.isDarkMode});
  final Function(String content) reloadHome;
  final bool isDarkMode;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late TaskController db;
  @override
  void initState() {
    db = TaskController();
    super.initState();
  }

  String categorySelected = "Productividad";
  List<String> categories = [
    "Productividad",
    "Programacion",
  ];

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isDarkMode ? const Color(0xff202124) : const Color(0xffF4F6FA),
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      label: Text("Titulo de la tarea"),
                    ),
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    maxLines: 5,
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      label: Text("Descripcion de la tarea"),
                    ),
                  ),
                ),
              ),
              DropdownButton<String>(
                  value: categorySelected,
                  items: categories
                      .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: widget.isDarkMode
                                        ? Colors.grey
                                        : Colors.black),
                              )))
                      .toList(),
                  onChanged: (value) {
                    setState(() => categorySelected = value!);
                  }),
              const SizedBox(height: 20),
              CupertinoButton(
                  color: Colors.green[400],
                  child: const Text("Agregar"),
                  onPressed: () async {
                    String title = titleController.text.trim();
                    String description = descriptionController.text.trim();
                    String date = DateTime.now().toString().substring(0, 10);

                    if (title.isNotEmpty) {
                      Task newTask =
                          Task(title, description, date, categorySelected, 0);
                      ResponseDatabase response = await db.insert(newTask);
                      Navigator.pop(context);
                      widget.reloadHome(response.body);
                    } else {
                      showSnackbar("Ingrese un titulo", context);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
