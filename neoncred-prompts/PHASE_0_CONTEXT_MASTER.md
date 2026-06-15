# NEONCRED — PHASE 0: MASTER CONTEXT & ARCHITECTURE
## Design-First Spec for Kiro / Antigravity Codex
### Використовувати як стартовий контекст перед кожною фазою

---

> **ІНСТРУКЦІЯ ДЛЯ AI-АГЕНТА**
>
> Цей файл — єдине джерело правди про архітектуру проєкту.
> Прочитай його ПОВНІСТЮ перед будь-якими змінами в коді.
> Не вигадуй нові патерни — слідуй тому, що вже є в проєкті.

---

## 1. ІДЕНТИЧНІСТЬ ПРОЄКТУ

| Поле | Значення |
|------|----------|
| Назва | **NEONCRED** |
| Платформа | Flutter (Dart) 3.44+ з Impeller renderer |
| Архітектура | Clean Architecture, feature-first |
| Package | `com.neoncred.neoncred` |
| Мова UI | Українська (primary), English (secondary) |
| Естетика | Cyberpunk / Neon Dark |

---

## 2. ІСНУЮЧА АРХІТЕКТУРА (НЕ ЗМІНЮВАТИ)

### 2.1 Навігація — `lib/core/navigation/app_router.dart`

- GoRouter з Riverpod провайдером
- 40+ маршрутів вже налаштовані
- ShellRoute з ShellScaffold: 5 табів (Home, Analytics, History, Streak, Settings)
- Redirect-логіка: Dopamine Detox блокування, onboarding flow контроль

**Правило:** Нові маршрути додавати через існуючий GoRouter провайдер.
Не створювати паралельну навігацію.

### 2.2 База даних — `lib/data/database.dart`

- Drift ORM, schemaVersion: **20** (не знижувати!)
- 23 існуючі таблиці з міграціями v1→v20
- Атомарні транзакції: `saveDepositWithAllocations()`, `softDeleteDeposit()`
- Всі грошові значення в **копійках** (minor units, int)

**Правило:** Нові таблиці додавати як `schemaVersion: 21+`.
Кожна нова таблиця — окремий крок міграції.

### 2.3 Shell Scaffold — `lib/features/dashboard/screens/shell_scaffold.dart`

- Material 3 NavigationBar
- Ambient cyberpunk background (radial glow blobs)
- Penalty Glitch Wrapper (shake + color filter + scanlines)
- Dopamine Detox grayscale фільтр

### 2.4 State Management — Riverpod

Існуючі провайдери (НЕ дублювати):
```
savingsProvider, petsProvider, partnersProvider, questsProvider,
freezersProvider, karmaProvider, xpProvider, leaderboardProvider,
priceHunterProvider, dailyBonusProvider, merchantProvider,
subscriptionsProvider, zenModeProvider, localeProvider
```

**Правило:** Кожна нова фіча — окремий `NotifierProvider` або `FutureProvider`.
Зберігати в `lib/features/{feature_name}/providers/`.

---

## 3. ДИЗАЙН-СИСТЕМА (СУВОРО ДОТРИМУВАТИСЬ)

```dart
// Кольори
background:         Color(0xFF0A0E17)
backgroundElevated: Color(0xFF111827)
backgroundSurface:  Color(0xFF1A1F2E)
cyan:               Color(0xFF00F0FF)  // Electric Cyan
purple:             Color(0xFF6B00FF)  // Neon Purple
green:              Color(0xFF00FF88)
red:                Color(0xFFFF3366)
orange:             Color(0xFFFF6B00)
textPrimary:        Color(0xFFFFFFFF)
textSecondary:      Color(0xB3FFFFFF)

// Градієнт
LinearGradient([Color(0xFF00F0FF), Color(0xFF6B00FF)])

// Шрифти
Headings: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4)
Body:     GoogleFonts.shareTechMono()

// ВАЖЛИВО: withOpacity() НЕ withValues() (Flutter 3.44)
// ВАЖЛИВО: Жодних емодзі в UI
// ВАЖЛИВО: Весь UI текст — Українською
```

---

## 4. СТРУКТУРА ФАЙЛІВ ДЛЯ НОВИХ ФІЧ

Кожна нова фіча повинна мати цю структуру:

```
lib/features/{feature_name}/
  screens/
    {feature_name}_screen.dart      # Головний екран
  providers/
    {feature_name}_provider.dart    # Riverpod провайдер
  services/
    {feature_name}_service.dart     # Бізнес-логіка + AI
  widgets/
    {widget_name}_widget.dart       # Reusable компоненти (якщо потрібні)
```

---

## 5. ІНТЕГРАЦІЯ З AI (OpenRouter)

Використовувати існуючий `OpenRouterService` з `lib/core/services/`.
API ключ з `EnvProvider` (`.env` файл).
Модель: DeepSeek або GPT-4o через OpenRouter.

---

## 6. ПРАВИЛА ДЛЯ ВСІХ ФАЗ

1. **Не зламати існуюче** — перед змінами перевір що вже є
2. **schemaVersion** — тільки збільшувати, ніколи не зменшувати
3. **Копійки** — всі суми в int (minor units)
4. **withOpacity()** — не withValues()
5. **Без емодзі** — нуль emoji символів
6. **Українська** — весь текст в UI
7. **Орbitron + ShareTechMono** — тільки ці шрифти
8. **Існуючий router** — додавати маршрути, не замінювати

---

*Цей файл завжди чинний. Версія: NEONCRED v2.0 | Червень 2026*
