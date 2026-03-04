class Area {
  final int? id;
  final String name;

  Area({this.id, required this.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  factory Area.fromMap(Map<String, dynamic> map) =>
      Area(id: map['id'], name: map['name']);

  Area copyWith({int? id, String? name}) =>
      Area(id: id ?? this.id, name: name ?? this.name);
}
