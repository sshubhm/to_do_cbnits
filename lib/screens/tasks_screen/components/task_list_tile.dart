import 'package:flutter/material.dart';
import 'package:to_do_cbnits/models/task.dart';

import 'input_field.dart';

class TaskListTile extends StatefulWidget {
  final Task? task;
  final Function? onCheckBoxTap;
  final Function? onTaskDelete;
  final Function? onEditTask;

  TaskListTile(
      {this.task, this.onCheckBoxTap, this.onTaskDelete, this.onEditTask});

  @override
  _TaskListTileState createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  bool isSelected = false;
  bool isEditing = false;

  var editingController = TextEditingController();
  var editingFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    editingFocusNode.addListener(() {
      if (!editingFocusNode.hasFocus) {
        setState(() {
          isEditing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    isSelected = widget.task!.isCompleted!;
    return GestureDetector(
      onTap: () {
        editingFocusNode.requestFocus();
        editingController.text = widget.task!.description!;
        setState(() {
          isEditing = true;
        });
      },
      child: isEditing
          ? InputField(
              onAddTask: (value) {
                widget.onEditTask!(value);
              },
              focusNode: editingFocusNode,
              controller: editingController,
            )
          : Padding(
              padding: const EdgeInsets.all(4.0),
              child: Dismissible(
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  widget.onTaskDelete!();
                },
                key: Key(widget.task!.createdAt.toString()),
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
                            setState(() {
                              isSelected = value!;
                            });
                            widget.onCheckBoxTap!();
                          },
                        ),
                        Text(
                          widget.task!.description!,
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
