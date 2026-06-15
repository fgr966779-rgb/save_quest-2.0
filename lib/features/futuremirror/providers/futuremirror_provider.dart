import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/database.dart';

class FutureMirrorState {
  final int monthsForward;
  final int projectedAmount;
  final String aiMessage;
  final bool isLoading;

  FutureMirrorState({
    this.monthsForward = 3,
    this.projectedAmount = 0,
    this.aiMessage = '',
    this.isLoading = false,
  });

  FutureMirrorState copyWith({
    int? monthsForward,
    int? projectedAmount,
    String? aiMessage,
    bool? isLoading,
  }) {
    return FutureMirrorState(
      monthsForward: monthsForward ?? this.monthsForward,
      projectedAmount: projectedAmount ?? this.projectedAmount,
      aiMessage: aiMessage ?? this.aiMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final futureMirrorProvider = StateNotifierProvider<FutureMirrorNotifier, FutureMirrorState>((ref) {
  final db = ref.watch(databaseProvider);
  return FutureMirrorNotifier(db);
});

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

class FutureMirrorNotifier extends StateNotifier<FutureMirrorState> {
  final AppDatabase _db;

  FutureMirrorNotifier(this._db) : super(FutureMirrorState()) {
    _calculateProjection(state.monthsForward);
  }

  void setMonthsForward(int months) {
    if (state.monthsForward == months) return;
    _calculateProjection(months);
  }

  Future<void> _calculateProjection(int months) async {
    state = state.copyWith(isLoading: true, monthsForward: months);
    try {
      // Mock calculation based on user's current goal progress.
      // E.g. find total saved and average monthly deposit to calculate future.
      final goals = await _db.select(_db.goals).get();
      int totalSaved = 0;
      for (final goal in goals) {
        totalSaved += goal.currentAmount;
      }

      // Mock avg monthly deposit (e.g. 1000 UAH)
      const avgMonthlyDepositKopecks = 100000;
      final projected = totalSaved + (avgMonthlyDepositKopecks * months);
      
      final message = _getMockAiMessage(months);

      state = state.copyWith(
        projectedAmount: projected,
        aiMessage: message,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  String _getMockAiMessage(int months) {
    if (months <= 3) return 'Твій аватар отримує перший заряд енергії. Продовжуй депозити, щоб закріпити ауру!';
    if (months <= 6) return 'Половина шляху. Твоя фінансова броня міцніє, а шкідливі звички не мають шансів.';
    if (months <= 12) return 'Рік стабільності! Ти перетворився на майстра заощаджень. Твоє майбутнє захищене.';
    return 'ЛЕГЕНДА! Твоя фінансова міць досягла максимуму. Ця проєкція – твоя реальність, якщо не здашся.';
  }
}
