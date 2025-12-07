class RoomType {
  final String id;
  final String name;
  final String description;
  final int capacity;
  final String imageUrl;
  final List<String> amenities;

  RoomType({
    required this.id,
    required this.name,
    required this.description,
    required this.capacity,
    this.imageUrl = '',
    this.amenities = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'capacity': capacity,
    'imageUrl': imageUrl,
    'amenities': amenities,
  };

  factory RoomType.fromJson(Map<String, dynamic> json) => RoomType(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    capacity: json['capacity'] ?? 1,
    imageUrl: json['imageUrl'] ?? '',
    amenities: List<String>.from(json['amenities'] ?? []),
  );
}
