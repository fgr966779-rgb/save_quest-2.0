import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/providers/providers.dart';

class KarmaState {
  final int karmaDebt;
  final DateTime? debuffActiveUntil;
  final bool justReported;
  final bool justHealed;

  KarmaState({
    required this.karmaDebt,
    this.debuffActiveUntil,
    this.justReported = false,
    this.justHealed = false,
  });

  KarmaState copyWith({
    int? karmaDebt,
    drift.Value<DateTime?> debuffActiveUntil = const drift.Value.absent(),
    bool? justReported,
    bool? justHealed,
  }) {
    return KarmaState(
      karmaDebt: karmaDebt ?? this.karmaDebt,
      debuffActiveUntil: debuffActiveUntil.present ? debuffActiveUntil.value : this.debuffActiveUntil,
      justReported: justReported ?? this.justReported,
      justHealed: justHealed ?? this.justHealed,
    );
  }
}

class KarmaNotifier extends AsyncNotifier<KarmaState> {
  @override
  Future<KarmaState> build() async {
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile == null) {
      return KarmaState(karmaDebt: 0);
    }
    return KarmaState(
      karmaDebt: profile.karmaDebt,
      debuffActiveUntil: profile.debuffActiveUntil,
    );
  }

  /// Self-report an impulse buy, leading to a temporary debuff and karma debt increase.
  Future<void> reportImpulseSpend(double amount) async {
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile == null) return;

    final now = DateTime.now();
    // Add 50 karma debt, max capped at 150
    final newDebt = (profile.karmaDebt + 50).clamp(0, 150);
    // Debuff active for 48 hours from now
    final debuffEnd = now.add(const Duration(hours: 48));

    await db.updateUserProfile(profile.copyWith(
      karmaDebt: newDebt,
      debuffActiveUntil: drift.Value(debuffEnd),
      updatedAt: now,
    ));

    ref.invalidate(userProfileProvider);
    // Refresh daily quests to potentially show the recovery quest

    state = AsyncData(KarmaState(
      karmaDebt: newDebt,
      debuffActiveUntil: debuffEnd,
      justReported: true,
    ));
  }

  /// Execute cleanse step to reduce karma debt by 25 points.
  Future<void> cleanseKarma() async {
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile == null || profile.karmaDebt <= 0) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final newDebt = (profile.karmaDebt - 25).clamp(0, 150);
    final isFullyHealed = newDebt <= 0;

    // --- Streak Logic ---
    int newStreak = profile.karmaHealingStreakCount;
    final lastHeal = profile.lastKarmaHealDate;

    if (lastHeal == null) {
      newStreak = 1;
    } else {
      final lastHealDay = DateTime(lastHeal.year, lastHeal.month, lastHeal.day);
      final diff = today.difference(lastHealDay).inDays;

      if (diff == 1) {
        newStreak += 1;
      } else if (diff > 1) {
        newStreak = 1;
      }
      // if diff == 0, keep same streak (already healed today)
    }

    await db.updateUserProfile(profile.copyWith(
      karmaDebt: newDebt,
      debuffActiveUntil: isFullyHealed ? const drift.Value(null) : drift.Value(profile.debuffActiveUntil),
      karmaHealingStreakCount: newStreak,
      lastKarmaHealDate: drift.Value(now),
      updatedAt: now,
    ));

    ref.invalidate(userProfileProvider);

    state = AsyncData(KarmaState(
      karmaDebt: newDebt,
      debuffActiveUntil: isFullyHealed ? null : profile.debuffActiveUntil,
      justHealed: isFullyHealed,
    ));
  }

  void clearFlags() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      justReported: false,
      justHealed: false,
    ));
  }

  /// DEBUG: Increment healing streak by 1 and set lastHealDate to yesterday.
  Future<void> debugIncrementStreak() async {
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile == null) return;

    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    await db.updateUserProfile(profile.copyWith(
      karmaHealingStreakCount: profile.karmaHealingStreakCount + 1,
      lastKarmaHealDate: drift.Value(yesterday),
      updatedAt: DateTime.now(),
    ));

    ref.invalidate(userProfileProvider);
    state = AsyncData(await build());
  }
}

final karmaProvider = AsyncNotifierProvider<KarmaNotifier, KarmaState>(KarmaNotifier.new);
