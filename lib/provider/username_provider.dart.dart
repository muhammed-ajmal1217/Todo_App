import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
class UsernameProvider extends ChangeNotifier{
  final storedUsername = Hive.box('username_box').get('username');
  String _username = "";
  String get username => _username;

   void usernameFunction(String newUsername){
    if (storedUsername != null) {
          _username=newUsername;
      }
       notifyListeners();
   }
}





