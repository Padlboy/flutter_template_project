import 'package:flutter/material.dart';

import '../../design/app_colors.dart';
import '../../features/auth/auth_notifier.dart';
import '../../widgets/app_drawer.dart';

/// Home screen — the main screen shown to authenticated users.
///
/// Replace or extend this with your app-specific content.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.authNotifier});

  final AuthNotifier authNotifier;

  @override
  Widget build(BuildContext context) {
    final user = authNotifier.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'), // TODO: Replace with your app name
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      drawer: AppDrawer(authNotifier: authNotifier),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.home_outlined, size: 64, color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                'Welcome, ${user?.email ?? 'user'}!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'This is your template home screen.\nReplace this with your app content.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
