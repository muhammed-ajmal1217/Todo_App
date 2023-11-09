import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todolist1/db_functions/db_functions.dart';
import 'package:todolist1/model/data_model.dart';
import 'package:todolist1/theme/theme_manager_provider.dart';
import 'package:todolist1/widget_pages/checkbox_change.dart';
import 'package:todolist1/widget_pages/custom_container.dart';

// ignore: must_be_immutable
class UnComplete extends StatelessWidget {
   UnComplete({super.key});
  List<TaskModel> incompletedTasks = [];
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    // final currentDate = DateTime.now();
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
              const SizedBox(
                height: 70,
              ),
              Image.asset('asset/PngItem_1022533.png',height: 50,),
                  const Text("Inomplete Tasks",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w200),),
              Builder(builder: (context) {
          return Consumer<dbProvider>(
            builder:
                (context, db, child){
              final incompleteTasks =
                  db.filteredTasks.where((task) => !task.tasComplete).toList();
              return Expanded(
                child: ListView.builder(
                  itemCount: incompleteTasks.length,
                  itemBuilder: (context, index) {
                    final data = incompleteTasks[index];
                    return SizedBox(
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
                            child: SingleChildScrollView(
                              child: ListTile(
                                title: Text(
                                  data.taskName,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('MM/dd/yyyy').format(data.date),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      if (data.description.isNotEmpty)
                                        Text(
                                          data.description,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                    ],
                                  ),
                                leading: CustomCheckbox(
                                  value: data.tasComplete,
                                  onChanged: (newvalue) {
                                    if (newvalue!=true) {                                  
                                        db.addtask(data);
                                    }
                                  },
                                ),
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
