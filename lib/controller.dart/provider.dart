import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist1/model/data_model.dart';
import 'package:todolist1/views/chart.dart';
import 'package:todolist1/views/completed_page.dart';
import 'package:todolist1/views/home_page.dart';
import 'package:todolist1/views/in_complete.dart';
import 'package:todolist1/views/login.dart';
class HomeProvider extends ChangeNotifier{
  final storedUsername = Hive.box('username_box').get('username');
  String _username = "";
  String get username => _username;

   void usernameFunction(String newUsername){
    if (storedUsername != null) {
          _username=newUsername;
      }
      // notifyListeners();
   }
}
class SplashProvider extends ChangeNotifier{
  bool isLoading = true;
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
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

class SearchProvider with ChangeNotifier {
  bool _isSearching = false;
  TextEditingController _controller = TextEditingController();

  bool get isSearching => _isSearching;
  TextEditingController get controller => _controller;

  void searching() {
    _isSearching = !_isSearching;
    notifyListeners();
  }

  
}
class BottomNavigationProvider with ChangeNotifier {
  int selectIndex = 0;

  List<Widget> widgetOptions = [];
  late Widget currentScreen;

  BottomNavigationProvider({required String username}) {
    widgetOptions = [
      HomePage(username: username),
      const Completed(),
      UnComplete(),
      const Chart(),
     ];
    currentScreen = widgetOptions[selectIndex];
  }

  void navigateToPage(int index) {
    selectIndex = index;
    currentScreen = widgetOptions[index];
    notifyListeners();
  }
}
