import 'dart:io';
import 'dart:convert';
import 'package:app_flutter/config/constants.dart';
import 'package:app_flutter/config/helpers.dart';
import 'package:app_flutter/models/data_model.dart';
import 'package:app_flutter/models/sheet_model.dart';
import 'package:app_flutter/models/slot_model.dart';
import 'package:app_flutter/shared.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class InsertImageProvider extends ChangeNotifier {
  final pageController = PageController();
  Data data = Data(sheets: []);
  String? nameFile;
  List<String> _templates = [];
  String? _savePath;
  String? _templatesPath;
  String? _templateName;

  int _sheetSelected = 0;

  int get sheetSelected => _sheetSelected;
  String? get templatesPath => _templatesPath;
  String? get savePath => _savePath;
  String? get templateName => _templateName;
  List<String> get templates => _templates;

  Future<void> getListTemplates() async {
    if (_templatesPath != null) {
      final directory = Directory(_templatesPath!);
      if (!directory.existsSync()) return;
      final listTemplates = directory.listSync().where((file) {
        return file.path.endsWith('.xlsx');
      }).toList();
      _templates = listTemplates.map((e) {
        return p.basenameWithoutExtension(e.path);
      }).toList();
    }
  }

  Future<void> copyTemplate(String newTemplatePath) async {
    final newTemplateName = p.basenameWithoutExtension(newTemplatePath);
    File(newTemplatePath).copySync("$_templatesPath/$newTemplateName.xlsx");
    templates.add(newTemplateName);
    setTemplateName(newTemplateName);
  }

  Future<void> setTemplateName(String? templateName) async {
    _templateName = templateName;
    Shared.saveTemplateName(templateName);
    loadJson();
    notifyListeners();
  }

  Future<void> setTemplatesPath(String templatesPath) async {
    _templatesPath = templatesPath;
    Shared.saveTemplatePath(templatesPath);
    notifyListeners();
  }

  Future<void> setSavePath(String savePath) async {
    _savePath = savePath;
    Shared.saveSavePath(savePath);
    notifyListeners();
  }

  Future<void> setNameSlot(int indexSlot, String nameSlot) async {
    data.sheets[_sheetSelected].slots[indexSlot].name = nameSlot;
    await saveData();
  }

  Future<void> setCells(int indexSlot, String cells) async {
    data.sheets[_sheetSelected].slots[indexSlot].cells = cells;
    await saveData();
  }

  void setSheetSelected(int indexSheet) {
    _sheetSelected = indexSheet;
    pageController.jumpToPage(indexSheet);
    notifyListeners();
  }

  Future<void> addSheet(Sheet sheet) async {
    data.sheets.add(sheet);
    await saveData();
    notifyListeners();
  }

  Future<void> deleteSheet(Sheet sheet) async {
    data.sheets.remove(sheet);
    await saveData();
    notifyListeners();
  }

  Future<void> addSlot(Slot slot) async {
    data.sheets[_sheetSelected].slots.add(slot);
    await saveData();
    notifyListeners();
  }

  Future<void> deleteSlot(Slot slot) async {
    data.sheets[_sheetSelected].slots.remove(slot);
    await saveData();
    notifyListeners();
  }

  Future<void> insertPhoto(int indexSlot, String photoPath) async {
    data.sheets[_sheetSelected].slots[indexSlot].photos.add(photoPath);
    await saveData();
    notifyListeners();
  }

  Future<void> deletePhoto(int indexSlot, String photoPath) async {
    data.sheets[_sheetSelected].slots[indexSlot].photos.remove(photoPath);
    await saveData();
    notifyListeners();
  }

  Future<void> loadJson() async {
    if (_templateName != null) {
      final jsonPath = "$templatesPath/$_templateName.json";

      final file = File(jsonPath);
      if (file.existsSync()) {
        final jsonString = await file.readAsString();
        final dataMap = json.decode(jsonString);
        data = Data.fromJson(dataMap);
        notifyListeners();
        return;
      }
    }
    data = Data(sheets: []);
    notifyListeners();
  }

  Future<void> loadData() async {
    _templateName = await Shared.getTemplateName();
    _savePath = await Shared.getSavePath();
    _templatesPath = await Shared.getTemplatePath();

    if (_templatesPath == null) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      _templatesPath =
          await createFolder("${documentsDirectory.path}/$docsFolder");
    } else {
      _templatesPath = await createFolder(_templatesPath!);
    }

    await getListTemplates();

    if (!_templates.contains(_templateName)) _templateName = null;

    loadJson();
  }

  Future<void> saveData() async {
    final dataJson = data.toJson();
    final jsonString = const JsonEncoder.withIndent('  ').convert(dataJson);
    if (_templateName != null) {
      await File("$templatesPath/$_templateName.json").writeAsString(jsonString);
    }
  }
}
