import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todolist/functions/db_functions.dart';
import 'package:todolist/model/data_model.dart';
import 'package:todolist/screens/widget_pages/checkbox_change.dart';
import 'package:todolist/screens/widget_pages/custom_container.dart';
import 'package:todolist/theme/theme_manager.dart';

class Completed extends StatefulWidget {
  const Completed({Key? key}) : super(key: key);

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
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
              Image.asset('asset/pngegg (1).png',height: 50,),
                  Text("Completed Tasks",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w200),),
              Builder(builder: (context) {
                return ValueListenableBuilder(
                  valueListenable: taskListNotifier,
                  builder: (BuildContext ctx, List<TaskModel> todolist,
                      Widget? child) {
                    final completedTasks = todolist.where((task) {
                      return task.tasComplete &&
                          (currentDate.isBefore(task.date) ||
                              currentDate.isAtSameMomentAs(task.date) ||
                              isSameDay(currentDate, task.date));
                    }).toList();

                    return Expanded(
                      child: ListView.builder(
                        itemCount: completedTasks.length,
                        itemBuilder: (context, index) {
                          final data = completedTasks[index];
                          return Container(
                            width: 200,
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: themeManager.completedTaskColors,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 10,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        if (newvalue == true) {
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

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}
