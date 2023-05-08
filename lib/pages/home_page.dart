import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_sapp/components/task_card.dart';
import 'package:task_sapp/controllers/settings.dart';
import 'package:task_sapp/models/response_database.dart';
import 'package:task_sapp/models/settings.dart';
import 'package:task_sapp/models/task.dart';
import 'package:task_sapp/pages/add_task_page.dart';
import 'package:task_sapp/controllers/task.dart';
import 'package:task_sapp/utils/additional_functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskController taskCtrl = TaskController();
  SettingsController settingsCtrl = SettingsController();
  TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void reloadHome(String content) {
    setState(() {
      showSnackbar(content, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: settingsCtrl.getConfiguration(),
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Settings settings = Settings.fromJson(snapshot.data.body[0]);
            bool darkMode = isDarkMode(settings);

            return Scaffold(
              backgroundColor:
                  darkMode ? const Color(0xff202124) : const Color(0xffF4F6FA),
              appBar: AppBar(
                  title: const Text(
                    "Tasks App",
                    style: TextStyle(fontFamily: "Satisfy", fontSize: 24),
                  ),
                  centerTitle: true),
              drawer: Drawer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DrawerHeader(
                        child: Row(
                      children: [
                        const Text("User: ", style: TextStyle(fontSize: 20)),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: TextFormField(
                                              maxLines: 1,
                                              controller: usernameController,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        CupertinoButton(
                                          onPressed: () {
                                            setState(() => settings.username =
                                                usernameController.text);

                                            settingsCtrl
                                                .update(settings)
                                                .then((_) {});
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Guardar"),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            settings.username,
                            style: const TextStyle(
                                color: Colors.blueAccent, fontSize: 20),
                          ),
                        )
                      ],
                    )),
                    Row(
                      children: [
                        const Text("Dark Mode"),
                        Switch(
                          value: settings.darkMode == 1 ? true : false,
                          onChanged: (value) {
                            setState(() {
                              settings.darkMode =
                                  settings.darkMode == 1 ? 0 : 1;
                              settingsCtrl.update(settings);
                            });
                          },
                        ),
                        Text(darkMode ? "Activado" : "Desactivado")
                      ],
                    )
                  ],
                ),
              ),
              body: FutureBuilder(
                future: taskCtrl.getAll(),
                builder: (_, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    ResponseDatabase response = snapshot.data;

                    return ListView.builder(
                        itemCount: response.body.length,
                        itemBuilder: (_, index) {
                          Task task = Task.fromJson(response
                              .body[(response.body.length - 1) - index]);
                          return TaskCard(
                            task: task,
                            reloadHome: reloadHome,
                            isDarkMode: darkMode,
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.data.body));
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AddTaskPage(
                              reloadHome: reloadHome, isDarkMode: darkMode)));
                },
                child: const Icon(Icons.add_circle_outline_outlined),
              ),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
                body: Center(child: Text("Ocurrio un error")));
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  bool isDarkMode(Settings settings) {
    bool darkMode = settings.darkMode == 1;
    return darkMode;
  }
}
