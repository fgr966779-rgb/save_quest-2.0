import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class DailyBonusState {
  final bool isBonusAvailable;
  final int currentBonusStreak;
  final int bonusAmountForToday;
  final bool shieldActivated;
  final int shieldDaysSaved;

  DailyBonusState({
    required this.isBonusAvailable,
    required this.currentBonusStreak,
    required this.bonusAmountForToday,
    this.shieldActivated = false,
    this.shieldDaysSaved = 0,
  });
}

class DailyBonusNotifier extends StateNotifier<AsyncValue<DailyBonusState>> {
  final AppDatabase db;
  
  DailyBonusNotifier(this.db) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final profile = await db.getUserProfile();
      if (profile == null) {
        state = AsyncValue.data(DailyBonusState(
          isBonusAvailable: false,
          currentBonusStreak: 0,
          bonusAmountForToday: 5,
        ));
        return;
      }

      final now = DateTime.now();
      final lastClaim = profile.lastBonusClaimDate;
      int currentStreak = profile.bonusStreak;
      bool isAvailable = false;
      bool shieldActivated = false;
      int shieldDaysSaved = 0;
      
      int freezeTokens = profile.freezeTokens;
      UserProfile updatedProfile = profile;

      if (lastClaim == null) {
        isAvailable = true;
      } else {
        final lastClaimDateOnly = DateTime(lastClaim.year, lastClaim.month, lastClaim.day);
        final todayDateOnly = DateTime(now.year, now.month, now.day);
        
        final difference = todayDateOnly.difference(lastClaimDateOnly).inDays;

        if (difference == 1) {
          // Normal next day
          isAvailable = true;
        } else if (difference > 1) {
          // Missed days
          final missedDays = difference - 1;
          
          if (freezeTokens > 0) {
            // Use shield
            shieldActivated = true;
            shieldDaysSaved = missedDays;
            
            // Only consume 1 token per missed period (or we can consume 1 token per missed day depending on the balance we want)
            // Let's say 1 freeze token saves the streak entirely regardless of days missed for simplicity, 
            
            if (freezeTokens >= missedDays) {
               // Full streak saved
               freezeTokens -= missedDays;
               isAvailable = true;
               
               // Update DB that tokens were consumed so we don't consume them again without claiming
               updatedProfile = updatedProfile.copyWith(freezeTokens: freezeTokens);
               await db.updateUserProfile(updatedProfile);
            } else {
               // Not enough tokens, streak broken
               currentStreak = 0;
               isAvailable = true;
               updatedProfile = updatedProfile.copyWith(bonusStreak: 0);
               await db.updateUserProfile(updatedProfile);
            }
          } else {
            // No shield, streak broken
            currentStreak = 0;
            isAvailable = true;
            updatedProfile = updatedProfile.copyWith(bonusStreak: 0);
            await db.updateUserProfile(updatedProfile);
          }
        } else if (difference == 0) {
          // Already claimed today
          isAvailable = false;
        }
      }

      int bonusForToday = _calculateBonusForStreak(currentStreak + 1);

      state = AsyncValue.data(DailyBonusState(
        isBonusAvailable: isAvailable,
        currentBonusStreak: currentStreak,
        bonusAmountForToday: bonusForToday,
        shieldActivated: shieldActivated,
        shieldDaysSaved: shieldDaysSaved,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  int _calculateBonusForStreak(int streak) {
    if (streak >= 30) return 200;
    if (streak >= 7) return 50;
    if (streak >= 3) return 15;
    return 5; // Default day 1, 2
  }

  Future<void> claimBonus() async {
    final currentState = state.value;
    if (currentState == null || !currentState.isBonusAvailable) return;

    try {
      final profile = await db.getUserProfile();
      if (profile == null) return;

      int newStreak = currentState.currentBonusStreak + 1;
      
      await (db.update(db.userProfiles)..where((t) => t.id.equals(1))).write(UserProfilesCompanion(
          lastBonusClaimDate: Value(DateTime.now()),
          bonusStreak: Value(newStreak),
          crystalsBalance: Value(profile.crystalsBalance + currentState.bonusAmountForToday),
      ));

      state = AsyncValue.data(DailyBonusState(
        isBonusAvailable: false,
        currentBonusStreak: newStreak,
        bonusAmountForToday: _calculateBonusForStreak(newStreak + 1),
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final dailyBonusProvider = StateNotifierProvider<DailyBonusNotifier, AsyncValue<DailyBonusState>>((ref) {
  final db = ref.watch(databaseProvider);
  return DailyBonusNotifier(db);
});
