import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist1/controller.dart/functions/db_functions.dart';
import 'package:todolist1/model/data_model.dart';
import 'package:todolist1/screens/home_page.dart';

class ShowDialogEdit extends StatefulWidget {
  final TaskModel task;
  final int index;

  const ShowDialogEdit({Key? key, required this.task, required this.index})
      : super(key: key);

  @override
  State<ShowDialogEdit> createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialogEdit> {
  final TextEditingController _taskController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _discriptController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  DateTime _dateTime = DateTime.now();

  List<HomePage> todolist = [];
  @override
  void initState() {
    super.initState();
    _taskController.text = widget.task.taskName;
    _discriptController.text = widget.task.description;
    _dateTime = widget.task.date;
    _dateController.text = _formatDate(widget.task.date);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      title: const Text('Edit Task'),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Task is Empty';
                }
                return null;
              },
              controller: _taskController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 4, 18, 94),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _dateController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date is Empty';
                      }
                      return null;
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Select Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 4, 18, 94)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                    splashColor: Colors.grey,
                    onTap: () => _showDatePicker(),
                    child: const Icon(
                      Icons.date_range_outlined,
                      size: 20,
                      color: Colors.grey,
                    )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _discriptController,
              decoration: InputDecoration(
                hintText: 'Description (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 4, 18, 94)),
                ),
              ),
              maxLines: 4,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final updatedTask = TaskModel(
                taskName: _taskController.text.trim(),
                tasComplete: widget.task.tasComplete,
                date: _dateTime,
                description: _discriptController.text.trim(),
              );
              updateTask(widget.index, updatedTask);
              Navigator.of(context).pop(updatedTask);
            }
          },
        ),
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2060),
    ).then((value) {
      if (value != null) {
        setState(() {
          _dateTime = value;
          _dateController.text = _formatDate(value);
        });
      }
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }
}
