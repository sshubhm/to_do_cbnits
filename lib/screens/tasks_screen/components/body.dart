import 'package:flutter/material.dart';
import 'package:to_do_cbnits/models/task.dart';
import 'package:to_do_cbnits/screens/tasks_screen/components/input_field.dart';
import 'package:to_do_cbnits/screens/tasks_screen/components/task_list_tile.dart';

class Body extends StatelessWidget {
  final List<Task>? tasks;
  final bool? addNewTask;
  final Function? onAddTask;
  final Function? onCheckBoxTap;
  final Function? onDeleteTask;

  var controller = TextEditingController();

  Body(
      {this.tasks,
      this.addNewTask,
      this.onAddTask,
      this.onCheckBoxTap,
      this.onDeleteTask});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return TaskListTile(
                onTaskDelete: () {
                  onDeleteTask!(index);
                },
                onCheckBoxTap: () {
                  onCheckBoxTap!(index);
                },
                task: tasks![index],
              );
            },
            itemCount: tasks!.length,
          ),
        ),
        addNewTask!
            ? InputField(
                onAddTask: onAddTask,
                controller: controller,
              )
            : Container()
      ],
    );
  }
}
