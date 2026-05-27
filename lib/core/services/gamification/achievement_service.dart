import '../../../data/database.dart';
import '../../../features/gamification/models/reward_model.dart';

class AchievementService {
  static Future<List<Reward>> validateRewards({
    required AppDatabase db,
    required int newStreak,
    required int totalSavedCents,
    required int depositAmountCents,
    required int totalDepositsCount,
    required int depositsToday,
    required int currentLevel,
    required bool freezeUsed,
    required double goalAPercent,
    required DateTime now,
    required Set<String> unlockedIds,
  }) async {
    final List<Reward> newlyUnlocked = [];
    final goalA = await db.getGoalById('goal_a');
    final goalB = await db.getGoalById('goal_b');

    for (final reward in allRewards) {
      if (unlockedIds.contains(reward.id)) continue;

      bool meetsCriteria = false;
      switch (reward.id) {
        // --- Achievements ---
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
        case 'freeze_shield':
          meetsCriteria = freezeUsed;
          break;
        case 'xp_hoarder_1':
          meetsCriteria = currentLevel >= 5;
          break;
        case 'centurion':
          meetsCriteria = depositAmountCents >= 10000;
          break;

        // --- Badges ---
        case 'iron_wallet':
          meetsCriteria = newStreak >= 7;
          break;
        case 'corporate_magnate':
          meetsCriteria = totalSavedCents >= 1000000;
          break;
        case 'speed_runner':
          meetsCriteria = depositsToday >= 5;
          break;
      }

      if (meetsCriteria) {
        await db.unlockAchievement(reward.id);
        newlyUnlocked.add(reward);
      }
    }
    return newlyUnlocked;
  }
}
