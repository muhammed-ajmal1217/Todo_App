import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist1/model/data_model.dart';
import 'package:todolist1/views/login.dart';

class ResetProvider extends ChangeNotifier{
    void resetApp(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    notifyListeners();
    final taskbox = Hive.box<TaskModel>('task_db');
    await taskbox.clear();
    notifyListeners();
    final pictureBox = Hive.box('profile_picture_box');
    await pictureBox.clear();
    notifyListeners();
    final nameBox = Hive.box('username_box');
    await nameBox.clear();
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx)=>const LoginPage()), (route) => false);
    notifyListeners();
  }
}