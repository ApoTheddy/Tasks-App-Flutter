import 'package:task_sapp/controllers/database.dart';
import 'package:task_sapp/models/response_database.dart';
import 'package:task_sapp/models/settings.dart';

class SettingsController {
  final DatabaseController ctrlDB = DatabaseController();

  Future<ResponseDatabase> getConfiguration() async {
    try {
      final db = await ctrlDB.getDB();
      List<Map> list = await db.rawQuery("SELECT * FROM settings");
      return ResponseDatabase.ok(list);
    } catch (error) {
      return ResponseDatabase.error(error);
    }
  }

  void insert() async {
    final db = await ctrlDB.getDB();
    db.rawUpdate(
        '''INSERT INTO settings(username,darkMode) VALUES("user",0)''');
  }

  Future<ResponseDatabase> update(Settings settings) async {
    try {
      final db = await ctrlDB.getDB();
      db.rawUpdate(
          "UPDATE settings SET username = ?, darkMode = ?", settings.toList());
      return ResponseDatabase.ok("Tarea agregada correctamente");
    } catch (error) {
      return ResponseDatabase.error(error);
    }
  }
}
