# Supabase Setup

> **Status:** Not configured — run `supabase-agent: setup` to get started.

This file is maintained by the **supabase-agent**. Once a Supabase project has
been provisioned the agent will update this file with the project details,
schema overview, and any follow-up tasks.

---

## Quick-start

```
supabase-agent: setup
```

The agent will:
1. Ask for your preferred region and project name.
2. Provision a new Supabase project via the Supabase MCP server.
3. Apply `supabase/migrations/001_initial_schema.sql` (creates the `profiles` table).
4. Update `lib/supabase_config.dart` with the real URL and anon key.
5. Write the project details back to this file.

---

## Credentials placeholder

After setup, this section will be filled in by the agent:

| Field | Value |
|---|---|
| Project name | _(pending)_ |
| Project ID | _(pending)_ |
| Region | _(pending)_ |
| URL | _(pending)_ |
| Status | _(pending)_ |
