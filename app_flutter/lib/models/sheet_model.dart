import 'package:autocells/models/models.dart';

class Sheet {
  String nameSheet;
  final List<TextSlot> textSlots;
  final List<ImageSlot> imageSlots;

  Sheet({
    required this.nameSheet,
    required this.textSlots,
    required this.imageSlots,
  });

  factory Sheet.fromJson(Map<String, dynamic> json) => Sheet(
        nameSheet: json['nameSheet'] ?? '',
        textSlots: List.from(
          List.from(json['textSlots'] ?? []).map((e) => TextSlot.fromJson(e)),
        ),
        imageSlots: List.from(
          List.from(json['imageSlots'] ?? []).map((e) => ImageSlot.fromJson(e)),
        ),
      );

  Map<String, dynamic> toJson() => {
        'nameSheet': nameSheet,
        'textSlots': textSlots.map((e) => e.toJson()).toList(),
        'imageSlots': imageSlots.map((e) => e.toJson()).toList(),
      };
}
