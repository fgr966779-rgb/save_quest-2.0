import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

/// Immutable state for the No-Spend Streak challenge.
class NoSpendState {
  /// Total consecutive days where user declared "no-spend".
  final int streakCount;

  /// Progress inside the current 7-day chest cycle (0–6).
  final int boxProgress;

  /// Whether the user can still claim "no-spend" for today.
  final bool canClaimToday;

  /// Set to true right after a successful claim — used to trigger
  /// the success dialog in the UI then immediately reset to false.
  final bool justClaimed;

  /// Set to true if a lootbox was just awarded (7-day boundary).
  final bool justEarnedLootbox;

  const NoSpendState({
    required this.streakCount,
    required this.boxProgress,
    required this.canClaimToday,
    this.justClaimed = false,
    this.justEarnedLootbox = false,
  });

  NoSpendState copyWith({
    int? streakCount,
    int? boxProgress,
    bool? canClaimToday,
    bool? justClaimed,
    bool? justEarnedLootbox,
  }) {
    return NoSpendState(
      streakCount: streakCount ?? this.streakCount,
      boxProgress: boxProgress ?? this.boxProgress,
      canClaimToday: canClaimToday ?? this.canClaimToday,
      justClaimed: justClaimed ?? this.justClaimed,
      justEarnedLootbox: justEarnedLootbox ?? this.justEarnedLootbox,
    );
  }
}

class NoSpendNotifier extends AsyncNotifier<NoSpendState> {
  @override
  Future<NoSpendState> build() async {
    return _loadState();
  }

  /// Reads the current UserProfile from DB and derives the NoSpendState.
  Future<NoSpendState> _loadState() async {
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();

    if (profile == null) {
      return const NoSpendState(
        streakCount: 0,
        boxProgress: 0,
        canClaimToday: true,
      );
    }

    final lastDate = profile.lastNoSpendDate;
    final today = _today();
    final alreadyClaimedToday = lastDate != null && _isSameDay(lastDate, today);

    return NoSpendState(
      streakCount: profile.noSpendStreakCount,
      boxProgress: profile.noSpendStreakCount % 7,
      canClaimToday: !alreadyClaimedToday,
    );
  }

  /// Main action: user declares today as a "no-spend" day.
  Future<void> claimNoSpend() async {
    final currentState = state.valueOrNull;
    if (currentState == null || !currentState.canClaimToday) return;

    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile == null) return;

    final now = DateTime.now();
    final newStreak = profile.noSpendStreakCount + 1;
    const crystalReward = 15;

    // Determine if this triggers a 7-day lootbox
    final earnedLootbox = newStreak % 7 == 0;

    // Write updated profile atomically
    await db.updateUserProfile(profile.copyWith(
      noSpendStreakCount: newStreak,
      lastNoSpendDate: Value(now),
      crystalsBalance: profile.crystalsBalance + crystalReward,
      updatedAt: now,
    ));

    // If 7-day milestone — insert an unopened Lootbox
    if (earnedLootbox) {
      await db.into(db.lootboxes).insert(LootboxesCompanion.insert(
        id: 'no_spend_lootbox_${now.millisecondsSinceEpoch}',
        rarity: 'rare',
        earnedAt: now,
      ));
    }

    // Refresh userProfileProvider so the header crystal counter updates
    ref.invalidate(userProfileProvider);

    state = AsyncData(NoSpendState(
      streakCount: newStreak,
      boxProgress: newStreak % 7,
      canClaimToday: false,
      justClaimed: true,
      justEarnedLootbox: earnedLootbox,
    ));
  }

  /// Resets the "just claimed / just earned lootbox" flags after the
  /// success dialog has been shown. Call this from the UI after display.
  void clearJustClaimed() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      justClaimed: false,
      justEarnedLootbox: false,
    ));
  }

  /// DEBUG cheat hook: fast-forwards lastNoSpendDate by one day back
  /// so the user appears to have not claimed today, effectively letting
  /// them claim again immediately. Simulates passing a day.
  Future<void> debugIncrementDays() async {
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile == null) return;

    // Set lastNoSpendDate to yesterday so canClaimToday becomes true again
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    await db.updateUserProfile(profile.copyWith(
      lastNoSpendDate: Value(yesterday),
      updatedAt: DateTime.now(),
    ));

    ref.invalidate(userProfileProvider);

    // Reload from DB
    state = AsyncData(await _loadState());
  }

  // ─── Private Helpers ────────────────────────────────────────────────────────

  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

final noSpendProvider =
    AsyncNotifierProvider<NoSpendNotifier, NoSpendState>(NoSpendNotifier.new);
