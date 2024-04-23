import 'dart:io';
import 'dart:convert';
import 'package:autocells/config/constants.dart';
import 'package:autocells/config/helpers.dart';
import 'package:autocells/models/models.dart';
import 'package:autocells/config/shared.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ExcelTemplateProvider extends ChangeNotifier {
  final pageSheetController = PageController();
  Data data = Data(sheets: []);
  String? nameFile;
  List<String> _templates = [];
  String? _savePath;
  String? _templatesPath;
  String? _templateName;

  int _sheetSelected = 0;
  int _typeSelected = 0;

  int get sheetSelected => _sheetSelected;
  int get typeSelected => _typeSelected;
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
    await loadJson();
    await getSheetNames(templateName);
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

  Future<void> updateNameSlot(int indexSlot, String nameSlot) async {
    data.sheets[_sheetSelected].imageSlots[indexSlot].name = nameSlot;
    await saveData();
  }

  Future<void> updateTextCell(int index, TextSlot textCell) async {
    data.sheets[_sheetSelected].textSlots[index] = textCell;
    await saveData();
    notifyListeners();
  }

  Future<void> updateSlotCells(int indexSlot, String cells) async {
    data.sheets[_sheetSelected].imageSlots[indexSlot].cells = cells;
    await saveData();
  }

  void setSheetSelected(int indexSheet) {
    _sheetSelected = indexSheet;
    pageSheetController.jumpToPage(indexSheet);
    notifyListeners();
  }

  void setTypeSelected(int index) {
    _typeSelected = index;
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

  Future<void> updateSheet(int? index, Sheet? sheet) async {
    if (index != null && sheet != null) {
      data.sheets[index] = sheet;
      await saveData();
      notifyListeners();
    }
  }

  Future<void> addTextCell(TextSlot textCell) async {
    data.sheets[_sheetSelected].textSlots.add(textCell);
    await saveData();
    notifyListeners();
  }

  Future<void> addSlot(ImageSlot slot) async {
    data.sheets[_sheetSelected].imageSlots.add(slot);
    await saveData();
    notifyListeners();
  }

  Future<void> deleteSlot(ImageSlot slot) async {
    data.sheets[_sheetSelected].imageSlots.remove(slot);
    await saveData();
    notifyListeners();
  }

  Future<void> deleteTextCell(TextSlot textCell) async {
    data.sheets[_sheetSelected].textSlots.remove(textCell);
    await saveData();
    notifyListeners();
  }

  Future<void> insertPhoto(int indexSlot, String photoPath) async {
    data.sheets[_sheetSelected].imageSlots[indexSlot].photos.add(photoPath);
    await saveData();
    notifyListeners();
  }

  Future<void> deletePhoto(int indexSlot, String photoPath) async {
    data.sheets[_sheetSelected].imageSlots[indexSlot].photos.remove(photoPath);
    await saveData();
    notifyListeners();
  }

  Future<void> deleteAll() async {
    data.sheets.asMap().forEach((indexSheet, _) {
      data.sheets[indexSheet].imageSlots.asMap().forEach((index, _) {
        data.sheets[indexSheet].imageSlots[index].photos.clear();
      });
      data.sheets[indexSheet].textSlots.asMap().forEach((index, _) {
        data.sheets[indexSheet].textSlots[index].value = '';
      });
    });

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
      _templatesPath = "${documentsDirectory.path}/$templatesFolder";
      _templatesPath = await createFolder(_templatesPath!);
    } else {
      _templatesPath = await createFolder(_templatesPath!);
    }

    await getListTemplates();

    if (_templates.contains(_templateName)) {
      await getSheetNames(_templateName);
    } else {
      _templateName = null;
      await loadJson();
    }    
  }

  Future<void> getSheetNames(String? templateName) async {
    final out = await Process.run(pyExe, [
      getNameSheetsPyPath,
      "$_templatesPath\\$templateName.xlsx",
    ]);

    await loadJson();
    
    final nameSheets = List<String>.from(jsonDecode(out.stdout));
    for (final nameSheet in nameSheets) {
      final sheetsExist = data.sheets.map((e) => e.nameSheet);
      if (!sheetsExist.contains(nameSheet)) {
        data.sheets.add(Sheet(
          nameSheet: nameSheet,
          textSlots: [],
          imageSlots: [],
        ));
      }
    }
  }

  Future<void> saveData() async {
    final dataJson = data.toJson();
    final jsonString = const JsonEncoder.withIndent('  ').convert(dataJson);
    if (_templateName != null) {
      await File("$templatesPath/$_templateName.json")
          .writeAsString(jsonString);
    }
  }
}
