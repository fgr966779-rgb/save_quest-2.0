import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/providers/providers.dart';
import '../../../data/database.dart';
import '../services/price_pulse_service.dart';

class PriceHunterNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> setProductUrl(String goalId, String url, int initialPrice) async {
    final db = ref.read(databaseProvider);
    final goal = await db.getGoalById(goalId);
    if (goal == null) return;

    await db.updateGoal(goal.copyWith(
      productUrl: drift.Value(url),
      targetPrice: drift.Value(initialPrice),
      currentPrice: drift.Value(initialPrice),
      priceShieldHp: 100,
      lastPriceUpdate: drift.Value(DateTime.now()),
    ));
    
    // Invalidate goals provider so the UI updates
    ref.invalidate(goalsProvider);
  }

  Future<void> updateManualPrice(String goalId, int newPriceKopecks) async {
    final db = ref.read(databaseProvider);
    final goal = await db.getGoalById(goalId);
    if (goal == null) return;
    
    await db.insertPriceHistoryEntry(PriceHistoryEntriesCompanion.insert(
      goalId: goal.id,
      priceKopecks: newPriceKopecks,
      store: const drift.Value('Manual'),
      dataSource: const drift.Value('manual'),
      cachedAt: DateTime.now(),
    ));

    await db.updateGoal(goal.copyWith(
      currentPrice: drift.Value(newPriceKopecks),
      lastPriceUpdate: drift.Value(DateTime.now()),
    ));
    
    ref.invalidate(goalsProvider);
  }

  /// Wraps PricePulseService logic. Returns the PricePulseResult for the UI.
  Future<PricePulseResult?> updatePrice(String goalId, {bool forceManual = false}) async {
    final db = ref.read(databaseProvider);
    final service = ref.read(pricePulseServiceProvider);
    
    final goal = await db.getGoalById(goalId);
    if (goal == null || goal.productUrl == null) return null;

    final result = await service.updatePriceForGoal(goal, forceManual: forceManual);

    ref.invalidate(goalsProvider);
    if (result.xpAwarded > 0) {
      ref.invalidate(userProfileProvider);
    }
    
    return result;
  }

  Future<PriceTrendForecast?> getForecast(String goalId) async {
    final service = ref.read(pricePulseServiceProvider);
    return await service.getForecast(goalId);
  }

  Future<void> debugResetCache(String goalId) async {
    final service = ref.read(pricePulseServiceProvider);
    await service.debugResetCache(goalId);
    ref.invalidate(goalsProvider);
    ref.invalidate(userProfileProvider);
  }

  Future<void> debugSimulateCriticalHit(String goalId) async {
    final db = ref.read(databaseProvider);
    final service = ref.read(pricePulseServiceProvider);
    
    final goal = await db.getGoalById(goalId);
    if (goal == null) return;

    await service.debugSimulateCriticalHit(goal);
    ref.invalidate(goalsProvider);
    ref.invalidate(userProfileProvider);
  }
}

final priceHunterProvider = AsyncNotifierProvider<PriceHunterNotifier, void>(PriceHunterNotifier.new);
