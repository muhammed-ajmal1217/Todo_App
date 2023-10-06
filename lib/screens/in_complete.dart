import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todolist/functions/db_functions.dart';
import 'package:todolist/model/data_model.dart';
import 'package:todolist/screens/widget_pages/checkbox_change.dart';
import 'package:todolist/screens/widget_pages/custom_container.dart';

import '../theme/theme_manager.dart';

class UnComplete extends StatefulWidget {
  const UnComplete({super.key});

  @override
  State<UnComplete> createState() => _UnCompleteState();
}

class _UnCompleteState extends State<UnComplete> {
  List<TaskModel> incompletedTasks = [];
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final currentDate = DateTime.now();
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: ClipPath(
              clipper: MyCustomClipper(),
              child: Container(
                height: 500,
                width: double.infinity,
                color: themeManager.mainContainerBack,
              ),
            ),
          ),
          Positioned(
            child: ClipPath(
              clipper: MyCustomClipper1(),
              child: Container(
                height: 450,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: themeManager.primaryColorGradient
                   ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 70,
              ),
              Image.asset('asset/PngItem_1022533.png',height: 50,),
                  Text("Inomplete Tasks",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w200),),
              Builder(builder: (context) {
          return ValueListenableBuilder(
            valueListenable: taskListNotifier,
            builder:
                (BuildContext ctx, List<TaskModel> todolist, Widget? child) {
              final incompleteTasks =
                  todolist.where((task) => !task.tasComplete).toList();
              return Expanded(
                child: ListView.builder(
                  itemCount: incompleteTasks.length,
                  itemBuilder: (context, index) {
                    final data = incompleteTasks[index];
                    return Container(
                      width: 200,
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: themeManager.incompletedTaskColors,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
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
                                ),
                              ),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${DateFormat('MM/dd/yyyy').format(data.date)}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    if (data.description != null &&
                                        data.description.isNotEmpty)
                                      Text(
                                        '${data.description}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                  ],
                                ),
                              leading: CustomCheckbox(
                                value: data.tasComplete,
                                onChanged: (newvalue) {
                                  if (newvalue!=true) {                                  
                                      addtask(data);
                                  }
                                },
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
        }),
            ],
          ),
        ],
      ),
    );
  }
}
