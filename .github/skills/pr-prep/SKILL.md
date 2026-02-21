---
name: pr-prep
description: Prepare current work for PR - verify tests and cleanup code before creating a pull request
---

# Prepare Current Work for PR: Verify Tests Passing and Cleanup

**Objective:** Verify the current test suite status with `flutter test`, clean up any temporary modifications, and harden test coverage for active files.

## Instructions

### 1. Baseline: Establish Current State
- Run `dart fix --apply` to apply automated fixes
- Run `flutter analyze` to ensure no analysis issues
- Run `flutter test` to establish the current passing state
- Run `flutter test integration_test/app_test.dart` to verify integration integrity (if integration tests exist)

### 2. Fix Failures
If there are any test failures or analysis errors:
- Investigate and resolve them systematically
- Prioritize fixing code over deleting tests
- Ensure all failures are resolved before proceeding

### 3. Cleanup Code

Review any currently modified files using `git status` or check the diff. Remove any:
- `print` / `debugPrint` statements
- Unused imports
- Commented-out code blocks
- Temporary "hack" fixes that should be replaced with proper solutions
- Unused variables or functions

Use MCP tools:
- `dart_fix --apply` to auto-fix issues
- `dart_format` to format code
- `analyze_files` to verify no issues remain

### 4. Verify & Expand Test Coverage

For the files you touched or cleaned up:
- Check if there are obvious edge cases missing from their unit tests
- Add tests to cover these cases:
  - Null inputs and boundary values
  - Error conditions and exception paths
  - Branch coverage (if/else paths)
- Run `flutter analyze` again to ensure clean code
- Run `flutter test` again to ensure cleanup didn't break anything
- Repeat this step as necessary

### 5. Report & Review

**Summarize the cleanup status**, for example:
- "Tests passing, removed 3 debug prints and 2 commented code blocks"
- "Added 4 new unit tests for edge cases in UserModel"
- "Fixed 2 analysis warnings regarding unused imports"

**Action:** Ask the user to review the changes closely to ensure no intended code was accidentally removed.

**Do not commit or push** - let the user review changes first.

**Provide a suggested Git commit message**, for example:
- "Prepare for PR: Fix tests and remove debug code"
- "Cleanup: Remove debug prints and add edge case tests"

## Use Case

This skill is perfect when:
- You have made several changes and want to prepare for a PR
- You want to ensure all tests pass before submitting
- You want to clean up debug code and temporary fixes
- You want to improve test coverage on modified files
- You want a final verification before code review

## MCP Tools Used

- `analyze_files` - Check for analysis issues
- `dart_fix` - Apply automated fixes
- `dart_format` - Format code
- `run_tests` - Execute test suite
