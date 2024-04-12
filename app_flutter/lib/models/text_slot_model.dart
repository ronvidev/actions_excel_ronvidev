class TextSlot {
  String title;
  String cell;
  String value;

  TextSlot({
    required this.title,
    required this.cell,
    required this.value,
  });

  factory TextSlot.fromJson(Map<String, dynamic> json) => TextSlot(
        title: json['title'] ?? '',
        cell: json['cell'] ?? '',
        value: json['value'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'cell': cell,
        'value': value,
      };
}
