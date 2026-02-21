---
name: single-file-test-coverage
description: Write or modify tests for a single file to improve test coverage
---

# Single File Test Coverage Improvement

**Objective:** Write a new test file or modify an existing one to improve coverage for a specific target class or module.

## Instructions

### 1. Identify Target

Choose a single source file (Dart) in `lib/` that has:
- Low or no test coverage
- Suitable logic for unit testing (e.g., utility classes, logic helpers, services)
- Clear responsibilities and dependencies

Avoid selecting files that are primarily UI (widgets) without logic, unless testing specific widget behavior.

### 2. Establish Baseline

- Run `flutter analyze` to ensure the project is valid
- Run `flutter test` to ensure the project is stable
- Run `flutter test --coverage` and check `coverage/lcov.info` to see initial coverage for the target file
- Use MCP tool `analyze_files` to identify any existing issues

### 3. Implement or Update Tests

Create a new test file in `test/` (e.g., `test/unit/models/user_test.dart`) or update an existing one.

Focus on:
- **Edge cases**: null inputs, empty strings, boundary values, extreme numbers
- **Branch coverage**: ensure if/else paths are exercised
- **Error conditions**: test exception handling
- **Normal paths**: test the happy path with valid inputs
- **Mocking dependencies**: use `mockito` or `mocktail` for external dependencies

Example structure:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/domain/models/user.dart';

void main() {
  group('User', () {
    test('creates user with valid inputs', () {
      final user = User(name: 'John', email: 'john@example.com');
      expect(user.name, 'John');
      expect(user.email, 'john@example.com');
    });

    test('throws exception when name is empty', () {
      expect(
        () => User(name: '', email: 'john@example.com'),
        throwsArgumentError,
      );
    });

    // Add more tests for edge cases...
  });
}
```

### 4. Verify & Iterate

- Run tests for the new test file: `flutter test test/unit/models/user_test.dart`
- Ensure all tests pass
- Run `flutter analyze` to ensure no regressions
- If coverage is still low:
  - Analyze missed lines and branches in `coverage/lcov.info`
  - Add targeted test cases for uncovered paths
  - Iterate until sufficient coverage is achieved (aim for >80% for unit tested code)

### 5. Report & Review

**Summarize what was fixed/covered**, for example:
- "Improved coverage for UserModel from 45% to 87%"
- "Added 12 new unit tests covering edge cases: null inputs, empty strings, validation errors"
- "Covered 5 previously untested branches in parseDate() utility function"

**Action:** Ask the user to review the new tests closely to ensure:
- Tests are meaningful and test actual logic
- No test is redundant or testing the same thing twice
- Edge cases are properly covered

**Test Location:** If testing a widget or feature, explicitly state where the user should manually test:
- "The widget is used in the Settings screen, accessible via Settings > Notifications"

**Do not commit or push** - let the user review first.

**Provide a suggested Git commit message**, for example:
- "test: Add unit tests for UserModel (improve coverage from 45% to 87%)"
- "test: Improve coverage for date/time parsing utilities"

## Use Case

This skill is perfect when:
- A module has low or zero test coverage
- You want to improve code quality before a release
- You want to document expected behavior through tests
- You want to catch potential bugs through edge case testing
- You're refactoring and need tests to ensure correctness

## MCP Tools Used

- `analyze_files` - Check for issues
- `run_tests` - Execute specific test file
- `dart_format` - Format test code
- `dart_fix` - Fix test issues
