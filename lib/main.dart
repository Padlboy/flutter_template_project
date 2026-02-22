import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'design/app_theme.dart';
import 'features/auth/auth_notifier.dart';
import 'features/categories/category_notifier.dart';
import 'features/recipes/recipe_notifier.dart';
import 'repositories/auth_repository.dart';
import 'repositories/category_repository.dart';
import 'repositories/recipe_repository.dart';
import 'router.dart';
import 'supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SupabaseClient _supabase;
  late final AuthRepository _authRepo;
  late final CategoryRepository _categoryRepo;
  late final RecipeRepository _recipeRepo;
  late final AuthNotifier _authNotifier;
  late final CategoryNotifier _categoryNotifier;
  late final RecipeListNotifier _recipeListNotifier;

  @override
  void initState() {
    super.initState();
    _supabase = Supabase.instance.client;
    _authRepo = AuthRepository(_supabase);
    _categoryRepo = CategoryRepository(_supabase);
    _recipeRepo = RecipeRepository(_supabase);
    _authNotifier = AuthNotifier(_authRepo);
    _categoryNotifier = CategoryNotifier(_categoryRepo);
    _recipeListNotifier = RecipeListNotifier(_recipeRepo);
  }

  @override
  void dispose() {
    _authNotifier.dispose();
    _categoryNotifier.dispose();
    _recipeListNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = buildRouter(
      authNotifier: _authNotifier,
      recipeListNotifier: _recipeListNotifier,
      categoryNotifier: _categoryNotifier,
      recipeRepository: _recipeRepo,
    );

    return MaterialApp.router(
      title: 'All About Snacks',
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}