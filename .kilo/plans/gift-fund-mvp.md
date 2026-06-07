# Gift Fund MVP — Implementation Plan

## 1. Strategic Rationale

### Why Gift Fund for 2026–2030 LTV
- **Emotional anchoring**: Financial goals tied to specific people create psychological lock-in far stronger than abstract "save for a car" targets.
- **Zero external dependencies**: Unlike Eco-Cashback (CarbonFootprint API), Promo Code Aggregator (Promocod.ua), or Dream Crowdfunding (WayForPay), Gift Fund is **100% local logic + optional Firebase for sharing**.
- **Network effect potential**: Each "gift goal" creates a natural invitation loop ("Mom, save for my birthday gift") with zero marketing cost.
- **Low technical risk**: No OCR, no STT, no third-party APIs, no payment integrations.

### Comparison Snapshot

| Feature | External APIs | Auth Complexity | Data Sensitivity | LTV Signal | MVP Safety |
|---|---|---|---|---|---|
| **Gift Fund** | None (optional Firebase) | Low (Firebase Anonymous) | Low | High | ✅✅✅ |
| Receipt Scanner | Google ML Kit / ML Kit | Medium | High (receipt PII) | Medium | ⚠️ |
| Voice Diary | Whisper / local STT | Low | Medium | Medium | ⚠️ |
| Promo Aggregator | Promocod.ua | Medium | Low | Low | ⚠️ |
| Eco-Cashback | CarbonFootprint API | High | Low | Low | ❌ |
| Mentorship | Firebase Firestore | High | High | Medium | ⚠️ |
| Currency Arb | NBU API | Low | Low | Medium | ✅ |
| Sub Manager | None | Low | Medium | Low | ✅ |
| Health Integ | HealthKit / Google Fit | High | Very High | Medium | ❌ |
| Crowdfunding | WayForPay | Very High | High | Low | ❌ |

## 2. Technical Architecture

### 2.1 Data Model (Drift Migration)

**New table: `GiftGoals`**

```dart
class GiftGoals extends Table {
  TextColumn get id => text()();
  TextColumn get goalId => text()();          // FK to Goals.id
  TextColumn get recipientName => text()();
  TextColumn get recipientRelationship => text()(); // 'mother', 'friend', 'child', etc.
  TextColumn get occasionType => text()();    // 'birthday', 'new_year', 'wedding', 'other'
  DateTimeColumn get occasionDate => dateTime()();
  TextColumn get emoji => text().withDefault(const Constant('🎁'))();
  TextColumn get personalizedMessage => text().nullable()();
  BoolColumn get isSurpriseMode => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (goal_id) REFERENCES goals(id) ON DELETE CASCADE',
  ];
}
```

**Drift migration path:**
- Migration v20: additive `CREATE TABLE` for `gift_goals`
- No data backfill needed (new feature)
- `schemaVersion => 20`

### Provider structure

```dart
// State
final giftFundProvider = AsyncNotifierProvider<GiftFundNotifier, List<GiftGoal>>(
  GiftFundNotifier.new,
);

// Detail stream per goal
final giftGoalProvider = StreamProvider.family<GiftGoal?, String>((ref, goalId) {
  final db = ref.watch(databaseProvider);
  return db.watchGiftGoalByGoalId(goalId);
});
```

### UI

```
screens/
  gift_fund_screen.dart
  gift_goal_setup_screen.dart
  gift_share_preview_screen.dart
widgets/
  gift_goal_card.dart
  occasion_badge.dart
  countdown_timer.dart
```

### Sharing MVP

- Share token: base64 encoded JSON with only public fields
- Read-only shared view: `/gift-preview/{goalId}?token=...`
