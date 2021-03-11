import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:to_do_cbnits/models/task.dart';
import 'package:to_do_cbnits/utilities/network_utility.dart';

import 'components/body.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasks = [];
  Task? lastDeletedTask;
  var _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final FocusNode addTaskFocusNode = FocusNode();
  bool addNewTask = false;
  bool isLoading = false;

  int sortLogic(task1, task2) {
    if (task1.isCompleted!) {
      if (task2.isCompleted!) {
        if (task1.completedAt!.isBefore(task2.completedAt!)) {
          return -1;
        } else {
          return 1;
        }
      } else {
        return 1;
      }
    } else {
      if (task2.isCompleted!) {
        return -1;
      } else {
        if (task1.createdAt!.isBefore(task2.createdAt!)) {
          return 1;
        } else {
          return -1;
        }
      }
    }
  }

  onCheckBoxTap(index) {
    setState(() {
      isLoading = true;
    });
    List<Task> tempTasks = [...tasks];
    var task = tempTasks.removeAt(index);
    NetworkUtility()
        .toggleCompletedStatus(
            id: tasks[index].id.toString(), isCompleted: task.isCompleted)
        .then((result) {
      tempTasks.add(result);
      tempTasks.sort(sortLogic);
      setState(() {
        tasks = tempTasks;
      });
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  onTaskEdit(value, index) {
    setState(() {
      isLoading = true;
    });
    NetworkUtility()
        .updateTask(task: tasks[index], description: value)
        .then((result) {
      List<Task> tempTasks = [...tasks];
      tempTasks.removeAt(index);
      tempTasks.add(result);
      tempTasks.sort(sortLogic);
      setState(() {
        tasks = tempTasks;
      });
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  onDeleteTask(index) {
    _scaffoldKey.currentState!.removeCurrentSnackBar();
    NetworkUtility().deleteTask(id: tasks[index].id.toString()).then((result) {
      if (result) {
        List<Task> tempTasks = [...tasks];
        lastDeletedTask = tempTasks.removeAt(index);
        setState(() {
          tasks = tempTasks;
        });
        _scaffoldKey.currentState!.showSnackBar(SnackBar(
          content: Text("Deleted"),
          action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              _scaffoldKey.currentState!.removeCurrentSnackBar();
              if (lastDeletedTask != null) {
                NetworkUtility()
                    .addNewTask(task: lastDeletedTask)
                    .then((result) {
                  tempTasks = [result, ...tasks];
                  lastDeletedTask = null;
                  setState(() {
                    tasks = tempTasks;
                  });
                });
              }
            },
          ),
        ));
      }
    });
  }

  onAddTask(description) {
    if (description.trim().isEmpty) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    Task task = new Task();
    task.description = description;
    NetworkUtility().addNewTask(task: task).then((result) {
      List<Task> tempTasks = [result, ...tasks];

      setState(() {
        tasks = tempTasks;
        addNewTask = false;
      });
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    addTaskFocusNode.addListener(() {
      if (!addTaskFocusNode.hasFocus) {
        setState(() {
          addNewTask = false;
        });
      }
    });
    isLoading = true;
    NetworkUtility().getTasks().then((result) {
      result.sort(sortLogic);
      setState(() {
        tasks = result;
      });
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo List"),
          actions: [
            isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SpinKitWanderingCubes(
                      color: Colors.white,
                      size: 18,
                    ),
                  )
                : Container(),
          ],
        ),
        body: Body(
          onEditTask: onTaskEdit,
          addTaskFocusNode: addTaskFocusNode,
          onCheckBoxTap: onCheckBoxTap,
          tasks: tasks,
          onDeleteTask: onDeleteTask,
          addNewTask: addNewTask,
          onAddTask: onAddTask,
        ),
        floatingActionButton: !addNewTask
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    addNewTask = true;
                  });
                },
                child: Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
