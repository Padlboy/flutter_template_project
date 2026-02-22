# Design Spec: All About Snacks — Mobile App

**Figma File:** [All-About-Snacks-Mobile-App](https://www.figma.com/design/tyfMigKa4h2SWekn6Vbl31/All-About-Snacks-Mobile-App)  
**fileKey:** `tyfMigKa4h2SWekn6Vbl31`  
**Target:** Flutter (Dart)  
**Viewport:** 390 × 844 pt (iPhone 14-size base)

---

## Design Tokens

### Colors

| Token name         | Hex value   | Usage                                 |
|--------------------|-------------|---------------------------------------|
| `primary`          | `#8B3C7F`   | App bar, bottom bar, buttons          |
| `background`       | `#F4F1F1`   | Screen background                     |
| `surface`          | `#FFFFFF`   | Cards, modal panels                   |
| `surfaceVariant`   | `#D9D9D9`   | Search field, disabled placeholders   |
| `onPrimary`        | `#FFFFFF`   | Icons / text on primary color         |
| `onBackground`     | `#000000`   | Body text on background               |
| `categoryCircle`   | `#8B3C7F`   | Category list avatar circles          |
| `shadow`           | `rgba(0,0,0,0.25)` | Card drop shadows              |
| `divider`          | `#000000`   | Menu divider lines                    |

### Typography

| Token                 | Font             | Size  | Weight  | Notes                          |
|-----------------------|------------------|-------|---------|--------------------------------|
| `displayLarge`        | Fraunces         | 24 sp | Bold    | Category/screen headings       |
| `bodyLarge`           | Fraunces         | 20 sp | Regular | Menu items, recipe titles      |
| `bodyMedium`          | Fraunces         | 16 sp | Regular | Sub-labels, helper texts       |
| `labelSmall`          | Fraunces         | 12 sp | Regular | e.g. serving / time info       |

> **Font:** `Fraunces` (variable, `SOFT=0, WONK=1`). Add to pubspec via `google_fonts` or bundle the ttf.

### Spacing (based on 8 pt grid)

| Token   | Value  |
|---------|--------|
| `xs`    | 4 pt   |
| `sm`    | 8 pt   |
| `md`    | 14 pt  |
| `lg`    | 16 pt  |
| `xl`    | 24 pt  |
| `xxl`   | 28 pt  |

### Border Radii

| Token          | Value  | Used on                      |
|----------------|--------|------------------------------|
| `cardRadius`   | 28 pt  | Recipe cards                 |
| `panelRadius`  | 29 pt  | Slide-out menu card          |
| `chipRadius`   | 21 pt  | Search bar, category badges  |
| `buttonRadius` | 22 pt  | CTA buttons (e.g., new category) |
| `imageRadius`  | 1 pt   | Recipe images (slightly rounded) |
| `iconRadius`   | 41 pt  | Bear/character image frame   |

### Shadows / Elevation

| Token        | Value                            |
|--------------|----------------------------------|
| `cardShadow` | `offset(0,4) blur(4) rgba(0,0,0,0.25)` |

---

## Screens

### 1. Front Site (Home Feed) — nodeId `201:3`

**Purpose:** Main scrollable feed showing snack/recipe cards.

**Layout:**
- Full-screen vertical scroll
- `AppBar` (height 70 pt) — purple `#8B3C7F`  
  - Left: hamburger menu icon (white)  
  - Center: "All About Snacks" logo (SVG)  
  - Right: cart icon + search icon (both white)
- Content: vertically stacked `RecipeCard` widgets with `margin(horizontal: 17, top: 86 from top of screen)`, spaced ~15 pt apart
- `BottomAppBar` (height 70 pt) — purple `#8B3C7F`  
  - Center: FAB `+` button (white icon, circular)

**RecipeCard:**
- Width: 356 pt, height: 363 pt
- Border radius: 28 pt, `clipBehavior: Clip.hardEdge`
- Image section: 292 pt tall, `BoxFit.cover`, subtle shadow
- Label section: 71 pt, white background, centered `Fraunces 20 sp` text

---

### 2. RegisterMenü (Navigation Drawer) — nodeId `202:2`

**Purpose:** Slide-out navigation menu with app sections.

**Layout:**
- Full-screen background color `#F4F1F1`
- White rounded card (`#FFFFFF`, border 1 pt black, radius 29 pt, size 361 × 670 pt) at position (13, 87)
- Gray search/header area (radius 21 pt) at top of card
- Menu items (full-width list, `Fraunces 20 sp`):
  1. **Zu den Snacks** — with right chevron
  2. **neuen Snack hinzufügen >**
  3. **Einkaufsliste >**
- Each item separated by a thin black divider line
- Bear illustration image filling bottom portion of the card (radius 41 pt)
- App bar + bottom bar same as Front Site

---

### 3. Zu den Snacks — Category Overview — nodeId `202:108`

**Purpose:** List of snack categories with add/edit/delete actions.

**Layout:**
- White rounded panel (361 × 670 pt, radius 29 pt) with border
- Header: back/navigation area
- Category list items (height 73 pt each):
  - Left: purple circle avatar (`#8B3C7F`, ~38 pt)
  - Label: `Fraunces 20 sp`
  - Right side icons: pencil (edit), trash (delete), chevron-right
  - Rows for: **zu den Snacks!**, **Frühstück**, **Mittagessen**, **Abendessen**
- At bottom: purple pill button "i will a neue Kategorie" (radius 22 pt, `#8B3C7F` bg, white text)

---

### 4. Zu den Snacks — Category Detail / Edit — nodeId `0:3`

**Purpose:** Add or edit a category with a title and icon.

**Layout:**
- White panel (361 × 670 pt, radius 29 pt)
- **Section: Kategorie Titel**
  - Label text: `Fraunces 16 sp bold` "Titel der Kategorie"
  - Input: `Fraunces 24 sp` (initial value "Curry"), rounded rect input field
- **Section: Kategorie Icon**
  - Label: "Kategorie Icon"
  - Icon picker area: rounded rect, 302 × 236 pt, contains a vector icon at center
- **Two CTA buttons** (233 × 43 pt, radius 22 pt each):
  - Submit: "jas das passt so" (confirm)
  - Cancel: "nas i will zurück" (cancel)

---

## App Architecture Recommendation

```
lib/
  design/
    app_colors.dart        ← color tokens
    app_typography.dart    ← text style tokens
    app_spacing.dart       ← spacing constants
    app_theme.dart         ← MaterialTheme combining all tokens
  screens/
    home/
      home_screen.dart     ← Front Site
    menu/
      menu_drawer.dart     ← RegisterMenü
    categories/
      category_list_screen.dart   ← Kategorie Übersicht
      category_edit_screen.dart   ← Kategorie Detail/Edit
  widgets/
    recipe_card.dart       ← RecipeCard widget
    app_bar.dart           ← shared AppBar
    bottom_bar.dart        ← shared BottomAppBar + FAB
    category_list_tile.dart
```

---

## Flutter Implementation Notes

1. **Font:** Use `google_fonts` package → `GoogleFonts.fraunces(...)` to apply Fraunces. No custom font bundling required.
2. **AppBar:** Use `PreferredSize` with height 70, color `AppColors.primary`. Left icon opens the `Drawer`.
3. **Drawer:** Custom `Drawer` widget; content is a white rounded card overlaid on the scaffold background.
4. **RecipeCard:** `ClipRRect` with `borderRadius: 28 pt`, child `Stack` containing `Image.network` + a `Positioned` bottom label box.
5. **Category list tile:** `ListTile` with custom `leading` (CircleAvatar purple), `trailing` Row (icon buttons + chevron).
6. **FAB:** `FloatingActionButton` with `backgroundColor: Colors.white`, icon `Icons.add` in primary color. Use `FloatingActionButtonLocation.centerDocked` with `BottomAppBar`.
7. **Scrolling home feed:** `ListView.builder` or `SingleChildScrollView` > `Column`.
8. **No navigation framework specified** — use Flutter's built-in `Navigator` or add `go_router` if deep linking is needed.

---

## Figma Reference

| Screen               | nodeId    | Direct link |
|----------------------|-----------|-------------|
| Front Site (Home)    | `201:3`   | [Open in Figma](https://www.figma.com/design/tyfMigKa4h2SWekn6Vbl31/All-About-Snacks-Mobile-App?node-id=201-3) |
| RegisterMenü         | `202:2`   | [Open in Figma](https://www.figma.com/design/tyfMigKa4h2SWekn6Vbl31/All-About-Snacks-Mobile-App?node-id=202-2) |
| Category Overview    | `202:108` | [Open in Figma](https://www.figma.com/design/tyfMigKa4h2SWekn6Vbl31/All-About-Snacks-Mobile-App?node-id=202-108) |
| Category Detail/Edit | `0:3`     | [Open in Figma](https://www.figma.com/design/tyfMigKa4h2SWekn6Vbl31/All-About-Snacks-Mobile-App?node-id=0-3) |
