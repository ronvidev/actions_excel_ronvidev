class ImageSlot {
  String name;
  String cells;
  final List<String> photos;

  ImageSlot({
    required this.name,
    required this.cells,
    required this.photos,
  });

  factory ImageSlot.fromJson(Map<String, dynamic> json) => ImageSlot(
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
