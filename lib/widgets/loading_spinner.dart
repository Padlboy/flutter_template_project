import 'package:flutter/material.dart';

import '../design/app_colors.dart';

/// Centered loading indicator using the brand color.
class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }
}
