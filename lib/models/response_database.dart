class ResponseDatabase {
  late int status;
  late String msg;
  late dynamic body;
  ResponseDatabase(this.status, this.msg, this.body);

  ResponseDatabase.ok(this.body) {
    status = 0;
    msg = "Done";
  }

  ResponseDatabase.error(Object error) {
    status = 1;
    msg = "error";
    body = error;
  }
}
