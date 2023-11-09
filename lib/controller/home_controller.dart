import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todolist1/db_functions/db_functions.dart';
import 'package:todolist1/model/data_model.dart';
import 'package:todolist1/provider/search_provider.dart';
import 'package:todolist1/provider/username_provider.dart.dart';
import 'package:todolist1/widget_pages/task_editing.dart';

Future<dynamic> ShowDialogueBox(BuildContext context, int index) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SingleChildScrollView(
          child: ShowDialogEdit(
              task: Provider.of<dbProvider>(context, listen: false)
                  .filteredTasks[index],
              index: index),
        ),
      );
    },
  );
}

void showDeleteConfirmationDialog(BuildContext context, int index) {
  final dbPro = Provider.of<dbProvider>(context, listen: false);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure you want to delete this task?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              dbPro.deleteTask(index);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> loadTasks(BuildContext context) async {
  final dbPro = Provider.of<dbProvider>(context, listen: false);
  dbPro.todolist = Hive.box<TaskModel>('task_db').values.toList();
  dbPro.filteredTasks = dbPro.todolist;
}
