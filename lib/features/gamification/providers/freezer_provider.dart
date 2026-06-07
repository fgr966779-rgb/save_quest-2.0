import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/settings_service.dart';
import '../../../core/providers/providers.dart';

class FreezerState {
  final bool isLocked;
  final int lockedAmount; // in kopecks
  final int unlockTime; // epoch ms
  final String itemName;
  final int durationHours;
  final Duration timeRemaining;

  FreezerState({
    required this.isLocked,
    required this.lockedAmount,
    required this.unlockTime,
    required this.itemName,
    required this.durationHours,
    required this.timeRemaining,
  });

  FreezerState copyWith({
    bool? isLocked,
    int? lockedAmount,
    int? unlockTime,
    String? itemName,
    int? durationHours,
    Duration? timeRemaining,
  }) {
    return FreezerState(
      isLocked: isLocked ?? this.isLocked,
      lockedAmount: lockedAmount ?? this.lockedAmount,
      unlockTime: unlockTime ?? this.unlockTime,
      itemName: itemName ?? this.itemName,
      durationHours: durationHours ?? this.durationHours,
      timeRemaining: timeRemaining ?? this.timeRemaining,
    );
  }
}

class FreezerNotifier extends StateNotifier<FreezerState> {
  final SettingsService _settings;
  final Ref _ref;
  Timer? _timer;

  FreezerNotifier(this._settings, this._ref)
      : super(FreezerState(
          isLocked: false,
          lockedAmount: 0,
          unlockTime: 0,
          itemName: '',
          durationHours: 24,
          timeRemaining: Duration.zero,
        )) {
    _loadFromSettings();
  }

  void _loadFromSettings() {
    final amount = _settings.freezerLockedAmount;
    final unlock = _settings.freezerUnlockTime;
    final name = _settings.freezerItemName;
    final hours = _settings.freezerDurationHours;

    final now = DateTime.now().millisecondsSinceEpoch;
    final bool _ = amount > 0 && unlock > now; // active flag (unused but kept for clarity)

    Duration remaining = Duration.zero;
    if (amount > 0) {
      final diff = unlock - DateTime.now().millisecondsSinceEpoch;
      remaining = Duration(milliseconds: diff > 0 ? diff : 0);
    }

    state = FreezerState(
      isLocked: amount > 0,
      lockedAmount: amount,
      unlockTime: unlock,
      itemName: name,
      durationHours: hours,
      timeRemaining: remaining,
    );

    if (amount > 0 && remaining.inMilliseconds > 0) {
      _startTickTimer();
    }
  }

  void _startTickTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final diff = state.unlockTime - now;
      if (diff <= 0) {
        t.cancel();
        state = state.copyWith(timeRemaining: Duration.zero);
      } else {
        state = state.copyWith(timeRemaining: Duration(milliseconds: diff));
      }
    });
  }

  Future<void> lockImpulse({
    required double amountUah,
    required String itemName,
    required int durationHours,
  }) async {
    final amountCents = (amountUah * 100).round();
    final unlockTimestamp = DateTime.now()
        .add(Duration(hours: durationHours))
        .millisecondsSinceEpoch;

    _settings.freezerLockedAmount = amountCents;
    _settings.freezerUnlockTime = unlockTimestamp;
    _settings.freezerItemName = itemName;
    _settings.freezerDurationHours = durationHours;

    state = FreezerState(
      isLocked: true,
      lockedAmount: amountCents,
      unlockTime: unlockTimestamp,
      itemName: itemName,
      durationHours: durationHours,
      timeRemaining: Duration(hours: durationHours),
    );

    _startTickTimer();
  }

  /// Resolve impulse by saving it in the vault
  Future<void> unfreezeAndSave() async {
    _timer?.cancel();
    final amountCents = state.lockedAmount;

    // Split equally into Goal A and Goal B (50% / 50%)
        // amountGoalB is implicit: createDeposit splits 50%/50% via goalAPercent: 50.0

    final db = _ref.read(databaseProvider);
    final activeEvent = _ref.read(eventsProvider);

    // Perform deposit with gamification gains (Standard flow context gives +150 XP bonus as a willpower reward)
    await _ref.read(savingsNotifierProvider.notifier).createDeposit(
          amount: amountCents / 100.0,
          goalAPercent: 50.0,
          note: 'Кріо-Сейв: ${state.itemName}',
          activeEvent: activeEvent,
          context: ActionContext.standard,
        );

    // Also manually grant extra willpower bonus XP (+150 XP) if user profile exists
    final profile = await db.getUserProfile();
    if (profile != null) {
      await db.insertUserProfile(profile.copyWith(
        xp: profile.xp + 150,
      ));
      // ignore: unused_result
      _ref.refresh(userProfileProvider);
    }

    _clearFreezer();
  }

  /// Resolve impulse by breaking the freeze and buying the item anyway
  void unfreezeAndBuy() {
    _timer?.cancel();
    _clearFreezer();
  }

  /// Cheat / Debug hook to fast forward the countdown timer to 5 seconds
  void debugFastForward() {
    if (!state.isLocked) return;
    final newUnlockTime = DateTime.now().add(const Duration(seconds: 5)).millisecondsSinceEpoch;
    _settings.freezerUnlockTime = newUnlockTime;
    state = state.copyWith(
      unlockTime: newUnlockTime,
      timeRemaining: const Duration(seconds: 5),
    );
    _startTickTimer();
  }

  void _clearFreezer() {
    _settings.freezerLockedAmount = 0;
    _settings.freezerUnlockTime = 0;
    _settings.freezerItemName = '';
    _settings.freezerDurationHours = 24;

    state = FreezerState(
      isLocked: false,
      lockedAmount: 0,
      unlockTime: 0,
      itemName: '',
      durationHours: 24,
      timeRemaining: Duration.zero,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final freezerProvider = StateNotifierProvider<FreezerNotifier, FreezerState>((ref) {
  final settings = ref.watch(settingsServiceProvider);
  return FreezerNotifier(settings, ref);
});
