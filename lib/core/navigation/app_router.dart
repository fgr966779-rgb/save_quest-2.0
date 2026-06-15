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

import '../../features/gamification/screens/freezer_screen.dart';
import '../../features/gamification/screens/gift_fund_screen.dart';
import '../../features/gamification/screens/gift_goal_setup_screen.dart';
import '../../features/dashboard/screens/goal_complete_screen.dart';
import '../../features/dashboard/screens/savings_calculator_screen.dart';
import '../../features/gamification/screens/weekly_challenges_screen.dart';
import '../../features/gamification/screens/savings_stats_screen.dart';
import '../../features/subscriptions/screens/subscriptions_screen.dart';
import '../../features/gamification/screens/oracle_screen.dart';
import '../../features/dashboard/screens/annual_report_screen.dart';
import '../../features/dashboard/screens/investment_market_screen.dart';
import '../../features/necrospend/screens/savings_graveyard_screen.dart';
import '../../features/retaincore/screens/anti_churn_screen.dart';
import '../../features/futuremirror/screens/future_self_screen.dart';
import '../../features/lootbox/screens/variable_reward_screen.dart';
import '../../features/banklink/screens/bank_sync_screen.dart';
import '../../features/phase2/screens/reputation_forge_screen.dart';
import '../../features/phase2/screens/flash_mob_screen.dart';
import '../../features/phase2/screens/choice_paradox_screen.dart';
import '../../features/phase2/screens/nudge_lab_screen.dart';
import '../../features/phase2/screens/trophy_gallery_screen.dart';
import '../../features/phase2/screens/news_radar_screen.dart';
import '../../features/phase2/screens/price_oracle_screen.dart';
import '../../features/phase2/screens/receipt_scanner_screen.dart';
import '../../features/phase2/screens/cyber_pet_screen.dart';
import '../../features/phase2/screens/budget_dna_screen.dart';
import '../../features/phase3/screens/voice_vault_screen.dart';
import '../../features/phase3/screens/biometric_vault_screen.dart';
import '../../features/phase3/screens/crowd_fund_screen.dart';
import '../../features/phase3/screens/ar_price_tag_screen.dart';
import '../../features/phase3/screens/soundscapes_screen.dart';
import '../../features/phase3/screens/price_shark_screen.dart';
import '../../features/phase3/screens/price_roulette_screen.dart';
import '../../features/phase3/screens/price_match_screen.dart';
import '../../features/phase3/screens/preorder_guard_screen.dart';
import '../../features/phase3/screens/loyalty_cruncher_screen.dart';
import '../../features/phase3/screens/price_freeze_screen.dart';
import '../../features/phase3/screens/wishlist_radar_screen.dart';
import '../../features/phase3/screens/smart_alerts_screen.dart';
import '../../features/phase3/screens/price_arena_screen.dart';
import '../../features/phase3/screens/price_prophet_screen.dart';
import '../../features/phase4/screens/secondhand_analyzer_screen.dart';
import '../../features/phase4/screens/seasonal_calendar_screen.dart';
import '../../features/phase4/screens/price_momentum_screen.dart';
import '../../features/phase4/screens/price_war_screen.dart';
import '../../features/phase4/screens/haggling_coach_screen.dart';
import '../../features/phase4/screens/price_elasticity_screen.dart';
import '../../features/phase4/screens/inventory_stalker_screen.dart';
import '../../features/phase4/screens/lending_tracker_screen.dart';
import '../../features/phase4/screens/goal_price_integrator_screen.dart';
import '../../features/phase4/screens/habit_loop_forge_screen.dart';
import '../../features/phase4/screens/inflation_shield_screen.dart';
import '../../features/phase4/screens/price_detective_screen.dart';
import '../../features/phase4/screens/wishlist_link_ripper_screen.dart';
import '../../features/phase4/screens/showroom_shield_screen.dart';
import '../../features/phase4/screens/time_machine_screen.dart';
import '../../features/phase4/screens/quest_chain_screen.dart';
import '../../features/phase4/screens/sage_coach_screen.dart';
import '../../features/phase4/screens/infla_wall_screen.dart';

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

      // Block gamification triggers during active Dopamine Detox
      final detoxBlockedRoutes = [
        '/market',
        '/customization',
        '/avatar-builder',
        '/lootboxes',
        '/skill-tree',
      ];
      final isBlocked = detoxBlockedRoutes.any((route) => state.uri.path.startsWith(route));
      if (settings.isDopamineDetoxActive && isBlocked) {
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
            path: '/gift-fund',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: GiftFundScreen(),
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
          final goalId = state.pathParameters['goalId'] ?? 'goal_a';
          return GoalDetailScreen.fromString(id: goalId);
        },
      ),
      GoRoute(
        path: '/oracle',
        builder: (context, state) => const OracleScreen(),
      ),
      GoRoute(
        path: '/annual-report',
        builder: (context, state) => const AnnualReportScreen(),
      ),
      GoRoute(
        path: '/investment-market',
        builder: (context, state) => const InvestmentMarketScreen(),
      ),
      GoRoute(
        path: '/gift-goal-setup',
        builder: (context, state) => const GiftGoalSetupScreen(),
      ),
      GoRoute(
        path: '/freezer',
        builder: (context, state) => const FreezerScreen(),
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
        path: '/subscriptions',
        builder: (context, state) => const SubscriptionsScreen(),
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
      GoRoute(
        path: '/graveyard',
        builder: (context, state) => const SavingsGraveyardScreen(),
      ),
      GoRoute(
        path: '/anti-churn',
        builder: (context, state) => const AntiChurnScreen(),
      ),
      GoRoute(
        path: '/future-self',
        builder: (context, state) => const FutureSelfScreen(),
      ),
      GoRoute(
        path: '/variable-reward',
        builder: (context, state) => const VariableRewardScreen(),
      ),
      GoRoute(
        path: '/bank-sync',
        builder: (context, state) => const BankSyncScreen(),
      ),
      GoRoute(path: '/reputation-forge', builder: (context, state) => const ReputationForgeScreen()),
      GoRoute(path: '/flash-mob', builder: (context, state) => const FlashMobScreen()),
      GoRoute(path: '/choice-paradox', builder: (context, state) => const ChoiceParadoxScreen()),
      GoRoute(path: '/nudge-lab', builder: (context, state) => const NudgeLabScreen()),
      GoRoute(path: '/trophy-gallery', builder: (context, state) => const TrophyGalleryScreen()),
      GoRoute(path: '/news-radar', builder: (context, state) => const NewsRadarScreen()),
      GoRoute(path: '/price-oracle', builder: (context, state) => const PriceOracleScreen()),
      GoRoute(path: '/receipt-scanner', builder: (context, state) => const ReceiptScannerScreen()),
      GoRoute(path: '/cyber-pet', builder: (context, state) => const CyberPetScreen()),
      GoRoute(path: '/budget-dna', builder: (context, state) => const BudgetDNAScreen()),
      GoRoute(path: '/voice-vault', builder: (context, state) => const VoiceVaultScreen()),
      GoRoute(path: '/biometric-vault', builder: (context, state) => const BiometricVaultScreen()),
      GoRoute(path: '/crowd-fund', builder: (context, state) => const CrowdFundScreen()),
      GoRoute(path: '/ar-price-tag', builder: (context, state) => const ARPriceTagScreen()),
      GoRoute(path: '/soundscapes', builder: (context, state) => const SoundscapesScreen()),
      GoRoute(path: '/price-shark', builder: (context, state) => const PriceSharkScreen()),
      GoRoute(path: '/price-roulette', builder: (context, state) => const PriceRouletteScreen()),
      GoRoute(path: '/price-match', builder: (context, state) => const PriceMatchScreen()),
      GoRoute(path: '/preorder-guard', builder: (context, state) => const PreOrderGuardScreen()),
      GoRoute(path: '/loyalty-cruncher', builder: (context, state) => const LoyaltyCruncherScreen()),
      GoRoute(path: '/price-freeze', builder: (context, state) => const PriceFreezeScreen()),
      GoRoute(path: '/wishlist-radar', builder: (context, state) => const WishlistRadarScreen()),
      GoRoute(path: '/smart-alerts', builder: (context, state) => const SmartAlertsScreen()),
      GoRoute(path: '/price-arena', builder: (context, state) => const PriceArenaScreen()),
      GoRoute(path: '/price-prophet', builder: (context, state) => const PriceProphetScreen()),
      GoRoute(path: '/secondhand-analyzer', builder: (context, state) => const SecondhandAnalyzerScreen()),
      GoRoute(path: '/seasonal-calendar', builder: (context, state) => const SeasonalCalendarScreen()),
      GoRoute(path: '/price-momentum', builder: (context, state) => const PriceMomentumScreen()),
      GoRoute(path: '/price-war', builder: (context, state) => const PriceWarScreen()),
      GoRoute(path: '/haggling-coach', builder: (context, state) => const HagglingCoachScreen()),
      GoRoute(path: '/price-elasticity', builder: (context, state) => const PriceElasticityScreen()),
      GoRoute(path: '/inventory-stalker', builder: (context, state) => const InventoryStalkerScreen()),
      GoRoute(path: '/lending-tracker', builder: (context, state) => const LendingTrackerScreen()),
      GoRoute(path: '/goal-price-integrator', builder: (context, state) => const GoalPriceIntegratorScreen()),
      GoRoute(path: '/habit-loop-forge', builder: (context, state) => const HabitLoopForgeScreen()),
      GoRoute(path: '/inflation-shield', builder: (context, state) => const InflationShieldScreen()),
      GoRoute(path: '/price-detective', builder: (context, state) => const PriceDetectiveScreen()),
      GoRoute(path: '/wishlist-link-ripper', builder: (context, state) => const WishlistLinkRipperScreen()),
      GoRoute(path: '/showroom-shield', builder: (context, state) => const ShowroomShieldScreen()),
      GoRoute(path: '/time-machine', builder: (context, state) => const TimeMachineScreen()),
      GoRoute(path: '/quest-chain', builder: (context, state) => const QuestChainScreen()),
      GoRoute(path: '/sage-coach', builder: (context, state) => const SageCoachScreen()),
      GoRoute(path: '/infla-wall', builder: (context, state) => const InflaWallScreen()),
    ],
  );
});
