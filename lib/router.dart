import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/auth_notifier.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/categories/category_list_screen.dart';
import 'features/home/home_screen.dart';
import 'features/recipes/recipe_detail_screen.dart';
import 'features/recipes/recipe_edit_screen.dart';
import 'features/recipes/recipe_notifier.dart';
import 'models/recipe.dart';
import 'features/categories/category_notifier.dart';
import 'repositories/recipe_repository.dart';

/// Builds the app router wired to the provided notifiers / repositories.
GoRouter buildRouter({
  required AuthNotifier authNotifier,
  required RecipeListNotifier recipeListNotifier,
  required CategoryNotifier categoryNotifier,
  required RecipeRepository recipeRepository,
}) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
      final isAuthPath = state.matchedLocation.startsWith('/auth/');
      if (!isLoggedIn && !isAuthPath) return '/auth/login';
      if (isLoggedIn && isAuthPath) return '/';
      return null;
    },
    routes: [
      // ── Auth ────────────────────────────────────────────────────────────
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => LoginScreen(
          authNotifier: authNotifier,
          onLoggedIn: () => context.go('/'),
          onGoToRegister: () => context.go('/auth/register'),
        ),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => RegisterScreen(
          authNotifier: authNotifier,
          onRegistered: () => context.go('/'),
          onGoToLogin: () => context.go('/auth/login'),
        ),
      ),
      // ── Home ────────────────────────────────────────────────────────────
      GoRoute(
        path: '/',
        builder: (context, state) => HomeScreen(
          authNotifier: authNotifier,
          recipeListNotifier: recipeListNotifier,
        ),
      ),
      // ── Categories ──────────────────────────────────────────────────────
      GoRoute(
        path: '/categories',
        builder: (context, state) => CategoryListScreen(
          authNotifier: authNotifier,
          categoryNotifier: categoryNotifier,
        ),
      ),
      GoRoute(
        path: '/categories/:id',
        builder: (context, state) {
          final categoryId = state.pathParameters['id']!;
          // Reuse the list notifier but filter by category
          recipeListNotifier.load(categoryId: categoryId);
          return HomeScreen(
            authNotifier: authNotifier,
            recipeListNotifier: recipeListNotifier,
          );
        },
      ),
      // ── Recipes ─────────────────────────────────────────────────────────
      GoRoute(
        path: '/recipes/new',
        builder: (context, state) => RecipeEditScreen(
          authNotifier: authNotifier,
          recipeEditNotifier: RecipeEditNotifier(recipeRepository),
          categoryNotifier: categoryNotifier,
        ),
      ),
      GoRoute(
        path: '/recipes/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return RecipeDetailScreen(
            recipeId: id,
            recipeListNotifier: recipeListNotifier,
          );
        },
      ),
      GoRoute(
        path: '/recipes/:id/edit',
        builder: (context, state) {
          final existing = state.extra as Recipe?;
          return RecipeEditScreen(
            authNotifier: authNotifier,
            recipeEditNotifier: RecipeEditNotifier(
              recipeRepository,
              existing: existing,
            ),
            categoryNotifier: categoryNotifier,
            existing: existing,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
