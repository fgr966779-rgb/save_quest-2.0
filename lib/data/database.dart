import 'package:drift/drift.dart';
import 'connection/connection.dart';

part 'database.g.dart';

typedef Lootbox = Lootboxe;

/// All monetary columns store values in MINOR UNITS (kopecks / cents).
/// 1 UAH = 100 kopecks. Use money_utils.dart for conversion.
class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  /// Target amount in minor units (kopecks).
  IntColumn get targetAmount => integer()();
  /// Current accumulated amount in minor units (kopecks).
  IntColumn get currentAmount => integer()();
  TextColumn get currency => text()();
  TextColumn get accentColor => text()();
  DateTimeColumn get createdAt => dateTime()();
  /// Sync-readiness: updated on every write for Last-Write-Wins conflict resolution.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // --- Price Hunter (v12) ---
  TextColumn get productUrl => text().nullable()();
  IntColumn get targetPrice => integer().nullable()();
  IntColumn get currentPrice => integer().nullable()();
  IntColumn get priceShieldHp => integer().withDefault(const Constant(100))();
  DateTimeColumn get lastPriceUpdate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Deposits extends Table {
  TextColumn get id => text()();
  /// Total deposit amount in minor units (kopecks).
  IntColumn get amount => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  /// Sync-readiness: updated on every write for Last-Write-Wins conflict resolution.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Relational N-Goal allocation: maps a single deposit to one or more goals.
/// Replaces the legacy goalAAmount / goalBAmount static columns on Deposits.
/// Enables unlimited dynamic goal targeting in Phase 2.
class DepositAllocations extends Table {
  TextColumn get id => text()();
  TextColumn get depositId => text().references(Deposits, #id)();
  TextColumn get goalId => text().references(Goals, #id)();
  /// Allocated portion in minor units (kopecks).
  IntColumn get amount => integer()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class UserProfiles extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  IntColumn get level => integer().withDefault(const Constant(1))();
  IntColumn get streakCount => integer().withDefault(const Constant(0))();
  IntColumn get maxStreak => integer().withDefault(const Constant(0))();
  IntColumn get freezeTokens => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastDepositDate => dateTime().nullable()();
  IntColumn get skillPoints => integer().withDefault(const Constant(0))();
  TextColumn get playerClass => text().nullable()();
  TextColumn get currentTheme =>
      text().withDefault(const Constant('default'))();
  TextColumn get avatarConfig => text().nullable()();
  IntColumn get penaltyBalance => integer().withDefault(const Constant(0))();
  IntColumn get hackerXp => integer().withDefault(const Constant(0))();
  IntColumn get magnateXp => integer().withDefault(const Constant(0))();
  IntColumn get resilienceXp => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastBonusClaimDate => dateTime().nullable()();
  IntColumn get bonusStreak => integer().withDefault(const Constant(0))();
  IntColumn get crystalsBalance => integer().withDefault(const Constant(0))();
  IntColumn get noSpendStreakCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastNoSpendDate => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // --- Karma Debt (v11) ---
  IntColumn get karmaDebt => integer().withDefault(const Constant(0))();
  DateTimeColumn get debuffActiveUntil => dateTime().nullable()();

  // --- Cyber-Partner (v13) ---
  TextColumn get partnerName => text().nullable()();
  DateTimeColumn get partnerLastDepositDate => dateTime().nullable()();
  DateTimeColumn get lastDiversificationXPDate => dateTime().nullable()();
  DateTimeColumn get lastRebalanceXPDate => dateTime().nullable()();

  // --- Price Pulse (v18) ---
  /// Last date XP was awarded for weekly price tracking (+15 XP / 7 days).
  DateTimeColumn get lastPricePulseXPDate => dateTime().nullable()();
  /// Total number of successful price checks (for "Снайпер Цін" badge at 5).
  IntColumn get pricePulseTrackingCount => integer().withDefault(const Constant(0))();

  // --- Karma Healing (v15) ---
  IntColumn get karmaHealingStreakCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastKarmaHealDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class UnlockedAchievements extends Table {
  TextColumn get id => text()();
  DateTimeColumn get unlockedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class UnlockedSkills extends Table {
  TextColumn get id => text()();
  DateTimeColumn get unlockedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Lootboxes extends Table {
  TextColumn get id => text()();
  TextColumn get rarity => text()();
  BoolColumn get isOpened => boolean().withDefault(const Constant(false))();
  DateTimeColumn get earnedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Pets extends Table {
  TextColumn get id => text()();
  TextColumn get petType => text()();
  IntColumn get happinessLevel =>
      integer().withDefault(const Constant(100))();
  DateTimeColumn get lastFedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Squads extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get totalXp => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class SideQuests extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  BoolColumn get isCompleted =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get expiresAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class TransactionTags extends Table {
  TextColumn get id => text()();
  TextColumn get depositId => text()();
  TextColumn get tag => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class VoiceLogs extends Table {
  TextColumn get id => text()();
  TextColumn get depositId => text()();
  TextColumn get filePath => text()();
  DateTimeColumn get recordedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class PenaltyHabits extends Table {
  TextColumn get id => text()();
  TextColumn get habitName => text()();
  IntColumn get penaltyAmount => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class JointGoals extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get targetAmount => integer()(); // minor units
  IntColumn get currentAmount =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get deadline => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class JointGoalMembers extends Table {
  TextColumn get id => text()();
  TextColumn get goalId => text()();
  TextColumn get memberName => text()();
  IntColumn get contributedAmount =>
      integer().withDefault(const Constant(0))();
  IntColumn get avatarIndex => integer().withDefault(const Constant(0))();
  BoolColumn get isCurrentUser =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class AvoidedPurchases extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get amount => integer()(); // minor units
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class InvestmentPortfolio extends Table {
  TextColumn get assetId => text()();
  TextColumn get assetName => text()();
  IntColumn get amountOwned => integer()();
  RealColumn get averageBuyPrice => real()();
  
  @override
  Set<Column> get primaryKey => {assetId};
}

class MarketPrices extends Table {
  TextColumn get symbol => text()();
  RealColumn get price => real()();
  TextColumn get currency => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {symbol};
}

/// Time-series price snapshots for user goals.
/// Each row is one manual or automatic price check.
/// Used by the Trend Engine (linear regression on 3-5 last points).
/// Never fetched more than once per 24 h per goal (API limit guard).
class PriceHistoryEntries extends Table {
  /// Auto-increment surrogate key.
  IntColumn get id => integer().autoIncrement()();

  /// FK: references Goals.id. Not a Drift reference to avoid cascade issues
  /// when goals are soft-deleted.
  TextColumn get goalId => text()();

  /// Price in kopecks (minor units, same convention as the rest of the app).
  IntColumn get priceKopecks => integer()();

  /// Store / source label (e.g. "Rozetka", "SerpAPI avg", "Manual").
  TextColumn get store => text().withDefault(const Constant('SerpAPI'))();

  /// Data source: 'api' | 'manual' | 'cache'.
  TextColumn get dataSource => text().withDefault(const Constant('api'))();

  /// When this snapshot was recorded. Used for TTL checks and trend plotting.
  DateTimeColumn get cachedAt => dateTime()();
}

class MemoryVaultEntries extends Table {
  TextColumn get id => text()();
  TextColumn get goalId => text()();
  IntColumn get unlockThresholdPercent => integer()();
  TextColumn get content => text().nullable()();
  BoolColumn get isUnlocked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class LendingContracts extends Table {
  TextColumn get id => text()();
  TextColumn get debtorName => text()();
  IntColumn get amount => integer()(); // minor units
  DateTimeColumn get returnDate => dateTime()();
  BoolColumn get isReturned => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class ChatMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get role => text()(); // 'user' or 'assistant'
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// User's recurring subscriptions/parasites
class GiftGoals extends Table {
  TextColumn get id => text()();
  TextColumn get goalId => text()();
  TextColumn get recipientName => text()();
  TextColumn get recipientRelationship => text()();
  TextColumn get occasionType => text()();
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

class Subscriptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get amountKopecks => integer()();
  TextColumn get currency => text().withDefault(const Constant('UAH'))();
  TextColumn get billingCycle => text().withDefault(const Constant('monthly'))(); // 'monthly' or 'yearly'
  DateTimeColumn get nextBillingDate => dateTime()();
  IntColumn get reminderDaysBefore => integer().withDefault(const Constant(3))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastCheckedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class GraveyardEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get goalId => text()();
  TextColumn get goalName => text()();
  IntColumn get targetAmount => integer()();
  IntColumn get savedAmount => integer()();
  TextColumn get epitaph => text().nullable()();
  DateTimeColumn get deathDate => dateTime()();
  BoolColumn get isResurrected => boolean().withDefault(const Constant(false))();
  DateTimeColumn get resurrectionDate => dateTime().nullable()();
  TextColumn get deathReason => text().nullable()();
  BoolColumn get necromancerUsed => boolean().withDefault(const Constant(false))();
}

class FutureSelfProjections extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get goalId => text()();
  DateTimeColumn get projectedDate => dateTime()();
  IntColumn get projectedAmount => integer()();
  RealColumn get confidence => real()();
  TextColumn get aiMessage => text().nullable()();
  DateTimeColumn get calculatedAt => dateTime()();
}

class LootBoxResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tier => text()();
  IntColumn get xpReward => integer()();
  TextColumn get rewardType => text()();
  TextColumn get rewardData => text().nullable()();
  DateTimeColumn get openedAt => dateTime()();
}

class BankSyncConfigs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get provider => text()();
  TextColumn get status => text()();
  TextColumn get maskedAccount => text().nullable()();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  BoolColumn get roundUpEnabled => boolean().withDefault(const Constant(false))();
  TextColumn get roundUpGoalId => text().nullable()();
}

class AutoDeposits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get goalId => text()();
  TextColumn get ruleType => text()();
  IntColumn get amount => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get nextTriggerAt => dateTime().nullable()();
}

// ── Phase 2 tables ──────────────────────────────────────────────

class ReputationProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  IntColumn get score => integer().withDefault(const Constant(0))();
  TextColumn get tier => text().withDefault(const Constant('Novice'))();
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

class FlashMobEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  RealColumn get multiplier => real()();
  IntColumn get participantCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get startAt => dateTime()();
  DateTimeColumn get endAt => dateTime()();
  BoolColumn get isJoined => boolean().withDefault(const Constant(false))();
  IntColumn get xpBonus => integer()();
}

class SavingsContracts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get contractType => text()();
  IntColumn get targetAmount => integer()();
  IntColumn get xpStake => integer()();
  IntColumn get karmaStake => integer()();
  IntColumn get currentProgress => integer()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get isFulfilled => boolean().withDefault(const Constant(false))();
  BoolColumn get isBroken => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}

class NudgeExperiments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nudgeType => text()();
  TextColumn get variant => text()();
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

class TrophyEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get name => text()();
  TextColumn get tier => text()();
  IntColumn get milestoneAmount => integer()();
  BoolColumn get isUnlocked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get unlockedAt => dateTime().nullable()();
  TextColumn get sketchfabModelId => text().nullable()();
  TextColumn get aiDescription => text().nullable()();
}

class NewsInsights extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get summary => text()();
  TextColumn get category => text()();
  IntColumn get relevanceScore => integer()();
  BoolColumn get isActionable => boolean().withDefault(const Constant(false))();
  TextColumn get aiSuggestion => text().nullable()();
  IntColumn get relatedGoalId => integer().nullable()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get publishedAt => dateTime()();
}

class PriceWatchItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get name => text()();
  TextColumn get searchQuery => text()();
  IntColumn get currentPrice => integer()();
  IntColumn get previousPrice => integer()();
  IntColumn get targetPrice => integer()();
  TextColumn get storeName => text().nullable()();
  TextColumn get alertType => text()();
  TextColumn get aiPrediction => text().nullable()();
  DateTimeColumn get lastCheckedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

class ScannedReceipts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get merchant => text()();
  IntColumn get amount => integer()();
  TextColumn get category => text()();
  IntColumn get savingsPotential => integer()();
  TextColumn get aiMotivation => text().nullable()();
  BoolColumn get isImpulseBuy => boolean().withDefault(const Constant(false))();
  TextColumn get imagePath => text().nullable()();
  DateTimeColumn get scannedAt => dateTime()();
}

class CyberPets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get petType => text()();
  TextColumn get name => text()();
  IntColumn get health => integer().withDefault(const Constant(100))();
  IntColumn get happiness => integer().withDefault(const Constant(100))();
  TextColumn get evolutionStage => text().withDefault(const Constant('Egg'))();
  IntColumn get totalFeedings => integer().withDefault(const Constant(0))();
  IntColumn get daysTogether => integer().withDefault(const Constant(0))();
  TextColumn get accessories => text().withDefault(const Constant('[]'))();
  DateTimeColumn get adoptedAt => dateTime()();
}

class BudgetEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get category => text()();
  IntColumn get monthlyLimit => integer()();
  IntColumn get spentAmount => integer()();
  TextColumn get month => text()();
  BoolColumn get isBreach => boolean().withDefault(const Constant(false))();
}

class BudgetReports extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get month => text()();
  IntColumn get totalSpent => integer()();
  IntColumn get totalLimit => integer()();
  RealColumn get savingsRate => real()();
  TextColumn get aiAnalysis => text().nullable()();
  IntColumn get usdUahRate => integer()();
  IntColumn get eurUahRate => integer()();
  RealColumn get inflationRate => real()();
}

// ==========================================
// PHASE 3 (PRICE INTELLIGENCE) TABLES
// ==========================================

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

// ==========================================
// PHASE 4 (ADVANCED ANALYTICS & BEHAVIORAL) TABLES
// ==========================================

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

class ElasticityItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productName => text()();
  IntColumn get basePrice => integer()(); // копійки
  RealColumn get elasticityScore => real()(); // -3.0 до 0
  TextColumn get category => text()(); // elastic/inelastic/unit_elastic
  TextColumn get insight => text().nullable()(); // AI пояснення
  DateTimeColumn get calculatedAt => dateTime()();
}

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

class QuestChains extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get questType => text()();
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

class CoachPredictions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get predictionType => text()();
  RealColumn get confidence => real()(); // 0.0 - 1.0
  TextColumn get predictionText => text()();
  TextColumn get actionSuggestion => text()();
  BoolColumn get wasCorrect => boolean().nullable()();
  DateTimeColumn get predictedFor => dateTime()();
  DateTimeColumn get generatedAt => dateTime()();
}

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

@DriftDatabase(tables: [
  Goals,
  Deposits,
  DepositAllocations,
  UserProfiles,
  UnlockedAchievements,
  UnlockedSkills,
  Lootboxes,
  Pets,
  Squads,
  SideQuests,
  TransactionTags,
  VoiceLogs,
  PenaltyHabits,
  JointGoals,
  JointGoalMembers,
  AvoidedPurchases,
  MemoryVaultEntries,
  LendingContracts,
  ChatMessages,
  InvestmentPortfolio,
  MarketPrices,
  PriceHistoryEntries,
  Subscriptions,
  GiftGoals,
  GraveyardEntries,
  FutureSelfProjections,
  LootBoxResults,
  BankSyncConfigs,
  AutoDeposits,
  ReputationProfiles,
  PublicCommitments,
  FlashMobEvents,
  SavingsContracts,
  NudgeExperiments,
  PersuasionProfiles,
  TrophyEntries,
  NewsInsights,
  PriceWatchItems,
  ScannedReceipts,
  CyberPets,
  BudgetEntries,
  BudgetReports,
  VoiceCommands,
  CrowdFundWishlists,
  CrowdFundContributions,
  ARScanEntries,
  SoundUnlocks,
  PriceSharkItems,
  RouletteItems,
  PriceMatchRequests,
  PreOrderGuards,
  LoyaltyCards,
  FreezeChallenges,
  RadarWishItems,
  SmartAlertEntries,
  AlertSubscriptions,
  ArenaTournaments,
  ArenaSubmissions,
  PriceForecasts,
  SecondHandItems,
  CalendarSubscriptions,
  PriceEvents,
  MomentumItems,
  PriceWarEntries,
  HagglingSessions,
  ElasticityItems,
  InventoryStalkerItems,
  LendingRecords,
  GoalProductLinks,
  HabitLoops,
  InflationShields,
  PriceDetectiveItems,
  WishlistUrls,
  PriceShieldScans,
  TimeMachineProjections,
  QuestChains,
  CoachPredictions,
  InflationWaves,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  AppDatabase.connect(super.connection);

  @override
  int get schemaVersion => 24;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Migrate goals: real → integer (kopecks)
            await customStatement('''
              CREATE TABLE goals_new (
                id TEXT NOT NULL PRIMARY KEY,
                name TEXT NOT NULL,
                target_amount INTEGER NOT NULL,
                current_amount INTEGER NOT NULL,
                currency TEXT NOT NULL,
                accent_color TEXT NOT NULL,
                created_at INTEGER NOT NULL
              )
            ''');
            await customStatement('''
              INSERT INTO goals_new
                SELECT id, name,
                  CAST(ROUND(target_amount * 100) AS INTEGER),
                  CAST(ROUND(current_amount * 100) AS INTEGER),
                  currency, accent_color, created_at
                FROM goals
            ''');
            await customStatement('DROP TABLE goals');
            await customStatement('ALTER TABLE goals_new RENAME TO goals');

            // Migrate deposits: real → integer (kopecks)
            await customStatement('''
              CREATE TABLE deposits_new (
                id TEXT NOT NULL PRIMARY KEY,
                amount INTEGER NOT NULL,
                goal_a_amount INTEGER NOT NULL,
                goal_b_amount INTEGER NOT NULL,
                note TEXT,
                created_at INTEGER NOT NULL,
                is_deleted INTEGER NOT NULL DEFAULT 0
                  CHECK (is_deleted IN (0, 1))
              )
            ''');
            await customStatement('''
              INSERT INTO deposits_new
                SELECT id,
                  CAST(ROUND(amount * 100) AS INTEGER),
                  CAST(ROUND(goal_a_amount * 100) AS INTEGER),
                  CAST(ROUND(goal_b_amount * 100) AS INTEGER),
                  note, created_at, is_deleted
                FROM deposits
            ''');
            await customStatement('DROP TABLE deposits');
            await customStatement(
                'ALTER TABLE deposits_new RENAME TO deposits');
          }
          if (from < 3) {
            await m.addColumn(userProfiles, userProfiles.skillPoints);
            await m.addColumn(userProfiles, userProfiles.playerClass);
            await m.addColumn(userProfiles, userProfiles.currentTheme);
            await m.addColumn(userProfiles, userProfiles.avatarConfig);
            await m.addColumn(userProfiles, userProfiles.penaltyBalance);
            await m.createTable(lootboxes);
            await m.createTable(pets);
            await m.createTable(squads);
            await m.createTable(sideQuests);
            await m.createTable(transactionTags);
            await m.createTable(voiceLogs);
            await m.createTable(penaltyHabits);
          }
          if (from < 4) {
            await m.createTable(unlockedSkills);
          }
          if (from < 5) {
            await m.addColumn(userProfiles, userProfiles.hackerXp);
            await m.addColumn(userProfiles, userProfiles.magnateXp);
            await m.addColumn(userProfiles, userProfiles.resilienceXp);
          }
          if (from < 6) {
            await m.addColumn(userProfiles, userProfiles.lastBonusClaimDate);
            await m.addColumn(userProfiles, userProfiles.bonusStreak);
            await m.addColumn(userProfiles, userProfiles.crystalsBalance);
          }
          if (from < 7) {
            await m.createTable(jointGoals);
            await m.createTable(jointGoalMembers);
          }
          if (from < 8) {
            await m.createTable(avoidedPurchases);
          }
          if (from < 9) {
            // ── Step 1: Create deposit_allocations (N-Goal relational table) ──
            await customStatement('''
              CREATE TABLE IF NOT EXISTS deposit_allocations (
                id TEXT NOT NULL PRIMARY KEY,
                deposit_id TEXT NOT NULL,
                goal_id TEXT NOT NULL,
                amount INTEGER NOT NULL,
                updated_at INTEGER NOT NULL DEFAULT 0
              )
            ''');

            // ── Step 2: Backfill allocations from legacy goal_a/goal_b data ──
            await customStatement('''
              INSERT OR IGNORE INTO deposit_allocations
                (id, deposit_id, goal_id, amount, updated_at)
              SELECT id || '_goal_a', id, 'goal_a', goal_a_amount, created_at
              FROM deposits
              WHERE goal_a_amount > 0 AND is_deleted = 0
            ''');
            await customStatement('''
              INSERT OR IGNORE INTO deposit_allocations
                (id, deposit_id, goal_id, amount, updated_at)
              SELECT id || '_goal_b', id, 'goal_b', goal_b_amount, created_at
              FROM deposits
              WHERE goal_b_amount > 0 AND is_deleted = 0
            ''');

            // ── Step 3: Recreate deposits without goalA/goalB, add updatedAt ──
            await customStatement('''
              CREATE TABLE deposits_v9 (
                id TEXT NOT NULL PRIMARY KEY,
                amount INTEGER NOT NULL,
                note TEXT,
                created_at INTEGER NOT NULL,
                updated_at INTEGER NOT NULL DEFAULT 0,
                is_deleted INTEGER NOT NULL DEFAULT 0
                  CHECK (is_deleted IN (0, 1))
              )
            ''');
            await customStatement('''
              INSERT INTO deposits_v9
                (id, amount, note, created_at, updated_at, is_deleted)
              SELECT id, amount, note, created_at, created_at, is_deleted
              FROM deposits
            ''');
            await customStatement('DROP TABLE deposits');
            await customStatement(
                'ALTER TABLE deposits_v9 RENAME TO deposits');

            // ── Step 4: Add updatedAt to goals ──
            await customStatement(
              'ALTER TABLE goals ADD COLUMN updated_at INTEGER NOT NULL DEFAULT 0',
            );

            // ── Step 5: Add updatedAt to joint_goals ──
            await customStatement(
              'ALTER TABLE joint_goals ADD COLUMN updated_at INTEGER NOT NULL DEFAULT 0',
            );

            // ── Step 6: Add updatedAt to joint_goal_members ──
            await customStatement(
              'ALTER TABLE joint_goal_members ADD COLUMN updated_at INTEGER NOT NULL DEFAULT 0',
            );

            // ── Step 7: Add updatedAt to user_profiles ──
            await customStatement(
              'ALTER TABLE user_profiles ADD COLUMN updated_at INTEGER NOT NULL DEFAULT 0',
            );
          }
          if (from < 10) {
            await m.addColumn(userProfiles, userProfiles.noSpendStreakCount);
            await m.addColumn(userProfiles, userProfiles.lastNoSpendDate);
          }
          if (from < 11) {
            await m.addColumn(userProfiles, userProfiles.karmaDebt);
            await m.addColumn(userProfiles, userProfiles.debuffActiveUntil);
          }
          if (from < 12) {
            await m.addColumn(goals, goals.productUrl);
            await m.addColumn(goals, goals.targetPrice);
            await m.addColumn(goals, goals.currentPrice);
            await m.addColumn(goals, goals.priceShieldHp);
            await m.addColumn(goals, goals.lastPriceUpdate);
          }
          if (from < 13) {
            await m.addColumn(userProfiles, userProfiles.partnerName);
            await m.addColumn(userProfiles, userProfiles.partnerLastDepositDate);
          }
          if (from < 14) {
            await m.createTable(memoryVaultEntries);
          }
          if (from < 15) {
            await m.addColumn(userProfiles, userProfiles.karmaHealingStreakCount);
            await m.addColumn(userProfiles, userProfiles.lastKarmaHealDate);
          }
          if (from < 16) {
            await m.createTable(lendingContracts);
          }
          if (from < 17) {
            await m.createTable(chatMessages);
          }
          if (from < 18) {
            // Price Pulse: time-series price history table
            await m.createTable(priceHistoryEntries);
            // Price Pulse: XP guard columns on UserProfiles
            await m.addColumn(userProfiles, userProfiles.lastPricePulseXPDate);
            await m.addColumn(userProfiles, userProfiles.pricePulseTrackingCount);
          }
          if (from < 19) {
            await m.createTable(subscriptions);
          }
          if (from < 20) {
            await m.createTable(giftGoals);
          }
          if (from < 21) {
            await m.createTable(graveyardEntries);
            await m.createTable(futureSelfProjections);
            await m.createTable(lootBoxResults);
            await m.createTable(bankSyncConfigs);
            await m.createTable(autoDeposits);
          }
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
          if (from < 23) {
            await m.createTable(voiceCommands);
            await m.createTable(crowdFundWishlists);
            await m.createTable(crowdFundContributions);
            await m.createTable(aRScanEntries);
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
        },
      );

  // ==========================================
  // GOAL QUERIES
  // ==========================================
  Stream<List<Goal>> watchAllGoals() => select(goals).watch();
  Future<List<Goal>> getAllGoals() => select(goals).get();
  Future<Goal?> getGoalById(String id) =>
      (select(goals)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  Future<int> insertGoal(Goal goal) =>
      into(goals).insert(goal, mode: InsertMode.insertOrReplace);
  Future<bool> updateGoal(Goal goal) => update(goals).replace(goal);

  // ==========================================
  // DEPOSIT QUERIES
  // ==========================================
  Stream<List<Deposit>> watchAllDeposits() =>
      (select(deposits)
            ..where((tbl) => tbl.isDeleted.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<List<Deposit>> getAllDeposits() =>
      (select(deposits)
            ..where((tbl) => tbl.isDeleted.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<int> insertDeposit(Deposit deposit) =>
      into(deposits).insert(deposit);

  // ==========================================
  // DEPOSIT ALLOCATIONS QUERIES
  // ==========================================
  Future<List<DepositAllocation>> getAllocationsForDeposit(
          String depositId) =>
      (select(depositAllocations)
            ..where((tbl) => tbl.depositId.equals(depositId)))
          .get();

  Stream<List<DepositAllocation>> watchAllocationsForDeposit(
          String depositId) =>
      (select(depositAllocations)
            ..where((tbl) => tbl.depositId.equals(depositId)))
          .watch();

  Future<List<DepositAllocation>> getAllocationsForGoal(String goalId) =>
      (select(depositAllocations)
            ..where((tbl) => tbl.goalId.equals(goalId)))
          .get();

  // ==========================================
  // MEMORY VAULT QUERIES
  // ==========================================
  Stream<List<MemoryVaultEntry>> watchMemoryVaultEntriesForGoal(String goalId) =>
      (select(memoryVaultEntries)
            ..where((tbl) => tbl.goalId.equals(goalId))
            ..orderBy([(t) => OrderingTerm.asc(t.unlockThresholdPercent)]))
          .watch();

  Future<List<MemoryVaultEntry>> getMemoryVaultEntriesForGoal(String goalId) =>
      (select(memoryVaultEntries)
            ..where((tbl) => tbl.goalId.equals(goalId))
            ..orderBy([(t) => OrderingTerm.asc(t.unlockThresholdPercent)]))
          .get();

  Future<int> insertMemoryVaultEntry(MemoryVaultEntry entry) =>
      into(memoryVaultEntries).insert(entry, mode: InsertMode.insertOrReplace);

  Future<bool> updateMemoryVaultEntry(MemoryVaultEntry entry) => 
      update(memoryVaultEntries).replace(entry);

  // ==========================================
  // N-GOAL TRANSACTION METHODS (Phase 2)
  // ==========================================

  /// Save a deposit distributed across N goals via [DepositAllocations].
  /// [allocations] maps goalId → amount in minor units (kopecks).
  /// Goals are updated atomically within a single SQLite transaction.
  Future<void> saveDepositWithAllocations({
    required Deposit deposit,
    required Map<String, int> allocations,
  }) async {
    await transaction(() async {
      await insertDeposit(deposit);
      for (final entry in allocations.entries) {
        if (entry.value <= 0) continue;
        await into(depositAllocations).insert(DepositAllocationsCompanion(
          id: Value('\$1_\$1'),
          depositId: Value(deposit.id),
          goalId: Value(entry.key),
          amount: Value(entry.value),
          updatedAt: Value(DateTime.now()),
        ));
        final goal = await getGoalById(entry.key);
        if (goal != null) {
          await updateGoal(goal.copyWith(
            currentAmount: goal.currentAmount + entry.value,
            updatedAt: DateTime.now(),
          ));
        }
      }
    });
  }

  /// Soft-delete a deposit and automatically revert all goal currentAmounts
  /// by reading [DepositAllocations] — works with any number of goals.
  Future<void> softDeleteDeposit({required String depositId}) async {
    await transaction(() async {
      final allocs = await getAllocationsForDeposit(depositId);
      await (update(deposits)..where((tbl) => tbl.id.equals(depositId)))
          .write(DepositsCompanion(
        isDeleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ));
      for (final alloc in allocs) {
        final goal = await getGoalById(alloc.goalId);
        if (goal != null) {
          await updateGoal(goal.copyWith(
            currentAmount:
                (goal.currentAmount - alloc.amount).clamp(0, 999999999),
            updatedAt: DateTime.now(),
          ));
        }
      }
    });
  }

  /// @deprecated Use [saveDepositWithAllocations] for full N-Goal support.
  /// Legacy two-goal wrapper maintained for backward compatibility.
  Future<void> saveDepositAndUpdateGoals({
    required Deposit deposit,
    required int goalADelta,
    required int goalBDelta,
  }) async {
    final allocMap = <String, int>{
      if (goalADelta > 0) 'goal_a': goalADelta,
      if (goalBDelta > 0) 'goal_b': goalBDelta,
    };
    await saveDepositWithAllocations(deposit: deposit, allocations: allocMap);
  }

  /// @deprecated Use [softDeleteDeposit] for N-Goal support.
  Future<void> softDeleteDepositAndUpdateGoals({
    required String depositId,
    required int goalAAmount,
    required int goalBAmount,
  }) async {
    await softDeleteDeposit(depositId: depositId);
  }

  // ==========================================
  // USER PROFILE & STREAK QUERIES
  // ==========================================
  Future<UserProfile?> getUserProfile() =>
      (select(userProfiles)..where((tbl) => tbl.id.equals(1)))
          .getSingleOrNull();
  Stream<UserProfile?> watchUserProfile() =>
      (select(userProfiles)..where((tbl) => tbl.id.equals(1)))
          .watchSingleOrNull();
  Future<int> insertUserProfile(UserProfile profile) =>
      into(userProfiles).insert(profile, mode: InsertMode.insertOrReplace);
  Future<bool> updateUserProfile(UserProfile profile) =>
      update(userProfiles).replace(profile);

  // ==========================================
  // ACHIEVEMENTS QUERIES
  // ==========================================
  Future<List<UnlockedAchievement>> getUnlockedAchievements() =>
      select(unlockedAchievements).get();
  Stream<List<UnlockedAchievement>> watchUnlockedAchievements() =>
      select(unlockedAchievements).watch();
  Future<int> unlockAchievement(String id) =>
      into(unlockedAchievements).insert(
        UnlockedAchievement(id: id, unlockedAt: DateTime.now()),
        mode: InsertMode.insertOrReplace,
      );

  // ==========================================
  // SKILL TREE QUERIES
  // ==========================================
  Future<List<UnlockedSkill>> getUnlockedSkills() =>
      select(unlockedSkills).get();
  Stream<List<UnlockedSkill>> watchUnlockedSkills() =>
      select(unlockedSkills).watch();
  Future<bool> isSkillUnlocked(String id) async {
    final result =
        await (select(unlockedSkills)..where((t) => t.id.equals(id)))
            .getSingleOrNull();
    return result != null;
  }

  Future<int> unlockSkill(String id) => into(unlockedSkills).insert(
        UnlockedSkill(id: id, unlockedAt: DateTime.now()),
        mode: InsertMode.insertOrReplace,
      );

  // ==========================================
  // PRICE HISTORY QUERIES (Price Pulse v18)
  // ==========================================

  /// Returns price history for a goal, ordered newest first.
  Future<List<PriceHistoryEntry>> getPriceHistory(String goalId,
      {int limit = 20}) =>
      (select(priceHistoryEntries)
            ..where((t) => t.goalId.equals(goalId))
            ..orderBy([(t) => OrderingTerm.desc(t.cachedAt)])
            ..limit(limit))
          .get();

  /// Returns the latest price snapshot for a goal, or null if none exists.
  Future<PriceHistoryEntry?> getLatestPriceEntry(String goalId) =>
      (select(priceHistoryEntries)
            ..where((t) => t.goalId.equals(goalId))
            ..orderBy([(t) => OrderingTerm.desc(t.cachedAt)])
            ..limit(1))
          .getSingleOrNull();

  /// Inserts a new price snapshot. Returns the row id.
  Future<int> insertPriceHistoryEntry(PriceHistoryEntriesCompanion entry) =>
      into(priceHistoryEntries).insert(entry);

  /// Deletes entries older than [before] for a given goal to prevent
  /// unbounded table growth (keep last 30 snapshots per goal).
  Future<int> pruneOldPriceHistory(String goalId, {int keepLast = 30}) async {
    final rows = await getPriceHistory(goalId, limit: keepLast + 1);
    if (rows.length <= keepLast) return 0;
    final cutoff = rows[keepLast - 1].cachedAt;
    return (delete(priceHistoryEntries)
          ..where(
              (t) => t.goalId.equals(goalId) & t.cachedAt.isSmallerThan(Variable(cutoff))))
        .go();
  }

  /// Watches live price history stream for a goal (for UI reactivity).
  Stream<List<PriceHistoryEntry>> watchPriceHistory(String goalId,
          {int limit = 10}) =>
      (select(priceHistoryEntries)
            ..where((t) => t.goalId.equals(goalId))
            ..orderBy([(t) => OrderingTerm.desc(t.cachedAt)])
            ..limit(limit))
          .watch();

  // ==========================================
  // GIFT FUND QUERIES (v20)
  // ==========================================

  Future<List<GiftGoal>> getAllGiftGoals() => select(giftGoals).get();

  Stream<List<GiftGoal>> watchAllGiftGoals() => select(giftGoals).watch();

  Future<GiftGoal?> getGiftGoalByGoalId(String goalId) =>
      (select(giftGoals)..where((tbl) => tbl.goalId.equals(goalId)))
          .getSingleOrNull();

  Stream<GiftGoal?> watchGiftGoalByGoalId(String goalId) =>
      (select(giftGoals)..where((tbl) => tbl.goalId.equals(goalId)))
          .watchSingleOrNull();

  /// Returns gift goals where the goal is still in progress (current < target).
  /// Uses a JOIN to avoid orphaned data if goals were modified outside the app.
  Future<List<GiftGoal>> getActiveGiftGoals() async {
    final rows = await (select(giftGoals)
          ..orderBy([(t) => OrderingTerm.asc(t.occasionDate)]))
        .get();
    final goalIds = rows.map((r) => r.goalId).toList();
    if (goalIds.isEmpty) return [];
    final activeGoals = await (select(goals)
          ..where((tbl) => tbl.id.isIn(goalIds) & tbl.currentAmount.isSmallerThan(tbl.targetAmount)))
        .get();
    final activeGoalIds = activeGoals.map((g) => g.id).toSet();
    return rows.where((r) => activeGoalIds.contains(r.goalId)).toList();
  }

  Future<int> insertGiftGoal(GiftGoal giftGoal) =>
      into(giftGoals).insert(giftGoal, mode: InsertMode.insertOrReplace);

  Future<bool> updateGiftGoal(GiftGoal giftGoal) =>
      update(giftGoals).replace(giftGoal);

  Future<int> deleteGiftGoal(String id) =>
      (delete(giftGoals)..where((tbl) => tbl.id.equals(id))).go();

  /// Called when a Goal is deleted to ensure no orphaned gift goals remain.
  /// The DB FOREIGN KEY with ON DELETE CASCADE also handles this at the SQL level.
  Future<int> deleteGiftGoalsByGoalId(String goalId) =>
      (delete(giftGoals)..where((tbl) => tbl.goalId.equals(goalId))).go();
}
