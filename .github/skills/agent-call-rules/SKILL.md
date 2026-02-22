---
name: agent-call-rules
description: "Authoritative ruleset defining which agent can call which other agent, how handoffs work, and what happens when the planning agent has not yet run. MANDATORY reading for every agent before starting any work."
---

# Agent Call Rules

> ⚠️ **Every agent MUST read these rules before starting any work.**
> ⚠️ **Every agent MUST verify that the planning agent has run before starting any work.**

---

## 0. The Golden Rule — Planning First

**Before any agent does anything, the planning-agent MUST have produced an app plan.**

### How to check

Look for the master plan file:
```
ai-context/planning-agent/app-plan.md
```

- **File exists and is non-empty** → proceed with your work.
- **File does not exist, is empty, or only contains a placeholder** → **STOP. Reject all work. Tell the user:**

> ❌ No app plan found. The planning-agent must run first and create `ai-context/planning-agent/app-plan.md` before I can start working. Please invoke the planning-agent with your app idea first.

This rule applies to **every agent without exception** — coding, design, supabase, and testing agents all check for this file.

---

## 1. Agent Roster and Roles

| Agent | Role | Invoked by |
|---|---|---|
| `planning-agent` | Creates the master app plan, design brief, and Supabase plan | User directly |
| `flutter-coding-agent` | Implements features in Flutter/Dart | User directly |
| `design-agent` | Fetches Figma designs, generates design specs and handoff files | User directly or flutter-coding-agent |
| `supabase-agent` | Sets up backend, schema, auth, generates Flutter wiring | User directly or flutter-coding-agent |
| `browser-mode-tester` | Runs E2E and unit tests | User directly, flutter-coding-agent, or itself (re-runs after bug fix) |

---

## 2. Call Permission Matrix

```
planning-agent
  ├── CAN CALL:   nobody
  └── CAN BE CALLED BY: user only

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

### planning-agent

- Called **directly by the user** with the initial app idea / prompt.
- **Does NOT call any other agent.**
- **Cannot be called by any other agent.**
- Produces three planning files (see section 5) that all other agents read.
- Must be the first agent invoked for any new app or major feature.

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
| No `app-plan.md` | **Reject work. Tell user to run planning-agent first.** |
| UI implementation needed, no design spec | Call design-agent first |
| Supabase feature needed, no handoff file | Call supabase-agent first |
| Feature complete | Call browser-mode-tester to validate |
| Tester called by coder and finds bugs | Respond with bug report — do NOT call coder back |
| Tester started by human dev and finds bugs | Call flutter-coding-agent with bug report |

---

## 7. YAML `agents:` Field Reference

These are the authoritative values for each agent's markdown front matter:

```yaml
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
