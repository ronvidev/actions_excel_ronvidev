import 'package:flutter/material.dart';

class InsertImageProvider extends ChangeNotifier {
  final pageController = PageController();
  int _sheetSelected = 0;

  int get sheetSelected => _sheetSelected;

  void setSheetSelected(int indexSheet) {
    _sheetSelected = indexSheet;
    pageController.jumpToPage(indexSheet);
    notifyListeners();
  }
}
