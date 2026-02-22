---
name: agent-call-rules
description: "Authoritative ruleset defining which agent can call which other agent, how handoffs work, and what happens when the planning agent has not yet run. MANDATORY reading for every agent before starting any work."
---

# Agent Call Rules

> ⚠️ **Every agent MUST read these rules before starting any work.**
> ⚠️ **Every agent MUST check `ai-context/planning-status.json` before starting any work.**
> ⚠️ **Every implementation agent MUST verify that the planning agent has run before starting any work.**

---

## 0. The Golden Rules

### Rule 0a — Check Planning Status First

**Before any agent does anything, check the planning status flag:**
```
ai-context/planning-status.json
```

| `initial_planning_completed` | Required action |
|---|---|
| `false` | **STOP.** No app has been planned yet. Tell the user: *"No requirements or app plan exist yet. Please run the `requirement-engineer` first to define requirements, then the `planning-agent` to create the app plan."* |
| `true` | Proceed. Scope your work to the specific feature or change being requested. |

The `requirement-engineer` and `planning-agent` are exempt from this rule — they ARE the agents that establish the initial plan.

### Rule 0b — App Plan Gate

**Before any *implementation* agent does anything, the planning-agent MUST have produced an app plan.**

Look for the master plan file:
```
ai-context/planning-agent/app-plan.md
```

- **File exists and is non-empty** → proceed with your work.
- **File does not exist, is empty, or only contains a placeholder** → **STOP. Reject all work. Tell the user:**

> ❌ No app plan found. The planning-agent must run first and create `ai-context/planning-agent/app-plan.md` before I can start working. Please invoke the planning-agent with your app idea first.

This rule applies to the design, supabase, coding, and browser-mode-tester agents. The `requirement-engineer` and `planning-agent` themselves are exempt.

---

## 1. Agent Roster and Roles

| Agent | Role | Invoked by |
|---|---|---|
| `requirement-engineer` | Elicits and documents all requirements. Optional but recommended first step. | User directly or planning-agent (hand-off) |
| `planning-agent` | Creates/updates the master app plan, design brief, and Supabase plan | User directly, requirement-engineer |
| `flutter-coding-agent` | Implements features in Flutter/Dart | User directly |
| `design-agent` | Fetches Figma designs, generates design specs and handoff files | User directly or flutter-coding-agent |
| `supabase-agent` | Sets up backend, schema, auth, generates Flutter wiring | User directly or flutter-coding-agent |
| `browser-mode-tester` | Runs E2E and unit tests | User directly, flutter-coding-agent, or itself (re-runs after bug fix) |

---

## 2. Call Permission Matrix

```
requirement-engineer
  ├── CAN CALL:   planning-agent (when requirements are complete and user is ready)
  └── CAN BE CALLED BY: user only

planning-agent
  ├── CAN CALL:   nobody
  └── CAN BE CALLED BY: user, requirement-engineer

flutter-coding-agent
  ├── CAN CALL:   design-agent
  │               supabase-agent
  │               browser-mode-tester
  └── CAN BE CALLED BY: user, browser-mode-tester (bug reports only)

design-agent
  ├── CAN CALL:   nobody
  └── CAN BE CALLED BY: user, flutter-coding-agent

supabase-agent
  ├── CAN CALL:   nobody
  └── CAN BE CALLED BY: user, flutter-coding-agent

browser-mode-tester
  ├── CAN CALL:   flutter-coding-agent (only when started by the human dev — NOT when called by the coder)
  └── CAN BE CALLED BY: user, flutter-coding-agent
```

---

## 3. Detailed Rules Per Agent

### requirement-engineer

- Called **directly by the user** with the initial app idea or a change/feature request.
- **Supports two modes:**
  - **Mode A (new app):** `planning-status.json → initial_planning_completed: false` — runs full requirements elicitation and writes `ai-context/requirements-engineer/requirements.md`.
  - **Mode B (change/feature):** `planning-status.json → initial_planning_completed: true` — runs scoped change elicitation and writes `ai-context/requirements-engineer/change-request-<name>.md`.
- **MAY call `planning-agent`** when requirements are complete and the user is ready to proceed.
- **Does NOT call** any other agent.
- The `requirement-engineer` is **optional** — the planning-agent can also work from a direct developer description.

---

### planning-agent

- Called **directly by the user** or by the `requirement-engineer`.
- **Supports two modes:**
  - **Mode A (new app):** `planning-status.json → initial_planning_completed: false` — creates full plan from scratch. Reads `requirements.md` if available.
  - **Mode B (change/feature):** `planning-status.json → initial_planning_completed: true` — updates existing plan sections relevant to the change.
- **Does NOT call any other agent.**
- After Mode A completes, sets `initial_planning_completed: true` in `planning-status.json`.
- Produces three planning files (see section 5) that all other agents read.

---

### flutter-coding-agent

- The **central implementation agent**.
- **MUST call `design-agent`** before implementing any UI screen or component. Do not implement UI from scratch without a design spec.
- **MUST call `supabase-agent`** before implementing any Supabase feature. Do not write Supabase queries or auth code without a handoff file.
- **SHOULD call `browser-mode-tester`** after completing any feature implementation to validate correctness. This is best practice and should be the default.
- May call `design-agent`, `supabase-agent`, or `browser-mode-tester` **at any time** when confused or needing help.

**Handoff file workflow:**
1. Read `ai-context/supabase-agent/*.md` and `ai-context/design-agent/*.md` at the start of every session.
2. If relevant handoff files exist, ask the user: *"I found handoff tasks from the design-agent / supabase-agent. Should I implement them?"*
3. If no handoff file exists for a needed Supabase or design feature, call the respective agent first.

---

### design-agent

- Called by the user or `flutter-coding-agent`.
- **Does NOT call any other agent.**
- **Does NOT call the flutter-coding-agent** — communication is one-way via handoff files.
- After completing design work, creates a handoff file in `ai-context/design-agent/<component>.md`.
- The handoff file is the only communication channel back to the coding agent.

---

### supabase-agent

- Called by the user or `flutter-coding-agent`.
- **Does NOT call any other agent.**
- **Does NOT call the flutter-coding-agent** — communication is one-way via handoff files.
- After completing backend work, creates a handoff file in `ai-context/supabase-agent/<feature>.md`.
- The handoff file is the only communication channel back to the coding agent.

---

### browser-mode-tester

**Two operating modes:**

#### Mode A — Called by flutter-coding-agent
- Runs the requested tests.
- **Does NOT call flutter-coding-agent back.**
- Instead, **responds directly** to the coding agent session with:
  - ✅ Pass/fail summary
  - Specific failing test names and locators
  - Screenshots if relevant
  - Suggested fixes for any bugs found
- The coding agent then fixes the bugs itself without re-invoking the tester (or may re-invoke to verify the fix).

#### Mode B — Started by the human developer
- Applies when the **human developer** directly invokes the browser-mode-tester (not when called by flutter-coding-agent).
- **MAY call `flutter-coding-agent`** when it finds a bug, to request a fix.
- Formats the bug report clearly: screen, locator, expected vs actual, suggested fix.
- After the coding agent fixes the bug, the tester re-runs the tests to confirm.

**The tester NEVER calls design-agent, supabase-agent, or planning-agent.**

---

## 4. Handoff File Locations

| Producer | Output Directory | Consumer |
|---|---|---|
| `requirement-engineer` | `ai-context/requirements-engineer/` | `planning-agent` (reads requirements.md) |
| `planning-agent` | `ai-context/planning-agent/` | All agents (planning gate) |
| `design-agent` | `ai-context/design-agent/` | `flutter-coding-agent` |
| `supabase-agent` | `ai-context/supabase-agent/` | `flutter-coding-agent` |
| `browser-mode-tester` | `ai-context/browser-mode-tester/` | `flutter-coding-agent` (instructions), user (reports) |

---

## 5. Planning Files Reference

The `planning-agent` produces these files. All other agents read them:

| File | Purpose |
|---|---|
| `app-plan.md` | Master plan: app name, purpose, user stories, feature list, tech decisions |
| `design-brief.md` | Design direction for the design-agent: color palette, tone, UI patterns |
| `supabase-plan.md` | Backend blueprint for the supabase-agent: tables, auth, RLS, edge functions |

---

## 6. Enforcement Summary

| Situation | Required action |
|---|---|
| `planning-status.json → initial_planning_completed: false` | **STOP (for impl agents).** Tell user to run requirement-engineer then planning-agent first. |
| No `app-plan.md` | **Reject work (impl agents).** Tell user to run planning-agent first. |
| UI implementation needed, no design spec | Call design-agent first |
| Supabase feature needed, no handoff file | Call supabase-agent first |
| Feature complete | Call browser-mode-tester to validate |
| Tester called by coder and finds bugs | Respond with bug report — do NOT call coder back |
| Tester started by human dev and finds bugs | Call flutter-coding-agent with bug report |

---

## 7. YAML `agents:` Field Reference

These are the authoritative values for each agent's markdown front matter:

```yaml
# requirement-engineer.md
agents: ['planning-agent']

# planning-agent.md
agents: []

# flutter-coding-agent.md
agents: ['design-agent', 'supabase-agent', 'browser-mode-tester']

# design-agent.md
# (no agents: field — cannot call any agent)

# supabase-agent.md
# (no agents: field — cannot call any agent)

# browser-mode-tester.md
agents: ['flutter-coding-agent']
```
