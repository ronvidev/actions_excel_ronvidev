import 'dart:io';
import 'dart:convert';
import 'package:app_flutter/constants.dart';
import 'package:app_flutter/models/data_model.dart';
import 'package:flutter/material.dart';

class InsertImageProvider extends ChangeNotifier {
  late Data data;
  final pageController = PageController();
  int _sheetSelected = 0;

  int get sheetSelected => _sheetSelected;

  void setSheetSelected(int indexSheet) {
    _sheetSelected = indexSheet;
    pageController.jumpToPage(indexSheet);
    notifyListeners();
  }

  Future<void> insertPhoto(int indexSlot, String photoPath) async {
    data.sheets[_sheetSelected].slots[indexSlot].photos.add(photoPath);
    await saveJson();
    notifyListeners();
  }

  Future<void> deletePhoto(int indexSlot, String photoPath) async {
    data.sheets[_sheetSelected].slots[indexSlot].photos.remove(photoPath);
    await saveJson();
    notifyListeners();
  }

  Future<void> loadJson() async {
    final file = File(jsonDataPath);
    if (file.existsSync()) {
      final jsonString = await file.readAsString();
      final dataMap = json.decode(jsonString);
      data = Data.fromJson(dataMap);
    }
  }

  Future<void> saveJson() async {
    final dataJson = data.toJson();
    final jsonString = const JsonEncoder.withIndent('  ').convert(dataJson);
    await File(jsonDataPath).writeAsString(jsonString);
  }
}
