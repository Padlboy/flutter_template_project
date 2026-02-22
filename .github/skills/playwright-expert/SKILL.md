---
name: playwright-expert
description: Expert guide for writing, running, and debugging Playwright end-to-end tests against web applications. Use when testing a Flutter web app or any web frontend with the Playwright MCP server or npx playwright CLI.
---

# Playwright Expert

Authoritative guide for E2E testing with Playwright, based on official best practices from playwright.dev.

---

## Core Philosophy

| Principle | Guidance |
|---|---|
| **Test user-visible behaviour** | Assert what the user sees and interacts with — not internal implementation details, CSS classes, or function names |
| **Make tests isolated** | Each test runs independently with its own browser context, local storage, and cookie state |
| **Avoid third-party deps** | Mock external API calls with `page.route()` instead of hitting live services in tests |
| **Use web-first assertions** | Always `await expect(locator).toBeVisible()` — never `expect(await locator.isVisible()).toBe(true)` |

---

## Preferred Locators (priority order)

```ts
page.getByRole('button', { name: 'Save' })      // ✅ best — uses ARIA role
page.getByLabel('Email address')                  // ✅ form fields
page.getByPlaceholder('Enter password')           // ✅ inputs
page.getByText('Welcome back')                    // ✅ visible text
page.getByTestId('submit-btn')                    // ✅ data-testid attribute
page.locator('.some-class')                       // ❌ avoid — brittle
page.locator('//div[1]/span')                     // ❌ avoid — XPath breaks easily
```

---

## Test File Structure (TypeScript)

```ts
import { test, expect } from '@playwright/test';

test.describe('Feature: Recipe Management', () => {
  test.beforeEach(async ({ page }) => {
    // shared setup — navigate + authenticate
    await page.goto('http://localhost:PORT');
  });

  test('should display empty state when no recipes exist', async ({ page }) => {
    await expect(page.getByText('No snack recipes yet')).toBeVisible();
  });

  test('should create a new recipe', async ({ page }) => {
    await page.getByRole('button', { name: 'Add Recipe' }).click();
    await page.getByLabel('Title').fill('Nachos');
    await page.getByRole('button', { name: 'Save' }).click();
    await expect(page.getByText('Nachos')).toBeVisible();
  });
});
```

---

## Authentication Pattern

Store credentials in `tester-credentials.json` (gitignored). Re-use auth state across tests:

```ts
// playwright.config.ts
import { defineConfig } from '@playwright/test';
export default defineConfig({
  globalSetup: './global-setup.ts',  // handles login once
  use: {
    storageState: 'playwright/.auth/user.json',  // reused by every test
  },
});

// global-setup.ts
import { chromium } from '@playwright/test';
import creds from './tester-credentials.json';

export default async function globalSetup() {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto(creds.baseUrl);
  await page.getByLabel('Email').fill(creds.email);
  await page.getByLabel('Password').fill(creds.password);
  await page.getByRole('button', { name: 'Sign in' }).click();
  await page.context().storageState({ path: 'playwright/.auth/user.json' });
  await browser.close();
}
```

---

## Flutter Web Specifics

Flutter renders to a `<canvas>` / semantic tree. To make elements testable:

1. **Enable accessibility/semantics** in test entry point:
   ```dart
   // In Flutter web, semantics are auto-enabled for accessibility tools.
   // For Playwright, ensure the app is built with --web-renderer html (not canvaskit)
   // so DOM elements are present:
   flutter run -d chrome --web-renderer html
   ```

2. **Use semantic labels** in Flutter widgets:
   ```dart
   ElevatedButton(
     onPressed: onSave,
     child: const Text('Save Recipe'),  // Playwright: getByText('Save Recipe')
   )
   Semantics(
     label: 'Recipe title input',
     child: TextField(...),             // Playwright: getByLabel('Recipe title input')
   )
   ```

3. **Wait for Flutter to finish rendering** before asserting:
   ```ts
   // Flutter web may need a short wait after navigation
   await page.waitForLoadState('networkidle');
   await expect(page.getByText('All About Snacks')).toBeVisible();
   ```

---

## Running Tests

```bash
# Install once
npm init playwright@latest

# Run all tests
npx playwright test

# Run with UI mode (time-travel debugger)
npx playwright test --ui

# Run specific file
npx playwright test tests/auth.spec.ts

# Debug with inspector
npx playwright test --debug

# Generate locators interactively
npx playwright codegen http://localhost:PORT

# Show last HTML report
npx playwright show-report
```

---

## Soft Assertions (for multi-check tests)

```ts
// Don't stop on first failure — collect all failures
await expect.soft(page.getByTestId('title')).toHaveText('Nachos');
await expect.soft(page.getByTestId('servings')).toHaveText('2 servings');
// always check at end:
expect(test.info().errors).toHaveLength(0);
```

---

## Playwright Config Template

```ts
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  retries: process.env.CI ? 2 : 0,
  reporter: 'html',
  use: {
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
  ],
});
```