import 'package:flutter/foundation.dart' hide Category;

import '../../models/category.dart';
import '../../repositories/category_repository.dart';

/// Manages category list state.
class CategoryNotifier extends ChangeNotifier {
  CategoryNotifier(this._repo);

  final CategoryRepository _repo;

  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _setLoading(true);
    try {
      _categories = await _repo.fetchAll();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> add(String name) async {
    final category = await _repo.create(name);
    _categories = [..._categories, category];
    notifyListeners();
  }

  Future<void> edit(String id, String name) async {
    final updated = await _repo.update(id, name);
    _categories = _categories
        .map((c) => c.id == id ? updated : c)
        .toList();
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await _repo.delete(id);
    _categories = _categories.where((c) => c.id != id).toList();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
