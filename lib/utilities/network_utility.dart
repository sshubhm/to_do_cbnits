import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:to_do_cbnits/models/task.dart';

class NetworkUtility {
  static final NetworkUtility _singleton = NetworkUtility._internal();
  factory NetworkUtility() {
    return _singleton;
  }

  NetworkUtility._internal();

  Client client = http.Client();
  var userId = "148";
  var baseUrl = "https://tiny-list.herokuapp.com/api/v1/";

  getTasks() async {
    var url = baseUrl + "users/$userId/tasks";
    var response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      List<Task> tasks =
          List<Task>.from(res.map((model) => Task.fromJson(model)));
      return tasks;
    } else {
      throw "No Task";
    }
  }

  addNewTask({Task? task}) async {
    var url = baseUrl + "users/$userId/tasks";
    print(jsonEncode({"task": task}));
    print(url);
    var response = await client.post(Uri.parse(url),
        body: jsonEncode({"task": task}),
        headers: {"content-type": "application/json"});
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201) {
      var res = jsonDecode(response.body);
      Task task = Task.fromJson(res);
      print(task.isCompleted);
      return task;
    }
  }

  deleteTask({String? id}) async {
    var url = baseUrl + "users/$userId/tasks/$id";
    var response = await client.delete(Uri.parse(url));
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  toggleCompletedStatus({String? id, bool? isCompleted}) async {
    var url = baseUrl + "users/$userId/tasks/$id/";
    if (isCompleted!) {
      url += "uncompleted";
    } else {
      url += "completed";
    }
    print(url);
    var response = await client.put(Uri.parse(url));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      Task task = Task.fromJson(res);
      return task;
    }
  }
}
