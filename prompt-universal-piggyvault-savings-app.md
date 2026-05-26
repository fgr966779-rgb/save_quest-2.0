# PIGGYVAULT — UNIVERSAL AI AGENT PROMPT
## Dual-Goal Gamified Savings Tracker · Mobile App · Full Build Specification
### Version 1.0 | Universal (Claude Code / Gemini 2.5 Pro / GPT-4o / Cursor / Cline)

---

> **AGENT INSTRUCTIONS — READ BEFORE ACTING**
>
> You are a world-class senior mobile engineer and UI/UX architect tasked with building a **complete, production-ready mobile application** from scratch. This document is your single source of truth. It is intentionally exhaustive — every section carries weight. Do not skim, do not interpolate silently, do not invent features not described here.
>
> **Execution protocol:**
> 1. Read this entire document before writing a single line of code.
> 2. Think through the full architecture before scaffolding.
> 3. Build iteratively: foundation → data layer → navigation → screens → animations → polish.
> 4. After each major milestone, verify it against the relevant section of this spec.
> 5. Where this spec leaves room for creative freedom (marked with 🎨), use it generously. Where it is prescriptive, follow it precisely.
> 6. Ask for clarification only if a genuine contradiction exists — otherwise, proceed with professional judgment.

---

## PART 1 — PROJECT OVERVIEW

### 1.1 Application Identity

| Field | Value |
|---|---|
| App Name | **PiggyVault** (Ukrainian: «Скарбничка») |
| Tagline | *"Save with purpose. Win with style."* |
| Category | Personal Finance / Gamification / Lifestyle |
| Primary Purpose | Dual-goal gamified savings tracker for two simultaneous purchase targets |
| Target Audience | Young adults (18–35) passionate about gaming and tech |
| Platforms | iOS (primary) + Android (parity) |
| Minimum OS | iOS 16.0 / Android 8.0 (API 26) |
| Screen Count | ~75 screens / states / modal overlays |
| Localization | Ukrainian (primary), English (secondary) |
| Offline Support | Full offline capability; sync when online |

### 1.2 Core Mission Statement

PiggyVault transforms the mundane act of saving money into an engaging, visually stunning gaming experience. Two simultaneous savings goals sit at the heart of the app: a **PlayStation 5** and a **Gaming Monitor**. Users deposit money toward either or both goals, watch animated progress fill up their "vaults," earn achievements, maintain streaks, and celebrate milestones — all within a dark, cyberpunk-infused neon aesthetic that feels like a premium gaming product, not a bank app.

The app must feel **alive at all times**. Idle states should pulse gently. Actions should feel consequential and satisfying. Progress should be immediately visible and emotionally rewarding.

### 1.3 The Two Goals — Fixed Context

| Goal | Label | Icon Metaphor | Primary Accent Color |
|---|---|---|---|
| **Goal A** | PlayStation 5 | PS5 DualSense controller silhouette | Electric Cyan `#00E5FF` |
| **Goal B** | Gaming Monitor | Curved widescreen monitor silhouette | Neon Magenta `#FF00FF` |

Both goals exist simultaneously. The user sets a target price for each, a deadline (optional), and allocates deposits to either or both. Neither goal can be deleted — they can only be reset. The app is purpose-built for these two specific goals.

---

## PART 2 — FRAMEWORK & TECHNICAL STACK DECISION

### 2.1 Framework Recommendation

**Choose Flutter (Dart).** Justify this choice to the user in a brief in-code comment block at the top of `main.dart`. The justification:

- PiggyVault is **animation-heavy** by design — particle effects, vault fill animations, streak counters, confetti bursts, glassmorphism overlays. Flutter's custom rendering engine (Impeller, default on iOS and Android from Flutter 3.27+) delivers 60–120 FPS with precompiled shaders, eliminating animation jank entirely.
- **Pixel-perfect UI consistency** across iOS and Android is mandatory. The cyberpunk aesthetic requires precise control over every pixel. Flutter's widget tree provides this; React Native's bridge to native views introduces subtle rendering inconsistencies.
- The developer's existing ecosystem (Riverpod, Drift, GoRouter, Clean Architecture) maps directly.
- Flutter 3.41+ (May 2026) is production-stable with Impeller as default renderer.

### 2.2 Architecture

Follow **Clean Architecture** strictly:

```
lib/
├── core/
│   ├── constants/          # AppColors, AppSizes, AppStrings, AppDurations
│   ├── theme/              # AppTheme, TextStyles, ComponentThemes
│   ├── router/             # GoRouter configuration, route guards
│   ├── di/                 # Dependency injection (Riverpod providers)
│   ├── utils/              # CurrencyFormatter, DateUtils, AnimationUtils
│   └── errors/             # Failure classes, Either type
├── features/
│   ├── onboarding/         # Splash, Welcome, Setup wizard
│   ├── dashboard/          # Home screen, dual vault display
│   ├── deposit/            # Deposit flow, allocation, confirmation
│   ├── goals/              # Goal detail, history, projection
│   ├── achievements/       # Badges, milestones, trophy room
│   ├── streaks/            # Streak tracking, calendar heatmap
│   ├── analytics/          # Charts, statistics, projections
│   ├── settings/           # Profile, notifications, themes, reset
│   └── celebrations/       # Confetti, milestone modals, completion screen
└── shared/
    ├── widgets/            # Reusable design system components
    ├── animations/         # Shared animation controllers and builders
    └── extensions/         # BuildContext extensions, Color extensions
```

Each feature follows `data → domain → presentation` layers internally.

### 2.3 State Management

**Riverpod 2.x** (code generation with `@riverpod` annotation).

- Use `AsyncNotifierProvider` for data-fetching states.
- Use `NotifierProvider` for synchronous local state.
- Use `StreamProvider` for real-time deposit feeds.
- No `setState` anywhere in the feature layer — only in isolated micro-animation widgets within `shared/animations/`.

### 2.4 Local Database

**Drift (formerly Moor)** for structured relational data:

- `deposits` table: `id`, `amount`, `goal_id` (A or B), `note`, `created_at`, `type` (manual / scheduled / imported)
- `goals` table: `id`, `label`, `target_amount`, `current_amount`, `currency`, `deadline`, `created_at`, `color_hex`, `icon_key`
- `achievements` table: `id`, `key`, `unlocked_at`, `is_seen`
- `streaks` table: `id`, `date`, `has_deposit`, `amount`
- `settings` table: `key`, `value` (key-value pairs)

Use **Hive** for ephemeral app-state caching (last scroll position, animation states, onboarding completion flag).

### 2.5 Navigation

**GoRouter 14.x** with named routes and typed parameters.

Route structure:
```
/                        → SplashScreen
/onboarding              → OnboardingFlow (nested shell)
  /onboarding/welcome    → WelcomeScreen
  /onboarding/setup-a    → GoalSetupScreen (Goal A — PS5)
  /onboarding/setup-b    → GoalSetupScreen (Goal B — Monitor)
  /onboarding/currency   → CurrencySetupScreen
  /onboarding/ready      → ReadyScreen
/home                    → DashboardScreen (shell route with bottom nav)
  /home/deposit          → DepositScreen
  /home/analytics        → AnalyticsScreen
  /home/achievements     → AchievementsScreen
  /home/settings         → SettingsScreen
/deposit/confirm         → DepositConfirmScreen
/deposit/success         → DepositSuccessScreen
/goal/:id                → GoalDetailScreen
/goal/:id/history        → GoalHistoryScreen
/goal/:id/projection     → GoalProjectionScreen
/achievement/:key        → AchievementDetailScreen
/milestone/:goalId/:pct  → MilestoneScreen
/celebration/complete    → GoalCompleteScreen
/settings/notifications  → NotificationSettingsScreen
/settings/theme          → ThemeSettingsScreen
/settings/currency       → CurrencySettingsScreen
/settings/reset          → ResetConfirmScreen
/settings/about          → AboutScreen
```

### 2.6 Key Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.6.x
  riverpod_annotation: ^2.3.x
  drift: ^2.18.x
  drift_flutter: ^0.2.x
  hive_flutter: ^1.1.x
  go_router: ^14.x
  intl: ^0.19.x
  fl_chart: ^0.68.x
  confetti: ^0.7.x
  lottie: ^3.x
  flutter_animate: ^4.5.x
  shared_preferences: ^2.3.x
  flutter_local_notifications: ^17.x
  permission_handler: ^11.x
  animations: ^2.0.x       # Material motion transitions
  shimmer: ^3.0.x
  haptic_feedback: ^0.x
  freezed: ^2.5.x
  freezed_annotation: ^2.4.x
  json_annotation: ^4.9.x

dev_dependencies:
  build_runner: ^2.4.x
  riverpod_generator: ^2.4.x
  drift_dev: ^2.18.x
  hive_generator: ^2.0.x
  freezed: ^2.5.x
  json_serializable: ^6.8.x
  flutter_lints: ^4.x
  mocktail: ^1.0.x
```

---

## PART 3 — VISUAL DESIGN SYSTEM

### 3.1 Aesthetic Manifesto

PiggyVault inhabits a **dark cyberpunk / neon gaming** visual universe. Think: a high-end gaming peripheral product website crossed with a premium mobile fintech app, with the soul of a dungeon loot system. Every screen breathes this aesthetic. There is no room for "clean white corporate" energy here.

Key visual principles:
- **Dark-first**: All screens use deep dark backgrounds. Light mode does not exist in v1.0.
- **Neon accents**: Electric Cyan and Neon Magenta are the twin souls of the app — each assigned to one goal. They glow, they pulse, they bleed.
- **Glassmorphism**: Cards and modals use frosted-glass panels (semi-transparent dark backgrounds with subtle blur and luminous borders).
- **Depth**: Multiple z-layers. Background ambient particles, mid-layer cards, foreground interactive elements.
- **Typography**: Futuristic but legible. Numbers feel like HUD displays. Labels feel like system fonts from a sci-fi OS.

### 3.2 Color Palette

```dart
class AppColors {
  // === BACKGROUNDS ===
  static const Color background         = Color(0xFF080B14); // Near-black, deep navy
  static const Color backgroundElevated = Color(0xFF0D1120); // Cards, panels
  static const Color backgroundSurface  = Color(0xFF131827); // Input fields, chips
  static const Color backgroundOverlay  = Color(0x99080B14); // Modal overlays

  // === GOAL A — PlayStation 5 ===
  static const Color cyanPrimary        = Color(0xFF00E5FF); // Electric Cyan
  static const Color cyanSecondary      = Color(0xFF00B8CC); // Deeper Cyan
  static const Color cyanGlow           = Color(0x4000E5FF); // Glow effect (40% opacity)
  static const Color cyanDim            = Color(0xFF00596E); // Inactive/filled track

  // === GOAL B — Gaming Monitor ===
  static const Color magentaPrimary     = Color(0xFFFF00FF); // Neon Magenta
  static const Color magentaSecondary   = Color(0xFFCC00CC); // Deeper Magenta
  static const Color magentaGlow        = Color(0x40FF00FF); // Glow effect (40% opacity)
  static const Color magentaDim         = Color(0xFF590059); // Inactive/filled track

  // === NEUTRAL NEONS ===
  static const Color neonPurple         = Color(0xFF9B59FF); // Tertiary accent
  static const Color neonGold           = Color(0xFFFFD700); // Achievements, streaks
  static const Color neonGreen          = Color(0xFF00FF88); // Success states
  static const Color neonRed            = Color(0xFFFF2E4D); // Error states, warnings

  // === TEXT ===
  static const Color textPrimary        = Color(0xFFE8EEFF); // Main body text
  static const Color textSecondary      = Color(0xFF8896B3); // Subtitles, metadata
  static const Color textTertiary       = Color(0xFF4A5568); // Placeholders, disabled
  static const Color textOnDark         = Color(0xFF080B14); // Text on bright neon buttons

  // === BORDERS & DIVIDERS ===
  static const Color borderSubtle       = Color(0x1AFFFFFF); // 10% white
  static const Color borderAccent       = Color(0x33FFFFFF); // 20% white
  static const Color borderCyan         = Color(0x6600E5FF); // Cyan border glow
  static const Color borderMagenta      = Color(0x66FF00FF); // Magenta border glow

  // === GRADIENTS ===
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0F1E), Color(0xFF060910)],
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF0080CC)],
  );

  static const LinearGradient magentaGradient = LinearGradient(
    colors: [Color(0xFFFF00FF), Color(0xFF9900CC)],
  );

  static const LinearGradient dualGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF9B59FF), Color(0xFFFF00FF)],
  );
}
```

### 3.3 Typography

Font stack (in priority order):
1. **Orbitron** — Headlines, large numeric displays, goal titles. Futuristic geometric feel.
2. **Rajdhani** — Subheadings, card labels, navigation items. Slightly condensed, techy.
3. **Inter** — Body text, descriptions, settings, legal. Highly legible at small sizes.

```dart
class AppTextStyles {
  // DISPLAY — HUD-style large numbers
  static const TextStyle displayXL = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 48, fontWeight: FontWeight.w900,
    letterSpacing: 2.0, height: 1.0,
  );
  static const TextStyle displayL = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 36, fontWeight: FontWeight.w800,
    letterSpacing: 1.5,
  );
  static const TextStyle displayM = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 24, fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
  );

  // HEADINGS
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 28, fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );
  static const TextStyle h2 = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 22, fontWeight: FontWeight.w600,
  );
  static const TextStyle h3 = TextStyle(
    fontFamily: 'Rajdhani',
    fontSize: 18, fontWeight: FontWeight.w600,
  );

  // BODY
  static const TextStyle bodyL = TextStyle(
    fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w400, height: 1.5,
  );
  static const TextStyle bodyM = TextStyle(
    fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w400, height: 1.5,
  );
  static const TextStyle bodyS = TextStyle(
    fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w400, height: 1.4,
  );

  // LABELS & METADATA
  static const TextStyle label = TextStyle(
    fontFamily: 'Rajdhani', fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 1.2,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 0.3,
  );
  static const TextStyle monospace = TextStyle(
    fontFamily: 'Courier New', fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.5,
  );
}
```

### 3.4 Component Design Tokens

**Border Radius:**
- Chips, small tags: `6px`
- Buttons (standard): `12px`
- Cards, panels: `16px`
- Large modals, bottom sheets: `24px` (top corners only)
- Circular elements: `50%`

**Elevation via Glow (not drop shadows):**
- Level 1 (subtle): `BoxShadow(color: color.withOpacity(0.15), blurRadius: 8)`
- Level 2 (interactive hover): `BoxShadow(color: color.withOpacity(0.30), blurRadius: 16, spreadRadius: 2)`
- Level 3 (focused / active): `BoxShadow(color: color.withOpacity(0.50), blurRadius: 24, spreadRadius: 4)`

**Glassmorphism Panel:**
```dart
// Base recipe for all glass panels
decoration: BoxDecoration(
  color: AppColors.backgroundElevated.withOpacity(0.6),
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: AppColors.borderSubtle, width: 1),
  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20)],
)
// Apply BackdropFilter(filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12)) as parent
```

### 3.5 Animation Principles

- **Duration scale**: `fast = 150ms`, `medium = 300ms`, `slow = 600ms`, `dramatic = 1200ms`
- **Curves**: Use `Curves.easeOutCubic` for entrances, `Curves.easeInCubic` for exits, `Curves.elasticOut` for bouncy celebrations, `Curves.fastLinearToSlowEaseIn` for deposits.
- **Haptics**: Use `HapticFeedback.lightImpact()` on button taps, `HapticFeedback.mediumImpact()` on deposit confirmations, `HapticFeedback.heavyImpact()` on milestone unlocks. Never use haptics without a visible UI event.
- **Ambient animation**: All main screens have a slow ambient particle system in the background (gentle floating neon specks, ~30 particles, CPU-light using `CustomPainter`).
- **Principle**: Every user action must produce a visible, satisfying response within `100ms`. No silent button taps.

---

## PART 4 — CORE MECHANICS & BUSINESS LOGIC

### 4.1 Dual Vault System

Two vaults (Goal A: PS5, Goal B: Monitor) operate completely independently but are displayed together. Each vault has:

- **Target Amount** (`targetAmount: double`) — set during onboarding, editable in settings
- **Current Amount** (`currentAmount: double`) — sum of all deposits for this goal
- **Progress Percentage** (`progress = currentAmount / targetAmount`, clamped 0.0–1.0)
- **Deadline** (`deadline: DateTime?`) — optional. If set, enables projection features.
- **Currency** — shared app-level setting (UAH primary, EUR/USD secondary)
- **Milestone Flags** — boolean flags at 10%, 25%, 50%, 75%, 90%, 100%

### 4.2 Deposit Flow

A deposit consists of:
1. **Amount input** — numeric keyboard with currency formatting
2. **Goal allocation** — assign to Goal A, Goal B, or split (custom % split)
3. **Optional note** — free text up to 100 characters
4. **Confirmation** — animated summary before commit
5. **Success celebration** — confetti + haptic + sound (optional)
6. **Post-deposit state update** — check for new milestone unlocks

**Split deposit rules:**
- When split mode is selected, two sliders appear (one per goal). They are linked: A% + B% = 100%. Dragging one adjusts the other.
- Display exact amounts for each goal as the sliders move in real time.

### 4.3 Milestone System

Milestones trigger automatically when progress crosses a threshold:

| Threshold | Title (EN) | Title (UA) | Trigger |
|---|---|---|---|
| 10% | "First Spark" | «Перша іскра» | Animated spark burst |
| 25% | "Quarter Power" | «Чверть шляху» | Pulsing glow ring |
| 50% | "Halfway There" | «Половина мети» | Split-screen celebration |
| 75% | "Almost Ready" | «Майже готово» | Screen edge neon flash |
| 90% | "Locked In" | «Фінальний ривок» | Countdown timer appears |
| 100% | "VAULT UNLOCKED" | «СКАРБНИЧКУ ВІДКРИТО» | Full-screen epic celebration |

Each milestone shows a dedicated screen overlay (not a modal — it takes over the screen) with an animation, title, description, and a "Continue" CTA. Milestones are stored in the database and marked as seen.

### 4.4 Streak System

A **deposit streak** counts consecutive days that have at least one deposit (to either goal).

- Streak counter is displayed prominently on the Dashboard.
- Streak resets to 0 if a full calendar day passes with no deposit.
- **Streak Freeze**: User can earn (via achievements) or purchase up to 3 streak freeze tokens. Freezes survive one missed day.
- A heatmap calendar (GitHub-style) shows deposit activity over the past 3 months.

**Streak Milestones:**
- 3 days: Bronze Shield badge
- 7 days: Silver Flame badge
- 14 days: Gold Flame badge
- 30 days: Platinum Crown badge
- 60 days: Diamond Infinity badge
- 100 days: LEGENDARY — animated holographic badge

### 4.5 Achievement System

A collection of **50+ achievements** (badges) that users unlock through actions. Categories:

| Category | Examples |
|---|---|
| First Steps | First deposit, set both goals, add first note |
| Milestone | Each milestone for each goal (12 total) |
| Streak | Streak milestones as above (6 total) |
| Amount | Deposit single amounts of 100/500/1000/5000 UAH |
| Speed | Three deposits in one day, 5 in one week |
| Balance | Maintain equal % progress on both goals |
| Dedication | 10/25/50/100 total deposits |
| Special | Deposit on your birthday, deposit on New Year's Day |

Each achievement has: `key` (unique string ID), `title`, `description`, `icon` (custom SVG/Lottie), `rarity` (Common/Rare/Epic/Legendary), `unlockedAt`.

### 4.6 Projection Engine

If a deadline is set for a goal, the app computes:
- **Required daily savings** = `(targetAmount - currentAmount) / remainingDays`
- **Projected completion date** = based on average daily savings over last 14 days
- **On-track status**: `ahead` / `on-track` / `at-risk` / `critical`

Display this data in the Analytics screen and subtly on the Goal Detail screen.

### 4.7 Currency Support

Support UAH (₴), USD ($), EUR (€). Currency is an app-level setting, not per-goal. All amounts stored in the database in the selected base currency. No live exchange rates in v1.0 — display note: "Prices set manually."

---

## PART 5 — SCREEN SPECIFICATIONS

> **Note:** Each screen description covers: **Purpose → Layout → Key Elements → States → Micro-interactions → Animations → Transitions**.
> 🎨 marks areas of creative freedom — the agent may design these as it sees fit within the established aesthetic.

---

### SCREEN GROUP 1: ONBOARDING FLOW (5 screens)

---

#### SCREEN 1.1 — Splash Screen

**Purpose:** App identity reveal. Brand moment. Auth/DB initialization.

**Duration:** 2.5 seconds max, then auto-navigate.

**Layout:** Full-screen dark canvas. Dead center: PiggyVault logo.

**Logo Animation Sequence (must match this timing):**
1. `0ms–400ms`: Screen is pure black.
2. `400ms–700ms`: A single electric cyan horizontal line materializes from center outward, like a laser scan. Width reaches full screen.
3. `700ms–1000ms`: The line collapses vertically, becoming a single glowing point.
4. `1000ms–1500ms`: From that point, the **PiggyVault logo** assembles — the piggy bank icon (stylized geometric, neon-outlined) drops in from above while the wordmark "PiggyVault" types itself character by character, each character briefly glowing before settling.
5. `1500ms–2000ms`: A neon grid (faint, perspective-projected) expands outward from behind the logo.
6. `2000ms–2500ms`: Tagline fades in below: *"Save with purpose. Win with style."*

**States:**
- Default: animation plays in sequence.
- Error state (DB init failure): After animation, replace tagline with "System Error — Tap to retry" in `neonRed`. Provide retry handler.

**Transition out:** Crossfade to `/onboarding/welcome` (if first launch) or `/home` (if returning user).

🎨 **Creative freedom:** The exact shape of the logo's assembly sequence can be refined for maximum cinematic impact. The neon grid pattern direction and density are at the agent's discretion.

---

#### SCREEN 1.2 — Welcome Screen

**Purpose:** First human touchpoint. Establish emotional tone. Gate to setup.

**Layout:**
- Top 60%: Full-bleed illustration area.
- Bottom 40%: Glass panel with text and CTA.

**Illustration (top area):** 🎨 A stylized scene — a glowing treasure vault door floating in digital space, cracked slightly open with cyan and magenta light spilling out. Abstract pixel data streams flow around it. The illustration should feel like a premium gaming poster.

**Bottom panel content:**
- Super-large headline: **"YOUR GOALS. YOUR VAULT."** (Orbitron, displayL, white)
- Subheading: "Track your dream gaming setup — one deposit at a time." (Inter bodyM, textSecondary)
- Divider line with small ornamental glyph (⬡ or similar) at center
- Two small teaser icons: PS5 DualSense silhouette (cyan-tinted) + Monitor silhouette (magenta-tinted)
- Primary CTA button: **"START THE MISSION"** — full-width, cyan gradient, Orbitron font
- Secondary text link: "I already have an account" (textSecondary, small — reserved for future cloud sync)

**Micro-interactions:**
- The vault illustration slowly pulsates — the light from within the vault door expands and contracts with a 4-second cycle.
- The two teaser goal icons have a slow alternating glow — cyan then magenta, like a heartbeat.
- The CTA button has a living neon border that traces its perimeter continuously.

**Entry animation:** Slide up from bottom with fade-in, `600ms`, `easeOutCubic`.

**Exit transition:** The vault door illustration animates to fully open, light floods the screen (white flash frame), then transitions to Goal Setup Screen A via slide-right.

---

#### SCREEN 1.3 — Goal Setup Screen (replicated for Goal A and Goal B)

**Purpose:** User sets the target price for one goal. Appears twice: once for PS5, once for Monitor.

**For Goal A (PS5):** Accent = Cyan. Icon = DualSense controller.
**For Goal B (Monitor):** Accent = Magenta. Icon = curved monitor.

**Layout:**
- Step indicator at top: "STEP 1 OF 3" / "STEP 2 OF 3" (dots + text, accent-colored active dot)
- Large goal icon (120×120px, neon-outlined) centered, slightly above midpoint
- Goal name label below icon (e.g., "PlayStation 5", Rajdhani h2, accent color)
- Instruction text: "Set your target price" (Inter bodyM, textSecondary)
- **Price input field**: Custom component — large centered number display (Orbitron displayL), currency prefix on left. No traditional text field border — just a glowing underline in accent color. Numeric keyboard auto-opens.
- Preset quick-select chips below input: Common PS5 prices (e.g., ₴21,999 / ₴24,999 / ₴26,999). Tapping a chip fills the amount.
- Small toggle below: "Set a deadline?" — if toggled ON, a date picker appears (native, styled to match app).
- "CONTINUE" button at bottom, disabled until amount > 0, enabled state has glow animation.

**States:**
- Empty: Input shows "0" dimmed, CTA disabled with reduced opacity.
- Filled: Number glows in accent color, CTA becomes active.
- Preset selected: Chip gets filled background, accent border, scale-up animation.
- With deadline: Date picker row slides in smoothly below deadline toggle.

**Micro-interactions:**
- As user types, each digit "snaps" in with a tiny scale-up animation (`150ms, elasticOut`).
- The goal icon slowly rotates 360° over 8 seconds (continuous, restart).
- Currency prefix has a subtle glow that intensifies as the number grows.

**Exit transition:** Slide left → Goal B setup (or Currency setup if coming from B).

---

#### SCREEN 1.4 — Currency Setup Screen

**Purpose:** One-time currency selection.

**Layout:** Simple centered card.
- Heading: "SELECT YOUR CURRENCY"
- Three large segmented buttons: UAH (₴) / USD ($) / EUR (€)
- Each button shows the flag emoji + currency name + symbol.
- Selected state: Filled with dual gradient, text in dark.
- Note text: "You can change this anytime in Settings."
- "CONTINUE" CTA.

**States:** Always has one selected (UAH default).

---

#### SCREEN 1.5 — Ready Screen (Onboarding Complete)

**Purpose:** Climactic reveal of both configured vaults before entering the app. Emotional peak of onboarding.

**Layout:** Full-screen celebration.

**Animation sequence:**
1. Black screen → burst of particles from center
2. Two vault cards materialize — one for PS5 (cyan-tinted), one for Monitor (magenta-tinted) — sliding in from left and right respectively
3. Both cards show the configured target amount with a typewriter animation
4. Progress bars fill from 0% with a satisfying fill animation (they're at 0%, showing the journey ahead)
5. Text fades in: **"YOUR VAULT IS READY"** (Orbitron, displayL, dual gradient text)
6. Subtext: "Time to start saving." (Rajdhani)
7. Confetti burst (small, neon-colored particles in cyan and magenta)

**CTA:** "ENTER THE VAULT" — full-width button, dual gradient, Orbitron.

**Transition:** Dramatic zoom-into-screen transition (scale down to black, then crossfade to Dashboard).

---

### SCREEN GROUP 2: DASHBOARD / HOME (7 screens/states)

---

#### SCREEN 2.1 — Dashboard (Main Home Screen)

**Purpose:** The app's beating heart. Displays real-time status of both goals at a glance, quick-access deposit, and key stats. User returns here dozens of times per week.

**Layout (top to bottom):**

```
┌─────────────────────────────────┐
│  [Avatar] PiggyVault  [🔔] [⚙]  │  ← Header
├─────────────────────────────────┤
│         🔥 12-day streak         │  ← Streak Banner
├─────────────────────────────────┤
│  ╔═══════════════════════════╗  │
│  ║  GOAL A: PS5              ║  │  ← Vault Card A (cyan)
│  ║  ₴12,450 / ₴24,999        ║  │
│  ║  [████████░░░░] 49.8%     ║  │
│  ╚═══════════════════════════╝  │
│  ╔═══════════════════════════╗  │
│  ║  GOAL B: Monitor          ║  │  ← Vault Card B (magenta)
│  ║  ₴4,200 / ₴14,999         ║  │
│  ║  [███░░░░░░░░░] 28.0%     ║  │
│  ╚═══════════════════════════╝  │
├─────────────────────────────────┤
│    [Combined Progress Ring]      │  ← Dual Progress Composite
├─────────────────────────────────┤
│  Total Saved  │  This Week       │  ← Quick Stats Row
│  ₴16,650      │  ₴850            │
├─────────────────────────────────┤
│   [Recent deposits mini-list]    │  ← Last 3 deposits
├─────────────────────────────────┤
│  🏠  💰  📊  🏆  ⚙              │  ← Bottom Navigation
└─────────────────────────────────┘
```

**Header:**
- Left: Small avatar circle (initials or custom emoji — no photo required). Tap → Settings.
- Center: "PiggyVault" logo wordmark (small, Rajdhani).
- Right: Bell icon (notification badge if unread) + optional settings gear.

**Streak Banner:**
- Full-width pill-shaped banner, neon gold color scheme.
- Shows: 🔥 flame icon + "{N}-day streak" in Orbitron font.
- Subtle animated shimmer passes across it every 5 seconds.
- Tap → Streak detail screen (streak calendar).
- **State: No streak** (0 days): Banner shows "Start your streak today! Make a deposit." in subdued gray. No flame icon.
- **State: Frozen streak**: Shows 🧊 ice icon + "Streak frozen — deposit today to resume".

**Vault Cards (A and B):**
Each card is a glass panel with:
- Goal icon (top-right corner, 40px, accent-tinted)
- Goal label ("PS5" / "Gaming Monitor", Rajdhani h3, accent color)
- Current amount (Orbitron displayM, accent color)
- "/" separator + target amount (Rajdhani, textSecondary, smaller)
- **Neon progress bar**: Custom-painted `CustomPainter`. Background track is dimmed accent. Filled portion glows intensely in accent color. A small white "head" dot travels at the progress point with a drip/glow effect. Progress animates on every deposit.
- Percentage badge (top-left corner): pill-shaped, accent background, Orbitron font (e.g., "49.8%").
- Deadline badge (bottom-right, only if deadline set): "⏱ 47 days left" in small textSecondary.
- Tap → Goal Detail Screen.

**Vault Card States:**
- `loading`: Shimmer animation placeholder (no content visible).
- `empty` (0%): Progress bar shows as empty track. Special empty-state message inside card: "Tap ₊ to make your first deposit".
- `inProgress` (1–99%): Standard display.
- `complete` (100%): Card transforms — background becomes fully lit in accent gradient, goal icon replaced with trophy, "GOAL ACHIEVED" text pulses, confetti particles loop inside the card bounds. A "Celebrate!" CTA appears.

**Combined Progress Ring:**
A large circular ring (180px diameter) split into two arcs — the left arc is cyan (Goal A progress), the right arc is magenta (Goal B progress). In the center: a small PiggyVault icon. Below the icon: "COMBINED" label and the overall total saved. The arcs animate on load with a staggered draw animation.

**Quick Stats Row:**
Two metric tiles side by side in glass panels:
- Left: "TOTAL SAVED" + amount
- Right: "THIS WEEK" + amount (deposits in current Mon–Sun)
Both use Orbitron displayM for the number, Rajdhani label for the heading.

**Recent Deposits Mini-List:**
Last 3 deposits, each showing: goal icon (small, tinted) + amount + note (truncated) + relative time ("2h ago"). Tap row → navigates to full history. Bottom of section: "View all history →" link.

**Ambient Animation:**
- Background: 25–30 floating neon particles (tiny dots, 1–3px) drifting slowly upward. Particles are ~30% cyan and ~30% magenta, rest are white/purple. CPU-efficient `CustomPainter` with `Ticker`.
- Vault cards pulse their glow border very gently on a 3-second cycle.

**Bottom Navigation:**
5 items: Home (🏠) / Deposit (💰, larger center button) / Analytics (📊) / Achievements (🏆) / Settings (⚙).
- Active tab: icon + label, accent-colored icon with glow dot underneath.
- Deposit tab: Slightly elevated, circular, gradient background — treated as FAB-style center action.
- Navigation transitions: Custom page transition using `flutter_animate` — slide-fade from the direction of the tab.

**Dashboard Entry Animation (each app launch):**
1. Background fades in (`300ms`).
2. Header slides down from above (`400ms`, `easeOutCubic`).
3. Streak banner pops in from top (`300ms`, `elasticOut`).
4. Vault Card A slides in from left (`500ms`, `easeOutCubic`).
5. Vault Card B slides in from right (`500ms`, `easeOutCubic`, `100ms` delay).
6. Progress ring draws itself (arc animation, `800ms`).
7. Stats row and recent deposits fade up (`400ms`).

---

#### SCREEN 2.2 — Dashboard (Empty State — Zero Deposits)

**Purpose:** First-time-ish state when user has set up goals but made no deposits yet.

**Differences from standard Dashboard:**
- Both vault cards show a distinct empty state variant: translucent card with a dashed neon border (pulsing). Inside: goal icon large (60px), centered, dimmed. Text: "No deposits yet." Below: a small arrow pointing down toward the Deposit tab.
- Progress bars are fully empty but animated with a subtle "waiting" pulse.
- Recent deposits section replaced with: "Your deposit history will appear here. Make your first deposit now!"
- Combined ring shows two empty arcs with a loading-ring animation.
- A gentle tutorial tooltip hovers over the Deposit nav button: "Start here →".

---

#### SCREEN 2.3 — Dashboard (Streak Warning State)

**Purpose:** When user hasn't deposited today and the streak is at risk (showing after 6 PM if no deposit).

**Visual overlay:**
- An amber/orange warning banner slides down from top: "⚠ Your streak ends at midnight! Deposit now to protect it."
- The streak banner transforms: gold color replaced with amber pulse animation.
- The Deposit nav button gains an urgent pulsing glow.
- Notification also fires (if notifications enabled).

---

#### SCREEN 2.4 — Dashboard (Milestone Just Unlocked)

**Purpose:** Transient state shown once immediately after a deposit that triggers a milestone.

**Behavior:** After deposit success, when returning to Dashboard:
- The relevant vault card briefly "explodes" with a particle burst at the progress bar position.
- An overlay milestone card slides up from the bottom (not a bottom sheet — it has a dramatic entrance): large goal icon, milestone title, description, and a "VIEW ACHIEVEMENT" CTA.
- The screen behind the overlay is dimmed and slightly blurred.
- Auto-dismisses after 8 seconds if user doesn't interact.

---

#### SCREEN 2.5 — Dashboard (Both Goals Complete)

**Purpose:** The epic endgame state. Both goals at 100%.

**Visual treatment:**
- Both vault cards are in the "complete" state (animated).
- The combined ring is fully filled — split evenly in cyan and magenta, spinning slowly.
- A new center element appears: a holographic trophy animation (Lottie or custom paint) between the two cards.
- Background particles intensify — more of them, moving faster.
- New section replaces "Recent deposits": "MISSION COMPLETE — Share your achievement!" with a share button.
- The bottom of the screen shows: "Ready for your next mission? Reset a vault to start over."

---

### SCREEN GROUP 3: DEPOSIT FLOW (6 screens)

---

#### SCREEN 3.1 — Deposit Screen

**Purpose:** Primary deposit initiation screen. Most-used action in the app.

**Layout:**
```
┌─────────────────────────────────┐
│  ← Back        DEPOSIT          │  ← AppBar
├─────────────────────────────────┤
│                                  │
│          ₴  [  0  ]              │  ← Amount Input (massive)
│                                  │
│  ┌──────────────────────────┐   │
│  │  QUICK AMOUNTS           │   │
│  │  [50] [100] [200] [500]  │   │  ← Quick chips
│  │  [1000] [2000] [Custom]  │   │
│  └──────────────────────────┘   │
│                                  │
│  ALLOCATE TO:                    │  ← Allocation section
│  [● PS5 only    ] [● Monitor only]│
│  [● Split: 50% / 50%          ] │
│                                  │
│  ┌─────────────┐ ┌────────────┐  │  ← Split sliders (if split mode)
│  │  PS5: ₴xxx  │ │ Mon: ₴xxx │  │
│  └─────────────┘ └────────────┘  │
│  [═══●══════════════════════════] │  ← Single split slider
│                                  │
│  ADD A NOTE (optional)           │
│  [_______________________________]│  ← Text input
│                                  │
│  [     PREVIEW DEPOSIT     ]     │  ← CTA
└─────────────────────────────────┘
```

**Amount Input:**
- Currency symbol is large and positioned left of the number.
- The number itself is displayed in Orbitron displayXL — massive and central.
- No text field chrome — pure number display with a blinking cursor line.
- Color: starts as textTertiary at 0, transitions to white as amount grows, glows in the selected goal's accent color.
- Custom numeric keyboard rendered at the bottom of the screen (not system keyboard): large digit buttons, delete, decimal point. Each key tap produces `HapticFeedback.lightImpact()` and a subtle scale-pulse animation on the digit.

**Quick Amount Chips:**
- Row of preset amount chips. Styled as neon-bordered pills.
- Tapping fills the amount with a snap animation.
- "Custom" chip opens full keyboard.

**Allocation Selector (3 modes):**
- **PS5 only**: Background fills with cyan tint.
- **Monitor only**: Background fills with magenta tint.
- **Split**: Background uses the dual gradient. Split slider appears.

**Split Slider:**
- Single horizontal slider with a dual-colored track: cyan on left, magenta on right.
- The dividing thumb is white with a dual-glow halo.
- As thumb moves, real-time amounts update below each goal's label.
- Labels flash briefly (scale pulse) on each update.

**Note Input:**
- Subtle text field with neon underline border.
- Placeholder: "Add a note... (optional)"
- Character counter: `0/100` appears when user starts typing.

**CTA "PREVIEW DEPOSIT":**
- Disabled state: low opacity, no glow.
- Enabled state: full neon glow animation around button border.
- On tap: `HapticFeedback.mediumImpact()` + transition to Confirm screen.

**States:**
- `empty`: Amount = 0, CTA disabled.
- `filledNoAllocation`: Amount filled but no goal selected — CTA disabled with tooltip "Select a goal first".
- `readyToPreview`: All required fields set — CTA enabled.
- `splitMode`: Split slider visible, both amounts shown.

---

#### SCREEN 3.2 — Deposit Confirm Screen

**Purpose:** Summary review before committing the deposit. Prevents accidental deposits.

**Layout:**
- Large centered "CONFIRM DEPOSIT" heading.
- Summary card (glass panel):
  - Amount: displayed very large (Orbitron displayL).
  - Allocation: shows goal icon(s) + amount per goal.
  - Note: if provided, shown in italic.
  - Date/time: "Today at {HH:MM}" (auto-set to now).
- Progress preview: Small version of each affected vault's progress bar, showing current state → new state after this deposit. The "new" progress is highlighted with a dotted overlay.
- Two buttons: "EDIT" (secondary, no fill) and "CONFIRM DEPOSIT" (primary, full gradient glow).

**Micro-interaction:**
- When screen loads, summary card animates in with a scale-from-center effect.
- The progress previews animate a partial fill from current to projected.
- Confirming causes the confirm button to morph into a loading spinner for `200ms` before navigating.

---

#### SCREEN 3.3 — Deposit Success Screen

**Purpose:** Emotional payoff of the deposit action. Must feel GREAT.

**This is one of the most important screens in the app — users see it every time they save.**

**Layout:**
- Full-screen celebration.
- Background: animated neon explosion from center.
- Large success icon: ✓ checkmark assembled from neon lines, drawing animation.
- Big text: "DEPOSITED!" (Orbitron, displayL, white).
- Amount text (goal's accent color, displayM).
- Allocation breakdown below (small, goal icon + amount per goal).
- New progress info: "PS5 is now {%}%" — with a mini progress bar showing the new state.
- **If milestone unlocked**: Additional "🏆 New milestone: {title}" banner appears below.
- "BACK TO VAULT" CTA (appears after 1.5 seconds, slides up).
- Optional "Share" link (text, small) — generates a shareable image card.

**Confetti:**
- `confetti` package — neon-colored particles (cyan, magenta, gold, white) bursting from the top.
- Duration: 3 seconds. Intensity: Medium.

**Haptic:** `HapticFeedback.heavyImpact()` exactly once when the screen appears.

**Animation sequence:**
1. `0ms`: Background flash (white → dark in 200ms).
2. `200ms`: Confetti starts.
3. `300ms`: Checkmark draws itself (500ms).
4. `600ms`: "DEPOSITED!" text appears with letter-by-letter animation.
5. `900ms`: Amount and details fade in.
6. `1500ms`: "Back to Vault" CTA slides up from bottom.

**States:**
- Standard: As described.
- With milestone: Extra milestone banner with gold glow.
- With achievement unlock: Achievement badge thumbnail appears with "Achievement unlocked!" text.

---

#### SCREEN 3.4 — Scheduled Deposit Setup Screen

**Purpose:** Optional — user can set up recurring reminders/auto-deposit prompts.

**Access:** Via Settings → "Scheduled Deposits" or via a prompt after first deposit.

**Layout:**
- Toggle: "Enable recurring deposit reminders"
- Frequency selector: Daily / Weekly / Monthly (segmented control).
- Amount pre-fill option: "Always open with last amount".
- Day/time picker (shown when weekly or monthly selected).
- Goal pre-selection toggle: "Remember my last allocation choice".
- Note: "We'll remind you to deposit — we can't auto-deposit for you." (reassurance text)

---

#### SCREEN 3.5 — Deposit History Screen

**Purpose:** Full chronological list of all deposits.

**Layout:**
- Filter bar at top: "All" / "PS5" / "Monitor" / "Split" (accent-colored active chip).
- Date-grouped list:
  - Section header: "TODAY" / "YESTERDAY" / "12 May 2026" (Rajdhani, dimmed, uppercase).
  - Each deposit row: goal icon (tinted, 32px) | amount (Orbitron) | note | time. Tap → Deposit Detail.
- Empty state: "No deposits yet. Start your savings journey!" with illustrated empty vault.
- Load more on scroll (pagination, 30 items per page).

**Swipe actions on each row:**
- Swipe left: Delete option (with confirmation alert).
- Swipe right: "Add note" (if no note exists) or "Edit note".

**Micro-interactions:**
- On list entry, rows slide in staggered from bottom (25ms delay per row).
- Deleting: Row collapses with a swipe-away animation.

---

#### SCREEN 3.6 — Deposit Detail Screen

**Purpose:** Full details for a single deposit.

**Layout:** Centered card on dimmed background (pushed as modal).
- Large amount (Orbitron displayM, goal's accent color).
- Goal badge (icon + name).
- Date/time full format.
- Note (full text, no truncation).
- "Deposit ID: #{id}" (monospace, textTertiary — for support).
- Two actions at bottom: "Edit Note" / "Delete Deposit".

---

### SCREEN GROUP 4: GOAL DETAIL (5 screens)

---

#### SCREEN 4.1 — Goal Detail Screen

**Purpose:** Deep dive into a single goal's status, progress, and history.

**Access:** Tap on a Vault Card from Dashboard.

**Layout:**
```
┌─────────────────────────────────┐
│ ← Back       [GOAL ICON]        │  ← App bar with goal's accent color background
├─────────────────────────────────┤
│  PlayStation 5                  │  ← Goal title (large, Orbitron)
│  ₴12,450 saved of ₴24,999       │  ← Progress text
│                                  │
│  [════════════════════░░░] 49.8% │  ← Big progress bar
│                                  │
│  ┌───────┐  ┌────────┐  ┌─────┐  │
│  │ Saved │  │ Left   │  │ 47d  │  │  ← Stat cards row
│  │₴12,450│  │₴12,549 │  │ left │  │
│  └───────┘  └────────┘  └─────┘  │
│                                  │
│  MILESTONES                      │
│  [●─────●─────○─────○─────○]    │  ← Milestone timeline
│  10%    25%   50%   75%   100%  │
│                                  │
│  DEPOSITS (last 5)               │
│  [deposit row] ₴500  2d ago      │
│  [deposit row] ₴1000 5d ago      │
│  [View full history →]           │
│                                  │
│  [ MAKE A DEPOSIT → ]            │  ← CTA
└─────────────────────────────────┘
```

**Hero section:**
- The goal icon animates on entry: rotates 360° once, then settles.
- Progress bar is a custom animated widget — it draws from 0% to actual progress with a satisfying fill.
- A subtle glow pulse emanates from the progress bar's leading edge.

**Stat Cards:**
Three glass tiles — "Saved / Left / Days Left". Numbers use Orbitron. If no deadline: "Days Left" tile shows "—" with a note "Set a deadline to see projections".

**Milestone Timeline:**
A horizontal timeline with 5 nodes at 10%/25%/50%/75%/100%. Completed nodes are filled (accent color, glow). Current next milestone node pulses gently. Future nodes are outline-only.
- Tap any completed milestone node → its badge overlay slides up.
- Tap incomplete node → shows what's needed to reach it.

**Deposits Section:**
Last 5 deposits (compact rows). "View full history →" navigates to Goal History filtered for this goal.

**Edit Goal CTA** (top-right corner, pencil icon): Navigates to Goal Edit screen.

---

#### SCREEN 4.2 — Goal Edit Screen

**Purpose:** Edit target amount or deadline.

**Layout:** Similar to Goal Setup screen but in-edit mode.
- Shows current values pre-filled.
- Warning text: "Changing the target will recalculate your progress percentage."
- "SAVE CHANGES" CTA.
- "Reset this goal?" destructive link at bottom (navigates to Reset Confirm).

---

#### SCREEN 4.3 — Goal History Screen

**Purpose:** Full deposit history for one specific goal. Pre-filtered.

Identical to Deposit History Screen (3.5) but filtered to one goal. Header shows goal name and icon.

---

#### SCREEN 4.4 — Goal Projection Screen

**Purpose:** Visual projection of when this goal will be completed.

**Access:** Via a "Projection" CTA on Goal Detail (only shown if deadline is set or sufficient deposit history exists).

**Layout:**
- Header: "PROJECTED COMPLETION"
- Large line chart (fl_chart): X-axis = dates (past + future). Y-axis = saved amount. Two lines: actual history (solid, accent) + projected trajectory (dashed, accent with lower opacity). A horizontal dashed line at `targetAmount`. The intersection of projected trajectory + target line = completion date.
- Completion date displayed large below chart: "Est. completion: **14 Nov 2026**" (or "You're behind schedule" in neonRed if under-pacing).
- Status indicator: On-track / Ahead / At-risk / Critical — each with distinct color and icon.
- Required daily savings: "To meet deadline: **₴145/day**" — shown in a highlighted chip.
- Historical average: "Your average: **₴98/day**" — shown below.

---

#### SCREEN 4.5 — Goal Complete Screen

**Purpose:** The GRAND FINALE for a single goal reaching 100%. An epic celebration screen.

**This screen must be the most visually impressive screen in the app.**

**Triggered:** Automatically when any deposit brings a goal to 100%.

**Layout:** Full-screen takeover.

**Animation sequence:**
1. Screen cuts to black.
2. A massive, bright neon explosion from center (goal's accent color) fills the screen.
3. The goal's icon (PS5 or Monitor) materializes from the energy, large (200px), rotating slowly.
4. Confetti — intense, full screen, 5 seconds. Neon particles of goal's accent color.
5. Text assembles from particles: "**VAULT UNLOCKED**" (Orbitron displayXL, gradient).
6. Below: Goal name in large accent-colored text.
7. Stats appear: "Saved: ₴XX,XXX over {N} days / {N} deposits".
8. Achievement banner: "🏆 Goal Achieved! Achievement unlocked."
9. Two CTAs slide up: "SHARE THIS WIN 🎮" and "CONTINUE SAVING FOR THE OTHER GOAL".

**Haptics:** A long celebration haptic pattern (3 × heavy impact, staggered).
**Sound:** Optional (user preference) — a synthesizer "victory chord" sound effect.

---

### SCREEN GROUP 5: ANALYTICS (4 screens)

---

#### SCREEN 5.1 — Analytics Dashboard

**Purpose:** Overview of all financial data with charts and statistics.

**Access:** Analytics tab in bottom nav.

**Layout:**
- Tab row at top: "OVERVIEW" / "PS5" / "MONITOR" (pill-style tabs, accent-colored active state).
- **Scrollable content:**

**Overview Tab:**
1. **Weekly Bar Chart** — Deposits per day this week. Two-colored bars (cyan for PS5, magenta for Monitor, stacked or side-by-side). Each bar tap shows tooltip with exact amounts.
2. **Total Saved Donut Chart** — Shows split between Goal A, Goal B. Percentage labels in center. 🎨
3. **Monthly Trend Line** — Combined savings over last 3 months.
4. **Stats Grid** (2×3):
   - Largest single deposit
   - Average deposit amount
   - Total number of deposits
   - Most active day of week
   - Best streak (all-time)
   - Days since first deposit
5. **Projection Summary** (if applicable): Both goals' completion dates in a compact card.

**Per-Goal Tabs (PS5 / Monitor):**
Same charts filtered to one goal. Adds goal-specific stats: "Deposits to this goal: {N}", "Average deposit: ₴{X}".

**Chart animations:** All charts animate in on tab switch / screen entry. Bar charts grow from 0. Line charts draw from left. Donut charts spin to fill.

---

#### SCREEN 5.2 — Streak Calendar Screen

**Purpose:** Heatmap calendar of deposit activity. Motivational — shows visual proof of consistency.

**Access:** Tap Streak Banner on Dashboard.

**Layout:**
- Header: Current streak counter in large Orbitron (🔥 + number + "day streak").
- Streak milestones row: Show next milestone to unlock (e.g., "7 more days for Gold Flame 🔥").
- **3-month heatmap calendar**:
  - Each day cell: small square, colored by deposit intensity:
    - `No deposit`: dark gray.
    - `< ₴100`: dim cyan/magenta mix.
    - `₴100–₴499`: medium intensity.
    - `≥ ₴500`: full neon glow intensity.
  - Today's cell has a white outline border.
  - Tap a day cell → shows deposit summary for that day in a tooltip.
- Streak badges row: Shows all earned streak badges, greyed out if not yet earned.
- **Streak freeze tokens**: "You have {N} streak freeze tokens" — tap to see how to earn more.

---

#### SCREEN 5.3 — Statistics Detail Screen

**Purpose:** Expanded view of any single statistic (navigated to by tapping a stat card).

Full-page breakdown of that metric with chart, history, and context. Minimalistic. 🎨

---

#### SCREEN 5.4 — Export Screen

**Purpose:** Export deposit history as CSV or share a summary image.

**Layout:**
- "EXPORT DATA" heading.
- Date range picker: "Last 30 days / Last 3 months / All time / Custom".
- Format: CSV (for spreadsheets) / PNG Summary Card.
- "EXPORT" CTA.

CSV includes: date, amount, goal, note.
PNG Summary Card: a stylized image (matching app aesthetic) with the user's stats — designed to be shared on social media.

---

### SCREEN GROUP 6: ACHIEVEMENTS (4 screens)

---

#### SCREEN 6.1 — Achievements Trophy Room

**Purpose:** Gallery of all 50+ achievements. Gamification hub.

**Layout:**
- Header: "TROPHY ROOM" (Orbitron), total earned count (e.g., "12 / 54 Unlocked").
- Filter tabs: "All / Unlocked / Locked / Rare / Legendary".
- **Achievement Grid** (2 columns):
  - Each cell: glass card with badge icon (large, 64px) + name + rarity chip.
  - **Unlocked**: Full color, glowing border in rarity color. Rarity indicators: Common (white) → Rare (cyan) → Epic (magenta) → Legendary (gold holographic shimmer).
  - **Locked**: Grayscale + dimmed, with a 🔒 overlay. Description is visible but icon is blurred.
  - Tap → Achievement Detail Screen.
- **Recently Unlocked** section at top (if any unseen): Horizontal scroll of newly-earned badges with a "NEW" badge chip on each.

**Micro-interactions:**
- Unlocked badges have a slow idle shimmer animation.
- Legendary badges have a looping holographic gradient rotation.
- On entry, the grid cells animate in staggered (30ms delay each).

---

#### SCREEN 6.2 — Achievement Detail Screen

**Purpose:** Full information about a single achievement.

**Layout:** Pushed as a modal / bottom sheet.
- Large badge icon (100px) centered at top.
- Name (Orbitron h2) + rarity chip.
- Description: Full text explaining what this achievement is for.
- Unlock condition: "How to earn: {description}".
- Status: "Unlocked on {date}" (if earned) or "Not yet earned" (if locked).
- Progress indicator (if applicable): e.g., "14 / 30 deposits made".
- "SHARE ACHIEVEMENT" button (if unlocked).

---

#### SCREEN 6.3 — Achievement Unlock Modal

**Purpose:** Full-screen celebration overlay when an achievement is just unlocked.

Similar to Milestone overlay — dramatic, full-screen, non-dismissible for 2 seconds. Shows badge, title, description, rarity, and confetti. Auto-dismisses after 5 seconds or on tap.

---

#### SCREEN 6.4 — Achievement Unlock Queue (if multiple unlocked at once)

**Purpose:** When multiple achievements unlock simultaneously (e.g., after a large deposit), show them in sequence.

**Logic:** Queue the overlays. Show one, wait for dismiss, show next.

---

### SCREEN GROUP 7: SETTINGS (8 screens)

---

#### SCREEN 7.1 — Settings Main Screen

**Layout:**
- Header: User's display name + avatar (large, centered at top of settings).
- Grouped sections:

**PROFILE:**
- Display Name (editable inline)
- Avatar / emoji selector

**SAVINGS:**
- Currency selector (tap → Currency Settings)
- Goal A: PS5 target (tap → Goal Edit)
- Goal B: Monitor target (tap → Goal Edit)
- Scheduled Deposits (tap → Scheduled Deposit Setup)

**NOTIFICATIONS:**
- Master toggle for notifications
- "Tap for detailed notification settings" → Notification Settings Screen

**APPEARANCE:**
- Theme (only dark in v1.0, but show a "More themes coming soon" toggle as disabled, teasing future feature)
- Language: Ukrainian / English

**DATA:**
- Export Data → Export Screen
- Import Data (placeholder — "Coming soon")
- Clear deposit history (destructive, with confirmation)

**ABOUT:**
- App version
- Rate the app
- Share the app
- Privacy Policy / Terms
- Open-source licenses

---

#### SCREEN 7.2 — Notification Settings Screen

**Purpose:** Granular notification control.

**Toggles:**
- Daily deposit reminder (time picker)
- Streak warning (before midnight)
- Milestone celebrations
- Achievement unlocks
- Weekly summary (every Sunday)
- App update notifications

Each toggle shows a description of what it controls. Time pickers are inline below their respective toggle (slide in when enabled).

---

#### SCREEN 7.3 — Theme Settings Screen

**Purpose:** Future theme selection screen. In v1.0, only one theme is available.

**Layout:**
- "Current theme: Neon Cyberpunk" — shown with a preview swatch.
- Greyed out: "Void Black", "Digital Sakura", "Arctic Neon", "Gold Rush" — each with a locked 🔒 chip and "Coming soon" label.
- Note: "More themes unlock as you level up your vault!"

---

#### SCREEN 7.4 — Currency Settings Screen

Three large option cards (UAH / USD / EUR). Currently selected card is outlined in accent color. "SAVE" CTA.

---

#### SCREEN 7.5 — Reset Confirm Screen

**Purpose:** Irreversible confirmation for resetting a goal or all data.

**Layout:**
- Large warning icon (⚠, neonRed glow).
- Danger-styled heading: "ARE YOU SURE?"
- Description of what will be deleted (non-recoverable data warning).
- Two inputs: user must type "RESET" in a text field to confirm — disables the "CONFIRM RESET" CTA unless correct.
- Buttons: "CANCEL" (prominent, secondary) + "CONFIRM RESET" (neonRed, only active when text correct).

---

#### SCREEN 7.6 — Profile / Avatar Editor Screen

**Purpose:** Choose display name and avatar emoji or color.

**Layout:**
- Large avatar preview (120px circle) centered.
- Emoji grid below: 30+ gaming/tech/finance relevant emojis to choose from.
- Color ring: Select avatar background color (8 preset neon colors).
- Display name text field below.
- "SAVE" CTA.

---

#### SCREEN 7.7 — About Screen

Standard about screen. But styled consistently — not plain white.
- App logo centered.
- Version, build number.
- "Made with 💙 by {developer/team name}" — cyberpunk font.
- Links: rate, share, GitHub (if OSS), privacy, terms.
- Easter egg: Long-press on the logo (3s) → triggers a secret confetti burst and a hidden achievement "Curiosity Killed the Cat" unlocks.

---

#### SCREEN 7.8 — Import / Export Data Screen

Extended version of Export Screen (5.4). Adds import from CSV (file picker). Import validates file format and shows a preview before confirming.

---

### SCREEN GROUP 8: MILESTONE & CELEBRATION OVERLAYS (6 screens/states)

---

#### SCREEN 8.1–8.5 — Individual Milestone Screens (10% / 25% / 50% / 75% / 90%)

Each milestone has a **unique visual treatment** that escalates in drama as the percentage increases.

**10% — "First Spark":**
- Light spark animation. Simple glow ring expands. Small confetti. Subdued but satisfying.

**25% — "Quarter Power":**
- Pulsing quarter-circle arc animation. More confetti. "One quarter done!" energy.

**50% — "Halfway There":**
- Screen splits vertically — left half fills with goal A color, right with goal B. Then rejoins. Medium confetti. "You're halfway — momentum is everything."

**75% — "Almost Ready":**
- Dramatic edge-lighting: the screen's borders flash in rapid neon pulses (3×). More intense confetti. Timer/urgency energy if deadline is set.

**90% — "Locked In":**
- System-style alert aesthetic: a countdown-like display. "Final approach." If deadline is close, extra urgency. Intense confetti.

All milestone screens share:
- Dimmed background with blur.
- Glass card centered: icon + title + body text.
- "CONTINUE" CTA (bottom).
- Auto-dismiss after 8 seconds with a visible countdown ring on the CTA button.

---

#### SCREEN 8.6 — Both Goals Complete Celebration

Described in Section 2.5. The ultimate state of the app.

---

### SCREEN GROUP 9: SHARED / UTILITY (6 screens)

---

#### SCREEN 9.1 — Onboarding Tooltip Overlays

Context-sensitive tutorials that appear on first-time visits to each screen. Semi-transparent dark overlay with a spotlight on the relevant element. Text bubble with arrows. Dismissible by tap anywhere.

**Screens with first-time tooltips:**
- Dashboard: Points to deposit button ("Tap here to add money").
- Dashboard: Points to vault card ("Tap a vault to see details").
- Analytics: Points to chart ("Swipe between goals using tabs above").
- Achievements: Points to locked badge ("Complete challenges to unlock badges").

---

#### SCREEN 9.2 — Error / Offline Screen

**Purpose:** Shown when an operation fails or the app detects required connectivity is unavailable.

**Layout:**
- Animated illustration of a disconnected neon plug / broken data stream. 🎨
- "CONNECTION LOST" (or specific error) heading.
- Description: context-specific error message.
- "RETRY" CTA.

Note: Most features work fully offline. This screen only appears for features that require connectivity (none in v1.0, but scaffolded for future cloud sync).

---

#### SCREEN 9.3 — Loading / Skeleton Screen

Applied to: Dashboard, Analytics, History, Achievements on cold start.

**Design:**
- Exact layout skeleton of the target screen.
- All content areas replaced with `shimmer` package animated grey → lighter grey → grey pulse.
- The shimmer color should be tinted with the app's dark background — not bright white as in typical shimmer.
- Duration: shown until data loads. Max shown: 3 seconds. If data not loaded in 3s → show error state.

---

#### SCREEN 9.4 — Permission Request Screens

**Purpose:** Graceful permission requests for notifications.

**Layout (bottom sheet style):**
- Illustrated top area: a stylized notification bell in neon.
- Heading: "Stay on track with reminders."
- Body: Explains what notifications will be sent.
- "ALLOW NOTIFICATIONS" CTA (primary).
- "Maybe later" text link (secondary).

Never trigger native permission dialog without this pre-prompt screen first.

---

#### SCREEN 9.5 — Share Sheet / Generated Card

**Purpose:** Shareable image generated for social sharing.

**Generated image specs (1080×1080px):**
- PiggyVault branding (logo + app name).
- User's achievement or progress stats.
- Dark background, neon aesthetic — looks great on any social feed.
- Goal icons with progress percentages.
- Optional message: "Saving for my dream setup! #PiggyVault".

---

#### SCREEN 9.6 — App Update Screen (future-proof)

Shown when a required app update is detected. Standard layout: version info, "Update Now" CTA that opens the store. Consistent styling.

---

## PART 6 — SHARED WIDGET LIBRARY

Build and document a full widget library in `lib/shared/widgets/`. Each widget must be:
- Self-contained
- Themeable via constructor parameters
- Well-documented with a Dart docstring
- Tested with at least one widget test

### Required Shared Widgets

| Widget | Description |
|---|---|
| `NeonProgressBar` | Animated progress bar with glow effect, configurable accent color |
| `GlassCard` | Glassmorphism panel with blur, border, configurable radius and elevation |
| `NeonButton` | Primary CTA button with animated glow border, gradient fill, haptic |
| `GhostButton` | Secondary button with outline + subtle glow |
| `AmountDisplay` | Large currency amount with Orbitron font, animated digit transitions |
| `GoalChip` | Small pill showing goal name + icon |
| `StreakBadge` | Flame icon + streak number, animated |
| `NeonTextField` | Custom text field with neon underline, floating label |
| `AchievementBadge` | Badge icon with rarity glow, locked/unlocked states |
| `DualProgressRing` | Circular dual-arc progress ring for both goals |
| `DepositRow` | Single deposit list item with goal icon, amount, note, time |
| `MilestoneTimeline` | Horizontal milestone progress timeline |
| `NeonDivider` | Styled divider with optional center label |
| `TooltipOverlay` | First-time tutorial spotlight overlay |
| `ConfettiWidget` | Wrapper around confetti package with app-specific config |
| `ParticleBackground` | Ambient floating particles CustomPainter widget |
| `ShimmerCard` | Skeleton loading card with dark-tinted shimmer |
| `StatTile` | Small glass tile for displaying a metric (label + value) |
| `QuickAmountChip` | Preset amount selection chip |
| `SplitSlider` | Dual-color split allocation slider |
| `NeonTabBar` | Custom tab bar with neon active indicator |
| `GoalIcon` | Goal-specific icon with tinting and animation variants |

---

## PART 7 — NOTIFICATIONS

**Local notifications only** (v1.0). Use `flutter_local_notifications`.

**Notification types:**

| ID | Type | Default Schedule | Content |
|---|---|---|---|
| 1 | Daily reminder | User-set time (default 20:00) | "Don't forget to save today! 💰 Every coin counts." |
| 2 | Streak warning | 22:00 if no deposit today | "⚠ Your {N}-day streak is at risk! Deposit before midnight." |
| 3 | Streak broken | Morning after a miss | "Your streak was broken. Start a new one today! 🔥" |
| 4 | Milestone | On trigger | "🏆 Milestone unlocked! {Goal} is {%}% funded!" |
| 5 | Achievement | On trigger | "🎮 Achievement unlocked: {title}" |
| 6 | Weekly summary | Sunday 10:00 | "Week in review: You saved ₴{X} this week!" |

All notifications deep-link into the relevant app screen.

---

## PART 8 — ACCESSIBILITY

The app must meet **WCAG 2.1 AA** compliance:

- **Color contrast**: All text meets 4.5:1 contrast ratio against its background. Verify neon-on-dark combinations. Never rely solely on color to convey information.
- **Semantics**: All interactive elements have `Semantics` labels. Custom `CustomPainter` widgets include semantic descriptions.
- **Text scaling**: All text uses `sp` units (not `px`). Layout remains usable at 200% text scale.
- **Touch targets**: Minimum 48×48px for all tappable elements. Bottom navigation items min 60px height.
- **Screen reader**: Full VoiceOver (iOS) and TalkBack (Android) support. Test the core deposit flow manually.
- **Reduced motion**: If `MediaQuery.disableAnimations` is true, replace all animations with instant transitions.

---

## PART 9 — PERFORMANCE REQUIREMENTS

- **App startup** (cold): < 2 seconds to interactive Dashboard on mid-range device (e.g., Pixel 6a).
- **Frame rate**: 60 FPS minimum on all main screens. 120 FPS on devices supporting ProMotion. Zero jank on deposit flow.
- **Database queries**: All Drift queries run asynchronously. No sync DB calls on main thread.
- **Animation efficiency**: Particle system uses `CustomPainter` with dirty-region marking. Avoid `setState` on full `Scaffold` — isolate animation widgets.
- **Image assets**: All SVG where possible. Raster assets provided at 1×, 2×, 3× densities. No PNG over 200KB.
- **Memory**: Profile with Flutter DevTools. No memory leaks in animation controllers (always `dispose()`).
- **Build sizes**: Target APK < 30MB (release, arm64). IPA < 40MB.

---

## PART 10 — TESTING STRATEGY

### Unit Tests (domain + data layers)
- `GoalProgressCalculator`: test all percentage edge cases, clamping at 100%.
- `StreakCalculator`: test streak continuity, gap detection, freeze logic.
- `ProjectionEngine`: test trajectory calculation with various deposit patterns.
- `CurrencyFormatter`: test formatting for UAH/USD/EUR at various amounts.

### Widget Tests (presentation layer)
- `NeonProgressBar`: renders correct fill percentage, animates on update.
- `GlassCard`: renders with correct styling, handles all padding variants.
- `DepositScreen`: amount input → chip selection → allocation mode transitions.
- `Dashboard`: renders both vault cards in all states.

### Integration Tests
- Full deposit flow: enter amount → select goal → confirm → success → verify DB updated → verify progress on Dashboard.
- Onboarding flow: all 5 screens, completion → Dashboard entry.
- Streak increment: deposit today → verify streak counter increments.

---

## PART 11 — AGENT EXECUTION CHECKLIST

Execute in this order. Do not skip steps.

```
[ ] 1. Scaffold Flutter project with correct package name (com.piggyvault.app)
[ ] 2. Add all dependencies to pubspec.yaml and run flutter pub get
[ ] 3. Set up folder structure exactly as specified in Section 2.2
[ ] 4. Configure GoRouter with all routes from Section 2.5
[ ] 5. Set up Drift database with all tables from Section 2.4
[ ] 6. Configure Riverpod providers (DI layer)
[ ] 7. Implement AppColors, AppTextStyles, AppTheme from Section 3
[ ] 8. Build all shared widgets from Section 6 (in isolation, with tests)
[ ] 9. Implement Splash Screen + Onboarding flow (Screens 1.1–1.5)
[ ] 10. Implement Dashboard (Screen 2.1) with all states
[ ] 11. Implement Deposit Flow (Screens 3.1–3.3)
[ ] 12. Implement Goal Detail screens (Group 4)
[ ] 13. Implement Analytics screens (Group 5)
[ ] 14. Implement Achievements screens (Group 6)
[ ] 15. Implement Settings screens (Group 7)
[ ] 16. Implement Milestone overlays (Group 8)
[ ] 17. Implement notification scheduling (Section 7)
[ ] 18. Add ambient particle system to all main screens
[ ] 19. Add haptic feedback to all interactive elements
[ ] 20. Verify accessibility compliance (Section 8)
[ ] 21. Profile performance (Section 9)
[ ] 22. Run full test suite (Section 10)
[ ] 23. Generate release builds for iOS + Android
[ ] 24. Verify all ~75 screen states exist and are reachable
```

---

## PART 12 — CREATIVE BRIEF FOR AI (🎨 SECTIONS)

The following elements have intentional creative freedom. The agent should apply professional judgment and maximize visual quality:

1. **Welcome Screen illustration** (Screen 1.2): Design the hero artwork for the vault concept. Make it striking and gamified.
2. **Goal icons**: Design cohesive SVG icons for PS5 (DualSense) and Monitor. Neon-outlined, geometric, beautiful.
3. **Particle system behavior**: Tune particle count, speed, color distribution, and size variation for maximum ambiance without performance cost.
4. **Achievement badge artwork**: Design 10+ unique badge icons. Each rarity tier should feel distinctly premium.
5. **Lottie/Custom animations**: For the vault unlock celebration, milestone explosions, and streak fire animation — design or source animations that match the cyberpunk aesthetic.
6. **Empty state illustrations**: For history screens, offline screens, etc. Keep them on-brand: dark, techy, but with a hint of warmth.
7. **Loading animation**: Design a custom branded loading indicator (not the default `CircularProgressIndicator`). Perhaps a neon hexagon spinner, or a scanning laser line.
8. **Sound design** (optional, user-toggleable): If implementing sound, the agent should source/generate UI sounds that fit the cyberpunk aesthetic — synthesized tones, subtle chimes, digital acknowledgments. NO realistic sounds. Everything should sound "digital".

---

## PART 13 — FINAL QUALITY GATES

Before considering the build complete, verify:

- [ ] Every screen from this spec is implemented and reachable via navigation.
- [ ] No placeholder content ("Lorem ipsum", "TODO", "Coming soon" except where explicitly noted).
- [ ] All animations are smooth at 60 FPS on a Pixel 6a equivalent.
- [ ] The app can be used entirely offline (all core features).
- [ ] A new user can complete onboarding and make their first deposit in under 3 minutes.
- [ ] The app is delightful: interactions feel satisfying, animations are polished, the aesthetic is consistent.
- [ ] Haptics fire on all meaningful actions, never excessively.
- [ ] The codebase is clean: no commented-out code, proper error handling, no force-unwraps, all async operations properly awaited.
- [ ] Dart analysis passes with zero errors and zero warnings (`flutter analyze`).
- [ ] All strings are localized (Ukrainian + English) using Flutter's `intl` / `AppLocalizations`.

---

### SCREEN GROUP 10: STREAK & GAMIFICATION (5 screens)

---

#### SCREEN 10.1 — Streak Detail / "Fire Room" Screen

**Purpose:** Deep gamification hub around the streak mechanic. More immersive than the calendar alone.

**Access:** Tap streak banner on Dashboard OR long-press streak counter.

**Layout:**
- Hero area (top 35%): Animated fire visualization — the flame height and intensity correspond directly to the current streak length. At 1–3 days: small candle-like flame (cyan). At 7+: medium torch (gold). At 30+: roaring bonfire (full neon gold + orange). At 100+: 🎨 legendary infernal pillar. The flame is a custom `CustomPainter` or Lottie animation.
- Large streak number centered in/near the flame: Orbitron displayXL, gold color, pulsing.
- Sub-label: "consecutive days" (Rajdhani, textSecondary).
- **Streak stats row** (glass tiles):
  - Current streak
  - Best-ever streak
  - Total days with deposits (all-time)
  - Total deposits made
- **Upcoming milestones** section: A vertical list of the next 3 streak milestones not yet reached. Each row: badge thumbnail (dimmed) + milestone name + "X more days". The nearest one has a progress bar below it showing how close the user is.
- **Earned streak badges** horizontal scroll: All streak badges earned so far (bronze shield, silver flame, etc.), each tappable to see badge detail.
- **Streak freeze status**: "You have {N} Freeze Tokens" — with a snowflake icon. Button: "Learn how to earn more →" (navigates to 10.2).
- Bottom CTA: "DEPOSIT NOW — PROTECT YOUR STREAK" (shown only if no deposit today; neon gold gradient).

**Animation:** Flame animation updates reactively — if user just made a deposit and navigated here, the flame grows with a satisfying swell animation over 1.5 seconds.

---

#### SCREEN 10.2 — Streak Freeze Tokens Screen

**Purpose:** Explain and manage streak freeze tokens.

**Layout:**
- Header: "❄ STREAK FREEZE TOKENS"
- Current token count: large, centered. Ice-blue (`#A8D8EA`) color.
- Visual explanation card: Illustrated infographic showing "Missed a day?" → "Token activates automatically" → "Streak preserved!". 🎨 Dark, techy illustration style.
- **How to earn tokens** section (list):
  - "Reach a 7-day streak for the first time → +1 token"
  - "Reach a 30-day streak → +1 token"
  - "Make 5 deposits in one week → +1 token"
  - "Unlock a Rare achievement → +1 token"
  - "Max tokens you can hold: 3"
- **Token history**: Small log showing when tokens were earned and when used.
- No purchase option — tokens are earned only (v1.0 design philosophy: no pay-to-play).

---

#### SCREEN 10.3 — Personal Records Screen

**Purpose:** All-time personal bests. Trophy-case energy. Motivational.

**Access:** Via Analytics or Achievement screens.

**Layout:**
- Header: "YOUR RECORDS" (Orbitron, dual gradient).
- Vertical list of record cards, each as a glass panel:
  - 💰 Largest single deposit ever (amount + date)
  - 📅 Most deposited in a single day
  - 📆 Most deposited in a single week
  - 🔥 Longest streak ever (days)
  - ⚡ Fastest milestone reached (e.g., "Hit 50% in 12 days")
  - 🏆 Total achievements unlocked
  - 🎯 Total deposits made (all-time count)
  - ⏱ Days since app install
- Each card: metric label (Rajdhani, textSecondary) + value (Orbitron, accent-colored) + date of record (small, textTertiary).
- "SHARE MY RECORDS" CTA at bottom → generates a shareable PNG card.

**Animation:** On entry, record cards cascade in from the right, staggered 40ms apart.

---

#### SCREEN 10.4 — Daily Challenge Screen

**Purpose:** Optional daily micro-challenge to boost engagement. Shows one randomized challenge per day.

**Access:** Via a "⚡ Daily Challenge" widget on Dashboard (shown after user's first week, if they have a streak).

**Layout:**
- Header: "TODAY'S CHALLENGE" + date.
- Large challenge card (glass panel, animated border):
  - Challenge icon (unique per challenge type)
  - Challenge title: e.g., "Round Number Rush" / "Double Down" / "Consistency Check"
  - Description: e.g., "Make a deposit that ends in ,000 today."
  - Reward: "🏆 Reward: +1 Streak Freeze Token" or "Reward: Badge: {name}"
  - Deadline: "Resets in 14h 32m" (live countdown).
  - Status: "INCOMPLETE" → "COMPLETED ✓" after user meets the condition.
- Challenge history (last 7 days): Small row of day indicators (✓ or ✗) showing completion rate.
- Note: "Challenges reset daily at midnight. Completing 7 in a row unlocks a special badge."

**Challenge Types (examples — implement at least 10 varieties):**
- Deposit any amount today (trivial, encouragement)
- Deposit exactly ₴500
- Deposit more than yesterday's deposit
- Deposit to the goal with lower % progress
- Make two separate deposits in one day
- Add a note to your deposit
- Deposit before noon
- Deposit a prime number amount
- Deposit and reach a new percentage (any)
- Make your 10th / 25th / 50th deposit

---

#### SCREEN 10.5 — XP & Level Progress Screen

**Purpose:** A lightweight leveling system layered on top of deposits and achievements. Gives users a persistent sense of progression beyond the two goals themselves.

**Access:** Via a small "LVL {N}" badge on the Dashboard header (tap).

**Level system logic (implementation detail):**
- Users earn XP for: deposits (XP = amount / 100, capped at 500 per deposit), completing achievements (50–500 XP by rarity), streak milestones (100–1000 XP), daily challenges (50–200 XP).
- Level thresholds: Level 1 = 0 XP, Level 2 = 200 XP, then +300 XP per level up to Level 10, then +500 XP per level up to Level 25, then +1000 XP per level (no level cap).
- Level-ups may unlock cosmetic rewards (future: themes, badge frames).

**Layout:**
- Hero: Large circular level badge (neon-bordered, level number in Orbitron). Current level title below (e.g., "Vault Initiate" → "Neon Saver" → "Cyber Treasurer" → "Vault Legend").
- XP progress bar: Shows XP toward next level. Animated fill. "1,240 / 2,000 XP to Level 12" label.
- **Level history timeline**: Vertical scroll of past levels reached with dates. Each level shows the title and when it was reached.
- **Benefits section**: "Your level unlocks:" — currently cosmetic only. Tease future content.
- XP breakdown: How XP was earned (pie chart or bar chart showing deposits vs achievements vs streaks contribution).

---

### SCREEN GROUP 11: QUICK ACTIONS & WIDGETS (4 screens)

---

#### SCREEN 11.1 — Quick Deposit Bottom Sheet

**Purpose:** A faster path to deposit — accessible via a swipe-up gesture from the Dashboard's Deposit FAB, or via a 3D Touch / long-press shortcut on the app icon.

**Behavior:** Appears as a tall bottom sheet (85% screen height). Functionally equivalent to Deposit Screen (3.1) but with a streamlined layout optimized for speed.

**Layout:**
- Top drag handle + "QUICK DEPOSIT" label.
- Amount input (same as 3.1 — large Orbitron, center).
- Quick amount chips (same).
- Single-tap goal selection: Two large full-width cards side by side — "PS5" (cyan) and "Monitor" (magenta). One tap selects. No split mode here (split is in full deposit screen only).
- "Note" field (collapsed by default; tap "➕ Add note" to expand inline).
- "DEPOSIT NOW" CTA — full width, prominent. Fires immediately on tap, bypassing the Confirm screen (shows a brief inline "Depositing..." animation on the button, then success toast).
- Small "FULL DETAILS →" link below CTA for users who want the full deposit flow.

**Success state (inline):**
- Instead of navigating to a success screen, the bottom sheet plays a mini confetti burst inside its bounds, shows a checkmark animation on the button, and auto-dismisses after 2 seconds.
- Dashboard behind it updates its progress bars in real time.

---

#### SCREEN 11.2 — Home Screen Widget Setup Screen

**Purpose:** Configuration screen for iOS/Android home screen widgets.

**Access:** Settings → "Home Screen Widgets".

**Layout:**
- Heading: "ADD TO YOUR HOME SCREEN"
- Widget size gallery (horizontal scroll): Small (2×2), Medium (4×2), Large (4×4). Each shows a static preview of the widget at that size.
- **Widget preview**:
  - Small: Shows one goal's progress bar + percentage. User selects which goal via toggle below preview.
  - Medium: Both goals side by side with mini progress bars and amounts.
  - Large: Both goals + streak counter + total saved. Full glass-card aesthetic.
- "HOW TO ADD" instructions: Step-by-step illustrated guide (iOS: long-press home screen → Add Widget; Android: long-press → Widgets). 🎨 Simple numbered steps with small device outline illustrations.
- Platform note: "Widgets update automatically every 30 minutes."

**Implementation note for agent:** Implement home screen widgets using:
- iOS: Flutter home_widget package + WidgetKit extension.
- Android: Flutter home_widget package + AppWidgetProvider.
Both sized correctly and styled to match the app aesthetic (dark background, neon progress arcs).

---

#### SCREEN 11.3 — App Icon Shortcut Screen (Quick Actions)

**Purpose:** Configuration / info screen for 3D Touch / long-press app icon shortcuts.

**Access:** Settings → "Quick Shortcuts".

**Layout:**
- Brief explanation of what shortcuts are.
- Toggle list (each with on/off):
  - "Quick Deposit" — opens Quick Deposit sheet directly.
  - "View PS5 Progress" — opens Goal Detail for Goal A.
  - "View Monitor Progress" — opens Goal Detail for Goal B.
  - "View Streak" — opens Streak Detail.
- Preview: Static iOS/Android home screen mockup showing the shortcuts menu. 🎨

**Implementation:** Use `quick_actions` Flutter package.

---

#### SCREEN 11.4 — Notification-Triggered Deposit Screen

**Purpose:** When user taps a notification with action "Deposit Now", this screen opens directly — pre-initialized for maximum speed.

**Behavior:**
- Identical to Quick Deposit Bottom Sheet (11.1), but opens as a full screen (not sheet) since the app may not be in memory.
- If the notification was a streak warning, pre-fills a suggested amount based on user's recent deposit average.
- After deposit: shows Success screen (3.3) then navigates to Dashboard.

---

### SCREEN GROUP 12: SEARCH & FILTER (3 screens)

---

#### SCREEN 12.1 — Global Search Screen

**Purpose:** Search across all deposits by amount, note text, or date.

**Access:** Search icon in Dashboard header (shown after user has 10+ deposits).

**Layout:**
- Full-screen, modal-style (slide down from top).
- Search bar at top (auto-focused, keyboard opens immediately): neon underline style, placeholder "Search deposits...".
- **Search results** (live, updates as user types):
  - Grouped by type: "DEPOSITS" section header → matching rows.
  - Each result: same row style as Deposit History (goal icon + amount + note snippet + date).
  - Note text matches are highlighted (accent color background on matched substring).
- **Empty search state**: Animated search-beam illustration + "Type to search your vault history."
- **No results state**: "Nothing found for '{query}'." + suggestion "Try searching by amount or note."
- Recent searches (shown before user types): Last 5 searches as deletable chips.

---

#### SCREEN 12.2 — Advanced Filter Screen

**Purpose:** Multi-criteria filter for deposit history.

**Access:** Filter icon in Deposit History toolbar.

**Layout (bottom sheet, tall):**
- "FILTER DEPOSITS" heading.
- **Date range**: Two date pickers ("From" / "To"). Presets: Today, Last 7 days, This month, Last 3 months, Custom.
- **Goal**: Toggle chips — "All" / "PS5" / "Monitor" / "Split".
- **Amount range**: Dual-thumb range slider (min–max). Labels show formatted amounts.
- **Has note**: Toggle — "Only deposits with notes" / "Only without notes" / "All".
- **Sort by**: Newest / Oldest / Largest amount / Smallest amount.
- Two buttons: "CLEAR ALL" (secondary) + "APPLY FILTERS" (primary). Applied filter count shown on the icon in the history screen.

---

#### SCREEN 12.3 — Filtered Results Screen

**Purpose:** Deposit history with active filters applied.

**Layout:** Same as Deposit History (3.5) but with an active filter indicator bar at the top:
- Pill chips for each active filter (e.g., "📅 Last 7 days" × "🎮 PS5" ×).
- Tapping × on a chip removes that filter.
- "Results: {N} deposits" count shown.
- If no results match filters: empty state with illustration and "Adjust filters" CTA.

---

### SCREEN GROUP 13: SOCIAL & SHARING (3 screens)

---

#### SCREEN 13.1 — Share Achievement Card Preview

**Purpose:** Preview and export a styled shareable image for a specific achievement.

**Access:** "Share" button on Achievement Detail Screen (6.2).

**Layout:**
- The generated card is shown at full size in a phone-screen preview (centered, with a faint device frame outline).
- **Card design** (1080×1080px):
  - Dark cyberpunk background with neon grid.
  - Achievement badge icon (large, centered, glowing).
  - Achievement title + rarity.
  - User's display name.
  - PiggyVault logo + tagline (bottom).
  - Decorative neon corner accents. 🎨
- Below preview: Share options row — "Save to Photos" / "Share via..." / "Copy image".
- Small "Edit" link: let user customize their display name shown on the card.

**Implementation:** Generate the card using Flutter's `RepaintBoundary` → `toImage()` → save to gallery or share sheet.

---

#### SCREEN 13.2 — Share Progress Card Preview

**Purpose:** Shareable progress update card — "I'm 67% toward my PS5!"-style.

**Access:** "Share Progress" option on Goal Detail screen.

**Card design:**
- Shows the goal's icon + name.
- Large animated-style progress bar (static in the image, but rendered as if in mid-animation).
- "X% funded" in large Orbitron.
- Total saved amount.
- Hashtags: "#PiggyVault #SavingUp #GamingGoals".
- 🎨 Optionally: user-selectable background variant (gradient A, gradient B, minimal).

---

#### SCREEN 13.3 — Invite / Refer a Friend Screen

**Purpose:** Share the app with friends. Lightweight referral system (no backend in v1.0 — just app store link sharing).

**Access:** Settings → "Share PiggyVault".

**Layout:**
- "SPREAD THE NEON" heading.
- Short copy: "Know someone saving for something big? Share PiggyVault with them."
- App store link auto-generated for iOS/Android.
- Share CTA: "SHARE THE APP" → opens native share sheet with pre-written message and link.
- Social icons row (tap to pre-fill share): WhatsApp / Telegram / Instagram / Copy link.
- Referral note (future feature teaser): "Referral rewards coming soon — stay tuned!"

---

### SCREEN GROUP 14: EDIT & CORRECTION (3 screens)

---

#### SCREEN 14.1 — Edit Deposit Screen

**Purpose:** Correct mistakes in a deposit (amount, goal allocation, note). Only editable within 24 hours of creation; after that, read-only (data integrity).

**Access:** Swipe-right action on deposit row in history → "Edit Note" OR via Deposit Detail screen → "Edit Deposit".

**Layout:**
- Same structure as Deposit Screen (3.1) but pre-filled with existing values.
- Header: "EDIT DEPOSIT" with "Created: {date}" subtitle.
- All fields pre-filled and editable: amount, goal allocation, note.
- "SAVE CHANGES" CTA.
- "CANCEL" secondary action (discards changes).
- **24-hour lock banner** (shown if deposit is older than 24h): amber warning bar "This deposit can no longer be edited — only the note can be changed." The amount and allocation fields become read-only; only note remains editable.
- Change log note (small, bottom): "Edited deposits are logged for your records."

---

#### SCREEN 14.2 — Bulk Delete Screen

**Purpose:** Select and delete multiple deposits at once.

**Access:** Long-press any deposit row in History → enters selection mode.

**Layout:**
- AppBar transforms: shows selection count ("3 selected") + "SELECT ALL" link + "DELETE" button (neonRed).
- All deposit rows gain a checkbox on the left.
- Selected rows have accent-tinted background.
- "DELETE {N} DEPOSITS" CTA at bottom (red, disabled until at least 1 selected).
- Deselect by tapping again; exit selection mode via "✕" in AppBar.

---

#### SCREEN 14.3 — Delete Confirm Dialog

**Purpose:** Final confirmation before irreversible deposit deletion (single or bulk).

**Layout:** Modal dialog (centered, glass panel):
- Warning icon (⚠, neonRed).
- Heading: "Delete {N} deposit(s)?"
- Body: "This cannot be undone. Your goal progress will be updated."
- Two buttons: "CANCEL" (large, prominent, secondary) / "DELETE" (smaller, neonRed).
- **Design note:** The "Cancel" button is deliberately made larger and more visually prominent than "Delete" — this is intentional UX to reduce accidental deletions.

---

### SCREEN GROUP 15: FEATURE DISCOVERY & RE-ENGAGEMENT (4 screens)

---

#### SCREEN 15.1 — What's New Modal

**Purpose:** Shown after an app update (once per version). Highlights new features.

**Layout:** Bottom sheet (80% height):
- "WHAT'S NEW IN {version}" heading.
- Feature list: 3–5 entries, each with:
  - Icon (neon, 32px)
  - Feature name (Rajdhani bold)
  - One-line description (Inter)
- "GOT IT" CTA at bottom.
- Auto-shown once after update, never again for same version.

---

#### SCREEN 15.2 — Feature Discovery Tooltips (Contextual)

**Purpose:** Progressive disclosure of advanced features as users grow into the app.

**Trigger rules (show once each, in order, after conditions met):**

| Condition | Feature Revealed |
|---|---|
| After 3rd deposit | "💡 Did you know? You can split deposits between both goals." |
| After 7-day streak | "🔥 You've earned a Streak Freeze Token! Here's how it works." |
| After first milestone | "📊 Check Analytics to see your saving patterns." |
| After 5 deposits | "🔍 Tap the search icon to find any deposit fast." |
| After 10 deposits | "📤 You can export your deposit history from Settings." |

**Visual treatment:** A neon-bordered tooltip bubble with a pointing arrow, attached to the relevant UI element. Background is semi-transparent dark. Dismissible by tap. "Don't show again" link inside tooltip.

---

#### SCREEN 15.3 — Returning User Welcome Back Screen

**Purpose:** Shown when user opens the app after an absence of 7+ days (has existing data).

**Trigger:** App launch, if last session > 7 days ago AND user has deposits.

**Layout:** Modal overlay (not full screen — dark overlay behind):
- Personalized greeting: "Welcome back, {name}! 👋"
- Summary of what happened while away: "You've been gone {N} days. Your progress:"
  - Goal A: current %, change from last session.
  - Goal B: current %, change from last session.
  - Streak status: "Your streak was reset. Start fresh today!"
- CTA: "MAKE A DEPOSIT NOW" (primary) + "MAYBE LATER" (link).
- Small note: "We missed you. Your vault is waiting."

---

#### SCREEN 15.4 — App Rating Prompt Screen

**Purpose:** Politely request a store rating at the right moment.

**Trigger conditions (all must be true):**
- User has made ≥ 5 deposits.
- User has been using the app ≥ 7 days.
- User has NOT been prompted before.
- User just completed a positive action (deposit success or milestone).

**Layout:** Custom in-app prompt (NOT the native system dialog yet):
- Glass panel over dashboard.
- Heading: "Enjoying PiggyVault?"
- Subtext: "Your rating helps other savers find us! ⭐"
- Three buttons: "❤️ LOVE IT — Rate Now" / "🔨 Has Issues — Give Feedback" / "⏰ Ask Me Later".
- "Love It" → triggers native `in_app_review` package request.
- "Has Issues" → opens a simple feedback form (email pre-addressed to support).
- "Ask Me Later" → suppresses prompt for 30 days.

---

### SCREEN GROUP 16: SYSTEM & MISCELLANEOUS (4 screens)

---

#### SCREEN 16.1 — Haptic & Sound Settings Screen

**Purpose:** Fine-grained control over haptic feedback and optional sound effects.

**Access:** Settings → "Haptics & Sound".

**Layout:**
- **HAPTIC FEEDBACK** section:
  - Master toggle: "Enable haptic feedback" (on by default).
  - Sub-toggles (shown only when master is on):
    - Button taps (light impact)
    - Deposit confirmation (medium impact)
    - Milestone unlocks (heavy impact + pattern)
    - Achievement unlocks (heavy impact)
    - Streak updates (light impact)
- **SOUND EFFECTS** section:
  - Master toggle: "Enable sound effects" (off by default — opt-in).
  - Sub-toggles (shown when master is on):
    - Deposit success chime
    - Milestone fanfare
    - Achievement unlock sound
    - Level-up sound
  - Preview button next to each sound: "▶ Preview" plays the sound at system volume.
- **Note at bottom**: "All sounds are synthesized digital tones — no intrusive or loud sounds."

---

#### SCREEN 16.2 — Data Privacy Screen

**Purpose:** Transparency about what data is stored and where.

**Access:** Settings → About → "Privacy Policy" (also as a bottom sheet during onboarding, before user sets up goals).

**Layout:**
- "YOUR DATA, YOUR VAULT" heading.
- Clear sections:
  - **What we store**: "Your savings data is stored locally on your device only. We have no servers, no accounts, no cloud sync in v1.0."
  - **What we DON'T do**: No tracking, no analytics, no ads, no selling data.
  - **Backup**: "Back up your data via iOS iCloud backup or Android backup — the app data is included automatically."
  - **Export**: "You can export all your data as CSV at any time from Settings → Export."
  - **Delete**: "Uninstalling the app removes all data permanently."
- "DOWNLOAD PRIVACY POLICY" link (opens PDF or web page).

---

#### SCREEN 16.3 — Open Source Licenses Screen

**Purpose:** Legal attribution for open-source packages used.

**Access:** Settings → About → "Open Source Licenses".

**Layout:** Standard scrollable list of package names + license types. Flutter's built-in `LicensePage` widget, styled to match the app theme (dark background, custom header). No additional custom design required.

---

#### SCREEN 16.4 — Onboarding Re-Entry / Goal Re-Setup Screen

**Purpose:** Allows user to change one goal's fundamental setup (target and deadline) through a guided re-setup flow identical to the original onboarding goal screens, accessed from Settings.

**Access:** Settings → Goal A/B → "Reconfigure Goal".

**Behavior:**
- Presents Goal Setup Screen (1.3) in edit mode, pre-filled with existing values.
- On save: recalculates all milestones, updates projection, recalculates progress percentage.
- If new target < current saved amount: shows warning "Your new target is lower than your current savings — your goal will show as 100%+. Consider a higher target." User can confirm or adjust.
- After save: brief success toast + returns to Settings.

---

## COMPLETE SCREEN INVENTORY — 75 Total

| # | Screen ID | Screen Name | Group |
|---|---|---|---|
| 1 | 1.1 | Splash Screen | Onboarding |
| 2 | 1.2 | Welcome Screen | Onboarding |
| 3 | 1.3a | Goal Setup — PS5 | Onboarding |
| 4 | 1.3b | Goal Setup — Monitor | Onboarding |
| 5 | 1.4 | Currency Setup | Onboarding |
| 6 | 1.5 | Ready / Vault Reveal | Onboarding |
| 7 | 2.1 | Dashboard — Default | Dashboard |
| 8 | 2.2 | Dashboard — Empty State | Dashboard |
| 9 | 2.3 | Dashboard — Streak Warning | Dashboard |
| 10 | 2.4 | Dashboard — Milestone Unlocked | Dashboard |
| 11 | 2.5 | Dashboard — Both Goals Complete | Dashboard |
| 12 | 3.1 | Deposit Screen | Deposit |
| 13 | 3.2 | Deposit Confirm | Deposit |
| 14 | 3.3 | Deposit Success | Deposit |
| 15 | 3.4 | Scheduled Deposit Setup | Deposit |
| 16 | 3.5 | Deposit History | Deposit |
| 17 | 3.6 | Deposit Detail | Deposit |
| 18 | 4.1 | Goal Detail | Goal Detail |
| 19 | 4.2 | Goal Edit | Goal Detail |
| 20 | 4.3 | Goal History | Goal Detail |
| 21 | 4.4 | Goal Projection | Goal Detail |
| 22 | 4.5 | Goal Complete — 100% Celebration | Goal Detail |
| 23 | 5.1 | Analytics Dashboard | Analytics |
| 24 | 5.2 | Streak Calendar | Analytics |
| 25 | 5.3 | Statistics Detail | Analytics |
| 26 | 5.4 | Export Screen | Analytics |
| 27 | 6.1 | Achievements Trophy Room | Achievements |
| 28 | 6.2 | Achievement Detail | Achievements |
| 29 | 6.3 | Achievement Unlock Modal | Achievements |
| 30 | 6.4 | Achievement Unlock Queue | Achievements |
| 31 | 7.1 | Settings Main | Settings |
| 32 | 7.2 | Notification Settings | Settings |
| 33 | 7.3 | Theme Settings | Settings |
| 34 | 7.4 | Currency Settings | Settings |
| 35 | 7.5 | Reset Confirm | Settings |
| 36 | 7.6 | Profile / Avatar Editor | Settings |
| 37 | 7.7 | About Screen | Settings |
| 38 | 7.8 | Import / Export Data | Settings |
| 39 | 8.1 | Milestone — 10% "First Spark" | Milestones |
| 40 | 8.2 | Milestone — 25% "Quarter Power" | Milestones |
| 41 | 8.3 | Milestone — 50% "Halfway There" | Milestones |
| 42 | 8.4 | Milestone — 75% "Almost Ready" | Milestones |
| 43 | 8.5 | Milestone — 90% "Locked In" | Milestones |
| 44 | 8.6 | Both Goals Complete Epic Celebration | Milestones |
| 45 | 9.1 | Onboarding Tooltip Overlays | Utility |
| 46 | 9.2 | Error / Offline Screen | Utility |
| 47 | 9.3 | Loading Skeleton Screen | Utility |
| 48 | 9.4 | Permission Request Screen | Utility |
| 49 | 9.5 | Share Sheet / Generated Card | Utility |
| 50 | 9.6 | App Update Screen | Utility |
| 51 | 10.1 | Streak Detail / Fire Room | Streaks & XP |
| 52 | 10.2 | Streak Freeze Tokens | Streaks & XP |
| 53 | 10.3 | Personal Records | Streaks & XP |
| 54 | 10.4 | Daily Challenge | Streaks & XP |
| 55 | 10.5 | XP & Level Progress | Streaks & XP |
| 56 | 11.1 | Quick Deposit Bottom Sheet | Quick Actions |
| 57 | 11.2 | Home Screen Widget Setup | Quick Actions |
| 58 | 11.3 | App Icon Shortcut Setup | Quick Actions |
| 59 | 11.4 | Notification-Triggered Deposit | Quick Actions |
| 60 | 12.1 | Global Search | Search |
| 61 | 12.2 | Advanced Filter | Search |
| 62 | 12.3 | Filtered Results | Search |
| 63 | 13.1 | Share Achievement Card Preview | Social |
| 64 | 13.2 | Share Progress Card Preview | Social |
| 65 | 13.3 | Invite / Refer a Friend | Social |
| 66 | 14.1 | Edit Deposit | Edit & Correction |
| 67 | 14.2 | Bulk Delete | Edit & Correction |
| 68 | 14.3 | Delete Confirm Dialog | Edit & Correction |
| 69 | 15.1 | What's New Modal | Re-engagement |
| 70 | 15.2 | Feature Discovery Tooltips | Re-engagement |
| 71 | 15.3 | Returning User Welcome Back | Re-engagement |
| 72 | 15.4 | App Rating Prompt | Re-engagement |
| 73 | 16.1 | Haptic & Sound Settings | System |
| 74 | 16.2 | Data Privacy Screen | System |
| 75 | 16.3 | Open Source Licenses | System |
| 76 | 16.4 | Goal Re-Setup / Reconfigure | System |

**Total: 76 screens / states / overlays.**

---

*End of specification. Build something remarkable.*

---

## PART 6 — MEGA EXPANSION: 65 NEW FEATURES & MECHANICS
*(Added via Phase 1 Expansion)*

### 6.1 Advanced Gamification & RPG Elements
1. **Cyber-Crates (Lootboxes):** Earn crates for every 1000 UAH saved or 7-day streak. Contains UI skins, neon colors, sounds.
2. **Vault Pets:** Holographic dashboard pets that "feed" on deposits.
3. **Daily Spin / Hack Attempt:** Daily roulette for streak freezes, XP, or multipliers.
4. **Critical Deposits:** 5% chance for a deposit to trigger a "Critical Hit" for x3 XP.
5. **Skill Tree:** Spend level-up points on perks (e.g., cheaper themes, split deposit bonuses).
6. **Side Missions:** Temporary weekend quests (e.g., "Deposit 2 odd amounts").
7. **Vault Evolution:** Goal icons evolve from blueprints to 3D models based on progress.
8. **Boss Fights:** Fight temptation. Track money saved by skipping fast food, triggering a "boss defeat" animation.
9. **Player Classes:** Level 10 choice: "Sniper" (big, rare deposits) or "Gunner" (frequent, small deposits).
10. **Voice Logs:** Record audio messages when depositing. Compiled into a podcast at 100%.

### 6.2 Social & Competitive
11. **Squad Goals (Co-op):** Link with a partner for shared goal tracking.
12. **Cyber-Arena (Anonymous Leaderboard):** Rank by streak/XP.
13. **Savings Duels:** Challenge friends to 7-day consistency duels.
14. **World Events:** Community-wide goals (e.g., "Save 1M combined") for legendary badges.
15. **Cyber-Syndicates (Guilds):** 5-player groups with shared XP boosts.
16. **Holo-Cards:** Exportable, styled stat cards for Instagram/Telegram.
17. **Respects:** Friends can react to your unlocked achievements.

### 6.3 Smart Finance & Motivational Analytics
18. **Saved-From Tagging:** Tag deposits (Coffee, Taxi) and view charts on what funded the PS5.
19. **Spare Change Simulator:** Evening push: "Round up today's spending by 34 UAH?"
20. **Investment Calculator:** "What if this was in a 10% APY bank account?" projection.
21. **Dynamic Inflation:** Adjust target amounts mid-way if prices increase, with "breaking the ceiling" animations.
22. **Mood Tracker:** Track emotion during deposits to see long-term sentiment changes.
23. **Time Travel Slider:** "If I add 50 UAH more each time, I finish 42 days early."
24. **Prime Time Patterns:** AI detects best time of day to send deposit reminders.
25. **Virtual APY:** App awards XP "dividends" for simply holding the streak.
26. **Cyber-Statement:** Export PDF dossier of all savings activity.

### 6.4 Customization & Attention Economy
27. **Black Market:** Buy UI color themes (Toxic Green, Blood Red) with XP.
28. **Custom Sound Packs:** 8-bit, Mechanical Keyboard, Zen Chimes.
29. **Progress Ring Skins:** Speedometer, HP Bar, Sci-Fi Energy Shield.
30. **Transaction Stickers:** Add pixel emoji to history list items.
31. **Cyber-Avatar Maker:** Build avatar with unlockable neon glasses and implants.
32. **Screensavers:** Gyroscope-reactive particle idle screens if left open for 3 minutes.
33. **UI Fonts:** Buy terminal or pixel fonts with XP.

### 6.5 OS Integration, Widgets & Automation
34. **Interactive Widgets:** Deposit 50 UAH directly from iOS/Android home screen.
35. **Live Activities / Dynamic Island:** "Dark Zone" 24h no-spend countdown.
36. **Voice Commands:** "Siri, transfer 200 to PS5 in PiggyVault."
37. **Smartwatch Companion:** WearOS/Apple Watch app for 1-tap deposits.
38. **Payday Boost:** Calendar integration to suggest large deposits on payday.
39. **NFC Tags:** Tap phone to desk NFC to open deposit screen.
40. **AR Mode:** Place 3D PS5/Monitor on your desk via ARKit/ARCore.
41. **Quick Actions:** Long-press app icon for quick deposits.

### 6.6 Retention & Events
42. **Flash Events:** "Next 2 hours: x5 XP for any deposit!"
43. **Weekend Mystery Box:** Appears Friday, unlocks Sunday if you deposit.
44. **Recovery Protocol:** If streak dies, 12h window to save a double deposit to restore it.
45. **Dark Zone Challenge:** Opt-in 3-day no-spend mode for legendary XP.
46. **Cyber-Provocation Pushes:** Sassy notifications (e.g., "Protocol Monitor needs fuel, Samurai").
47. **Deposit QTE (Quick Time Event):** Tap screen at the right time after confirming to get bonus XP.
48. **Penalty Vault:** Bind bad habits. Pressing the habit button deducts a "fine" into the vault.

### 6.7 Quality of Life (QoL)
49. **Swipe-to-Deposit:** Swipe up on vault card on dashboard to quick-deposit default amount.
50. **Change Calculator:** Math input in deposit keypad (e.g., `500 - 340`).
51. **Undo / Rewind:** 5-second VHS-glitch window to undo a mistaken deposit.
52. **Cyber-Lock (FaceID):** Biometric lock with retinal-scan aesthetic.
53. **Dice Roll:** Button to generate a random small deposit amount.
54. **Drag-and-Drop Reallocation:** Drag PS5 card onto Monitor card to transfer funds.
55. **SMS Parsing:** (Opt-in via OS) Read spending and suggest rounding up.

### 6.8 Endgame & Micromanagement
56. **Overcharge Mode:** Continue depositing past 100% (progress bar turns red) for secret achievements.
57. **Prestige Mode (New Game+):** Resetting a 100% goal gives a permanent veteran star.
58. **Side Quests Vaults:** Temporary 1-week mini-goal (e.g., "Steam Game 400 UAH").
59. **Hall of Fame:** 3D gallery of past completed goals.
60. **Checkout Mode:** Initiate a massive celebration and "Mission Accomplished" receipt generation.
61. **Burn-down Chart:** Last 10% shows a countdown timer of remaining deposits.
62. **Sale Tracker:** Temporary target reduction with pulsing urgency timer.
63. **Holo-Assistant:** Text tips from a JARVIS-style AI on the dashboard.
64. **Black Market Trader:** Pop-up timed offers (e.g., "Deposit 300 now for an exclusive skin").
65. **Deposit Rarity:** Small = Common (White), Medium = Rare (Blue), Large = Epic (Purple), Massive = Legendary (Gold).

---

**Document metadata:**
- Created: May 2026
- Format: Universal AI Agent Prompt (Markdown)
- Compatible with: Claude Code, Claude Sonnet/Opus, Gemini 2.5 Pro, GPT-4o/o3, Cursor, Cline, Bolt
- Word count: ~11,500 words
- Screen count covered: **76 screens / states / overlays** (7 groups added: Streaks & XP, Quick Actions, Search, Social, Edit, Re-engagement, System)
