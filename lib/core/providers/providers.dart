import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import '../../data/settings_service.dart';

export 'savings_notifier.dart';
export 'penalty_notifier.dart';
export 'events_notifier.dart';
export 'zen_mode_provider.dart';
export '../../features/gamification/providers/lending_provider.dart';
export '../../features/gamification/providers/gift_fund_provider.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProvider was not overridden');
});

final settingsServiceProvider = Provider<SettingsService>((ref) {
  throw UnimplementedError('settingsServiceProvider was not overridden');
});

final goalsProvider = StreamProvider<List<Goal>>((ref) {
  return ref.watch(databaseProvider).watchAllGoals();
});

final depositsProvider = StreamProvider<List<Deposit>>((ref) {
  return ref.watch(databaseProvider).watchAllDeposits();
});

class DepositBreakdown {
  final Deposit deposit;
  final Map<String, int> allocationsByGoalId;

  const DepositBreakdown({
    required this.deposit,
    required this.allocationsByGoalId,
  });

  int amountForGoal(String goalId) => allocationsByGoalId[goalId] ?? 0;

  int get goalAAmount => amountForGoal('goal_a');

  int get goalBAmount => amountForGoal('goal_b');
}

final depositsBreakdownProvider = StreamProvider<List<DepositBreakdown>>((ref) async* {
  final db = ref.watch(databaseProvider);

  await for (final deposits in db.watchAllDeposits()) {
    final allocations = await db.select(db.depositAllocations).get();
    final allocationsByDeposit = <String, Map<String, int>>{};

    for (final allocation in allocations) {
      final perDeposit = allocationsByDeposit.putIfAbsent(
        allocation.depositId,
        () => <String, int>{},
      );
      perDeposit[allocation.goalId] =
          (perDeposit[allocation.goalId] ?? 0) + allocation.amount;
    }

    yield deposits
        .map(
          (deposit) => DepositBreakdown(
            deposit: deposit,
            allocationsByGoalId:
                allocationsByDeposit[deposit.id] ?? const <String, int>{},
          ),
        )
        .toList();
  }
});

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  return ref.watch(databaseProvider).watchUserProfile();
});

final unlockedAchievementsProvider = StreamProvider<List<UnlockedAchievement>>((ref) {
  return ref.watch(databaseProvider).watchUnlockedAchievements();
});

final unlockedSkillsProvider = StreamProvider<List<UnlockedSkill>>((ref) {
  return ref.watch(databaseProvider).watchUnlockedSkills();
});

// Onboarding Setup State Providers
// Default target amounts stored as display values (UAH).
// They are converted to kopecks (×100) when written to the DB in SetupFinishScreen.
final onboardingGoalATitleProvider = StateProvider<String>((ref) => 'PlayStation 5');
final onboardingGoalATargetProvider = StateProvider<double>((ref) => 25000.0);
final onboardingGoalACurrencyProvider = StateProvider<String>((ref) => '₴');

final onboardingGoalBTitleProvider = StateProvider<String>((ref) => 'Ігровий Монітор');
final onboardingGoalBTargetProvider = StateProvider<double>((ref) => 15000.0);
final onboardingGoalBCurrencyProvider = StateProvider<String>((ref) => '₴');

final onboardingGoalASplitProvider = StateProvider<double>((ref) => 0.5); // 50% / 50% split default

