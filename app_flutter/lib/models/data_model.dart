import 'package:autocells/models/sheet_model.dart';

class Data {
  final List<Sheet> sheets;

  Data({
    required this.sheets,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        sheets: List.from(json['sheets']).map((e) {
          return Sheet.fromJson(e);
        }).toList(),
      );

  Map<String, dynamic> toJson() => {
        'sheets': sheets.map((e) => e.toJson()).toList(),
      };
}
