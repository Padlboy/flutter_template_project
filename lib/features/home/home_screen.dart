import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../design/app_colors.dart';
import '../../features/auth/auth_notifier.dart';
import '../../features/recipes/recipe_notifier.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_spinner.dart';
import '../../widgets/recipe_card.dart';

/// Home screen showing the user's recipe feed.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.authNotifier,
    required this.recipeListNotifier,
  });

  final AuthNotifier authNotifier;
  final RecipeListNotifier recipeListNotifier;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.recipeListNotifier.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All About Snacks'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
            tooltip: 'Search',
          ),
        ],
      ),
      drawer: AppDrawer(authNotifier: widget.authNotifier),
      body: ListenableBuilder(
        listenable: widget.recipeListNotifier,
        builder: (context, _) {
          if (widget.recipeListNotifier.isLoading) {
            return const LoadingSpinner();
          }

          final error = widget.recipeListNotifier.errorMessage;
          if (error != null) {
            return _ErrorView(message: error, onRetry: widget.recipeListNotifier.load);
          }

          final recipes = widget.recipeListNotifier.recipes;
          if (recipes.isEmpty) {
            return EmptyState(
              icon: Icons.cookie_outlined,
              message: 'No snack recipes yet.\nAdd your first one!',
              actionLabel: 'Add Recipe',
              onAction: () => context.go('/recipes/new'),
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: widget.recipeListNotifier.load,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              itemCount: recipes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) {
                final recipe = recipes[i];
                return RecipeCard(
                  recipe: recipe,
                  onTap: () => context.go('/recipes/${recipe.id}'),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/recipes/new'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        tooltip: 'Add Recipe',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
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
