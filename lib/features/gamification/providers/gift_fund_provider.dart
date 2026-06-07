import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../data/database.dart';
import '../../../core/services/gamification/xp_service.dart';
import '../../../core/providers/providers.dart';

class GiftFundState {
  final List<GiftGoal> items;
  final bool isLoading;
  final Object? error;

  const GiftFundState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  GiftFundState copyWith({
    List<GiftGoal>? items,
    bool? isLoading,
    Object? error,
  }) =>
      GiftFundState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}

class GiftFundNotifier extends StateNotifier<AsyncValue<GiftFundState>> {
  final AppDatabase _db;

  GiftFundNotifier(this._db) : super(const AsyncValue.loading()) {
    _load();
    _db.watchAllGiftGoals().listen((list) {
      state = AsyncValue.data(GiftFundState(items: list));
    });
  }

  Future<void> _load() async {
    try {
      final list = await _db.getAllGiftGoals();
      state = AsyncValue.data(GiftFundState(items: list));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createGiftGoal(GiftGoalsCompanion data, Goal parentGoal) async {
    try {
      final now = DateTime.now();
      final companion = data.copyWith(
        id: Value('gift_${now.millisecondsSinceEpoch}_${_random4()}'),
        createdAt: Value(now),
        updatedAt: Value(now),
      );
      await _db.into(_db.giftGoals).insert(companion);
      await _awardXp('gift_created');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateGiftGoal(GiftGoal existing, GiftGoalsCompanion data) async {
    try {
      final companion = data.copyWith(
        id: Value(existing.id),
        updatedAt: Value(DateTime.now()),
      );
      await _db.update(_db.giftGoals).replace(companion);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteGiftGoal(String id) async {
    try {
      await (_db.delete(_db.giftGoals)..where((t) => t.id.equals(id))).go();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> onDepositCreated({
    required int depositAmountKopecks,
    required String goalId,
    required bool hasActiveStreak,
  }) async {
    try {
      final giftGoal = await _db.getGiftGoalByGoalId(goalId);
      if (giftGoal == null) return;

      final goal = await _db.getGoalById(goalId);
      if (goal == null || goal.targetAmount <= 0) return;

      final progress = goal.currentAmount / goal.targetAmount;
      if (progress >= 0.5) {
        await _awardXp('gift_progress_50', hasActiveStreak: hasActiveStreak);
      }
    } catch (_) {}
  }

  Future<void> onGoalCompleted(String goalId) async {
    try {
      final giftGoal = await _db.getGiftGoalByGoalId(goalId);
      if (giftGoal == null) return;
      await _awardXp('gift_completed');
    } catch (_) {}
  }

  Future<void> _awardXp(String event, {bool hasActiveStreak = false}) async {
    final profile = await _db.getUserProfile();
    if (profile == null) return;

    int baseXp = switch (event) {
      'gift_created' => 5,
      'gift_progress_50' => 15,
      'gift_completed' => 30,
      _ => 0,
    };

    final multiplier = hasActiveStreak ? 1.5 : 1.0;
    final xp = XpService.calculateXpGained(
      baseAmount: baseXp,
      multiplier: multiplier,
      playerClass: profile.playerClass,
    );

    await _db.updateUserProfile(profile.copyWith(xp: profile.xp + xp));
  }

  static int _random4() => DateTime.now().microsecond % 10000;
}

final giftFundProvider =
    StateNotifierProvider<GiftFundNotifier, AsyncValue<GiftFundState>>((ref) {
  final db = ref.watch(databaseProvider);
  return GiftFundNotifier(db);
});
