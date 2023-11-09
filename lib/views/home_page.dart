// ignore_for_file: constant_identifier_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todolist1/controller/home_controller.dart';
import 'package:todolist1/provider/search_provider.dart';
import 'package:todolist1/widget_pages/image_adding.dart';
import 'package:todolist1/provider/username_provider.dart.dart';
import 'package:todolist1/widget_pages/task_adding.dart';
import 'package:todolist1/widget_pages/task_editing.dart';
import 'package:todolist1/db_functions/db_functions.dart';
import 'package:todolist1/model/data_model.dart';
import 'package:todolist1/theme/theme_manager_provider.dart';
import 'package:todolist1/widget_pages/checkbox_change.dart';
import 'package:todolist1/widget_pages/custom_container.dart';
import 'package:todolist1/widget_pages/drawer.dart';
import 'package:todolist1/widget_pages/search_bar.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  String username;
  HomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  File? file;
  ImagePicker image = ImagePicker();
  @override
  void initState() {
    super.initState();   
    loadTasks(context);
    final nameProvider = Provider.of<UsernameProvider>(context, listen: false);
    nameProvider.usernameFunction(widget.username);
    nameProvider.storedUsername;
  }
   void filterTasks(String search) {  
    Provider.of<SearchProvider>(context, listen: false).searching();
    Provider.of<dbProvider>(context,listen: false).filter(search);
   }

  @override
  Widget build(BuildContext context) {
    Provider.of<UsernameProvider>(context, listen: false).storedUsername;
    final dbPro = Provider.of<dbProvider>(context, listen: false);
    final themeManager = Provider.of<ThemeManager>(context);
          final storedImageBytes = dbPro.getStoredImage();
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
                        padding: const EdgeInsets.only(
                            bottom: 290, left: 15, right: 15),
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
                                  dropdownColor:
                                      themeManager.primaryColorGradientApp,
                                  style: const TextStyle(color: Colors.white),
                                  icon: const Icon(
                                    Icons.expand_more_outlined,
                                    color: Colors.white,
                                  ),
                                  value: dbPro.selectedFilter,
                                  onChanged: (newValue) {
                                    dbPro.selectedFilter = newValue!;
                                    filterTasks('');
                                  },
                                  items: FilterCriteria.values.map((criteria) {
                                    return DropdownMenuItem<FilterCriteria>(
                                      value: criteria,
                                      child: Text(
                                          criteria.toString().split('.').last),
                                    );
                                  }).toList(),
                                ),
                                FloatingActionButton(
                                  elevation: 6,
                                  backgroundColor:
                                      themeManager.floatingButtonColor,
                                  splashColor:
                                      const Color.fromARGB(255, 240, 189, 48),
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        child:  SingleChildScrollView(
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
                          return Consumer<dbProvider>(
                            builder: (context, dbPro, child) {
                              return Expanded(
                                child: ListView.builder(
                                  itemCount: dbPro.filteredTasks.length,
                                  itemBuilder: (context, index) {
                                    final data = dbPro.filteredTasks[index];
                                    return SizedBox(
                                      width: 200,
                                      height: 100,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          elevation: 10,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: ListTile(
                                              title: SingleChildScrollView(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data.taskName,
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          decoration: data
                                                                  .tasComplete
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : TextDecoration
                                                                  .none,
                                                        ),
                                                      ),
                                                      Text(
                                                        DateFormat('MM/dd/yyyy')
                                                            .format(data.date),
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      if (data.description
                                                          .isNotEmpty)
                                                        Text(
                                                          data.description,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              leading: CustomCheckbox(
                                                value: data.tasComplete,
                                                onChanged: (newValue) {                            
                                                    dbPro.checkBoxchanged(
                                                        newValue, index);
                                                    data.tasComplete =
                                                        newValue ?? false;
                                                
                                                },
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  InkWell(
                                                    onTap: () =>
                                                        ShowDialogueBox(
                                                            context, index),
                                                    child:
                                                        const Icon(Icons.edit),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showDeleteConfirmationDialog(
                                                          context, index);
                                                    },
                                                    child: const Icon(
                                                        Icons.delete),
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
}
