import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import '../../data/settings_service.dart';

export 'savings_notifier.dart';
export 'penalty_notifier.dart';
export 'events_notifier.dart';

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

