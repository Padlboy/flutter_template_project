# Implementation Guide: All About Snacks Flutter App

This guide tells the coding agent exactly what to build for each screen, in which order, and how to connect them.

**Design spec:** [`design-spec.md`](./design-spec.md)  
**Design tokens:** `recipe_manager/lib/design/`

---

## Prerequisites

Run once before implementing screens:

```bash
cd recipe_manager
flutter pub get
```

The `google_fonts` package (needed for Fraunces) is already added to [pubspec.yaml](../../recipe_manager/pubspec.yaml).  
`AppTheme.light` is already wired into [main.dart](../../recipe_manager/lib/main.dart).

---

## Implementation Order

| # | Screen / Widget | File to create | Depends on |
|---|----------------|----------------|------------|
| 1 | RecipeCard widget | `lib/widgets/recipe_card.dart` | AppColors, AppTypography, AppSpacing |
| 2 | AppBar widget | `lib/widgets/snack_app_bar.dart` | AppColors |
| 3 | BottomBar + FAB | `lib/widgets/snack_bottom_bar.dart` | AppColors |
| 4 | Home Screen | `lib/screens/home/home_screen.dart` | RecipeCard, AppBar, BottomBar |
| 5 | Navigation Drawer | `lib/screens/menu/menu_drawer.dart` | AppTypography, AppColors |
| 6 | Category List Screen | `lib/screens/categories/category_list_screen.dart` | CategoryListTile |
| 7 | CategoryListTile | `lib/widgets/category_list_tile.dart` | AppColors, AppTypography |
| 8 | Category Edit Screen | `lib/screens/categories/category_edit_screen.dart` | AppTypography, AppSpacing |

---

## 1. RecipeCard Widget

**File:** `lib/widgets/recipe_card.dart`

```dart
import 'package:flutter/material.dart';
import '../design/app_colors.dart';
import '../design/app_spacing.dart';
import '../design/app_typography.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: SizedBox(
        width: AppDimensions.recipeCardWidth,
        height: AppDimensions.recipeCardHeight,
        child: Stack(
          children: [
            // ── Image ──────────────────────────────────────────────────────
            Positioned(
              top: 0, left: 0, right: 0,
              height: AppDimensions.recipeCardImageHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
            ),
            // ── Label ──────────────────────────────────────────────────────
            Positioned(
              top: AppDimensions.recipeCardImageHeight,
              left: 0, right: 0,
              height: AppDimensions.recipeCardLabelHeight,
              child: ColoredBox(
                color: AppColors.surface,
                child: Center(
                  child: Text(title, style: AppTypography.bodyLarge, textAlign: TextAlign.center),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 2. SnackAppBar

**File:** `lib/widgets/snack_app_bar.dart`

```dart
import 'package:flutter/material.dart';
import '../design/app_colors.dart';
import '../design/app_spacing.dart';

class SnackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SnackAppBar({super.key, this.showActions = false});

  final bool showActions;

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.onPrimary),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: Image.asset('assets/images/logo.png', height: 49), // replace with actual logo asset
      centerTitle: true,
      actions: showActions
          ? [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.onPrimary),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.onPrimary),
                onPressed: () {},
              ),
            ]
          : null,
    );
  }
}
```

---

## 3. SnackBottomBar

**File:** `lib/widgets/snack_bottom_bar.dart`

```dart
import 'package:flutter/material.dart';
import '../design/app_colors.dart';
import '../design/app_spacing.dart';

class SnackBottomBar extends StatelessWidget {
  const SnackBottomBar({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.primary,
      height: AppDimensions.bottomBarHeight,
      child: Center(
        child: FloatingActionButton(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.primary,
          onPressed: onAdd,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```

---

## 4. Home Screen

**File:** `lib/screens/home/home_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../../widgets/recipe_card.dart';
import '../../widgets/snack_app_bar.dart';
import '../../widgets/snack_bottom_bar.dart';
import '../../screens/menu/menu_drawer.dart';
import '../../design/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _demoRecipes = [
    ('https://via.placeholder.com/356x292', 'Griechische Joghurt-Bites'),
    ('https://via.placeholder.com/356x292', 'Griechische Joghurt-Bites'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SnackAppBar(showActions: true),
      drawer: const MenuDrawer(),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
        itemCount: _demoRecipes.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, i) => RecipeCard(
          imageUrl: _demoRecipes[i].$1,
          title: _demoRecipes[i].$2,
        ),
      ),
      bottomNavigationBar: SnackBottomBar(onAdd: () {}),
    );
  }
}
```

---

## 5. Navigation Drawer

**File:** `lib/screens/menu/menu_drawer.dart`

```dart
import 'package:flutter/material.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.onBackground),
              borderRadius: BorderRadius.circular(AppRadius.panel),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar placeholder
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppRadius.chip),
                    ),
                    child: const SizedBox(height: 52, width: double.infinity),
                  ),
                ),
                _MenuItem(label: 'Zu den Snacks', onTap: () {}),
                const Divider(),
                _MenuItem(label: 'neuen Snack hinzufügen', onTap: () {}),
                const Divider(),
                _MenuItem(label: 'Einkaufsliste', onTap: () {}),
                const Divider(),
                // Illustration
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Placeholder(), // Replace with Image.asset('assets/images/bear.png')
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppTypography.bodyLarge)),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
```

---

## 6. Category List Screen

**File:** `lib/screens/categories/category_list_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import '../../widgets/category_list_tile.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  static const _categories = ['zu den Snacks!', 'Frühstück', 'Mittagessen', 'Abendessen'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: AppDimensions.categoryPanelWidth,
          height: AppDimensions.categoryPanelHeight,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.onBackground),
            borderRadius: BorderRadius.circular(AppRadius.panel),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (_, i) => CategoryListTile(
                    label: _categories[i],
                    onEdit: () {},
                    onDelete: () {},
                    onTap: () {},
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    minimumSize: const Size(AppDimensions.ctaButtonWidth, AppDimensions.ctaButtonHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                  ),
                  onPressed: () {},
                  child: Text('i will a neue Kategorie', style: AppTypography.bodyLargeOnPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 7. CategoryListTile Widget

**File:** `lib/widgets/category_list_tile.dart`

```dart
import 'package:flutter/material.dart';
import '../design/app_colors.dart';
import '../design/app_spacing.dart';
import '../design/app_typography.dart';

class CategoryListTile extends StatelessWidget {
  const CategoryListTile({
    super.key,
    required this.label,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  final String label;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.categoryListTileHeight,
      child: ListTile(
        leading: CircleAvatar(
          radius: AppDimensions.categoryAvatarSize / 2,
          backgroundColor: AppColors.primary,
        ),
        title: Text(label, style: AppTypography.bodyLarge),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit_outlined), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
```

---

## 8. Category Edit Screen

**File:** `lib/screens/categories/category_edit_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';

class CategoryEditScreen extends StatelessWidget {
  const CategoryEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: AppDimensions.categoryPanelWidth,
          height: AppDimensions.categoryPanelHeight,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.panel),
          ),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Titel der Kategorie', style: AppTypography.bodyMedium),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.chip)),
                ),
                style: AppTypography.displayLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Kategorie Icon', style: AppTypography.bodyMedium),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.surfaceVariant),
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  child: const Center(child: Icon(Icons.image_outlined, size: 42)),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CtaButton(
                    label: 'jas das passt so',
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  _CtaButton(
                    label: 'nas i will zurück',
                    onPressed: () => Navigator.of(context).pop(false),
                    outlined: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.label, required this.onPressed, this.outlined = false});

  final String label;
  final VoidCallback onPressed;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.button),
    );
    return outlined
        ? OutlinedButton(
            onPressed: onPressed, style: OutlinedButton.styleFrom(shape: shape),
            child: Text(label, style: AppTypography.bodyMedium),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: shape,
              minimumSize: const Size(AppDimensions.ctaButtonWidth, AppDimensions.ctaButtonHeight),
            ),
            child: Text(label, style: AppTypography.bodyLargeOnPrimary),
          );
  }
}
```

---

## Wiring screens into main.dart

Update `lib/main.dart` home to `HomeScreen()`:

```dart
import 'screens/home/home_screen.dart';

// ...
home: const HomeScreen(),
```

---

## Assets (to be added)

Place these files in `recipe_manager/assets/images/` and register under `flutter.assets` in pubspec.yaml:

| Asset file          | Usage |
|---------------------|-------|
| `logo.png`          | AppBar center logo ("All About Snacks" with cupcake icon) |
| `bear.png`          | MenuDrawer bottom illustration |

---

## Outstanding Questions for the User

1. **Logo asset** — Does the repo include the "All About Snacks" logo SVG/PNG, or should it be exported from Figma manually?
2. **Bear illustration** — Same question for the bear image in the menu drawer.
3. **Data layer** — Should recipe/category data come from Supabase, local SQLite, or a mock list for now?
4. **Navigation** — Use Flutter built-in `Navigator`, or add `go_router` for named routes?
