import 'package:flutter/material.dart';

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