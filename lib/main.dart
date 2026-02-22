import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'design/app_theme.dart';
import 'features/auth/auth_notifier.dart';
import 'repositories/auth_repository.dart';
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
  late final AuthRepository _authRepo;
  late final AuthNotifier _authNotifier;

  @override
  void initState() {
    super.initState();
    _authRepo = AuthRepository(Supabase.instance.client);
    _authNotifier = AuthNotifier(_authRepo);
  }

  @override
  void dispose() {
    _authNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My App', // TODO: Replace with your app name
      theme: AppTheme.light,
      routerConfig: buildRouter(authNotifier: _authNotifier),
      debugShowCheckedModeBanner: false,
    );
  }
}