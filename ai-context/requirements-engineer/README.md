# Requirements Engineer — Context Directory

This directory contains output files produced by the **requirement-engineer** agent.

## Files written here

| File | Description |
|---|---|
| `requirements.md` | Full requirements document for the app or feature — read by the planning-agent |
| `change-request-<name>.md` | Individual change/feature request documents (Mode B: change requests) |

## How it works

- **Mode A — New App:** No prior plan exists. The agent runs full requirements elicitation and produces `requirements.md`.
- **Mode B — Change / Feature:** A plan already exists (`planning-status.json → initial_planning_completed: true`). The agent elicits scoped requirements for the new feature or change.

The planning-agent reads `requirements.md` (if it exists) before writing its planning files.
