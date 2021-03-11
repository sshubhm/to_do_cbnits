import 'package:flutter/material.dart';
import 'package:to_do_cbnits/models/task.dart';

import 'input_field.dart';

class TaskListTile extends StatelessWidget {
  bool isSelected = false;

  final Task? task;
  final Function? onCheckBoxTap;
  final Function? onTaskDelete;
  final Function? onEditTask;
  final Function? onTaskTileTap;

  TaskListTile(
      {this.task,
      this.onCheckBoxTap,
      this.onTaskDelete,
      this.onEditTask,
      this.onTaskTileTap});

  var editingController = TextEditingController();
  var editingFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    isSelected = task!.isCompleted!;
    if (task!.isEditing!) {
      editingController.text = task!.description!;
    }
    return GestureDetector(
      onTap: () {
        onTaskTileTap!();
        editingFocusNode.requestFocus();
      },
      child: task!.isEditing!
          ? InputField(
              onAddTask: (value) {
                onEditTask!(value);
              },
              focusNode: editingFocusNode,
              controller: editingController,
            )
          : Padding(
              padding: const EdgeInsets.all(4.0),
              child: Dismissible(
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  onTaskDelete!();
                },
                key: Key(task!.createdAt.toString()),
                background: Container(
                  color: Colors.white,
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                ),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(20),
                  child: ListTile(
                    title: Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            onCheckBoxTap!();
                          },
                        ),
                        Text(
                          task!.description!,
                          style: TextStyle(
                            decoration: isSelected
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: !isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
