import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../design/app_colors.dart';
import '../../features/auth/auth_notifier.dart';
import '../../features/categories/category_notifier.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/category_list_tile.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_spinner.dart';
import 'category_edit_dialog.dart';

/// Screen that lists all recipe categories.
class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({
    super.key,
    required this.authNotifier,
    required this.categoryNotifier,
  });

  final AuthNotifier authNotifier;
  final CategoryNotifier categoryNotifier;

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  void initState() {
    super.initState();
    widget.categoryNotifier.load();
  }

  Future<void> _showAddDialog() async {
    final name = await showCategoryEditDialog(context);
    if (name != null && name.isNotEmpty) {
      await widget.categoryNotifier.add(name);
    }
  }

  Future<void> _showEditDialog(String id, String currentName) async {
    final name = await showCategoryEditDialog(context, initialName: currentName);
    if (name != null && name.isNotEmpty) {
      await widget.categoryNotifier.edit(id, name);
    }
  }

  Future<void> _confirmDelete(String id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Delete "$name"? Recipes in this category will not be deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.categoryNotifier.remove(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      drawer: AppDrawer(authNotifier: widget.authNotifier),
      body: ListenableBuilder(
        listenable: widget.categoryNotifier,
        builder: (context, _) {
          if (widget.categoryNotifier.isLoading) {
            return const LoadingSpinner();
          }

          final categories = widget.categoryNotifier.categories;
          if (categories.isEmpty) {
            return EmptyState(
              icon: Icons.category_outlined,
              message: 'No categories yet.\nCreate one to organise your recipes.',
              actionLabel: 'Add Category',
              onAction: _showAddDialog,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final cat = categories[i];
              return CategoryListTile(
                category: cat,
                onTap: () => context.go('/categories/${cat.id}'),
                onEdit: () => _showEditDialog(cat.id, cat.name),
                onDelete: () => _confirmDelete(cat.id, cat.name),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        tooltip: 'Add Category',
        child: const Icon(Icons.add),
      ),
    );
  }
}
