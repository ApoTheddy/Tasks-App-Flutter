class Settings {
  late String username;
  late int darkMode;

  Settings(this.username, this.darkMode);

  List toList() {
    return [username, darkMode];
  }

  Settings.fromJson(Map<String, dynamic> json) {
    username = json["username"];
    darkMode = json["darkMode"];
  }
}
