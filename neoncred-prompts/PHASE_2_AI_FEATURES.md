# NEONCRED — PHASE 2: AI-POWERED FEATURES
## Kiro Design-First Spec | Priority: P1 (High)
### Фічі: RepForge · SwarmDrop · ParadoxCtrl · NudgeLab · HoloTrophies · InfoScan · PriceOracle · ReceiptRip · NeonPet · BudgetHelix

---

> **ПЕРЕД СТАРТОМ:** Прочитай `PHASE_0_CONTEXT_MASTER.md`.
> Phase 1 повинна бути завершена (schemaVersion: 21).
> Ця фаза використовує `OpenRouterService` майже у всіх фічах.

---

## DESIGN CONTEXT

```
After Phase 1: schemaVersion = 21
New tables from Phase 1: GraveyardEntries, FutureSelfProjections,
                          LootBoxResults, BankSyncConfigs, AutoDeposits
This phase adds: schemaVersion 22
OpenRouter: використовувати існуючий OpenRouterService
```

---

## FEATURE 6: RepForge (Reputation Forge)

**Route:** `/reputation-forge`

### БД (schemaVersion: 22):
```dart
class ReputationProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  IntColumn get score => integer().withDefault(const Constant(0))(); // 0-100
  TextColumn get tier => text().withDefault(const Constant('Novice'))();
  // tiers: Novice/Apprentice/Adept/Expert/Master/Legend
  RealColumn get fulfillmentRate => real().withDefault(const Constant(0.0))();
  IntColumn get karmaContributions => integer().withDefault(const Constant(0))();
}

class PublicCommitments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get title => text()();
  DateTimeColumn get deadline => dateTime()();
  IntColumn get xpStake => integer()();
  IntColumn get karmaStake => integer()();
  BoolColumn get isFulfilled => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}
```

### UI:
- Reputation score (0-100) з tier badge (Orbitron, відповідний колір)
- Список публічних зобов'язань з countdown таймерами
- Діалог "Зробити зобов'язання": назва, дедлайн, ставка XP/карми
- % виконання зобов'язань
- AI-пропозиції зобов'язань на основі поведінки (OpenRouter)

---

## FEATURE 7: SwarmDrop (Flash Mob)

**Route:** `/flash-mob`

### БД:
```dart
class FlashMobEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  RealColumn get multiplier => real()(); // 1.5, 2.0, 3.0
  IntColumn get participantCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get startAt => dateTime()();
  DateTimeColumn get endAt => dateTime()();
  BoolColumn get isJoined => boolean().withDefault(const Constant(false))();
  IntColumn get xpBonus => integer()();
}
```

### UI:
- Активні події з countdown таймерами
- Multiplier badge (cyan для 1.5x, purple для 2x, gold для 3x)
- Анімований лічильник учасників
- Кнопка "Приєднатись" → депозит з множником XP
- Минулі події з результатами
- AI-генеровані описи подій (OpenRouter)

---

## FEATURE 8: ParadoxCtrl (Choice Paradox — Savings Contracts)

**Route:** `/choice-paradox`

### БД:
```dart
class SavingsContracts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get contractType => text()();
  // types: weekly_deposit_target/no_spend_challenge/minimum_daily
  IntColumn get targetAmount => integer()(); // копійки
  IntColumn get xpStake => integer()();
  IntColumn get karmaStake => integer()();
  IntColumn get currentProgress => integer()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get isFulfilled => boolean().withDefault(const Constant(false))();
  BoolColumn get isBroken => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}
```

### UI:
- Список активних контрактів з прогрес-барами
- Ставки XP і карми "під ризиком" (червоний акцент)
- Діалог "Створити контракт": тип, сума, строк
- AI-рекомендації контрактів (OpenRouter)

---

## FEATURE 9: NudgeLab (Behavioral Experiments)

**Route:** `/nudge-lab`

### БД:
```dart
class NudgeExperiments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nudgeType => text()();
  // types: loss_aversion/social_proof/anchoring/scarcity/gamification
  TextColumn get variant => text()(); // A або B
  IntColumn get impressions => integer().withDefault(const Constant(0))();
  IntColumn get conversions => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get startedAt => dateTime()();
}

class PersuasionProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get dominantNudge => text()();
  RealColumn get lossAversionScore => real()();
  RealColumn get socialProofScore => real()();
  RealColumn get anchoringScore => real()();
  RealColumn get scarcityScore => real()();
  RealColumn get gamificationScore => real()();
}
```

### UI:
- Активні A/B експерименти з варіантами
- Лічильники impressions та conversions
- Домінуючий nudge type
- Radar chart ефективності (fl_chart або custom painter)
- Діалог "Запустити експеримент"
- Профіль переконання з 5 шкалами

---

## FEATURE 10: HoloTrophies (3D Trophy Gallery)

**Route:** `/trophy-gallery`
> ⚠️ В проєкті вже є маршрут `/trophies` — перевір чи є екран. Якщо є — розшир або злий.

### БД:
```dart
class TrophyEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get name => text()();
  TextColumn get tier => text()(); // Common/Rare/Epic/Legendary/Mythic
  IntColumn get milestoneAmount => integer()(); // копійки
  BoolColumn get isUnlocked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get unlockedAt => dateTime().nullable()();
  TextColumn get sketchfabModelId => text().nullable()();
  TextColumn get aiDescription => text().nullable()();
}
```

### UI:
- Grid трофеїв з tier кольорами
- Locked = grayscale + замок іконка
- Unlocked = кольоровий + glow ефект
- "Переглянути 3D" → WebView з Sketchfab (якщо є model ID)
- Статистика: всього трофеїв / по тирах / останнє розблокування
- AI-опис трофея (OpenRouter)

---

## FEATURE 11: InfoScan (Financial News Radar)

**Route:** `/news-radar`

### БД:
```dart
class NewsInsights extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get summary => text()();
  TextColumn get category => text()(); // currency/crypto/economy/tech/retail
  IntColumn get relevanceScore => integer()(); // 0-100
  BoolColumn get isActionable => boolean().withDefault(const Constant(false))();
  TextColumn get aiSuggestion => text().nullable()();
  IntColumn get relatedGoalId => integer().nullable()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get publishedAt => dateTime()();
}
```

### UI:
- News feed з relevance score барами
- Category badges (кольоровий тег)
- "Actionable" badge (green) якщо є конкретна порада
- AI summary для кожної новини (OpenRouter)
- Лінк до пов'язаної цілі
- Unread індикатор (cyan dot)

---

## FEATURE 12: PriceOracle (Price Tracker)

**Route:** `/price-oracle`

### БД:
```dart
class PriceWatchItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get name => text()();
  TextColumn get searchQuery => text()();
  IntColumn get currentPrice => integer()(); // копійки
  IntColumn get previousPrice => integer()(); // копійки
  IntColumn get targetPrice => integer()(); // копійки (alert threshold)
  TextColumn get storeName => text().nullable()();
  TextColumn get alertType => text()(); // push/in_app/both
  TextColumn get aiPrediction => text().nullable()();
  DateTimeColumn get lastCheckedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
```

### UI:
- Watch list: поточна/попередня/цільова ціна
- Індикатори зміни ціни (стрілка вгору/вниз + колір)
- Діалог "Додати товар" з пошуком (SERP API)
- Налаштування alert: цільова ціна, тип сповіщення
- Графік історії цін (fl_chart)
- AI прогноз ціни (OpenRouter)

---

## FEATURE 13: ReceiptRip (Receipt Scanner)

**Route:** `/receipt-scanner`

### БД:
```dart
class ScannedReceipts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get merchant => text()();
  IntColumn get amount => integer()(); // копійки
  TextColumn get category => text()();
  IntColumn get savingsPotential => integer()(); // копійки
  TextColumn get aiMotivation => text().nullable()();
  BoolColumn get isImpulseBuy => boolean().withDefault(const Constant(false))();
  TextColumn get imagePath => text().nullable()();
  DateTimeColumn get scannedAt => dateTime()();
}
```

### UI:
- Кнопка камера/галерея для імпорту фото чека
- OCR обробка (Mindee API або mock)
- Merchant, сума, категорія після розпізнавання
- "Savings Potential" badge
- AI мотиваційне повідомлення (OpenRouter)
- Індикатор "Імпульсна покупка"
- Тижневий spending summary chart
- Pie chart категорій витрат

---

## FEATURE 14: NeonPet (Cyber-Pet Companion)

**Route:** `/cyber-pet`
> ⚠️ В проєкті вже є маршрут `/pets` — перевір. Якщо є базовий екран — розшир до повної специфікації.

### БД (перевір чи вже є таблиця Pets в schemaVersion 20):
```dart
// Якщо Pets таблиця вже є — додати поля через ALTER TABLE в міграції
// Якщо немає — створити:
class CyberPets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get petType => text()(); // NeonCat/CircuitDog/DataDragon
  TextColumn get name => text()();
  IntColumn get health => integer().withDefault(const Constant(100))(); // 0-100
  IntColumn get happiness => integer().withDefault(const Constant(100))(); // 0-100
  TextColumn get evolutionStage => text().withDefault(const Constant('Egg'))();
  // stages: Egg/Baby/Teen/Adult/Mega/Ultra
  IntColumn get totalFeedings => integer().withDefault(const Constant(0))();
  IntColumn get daysTogether => integer().withDefault(const Constant(0))();
  TextColumn get accessories => text().withDefault(const Constant('[]'))(); // JSON list
  DateTimeColumn get adoptedAt => dateTime()();
}
```

### UI:
- Вибір петів: NeonCat, CircuitDog, DataDragon
- Pet display: 200x200 circle з pulse glow анімацією (AnimationController)
- Dialogue bubble з AI-повідомленнями (OpenRouter)
- Stat bars: Health (зелений), Happiness (cyan)
- Evolution progress: Egg→Baby→Teen→Adult→Mega→Ultra
- Кнопки: "Погладити" (free), "Поговорити" (AI), "Годувати" (депозит 100 грн)
- Магазин аксесуарів: купити за XP

---

## FEATURE 15: BudgetHelix (Budget DNA Scanner)

**Route:** `/budget-dna`

### БД:
```dart
class BudgetEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get category => text()();
  IntColumn get monthlyLimit => integer()(); // копійки
  IntColumn get spentAmount => integer()(); // копійки
  TextColumn get month => text()(); // "2026-06" format
  BoolColumn get isBreach => boolean().withDefault(const Constant(false))();
}

class BudgetReports extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get month => text()();
  IntColumn get totalSpent => integer()(); // копійки
  IntColumn get totalLimit => integer()(); // копійки
  RealColumn get savingsRate => real()();
  TextColumn get aiAnalysis => text().nullable()();
  IntColumn get usdUahRate => integer()(); // копійки (наприклад 4150 = 41.50 грн/USD)
  IntColumn get eurUahRate => integer()();
  RealColumn get inflationRate => real()();
}
```

### UI:
- Список категорій бюджету з лімітами та витратами
- Червоний індикатор при перевищенні ліміту
- Місячна звітна картка (grade: A/B/C/D)
- Економічні індикатори: USD/UAH, EUR/UAH, інфляція
- AI аналіз місяця (OpenRouter)
- Savings rate %
- Діалог "Додати категорію"
- DNA-helix візуалізація (custom painter або SVG)

---

## НАВІГАЦІЯ — що додати

```dart
GoRoute(path: '/reputation-forge', builder: (_, __) => const ReputationForgeScreen()),
GoRoute(path: '/flash-mob',        builder: (_, __) => const FlashMobScreen()),
GoRoute(path: '/choice-paradox',   builder: (_, __) => const ChoiceParadoxScreen()),
GoRoute(path: '/nudge-lab',        builder: (_, __) => const NudgeLabScreen()),
GoRoute(path: '/trophy-gallery',   builder: (_, __) => const TrophyGalleryScreen()),
GoRoute(path: '/news-radar',       builder: (_, __) => const NewsRadarScreen()),
GoRoute(path: '/price-oracle',     builder: (_, __) => const PriceOracleScreen()),
GoRoute(path: '/receipt-scanner',  builder: (_, __) => const ReceiptScannerScreen()),
GoRoute(path: '/cyber-pet',        builder: (_, __) => const CyberPetScreen()),
GoRoute(path: '/budget-dna',       builder: (_, __) => const BudgetDNAScreen()),
```

## БД МІГРАЦІЯ

```dart
// schemaVersion: 22
if (from < 22) {
  await m.createTable(reputationProfiles);
  await m.createTable(publicCommitments);
  await m.createTable(flashMobEvents);
  await m.createTable(savingsContracts);
  await m.createTable(nudgeExperiments);
  await m.createTable(persuasionProfiles);
  await m.createTable(trophyEntries);
  await m.createTable(newsInsights);
  await m.createTable(priceWatchItems);
  await m.createTable(scannedReceipts);
  await m.createTable(cyberPets);
  await m.createTable(budgetEntries);
  await m.createTable(budgetReports);
}
```

---

## ACCEPTANCE CRITERIA

- [ ] Всі 10 екранів відкриваються без помилок
- [ ] AI-виклики (OpenRouter) відпрацьовують і показують результат або fallback
- [ ] НeonPet анімується (pulse glow) без frame drops
- [ ] BudgetHelix показує реальні дані з БД
- [ ] PriceOracle зберігає та відображає watchlist
- [ ] schemaVersion = 22, міграція 21→22 без помилок
- [ ] Всі 10 карток є у Feature Grid
- [ ] Всі перевірки з Phase 0 (копійки, withOpacity, без emoji) виконані

---

*Phase 2 | NEONCRED v2.0 | 10 features | schemaVersion: 21 → 22*
