import 'package:flutter/material.dart';

/// Shows a dialog to create or edit a category name.
/// Returns the entered name, or null if cancelled.
Future<String?> showCategoryEditDialog(
  BuildContext context, {
  String? initialName,
}) async {
  final controller = TextEditingController(text: initialName ?? '');
  final isEditing = initialName != null;

  final result = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(isEditing ? 'Edit Category' : 'New Category'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Category Name',
            hintText: 'e.g. Breakfast',
          ),
          textCapitalization: TextCapitalization.sentences,
          onSubmitted: (_) => Navigator.of(context).pop(controller.text.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(isEditing ? 'Save' : 'Create'),
          ),
        ],
      );
    },
  );

  controller.dispose();
  return result;
}
