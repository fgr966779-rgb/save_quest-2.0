# NEONCRED — KIRO STEERING FILE
## `.kiro/steering/neoncred-context.md`
### Цей файл Kiro читає автоматично при кожному запиті в проєкті

---

## PROJECT IDENTITY

You are working on **NEONCRED** — a cyberpunk gamified savings Flutter app.
Package: `com.neoncred.neoncred`
Framework: Flutter 3.44+ (Dart), Riverpod 2.x, Drift ORM, GoRouter 14.x

---

## CRITICAL RULES — NEVER VIOLATE

1. **withOpacity()** — ALWAYS use `withOpacity()`, NEVER `withValues()` (Flutter 3.44)
2. **Minor units** — ALL monetary values stored as `int` kopiyky (not hryvnia)
3. **No emojis** — Zero emoji characters anywhere in UI
4. **Ukrainian UI** — All user-facing text in Ukrainian
5. **Orbitron + ShareTechMono** — Only these Google Fonts
6. **schemaVersion** — Only increment, never decrease (currently at 20+)
7. **Existing router** — Add routes to existing GoRouter, never replace it
8. **Existing providers** — Check for existing Riverpod providers before creating new ones

---

## COLORS (use these exact values)

```dart
background:         Color(0xFF0A0E17)
backgroundElevated: Color(0xFF111827)
backgroundSurface:  Color(0xFF1A1F2E)
cyan:               Color(0xFF00F0FF)
purple:             Color(0xFF6B00FF)
green:              Color(0xFF00FF88)
red:                Color(0xFFFF3366)
orange:             Color(0xFFFF6B00)
textPrimary:        Color(0xFFFFFFFF)
textSecondary:      Color(0xB3FFFFFF)
```

---

## FILE STRUCTURE FOR NEW FEATURES

```
lib/features/{name}/
  screens/{name}_screen.dart
  providers/{name}_provider.dart
  services/{name}_service.dart
  widgets/           (optional)
```

---

## EXISTING INFRASTRUCTURE (do not duplicate)

- Navigation: `lib/core/navigation/app_router.dart` (GoRouter + ShellRoute)
- Database: `lib/data/database.dart` (Drift, schemaVersion 20+)
- AI Service: `lib/core/services/open_router_service.dart`
- Price Service: `lib/core/services/serp_api_service.dart`
- Env: `lib/core/config/env_provider.dart` (loads .env API keys)
- Shell: `lib/features/dashboard/screens/shell_scaffold.dart`

---

## WHEN ADDING A NEW FEATURE

1. Check `app_router.dart` — does the route already exist?
2. Check `database.dart` — does the table already exist?
3. Check existing providers — is there already a provider for this data?
4. Follow `lib/features/` structure
5. Add migration: `if (from < NEW_VERSION) { await m.createTable(...) }`
6. Add route to GoRouter
7. Add feature card to Dashboard GridView

---

*NEONCRED Kiro Steering | Always active | June 2026*
