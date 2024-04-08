import 'package:autocells/models/slot_model.dart';

class Sheet {
  final String nameSheet;
  final List<Slot> slots;

  Sheet({
    required this.nameSheet,
    required this.slots,
  });

  factory Sheet.fromJson(Map<String, dynamic> json) => Sheet(
        nameSheet: json['nameSheet'] ?? '',
        slots: List.from(json['slots']).map((e) => Slot.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'nameSheet': nameSheet,
        'slots': slots.map((e) => e.toJson()).toList(),
      };
}
