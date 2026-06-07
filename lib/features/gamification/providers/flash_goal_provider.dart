import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/providers.dart';
import '../../../data/database.dart';
import '../../../data/settings_service.dart';

class FlashGoalState {
  final int targetAmount;
  final int currentAmount;
  final bool isCompleted;

  FlashGoalState({
    required this.targetAmount,
    required this.currentAmount,
    required this.isCompleted,
  });

  FlashGoalState copyWith({
    int? targetAmount,
    int? currentAmount,
    bool? isCompleted,
  }) {
    return FlashGoalState(
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

final flashGoalProvider = StateNotifierProvider<FlashGoalNotifier, FlashGoalState>((ref) {
  final settings = ref.watch(settingsServiceProvider);
  final db = ref.watch(databaseProvider);
  return FlashGoalNotifier(settings, db);
});

class FlashGoalNotifier extends StateNotifier<FlashGoalState> {
  final SettingsService _settings;
  final AppDatabase _db;

  FlashGoalNotifier(this._settings, this._db)
      : super(FlashGoalState(
          targetAmount: _settings.flashGoalTargetAmount,
          currentAmount: _settings.flashGoalCurrentAmount,
          isCompleted: _settings.flashGoalIsCompleted,
        )) {
    _init();
  }

  Future<void> _init() async {
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    if (_settings.flashGoalDate != todayStr) {
      await _generateNewGoal(todayStr);
    }
  }

  Future<void> _generateNewGoal(String todayStr) async {
    final deposits = await _db.getAllDeposits();
    int avg = 5000; // Default 50 UAH (minor units)
    if (deposits.isNotEmpty) {
      final total = deposits.fold<int>(0, (sum, d) => sum + d.amount);
      if (total > 0) {
        avg = total ~/ deposits.length;
      }
    }
    
    if (avg <= 0) avg = 5000;

    final random = Random();
    // Target is 30% to 80% of average deposit
    final multiplier = 0.3 + (random.nextDouble() * 0.5);
    int target = (avg * multiplier).toInt();
    if (target < 1000) target = 1000; // Minimum 10 UAH

    _settings.flashGoalDate = todayStr;
    _settings.flashGoalTargetAmount = target;
    _settings.flashGoalCurrentAmount = 0;
    _settings.flashGoalIsCompleted = false;

    state = FlashGoalState(
      targetAmount: target,
      currentAmount: 0,
      isCompleted: false,
    );
  }

  void addProgress(int amount) {
    if (state.isCompleted) return;

    final newCurrent = state.currentAmount + amount;
    bool isCompleted = false;
    
    if (newCurrent >= state.targetAmount) {
      isCompleted = true;
    }

    _settings.flashGoalCurrentAmount = newCurrent;
    _settings.flashGoalIsCompleted = isCompleted;

    state = state.copyWith(
      currentAmount: newCurrent,
      isCompleted: isCompleted,
    );
  }

  // Debug utility to simulate a new day
  Future<void> resetForTesting() async {
    _settings.flashGoalDate = '1970-01-01';
    await _init();
  }
}
