import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../features/auth/auth_notifier.dart';
import '../../features/categories/category_notifier.dart';
import '../../features/recipes/recipe_notifier.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../widgets/loading_spinner.dart';
import '../../widgets/primary_button.dart';

/// Form screen for creating or editing a recipe.
class RecipeEditScreen extends StatefulWidget {
  const RecipeEditScreen({
    super.key,
    required this.authNotifier,
    required this.recipeEditNotifier,
    required this.categoryNotifier,
    this.existing,
  });

  final AuthNotifier authNotifier;
  final RecipeEditNotifier recipeEditNotifier;
  final CategoryNotifier categoryNotifier;

  /// When non-null, the form is in edit mode.
  final Recipe? existing;

  @override
  State<RecipeEditScreen> createState() => _RecipeEditScreenState();
}

class _RecipeEditScreenState extends State<RecipeEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _imageUrlCtrl;
  late final TextEditingController _servingsCtrl;
  late final TextEditingController _prepCtrl;

  String? _selectedCategoryId;
  List<_IngredientEntry> _ingredients = [];
  List<TextEditingController> _instructions = [];

  @override
  void initState() {
    super.initState();
    final r = widget.existing;
    _titleCtrl = TextEditingController(text: r?.title ?? '');
    _descCtrl = TextEditingController(text: r?.description ?? '');
    _imageUrlCtrl = TextEditingController(text: r?.imageUrl ?? '');
    _servingsCtrl = TextEditingController(text: r?.servings.toString() ?? '');
    _prepCtrl = TextEditingController(text: r?.prepMinutes.toString() ?? '');
    _selectedCategoryId = r?.categoryId;

    _ingredients = r != null
        ? r.ingredients
            .map(
              (i) => _IngredientEntry(
                name: TextEditingController(text: i.name),
                amount: TextEditingController(text: i.amount),
                unit: TextEditingController(text: i.unit),
              ),
            )
            .toList()
        : [_IngredientEntry.empty()];

    _instructions = r != null
        ? r.instructions.map((s) => TextEditingController(text: s)).toList()
        : [TextEditingController()];

    widget.categoryNotifier.load();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _imageUrlCtrl.dispose();
    _servingsCtrl.dispose();
    _prepCtrl.dispose();
    for (final e in _ingredients) {
      e.dispose();
    }
    for (final c in _instructions) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = widget.authNotifier.currentUser?.id ?? '';

    final ingredients = _ingredients
        .where((e) => e.name.text.trim().isNotEmpty)
        .toList();
    final instructions = _instructions
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    await widget.recipeEditNotifier.save(
      userId: userId,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim().isEmpty ? '' : _descCtrl.text.trim(),
      imageUrl: _imageUrlCtrl.text.trim().isEmpty ? null : _imageUrlCtrl.text.trim(),
      categoryId: _selectedCategoryId,
      servings: int.tryParse(_servingsCtrl.text) ?? 1,
      prepMinutes: int.tryParse(_prepCtrl.text) ?? 0,
      ingredients: ingredients
          .map(
            (e) => Ingredient(
              id: '',
              recipeId: widget.existing?.id ?? '',
              name: e.name.text.trim(),
              amount: e.amount.text.trim(),
              unit: e.unit.text.trim(),
              sortOrder: _ingredients.indexOf(e),
            ),
          )
          .toList(),
      instructions: instructions,
    );

    if (!mounted) return;
    if (widget.recipeEditNotifier.errorMessage == null) {
      final savedId = widget.recipeEditNotifier.savedId;
      if (savedId != null) {
        context.go('/recipes/$savedId');
      } else {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Recipe' : 'New Recipe'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: ListenableBuilder(
        listenable: widget.recipeEditNotifier,
        builder: (context, _) {
          if (widget.recipeEditNotifier.isLoading) {
            return const LoadingSpinner();
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                if (widget.recipeEditNotifier.errorMessage != null)
                  _ErrorBanner(message: widget.recipeEditNotifier.errorMessage!),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Recipe Title *'),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _descCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Description (optional)'),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _imageUrlCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Image URL (optional)'),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: AppSpacing.md),
                // Category dropdown
                ListenableBuilder(
                  listenable: widget.categoryNotifier,
                  builder: (context, _) {
                    final categories = widget.categoryNotifier.categories;
                    return DropdownButtonFormField<String>(
                      value: _selectedCategoryId,
                      decoration:
                          const InputDecoration(labelText: 'Category (optional)'),
                      items: [
                        const DropdownMenuItem(
                          child: Text('None'),
                        ),
                        ...categories.map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          ),
                        ),
                      ],
                      onChanged: (v) => setState(() => _selectedCategoryId = v),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _servingsCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Servings'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _prepCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Prep (min)'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
                // Ingredients
                const SizedBox(height: AppSpacing.xl),
                _SectionHeader(
                  title: 'Ingredients',
                  onAdd: () => setState(() => _ingredients.add(_IngredientEntry.empty())),
                ),
                ...List.generate(_ingredients.length, (i) {
                  final entry = _ingredients[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: entry.name,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              isDense: true,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: entry.amount,
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: entry.unit,
                            decoration: const InputDecoration(
                              labelText: 'Unit',
                              isDense: true,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () => setState(() {
                            _ingredients[i].dispose();
                            _ingredients.removeAt(i);
                          }),
                          tooltip: 'Remove',
                        ),
                      ],
                    ),
                  );
                }),
                // Instructions
                const SizedBox(height: AppSpacing.xl),
                _SectionHeader(
                  title: 'Instructions',
                  onAdd: () =>
                      setState(() => _instructions.add(TextEditingController())),
                ),
                ...List.generate(_instructions.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 14, right: 8),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _instructions[i],
                            decoration: InputDecoration(
                              labelText: 'Step ${i + 1}',
                              isDense: true,
                            ),
                            maxLines: 2,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () => setState(() {
                            _instructions[i].dispose();
                            _instructions.removeAt(i);
                          }),
                          tooltip: 'Remove',
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: isEditing ? 'Save Changes' : 'Create Recipe',
                  onPressed: _submit,
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onAdd});

  final String title;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const Spacer(),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add'),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
      ),
    );
  }
}

/// Local helper to manage a set of ingredient form controllers.
class _IngredientEntry {
  _IngredientEntry({
    required this.name,
    required this.amount,
    required this.unit,
  });

  factory _IngredientEntry.empty() => _IngredientEntry(
        name: TextEditingController(),
        amount: TextEditingController(),
        unit: TextEditingController(),
      );

  final TextEditingController name;
  final TextEditingController amount;
  final TextEditingController unit;

  void dispose() {
    name.dispose();
    amount.dispose();
    unit.dispose();
  }
}
