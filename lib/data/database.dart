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
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  AppDatabase.connect(super.connection);

  @override
  int get schemaVersion => 20;

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
          id: Value('${deposit.id}_${entry.key}'),
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
