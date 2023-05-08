import 'package:sqflite/sqflite.dart';
import 'package:task_sapp/models/response_database.dart';

class DatabaseController {
  ResponseDatabase response = ResponseDatabase(-1, "", "");

  Future<Database> getDB() async {
    final database = await openDatabase("database_task.db", version: 1);
    return database;
  }

  Future<ResponseDatabase> createTable({required String sql}) async {
    try {
      Database database = await getDB();
      database.execute(sql);
      return ResponseDatabase.ok("Tabla creada correctamente");
    } catch (error) {
      return ResponseDatabase.error(error);
    }
  }

  Future<ResponseDatabase> createTaskTable() async {
    response = await createTable(
        sql:
            '''CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT DEFAULT "", date VARCHAR(10), category TEXT, isComplete INTEGER DEFAULT 0)''');
    return response;
  }

  Future<ResponseDatabase> createSettingsTable() async {
    response = await createTable(
        sql:
            "CREATE TABLE IF NOT EXISTS settings(username TEXT, darkMode INTEGER DEFAULT 0)");
    return response;
  }
}
