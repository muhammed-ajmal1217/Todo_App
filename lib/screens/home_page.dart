import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todolist/functions/db_functions.dart';
import 'package:todolist/functions/image_function.dart';
import 'package:todolist/functions/task_adding_function.dart';
import 'package:todolist/model/data_model.dart';
import 'package:todolist/screens/widget_pages/checkbox_change.dart';
import 'package:todolist/screens/widget_pages/drawer.dart';
import 'package:todolist/screens/widget_pages/search_bar.dart';
import 'package:todolist/theme/theme_manager.dart';

class HomePage extends StatefulWidget {
  String username;
  HomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum FilterCriteria {
  Daily,
  Weekly,
  Monthly,
  All,
}

FilterCriteria selectedFilter = FilterCriteria.Daily;

class _HomePageState extends State<HomePage> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _discriptController = TextEditingController();
  List<TaskModel> todolist = [];
  List<TaskModel> filteredTasks = [];
  final _formKey = GlobalKey<FormState>();
  List<int>? imageBytes;
  File? file;
  ImagePicker image = ImagePicker();
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    final taskDb = Hive.box<TaskModel>('task_db');
    todolist = taskDb.values.toList();
    setState(() {
      taskListNotifier.value = todolist;
    });
    filteredTasks = todolist;
    final usernameBox = Hive.box('username_box');
    final storedUsername = usernameBox.get('username');
    if (storedUsername != null) {
      widget.username = storedUsername;
    }
  }

  void filterTasks(String search) {
    final filteredList = filterTasksBySearch(todolist, search);

    setState(() {
      filteredTasks = filteredList;
    });
  }

  List<TaskModel> filterTasksBySearch(List<TaskModel> taskList, String search) {
    return search.isEmpty
        ? taskList
        : taskList
            .where((task) =>
                task.taskName.toLowerCase().contains(search.toLowerCase()))
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final storedImageBytes = getStoredImage();
    final imageWidget = storedImageBytes != null
        ? Image.memory(
            storedImageBytes,
            fit: BoxFit.cover,
            width: 150,
            height: 150,
          )
        : const Icon(
            Icons.party_mode_outlined,
            color: Colors.white,
            size: 40,
          );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeManager.primaryColor,
        automaticallyImplyLeading: false,
      ),
      endDrawer: draWer(),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.40),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    color: themeManager.primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 160, left: 15, right: 15),
                    child: AnimatedSearchBar(
                      onSearch: filterTasks,
                    ),
                  ),
                ),
                Container(
                  child: Positioned(
                    top: 110,
                    left: 15,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.40),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color.fromARGB(255, 185, 184, 184),
                              width: 1.0,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _addPhotoFunction(context);
                            },
                            child: ClipOval(
                              child: CircleAvatar(
                                radius: 45,
                                backgroundColor:
                                    const Color.fromARGB(255, 174, 198, 221),
                                child: imageWidget,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          '${widget.username}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w100),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: themeManager.headingsColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "All Task's",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: Colors.grey),
                      ),
                      DropdownButton<FilterCriteria>(
                        value: selectedFilter,
                        onChanged: (newValue) {
                          selectedFilter = newValue!;
                          filterTasks('');
                        },
                        items: FilterCriteria.values.map((criteria) {
                          return DropdownMenuItem<FilterCriteria>(
                            value: criteria,
                            child: Text(criteria.toString().split('.').last),
                          );
                        }).toList(),
                      ),
                      FloatingActionButton(
                        backgroundColor: themeManager.floatingButtonColor,
                        splashColor: const Color.fromARGB(255, 240, 189, 48),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ShowDialogAdd();
                            },
                          );
                        },
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Builder(
              builder: (context) {
                return ValueListenableBuilder(
                    valueListenable: taskListNotifier,
                    builder: (BuildContext ctx, List<TaskModel> studentList,
                        Widget? child) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final data = filteredTasks[index];
                            return Container(
                              width: 200,
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: ListTile(
                                      title: Text(
                                        data.taskName,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          decoration: data.tasComplete
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${DateFormat('MM/dd/yyyy').format(data.date)}',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          if (data.description != null &&
                                              data.description.isNotEmpty)
                                            Text(
                                              '${data.description}',
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                        ],
                                      ),
                                      leading: CustomCheckbox(
                                        value: data.tasComplete,
                                        onChanged: (newValue) {
                                          checkBoxchanged(newValue, index);
                                          data.tasComplete = newValue ?? false;
                                        },
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                const AlertDialog(
                                                  title: Text(
                                                      'Are you sure you want to delete this task..?'),
                                                );
                                                _showEditDialogBox(index);
                                              },
                                              child: const Icon(Icons.edit)),
                                          InkWell(
                                              onTap: () {
                                                const AlertDialog(
                                                  title: Text(
                                                      'Are you sure you want to delete this task..?'),
                                                );
                                                _showDeleteConfirmationDialog(
                                                    context, index);
                                              },
                                              child: const Icon(Icons.delete)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    });
              },
            )
          ],
        ),
      ),
    );
  }

  void checkBoxchanged(bool? value, int index) async {
    setState(() {
      final taskDb = Hive.box<TaskModel>('task_db');
      final task = taskDb.getAt(index);
      if (task != null) {
        task.tasComplete = value ?? false;
        taskDb.putAt(index, task);
      }
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
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
                setState(() {
                  deleteTask(index);
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialogBox(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final String currentTaskName = todolist[index].taskName;
        final String currentDescription = todolist[index].description;
        _taskController.text = currentTaskName;
        _discriptController.text = currentDescription;
        _dateController.text =
            DateFormat('MM/dd/yyyy').format(todolist[index].date);

        return Form(
          key: _formKey,
          child: AlertDialog(
            title: const Text('Edit Task'),
            content: Column(
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
                        // onTap: () => _showDatePicker(),
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
            actions: <Widget>[
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedTask = TaskModel(
                        taskName: _taskController.text.trim(),
                        tasComplete: todolist[index].tasComplete,
                        date: _dateTime,
                        description: _discriptController.text.trim());
                    updateTask(index, updatedTask);
                    Navigator.of(context).pop();
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
          ),
        );
      },
    );
  }

  void _addPhotoFunction(BuildContext context) async {
    ImageFunction.showAddPhotoDialog(context);
  }
}
