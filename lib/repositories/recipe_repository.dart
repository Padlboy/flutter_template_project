import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/ingredient.dart';
import '../models/recipe.dart';

/// Handles all database operations for [Recipe], [Ingredient], and instructions.
class RecipeRepository {
  RecipeRepository(this._client);

  final SupabaseClient _client;

  /// Fetches all recipes for the current user, without nested details.
  Future<List<Recipe>> fetchAll({String? categoryId}) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return [];

      var query = _client
          .from('recipes')
          .select()
          .eq('user_id', userId);

      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }

      final data = await query.order('created_at', ascending: false);

      return data
          .map((e) => Recipe.fromJson(e))
          .toList();
    } catch (e, s) {
      developer.log(
        'RecipeRepository.fetchAll failed',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Fetches a single recipe with its ingredients and instructions.
  Future<Recipe> fetchById(String id) async {
    final recipeData = await _client
        .from('recipes')
        .select()
        .eq('id', id)
        .single();

    final ingredientData = await _client
        .from('ingredients')
        .select()
        .eq('recipe_id', id)
        .order('sort_order');

    final instructionData = await _client
        .from('instructions')
        .select()
        .eq('recipe_id', id)
        .order('step_number');

    final ingredients = ingredientData
        .map((e) => Ingredient.fromJson(e))
        .toList();

    final instructions = instructionData
        .map((e) => e['text'] as String)
        .toList();

    return Recipe.fromJson({
      ...recipeData,
      'ingredients': ingredientData,
      'instructions': instructionData,
    }).copyWith(
      ingredients: ingredients,
      instructions: instructions,
    );
  }

  /// Creates a new recipe together with its ingredients and instructions.
  Future<Recipe> create({
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
    final recipeData = await _client
        .from('recipes')
        .insert({
          'title': title,
          'user_id': userId,
          'description': description,
          'image_url': imageUrl,
          'category_id': categoryId,
          'servings': servings,
          'prep_minutes': prepMinutes,
        })
        .select()
        .single();

    final recipeId = recipeData['id'] as String;

    if (ingredients.isNotEmpty) {
      await _client.from('ingredients').insert(
            ingredients
                .asMap()
                .entries
                .map(
                  (e) => {
                    ...e.value.copyWith(recipeId: recipeId).toJson(),
                    'sort_order': e.key,
                  },
                )
                .toList(),
          );
    }

    if (instructions.isNotEmpty) {
      await _client.from('instructions').insert(
            instructions
                .asMap()
                .entries
                .map(
                  (e) => {
                    'recipe_id': recipeId,
                    'step_number': e.key + 1,
                    'text': e.value,
                  },
                )
                .toList(),
          );
    }

    return fetchById(recipeId);
  }

  /// Updates a recipe and replaces its ingredients and instructions.
  Future<Recipe> update({
    required String id,
    required String title,
    String description = '',
    String? imageUrl,
    String? categoryId,
    int servings = 1,
    int prepMinutes = 0,
    List<Ingredient> ingredients = const [],
    List<String> instructions = const [],
  }) async {
    await _client.from('recipes').update({
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'category_id': categoryId,
      'servings': servings,
      'prep_minutes': prepMinutes,
    }).eq('id', id);

    await _client.from('ingredients').delete().eq('recipe_id', id);
    await _client.from('instructions').delete().eq('recipe_id', id);

    if (ingredients.isNotEmpty) {
      await _client.from('ingredients').insert(
            ingredients
                .asMap()
                .entries
                .map(
                  (e) => {
                    ...e.value.copyWith(recipeId: id).toJson(),
                    'sort_order': e.key,
                  },
                )
                .toList(),
          );
    }

    if (instructions.isNotEmpty) {
      await _client.from('instructions').insert(
            instructions
                .asMap()
                .entries
                .map(
                  (e) => {
                    'recipe_id': id,
                    'step_number': e.key + 1,
                    'text': e.value,
                  },
                )
                .toList(),
          );
    }

    return fetchById(id);
  }

  /// Deletes a recipe and its related data.
  Future<void> delete(String id) async {
    await _client.from('recipes').delete().eq('id', id);
  }
}
