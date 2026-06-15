# NEONCRED — PHASE 3: PRICE INTELLIGENCE ENGINE
## Kiro Design-First Spec | Priority: P2 (Medium)
### Фічі: VoiceCrypt · FundSwarm · ARTag · SynthWave · PriceShark · DropRoulette · MatchBlade · PreGuard · BonusCrunch · FreezeRay · WishScan · AlertCore · PriceColosseum · PriceProphet

---

> **ПЕРЕД СТАРТОМ:** Прочитай `PHASE_0_CONTEXT_MASTER.md`.
> Phase 1 (schemaVersion: 21) та Phase 2 (schemaVersion: 22) повинні бути завершені.
> Ця фаза — ціновий движок: 14 фіч для відстеження, аналізу та гейміфікації цін.

---

## DESIGN CONTEXT

```
After Phase 2: schemaVersion = 22
This phase adds: schemaVersion 23
Price data: SERP API (існуючий SerpApiService в lib/core/services/)
AI: OpenRouterService (існуючий)
Focus: цінові механіки, alerts, прогнози, геймифікація
```

---

## FEATURE 16: VoiceCrypt (Voice Command Deposits)

**Route:** `/voice-vault`

### БД:
```dart
class VoiceCommands extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get transcription => text()();
  TextColumn get parsedAction => text()(); // deposit/check_balance/add_goal
  IntColumn get parsedAmount => integer().nullable()(); // копійки
  IntColumn get targetGoalId => integer().nullable()();
  BoolColumn get wasExecuted => boolean().withDefault(const Constant(false))();
  TextColumn get responseText => text().nullable()();
  DateTimeColumn get recordedAt => dateTime()();
}
```

### UI:
- Велика кнопка мікрофону з pulse анімацією (cyan glow)
- Waveform анімація під час запису
- Транскрипція в реальному часі
- "Розпізнана команда" картка з підтвердженням
- Приклади команд: "Зберегти 500 гривень на PS5", "Скільки я накопичив"
- Голосові логи — список останніх команд
- ASR: ASR_API_KEY з .env або mock

---

## FEATURE 17: FundSwarm (Crowd Fund Wishlist)

**Route:** `/crowd-fund`

### БД:
```dart
class CrowdFundWishlists extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get itemName => text()();
  IntColumn get targetAmount => integer()(); // копійки
  IntColumn get collectedAmount => integer().withDefault(const Constant(0))();
  TextColumn get shareCode => text()(); // унікальний код для ділення
  BoolColumn get isPublic => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
}

class CrowdFundContributions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get wishlistId => integer()();
  TextColumn get contributorName => text()();
  IntColumn get amount => integer()(); // копійки
  TextColumn get message => text().nullable()();
  DateTimeColumn get contributedAt => dateTime()();
}
```

### UI:
- Список вішлістів з прогрес-барами збору
- Share код (QR або посилання)
- Список контрибуцій з іменами та сумами
- Форма "Додати вішліст": назва, цільова сума
- "Поділитись" → генерує share URL/code

---

## FEATURE 18: ARTag (AR Price Scanner)

**Route:** `/ar-price-tag`

### БД:
```dart
class ARScanEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  IntColumn get scannedPrice => integer()(); // копійки
  IntColumn get onlinePrice => integer().nullable()(); // копійки
  TextColumn get storeName => text().nullable()();
  BoolColumn get isFairPrice => boolean().withDefault(const Constant(true))();
  IntColumn get savingsPotential => integer()(); // копійки
  DateTimeColumn get scannedAt => dateTime()();
}
```

### UI:
- Кнопка "Сканувати ціну" → ручне введення (camera AR — для майбутньої версії)
- Порівняння: offline ціна vs online ціна
- "Справедлива ціна?" індикатор (green/red)
- Потенційна економія якщо купити онлайн
- Альтернативні магазини з цінами
- Загальна економія від всіх сканувань (статистика)

---

## FEATURE 19: SynthWave (Deposit Soundscapes)

**Route:** `/soundscapes`

### БД:
```dart
class SoundUnlocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get soundName => text()();
  TextColumn get soundFile => text()(); // asset path
  BoolColumn get isUnlocked => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  IntColumn get unlockCost => integer()(); // XP
  DateTimeColumn get unlockedAt => dateTime().nullable()();
}
```

### UI:
- Список звукових пакетів (Cyberpunk Beat, Neon Rain, Digital Pulse, Retro Chip)
- Locked/Unlocked стани
- Preview кнопка
- "Встановити активним" кнопка
- Звук грає при кожному успішному депозиті
- AudioPlayer (`audioplayers` пакет або `just_audio`)

---

## FEATURE 20: PriceShark (Price History Tracker)

**Route:** `/price-shark`

### БД:
```dart
class PriceSharkItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get productName => text()();
  TextColumn get searchQuery => text()();
  IntColumn get lowestPrice => integer()(); // копійки
  IntColumn get highestPrice => integer()(); // копійки
  IntColumn get currentPrice => integer()(); // копійки
  IntColumn get dropPercentage => integer()(); // % падіння від максимуму
  DateTimeColumn get lastUpdatedAt => dateTime()();
}
```

### UI:
- Список товарів що відстежуються
- Картка: назва, поточна/мін/макс ціна, % падіння
- Spark-line графік тренду (останні 7 точок)
- "Найкраща ціна за весь час" badge
- Діалог додавання нового товару

---

## FEATURE 21: DropRoulette (Price Drop Gambling)

**Route:** `/price-roulette`

### БД:
```dart
class RouletteItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  IntColumn get currentPrice => integer()(); // копійки
  IntColumn get predictedDropPrice => integer()(); // копійки
  IntColumn get betAmount => integer()(); // XP ставка
  TextColumn get outcome => text().nullable()(); // win/lose/pending
  DateTimeColumn get betPlacedAt => dateTime()();
  DateTimeColumn get resolvesAt => dateTime()();
}
```

### UI:
- Рулетка-анімація (spin wheel) в cyberpunk стилі
- Список активних ставок на падіння цін
- "Поставити XP": скільки XP ставиш + прогноз ціни
- Результати: виграш/програш з ефектом
- Leaderboard ставок (локальний)

---

## FEATURE 22: MatchBlade (Price Match Guarantees)

**Route:** `/price-match`

### БД:
```dart
class PriceMatchRequests extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  IntColumn get targetStorePrice => integer()(); // копійки
  IntColumn get competitorPrice => integer()(); // копійки
  TextColumn get targetStore => text()();
  TextColumn get competitorStore => text()();
  TextColumn get status => text()(); // pending/approved/rejected
  TextColumn get evidenceUrl => text().nullable()();
  DateTimeColumn get submittedAt => dateTime()();
}
```

### UI:
- Список price match запитів зі статусами
- Форма: назва товару, ціна в магазині, ціна конкурента, URL доказу
- Потенційна економія якщо match затверджено
- Інструкція як підготувати запит

---

## FEATURE 23: PreGuard (Pre-Order Price Protection)

**Route:** `/preorder-guard`

### БД:
```dart
class PreOrderGuards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  IntColumn get preOrderPrice => integer()(); // копійки
  IntColumn get currentPrice => integer().nullable()(); // копійки
  IntColumn get lowestPriceSeen => integer().nullable()(); // копійки
  DateTimeColumn get releaseDate => dateTime().nullable()();
  BoolColumn get priceDropAlert => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}
```

### UI:
- Список pre-order товарів
- Порівняння: ціна передзамовлення vs поточна ціна на ринку
- "Ціна впала після передзамовлення" попередження (red)
- Таймер до дати релізу
- Рекомендація: чекати чи купити зараз

---

## FEATURE 24: BonusCrunch (Loyalty Card Optimizer)

**Route:** `/loyalty-cruncher`

### БД:
```dart
class LoyaltyCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get storeName => text()();
  TextColumn get cardNumber => text().nullable()(); // зашифрований
  IntColumn get pointsBalance => integer().withDefault(const Constant(0))();
  IntColumn get pointsToMoney => integer()(); // скільки копійок = 1 поінт
  IntColumn get minRedeemPoints => integer()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
}
```

### UI:
- Список карток лояльності
- Баланс поінтів → гривні (конвертація)
- "Найкраща карта для покупки" калькулятор
- Попередження про спливання поінтів
- Вартість поінтів як знижка на цільові товари

---

## FEATURE 25: FreezeRay (Price Freeze Challenge)

**Route:** `/price-freeze`

### БД:
```dart
class FreezeChallenges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get productName => text()();
  IntColumn get frozenPrice => integer()(); // копійки — ціна що "заморожена"
  IntColumn get currentPrice => integer().nullable()(); // копійки
  IntColumn get targetSavingsDays => integer()(); // скільки днів зберігати
  IntColumn get currentSavingsDays => integer().withDefault(const Constant(0))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get xpReward => integer()();
  DateTimeColumn get startedAt => dateTime()();
}
```

### UI:
- "Заморозь ціну" challenge: збирай гроші поки ціна не виросла
- Прогрес-бар днів збереження
- Поточна ціна vs заморожена ціна
- XP нагорода за виконання
- Ice/freeze анімація (cyan кристали)

---

## FEATURE 26: WishScan (Wishlist Price Radar)

**Route:** `/wishlist-radar`

### БД:
```dart
class RadarWishItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get productName => text()();
  TextColumn get searchQuery => text()();
  IntColumn get targetPrice => integer()(); // копійки (trigger threshold)
  IntColumn get currentBestPrice => integer().nullable()(); // копійки
  TextColumn get bestStore => text().nullable()();
  BoolColumn get alertEnabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastCheckedAt => dateTime().nullable()();
}
```

### UI:
- Wishlist товарів з найкращою поточною ціною
- Radar-стиль анімація "пошуку" при оновленні
- Порівняння магазинів для кожного товару
- Alert toggle: сповістити коли ціна досягне target
- "Ціна нижче цільової" badge (green)

---

## FEATURE 27: AlertCore (Smart Price Notifications)

**Route:** `/smart-alerts`

### БД:
```dart
class SmartAlertEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  TextColumn get alertType => text()(); // price_drop/target_reached/flash_sale
  IntColumn get triggerPrice => integer()(); // копійки
  IntColumn get currentPrice => integer()(); // копійки
  BoolColumn get isTriggered => boolean().withDefault(const Constant(false))();
  DateTimeColumn get triggeredAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

class AlertSubscriptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get wishItemId => integer()();
  TextColumn get notificationType => text()(); // push/in_app/both
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
```

### UI:
- Центр сповіщень з активними алертами
- Triggered / Pending / Expired стани
- Налаштування: тип сповіщення, поріг ціни
- Прив'язка до `flutter_local_notifications` (вже в pubspec)
- History спрацьованих алертів

---

## FEATURE 28: PriceColosseum (Price Competition Arena)

**Route:** `/price-arena`

### БД:
```dart
class ArenaTournaments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  DateTimeColumn get startAt => dateTime()();
  DateTimeColumn get endAt => dateTime()();
  TextColumn get status => text()(); // active/completed
  IntColumn get prizeXp => integer()();
}

class ArenaSubmissions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tournamentId => integer()();
  IntColumn get userId => integer()();
  TextColumn get storeName => text()();
  IntColumn get price => integer()(); // копійки
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();
  DateTimeColumn get submittedAt => dateTime()();
}
```

### UI:
- Список активних "турнірів" по товарах
- Лідерборд: хто знайшов найнижчу ціну
- "Відправити ціну" форма: магазин + ціна + скрін
- XP нагорода за перемогу
- Cyberpunk arena стилізація (gladiator arena в neon)

---

## FEATURE 29: PriceProphet (AI Price Forecasting)

**Route:** `/price-prophet`

### БД:
```dart
class PriceForecasts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  IntColumn get currentPrice => integer()(); // копійки
  IntColumn get forecastPrice7d => integer()(); // копійки
  IntColumn get forecastPrice30d => integer()(); // копійки
  IntColumn get forecastPrice90d => integer()(); // копійки
  RealColumn get confidence => real()(); // 0.0 - 1.0
  TextColumn get reasoning => text().nullable()(); // AI пояснення
  TextColumn get recommendation => text()(); // buy_now/wait/urgent
  DateTimeColumn get generatedAt => dateTime()();
}
```

### UI:
- Пошук товару → AI прогноз на 7/30/90 днів
- Confidence level bar
- Графік прогнозованої ціни (fl_chart)
- Recommendation: "Купуй зараз" / "Чекай" / "Терміново!"
- AI пояснення чому (OpenRouter: ринкові тренди, сезонність)
- Prophet-style cyberpunk: кристальна куля в neon

---

## НАВІГАЦІЯ — що додати

```dart
GoRoute(path: '/voice-vault',       builder: (_, __) => const VoiceVaultScreen()),
GoRoute(path: '/crowd-fund',        builder: (_, __) => const CrowdFundScreen()),
GoRoute(path: '/ar-price-tag',      builder: (_, __) => const ARPriceTagScreen()),
GoRoute(path: '/soundscapes',       builder: (_, __) => const SoundscapesScreen()),
GoRoute(path: '/price-shark',       builder: (_, __) => const PriceSharkScreen()),
GoRoute(path: '/price-roulette',    builder: (_, __) => const PriceRouletteScreen()),
GoRoute(path: '/price-match',       builder: (_, __) => const PriceMatchScreen()),
GoRoute(path: '/preorder-guard',    builder: (_, __) => const PreOrderGuardScreen()),
GoRoute(path: '/loyalty-cruncher',  builder: (_, __) => const LoyaltyCruncherScreen()),
GoRoute(path: '/price-freeze',      builder: (_, __) => const PriceFreezeScreen()),
GoRoute(path: '/wishlist-radar',    builder: (_, __) => const WishlistRadarScreen()),
GoRoute(path: '/smart-alerts',      builder: (_, __) => const SmartAlertsScreen()),
GoRoute(path: '/price-arena',       builder: (_, __) => const PriceArenaScreen()),
GoRoute(path: '/price-prophet',     builder: (_, __) => const PriceProphetScreen()),
```

## БД МІГРАЦІЯ

```dart
// schemaVersion: 23
if (from < 23) {
  await m.createTable(voiceCommands);
  await m.createTable(crowdFundWishlists);
  await m.createTable(crowdFundContributions);
  await m.createTable(arScanEntries);
  await m.createTable(soundUnlocks);
  await m.createTable(priceSharkItems);
  await m.createTable(rouletteItems);
  await m.createTable(priceMatchRequests);
  await m.createTable(preOrderGuards);
  await m.createTable(loyaltyCards);
  await m.createTable(freezeChallenges);
  await m.createTable(radarWishItems);
  await m.createTable(smartAlertEntries);
  await m.createTable(alertSubscriptions);
  await m.createTable(arenaTournaments);
  await m.createTable(arenaSubmissions);
  await m.createTable(priceForecasts);
}
```

---

## ACCEPTANCE CRITERIA

- [ ] Всі 14 екранів відкриваються
- [ ] VoiceCrypt анімує waveform і зберігає команди
- [ ] PriceProphet генерує AI прогноз через OpenRouter
- [ ] SmartAlerts інтегровані з flutter_local_notifications
- [ ] DropRoulette spin анімація без frame drops
- [ ] schemaVersion = 23, міграція 22→23 без помилок
- [ ] Всі 14 карток у Feature Grid
- [ ] Усі перевірки Phase 0 виконані

---

*Phase 3 | NEONCRED v2.0 | 14 features | schemaVersion: 22 → 23*
