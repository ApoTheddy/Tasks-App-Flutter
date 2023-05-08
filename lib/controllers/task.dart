import 'package:task_sapp/controllers/database.dart';
import 'package:task_sapp/models/response_database.dart';
import 'package:task_sapp/models/task.dart';

class TaskController {
  final DatabaseController ctrlDB = DatabaseController();
  Future<ResponseDatabase> getAll() async {
    try {
      final db = await ctrlDB.getDB();
      List<Map> list = await db.rawQuery("SELECT * FROM tasks");
      return ResponseDatabase.ok(list);
    } catch (error) {
      return ResponseDatabase.error(error);
    }
  }

  Future<ResponseDatabase> insert(Task task) async {
    try {
      final db = await ctrlDB.getDB();
      await db.rawInsert(
          "INSERT INTO Tasks(title,description,date,category, isComplete) VALUES(?, ?, ?, ?, ?)",
          task.toList());
      return ResponseDatabase.ok("Tarea agregada correctamente");
    } catch (error) {
      return ResponseDatabase.error(error);
    }
  }

  Future<ResponseDatabase> delete(int id) async {
    try {
      final db = await ctrlDB.getDB();
      await db.rawDelete("DELETE FROM tasks WHERE id = $id");
      return ResponseDatabase.ok("Tarea eliminada");
    } catch (error) {
      return ResponseDatabase.error(error);
    }
  }

  Future<ResponseDatabase> setComplete(int isComplete, int id) async {
    try {
      final db = await ctrlDB.getDB();
      await db.rawUpdate(
          "UPDATE tasks SET isComplete = $isComplete WHERE id = $id");
      return ResponseDatabase.ok("Tarea completada");
    } catch (error) {
      return ResponseDatabase.error(error);
    }
  }

  Future<ResponseDatabase> update(Task task) async {
    try {
      final db = await ctrlDB.getDB();
      await db.rawUpdate(
          '''UPDATE tasks SET title = "${task.title}", description = "${task.description}", category = "${task.category}" WHERE id = ${task.id}''');
      return ResponseDatabase.ok("Se actualizo la tarea");
    } catch (error) {
      return ResponseDatabase.error(error);
    }
  }
}
