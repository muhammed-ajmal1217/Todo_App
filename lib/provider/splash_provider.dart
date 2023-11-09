import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier{
  bool isLoading = true;
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}