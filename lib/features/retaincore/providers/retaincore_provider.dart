import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/database.dart';

enum RiskLevel { low, medium, high, critical }

class RetainCoreState {
  final RiskLevel riskLevel;
  final int daysSinceDeposit;
  final String aiMessage;
  final bool isLoading;

  RetainCoreState({
    required this.riskLevel,
    required this.daysSinceDeposit,
    this.aiMessage = '',
    this.isLoading = false,
  });

  RetainCoreState copyWith({
    RiskLevel? riskLevel,
    int? daysSinceDeposit,
    String? aiMessage,
    bool? isLoading,
  }) {
    return RetainCoreState(
      riskLevel: riskLevel ?? this.riskLevel,
      daysSinceDeposit: daysSinceDeposit ?? this.daysSinceDeposit,
      aiMessage: aiMessage ?? this.aiMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final retainCoreProvider = StateNotifierProvider<RetainCoreNotifier, RetainCoreState>((ref) {
  final db = ref.watch(databaseProvider);
  return RetainCoreNotifier(db);
});

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

class RetainCoreNotifier extends StateNotifier<RetainCoreState> {
  final AppDatabase _db;

  RetainCoreNotifier(this._db)
      : super(RetainCoreState(riskLevel: RiskLevel.low, daysSinceDeposit: 0)) {
    _calculateRisk();
  }

  Future<void> _calculateRisk() async {
    state = state.copyWith(isLoading: true);

    try {
      final profile = await _db.select(_db.userProfiles).getSingleOrNull();
      if (profile == null) {
        state = state.copyWith(riskLevel: RiskLevel.low, daysSinceDeposit: 0, isLoading: false);
        return;
      }

      int daysSinceDeposit = 0;
      if (profile.lastDepositDate != null) {
        daysSinceDeposit = DateTime.now().difference(profile.lastDepositDate!).inDays;
      }

      int currentStreak = profile.streakCount;
      // Mock previous streak or amount trend for now
      int previousStreak = 0;
      double amountTrend = 0.0;
      bool streakBroken = currentStreak == 0 && profile.lastDepositDate != null && daysSinceDeposit > 1;

      RiskLevel level = RiskLevel.low;

      if (daysSinceDeposit > 7 || (currentStreak == 0 && previousStreak > 14)) {
        level = RiskLevel.critical;
      } else if (daysSinceDeposit > 3 || amountTrend < -0.30) {
        level = RiskLevel.high;
      } else if (daysSinceDeposit > 1 || streakBroken) {
        level = RiskLevel.medium;
      }

      String message = _getMockAiMessage(level);

      state = state.copyWith(
        riskLevel: level,
        daysSinceDeposit: daysSinceDeposit,
        aiMessage: message,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  String _getMockAiMessage(RiskLevel level) {
    switch (level) {
      case RiskLevel.critical:
        return 'СИСТЕМА ФІКСУЄ КРИТИЧНИЙ ВІДТІК. Ви не зберігали більше 7 днів. Ваш фінансовий аватар помирає. Зробіть екстрений депозит зараз.';
      case RiskLevel.high:
        return 'ВИСОКИЙ РИЗИК. Дисципліна падає. Відновіть темп, щоб не втратити прогрес.';
      case RiskLevel.medium:
        return 'ПОПЕРЕДЖЕННЯ. Стрік під загрозою або минув день без депозиту. Зробіть невеликий внесок.';
      case RiskLevel.low:
        return 'ВСЕ В НОРМІ. Ви підтримуєте відмінний темп збережень.';
    }
  }
}
