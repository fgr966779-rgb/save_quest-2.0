import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/onboarding/screens/goal_a_setup_screen.dart';
import '../../features/onboarding/screens/goal_b_setup_screen.dart';
import '../../features/onboarding/screens/setup_finish_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/dashboard/screens/goal_detail_screen.dart';
import '../../features/deposit/screens/deposit_screen.dart';
import '../../features/deposit/screens/history_screen.dart';
import '../../features/deposit/screens/analytics_screen.dart';
import '../../features/gamification/screens/streak_room_screen.dart';
import '../../features/gamification/screens/trophy_room_screen.dart';
import '../../features/gamification/screens/penalty_vault_screen.dart';
import '../../features/gamification/screens/class_selection_screen.dart';
import '../../features/gamification/screens/lootbox_screen.dart';
import '../../features/gamification/screens/customization_screen.dart';
import '../../features/gamification/screens/avatar_builder_screen.dart';
import '../../features/gamification/screens/market_screen.dart';
import '../../features/gamification/screens/pets_screen.dart';
import '../../features/gamification/screens/squads_screen.dart';
import '../../features/gamification/screens/joint_goal_detail_screen.dart';
import '../../features/gamification/screens/leaderboard_screen.dart';
import '../../features/gamification/screens/skill_tree_screen.dart';
import '../../features/gamification/screens/blacklist_screen.dart';
import '../../features/gamification/screens/regret_archive_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/dashboard/screens/terminal_screen.dart';
import '../../features/dashboard/screens/price_analysis_screen.dart';
import '../../features/remote_control/screens/remote_control_screen.dart';
import '../../features/dashboard/screens/shell_scaffold.dart';
import '../../features/gamification/screens/notification_center_screen.dart';

import '../../features/dashboard/screens/goal_complete_screen.dart';
import '../../features/dashboard/screens/savings_calculator_screen.dart';
import '../../features/gamification/screens/weekly_challenges_screen.dart';
import '../../features/gamification/screens/savings_stats_screen.dart';
final routerProvider = Provider<GoRouter>((ref) {
  final settings = ref.watch(settingsServiceProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isSplash = state.uri.path == '/';
      final isOnboarding = state.uri.path.startsWith('/welcome') ||
          state.uri.path.startsWith('/onboarding');
      final completedOnboarding = settings.hasCompletedOnboarding;

      if (isSplash) return null; // Let the splash screen finish its animation

      if (!completedOnboarding && !isOnboarding) {
        return '/welcome';
      }

      if (completedOnboarding && isOnboarding) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      // Splash
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      // Onboarding
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding-a',
        builder: (context, state) => const GoalASetupScreen(),
      ),
      GoRoute(
        path: '/onboarding-b',
        builder: (context, state) => const GoalBSetupScreen(),
      ),
      GoRoute(
        path: '/onboarding-finish',
        builder: (context, state) => const SetupFinishScreen(),
      ),

      // Shell Route (Contains bottom navigation dock)
      ShellRoute(
        builder: (context, state, child) {
          return ShellScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/analytics',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AnalyticsScreen(),
            ),
          ),
          GoRoute(
            path: '/history',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HistoryScreen(),
            ),
          ),
          GoRoute(
            path: '/streak',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StreakRoomScreen(),
            ),
          ),
          GoRoute(
            path: '/trophies',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TrophyRoomScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),

      GoRoute(
        path: '/deposit',
        builder: (context, state) => const DepositScreen(),
      ),
      GoRoute(
        path: '/penalty-vault',
        builder: (context, state) => const PenaltyVaultScreen(),
      ),
      GoRoute(
        path: '/class-selection',
        builder: (context, state) => const ClassSelectionScreen(),
      ),
      GoRoute(
        path: '/lootboxes',
        builder: (context, state) => const LootboxScreen(),
      ),
      GoRoute(
        path: '/customization',
        builder: (context, state) => const CustomizationScreen(),
      ),
      GoRoute(
        path: '/avatar-builder',
        builder: (context, state) => const AvatarBuilderScreen(),
      ),
      GoRoute(
        path: '/market',
        builder: (context, state) => const MarketScreen(),
      ),
      GoRoute(
        path: '/pets',
        builder: (context, state) => const PetsScreen(),
      ),
      GoRoute(
        path: '/squads',
        builder: (context, state) => const SquadsScreen(),
      ),
      GoRoute(
        path: '/joint-goal/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return JointGoalDetailScreen(goalId: id);
        },
      ),
      GoRoute(
        path: '/leaderboards',
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/skill-tree',
        builder: (context, state) => const SkillTreeScreen(),
      ),
      GoRoute(
        path: '/blacklist',
        builder: (context, state) => const BlacklistScreen(),
      ),
      GoRoute(
        path: '/regret-archive',
        builder: (context, state) => const RegretArchiveScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationCenterScreen(),
      ),
      GoRoute(
        path: '/terminal',
        builder: (context, state) => const TerminalScreen(),
      ),
      GoRoute(
        path: '/remote-control',
        builder: (context, state) => const RemoteControlScreen(),
      ),
      GoRoute(
        path: '/price-analysis',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return PriceAnalysisScreen(
            initialQuery: extra['query'] as String?,
            targetAmountKopecks: extra['targetAmount'] as int?,
            currency: extra['currency'] as String?,
          );
        },
      ),
      GoRoute(
        path: '/goal-detail/:goalId',
        builder: (context, state) {
          final goalId = int.tryParse(state.pathParameters['goalId'] ?? '') ?? 0;
          return GoalDetailScreen(goalId: goalId);
        },
      ),
      GoRoute(
        path: '/savings-calculator',
        builder: (context, state) => const SavingsCalculatorScreen(),
      ),
      GoRoute(
        path: '/weekly-challenges',
        builder: (context, state) => const WeeklyChallengesScreen(),
      ),
      GoRoute(
        path: '/savings-stats',
        builder: (context, state) => const SavingsStatsScreen(),
      ),
      GoRoute(
        path: '/goal-complete',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final goalName = extra['goalName'] as String? ?? 'Назва';
          // targetAmount is stored in kopecks (int)
          final targetAmount = extra['targetAmount'] as int? ?? 0;
          final currency = extra['currency'] as String? ?? '\$';
          return GoalCompleteScreen(
            goalName: goalName,
            targetAmount: targetAmount,
            currency: currency,
          );
        },
      ),
    ],
  );
});
