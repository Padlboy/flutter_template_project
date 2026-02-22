# Supabase Handoff: Full Setup Complete

**Date:** 2026-02-22
**Status:** ✅ Backend ready — one Flutter task remaining before launch

---

## What was set up

A brand-new Supabase project was provisioned and the full database schema was applied.
The Flutter `lib/supabase_config.dart` has been updated with real credentials — the app
will connect to Supabase immediately once the single remaining Flutter task is done.

---

## Supabase Project

| Field | Value |
|---|---|
| Project name | all-about-snacks |
| Project ID | `agbkabivksenuosjcard` |
| Region | eu-west-1 |
| URL | `https://agbkabivksenuosjcard.supabase.co` |
| Status | ACTIVE_HEALTHY |

---

## Database Schema

All tables are in the `public` schema with **RLS enabled** and a single "users manage own data" policy on each.

| Table | Key columns | RLS |
|---|---|---|
| `categories` | `id`, `user_id`, `name`, `created_at` | ✅ enabled |
| `recipes` | `id`, `user_id`, `category_id?`, `title`, `description`, `image_url?`, `servings`, `prep_minutes`, `created_at` | ✅ enabled |
| `ingredients` | `id`, `recipe_id`, `name`, `amount`, `unit`, `sort_order` | ✅ enabled (via recipes join) |
| `instructions` | `id`, `recipe_id`, `step_number`, `text` | ✅ enabled (via recipes join) |

Security advisor: **0 issues found** ✅

---

## Flutter config (already done)

`lib/supabase_config.dart` has been updated with real values:

```dart
abstract final class SupabaseConfig {
  static const String url = 'https://agbkabivksenuosjcard.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
}
```

`lib/main.dart` is already initialising Supabase:

```dart
await Supabase.initialize(
  url: SupabaseConfig.url,
  anonKey: SupabaseConfig.anonKey,
);
```

All repositories (`auth_repository.dart`, `category_repository.dart`, `recipe_repository.dart`)
are already wired to the live Supabase client.

---

## Flutter implementation tasks

- [ ] **Add web support** — run this once from the project root, then launch in Chrome:

```bash
# From: c:\Users\patrick\Projekte\flutter_template_repo
flutter create . --platforms web
flutter run -d chrome
```

That's it. No other wiring is needed — the full app (auth, categories, recipes, router,
screens, notifiers) is already implemented and connected to Supabase.

---

## Auth behaviour

- Unauthenticated users are redirected to `/auth/login` by go_router's `redirect` guard.
- After login/register the user lands on `/` (HomeScreen).
- Sign-out is accessible from the navigation drawer.
- Auth uses Supabase email + password (`signInWithPassword` / `signUp`).
- **Email confirmation is disabled by default** on new Supabase projects — users can log
  in immediately after sign-up. If you want to enable it, toggle it in the Supabase
  dashboard → Authentication → Email.

---

## Gotchas / Notes

- The `instructions` table uses a `text` column (not `json`). The repository inserts rows as
  `{recipe_id, step_number, text}` and reads them back ordered by `step_number`.
- `ingredients.sort_order` is set to the list index at save time; re-ordering in the UI is
  not yet implemented.
- Images are optional (`image_url TEXT NULL`). `RecipeCard` shows a placeholder icon when
  no URL is set.
- There is no Supabase Storage bucket yet — image URLs must be external (e.g. a CDN link).
  If you want users to upload photos, a `recipe-images` public bucket needs to be created
  and the upload flow added to `RecipeEditScreen`.
