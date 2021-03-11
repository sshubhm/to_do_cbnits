import 'package:flutter/material.dart';
import 'package:to_do_cbnits/models/task.dart';
import 'package:to_do_cbnits/utilities/network_utility.dart';

import 'components/body.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasks = [];
  //todo remove two item consecutively and do undo bug
  Task? lastDeletedTask;

  bool addNewTask = false;

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

  var _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    // TODO: handle error
    super.initState();
    NetworkUtility().getTasks().then((result) {
      result.sort(sortLogic);
      setState(() {
        tasks = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(),
        body: Body(
          onCheckBoxTap: (index) {
            List<Task> tempTasks = [...tasks];
            var task = tempTasks.removeAt(index);
            NetworkUtility()
                .toggleCompletedStatus(
                    id: tasks[index].id.toString(),
                    isCompleted: task.isCompleted)
                .then((result) {
              tempTasks.add(result);
              tempTasks.sort(sortLogic);
              setState(() {
                tasks = tempTasks;
              });
            });
          },
          tasks: tasks,
          onDeleteTask: (index) {
            NetworkUtility()
                .deleteTask(id: tasks[index].id.toString())
                .then((result) {
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
              } else {
                //todo handle error
              }
            });
          },
          addNewTask: addNewTask,
          onAddTask: (description) {
            if (description.isEmpty) {
              return;
            }
            Task task = new Task();
            task.description = description;
            NetworkUtility().addNewTask(task: task).then((result) {
              List<Task> tempTasks = [result, ...tasks];

              setState(() {
                tasks = tempTasks;
                addNewTask = false;
              });
            });
            //todo handle error
          },
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
