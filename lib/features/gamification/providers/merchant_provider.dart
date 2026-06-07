import 'dart:math';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/providers.dart';
import '../../../data/database.dart';
import '../../../data/settings_service.dart';

class MerchantState {
  final bool isActive;
  final Duration timeRemaining;
  final int targetAmount;
  final String reward;

  MerchantState({
    required this.isActive,
    required this.timeRemaining,
    required this.targetAmount,
    required this.reward,
  });

  MerchantState copyWith({
    bool? isActive,
    Duration? timeRemaining,
    int? targetAmount,
    String? reward,
  }) {
    return MerchantState(
      isActive: isActive ?? this.isActive,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      targetAmount: targetAmount ?? this.targetAmount,
      reward: reward ?? this.reward,
    );
  }
}

final merchantProvider = StateNotifierProvider<MerchantNotifier, MerchantState>((ref) {
  final settings = ref.watch(settingsServiceProvider);
  final db = ref.watch(databaseProvider);
  return MerchantNotifier(settings, db);
});

class MerchantNotifier extends StateNotifier<MerchantState> {
  final SettingsService _settings;
  final AppDatabase _db;
  Timer? _timer;
  bool _isGenerating = false;

  MerchantNotifier(this._settings, this._db)
      : super(MerchantState(
          isActive: false,
          timeRemaining: Duration.zero,
          targetAmount: 0,
          reward: '',
        )) {
    _init();
  }

  void _init() {
    _checkSpawn();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _checkSpawn();
    });
  }

  Future<void> _checkSpawn() async {
    if (_isGenerating) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final nextSpawn = _settings.merchantNextSpawnTime;
    final duration = _settings.merchantSpawnDuration;

    // If never initialized or the window is in the past and expired
    if (nextSpawn == 0 || now > (nextSpawn + duration)) {
      await _generateNewSpawn(now);
      return;
    }

    // Active window
    if (now >= nextSpawn && now <= (nextSpawn + duration)) {
      final remaining = Duration(milliseconds: nextSpawn + duration - now);
      if (!state.isActive || state.timeRemaining.inSeconds != remaining.inSeconds) {
        state = state.copyWith(
          isActive: true,
          timeRemaining: remaining,
          targetAmount: _settings.merchantContractTargetAmount,
          reward: _settings.merchantContractReward,
        );
      }
    } else {
      // Waiting for next spawn
      if (state.isActive) {
        state = state.copyWith(isActive: false, timeRemaining: Duration.zero);
      }
    }
  }

  Future<void> _generateNewSpawn(int now) async {
    _isGenerating = true;
    try {
      final random = Random();
      
      // Delay: 8 to 20 hours (ensures 1-2 times a day)
      final delayMs = (8 + random.nextInt(12)) * 60 * 60 * 1000;
      
      // Duration: 2 to 3 hours
      final durationMs = (2 + random.nextInt(2)) * 60 * 60 * 1000;

      _settings.merchantNextSpawnTime = now + delayMs;
      _settings.merchantSpawnDuration = durationMs;

      // Calculate target based on average deposit
      final deposits = await _db.getAllDeposits();
      int avg = 5000; // Default 50 UAH (minor units)
      if (deposits.isNotEmpty) {
        final total = deposits.fold<int>(0, (sum, d) => sum + d.amount);
        avg = total ~/ deposits.length;
      }
      
      // Target is 50% to 150% of average
      final multiplier = 0.5 + random.nextDouble();
      int target = (avg * multiplier).toInt();
      if (target < 1000) target = 1000; // Minimum 10 UAH

      _settings.merchantContractTargetAmount = target;

      // Reward
      final rewards = ['x2_xp', 'lootbox'];
      _settings.merchantContractReward = rewards[random.nextInt(rewards.length)];
      
      // Turn off active state until time comes
      state = state.copyWith(isActive: false, timeRemaining: Duration.zero);
    } finally {
      _isGenerating = false;
    }
  }

  void dismissContract() {
    // End the window early
    _settings.merchantNextSpawnTime = 0;
    _checkSpawn();
  }

  void fulfillContract() {
    // Mark completed or end the window
    _settings.merchantNextSpawnTime = 0;
    _checkSpawn();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
