import 'package:flutter/material.dart';
import 'package:todolist1/views/chart.dart';
import 'package:todolist1/views/completed_page.dart';
import 'package:todolist1/views/home_page.dart';
import 'package:todolist1/views/in_complete.dart';

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
    notifyListeners();
  }

  void navigateToPage(int index) {
    selectIndex = index;
    currentScreen = widgetOptions[index];
    notifyListeners();
  }
}