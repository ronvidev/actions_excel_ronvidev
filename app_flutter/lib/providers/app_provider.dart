import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  int _pageSelected = 0;

  int get pageSelected => _pageSelected;

  void setPageSelected(int indexPage) {
    _pageSelected = indexPage;
    notifyListeners();
  }
}