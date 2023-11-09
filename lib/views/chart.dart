
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist1/controller.dart/chart_controller.dart';
import 'package:todolist1/db_functions/db_functions.dart';

import 'package:todolist1/model/data_model.dart';
import 'package:todolist1/theme/theme_manager_provider.dart';

class Chart extends StatelessWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart'),
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: themeManager.primaryColorGradient,
          ),)),
      body: Column(
        children: [
          Consumer<dbProvider>(
            builder: (context, value, child) => 
             FutureBuilder<List<TaskModel>>(
              future: value.getAlltasks(),
              builder: (context, snapshot) {
                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("'No task's available.'",style: TextStyle(color: Colors.grey,fontSize: 25),));
                } else {
                  int completedTasks =
                      snapshot.data!.where((task) => task.tasComplete).length;
                  int incompletedTasks =
                      snapshot.data!.where((task) => !task.tasComplete).length;
                  int totalTasks = completedTasks + incompletedTasks;
          
                  double completed = (completedTasks / totalTasks) * 100;
                  double incompleted = (incompletedTasks / totalTasks) * 100;
          
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Container(
                        width: 350,
                        height: 350,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: completed,
                                color: themeManager.completedChart,
                                title: '${completed.toStringAsFixed(0)}%',titleStyle: TextStyle(color: Color.fromARGB(255, 31, 150, 20),fontSize: 50,fontWeight: FontWeight.w500),
                                radius: 40, 
                              ),
                              PieChartSectionData(
                                value: incompleted,
                                color: themeManager.incompletedChart,
                                title: '${incompleted.toStringAsFixed(0)}%',titleStyle: TextStyle(color: Color.fromARGB(255, 224, 2, 2),fontSize: 50,fontWeight: FontWeight.w500),
                                radius: 40, 
                              ),
                            ],
                            sectionsSpace: 2,
                            centerSpaceRadius: 90,
                            startDegreeOffset: 90,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          SizedBox(height: 20,),
          chartValues(color: themeManager.completedChart, text: "Completed Task's"),
          SizedBox(height: 40,),
          chartValues(color: themeManager.incompletedChart, text: "Incomplete Task's")
        ],
      ),
    );
  }
}
