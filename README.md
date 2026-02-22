# Flutter Template Repository

A production-ready Flutter project template with:

- **Supabase** back-end (auth, database, RLS) — wired out of the box
- **go_router** for declarative, guard-protected navigation
- **Docker dev container** for a reproducible team environment
- **Multi-agent AI workflow** (design, backend, coding, testing agents)
- Pre-built auth screens (login / register), a generic home screen, and reusable widgets

Fork this repository to start every new Flutter app from a solid foundation.

---

## Table of Contents

1. [Fork & First Steps](#1-fork--first-steps)
2. [Supabase Setup](#2-supabase-setup)
3. [Customise the Template](#3-customise-the-template)
4. [Dev Container](#4-dev-container)
5. [Project Structure](#5-project-structure)
6. [Agent Workflow](#6-agent-workflow)
7. [Daily Commands](#7-daily-commands)
8. [Troubleshooting](#8-troubleshooting)
9. [Contributing](#9-contributing)

---

## 1. Fork & First Steps

```bash
# 1. Fork this repo on GitHub, then clone your fork
git clone https://github.com/YOUR_USERNAME/YOUR_APP_NAME.git
cd YOUR_APP_NAME

# 2. Rename the app (update pubspec.yaml → name field)
# 3. Open in VS Code
code .

# 4. (Optional) Reopen in Dev Container when prompted
```

Rename the package in `pubspec.yaml`:

```yaml
name: your_app_name            # ← change this
description: "My awesome app" # ← change this
```

Then run:

```bash
flutter pub get
```

---

## 2. Supabase Setup

The template is pre-wired for Supabase. You just need to provision your own project.

### Option A — AI-assisted (recommended)

Ask the **supabase-agent** to do everything:

```
supabase-agent: setup
```

The agent will create the project, apply the baseline migration, and write your credentials into `lib/supabase_config.dart`.

### Option B — Manual

1. Create a project at [supabase.com](https://supabase.com)
2. Copy your project URL and anon key from **Settings → API**
3. Run the migration in the Supabase SQL editor:
   ```
   supabase/migrations/001_initial_schema.sql
   ```
4. Pass credentials via `--dart-define` (recommended):

```bash
flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
            --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

> **Never commit real keys** — use `--dart-define` or a `.env` file that is gitignored.

---

## 3. Customise the Template

All app-specific code lives in `lib/`. Here's where to start:

| File | What to do |
|---|---|
| `lib/main.dart` | Change the app title (`'My App'`) |
| `lib/router.dart` | Add your app's routes below the `// TODO` comment |
| `lib/features/home/home_screen.dart` | Replace the placeholder content |
| `lib/widgets/app_drawer.dart` | Add your navigation items |
| `lib/design/app_colors.dart` | Change the colour palette |
| `lib/design/app_theme.dart` | Tweak typography, shape, and theme |
| `supabase/migrations/001_initial_schema.sql` | Add your app-specific tables after the `profiles` table |

### Adding a new feature

```
1. Ask supabase-agent to create any tables you need:
   supabase-agent: db create [describe your table]

2. Create your model in lib/models/
3. Create your repository in lib/repositories/
4. Create your notifier in lib/features/<feature>/
5. Create your screen(s) in lib/features/<feature>/
6. Register routes in lib/router.dart
```

---

## 4. Dev Container

The `.devcontainer/` folder configures a Docker-based Flutter environment — the same image for every developer.

CI also validates this setup by building the dev container image and running `flutter analyze` inside it.

```bash
# Open in container (VS Code)
F1 → "Dev Containers: Reopen in Container"

# Rebuild after Dockerfile changes
F1 → "Dev Containers: Rebuild Container"

# Run the same analyze check used in CI
docker compose -f .devcontainer/docker-compose.yml build flutter-dev
docker compose -f .devcontainer/docker-compose.yml run --rm --user ubuntu flutter-dev sh -lc "flutter pub get && flutter analyze --fatal-infos"
```

See [.devcontainer/README.md](.devcontainer/README.md) for detailed setup including USB Android device passthrough on Windows/WSL2.

---

## 5. Project Structure

```
.
├── lib/
│   ├── main.dart                    # App entry point
│   ├── router.dart                  # go_router configuration
│   ├── supabase_config.dart         # Supabase credentials (use --dart-define)
│   ├── design/
│   │   ├── app_colors.dart          # Colour palette
│   │   ├── app_spacing.dart         # Spacing constants
│   │   └── app_theme.dart           # MaterialTheme
│   ├── features/
│   │   ├── auth/                    # Login & register screens + notifier
│   │   └── home/                    # Home screen placeholder
│   ├── models/                      # Data models (add yours here)
│   ├── repositories/
│   │   └── auth_repository.dart     # Auth Supabase calls
│   └── widgets/                     # Reusable widgets
│       ├── app_drawer.dart
│       ├── empty_state.dart
│       ├── loading_spinner.dart
│       └── primary_button.dart
├── supabase/
│   └── migrations/
│       └── 001_initial_schema.sql   # profiles table + trigger
├── test/                            # Unit & widget tests
├── .devcontainer/                   # Docker dev environment
├── .github/
│   ├── agents/                      # AI agent definitions
│   └── skills/                      # Reusable agent skills
├── pubspec.yaml
└── analysis_options.yaml
```

---

## 6. Agent Workflow

This template ships with a **multi-agent AI system** built on GitHub Copilot chat agents. Each agent has a narrow, well-defined responsibility. They hand off context via markdown files in `ai-context/` rather than calling each other in unpredictable chains.

> ⚠️ **Check `ai-context/planning-status.json` before starting work.** If `initial_planning_completed` is `false`, no app has been defined yet — run the `requirement-engineer` and then the `planning-agent` first. All implementation agents refuse to work until `ai-context/planning-agent/app-plan.md` exists.

### Agents at a glance

| Agent | Purpose | How to call |
|---|---|---|
| `requirement-engineer` | **Recommended first step** — elicits & documents all requirements | `requirement-engineer: [describe your app or change]` |
| `planning-agent` | Converts requirements/idea into a structured plan | `planning-agent: [describe your app or change]` |
| `design-agent` | Figma → Flutter design tokens & implementation guides | `design-agent: <cmd>` |
| `supabase-agent` | All Supabase tasks — projects, schema, auth, RLS wiring | `supabase-agent: <cmd>` |
| `flutter-coding-agent` | Central coding agent — features, refactors, debugging | default Copilot agent |
| `browser-mode-tester` | Playwright E2E + Flutter unit/widget tests | `browser-mode-tester: <cmd>` |

### Mandatory invocation order — new app

```
0. requirement-engineer → elicits requirements → writes requirements.md (recommended)
1. planning-agent       → reads requirements.md → creates app-plan.md, design-brief.md, supabase-plan.md
2. design-agent         → translates Figma into Flutter design specs
3. supabase-agent       → provisions backend, writes supabase handoff files
4. flutter-coding-agent → implements features using all the above
5. browser-mode-tester  → validates everything works
```

### Adding a feature or change to an existing app

```
0. requirement-engineer → scoped change requirements (recommended)
1. planning-agent       → updates the app plan
2. (design-agent / supabase-agent as needed)
3. flutter-coding-agent → implements the feature
4. browser-mode-tester  → validates the change
```

### How agents communicate

Agents don't call each other directly (except where the permission matrix allows). Instead they **write handoff files** that the next agent reads:

```
ai-context/
  planning-status.json     ← initial_planning_completed flag (read by ALL agents)
  requirements-engineer/
    requirements.md        ← full requirements doc → read by planning-agent
    change-request-*.md   ← scoped change requests
  planning-agent/
    app-plan.md            ← feature plan, user stories, screen map
    design-brief.md        ← color direction, tone, typography
    supabase-plan.md       ← tables, auth strategy, migration order
  design-agent/
    *.md                   ← design specs & implementation guides
  supabase-agent/
    supabase-setup.md      ← connection details, table list, RLS summary
  browser-mode-tester/
    *-test-instructions.md ← queued test tasks
```

### Example: starting a new app from scratch

```
# Step 0 — define requirements (recommended)
requirement-engineer: new app — a recipe manager with user accounts,
                      ingredient tracking, and meal planning

# Step 1 — create app plan (reads requirements.md automatically)
planning-agent: create plan from requirements

# Step 2 — set up the design (if you have a Figma file)
design-agent: initialize design project, figma_url: https://figma.com/design/...

# Step 3 — provision the backend
supabase-agent: setup

# Step 4 — implement features (reads all handoff files automatically)
flutter-coding-agent: implement the recipe list screen

# Step 5 — test
browser-mode-tester: e2e
```

See [AGENTS.md](AGENTS.md) for the full command reference, call-permission matrix, and global rules.

---

## 7. Daily Commands

```bash
# Run on web (after Supabase setup)
flutter run -d chrome

# Run on Android device
flutter run

# Code quality
dart format .
dart analyze
dart fix --apply
flutter test

# Build
flutter build apk --release
flutter build web
flutter build appbundle
```

---

## 8. Troubleshooting

| Problem | Fix |
|---|---|
| `SUPABASE_URL` placeholder error | Run `supabase-agent: setup` or pass `--dart-define` flags |
| Device not found | `flutter doctor`, reconnect USB, check USB Debugging |
| Build fails | `flutter clean && flutter pub get` |
| Container won't start | Ensure Docker Desktop is running, try Rebuild Container |
| `flutter doctor` issues | Run `setup-flutter-env` skill for guided diagnosis |

---

## 9. Contributing

Contributions are very welcome! This template is meant to grow with the community.

### Ways to contribute

- **Bug reports** — found something broken? [Open an issue](https://github.com/Padlboy/flutter_template_project/issues/new?template=bug_report.md) with steps to reproduce.
- **Feature requests** — have an idea to make the template better? [Start a discussion](https://github.com/Padlboy/flutter_template_project/issues/new?template=feature_request.md) or open an issue tagged `enhancement`.
- **Pull requests** — improvements to code, docs, agent prompts, or skills are all fair game. PRs of any size are appreciated.
- **New agent skills** — built a reusable skill for the `.github/skills/` folder? Submit a PR!
- **Template improvements** — better folder structure, new widgets, improved design tokens, smarter routing — all welcome.

### How to submit a PR

```bash
# 1. Fork the repo on GitHub
# 2. Clone your fork
git clone https://github.com/YOUR_USERNAME/flutter_template_project.git
cd flutter_template_project

# 3. Create a feature branch
git checkout -b feat/your-improvement

# 4. Make your changes, then run quality checks
dart format .
dart analyze
flutter test

# 5. Commit and push
git commit -m "feat: describe your change"
git push origin feat/your-improvement

# 6. Open a Pull Request on GitHub
```

There's no strict style guide — just keep code clean, document what you added, and make sure `dart analyze` passes with no errors.

---

## License

[MIT](LICENSE) — free to use, fork, and build on.

---

## 🚀 Quick Start

### Prerequisites
- **Docker Desktop** (Windows/Mac) or Docker Engine (Linux)
- **VS Code** with Dev Containers extension
- Clone this repository

### Setup (5 minutes)
```bash
# 1. Clone the repo
git clone <your-repo-url>
cd flutter_template_repo

# 2. Open in VS Code
code .

# 3. Click "Reopen in Container" when prompted
# (Or: F1 → Dev Containers: Reopen in Container)

# 4. Wait for container to build (~2 min first time)

# 5. Connect your Android phone via USB
