import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static const String _savePathKey = 'SAVEPATHKEY';
  static const String _templatePathKey = 'TEMPLATEPATHKEY';
  static const String _templateNameKey = 'TEMPLATENAMEKEY';
  static const String _lastThemeKey = 'LASTTHEMEKEY';

  static Future<bool> saveSavePath(String savePath) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(_savePathKey, savePath);
  }

  static Future<String?> getSavePath() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(_savePathKey);
  }

  static Future<bool> saveTemplatePath(String templatePath) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(_templatePathKey, templatePath);
  }

  static Future<String?> getTemplatePath() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    final string = sf.getString(_templatePathKey);
    return string?.isNotEmpty ?? false ? string : null;
  }

  static Future<bool> saveTemplateName(String? templateName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(_templateNameKey, templateName ?? '');
  }

  static Future<String?> getTemplateName() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    final string = sf.getString(_templateNameKey);
    return string?.isNotEmpty ?? false ? string : null;
  }

  static Future<bool> saveLastTheme(bool isDark) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(_lastThemeKey, isDark);
  }

  static Future<bool?> getLastTheme() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(_lastThemeKey);
  }

  
}
