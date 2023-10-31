// ignore_for_file: constant_identifier_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todolist1/controller.dart/image_adding.dart';
import 'package:todolist1/controller.dart/task_adding.dart';
import 'package:todolist1/controller.dart/task_editing.dart';
import 'package:todolist1/controller.dart/functions/db_functions.dart';
import 'package:todolist1/controller.dart/task_utils.dart';
import 'package:todolist1/model/data_model.dart';
import 'package:todolist1/controller.dart/theme/theme_manager.dart';
import 'package:todolist1/screens/widget_pages/checkbox_change.dart';
import 'package:todolist1/screens/widget_pages/custom_container.dart';
import 'package:todolist1/screens/widget_pages/drawer.dart';
import 'package:todolist1/screens/widget_pages/search_bar.dart';

// ignore: must_be_immutable
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

  List<TaskModel> todolist = [];
  List<TaskModel> filteredTasks = [];
  File? file;
  ImagePicker image = ImagePicker();
  bool _isDeleteDialogOpen = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      todolist = Hive.box<TaskModel>('task_db').values.toList();
      taskListNotifier.value = todolist;
      filteredTasks = todolist;
      final storedUsername = Hive.box('username_box').get('username');
      if (storedUsername != null) {
        setState(() {
          widget.username = storedUsername;
        });
      }
    });
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
            size: 30,
          );

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: themeManager.primaryColorGradientApp,
            ),
          )),
      endDrawer: draWer(),
      body: SafeArea(
        child: Stack(
          children: [
            ClipPath(
              clipper: MyCustomClipper(),
              child: Container(
                height: 400,
                width: double.infinity,
                color: themeManager.mainContainerBack,
              ),
            ),
            ClipPath(
              clipper: MyCustomClipper1(),
              child: Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.40),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  gradient: themeManager.primaryColorGradient,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 290, left: 15, right: 15),
                  child: AnimatedSearchBar(
                    onSearch: filterTasks,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 0,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return themeManager.IconColorHome.createShader(bounds);
                },
                child: const Icon(
                  Icons.subject_rounded,
                  color: Colors.white,
                  size: 170,
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
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
                        ),
                        child: GestureDetector(
                          onTap: () =>
                              ImageFunction.showAddPhotoDialog(context),
                          child: ClipOval(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor:
                                  themeManager.pictureBackground,
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
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "All Task's",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                          DropdownButton<FilterCriteria>(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 5,
                            dropdownColor: themeManager.primaryColorGradientApp,
                            style: const TextStyle(color: Colors.white),
                            icon: const Icon(
                              Icons.expand_more_outlined,
                              color: Colors.white,
                            ),
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
                                child:
                                    Text(criteria.toString().split('.').last),
                              );
                            }).toList(),
                          ),
                          FloatingActionButton(
                            elevation: 6,
                            backgroundColor: themeManager.floatingButtonColor,
                            splashColor:
                                const Color.fromARGB(255, 240, 189, 48),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: const SingleChildScrollView(
                                    child: ShowDialogAdd(),
                                  ),
                                );
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
                      builder: (BuildContext ctx, List<TaskModel> studentList,
                          Widget? child) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_isDeleteDialogOpen) {
                            _showDeleteConfirmationDialog(
                                context, _deleteIndex);
                          }
                        });
                        return Expanded(
                          child: ListView.builder(
                            itemCount: filteredTasks.length,
                            itemBuilder: (context, index) {
                              final data = filteredTasks[index];
                              return SizedBox(
                                width: 200,
                                height: 100,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: ListTile(
                                        title: 
                                         SingleChildScrollView(
                                           child: Padding(
                                             padding: const EdgeInsets.only(bottom: 10),
                                             child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                              data.taskName,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                decoration: data.tasComplete
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                              ),
                                                                                   ),
                                                Text(
                                                  DateFormat('MM/dd/yyyy').format(data.date),
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                                if (data.description.isNotEmpty)
                                                  Text(
                                                    data.description,
                                                    style: const TextStyle(
                                                        fontSize: 14,color: Colors.grey),
                                                  ),
                                              ],
                                                                                   ),
                                           ),
                                         ),
                                        leading: CustomCheckbox(
                                          value: data.tasComplete,
                                          onChanged: (newValue) {
                                            setState(() {
                                              checkBoxchanged(
                                                  newValue, index);
                                              data.tasComplete =
                                                  newValue ?? false;
                                            });
                                          },
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () => ShowDialogueBox(context, index),
                                              child: const Icon(Icons.edit),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _deleteIndex = index;
                                                _isDeleteDialogOpen = true;
                                                setState(() {});
                                              },
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
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> ShowDialogueBox(BuildContext context, int index) {
    return showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext context) {
                                                return Dialog(
                                                  shape:
                                                      RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(16.0),
                                                  ),
                                                  child:
                                                      SingleChildScrollView(
                                                    child: ShowDialogEdit(
                                                        task: filteredTasks[
                                                            index],
                                                        index: index),
                                                  ),
                                                );
                                              },
                                            );
  }

  int _deleteIndex = -1;
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
                _isDeleteDialogOpen = false;
                _deleteIndex = -1;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  deleteTask(index);
                  _isDeleteDialogOpen = false;
                  _deleteIndex = -1;
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
