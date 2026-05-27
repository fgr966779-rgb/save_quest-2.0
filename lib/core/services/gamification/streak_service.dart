import 'dart:math' as math;

class StreakService {
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

    final last = DateTime(
        lastDepositDate.year, lastDepositDate.month, lastDepositDate.day);
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
      final hasShield = unlockedSkillIds.contains('resilience_shield');
      final effectiveFreezes =
          hasShield ? math.max(1, freezeTokens) : freezeTokens;

      if (effectiveFreezes > 0) {
        final newStreak = currentStreak + 1;
        final actualConsume = !hasShield;
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
}
