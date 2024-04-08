import 'dart:io';

import 'package:autocells/config/constants.dart';
import 'package:autocells/config/shared.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode? _themeMode;
  int _pageSelected = 0;
  bool _isUpdated = false;
  bool _isUpdating = false;
  String _versionApp = '';
  String _newVersionApp = '';

  int get pageSelected => _pageSelected;
  ThemeMode? get themeMode => _themeMode;
  bool get isUpdated => _isUpdated;
  bool get isUpdating => _isUpdating;
  String get versionApp => _versionApp;
  String get newVersionApp => _newVersionApp;

  void setPageSelected(int indexPage) {
    _pageSelected = indexPage;
    notifyListeners();
  }

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    Shared.saveLastTheme(themeMode == ThemeMode.dark);
    notifyListeners();
  }

  void setUpdated(bool value) {
    _isUpdated = value;
    notifyListeners();
  }

  Future<void> getVersionApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _versionApp = packageInfo.version;
    notifyListeners();
  }

  Future<void> verifyUpdate() async {
    await getVersionApp(); 
    final response = await http.get(Uri.parse(kUriVersion));
    if (response.statusCode == 200) {
      _newVersionApp = response.body;
    }
    _isUpdated = _versionApp == _newVersionApp;
  }

  Future<void> updateApp() async {
    _isUpdating = true;
    notifyListeners();

    final response = await http.get(Uri.parse(kUriInstaller));

    File file = File(updateFilePath);
    await file.writeAsBytes(response.bodyBytes);

    await Process.run(updateFilePath, ['/VERYSILENT']);

    _isUpdating = false;
    notifyListeners();
  }
}
