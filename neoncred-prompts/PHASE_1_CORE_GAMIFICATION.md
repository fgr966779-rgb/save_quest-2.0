# NEONCRED — PHASE 1: CORE GAMIFICATION FOUNDATION
## Kiro Design-First Spec | Priority: P0 (Critical)
### Фічі: NecroSpend · RetainCore · FutureMirror · LootBox · BankLink

---

> **ПЕРЕД СТАРТОМ:** Прочитай `PHASE_0_CONTEXT_MASTER.md` повністю.
> Ці 5 фіч — фундамент геймифікації. Будь-яка помилка тут відіб'ється на всьому.

---

## DESIGN CONTEXT (існуючий проєкт)

```
Existing routes: splash, onboarding, dashboard, analytics, history,
                 streak, trophies, deposit, penalty-vault, class-selection,
                 lootboxes, customization, avatar-builder, market, pets,
                 squads, joint-goals, leaderboards, skill-tree + більше
Existing DB tables: Goals, Deposits, DepositAllocations, UserProfiles,
                    UnlockedAchievements, Pets, Squads, SideQuests,
                    TransactionTags, VoiceLogs, PenaltyHabits, JointGoals,
                    InvestmentPortfolio, MarketPrices, PriceHistoryEntries,
                    MemoryVaultEntries, LendingContracts, ChatMessages,
                    Subscriptions, GiftGoals + більше (schemaVersion: 20)
DB money rule: всі суми в копійках (int minor units)
```

---

## FEATURE 1: NecroSpend (Savings Graveyard)

**Route:** `/graveyard`
**Nav:** Додати в Feature Grid на Home екрані

### Що додати в БД (schemaVersion: 21):
```dart
// Нова таблиця GraveyardEntries
class GraveyardEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId => integer()();
  TextColumn get goalName => text()();
  IntColumn get targetAmount => integer()(); // копійки
  IntColumn get savedAmount => integer()();  // копійки
  TextColumn get epitaph => text().nullable()(); // AI-генерований
  DateTimeColumn get deathDate => dateTime()();
  BoolColumn get isResurrected => boolean().withDefault(const Constant(false))();
  DateTimeColumn get resurrectionDate => dateTime().nullable()();
  TextColumn get deathReason => text().nullable()();
  BoolColumn get necromancerUsed => boolean().withDefault(const Constant(false))();
}
```

### Що зробити в UI:
- Екран з темним "мавзолей"-стилем (background `Color(0xFF0A0E17)`)
- Кожна мета-надгробок: назва, цільова сума, зібрана сума, дата "смерті", епітафія
- Кнопка "Воскресити" → мінімальний депозит → мета повертається в Goals
- Некромант-механіка: витратити XP (з `UserProfiles.xp`) щоб воскресити без депозиту
- Статистика: всього "померло", воскрешено, % успішності воскрешення
- AI-епітафія: запит до `OpenRouterService` при "смерті" цілі

### Логіка:
- Ціль "вмирає" якщо: `targetDate` минув і прогрес < 100%, або користувач вручну видаляє
- При воскрешенні: запис в `GraveyardEntries.isResurrected = true` + відновити Goal

---

## FEATURE 2: RetainCore (Anti-Churn Oracle)

**Route:** `/anti-churn`

### Що додати в БД:
> Не потрібна окрема таблиця — обчислення в реальному часі з `UserProfiles` + `Deposits`

### Що зробити в UI:
- Dashboard з рівнем ризику: Low / Medium / High / Critical (кольори: green/orange/red/пульсуючий red)
- Сигнали відтоку: days since last deposit, streak broken, amounts decreasing
- AI "Rescue Missions" — персоналізовані виклики для реактивації (OpenRouter)
- Кнопка "Екстрений депозит" з мінімальним порогом (50 грн)
- Мотиваційні повідомлення від AI

### Логіка:
```dart
// Рівень ризику (обчислити в RetainCoreService)
Critical: daysSinceDeposit > 7 || currentStreak == 0 && previousStreak > 14
High:     daysSinceDeposit > 3 || amountTrend < -30%
Medium:   daysSinceDeposit > 1 || streakBroken
Low:      все в нормі
```

---

## FEATURE 3: FutureMirror (Future Self Visualizer)

**Route:** `/future-self`

### Що додати в БД (в тій же міграції):
```dart
// Нова таблиця FutureSelfProjections (schemaVersion: 21)
class FutureSelfProjections extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId => integer()();
  DateTimeColumn get projectedDate => dateTime()();
  IntColumn get projectedAmount => integer()(); // копійки
  RealColumn get confidence => real()();
  TextColumn get aiMessage => text().nullable()();
  DateTimeColumn get calculatedAt => dateTime()();
}
```

### Що зробити в UI:
- Split-screen: ліворуч — поточний стан, праворуч — проєкція майбутнього
- "If you continue at this pace" — дата досягнення цілі
- Слайдер "Fast-forward": 3 міс / 6 міс / 1 рік / 2 роки
- AI-мотиваційне повідомлення про майбутнє (OpenRouter)
- Візуальна трансформація аватару (прогрес → глоу-ефект посилюється)

---

## FEATURE 4: LootBox (Variable Reward Vault)

**Route:** `/variable-reward`
> ⚠️ В проєкті вже є маршрут `/lootboxes` — перевір чи є екран. Якщо є — розшир його. Якщо ні — створи новий під маршрутом `/variable-reward`.

### Що додати в БД:
```dart
// Нова таблиця LootBoxResults (schemaVersion: 21)
class LootBoxResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tier => text()(); // common/rare/epic/legendary/mythic
  IntColumn get xpReward => integer()();
  TextColumn get rewardType => text()(); // xp_multiplier/streak_freeze/cosmetic
  TextColumn get rewardData => text().nullable()(); // JSON деталі
  DateTimeColumn get openedAt => dateTime()();
}
```

### Що зробити в UI:
- Анімована скриня з відкриттям після кожного депозиту (5% шанс)
- Tier кольори: Common=grey, Rare=cyan, Epic=purple, Legendary=gold, Mythic=red
- Spin анімація з neon частинками
- Статистика: всього відкрито, найкращий лут, jackpot streak
- Вірогідності: Common 5%, Rare 2%, Epic 0.5%, Legendary 0.1%
- Нагороди: XP мультиплікатори, streak freeze токени, косметичні айтеми

---

## FEATURE 5: BankLink (Bank Sync Oracle)

**Route:** `/bank-sync`

### Що додати в БД:
```dart
// Нова таблиця BankSyncConfigs (schemaVersion: 21)
class BankSyncConfigs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get provider => text()(); // privatbank/plaid/mock
  TextColumn get status => text()(); // connected/disconnected/error
  TextColumn get maskedAccount => text().nullable()();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  BoolColumn get roundUpEnabled => boolean().withDefault(const Constant(false))();
  IntColumn get roundUpGoalId => integer().nullable()();
}

// Нова таблиця AutoDeposits (schemaVersion: 21)
class AutoDeposits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId => integer()();
  TextColumn get ruleType => text()(); // round_up/income_percent/fixed_weekly
  IntColumn get amount => integer()(); // копійки
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get nextTriggerAt => dateTime().nullable()();
}
```

### Що зробити в UI:
- Вибір провайдера: PrivatBank, Plaid, Mock (для демо)
- Статус підключення з анімованою іконкою синхронізації
- Список транзакцій з AI-категоризацією
- Round-up калькулятор: "здача" з покупок → автодепозит
- Правила авто-збережень: round-up / % від доходу / фіксований щотижня
- Кнопка "Синхронізувати зараз"
- **Mock провайдер** для демо (реальний API готовий до підключення)

---

## НАВІГАЦІЯ — що додати до router

```dart
// Додати в існуючий GoRouter в app_router.dart:
GoRoute(path: '/graveyard',     builder: (_, __) => const SavingsGraveyardScreen()),
GoRoute(path: '/anti-churn',    builder: (_, __) => const AntiChurnScreen()),
GoRoute(path: '/future-self',   builder: (_, __) => const FutureSelfScreen()),
GoRoute(path: '/variable-reward', builder: (_, __) => const VariableRewardScreen()),
GoRoute(path: '/bank-sync',     builder: (_, __) => const BankSyncScreen()),
```

## БД МІГРАЦІЯ

```dart
// В database.dart — збільшити schemaVersion до 21
// В migrationStrategy.onUpgrade:
if (from < 21) {
  await m.createTable(graveyardEntries);
  await m.createTable(futureSelfProjections);
  await m.createTable(lootBoxResults);
  await m.createTable(bankSyncConfigs);
  await m.createTable(autoDeposits);
}
```

## FEATURE GRID — що додати на Home

Додати 5 карток в GridView на Dashboard:
```dart
FeatureCard(name: 'NECROSPEND',    route: '/graveyard',        color: AppColors.red),
FeatureCard(name: 'RETAINCORE',    route: '/anti-churn',       color: AppColors.orange),
FeatureCard(name: 'FUTUREMIRROR',  route: '/future-self',      color: AppColors.cyan),
FeatureCard(name: 'LOOTBOX',       route: '/variable-reward',  color: AppColors.purple),
FeatureCard(name: 'BANKLINK',      route: '/bank-sync',        color: AppColors.green),
```

---

## ACCEPTANCE CRITERIA

- [ ] `/graveyard` відкривається, показує список "мертвих" цілей
- [ ] Кнопка "Воскресити" оновлює БД і повертає ціль
- [ ] `/anti-churn` показує правильний рівень ризику на основі реальних даних
- [ ] `/future-self` обчислює проєкцію з реальних депозитів
- [ ] Loot box відкривається після депозиту з правильною вірогідністю тирів
- [ ] `/bank-sync` показує mock-транзакції і round-up калькулятор
- [ ] Всі 5 маршрутів доступні з Feature Grid
- [ ] schemaVersion = 21, міграція без помилок
- [ ] Жодного emoji в UI, весь текст українською
- [ ] withOpacity() скрізь (не withValues)

---

*Phase 1 | NEONCRED v2.0 | 5 features | schemaVersion: 20 → 21*
