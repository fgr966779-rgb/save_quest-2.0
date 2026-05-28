import 'dart:math' as math;

class XpService {
  /// Formula: XP required for level N = 1000 * N^1.5
  static int xpRequiredForLevel(int level) {
    return (1000 * math.pow(level, 1.5)).toInt();
  }

  static double calculateStreakMultiplier(int streak) {
    if (streak >= 30) return 1.5;
    if (streak >= 14) return 1.3;
    if (streak >= 7) return 1.2;
    if (streak >= 3) return 1.1;
    return 1.0;
  }

  static int calculateXpGained({
    required int baseAmount,
    required double multiplier,
    String? playerClass,
    bool hasXpBoostSkill = false,
  }) {
    int xp = (baseAmount * multiplier).toInt();

    if (playerClass == 'warrior') {
      xp = (xp * 1.10).toInt();
    } else if (playerClass == 'rogue') {
      xp += 25;
    }

    if (hasXpBoostSkill) {
      xp = (xp * 1.05).toInt();
    }

    return xp;
  }
}
