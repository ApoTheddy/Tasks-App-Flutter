import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_sapp/components/task_card.dart';
import 'package:task_sapp/models/task.dart';
import 'package:task_sapp/controllers/task.dart';
import 'package:task_sapp/utils/additional_functions.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({super.key, required this.reloadHome, required this.task});
  final Function(String content) reloadHome;
  final Task task;

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TaskController db;

  String categorySelected = "Productividad";
  List<String> categories = [
    "Productividad",
    "Programacion",
  ];

  TextEditingController titleController = TextEditingController();
  TextEditingController? descriptionController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    db = TaskController();
    titleController.text = widget.task.title;
    descriptionController!.text = widget.task.description!;
    categorySelected = widget.task.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      .map<DropdownMenuItem<String>>((String value) =>
                          DropdownMenuItem<String>(
                              value: value, child: Text(value)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => categorySelected = value!);
                  }),
              const SizedBox(height: 20),
              CupertinoButton(
                  color: Colors.green[400],
                  child: const Text("Actualizar"),
                  onPressed: () {
                    if (titleController.text.isEmpty) {
                      showSnackbar("Ingrese un titulo", context);
                    } else {
                      widget.task.title = titleController.text;
                      widget.task.description = descriptionController!.text;
                      widget.task.category = categorySelected;

                      taskCtrl.update(widget.task).then((response) {
                        widget.reloadHome(response.body);
                      });
                      Navigator.pop(context);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
