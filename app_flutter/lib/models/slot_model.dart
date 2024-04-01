class Slot {
  final String name;
  final String cells;
  final List<String> photos;

  Slot({
    required this.name,
    required this.cells,
    required this.photos,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        name: json['name'] ?? '',
        cells: json['cells'] ?? '',
        photos: List<String>.from(json['photos']),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'cells': cells,
        'photos': photos,
      };
}
