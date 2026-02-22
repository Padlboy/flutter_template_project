/// A single ingredient belonging to a [Recipe].
class Ingredient {
  const Ingredient({
    required this.id,
    required this.recipeId,
    required this.name,
    this.amount = '',
    this.unit = '',
    this.sortOrder = 0,
  });

  final String id;
  final String recipeId;
  final String name;
  final String amount;
  final String unit;
  final int sortOrder;

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        id: json['id'] as String,
        recipeId: json['recipe_id'] as String,
        name: json['name'] as String,
        amount: json['amount'] as String? ?? '',
        unit: json['unit'] as String? ?? '',
        sortOrder: json['sort_order'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'recipe_id': recipeId,
        'name': name,
        'amount': amount,
        'unit': unit,
        'sort_order': sortOrder,
      };

  /// Display string like "2 cups flour".
  String get display {
    final parts = [if (amount.isNotEmpty) amount, if (unit.isNotEmpty) unit, name];
    return parts.join(' ');
  }

  Ingredient copyWith({
    String? id,
    String? recipeId,
    String? name,
    String? amount,
    String? unit,
    int? sortOrder,
  }) =>
      Ingredient(
        id: id ?? this.id,
        recipeId: recipeId ?? this.recipeId,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        unit: unit ?? this.unit,
        sortOrder: sortOrder ?? this.sortOrder,
      );
}
