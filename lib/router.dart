import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/auth_notifier.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/home/home_screen.dart';

/// Builds the app router.
///
/// The auth guard redirects unauthenticated users to the login screen.
/// Add your app-specific routes to [routes] below.
GoRouter buildRouter({required AuthNotifier authNotifier}) {
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
        builder: (context, state) => HomeScreen(authNotifier: authNotifier),
      ),
      // TODO: Add your app-specific routes here.
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Page not found: \${state.uri}'),
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
