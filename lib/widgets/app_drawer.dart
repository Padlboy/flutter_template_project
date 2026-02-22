import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../design/app_colors.dart';
import '../../features/auth/auth_notifier.dart';

/// The app's side navigation drawer.
///
/// Add your app-specific navigation items by adding [_DrawerItem] entries
/// in the [Column] below.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.authNotifier});

  final AuthNotifier authNotifier;

  @override
  Widget build(BuildContext context) {
    final user = authNotifier.currentUser;

    return Drawer(
      child: Column(
        children: [
          _DrawerHeader(email: user?.email ?? ''),
          const SizedBox(height: 8),
          _DrawerItem(
            icon: Icons.home_outlined,
            label: 'Home',
            onTap: () {
              context.go('/');
              Navigator.of(context).pop();
            },
          ),
          // TODO: Add your app-specific navigation items here.
          const Spacer(),
          const Divider(),
          _DrawerItem(
            icon: Icons.logout,
            label: 'Sign Out',
            iconColor: AppColors.error,
            onTap: () async {
              Navigator.of(context).pop();
              await authNotifier.signOut();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(color: AppColors.primary),
      accountName: const Text(
        'My App', // TODO: Replace with your app name
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      accountEmail: Text(email),
      currentAccountPicture: const CircleAvatar(
        backgroundColor: AppColors.surface,
        child: Icon(Icons.person_outline, color: AppColors.primary, size: 36),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(label),
      onTap: onTap,
    );
  }
}
