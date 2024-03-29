import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/functions/db_functions.dart';
import 'package:todolist/model/data_model.dart';

class ShowDialogAdd extends StatefulWidget {
  
   const ShowDialogAdd({super.key});

  @override
  State<ShowDialogAdd> createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialogAdd> {
  final TextEditingController _taskController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _discriptController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      title: const Text('Add Task'),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _taskController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Task is Empty';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Task',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 4, 18, 94)),
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
                  onTap:()=>_showDatePicker(),
                  splashColor: Colors.grey,
                  child: const Icon(
                    Icons.date_range_outlined,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
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
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 4, 18, 94)),
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
      actions:<Widget>[
              TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        saveTask();
                      });

                      Navigator.of(context).pop();
                    }
                  }),
              TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
    );
  }
    Future<void> saveTask() async {
    final task0 = _taskController.text.trim();
    final date = _dateTime;
    final descriPtion = _discriptController.text.trim();
    final task = TaskModel(
        taskName: task0,
        tasComplete: false,
        date: date,
        description: descriPtion);
    await addtask(task);
    _taskController.clear();
    _dateController.clear();
    _discriptController.clear();
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