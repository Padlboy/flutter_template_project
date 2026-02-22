import 'package:flutter/foundation.dart';

import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../repositories/recipe_repository.dart';

/// Manages the recipe list state.
class RecipeListNotifier extends ChangeNotifier {
  RecipeListNotifier(this._repo);

  final RecipeRepository _repo;

  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> load({String? categoryId}) async {
    _setLoading(true);
    try {
      _recipes = await _repo.fetchAll(categoryId: categoryId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> remove(String id) async {
    await _repo.delete(id);
    _recipes = _recipes.where((r) => r.id != id).toList();
    notifyListeners();
  }

  /// Fetches a single recipe with full ingredient and instruction detail.
  Future<Recipe> fetchById(String id) => _repo.fetchById(id);

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

/// Manages the state for creating or editing a single [Recipe].
class RecipeEditNotifier extends ChangeNotifier {
  RecipeEditNotifier(this._repo, {this.existing});

  final RecipeRepository _repo;
  final Recipe? existing;

  bool _isLoading = false;
  String? _errorMessage;
  String? _savedId;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEditing => existing != null;
  /// The id of the recipe that was last saved (set after a successful [save]).
  String? get savedId => _savedId;

  Future<Recipe?> save({
    required String title,
    required String userId,
    String description = '',
    String? imageUrl,
    String? categoryId,
    int servings = 1,
    int prepMinutes = 0,
    List<Ingredient> ingredients = const [],
    List<String> instructions = const [],
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      Recipe? saved;
      if (existing != null) {
        saved = await _repo.update(
          id: existing!.id,
          title: title,
          description: description,
          imageUrl: imageUrl,
          categoryId: categoryId,
          servings: servings,
          prepMinutes: prepMinutes,
          ingredients: ingredients,
          instructions: instructions,
        );
      } else {
        saved = await _repo.create(
          title: title,
          userId: userId,
          description: description,
          imageUrl: imageUrl,
          categoryId: categoryId,
          servings: servings,
          prepMinutes: prepMinutes,
          ingredients: ingredients,
          instructions: instructions,
        );
      }
      _savedId = saved.id;
      return saved;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
