# Planning Agent Output

This directory contains the planning files created by the `planning-agent`.

**All other agents MUST check for `app-plan.md` before starting any work.**
If `app-plan.md` does not exist, agents must reject all work and ask the user to run the planning-agent first.

## Files

| File | Status | Description |
|---|---|---|
| `app-plan.md` | _(not yet created)_ | Master app plan — features, user stories, tech decisions |
| `design-brief.md` | _(not yet created)_ | Design direction for the design-agent |
| `supabase-plan.md` | _(not yet created)_ | Backend blueprint for the supabase-agent |

## How to create the plan

Invoke the planning-agent with your app idea:

```
planning-agent: [describe your app idea here]
```

The planning-agent will ask clarifying questions and then produce all three files.
