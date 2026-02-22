/// A recipe category such as "Breakfast" or "Snacks".
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.userId,
  });

  final String id;
  final String name;
  final String userId;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as String,
        name: json['name'] as String,
        userId: json['user_id'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'user_id': userId,
      };

  Category copyWith({String? id, String? name, String? userId}) => Category(
        id: id ?? this.id,
        name: name ?? this.name,
        userId: userId ?? this.userId,
      );

  @override
  String toString() => 'Category(id: $id, name: $name)';
}
