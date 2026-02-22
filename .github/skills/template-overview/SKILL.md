---
name: template-overview
description: "Complete overview of this Flutter template repository — its architecture, folder structure, agent system, design conventions, and how all parts fit together. Read this skill at the start of any task to understand the project context before writing code or making decisions."
---

# Flutter Template Repository — Full Overview

This skill describes every significant component of this Flutter template so any agent can quickly orient itself and make well-informed decisions.

---

## Purpose of This Template

This repository is a **production-ready Flutter starter** for building authenticated, Supabase-backed apps with a multi-agent development workflow. It ships with:

- A working Flutter app skeleton (auth screens, home, routing, theming)
- Supabase integration boilerplate (config, auth repository)
- A design token system (colors, spacing, typography)
- Reusable widget library
- A multi-agent AI workflow (planning → design → backend → code → test)
- Skills for common development tasks

---

## Repository Layout

```
(project root)/
├── lib/                            ← Flutter app source code
│   ├── main.dart                   ← App entry point, Supabase init, theme setup
│   ├── router.dart                 ← GoRouter route definitions
│   ← supabase_config.dart         ← Supabase URL + anon key (from --dart-define)
│   ├── design/
│   │   ├── app_colors.dart         ← Color tokens (AppColors)
│   │   ├── app_spacing.dart        ← Spacing tokens (AppSpacing)
│   │   └── app_theme.dart          ← ThemeData factory using tokens
│   ├── features/
│   │   ├── auth/
│   │   │   ├── auth_notifier.dart  ← Auth state (ChangeNotifier / Riverpod)
│   │   │   ├── login_screen.dart   ← Login UI
│   │   │   └── register_screen.dart← Register UI
│   │   └── home/
│   │       └── home_screen.dart    ← Post-login landing screen
│   ├── models/                     ← Data model classes (add domain models here)
│   ├── repositories/
│   │   └── auth_repository.dart    ← Supabase auth calls abstracted
│   └── widgets/
│       ├── app_drawer.dart         ← Side drawer with navigation
│       ├── empty_state.dart        ← Reusable empty-state placeholder
│       ├── loading_spinner.dart    ← Centered loading indicator
│       └── primary_button.dart     ← Themed CTA button
├── test/
│   └── widget_test.dart            ← Starter widget tests
├── supabase/
│   └── migrations/
│       └── 001_initial_schema.sql  ← Initial DB schema migration
├── web/
│   ├── index.html                  ← Flutter web entry point
│   └── manifest.json
├── .env.example                    ← Template for environment variables
├── pubspec.yaml                    ← Flutter dependencies
├── analysis_options.yaml           ← Dart linter rules
└── .github/
    ├── agents/                     ← Agent instruction files
    │   ├── requirement-engineer.md ← Requirements elicitation agent (recommended first step)
    │   ├── planning-agent.md       ← Planning agent (MUST run before impl agents)
    │   ├── flutter-coding-agent.md ← Main coding agent
    │   ├── design-agent.md         ← Figma/design agent
    │   ├── supabase-agent.md       ← Supabase backend agent
    │   └── browser-mode-tester.md  ← E2E + unit testing agent
    ├── skills/                     ← Reusable agent skill files
    └── ...
```

---

## Architecture Patterns

### State Management
- Uses **ChangeNotifier** (or Riverpod if added) for feature-level state
- Each feature folder has a `*_notifier.dart` for its state
- UI widgets call notifiers via `Provider` or `ref.watch`

### Routing
- [`router.dart`](lib/router.dart) uses **GoRouter** for declarative routing
- Auth redirect guard: unauthenticated users → `/auth/login`, authenticated → `/`
- Add new routes using `GoRoute(path: '...', builder: ...)` entries

### Supabase Integration
- [`supabase_config.dart`](lib/supabase_config.dart) holds `url` + `anonKey` sourced from `--dart-define`
- [`auth_repository.dart`](lib/repositories/auth_repository.dart) wraps all Supabase auth calls
- Run with: `flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...`
- Or use a `.env` file + the `flutter_dotenv` pattern (add if needed)

### Design System
| File | What It Contains |
|---|---|
| `app_colors.dart` | `AppColors.primary`, `AppColors.surface`, etc. |
| `app_spacing.dart` | `AppSpacing.xs` (4), `sm` (8), `md` (16), `lg` (24), `xl` (32) |
| `app_theme.dart` | `AppTheme.light()` → `ThemeData` factory using the tokens |

**All new UI must use these tokens.** Never hardcode colors or spacing.

### Widget Library
| Widget | Usage |
|---|---|
| `PrimaryButton` | Main CTA in any screen — `PrimaryButton(label: 'Save', onPressed: ...)` |
| `LoadingSpinner` | Drop in while async loading — `const LoadingSpinner()` |
| `EmptyState` | Empty list placeholder — `EmptyState(message: 'No items yet')` |
| `AppDrawer` | Side nav drawer, already wired to Scaffold in HomeScreen |

---

## Agent System

This template uses a **5-agent workflow**. The agents must be invoked in the correct order.

### Mandatory Invocation Order

```
1. planning-agent     → Always first. Creates the app plan.
2. design-agent       → Translates Figma designs into Flutter specs.
3. supabase-agent     → Sets up database, auth, and generates Flutter wiring code.
4. flutter-coding-agent → Implements features using the specs and handoff files.
5. browser-mode-tester  → Tests the implemented features.
```

**⛔ No agent (except the planning-agent) should start work without a valid app plan in `ai-context/planning-agent/app-plan.md`.**

### Agent Calling Rules (summary)
See the `agent-call-rules` skill for the full authoritative ruleset.

| Agent | Can call | Creates output for |
|---|---|---|
| `requirement-engineer` | planning-agent (hand-off) | planning-agent (requirements.md) |
| `planning-agent` | nobody | all agents (app-plan.md, design-brief.md, supabase-plan.md) |
| `flutter-coding-agent` | design-agent, supabase-agent, browser-mode-tester | production code |
| `design-agent` | nobody | handoff files → `ai-context/design-agent/` |
| `supabase-agent` | nobody | handoff files → `ai-context/supabase-agent/` |
| `browser-mode-tester` | flutter-coding-agent (only when NOT called by coder) | test reports |

### Planning Status Flag
```
ai-context/planning-status.json
```
Read this first. `initial_planning_completed: false` → full planning needed. `true` → scoped changes only.

### Planning Files Location
```
ai-context/
├── planning-status.json         ← flag: initial_planning_completed (read by ALL agents)
├── requirements-engineer/
│   ├── requirements.md            ← full requirements doc (read by planning-agent)
│   └── change-request-*.md        ← scoped change requests
└── planning-agent/
    ├── app-plan.md                ← Master app plan (required by all impl agents)
    ├── design-brief.md            ← Design direction for design-agent
    └── supabase-plan.md           ← DB + auth plan for supabase-agent
```

### Handoff Files Location
```
ai-context/supabase-agent/     ← Backend readiness files for coding agent
ai-context/design-agent/       ← Design specs and token files for coding agent
ai-context/browser-mode-tester/ ← Test instructions for testing agent
```

---

## Skills Reference

| Skill | Purpose |
|---|---|
| `load-flutter-instructions` | Flutter/Dart coding standards — always load before writing code |
| `template-overview` | This file — project context and conventions |
| `agent-call-rules` | Which agent can call which — mandatory reading before starting work |
| `implement-design` | Figma → Flutter workflow with 1:1 fidelity |
| `flutter-unit-testing` | Unit and widget test patterns |
| `flutter-control-and-screenshot` | Flutter Driver E2E testing |
| `playwright-expert` | Playwright E2E test patterns for Flutter web |
| `setup-flutter-env` | Dev environment setup guidance |
| `pr-prep` | Pre-PR code quality checklist |
| `migrate-to-modern-dart-features` | Modernize code to Dart 3+ |
| `single-file-test-coverage` | Improve coverage on a specific file |
| `supabase-postgres-best-practices` | Postgres optimization for Supabase |
| `get-mcp-capabilities` | Reference for all available MCP tools |
| `find-skills` | Discover and install new skills |
| `search-new-flutter-skills` | Search internet for new Flutter skills |

---

## Key Conventions

1. **Feature folders** — each feature lives in `lib/features/<feature>/` with its own screen(s), notifier(s), and any local widgets.
2. **No business logic in widgets** — widgets only call notifier methods; never query Supabase directly from a widget.
3. **Repository pattern** — all external data access (Supabase, REST, local storage) goes through a repository class in `lib/repositories/`.
4. **Token-only styling** — use `AppColors.*`, `AppSpacing.*`, `Theme.of(context).*`; never raw values.
5. **GoRouter for navigation** — never use `Navigator.push` directly; always use `context.go(...)` or `context.push(...)`.
6. **dart-define for secrets** — never commit `SUPABASE_URL` or `SUPABASE_ANON_KEY`; always use `--dart-define`.
7. **RLS always on** — every Supabase table must have Row Level Security enabled.
8. **Tests for every feature** — every new feature should have at least one widget test and one unit test for its notifier.

---

## Running the App

```bash
# Web (development)
flutter run -d chrome \
  --dart-define=SUPABASE_URL=https://yourproject.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key

# Run tests
flutter test

# Analyze
flutter analyze

# Format
dart format lib/ test/
```

---

## Environment Variables

Copy `.env.example` to `.env` (gitignored) and fill in your values. Pass them via `--dart-define` flags or a build script.

```
SUPABASE_URL=https://yourproject.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

---

## Adding a New Feature — Quick Checklist

- [ ] Create `lib/features/<feature>/` folder
- [ ] Add data model in `lib/models/<feature>.dart`
- [ ] Add repository in `lib/repositories/<feature>_repository.dart`
- [ ] Add notifier in `lib/features/<feature>/<feature>_notifier.dart`
- [ ] Add screen(s) in `lib/features/<feature>/<feature>_screen.dart`
- [ ] Register route in `lib/router.dart`
- [ ] Add Supabase migration via supabase-agent
- [ ] Implement UI using design-agent spec
- [ ] Write unit test for notifier
- [ ] Write widget test for screen
- [ ] Call browser-mode-tester to validate E2E