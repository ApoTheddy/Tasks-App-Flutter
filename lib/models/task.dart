class Task {
  late int id;
  late String title;
  String? description;
  late String date;
  late String category;
  late int isComplete;

  Task(this.title, this.description, this.date, this.category, this.isComplete);

  Task.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    description = json["description"];
    date = json["date"];
    category = json["category"];
    isComplete = json["isComplete"];
  }

  List toList() {
    return [title, description, date, category, isComplete];
  }
}
