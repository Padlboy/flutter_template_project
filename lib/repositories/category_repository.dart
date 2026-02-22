import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/category.dart';

/// Handles all database operations for [Category].
class CategoryRepository {
  CategoryRepository(this._client);

  final SupabaseClient _client;

  /// Fetches all categories belonging to the current user.
  Future<List<Category>> fetchAll() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return [];

      final data = await _client
          .from('categories')
          .select()
          .eq('user_id', userId)
          .order('created_at');

      return (data as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, s) {
      developer.log(
        'CategoryRepository.fetchAll failed',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  /// Creates a new category and returns it.
  Future<Category> create(String name) async {
    final userId = _client.auth.currentUser!.id;
    final data = await _client
        .from('categories')
        .insert({'name': name, 'user_id': userId})
        .select()
        .single();
    return Category.fromJson(data);
  }

  /// Updates a category's [name] and returns the updated record.
  Future<Category> update(String id, String name) async {
    final data = await _client
        .from('categories')
        .update({'name': name})
        .eq('id', id)
        .select()
        .single();
    return Category.fromJson(data);
  }

  /// Deletes a category by [id].
  Future<void> delete(String id) async {
    await _client.from('categories').delete().eq('id', id);
  }
}
