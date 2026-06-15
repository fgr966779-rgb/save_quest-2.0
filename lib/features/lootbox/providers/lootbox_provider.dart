import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/providers.dart';
import '../../../data/database.dart';

class LootBoxState {
  final bool isOpening;
  final LootBoxResult? lastResult;
  final int totalOpened;
  final String bestLoot;

  LootBoxState({
    this.isOpening = false,
    this.lastResult,
    this.totalOpened = 0,
    this.bestLoot = 'Немає',
  });

  LootBoxState copyWith({
    bool? isOpening,
    LootBoxResult? lastResult,
    int? totalOpened,
    String? bestLoot,
  }) {
    return LootBoxState(
      isOpening: isOpening ?? this.isOpening,
      lastResult: lastResult ?? this.lastResult,
      totalOpened: totalOpened ?? this.totalOpened,
      bestLoot: bestLoot ?? this.bestLoot,
    );
  }
}

final variableRewardProvider = StateNotifierProvider<VariableRewardNotifier, LootBoxState>((ref) {
  final db = ref.watch(databaseProvider);
  return VariableRewardNotifier(db);
});



class VariableRewardNotifier extends StateNotifier<LootBoxState> {
  final AppDatabase _db;
  final Random _random = Random();

  VariableRewardNotifier(this._db) : super(LootBoxState()) {
    _loadStats();
  }

  Future<void> _loadStats() async {
    final results = await _db.select(_db.lootBoxResults).get();
    int total = results.length;
    String best = 'Немає';
    
    int highestRank = -1;
    final rankMap = {
      'mythic': 4,
      'legendary': 3,
      'epic': 2,
      'rare': 1,
      'common': 0,
    };

    for (final r in results) {
      final rank = rankMap[r.tier] ?? 0;
      if (rank > highestRank) {
        highestRank = rank;
        best = r.tier.toUpperCase();
      }
    }

    state = state.copyWith(totalOpened: total, bestLoot: best);
  }

  Future<void> openLootBox() async {
    if (state.isOpening) return;
    
    state = state.copyWith(isOpening: true, lastResult: null);
    
    // Simulate animation delay
    await Future.delayed(const Duration(seconds: 3));

    // Determine tier
    final double chance = _random.nextDouble();
    String tier = 'common';
    int xp = 50;
    String rewardType = 'xp_multiplier';

    if (chance < 0.001) {
      tier = 'mythic';
      xp = 1000;
      rewardType = 'cosmetic';
    } else if (chance < 0.011) { // 1% for legendary
      tier = 'legendary';
      xp = 500;
      rewardType = 'streak_freeze';
    } else if (chance < 0.061) { // 5% for epic
      tier = 'epic';
      xp = 250;
      rewardType = 'xp_multiplier';
    } else if (chance < 0.261) { // 20% for rare
      tier = 'rare';
      xp = 100;
      rewardType = 'streak_freeze';
    } else { // common
      tier = 'common';
      xp = 20;
      rewardType = 'xp_multiplier';
    }

    // Save to DB
    final resultId = await _db.into(_db.lootBoxResults).insert(
      LootBoxResultsCompanion.insert(
        tier: tier,
        xpReward: xp,
        rewardType: rewardType,
        openedAt: DateTime.now(),
      )
    );

    final result = await (_db.select(_db.lootBoxResults)..where((t) => t.id.equals(resultId))).getSingle();

    await _loadStats();
    state = state.copyWith(isOpening: false, lastResult: result);
  }

  void reset() {
    state = state.copyWith(lastResult: null);
  }
}
