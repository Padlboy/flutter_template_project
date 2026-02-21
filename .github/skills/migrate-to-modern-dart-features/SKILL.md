---
name: migrate-to-modern-dart-features
description: Migrate code to modern Dart features (Dart 3+) for improved readability and conciseness
---

# Migrate to Modern Dart Features

**Objective:** Optimize consistency and conciseness by migrating to modern Dart features (Dart 3+).

## Modern Dart Features (Dart 3+)

### 1. Switch Expressions vs If-Else Chains
**Before:**
```dart
String getStatus(int code) {
  if (code == 200) {
    return 'Success';
  } else if (code == 404) {
    return 'Not Found';
  } else if (code == 500) {
    return 'Server Error';
  } else {
    return 'Unknown';
  }
}
```

**After:**
```dart
String getStatus(int code) => switch (code) {
  200 => 'Success',
  404 => 'Not Found',
  500 => 'Server Error',
  _ => 'Unknown',
};
```

### 2. Pattern Matching for Null Checks
**Before:**
```dart
if (user != null) {
  print(user.name);
}
```

**After:**
```dart
if (user case User(:final name)) {
  print(name);
}
```

### 3. Records Instead of Primitive Data Classes
**Before:**
```dart
class Point {
  final double x;
  final double y;
  
  Point(this.x, this.y);
  
  @override
  bool operator ==(Object other) => 
    identical(this, other) ||
    other is Point && x == other.x && y == other.y;
  
  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
```

**After:**
```dart
typedef Point = ({double x, double y});

Point p = (x: 1.0, y: 2.0);
```

### 4. Guard Clauses with Pattern Matching
**Before:**
```dart
String formatDate(DateTime? date) {
  if (date == null) return 'No date';
  return '${date.day}/${date.month}/${date.year}';
}
```

**After:**
```dart
String formatDate(DateTime? date) => switch (date) {
  null => 'No date',
  DateTime(:final day, :final month, :final year) => '$day/$month/$year',
};
```

## Instructions

### 1. Baseline: Verify Project Stability
- Run `flutter test`
- Run `flutter analyze`
- Note the current passing state

### 2. Select Target: Identify One Migration Opportunity

Choose a *single* opportunity from the categories:
- `if-else` chains → `switch` expressions
- Data classes with manual `==`/`hashCode` → `Records`
- Null checks → pattern matching
- Ternary operations → `switch` expressions

**Keep the change extremely small** (max 50 lines total).

### 3. Migrate Code

Apply the modern Dart feature:
- Rewrite the code to use the pattern
- Maintain the same functionality
- Ensure no behavior changes

Use MCP tools:
- `dart_format` - Format the new syntax
- `analyze_files` - Check for issues

### 4. Verify No Regressions

- Run `flutter analyze` - verify no new issues
- Run `flutter test` - ensure all tests still pass
- Specifically run tests that exercise this code path
- Check that behavior is identical

### 5. Report & Review

**Summarize the migration**, for example:
- "Converted 8-line if-else chain in ValidationService.validateEmail() to switch expression"
- "Replaced Point data class with record type, reducing file from 30 lines to 5 lines"
- "Migrated null checks in UserRepository.getUser() to pattern matching"

**Action:** Ask the user to review the changes closely:
- Verify the refactored code is more readable
- Ensure no edge cases were missed

**Test Location:** Explicitly state where in the app the user should go to manually test:
- "Click the Settings button after the app opens to test the migrated validation"
- "The migrated code is used when logging in - test with valid and invalid credentials"

**Do not commit or push** - let the user review first.

**Provide a suggested Git commit message**, for example:
- "refactor: Use switch expression in ValidationService.validateEmail()"
- "refactor: Migrate Point class to record type"
- "refactor: Use pattern matching for null-safe date formatting"

## Use Case

This skill is perfect when:
- You want to modernize an aging codebase incrementally
- You want to improve readability without changing functionality
- You need to reduce boilerplate code
- You're practicing modern Dart patterns
- You want to ensure the team stays current with language features

## Constraints

- **One change at a time**: Keep each migration focused
- **Review-friendly size**: Maximum 50 lines affected
- **No behavior change**: Function must work identically before/after
- **Test coverage**: All affected code must be tested

## Common Patterns to Migrate

| Old Pattern | New Pattern | Benefit |
|-----------|-----------|---------|
| `if-else` chains | `switch` expressions | More concise, pattern matching support |
| `?.` checks | Pattern matching | More explicit, declarative |
| Data classes with `==`/`hashCode` | Records | Less boilerplate, immutable by default |
| Ternary (`? :`) | `switch` expression | More readable for multiple conditions |
| Manual validation | Guard clauses | More declarative |

## MCP Tools Used

- `analyze_files` - Check for issues
- `dart_format` - Format migrated code
- `run_tests` - Verify tests pass
- `dart_fix` - Auto-fix any issues

## Resources

- [Dart Language: Patterns](https://dart.dev/language/patterns)
- [Dart Language: Records](https://dart.dev/language/records)
- [Dart Language: Switch Expressions](https://dart.dev/language/branches#switch-expressions)
