# NEONCRED — PHASE 4: ADVANCED ANALYTICS & BEHAVIORAL SYSTEMS
## Kiro Design-First Spec | Priority: P3 (Extended)
### Фічі: ReGear · SeasonPulse · Momentum · PriceWar · HaggleAI · FlexPrice · StockGhost · LoanTracker · GoalSync · HabitForge · InflaShield · PriceEye · LinkRip · ShowroomShield · ChronoSaver · QuestChain · SageAI · InflaWall

---

> **ПЕРЕД СТАРТОМ:** Прочитай `PHASE_0_CONTEXT_MASTER.md`.
> Phases 1-3 повинні бути завершені (schemaVersion: 23).
> Ця фаза — фінальні 18 фіч: аналітика, поведінкові системи, геймифікація.

---

## DESIGN CONTEXT

```
After Phase 3: schemaVersion = 23
This phase adds: schemaVersion 24
This is the final phase — всі 47 фіч будуть реалізовані після неї
Emphasis: depth of analytics, AI coaching, game mechanics
```

---

## FEATURE 30: ReGear (Secondhand Price Analyzer)

**Route:** `/secondhand-analyzer`

### БД:
```dart
class SecondHandItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  IntColumn get newPrice => integer()(); // копійки
  IntColumn get usedPriceMin => integer()(); // копійки
  IntColumn get usedPriceMax => integer()(); // копійки
  IntColumn get recommendedUsedPrice => integer()(); // копійки
  RealColumn get depreciationRate => real()(); // % за рік
  TextColumn get condition => text()(); // excellent/good/fair/poor
  TextColumn get platform => text()(); // OLX/Rozetka/eBay
  DateTimeColumn get analyzedAt => dateTime()();
}
```

### UI:
- Пошук товару → аналіз б/у цін
- Порівняння: нова ціна vs рекомендована б/у
- Стан товару: Excellent/Good/Fair/Poor з ціновими поправками
- Платформи: OLX, Rozetka, eBay
- "Розумна пропозиція" — рекомендована ціна при покупці б/у

---

## FEATURE 31: SeasonPulse (Seasonal Price Calendar)

**Route:** `/seasonal-calendar`

### БД:
```dart
class CalendarSubscriptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productCategory => text()();
  BoolColumn get isSubscribed => boolean().withDefault(const Constant(true))();
}

class PriceEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get eventName => text()();
  TextColumn get productCategory => text()();
  IntColumn get expectedDropPercent => integer()(); // очікуваний % знижки
  DateTimeColumn get eventDate => dateTime()();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(true))();
  TextColumn get recurrencePattern => text().nullable()(); // yearly/monthly
}
```

### UI:
- Календарний вигляд з позначеними датами розпродажів
- Категорії: Electronics, Gaming, Appliances
- "До розпродажу" countdown
- Очікуваний % знижки для кожної події
- Push reminder за 7 днів до події

---

## FEATURE 32: Momentum (Price Momentum Tracker)

**Route:** `/price-momentum`

### БД:
```dart
class MomentumItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  IntColumn get price7dAgo => integer()(); // копійки
  IntColumn get price30dAgo => integer()(); // копійки
  IntColumn get currentPrice => integer()(); // копійки
  RealColumn get momentum7d => real()(); // % зміна за 7 днів
  RealColumn get momentum30d => real()(); // % зміна за 30 днів
  TextColumn get trend => text()(); // rising/falling/stable
  DateTimeColumn get updatedAt => dateTime()();
}
```

### UI:
- Список товарів з momentum індикаторами
- Trend arrows: зростання (red), падіння (green), стабільно (cyan)
- Momentum score: -100 до +100
- Рекомендація: "Зараз добрий час купити" / "Чекай"
- Sparkline тренд за 30 днів

---

## FEATURE 33: PriceWar (Store Price War Sentinel)

**Route:** `/price-war`

### БД:
```dart
class PriceWarEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  TextColumn get store1Name => text()();
  IntColumn get store1Price => integer()(); // копійки
  TextColumn get store2Name => text()();
  IntColumn get store2Price => integer()(); // копійки
  IntColumn get priceDifference => integer()(); // копійки
  TextColumn get winner => text()(); // store1/store2/tied
  DateTimeColumn get detectedAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
```

### UI:
- "Цінові війни" між магазинами в реальному часі
- Versus карточка: Магазин А vs Магазин Б
- Winner badge
- Різниця в ціні (скільки можна зекономити)
- Нотатки "Найактивніша конкуренція зараз"

---

## FEATURE 34: HaggleAI (AI Haggling Coach)

**Route:** `/haggling-coach`

### БД:
```dart
class HagglingSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  IntColumn get listedPrice => integer()(); // копійки
  IntColumn get targetPrice => integer()(); // копійки
  TextColumn get platform => text()(); // OLX/in_store/online
  TextColumn get script => text().nullable()(); // AI скрипт
  TextColumn get outcome => text().nullable()(); // won/lost/pending
  IntColumn get finalPrice => integer().nullable()(); // копійки
  DateTimeColumn get sessionAt => dateTime()();
}
```

### UI:
- Ввести: назву товару, прошену ціну, бажану ціну, платформу
- AI генерує скрипт переговорів (OpenRouter)
- Фрази для початку, торгу, фіналу
- "Результат торгу" кнопки: Виграв/Програв/В процесі
- Статистика: % успішних торгів, середня економія

---

## FEATURE 35: FlexPrice (Price Elasticity Explorer)

**Route:** `/price-elasticity`

### БД:
```dart
class ElasticityItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  IntColumn get basePrice => integer()(); // копійки
  RealColumn get elasticityScore => real()(); // -3.0 до 0
  TextColumn get category => text()(); // elastic/inelastic/unit_elastic
  TextColumn get insight => text().nullable()(); // AI пояснення
  DateTimeColumn get calculatedAt => dateTime()();
}
```

### UI:
- Пошук товару → аналіз еластичності ціни
- Шкала еластичності (-3.0 до 0)
- Категорія: Elastic (чутливий до ціни) / Inelastic / Unit Elastic
- Практичний інсайт: "Якщо ціна зросте на 10% — попит впаде на X%"
- Рекомендація для покупця

---

## FEATURE 36: StockGhost (Inventory Price Stalker)

**Route:** `/inventory-stalker`

### БД:
```dart
class InventoryStalkerItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  TextColumn get storeName => text()();
  TextColumn get stockStatus => text()(); // in_stock/out_of_stock/low_stock
  IntColumn get currentPrice => integer().nullable()(); // копійки
  IntColumn get lastInStockPrice => integer().nullable()(); // копійки
  BoolColumn get notifyWhenBack => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastCheckedAt => dateTime().nullable()();
  DateTimeColumn get addedAt => dateTime()();
}
```

### UI:
- Список товарів "які слідкую"
- Status badges: В наявності (green) / Немає (red) / Мало (orange)
- "Сповістити коли з'явиться" toggle
- Ціна коли востаннє був в наявності
- Ghost-стиль анімація для out-of-stock товарів

---

## FEATURE 37: LoanTracker (Lending & Debt Tracker)

**Route:** `/lending-tracker`
> ⚠️ Перевір — в проєкті вже є таблиця `LendingContracts`. Використай її або розшир.

### БД: (розшир існуючу `LendingContracts` або додай нову якщо структура не підходить)
```dart
class LendingRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get counterpartyName => text()();
  IntColumn get amount => integer()(); // копійки
  TextColumn get direction => text()(); // lent/borrowed
  TextColumn get reason => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get isSettled => boolean().withDefault(const Constant(false))();
  DateTimeColumn get settledAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
```

### UI:
- Список: "Я позичив" / "Мені позичили"
- Сума, кому, коли повернути
- "Позначити повернутим" кнопка
- Загальний баланс (скільки треба отримати / повернути)
- Прострочені борги (red highlight)

---

## FEATURE 38: GoalSync (Goal-Price Integrator)

**Route:** `/goal-price-integrator`

### БД:
```dart
class GoalProductLinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId => integer()();
  TextColumn get productName => text()();
  TextColumn get searchQuery => text()();
  IntColumn get linkedPrice => integer()(); // копійки
  TextColumn get storeName => text().nullable()();
  BoolColumn get autoUpdateTarget => boolean().withDefault(const Constant(false))();
  DateTimeColumn get linkedAt => dateTime()();
}
```

### UI:
- Прив'язати ціль до конкретного продукту
- Автоматично оновлювати target amount якщо ціна змінилась
- "Ціль прив'язана до: PS5 Slim — Rozetka — 18,999 грн"
- Індикатор зміни: "Ціль зросла на 500 грн через зміну ціни"
- Sync кнопка для ручного оновлення

---

## FEATURE 39: HabitForge (Habit Loop Builder)

**Route:** `/habit-loop-forge`

### БД:
```dart
class HabitLoops extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get triggerEvent => text()(); // morning/payday/coffee/custom
  TextColumn get routine => text()(); // що робити (deposit amount)
  IntColumn get routineAmount => integer()(); // копійки
  IntColumn get rewardXp => integer()();
  IntColumn get completionsCount => integer().withDefault(const Constant(0))();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastCompletedAt => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
```

### UI:
- Список звичок: Тригер → Дія → Нагорода
- Тригери: Ранок, День зарплати, Після кави, Кастомний
- Статистика: streak, кількість виконань
- Кнопка "Виконати зараз" (manual trigger)
- Habit heatmap (як GitHub contribution graph)

---

## FEATURE 40: InflaShield (Inflation Alert System)

**Route:** `/inflation-shield`

### БД:
```dart
class InflationShields extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  IntColumn get goalId => integer()();
  RealColumn get inflationRate => real()(); // поточна %
  IntColumn get originalTargetAmount => integer()(); // копійки на початку
  IntColumn get adjustedTargetAmount => integer()(); // копійки з урахуванням інфляції
  IntColumn get additionalNeeded => integer()(); // копійки різниці
  DateTimeColumn get calculatedAt => dateTime()();
}
```

### UI:
- Поточний рівень інфляції в Україні (з API або mock)
- Вплив на кожну ціль: на скільки виросла реальна ціна
- "Скільки додатково потрібно накопичити через інфляцію"
- Shield анімація (cyan shield відбиває інфляційні "атаки")
- Рекомендація: збільшити щомісячний депозит на X грн

---

## FEATURE 41: PriceEye (Price History Detective)

**Route:** `/price-detective`

### БД:
```dart
class PriceDetectiveItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  TextColumn get searchQuery => text()();
  IntColumn get currentPrice => integer()(); // копійки
  IntColumn get priceAllTimeMin => integer()(); // копійки
  IntColumn get priceAllTimeMax => integer()(); // копійки
  IntColumn get priceAverage => integer()(); // копійки
  TextColumn get pricePattern => text().nullable()(); // seasonal/volatile/stable
  TextColumn get aiDetectiveReport => text().nullable()();
  DateTimeColumn get investigatedAt => dateTime()();
}
```

### UI:
- Detective-стиль UI: "розслідуємо" цінову históю
- All-time min / max / average
- Патерн: Сезонний / Волатильний / Стабільний
- AI "звіт детектива" (OpenRouter): коли краще купити
- Magnifying glass анімація в cyberpunk стилі

---

## FEATURE 42: LinkRip (URL Wishlist Scanner)

**Route:** `/wishlist-url-scanner`

### БД:
```dart
class WishlistUrls extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get url => text()();
  TextColumn get productName => text().nullable()();
  IntColumn get extractedPrice => integer().nullable()(); // копійки
  TextColumn get storeName => text().nullable()();
  TextColumn get status => text()(); // pending/extracted/failed
  DateTimeColumn get addedAt => dateTime()();
  DateTimeColumn get lastCheckedAt => dateTime().nullable()();
}
```

### UI:
- Paste URL → автоматичне витягування назви і ціни
- Список відстежуваних URL
- Кнопка "Перевірити ціну" (re-fetch)
- "Додати до WishScan" — пов'язати з WishlistRadar
- Помилка якщо URL не розпізнано

---

## FEATURE 43: ShowroomShield (Showroom Price Shield)

**Route:** `/price-shield`

### БД:
```dart
class PriceShieldScans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  IntColumn get inStorePrice => integer()(); // копійки
  IntColumn get onlinePrice => integer().nullable()(); // копійки
  TextColumn get inStoreName => text()();
  TextColumn get onlineStoreName => text().nullable()();
  IntColumn get savingsPotential => integer()(); // копійки
  BoolColumn get isFairPrice => boolean()();
  DateTimeColumn get scannedAt => dateTime()();
}
```

### UI:
- "Ти в магазині — перевір чи ціна справедлива"
- Ввести: назва товару, ціна в магазині
- Порівняти з онлайн цінами (SERP API)
- "Справедлива ціна" / "Краще онлайн" індикатор
- Потенційна економія якщо купити онлайн
- Загальна статистика: скільки зекономлено завдяки ShowroomShield

---

## FEATURE 44: ChronoSaver (Savings Time Machine)

**Route:** `/savings-time-machine`

### БД:
```dart
class TimeMachineProjections extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId => integer()();
  TextColumn get scenarioName => text()();
  RealColumn get depositIncreasePercent => real()();
  IntColumn get lumpSumAmount => integer()(); // копійки
  TextColumn get depositFrequency => text()(); // daily/weekly/monthly
  DateTimeColumn get projectedCompletionDate => dateTime()();
  IntColumn get projectedFinalAmount => integer()(); // копійки
  DateTimeColumn get calculatedAt => dateTime()();
}
```

### UI:
- "What if" слайдери:
  - Збільш депозит на X% → нова дата виконання
  - Додай одноразову суму → прискорення
  - Змінити частоту: щодня/щотижня/щомісяця
- Порівняння: поточний темп vs прискорений темп
- Timeline візуалізація
- AI рекомендації для швидшого досягнення (OpenRouter)
- "Зберегти проєкцію" кнопка

---

## FEATURE 45: QuestChain (Savings Quest Chain)

**Route:** `/quest-chain`

### БД:
```dart
class QuestChains extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get questType => text()();
  // types: daily_deposit/reach_percentage/maintain_streak/no_spend_day/specific_amount
  TextColumn get questTitle => text()();
  IntColumn get targetValue => integer()(); // копійки або дні
  IntColumn get currentValue => integer().withDefault(const Constant(0))();
  IntColumn get xpReward => integer()();
  TextColumn get badgeReward => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get chainOrder => integer()(); // позиція в ланцюжку (1, 2, 3...)
  IntColumn get parentQuestId => integer().nullable()(); // попередній квест
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
}
```

### UI:
- Ланцюжок квестів: connected nodes (як рівні в грі)
- Поточний квест підсвічений (cyan glow)
- Locked наступні квести (grey)
- Completed = green checkmark + XP badge
- Типи квестів: щоденний депозит / досягти X% / streak / день без витрат / конкретна сума
- Нагорода при завершенні ланцюжка: анімація святкування
- AI-генерація нових квестів на основі поведінки (OpenRouter)
- "Почати квест" кнопка

---

## FEATURE 46: SageAI (Predictive Savings Coach)

**Route:** `/predictive-coach`

### БД:
```dart
class CoachPredictions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get predictionType => text()();
  // types: will_miss_deposit/will_break_streak/goal_at_risk/optimal_deposit_day
  RealColumn get confidence => real()(); // 0.0 - 1.0
  TextColumn get predictionText => text()();
  TextColumn get actionSuggestion => text()();
  BoolColumn get wasCorrect => boolean().nullable()();
  DateTimeColumn get predictedFor => dateTime()();
  DateTimeColumn get generatedAt => dateTime()();
}
```

### UI:
- Dashboard прогнозів з рівнями confidence
- Типи: "Ризик пропустити депозит", "Streak під загрозою", "Ціль в небезпеці"
- Аналіз поведінкових патернів
- Proactive notifications (flutter_local_notifications)
- AI коучинг повідомлення (OpenRouter)
- Точність прогнозів: % правильних передбачень
- "Запитати коуча" — chat interface з AI

---

## FEATURE 47: InflaWall (Anti-Inflation Shield Game)

**Route:** `/inflation-game`

### БД:
```dart
class InflationWaves extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  IntColumn get waveNumber => integer()();
  RealColumn get inflationRate => real()(); // % атаки
  IntColumn get savingsDefended => integer()(); // копійки
  IntColumn get savingsLost => integer()(); // копійки
  IntColumn get score => integer()();
  BoolColumn get isWaveWon => boolean()();
  DateTimeColumn get playedAt => dateTime()();
}
```

### UI — МІНІ-ГРА:
- Wave-based gameplay: інфляція "атакує" твої заощадження
- Депозити = "стіни" (cyan neon стіни)
- Хвиля: червоні "інфляційні" частинки летять на стіни
- Difficulty: кожна хвиля сильніша
- Захист: streak shields, bonus deposits, power-ups
- Score на основі збережених заощаджень
- Локальний leaderboard
- AI генерує параметри хвиль з реальними даними інфляції (OpenRouter)
- Pixel art style: neon walls, red particles, cyberpunk HUD

---

## НАВІГАЦІЯ — що додати

```dart
GoRoute(path: '/secondhand-analyzer',    builder: (_, __) => const SecondhandAnalyzerScreen()),
GoRoute(path: '/seasonal-calendar',      builder: (_, __) => const SeasonalCalendarScreen()),
GoRoute(path: '/price-momentum',         builder: (_, __) => const PriceMomentumScreen()),
GoRoute(path: '/price-war',              builder: (_, __) => const PriceWarScreen()),
GoRoute(path: '/haggling-coach',         builder: (_, __) => const HagglingCoachScreen()),
GoRoute(path: '/price-elasticity',       builder: (_, __) => const PriceElasticityScreen()),
GoRoute(path: '/inventory-stalker',      builder: (_, __) => const InventoryStalkerScreen()),
GoRoute(path: '/lending-tracker',        builder: (_, __) => const LendingTrackerScreen()),
GoRoute(path: '/goal-price-integrator',  builder: (_, __) => const GoalPriceIntegratorScreen()),
GoRoute(path: '/habit-loop-forge',       builder: (_, __) => const HabitLoopForgeScreen()),
GoRoute(path: '/inflation-shield',       builder: (_, __) => const InflationShieldScreen()),
GoRoute(path: '/price-detective',        builder: (_, __) => const PriceDetectiveScreen()),
GoRoute(path: '/wishlist-url-scanner',   builder: (_, __) => const WishlistUrlScannerScreen()),
GoRoute(path: '/price-shield',           builder: (_, __) => const PriceShieldScreen()),
GoRoute(path: '/savings-time-machine',   builder: (_, __) => const SavingsTimeMachineScreen()),
GoRoute(path: '/quest-chain',            builder: (_, __) => const QuestChainScreen()),
GoRoute(path: '/predictive-coach',       builder: (_, __) => const PredictiveCoachScreen()),
GoRoute(path: '/inflation-game',         builder: (_, __) => const InflationGameScreen()),
```

## БД МІГРАЦІЯ

```dart
// schemaVersion: 24 (ФІНАЛЬНА)
if (from < 24) {
  await m.createTable(secondHandItems);
  await m.createTable(calendarSubscriptions);
  await m.createTable(priceEvents);
  await m.createTable(momentumItems);
  await m.createTable(priceWarEntries);
  await m.createTable(hagglingSessions);
  await m.createTable(elasticityItems);
  await m.createTable(inventoryStalkerItems);
  await m.createTable(lendingRecords);
  await m.createTable(goalProductLinks);
  await m.createTable(habitLoops);
  await m.createTable(inflationShields);
  await m.createTable(priceDetectiveItems);
  await m.createTable(wishlistUrls);
  await m.createTable(priceShieldScans);
  await m.createTable(timeMachineProjections);
  await m.createTable(questChains);
  await m.createTable(coachPredictions);
  await m.createTable(inflationWaves);
}
```

---

## ФІНАЛЬНИЙ FEATURE GRID

Після Phase 4 у Feature Grid повинно бути **47 карток** в GridView.
Розбити на секції або використати continuous scroll.

```dart
// Приклад секційного заголовку в GridView
_sectionHeader('ПОВЕДІНКОВІ СИСТЕМИ'),
_featureCard('NECROSPEND',   '/graveyard'),
_featureCard('RETAINCORE',   '/anti-churn'),
// ... (всі 47)
_sectionHeader('АНАЛІТИКА'),
_featureCard('CHRONOSAVER',  '/savings-time-machine'),
_featureCard('SAGEAI',       '/predictive-coach'),
_sectionHeader('ІГРИ'),
_featureCard('INFLAWALL',    '/inflation-game'),
_featureCard('DROPROULETTE', '/price-roulette'),
```

---

## ACCEPTANCE CRITERIA — ФІНАЛЬНА ПЕРЕВІРКА

- [ ] Всі 18 екранів цієї фази відкриваються
- [ ] InflaWall: гра запускається, частинки анімуються, score рахується
- [ ] QuestChain: ланцюжок відображається, квест завершується, XP нараховується
- [ ] SageAI: прогнози генеруються (AI або mock), confidence відображається
- [ ] ChronoSaver: "what if" слайдери змінюють проєкцію в реальному часі
- [ ] LendingTracker: CRUD для боргів/позик без помилок
- [ ] GoalSync: прив'язка цілі до продукту оновлює target amount
- [ ] schemaVersion = 24, міграція 23→24 без помилок
- [ ] Всі 47 фіч в Feature Grid
- [ ] Flutter build --release без помилок
- [ ] Всі перевірки Phase 0: копійки, withOpacity, без emoji, українська мова

---

## ЗАГАЛЬНИЙ ПІДСУМОК ПРОЄКТУ

| Фаза | Фіч | schemaVersion | Статус |
|------|-----|---------------|--------|
| Phase 0 | Context Master | - | Прочитати перед кожною фазою |
| Phase 1 | 5 фіч (NecroSpend...BankLink) | 20 → 21 | |
| Phase 2 | 10 фіч (RepForge...BudgetHelix) | 21 → 22 | |
| Phase 3 | 14 фіч (VoiceCrypt...PriceProphet) | 22 → 23 | |
| Phase 4 | 18 фіч (ReGear...InflaWall) | 23 → 24 | |
| **TOTAL** | **47 фіч** | **24** | |

---

*Phase 4 (FINAL) | NEONCRED v2.0 | 18 features | schemaVersion: 23 → 24*
*Розроблено: Червень 2026*
