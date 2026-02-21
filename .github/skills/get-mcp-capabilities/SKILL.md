---
name: get-mcp-capabilities
description: "Get information on what the Flutter MCP server can be used for. Use this skill when working on Flutter apps to understand available MCP tools and which agent skills to deploy."
---

# Flutter MCP Server Capabilities & Agent Skills

This skill provides comprehensive information about the Dart/Flutter MCP server capabilities and guides you on which **Flutter Coding Agent skills** to use for different tasks.

---

## What is the Dart/Flutter MCP Server?

The **Model Context Protocol (MCP) server** for Dart and Flutter exposes advanced development tools to AI agents. It enables agents to:
- Analyze code and fix issues automatically
- Manage project dependencies
- Inspect running applications in real-time
- Execute tests and verify functionality
- Control Flutter apps for testing and documentation

### Prerequisites
- **Dart SDK 3.9+** and **Flutter SDK 3.35+**
- **VS Code** with **Dart extension v3.116+**
- **MCP Server enabled**: `dart.mcpServer: true` in VS Code settings

---

## Available MCP Tools by Category

### 🔍 Code Analysis & Fixes

| Tool | Purpose | When to Use |
|------|---------|-----------|
| `analyze_files` | Analyze project for errors, warnings, and style issues | Before committing code; checking code quality |
| `dart_fix` | Apply automated fixes to code issues | After detecting analysis issues; fixing deprecated APIs |
| `dart_format` | Format code using the Dart formatter | After writing code; cleaning up formatting |
| `resolve_workspace_symbol` | Search for symbols by name (fuzzy matching) | Finding where a class/function is defined; checking usages |

**Use When:**
- Running code quality checks
- Preparing code for PR (use skill: **`pr-prep`**)
- Cleaning up and normalizing code

---

### 📦 Dependency Management

| Tool | Purpose | When to Use |
|------|---------|-----------|
| `pub` | Run pub commands: `get`, `add`, `remove`, `upgrade` | Adding/removing packages; updating dependencies |
| `pub_dev_search` | Search pub.dev for packages with ratings & metadata | Finding suitable packages for features |
| `read_package_uris` | Inspect package structure and dependencies | Understanding what a package provides; checking versions |

**Use When:**
- Adding new functionality requiring external packages
- Updating project dependencies
- Researching package options

---

### ▶️ Runtime Inspection (Debugging & Control)

| Tool | Purpose | Requires |
|------|---------|----------|
| `launch_app` | Start Flutter app with Dart Tooling Daemon | - |
| `connect_dart_tooling_daemon` | Connect to running app for real-time inspection | App launched; DTD URI |
| `get_widget_tree` | Inspect full Flutter widget hierarchy | DTD connected |
| `get_runtime_errors` | Retrieve current runtime errors and logs | DTD connected |
| `get_selected_widget` | Get details of specific selected widget | DTD connected |
| `hot_reload` | Apply code changes without resetting state | App running |
| `hot_restart` | Restart app with full state reset | App running |
| `stop_app` | Kill running Flutter process | App PID |

**Use When:**
- Debugging layout issues (inspect widget tree)
- Testing app behavior during development
- Capturing screenshots (use skill: **`flutter-control-and-screenshot`**)

---

### 🧪 Testing & Execution

| Tool | Purpose | When to Use |
|------|---------|-----------|
| `run_tests` | Execute Dart/Flutter unit and widget tests | Before PR; verifying code changes |
| `flutter_driver_command` | Control app via Flutter Driver (tap, enter text, etc.) | E2E testing; capturing screenshots |

**Use When:**
- Running test suite
- Improving test coverage (use skill: **`single-file-test-coverage`**)
- Automating app control for screenshots

---

## Flutter Coding Agent Skills

The **flutter-coding-agent** has these specialized skills. Choose based on your task:

### 1. 📚 **`load-flutter-instructions`**
**What it does:** Loads Flutter/Dart best practices and coding standards

**When to use:** 
- ✅ Always loaded automatically with the agent
- Use when you need guidance on Flutter architecture, widget patterns, state management, testing practices

**User prompt example:**
> "Create a new screen following Flutter best practices with proper state management"

---

### 2. 🔧 **`flutter-setup-guide-skill`**
**What it does:** Complete setup guide for Flutter environments, MCP servers, and dev containers

**When to use:**
- ✅ Setting up a new Flutter project from scratch
- Configuring dev containers with MCP support
- Understanding available MCP tools and workflows

**User prompt example:**
> "Set up a complete Flutter project with dev container support and MCP server"

---

### 3. ✅ **`pr-prep`**
**What it does:** Prepare code for pull request - verify tests, cleanup code, improve coverage

**What MCP tools it uses:**
- `dart_fix`, `dart_format`, `analyze_files`, `run_tests`

**When to use:**
- ✅ Before submitting a pull request
- Code needs cleanup (debug prints, commented code)
- Want to ensure tests pass and coverage is sufficient

**User prompt example:**
> "Prepare my changes for a PR - verify tests and clean up the code"

**Outcomes:**
- All tests passing
- Code formatted and cleaned
- Improved test coverage
- Git commit message suggestion

---

### 4. 🧪 **`single-file-test-coverage`**
**What it does:** Write or improve tests for a specific file to increase coverage

**What MCP tools it uses:**
- `run_tests`, `analyze_files`, `dart_format`

**When to use:**
- ✅ File has low test coverage
- Want to document expected behavior
- Need to catch edge cases before production
- Improving code reliability

**User prompt example:**
> "Add unit tests for UserRepository with edge case coverage"

**Outcomes:**
- New test file or updated tests
- Coverage improved from X% to Y%
- Edge cases documented and tested

---

### 5. 🚀 **`migrate-to-modern-dart-features`**
**What it does:** Migrate code to modern Dart 3+ features (switch expressions, pattern matching, records)

**What MCP tools it uses:**
- `dart_format`, `analyze_files`, `run_tests`, `dart_fix`

**When to use:**
- ✅ Modernizing legacy code incrementally
- Improving code readability and conciseness
- Reducing boilerplate (if-else chains, data classes)
- Staying current with language features

**User prompt example:**
> "Refactor the ValidationService to use switch expressions instead of if-else chains"

**Constraints:**
- Small, focused changes (max 50 lines)
- No behavior change
- All tests must pass before and after

---

### 6. 🎬 **`flutter-control-and-screenshot`**
**What it does:** Control running Flutter apps via Flutter Driver for testing and documentation

**What MCP tools it uses:**
- `launch_app`, `connect_dart_tooling_daemon`, `flutter_driver_command`, `get_widget_tree`, `stop_app`

**When to use:**
- ✅ End-to-end testing of app workflows
- Capturing screenshots for documentation
- Manual regression testing
- Debugging complex user interactions

**User prompt example:**
> "Launch the app, navigate to Settings, and capture a screenshot"

**Workflows:**
- E2E test automation
- Regression testing
- Manual testing with automated control
- Documentation screenshots

---

## Quick Decision Tree: Which Skill to Use?

```
Task Analysis:
│
├─ "Set up a new project"
│  └─→ Use: flutter-setup-guide-skill
│
├─ "Add feature/write code"
│  ├─ "Need guidance on best practices"
│  │  └─→ Use: load-flutter-instructions
│  └─ "Need to find/add packages"
│     └─→ Use MCP: pub_dev_search, pub
│
├─ "Need to test"
│  ├─ "Add tests for a specific file"
│  │  └─→ Use: single-file-test-coverage
│  ├─ "Run tests to verify"
│  │  └─→ Use MCP: run_tests
│  └─ "Do E2E testing/screenshots"
│     └─→ Use: flutter-control-and-screenshot
│
├─ "Need to improve code"
│  ├─ "Modernize to Dart 3+"
│  │  └─→ Use: migrate-to-modern-dart-features
│  ├─ "Clean up and format"
│  │  └─→ Use MCP: dart_format, dart_fix, analyze_files
│  └─ "Fix issues"
│     └─→ Use MCP: analyze_files, dart_fix
│
└─ "Ready for PR"
   └─→ Use: pr-prep
```

---

## Common Workflows

### Workflow 1: Creating a New Feature
1. **Understand requirements** → Use skill: `load-flutter-instructions`
2. **Add dependencies** → Use MCP: `pub_dev_search`, `pub add`
3. **Write feature code** → Use skill: `load-flutter-instructions`
4. **Add tests** → Use skill: `single-file-test-coverage`
5. **Verify quality** → Use MCP: `analyze_files`, `run_tests`
6. **Prepare for PR** → Use skill: `pr-prep`

### Workflow 2: Bug Fixing
1. **Understand bug** → Use MCP: `get_runtime_errors`, `get_widget_tree`
2. **Fix code** → Use MCP: `hot_reload` for quick testing
3. **Add regression test** → Use skill: `single-file-test-coverage`
4. **Verify fix** → Use MCP: `run_tests`
5. **Prepare for PR** → Use skill: `pr-prep`

### Workflow 3: Codebase Modernization
1. **Find modernization candidates** → Use skill: `migrate-to-modern-dart-features`
2. **Refactor incrementally** → Use MCP: `dart_format`, `analyze_files`
3. **Verify no regressions** → Use MCP: `run_tests`
4. **Prepare for PR** → Use skill: `pr-prep`

### Workflow 4: Documentation/Testing
1. **Launch app** → Use MCP: `launch_app`
2. **Control app interactions** → Use skill: `flutter-control-and-screenshot`
3. **Capture screenshots** → Use skill: `flutter-control-and-screenshot`
4. **Stop app** → Use MCP: `stop_app`

---

## MCP Tool Examples

### Example 1: Search for a Package
```
MCP Tool: pub_dev_search
Search: "state management flutter"
Returns:
  - Provider (20M downloads, 4.9★)
  - Riverpod (5M downloads, 4.8★)
  - Bloc (3M downloads, 4.7★)
```
Then use: `pub add provider` to add selected package

### Example 2: Debug Layout Issue
```
MCP Tool: launch_app → get DTD
MCP Tool: connect_dart_tooling_daemon → connect
MCP Tool: get_runtime_errors → "Bottom overflowed by 42 pixels"
MCP Tool: get_widget_tree → inspect hierarchy
→ Fix widget → MCP Tool: hot_reload → verify
```

### Example 3: Improve Test Coverage
```
MCP Tool: run_tests --coverage → 62% coverage
Skill: single-file-test-coverage → add edge case tests
MCP Tool: run_tests --coverage → 87% coverage ✓
```

---

## When NOT to Use MCP Tools

- **Code should NOT be written directly via MCP** - Write code normally, use MCP for analysis/fixing
- **No interactive debugging** - Use `get_runtime_errors` and `get_widget_tree` instead of debugger
- **No git operations** - MCP tools don't commit/push (by design, for safety)
- **No file system access** - Limited to project directory only

---

## Checklist: Agent is Ready

Before starting a task, verify:

✅ **Setup Complete**
- [ ] Dart SDK 3.9+ installed: `dart --version`
- [ ] Flutter SDK 3.35+ installed: `flutter --version`
- [ ] Dart extension v3.116+ installed
- [ ] `dart.mcpServer: true` in VS Code settings

✅ **Skills Available**
- [ ] Agent has access to `flutter-coding-agent`
- [ ] Agent can reference skills for guidance
- [ ] MCP tools are accessible via VS Code

✅ **Project Ready**
- [ ] Flutter project exists with `pubspec.yaml`
- [ ] Dependencies downloaded: `flutter pub get`
- [ ] No build errors: `flutter analyze`

---

## Helpful Commands (Manual Reference)

```bash
# Verify setup
dart --version
flutter --version
flutter doctor -v

# Code quality (MCP tools)
dart analyze
dart format lib
dart fix --apply
flutter test

# Dependency management (MCP tools)
flutter pub get
flutter pub add package_name
flutter pub upgrade

# Development
flutter run
flutter run -d chrome  # For web testing

# Cleanup
flutter clean
dart pub cache clean
```

---

## Resources

- **Dart/Flutter MCP Server**: https://github.com/dart-lang/ai
- **Flutter Docs**: https://docs.flutter.dev/
- **Dart Language**: https://dart.dev/
- **Agent Skills Reference**: See `.github/skills/` directory

---

## Summary

| Situation | Use This |
|-----------|----------|
| Setting up new project | `flutter-setup-guide-skill` |
| Writing code | `load-flutter-instructions` + MCP tools |
| Adding packages | `pub_dev_search` + `pub` MCP tools |
| Testing code | `single-file-test-coverage` or `run_tests` MCP tool |
| Modernizing code | `migrate-to-modern-dart-features` |
| Debugging | `get_runtime_errors`, `get_widget_tree` MCP tools |
| Testing workflows | `flutter-control-and-screenshot` |
| Before PR | `pr-prep` |
| Code quality check | `analyze_files`, `dart_fix`, `dart_format` MCP tools |
