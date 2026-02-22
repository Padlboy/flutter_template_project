import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../design/app_colors.dart';
import '../models/recipe.dart';

/// A card showing a recipe photo and title.
class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  final Recipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                offset: Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _RecipeImage(imageUrl: recipe.imageUrl)),
              _RecipeLabel(title: recipe.title, textTheme: textTheme),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeImage extends StatelessWidget {
  const _RecipeImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return const ColoredBox(
        color: AppColors.surfaceVariant,
        child: Center(
          child: Icon(Icons.image_outlined, size: 64, color: AppColors.primary),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, __) => const ColoredBox(
        color: AppColors.surfaceVariant,
        child: Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (_, __, ___) => const ColoredBox(
        color: AppColors.surfaceVariant,
        child: Icon(Icons.broken_image_outlined, size: 64),
      ),
    );
  }
}

class _RecipeLabel extends StatelessWidget {
  const _RecipeLabel({
    required this.title,
    required this.textTheme,
  });

  final String title;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
