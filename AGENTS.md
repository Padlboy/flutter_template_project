# AGENTS.md

This repository uses a multi-agent workflow for Flutter app development.

> ⚠️ **The planning-agent MUST run first.** No other agent will start work until `ai-context/planning-agent/app-plan.md` exists.

---

## Mandatory Invocation Order

```
1. planning-agent       → first, always. Creates the app plan.
2. design-agent         → translates Figma into Flutter design specs.
3. supabase-agent       → sets up the backend, writes handoff files.
4. flutter-coding-agent → implements features using all the above.
5. browser-mode-tester  → validates everything works.
```

---

## Agent Call Permission Matrix

| Agent | Can call | Cannot call |
|---|---|---|
| `planning-agent` | nobody | everyone |
| `flutter-coding-agent` | design-agent, supabase-agent, browser-mode-tester | — |
| `design-agent` | nobody | everyone |
| `supabase-agent` | nobody | everyone |
| `browser-mode-tester` | flutter-coding-agent (Mode B only) | everyone else |

> **browser-mode-tester Mode A** = called by flutter-coding-agent → responds only, does NOT call back.
> **browser-mode-tester Mode B** = started by the human developer → MAY call flutter-coding-agent to report bugs.

See `.github/skills/agent-call-rules/SKILL.md` for the full authoritative ruleset.

---

## Agents

### planning-agent
**Location:** `.github/agents/planning-agent.md`
**Output directory:** `ai-context/planning-agent/`

The **planning-agent** is the mandatory first step for any new app or major feature. It converts a raw app idea into three structured planning files that every other agent reads before starting work.

- Asks clarifying questions to understand the app concept
- Writes `app-plan.md` — master feature plan, user stories, screen map, tech decisions
- Writes `design-brief.md` — color direction, tone, typography, UI component style
- Writes `supabase-plan.md` — tables, columns, auth strategy, RLS policies, migration order
- Does **NOT** call any other agent
- Is **NOT** called by any agent — only by the user

**⛔ All other agents reject work until `app-plan.md` exists.**

To invoke:
```
planning-agent: [describe your app idea]
```

---

### design-agent
**Location:** `.github/agents/design-agent.md`
**Output directory:** `ai-context/design-agent/`

The **design-agent** is responsible for all design-related tasks:
- Fetching design specifications and assets from Figma (via Figma MCP server)
- Generating markdown design specs and implementation guides for the coding agent
- Extracting design tokens (colors, typography, spacing) in Flutter-ready Dart constants
- Setting up and maintaining the connection to the Figma design project
- Answering design questions and clarifying design intent
- Creating handoff files in `ai-context/design-agent/` for the coding agent

**The coding agent should delegate all design tasks to the design-agent.**
**The design-agent does NOT call other agents** — it communicates back via handoff files.

To invoke it, prefix your request:
```
design-agent: get design for [Component], figma_url: <url>
design-agent: clarify [design question]
design-agent: generate implementation guide for [Component], target: flutter
design-agent: extract design system, figma_url: <url>, format: flutter-constants
design-agent: initialize design project, figma_url: <url>
```

---

### supabase-agent
**Location:** `.github/agents/supabase-agent.md`
**Output directory:** `ai-context/supabase-agent/`

The **supabase-agent** is responsible for all Supabase backend tasks:
- Creating and managing Supabase projects via the Supabase MCP server
- Designing schemas, writing migrations, and configuring RLS policies
- Setting up authentication (email/password, magic link, OAuth, OTP, MFA)
- Generating Flutter Dart integration code using `supabase_flutter` v2
- Verifying the Supabase setup (project health, security advisors, config)
- Running an interactive onboarding process when no Supabase config is detected
- Answering any question about Supabase architecture, pricing, or best practices
- Creating handoff files in `ai-context/supabase-agent/` for the coding agent

**The coding agent MUST call the supabase-agent before implementing any Supabase-related feature.**
**The supabase-agent does NOT call other agents** — it communicates back via handoff files.

To invoke it, prefix your request:
```
supabase-agent: setup
supabase-agent: status
supabase-agent: auth [provider]
supabase-agent: db create [table description]
supabase-agent: db query [description]
supabase-agent: wire [feature name]
supabase-agent: question [topic]
supabase-agent: deploy checklist
```

---

### flutter-coding-agent
**Location:** `.github/agents/flutter-coding-agent.md`

The **flutter-coding-agent** is the central implementation agent:
- Implements features in Flutter/Dart following the app plan and handoff files
- Reads handoff files from design-agent and supabase-agent at the start of each session
- Calls design-agent before implementing any UI screen or component
- Calls supabase-agent before implementing any Supabase feature
- Calls browser-mode-tester after completing any feature to validate it

**Calls:** design-agent, supabase-agent, browser-mode-tester

---

### browser-mode-tester
**Location:** `.github/agents/browser-mode-tester.md`
**Output directory:** `ai-context/browser-mode-tester/`

The **browser-mode-tester** is responsible for all automated testing:
- Running Playwright E2E tests against the Flutter web app in Chrome
- Writing and executing Flutter unit tests and widget tests
- Reading test instruction markdown files dropped by other agents in `ai-context/browser-mode-tester/`
- Falling back to a full-app smoke test when no instructions are provided
- Storing and managing test account credentials in `ai-context/browser-mode-tester/tester-credentials.json`
- Reporting test failures with locators, screenshots, and suggested fixes

**Mode A (called by flutter-coding-agent):** Responds directly with test results. Does NOT call back.
**Mode B (started by the human developer):** May call flutter-coding-agent to report bugs.

**The coding agent should call the browser-mode-tester after implementing a feature to validate it.**
Other agents can drop a `<feature>-test-instructions.md` file in `ai-context/browser-mode-tester/` to queue test tasks.

To invoke it, prefix your request:
```
browser-mode-tester: e2e                          # run full Playwright smoke test
browser-mode-tester: e2e [feature/file]            # test a specific feature
browser-mode-tester: unit [file or feature]        # run/write Flutter unit tests
browser-mode-tester: setup                         # initialise Playwright in this project
browser-mode-tester: credentials                   # update tester login credentials
browser-mode-tester: report                        # show last test run HTML report
```

**The tester will ask for the Flutter web server port if it can't determine it automatically.**

---

## Global Rules for All Agents

### 1. App Plan Gate — Non-Negotiable

**Every agent MUST check for `app-plan.md` before starting any work:**
```
ai-context/planning-agent/app-plan.md
```
If the file does not exist — **STOP and tell the user to run the planning-agent first.**

### 2. Read Call Rules at Startup

Every agent MUST read the `agent-call-rules` skill at the start of every session:
```
.github/skills/agent-call-rules/SKILL.md
```

### 3. Read Template Overview at Startup

Every agent MUST read the `template-overview` skill at the start of every session:
```
.github/skills/template-overview/SKILL.md
```

### 4. Context7 / Documentation Lookups
If the `upstash/context7` MCP server is available, **always prefer it** for looking up library and framework documentation over web search or relying on training data.

Use it whenever you need to check:
- API signatures, widget properties, or method parameters (Flutter, Dart, Figma APIs, etc.)
- Package documentation (pub.dev packages, npm packages, etc.)
- Framework-specific patterns or configuration options
- Any documentation where an up-to-date, authoritative source is better than a recalled answer

```
# Resolve the library ID first, then fetch docs
resolve_library_id("flutter")         → use returned ID in get_library_docs
get_library_docs(libraryId, "topic")  → authoritative, version-aware docs
```

Only fall back to web search or prior knowledge if Context7 does not have coverage for the library in question.

---

## Project Overview

This is a Flutter template repository. All Flutter source code lives in:
- `lib/` — main Flutter app source
- `test/` — widget and unit tests

Planning files (required by all agents before starting work):
- `ai-context/planning-agent/` — app-plan.md, design-brief.md, supabase-plan.md

Design assets and specs generated by the design-agent:
- `ai-context/design-agent/` — spec files and design documentation
- `lib/design/` — generated Flutter design constants (tokens)

Supabase handoff files:
- `ai-context/supabase-agent/` — backend readiness files for the coding agent

Test credentials and instructions:
- `ai-context/browser-mode-tester/` — tester-credentials.json and test instruction files
