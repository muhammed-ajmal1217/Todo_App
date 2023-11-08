import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist1/controller.dart/task_utils.dart';
import 'package:todolist1/model/data_model.dart';


  enum FilterCriteria {
  Daily,
  Weekly,
  Monthly,
  All,
}

// ignore: camel_case_types
class dbProvider extends ChangeNotifier{
  List <TaskModel> filteredTasks=[];
  List <TaskModel> todolist=[];
  FilterCriteria selectedFilter = FilterCriteria.All;
  Future<void> addtask(TaskModel value) async {
  final taskDb = await Hive.openBox<TaskModel>('task_db');
  await taskDb.add(value);
  filteredTasks.add(value);
  notifyListeners();
}
Future<List<TaskModel>> getAlltasks() async {
  final taskDb = await Hive.openBox<TaskModel>('task_db');
  final tasks = taskDb.values.toList();
  filteredTasks = tasks;
  notifyListeners();
  return tasks;
}

 Future<void> deleteTask(int index) async {
  final taskDb = await Hive.openBox<TaskModel>('task_db');
  await taskDb.deleteAt(index);
  filteredTasks.removeAt(index); 
  notifyListeners();
}
Future<void> updateTask(int index, TaskModel updatedTask) async {
  final taskDb = await Hive.openBox<TaskModel>('task_db');
  await taskDb.putAt(index, updatedTask);
  filteredTasks[index] = updatedTask;
  notifyListeners();
}
  Uint8List? getStoredImage() {
  final profilePictureBox = Hive.box('profile_picture_box');
  final imageBytes = profilePictureBox.get('profile_image');
  return imageBytes as Uint8List?;
}
  void storeImageInHive(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final profilePictureBox = Hive.box('profile_picture_box');
    await profilePictureBox.put('profile_image', imageBytes);
    notifyListeners();
}
void deleteStoredImage() async {
  final profilePictureBox = Hive.box('profile_picture_box');
  if (profilePictureBox.containsKey('profile_image')) {
    await profilePictureBox.delete('profile_image');
  }
  notifyListeners();
}

  filter(String term){
    final filteredBySearch = term.isEmpty
        ? todolist
        : todolist
            .where((task) =>
                task.taskName.toLowerCase().contains(term.toLowerCase()))
            .toList();
          notifyListeners();

             final filteredByCriteria =
        filterTasksByCriteria(filteredBySearch, selectedFilter, term);
     filteredTasks = filteredByCriteria;
     notifyListeners();
  }
      void checkBoxchanged(bool? value, int index) async {
      final taskDb = Hive.box<TaskModel>('task_db');
      final task = taskDb.getAt(index);
      if (task != null) {
        task.tasComplete = value ?? false;
        taskDb.putAt(index, task);
      }
      notifyListeners();
   
  }

}


