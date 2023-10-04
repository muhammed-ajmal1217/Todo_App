import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todolist/functions/db_functions.dart';
import 'package:todolist/screens/task_utils.dart';
import 'package:todolist/screens/widget_pages/image_adding.dart';
import 'package:todolist/screens/widget_pages/task_adding.dart';
import 'package:todolist/screens/widget_pages/task_editing.dart';
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

enum FilterCriteria { Daily, Weekly, Monthly, All }

FilterCriteria selectedFilter = FilterCriteria.Daily;

class _HomePageState extends State<HomePage> {
  List<TaskModel> todolist = [];
  List<TaskModel> filteredTasks = [];
  File? file;
  ImagePicker image = ImagePicker();

  @override
  void initState() {
    super.initState();
    todolist = Hive.box<TaskModel>('task_db').values.toList();
    setState(() => taskListNotifier.value = todolist);
    filteredTasks = todolist;
    final storedUsername = Hive.box('username_box').get('username');
    if (storedUsername != null) widget.username = storedUsername;
  }

  void filterTasks(String search) {
    final filteredBySearch = search.isEmpty
        ? todolist
        : todolist
            .where((task) =>
                task.taskName.toLowerCase().contains(search.toLowerCase()))
            .toList();
    final filteredByCriteria =
        filterTasksByCriteria(filteredBySearch, selectedFilter, search);

    setState(() => filteredTasks = filteredByCriteria);
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
                            onTap: () => ImageFunction.showAddPhotoDialog(context),
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
                          widget.username,
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
                          setState(() {
                            selectedFilter = newValue!;
                            filterTasks('');
                          });
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
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ShowDialogAdd();
                          },
                        ),
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
                  builder: (BuildContext ctx, List<TaskModel> studentList, Widget? child) {
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${DateFormat('MM/dd/yyyy').format(data.date)}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        if (data.description.isNotEmpty)
                                          Text(
                                            '${data.description}',
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                      ],
                                    ),
                                    leading: CustomCheckbox(
                                      value: data.tasComplete,
                                      onChanged: (newValue) {
                                        setState(() {
                                          checkBoxchanged(newValue, index);
                                          data.tasComplete = newValue ?? false;
                                        });
                                      },
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () => showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ShowDialogEdit(task: filteredTasks[index], index: index);
                                            },
                                          ),
                                          child: const Icon(Icons.edit),
                                        ),
                                        InkWell(
                                          onTap: () => _showDeleteConfirmationDialog(context, index),
                                          child: const Icon(Icons.delete),
                                        ),
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
                  },
                );
              },
            )
          ],
        ),
      ),
    );
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
}
