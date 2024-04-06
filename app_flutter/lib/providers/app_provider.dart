import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  int _pageSelected = 0;

  int get pageSelected => _pageSelected;
  ThemeMode get themeMode => _themeMode;

  void setPageSelected(int indexPage) {
    _pageSelected = indexPage;
    notifyListeners();
  }

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}