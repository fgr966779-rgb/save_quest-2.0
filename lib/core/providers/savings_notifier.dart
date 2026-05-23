import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import '../../data/database.dart';
import '../providers/providers.dart';
import '../utils/money_utils.dart';
import '../../features/gamification/models/achievement_model.dart';
import '../../features/gamification/models/badge_model.dart';
import '../../features/gamification/screens/skill_tree_screen.dart' show allSkillNodes;
import '../../core/widgets/neon_avatar_painter.dart';
import '../providers/events_notifier.dart';
import '../../features/gamification/providers/bounty_provider.dart';
import '../../features/gamification/providers/quest_provider.dart';

enum ActionContext {
  standard,
  cli,          // CLI usage -> Hacker XP
  bounty,       // AI Bounties -> Hacker XP
  recovery,     // Paying penalties -> Resilience XP
}
class DepositResult {
  final Deposit deposit;
  final int xpGained;
  final bool leveledUp;
  final int newLevel;
  final int streakCount;
  final bool freezeUsed;
  final bool isCritical;
  final int bonusXp;
  final int earnedCredits;
  final Lootbox? earnedLootbox;
  final List<Achievement> newlyUnlockedAchievements;
  final int hackerXpGained;
  final int magnateXpGained;
  final int resilienceXpGained;

  DepositResult({
    required this.deposit,
    required this.xpGained,
    required this.leveledUp,
    required this.newLevel,
    required this.streakCount,
    required this.freezeUsed,
    required this.isCritical,
    required this.bonusXp,
    required this.earnedCredits,
    this.earnedLootbox,
    required this.newlyUnlockedAchievements,
    required this.hackerXpGained,
    required this.magnateXpGained,
    required this.resilienceXpGained,
  });
}

class SavingsNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _db;
  final Ref _ref;

  SavingsNotifier(this._db, this._ref) : super(const AsyncValue.data(null));

  // Formula: XP required for level N = 1000 * N^1.5
  static int xpRequiredForLevel(int level) {
    return (1000 * math.pow(level, 1.5)).toInt();
  }

  static Map<String, dynamic> calculateStreak({
    required DateTime? lastDepositDate,
    required int currentStreak,
    required int maxStreak,
    required int freezeTokens,
    String? playerClass,
    Set<String> unlockedSkillIds = const {},
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (lastDepositDate == null) {
      return {
        'streak': 1,
        'maxStreak': math.max(1, maxStreak),
        'freezeUsed': false,
        'freezeTokens': freezeTokens,
      };
    }

    final last = DateTime(lastDepositDate.year, lastDepositDate.month, lastDepositDate.day);
    final difference = today.difference(last).inDays;

    if (difference == 0) {
      return {
        'streak': currentStreak,
        'maxStreak': maxStreak,
        'freezeUsed': false,
        'freezeTokens': freezeTokens,
      };
    } else if (difference == 1) {
      final newStreak = currentStreak + 1;
      return {
        'streak': newStreak,
        'maxStreak': math.max(newStreak, maxStreak),
        'freezeUsed': false,
        'freezeTokens': freezeTokens,
      };
    } else {
      // resilience_shield: auto-protect once every 14 days (stored separately; simplified here as a bonus freeze)
      final hasShield = unlockedSkillIds.contains('resilience_shield');
      final effectiveFreezes = hasShield ? math.max(1, freezeTokens) : freezeTokens;

      if (effectiveFreezes > 0) {
        final newStreak = currentStreak + 1;
        bool consumeToken = true;
        
        final actualConsume = consumeToken && !hasShield;
        return {
          'streak': newStreak,
          'maxStreak': math.max(newStreak, maxStreak),
          'freezeUsed': true,
          'freezeTokens': actualConsume ? freezeTokens - 1 : freezeTokens,
        };
      } else {
        return {
          'streak': 1,
          'maxStreak': maxStreak,
          'freezeUsed': false,
          'freezeTokens': freezeTokens,
        };
      }
    }
  }

  // ==========================================
  // TRANSACTION: CONFIRM DEPOSIT
  // All amounts arrive as display doubles (e.g. 250.50 UAH).
  // We convert to kopecks (int) before touching the DB.
  // ==========================================
  Future<DepositResult?> createDeposit({
    required double amount,
    required double goalAPercent,
    String? note,
    CyberEvent? activeEvent,
    ActionContext context = ActionContext.standard,
  }) async {
    state = const AsyncValue.loading();
    try {
      // --- Convert to minor units (kopecks) ---
      final int totalCents   = displayToCents(amount);
      final int goalACents   = (totalCents * goalAPercent / 100.0).round();
      final int goalBCents   = totalCents - goalACents; // exact, no rounding drift

      final depositId = const Uuid().v4();
      final now = DateTime.now();

      final deposit = Deposit(
        id: depositId,
        amount: totalCents,
        goalAAmount: goalACents,
        goalBAmount: goalBCents,
        note: note,
        createdAt: now,
        isDeleted: false,
      );

      // ----------------------------------------
      // Single atomic transaction: savings + gamification
      // ----------------------------------------
      late UserProfile updatedProfile;
      List<Achievement> newlyUnlocked = [];
      late int xpGained;
      late bool leveledUp;
      late int finalLevel;
      late int newStreak;
      late bool freezeUsed;
      late bool isCritical;
      late int bonusXp;
      late int earnedCredits;
      late int hackerXpInc;
      late int magnateXpInc;
      late int resilienceXpInc;
      Lootbox? earnedLootbox;

      await _db.transaction(() async {
        // 1. Save deposit and update goal balances
        await _db.saveDepositAndUpdateGoals(
          deposit: deposit,
          goalADelta: goalACents,
          goalBDelta: goalBCents,
        );

        // 2. Load or create user profile
        var profile = await _db.getUserProfile();
        profile ??= UserProfile(
          id: 1, xp: 0, level: 1, streakCount: 0, maxStreak: 0, freezeTokens: 0, 
          skillPoints: 0, playerClass: null, currentTheme: 'default', avatarConfig: null,
          penaltyBalance: 0, hackerXp: 0, magnateXp: 0, resilienceXp: 0,
          lastBonusClaimDate: null, bonusStreak: 0, crystalsBalance: 0,
        );

        // 3. Load unlocked skills for bonus application
        final unlockedSkillList = await _db.getUnlockedSkills();
        final unlockedSkillIds = unlockedSkillList.map((s) => s.id).toSet();

        // 4. Streak calculation
        final streakResults = calculateStreak(
          lastDepositDate: profile.lastDepositDate,
          currentStreak: profile.streakCount,
          maxStreak: profile.maxStreak,
          freezeTokens: profile.freezeTokens,
          playerClass: profile.playerClass,
          unlockedSkillIds: unlockedSkillIds,
        );

        newStreak = streakResults['streak'] as int;
        final maxStreak = streakResults['maxStreak'] as int;
        freezeUsed = streakResults['freezeUsed'] as bool;
        final currentFreezes = streakResults['freezeTokens'] as int;

        // 5. XP multiplier (streak-based)
        double multiplier = 1.0;
        if (newStreak >= 30)      multiplier = 1.5;
        else if (newStreak >= 14) multiplier = 1.3;
        else if (newStreak >= 7)  multiplier = 1.2;
        else if (newStreak >= 3)  multiplier = 1.1;

        // Combine streak multiplier with Cyber-Event multiplier
        if (activeEvent != null && activeEvent.isActive) {
          multiplier *= activeEvent.xpMultiplier;
        }

        xpGained = (100 * multiplier).toInt();

        // ── Class bonuses ──
        if (profile.playerClass == 'warrior') {
          xpGained = (xpGained * 1.10).toInt(); // Warrior: +10% XP
        }
        if (profile.playerClass == 'rogue') {
          xpGained += 25; // Rogue: Flat +25 XP
        }

        // ── Skill bonuses ──
        // magnate_xp_boost: +5% XP
        if (unlockedSkillIds.contains('magnate_xp_boost')) {
          xpGained = (xpGained * 1.05).toInt();
        }

        // Critical Hit logic
        double baseCritChance = profile.playerClass == 'mage' ? 0.25 : 0.10;
        // hacker_crit_boost: +10% crit chance
        if (unlockedSkillIds.contains('hacker_crit_boost')) {
          baseCritChance += 0.10;
        }
        isCritical = math.Random().nextDouble() < baseCritChance;
        bonusXp = isCritical ? xpGained : 0;
        
        var newXP = profile.xp + xpGained + bonusXp;
        var currentLevel = profile.level;
        leveledUp = false;

        // 5. Level-up loop
        while (newXP >= xpRequiredForLevel(currentLevel)) {
          currentLevel++;
          leveledUp = true;
        }
        finalLevel = currentLevel;

        final finalFreezes = currentFreezes + (leveledUp ? 1 : 0);
        final levelUps = finalLevel - profile.level;
        final newSkillPoints = profile.skillPoints + levelUps;

        // 5a. Cyber-Market Credits calculation + Badge updates
        // 1 Credit per 10 UAH (1000 kopecks)
        double creditsMulti = 1.0;
        if (activeEvent != null && activeEvent.isActive) {
          creditsMulti = activeEvent.creditsMultiplier;
        }
        
        earnedCredits = ((totalCents ~/ 1000) * creditsMulti).toInt();
        
        // Calculate Specific Skill XP
        hackerXpInc = 0;
        magnateXpInc = 0;
        resilienceXpInc = 0;

        // Hacker XP
        if (context == ActionContext.cli) hackerXpInc += 150;
        if (context == ActionContext.bounty) hackerXpInc += 300;

        // Magnate XP
        if (totalCents >= 50000) { // >= 500 UAH
          magnateXpInc += 250;
        } else if (totalCents >= 10000) { // >= 100 UAH
          magnateXpInc += 100;
        }
        magnateXpInc += (totalCents ~/ 500); // 1 XP per 5 UAH

        // Resilience XP
        if (context == ActionContext.recovery) resilienceXpInc += 200;
        if (newStreak > 1 && newStreak % 7 == 0) resilienceXpInc += 100; // Bonus every week
        if (newStreak >= 30) resilienceXpInc += 50; // Daily passive for long streaks

        // Load or create avatar config for credit + badge updates
        final existingConfig = profile.avatarConfig != null 
            ? AvatarConfig.fromJson(profile.avatarConfig!)
            : const AvatarConfig();

        // Calculate total saved for badge checks (loaded after save)
        final goalANow = await _db.getGoalById('goal_a');
        final goalBNow = await _db.getGoalById('goal_b');
        int totalSavedCents = 0;
        if (goalANow != null) totalSavedCents += goalANow.currentAmount;
        if (goalBNow != null) totalSavedCents += goalBNow.currentAmount;

        // Badge check
        final newBadges = checkNewBadges(
          existingBadges: existingConfig.badges,
          newStreak: newStreak,
          totalSavedCents: totalSavedCents,
          depositAmountCents: totalCents,
          hour: now.hour,
          depositsToday: 1, // simplified: no daily counter yet
        );
        final allNewBadges = [...(existingConfig.badges ?? <String>[]), ...newBadges];

        // Save credits + badges into AvatarConfig
        final updatedConfig = existingConfig.copyWith(
          credits: existingConfig.credits + earnedCredits,
          badges: allNewBadges,
        );
        final newAvatarConfigJson = updatedConfig.toJson();

        updatedProfile = UserProfile(
          id: profile.id,
          xp: newXP,
          level: finalLevel,
          streakCount: newStreak,
          maxStreak: maxStreak,
          freezeTokens: finalFreezes,
          lastDepositDate: now,
          skillPoints: newSkillPoints,
          playerClass: profile.playerClass,
          currentTheme: profile.currentTheme,
          avatarConfig: newAvatarConfigJson,
          penaltyBalance: profile.penaltyBalance,
          hackerXp: profile.hackerXp + hackerXpInc,
          magnateXp: profile.magnateXp + magnateXpInc,
          resilienceXp: profile.resilienceXp + resilienceXpInc,
          lastBonusClaimDate: profile.lastBonusClaimDate,
          bonusStreak: profile.bonusStreak,
          crystalsBalance: profile.crystalsBalance,
        );
        await _db.insertUserProfile(updatedProfile);

        // 5b. Squads update
        final squads = await _db.select(_db.squads).get();
        if (squads.isNotEmpty) {
          final squad = squads.first;
          await (_db.update(_db.squads)..where((t) => t.id.equals(squad.id))).write(
            SquadsCompanion(totalXp: drift.Value(squad.totalXp + xpGained + bonusXp)),
          );
        }

        // 6. Achievement validation (inside same transaction)
        final unlockedList = await _db.getUnlockedAchievements();
        final unlockedIds = unlockedList.map((e) => e.id).toSet();
        
        // Lootbox drop logic
        final rnd = math.Random().nextDouble();
        if (rnd < 0.05) {
          earnedLootbox = Lootbox(id: const Uuid().v4(), rarity: 'rare', isOpened: false, earnedAt: now);
        } else if (rnd < 0.25) {
          earnedLootbox = Lootbox(id: const Uuid().v4(), rarity: 'common', isOpened: false, earnedAt: now);
        }
        
        if (earnedLootbox != null) {
          await _db.into(_db.lootboxes).insert(earnedLootbox!);
        }
        final goalA = await _db.getGoalById('goal_a');
        final goalB = await _db.getGoalById('goal_b');

        // Total saved in kopecks (for achievements)
        int totalSavedCentsAch = 0;
        if (goalA != null) totalSavedCentsAch += goalA.currentAmount;
        if (goalB != null) totalSavedCentsAch += goalB.currentAmount;

        for (final ach in allAchievements) {
          if (unlockedIds.contains(ach.id)) continue;

          bool meetsCriteria = false;
          switch (ach.id) {
            case 'first_step':
              meetsCriteria = true;
              break;
            case 'cyber_saver_3':
              meetsCriteria = newStreak >= 3;
              break;
            case 'neon_streak_7':
              meetsCriteria = newStreak >= 7;
              break;
            case 'golden_flame_14':
              meetsCriteria = newStreak >= 14;
              break;
            case 'immortal_fire_30':
              meetsCriteria = newStreak >= 30;
              break;
            case 'halfway_ps5':
              if (goalA != null) {
                meetsCriteria = goalA.currentAmount >= (goalA.targetAmount ~/ 2);
              }
              break;
            case 'halfway_monitor':
              if (goalB != null) {
                meetsCriteria = goalB.currentAmount >= (goalB.targetAmount ~/ 2);
              }
              break;
            case 'ps5_acquired':
              if (goalA != null) {
                meetsCriteria = goalA.currentAmount >= goalA.targetAmount;
              }
              break;
            case 'monitor_acquired':
              if (goalB != null) {
                meetsCriteria = goalB.currentAmount >= goalB.targetAmount;
              }
              break;
            case 'split_master':
              meetsCriteria = goalAPercent == 50.0;
              break;
            case 'laser_focus_a':
              meetsCriteria = goalAPercent == 100.0;
              break;
            case 'laser_focus_b':
              meetsCriteria = goalAPercent == 0.0;
              break;
            case 'freeze_shield':
              meetsCriteria = freezeUsed;
              break;
            case 'xp_hoarder_1':
              meetsCriteria = currentLevel >= 5;
              break;
            case 'xp_legend':
              meetsCriteria = currentLevel >= 10;
              break;
            case 'night_owl':
              meetsCriteria = now.hour >= 0 && now.hour < 5;
              break;
            case 'centurion':
              // 100 UAH = 10000 kopecks
              meetsCriteria = totalCents >= 10000;
              break;
            case 'big_boss':
              // 1000 UAH = 100000 kopecks
              meetsCriteria = totalSavedCentsAch >= 100000;
              break;
            case 'serial_investor':
              // Check total deposits count
              final allDeps = await _db.getAllDeposits();
              meetsCriteria = allDeps.length >= 10;
              break;
            // analytics_master and gambling_hacker are tracked elsewhere
          }

          if (meetsCriteria) {
            await _db.unlockAchievement(ach.id);
            newlyUnlocked.add(ach);
          }
        }
      }); // end transaction

      // Check Bounty
      await _ref.read(bountyProvider.notifier).checkDeposit(amount);

      // Complete Daily Quest: deposit_any
      _ref.read(questProvider.notifier).completeQuest('deposit_any');

      state = const AsyncValue.data(null);
      return DepositResult(
        deposit: deposit,
        xpGained: xpGained,
        leveledUp: leveledUp,
        newLevel: finalLevel,
        streakCount: newStreak,
        freezeUsed: freezeUsed,
        isCritical: isCritical,
        bonusXp: bonusXp,
        earnedCredits: earnedCredits,
        earnedLootbox: earnedLootbox,
        newlyUnlockedAchievements: newlyUnlocked,
        hackerXpGained: hackerXpInc,
        magnateXpGained: magnateXpInc,
        resilienceXpGained: resilienceXpInc,
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  // ==========================================
  // TRANSACTION: REVERT DEPOSIT
  // ==========================================
  Future<bool> deleteDeposit(Deposit deposit) async {
    final now = DateTime.now();
    if (now.difference(deposit.createdAt).inHours >= 24) {
      return false;
    }

    state = const AsyncValue.loading();
    try {
      await _db.softDeleteDepositAndUpdateGoals(
        depositId: deposit.id,
        goalAAmount: deposit.goalAAmount,
        goalBAmount: deposit.goalBAmount,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

final savingsNotifierProvider = StateNotifierProvider<SavingsNotifier, AsyncValue<void>>((ref) {
  return SavingsNotifier(ref.watch(databaseProvider), ref);
});
