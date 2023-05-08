import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_sapp/models/task.dart';
import 'package:task_sapp/controllers/task.dart';
import 'package:task_sapp/pages/edit_task_page.dart';

TaskController taskCtrl = TaskController();

class TaskCard extends StatelessWidget {
  const TaskCard(
      {super.key,
      required this.task,
      required this.reloadHome,
      required this.isDarkMode});
  final Task task;
  final Function(String content) reloadHome;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            backgroundColor:
                isDarkMode ? const Color(0xff313034) : const Color(0xffFFFFFF),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            context: context,
            builder: (_) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                          margin: const EdgeInsets.all(5),
                          child: optionButton(
                              "Eliminar",
                              const Color(0xffEA4747),
                              () => removeTask(context)))),
                  Expanded(
                      flex: 1,
                      child: Container(
                          margin: const EdgeInsets.all(5),
                          child: optionButton(
                              valueButtonComplete(),
                              const Color(0xff53D80C),
                              () => completeTask(context)))),
                  Expanded(
                      flex: 1,
                      child:
                          optionButton("Editar", const Color(0xff3AC1E2), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditTaskPage(
                                    reloadHome: (content) {
                                      reloadHome(content);
                                      Navigator.pop(context);
                                    },
                                    task: task)));
                      }))
                ],
              );
            });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color:
                isDarkMode ? const Color(0xff313034) : const Color(0xffFFFFFF),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(
                  decoration: isTaskComplete(),
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Quicksand"),
            ),
            const SizedBox(height: 8),
            Text(
              task.description!.isEmpty ? "Sin descripcion" : task.description!,
              style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey,
                  fontFamily: "Quicksand"),
            ),
            Divider(
              color: isDarkMode
                  ? const Color(0xffFFFFFF)
                  : const Color(0xff000000),
            ),
            Row(
              children: [
                label(task.date, const Color(0xff8D83F7),
                    const Color(0xffF3F2FE)),
                const SizedBox(width: 5),
                label(task.category, const Color(0xff459DC5),
                    const Color(0xffEEF8FE))
              ],
            )
          ],
        ),
      ),
    );
  }

  void removeTask(BuildContext context) {
    taskCtrl.delete(task.id).then((response) {
      reloadHome(response.body);
    });
    Navigator.pop(context);
  }

  void completeTask(BuildContext context) {
    int valueTaskComplete = task.isComplete == 1 ? 0 : 1;

    taskCtrl.setComplete(valueTaskComplete, task.id).then((_) {
      reloadHome("Tarea ${valueButtonComplete()}");
    });
    Navigator.pop(context);
  }

  String valueButtonComplete() {
    return task.isComplete == 0 ? "Completada" : "Sin Completar";
  }

  TextDecoration isTaskComplete() {
    return task.isComplete == 1
        ? TextDecoration.lineThrough
        : TextDecoration.none;
  }

  Widget label(String title, Color colorlabel, Color colorbackground) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: colorbackground),
      child: Text(
        title,
        style: TextStyle(color: colorlabel, fontFamily: "Righteous"),
      ),
    );
  }

  Widget optionButton(String title, Color color, Function action) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: CupertinoButton(
          padding: const EdgeInsets.all(5),
          color: color,
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
          onPressed: () => action()),
    );
  }
}
