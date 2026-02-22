---
name: flutter-unit-testing
description: Guide for writing and running unit tests and widget tests for Flutter/Dart code. Use when adding test coverage to notifiers, repositories, models, or widgets in a Flutter project.
---

# Flutter Unit & Widget Testing

Best-practice guide for the three testing layers in Flutter.

---

## Testing Pyramid

| Layer | Tool | Speed | When to use |
|---|---|---|---|
| **Unit** | `flutter_test` + `mockito` | ⚡ fastest | Notifiers, repositories, models, pure logic |
| **Widget** | `flutter_test` + `WidgetTester` | ⚡ fast | Individual widgets, forms, interactions |
| **Integration / E2E** | Playwright (web) or `integration_test` | 🐢 slow | Full user flows |

---

## Setup

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.12
```

Generate mocks once after adding `@GenerateMocks`:
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Unit Test — ChangeNotifier (Notifier)

```dart
// test/features/recipes/recipe_notifier_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_template_repo/features/recipes/recipe_notifier.dart';
import 'package:flutter_template_repo/repositories/recipe_repository.dart';

import 'recipe_notifier_test.mocks.dart';

@GenerateMocks([RecipeRepository])
void main() {
  late MockRecipeRepository mockRepo;
  late RecipeListNotifier notifier;

  setUp(() {
    mockRepo = MockRecipeRepository();
    notifier = RecipeListNotifier(mockRepo);
  });

  tearDown(() => notifier.dispose());

  test('load() populates recipes list on success', () async {
    final fakeRecipes = [/* ... */];
    when(mockRepo.fetchAll()).thenAnswer((_) async => fakeRecipes);

    await notifier.load();

    expect(notifier.recipes, fakeRecipes);
    expect(notifier.isLoading, false);
    expect(notifier.errorMessage, isNull);
  });

  test('load() sets errorMessage on failure', () async {
    when(mockRepo.fetchAll()).thenThrow(Exception('network error'));

    await notifier.load();

    expect(notifier.recipes, isEmpty);
    expect(notifier.errorMessage, isNotNull);
  });
}
```

---

## Widget Test — Screen

```dart
// test/features/home/home_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
// ...

void main() {
  testWidgets('shows empty state when recipe list is empty', (tester) async {
    final mockNotifier = MockRecipeListNotifier();
    when(mockNotifier.isLoading).thenReturn(false);
    when(mockNotifier.recipes).thenReturn([]);
    when(mockNotifier.errorMessage).thenReturn(null);

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          authNotifier: MockAuthNotifier(),
          recipeListNotifier: mockNotifier,
        ),
      ),
    );

    expect(find.text('No snack recipes yet'), findsOneWidget);
    expect(find.byIcon(Icons.cookie_outlined), findsOneWidget);
  });
}
```

---

## Running Tests

```bash
# All tests
flutter test

# Single file
flutter test test/features/recipes/recipe_notifier_test.dart

# With coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Watch mode (re-runs on file save)
flutter test --watch
```

---

## Test File Locations

```
test/
├── models/
│   ├── recipe_test.dart
│   └── ingredient_test.dart
├── repositories/
│   ├── recipe_repository_test.dart
│   └── category_repository_test.dart
├── features/
│   ├── auth/
│   │   └── auth_notifier_test.dart
│   ├── recipes/
│   │   └── recipe_notifier_test.dart
│   └── categories/
│       └── category_notifier_test.dart
└── widgets/
    ├── recipe_card_test.dart
    └── primary_button_test.dart
```

---

## Key Assertions

```dart
expect(find.text('Save Recipe'), findsOneWidget);
expect(find.byType(CircularProgressIndicator), findsNothing);
expect(find.byIcon(Icons.add), findsOneWidget);

// Tap and re-render
await tester.tap(find.byRole(Role.button, name: 'Save'));
await tester.pumpAndSettle();  // waits for all animations/futures

// Text input
await tester.enterText(find.byType(TextField), 'Nachos');
await tester.pump();
```