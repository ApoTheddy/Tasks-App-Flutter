import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:task_sapp/controllers/database.dart';
import 'package:task_sapp/controllers/settings.dart';
import 'package:task_sapp/models/response_database.dart';
import 'package:task_sapp/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;
  await createInitialTables();

  runApp(const App());
}

Future<void> createInitialTables() async {
  DatabaseController dbCtrl = DatabaseController();
  SettingsController settingsCtrl = SettingsController();
  await dbCtrl.createTaskTable();
  await dbCtrl.createSettingsTable();
  ResponseDatabase response = await settingsCtrl.getConfiguration();

  if (List.castFrom(response.body).isEmpty) {
    settingsCtrl.insert();
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/home",
        routes: {"/home": (context) => const HomePage()});
  }
}
