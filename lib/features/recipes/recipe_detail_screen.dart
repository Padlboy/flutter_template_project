import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../features/recipes/recipe_notifier.dart';
import '../../models/recipe.dart';
import '../../widgets/loading_spinner.dart';

/// Full-detail view for a single recipe.
class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
    required this.recipeListNotifier,
  });

  final String recipeId;
  final RecipeListNotifier recipeListNotifier;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Recipe? _recipe;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final recipe = await widget.recipeListNotifier.fetchById(widget.recipeId);
      setState(() {
        _recipe = recipe;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const LoadingSpinner()
          : _error != null
              ? _ErrorView(error: _error!, onRetry: _loadRecipe)
              : _RecipeBody(
                  recipe: _recipe!,
                  onEdit: () => context.go('/recipes/${widget.recipeId}/edit'),
                ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeBody extends StatelessWidget {
  const _RecipeBody({required this.recipe, required this.onEdit});

  final Recipe recipe;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              recipe.title,
              style: const TextStyle(
                color: AppColors.onPrimary,
                shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
              ),
            ),
            background: recipe.imageUrl != null
                ? Image.network(
                    recipe.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.primary),
                  )
                : Container(color: AppColors.primary),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
              tooltip: 'Edit Recipe',
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meta chips
                Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    if (recipe.servings > 0)
                      _MetaChip(
                        icon: Icons.people_outline,
                        label: '${recipe.servings} servings',
                      ),
                    if (recipe.prepMinutes > 0)
                      _MetaChip(
                        icon: Icons.timer_outlined,
                        label: '${recipe.prepMinutes} min',
                      ),
                  ],
                ),
                if (recipe.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    recipe.description,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
                if (recipe.ingredients.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xl),
                  Text('Ingredients', style: theme.textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.sm),
                  ...recipe.ingredients.map(
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 4, right: 8),
                            child: Icon(Icons.circle, size: 6, color: AppColors.primary),
                          ),
                          Expanded(child: Text(i.display)),
                        ],
                      ),
                    ),
                  ),
                ],
                if (recipe.instructions.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xl),
                  Text('Instructions', style: theme.textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.sm),
                  ...recipe.instructions.asMap().entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: AppColors.primary,
                                child: Text(
                                  '${e.key + 1}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(e.value, style: theme.textTheme.bodyLarge),
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16, color: AppColors.primary),
      label: Text(label),
      backgroundColor: AppColors.surfaceVariant,
      padding: EdgeInsets.zero,
    );
  }
}
