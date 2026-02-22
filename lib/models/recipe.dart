import 'ingredient.dart';

/// A snack / food recipe with ingredients and step-by-step instructions.
class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.userId,
    this.description = '',
    this.imageUrl,
    this.categoryId,
    this.servings = 1,
    this.prepMinutes = 0,
    this.ingredients = const [],
    this.instructions = const [],
    this.createdAt,
  });

  final String id;
  final String title;
  final String userId;
  final String description;
  final String? imageUrl;
  final String? categoryId;
  final int servings;
  final int prepMinutes;
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final DateTime? createdAt;

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'] as String,
        title: json['title'] as String,
        userId: json['user_id'] as String,
        description: json['description'] as String? ?? '',
        imageUrl: json['image_url'] as String?,
        categoryId: json['category_id'] as String?,
        servings: json['servings'] as int? ?? 1,
        prepMinutes: json['prep_minutes'] as int? ?? 0,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'] as String)
            : null,
        ingredients: (json['ingredients'] as List<dynamic>?)
                ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        instructions: (json['instructions'] as List<dynamic>?)
                ?.map((e) => (e['text'] ?? e) as String)
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'user_id': userId,
        'description': description,
        'image_url': imageUrl,
        'category_id': categoryId,
        'servings': servings,
        'prep_minutes': prepMinutes,
      };

  Recipe copyWith({
    String? id,
    String? title,
    String? userId,
    String? description,
    String? imageUrl,
    String? categoryId,
    int? servings,
    int? prepMinutes,
    List<Ingredient>? ingredients,
    List<String>? instructions,
    DateTime? createdAt,
  }) =>
      Recipe(
        id: id ?? this.id,
        title: title ?? this.title,
        userId: userId ?? this.userId,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        categoryId: categoryId ?? this.categoryId,
        servings: servings ?? this.servings,
        prepMinutes: prepMinutes ?? this.prepMinutes,
        ingredients: ingredients ?? this.ingredients,
        instructions: instructions ?? this.instructions,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  String toString() => 'Recipe(id: $id, title: $title)';
}
