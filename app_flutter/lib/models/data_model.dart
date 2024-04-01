import 'package:app_flutter/models/sheet_model.dart';

class Data {
  final String savePath;
  final String templatePath;
  final List<Sheet> sheets;

  Data({
    required this.savePath,
    required this.templatePath,
    required this.sheets,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        savePath: json['savePath'] ?? '',
        templatePath: json['templatePath'] ?? '',
        sheets:
            List.from(json['sheets']).map((e) => Sheet.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'savePath': savePath,
        'templatePath': templatePath,
        'sheets': sheets.map((e) => e.toJson()).toList(),
      };
}
