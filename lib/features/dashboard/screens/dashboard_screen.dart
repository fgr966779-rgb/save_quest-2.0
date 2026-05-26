import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/savings_notifier.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/dual_progress_ring.dart';
import '../../../core/widgets/neon_avatar_painter.dart';
import '../../../core/widgets/financial_health_thermometer.dart';
import '../../../core/models/avatar_config.dart';
import '../../../core/providers/banking_provider.dart';
import '../../../core/providers/events_notifier.dart';
import '../../../core/providers/financial_health_provider.dart';

// New clean widgets (may be created in parallel — forward-import safe).
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../core/widgets/goal_card.dart';

// Existing feature widgets
import '../widgets/banking_insights_card.dart';
import '../../gamification/providers/bounty_provider.dart';
import '../../gamification/providers/quest_provider.dart';
import '../../gamification/providers/daily_bonus_provider.dart';
import '../../gamification/models/daily_quest.dart';
import '../../gamification/widgets/daily_spin_dialog.dart';
import '../../gamification/widgets/daily_bonus_dialog.dart';
import '../../gamification/widgets/shield_activation_dialog.dart';
import '../../../data/database.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // Listen for daily bonus / shield activation dialogs
    ref.listen<AsyncValue<DailyBonusState>>(dailyBonusProvider, (previous, next) {
      if (next is AsyncData<DailyBonusState>) {
        final state = next.value;
        if (state.shieldActivated && state.shieldDaysSaved > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ShieldActivationDialog.show(context, state.shieldDaysSaved);
            if (state.isBonusAvailable) {
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) DailyBonusDialog.show(context);
              });
            }
          });
        } else if (state.isBonusAvailable) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            DailyBonusDialog.show(context);
          });
        }
      }
    });

    final goalsAsync = ref.watch(goalsProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final currentLocale = ref.watch(localeProvider);
    final brightness = Theme.of(context).brightness;
    final settings = ref.watch(settingsServiceProvider);

    String t(String key) => AppLocalizations.get(currentLocale, key);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildAppBar(context, t),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 400));
        },
        color: AppColors.accent,
        backgroundColor: AppColors.surface(brightness),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spaceXl,
            vertical: AppTheme.spaceMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header: Avatar + Greeting + Level ──
              _buildHeader(context, profileAsync, brightness, t),
              const SizedBox(height: AppTheme.spaceXl),

              // ── Streak Banner ──
              _buildStreakBanner(profileAsync, brightness, t),
              const SizedBox(height: AppTheme.spaceLg),

              // ── Progress Rings ──
              _buildProgressRings(goalsAsync),
              const SizedBox(height: AppTheme.spaceLg),

              // ── Deposit CTA ──
              _buildDepositButton(context, t),
              const SizedBox(height: AppTheme.spaceXxl),

              // ── Goal Cards ──
              _buildGoalCards(context, ref, goalsAsync, settings),
              const SizedBox(height: AppTheme.spaceXl),

              // ── Daily Quests ──
              _buildDailyQuestsCard(ref, brightness),
              const SizedBox(height: AppTheme.spaceLg),

              // ── Quick Actions ──
              _buildQuickActions(context, t),
              const SizedBox(height: AppTheme.spaceLg),

              // ── Financial Health Thermometer ──
              _buildFinancialHealth(brightness),
              const SizedBox(height: AppTheme.spaceLg),

              // ── AI Insights ──
              const BankingInsightsCard(),
              const SizedBox(height: AppTheme.spaceLg),

              // ── Event Banner ──
              _buildEventBanner(brightness),
              const SizedBox(height: AppTheme.spaceSm),

              // ── Penalty Banner ──
              _buildPenaltyBanner(profileAsync, brightness),
              const SizedBox(height: AppTheme.spaceXxxl),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================
  // APP BAR
  // ============================================
  PreferredSizeWidget _buildAppBar(BuildContext context, String Function(String) t) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        'PiggyVault',
        style: AppTypography.h3(context),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.person_outline_rounded),
          onPressed: () => context.push('/avatar-builder'),
          tooltip: t('dash_profile_tooltip'),
        ),
        IconButton(
          icon: Icon(Icons.notifications_none_rounded),
          onPressed: () => context.push('/notifications'),
          tooltip: t('dash_notifications_tooltip'),
        ),
      ],
    );
  }

  // ============================================
  // HEADER — Avatar, Greeting, Level
  // ============================================
  Widget _buildHeader(
    BuildContext context,
    AsyncValue<UserProfile?> profileAsync,
    Brightness brightness,
    String Function(String) t,
  ) {
    return profileAsync.when(
      loading: () => const SizedBox(height: 64),
      error: (_, __) => const SizedBox.shrink(),
      data: (profile) {
        if (profile == null) return const SizedBox.shrink();

        final currentLevel = profile.level;
        final currentXp = profile.xp;
        final xpNeeded = SavingsNotifier.xpRequiredForLevel(currentLevel);
        final xpProgress = (currentXp / xpNeeded).clamp(0.0, 1.0);

        final avatarConfig = profile.avatarConfig != null
            ? AvatarConfig.fromJson(profile.avatarConfig!)
            : const AvatarConfig();

        return Row(
          children: [
            // Avatar
            GestureDetector(
              onLongPress: () {
                HapticFeedback.heavyImpact();
                final settings = ref.read(settingsServiceProvider);
                settings.privacyMode = !settings.privacyMode;
                setState(() {});
              },
              child: NeonAvatarWidget(
                config: avatarConfig,
                size: 48.0,
                brightness: brightness,
              ),
            ),
            const SizedBox(width: AppTheme.spaceLg),

            // Greeting
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t('dash_welcome'),
                    style: AppTypography.bodySmall(context),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    t('dash_title'),
                    style: AppTypography.h2(context),
                  ),
                ],
              ),
            ),

            // Level Chip
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spaceMd,
                vertical: AppTheme.spaceSm,
              ),
              decoration: BoxDecoration(
                color: AppColors.accentMutedBg(brightness),
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
              child: Column(
                children: [
                  Text(
                    'LVL $currentLevel',
                    style: AppTypography.overline(context,
                        color: AppColors.accent),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 80,
                    height: 4,
                    child: LinearProgressIndicator(
                      value: xpProgress,
                      backgroundColor: AppColors.border(brightness),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(AppColors.accent),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$currentXp / $xpNeeded XP',
                    style: AppTypography.caption(context,
                        color: AppColors.textTertiary(brightness)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================
  // STREAK BANNER
  // ============================================
  Widget _buildStreakBanner(
    AsyncValue<UserProfile?> profileAsync,
    Brightness brightness,
    String Function(String) t,
  ) {
    return profileAsync.when(
      loading: () => const SizedBox(height: 56),
      error: (_, __) => const SizedBox.shrink(),
      data: (profile) {
        if (profile == null) return const SizedBox.shrink();

        final streak = profile.streakCount;
        final hasStreak = streak > 0;
        final tokens = profile.freezeTokens;

        return SurfaceCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spaceLg,
            vertical: AppTheme.spaceMd,
          ),
          child: Row(
            children: [
              Icon(
                hasStreak
                    ? Icons.local_fire_department_rounded
                    : Icons.opacity_rounded,
                color: hasStreak ? AppColors.warning : AppColors.textTertiary(brightness),
                size: 28,
              ),
              const SizedBox(width: AppTheme.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasStreak
                          ? '${t('dash_streak_active')} $streak ${t('dash_days').toLowerCase()}'
                          : t('dash_streak_inactive'),
                      style: AppTypography.bodySmall(context,
                          color: hasStreak
                              ? AppColors.warning
                              : AppColors.textSecondary(brightness)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasStreak
                          ? t('dash_streak_tip_active')
                          : t('dash_streak_tip_inactive'),
                      style: AppTypography.caption(context),
                    ),
                  ],
                ),
              ),
              // Freeze tokens
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceSm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentMutedBg(brightness),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.ac_unit_rounded,
                      color: AppColors.accent,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$tokens',
                      style: AppTypography.caption(context,
                          color: AppColors.accent),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================
  // PROGRESS RINGS
  // ============================================
  Widget _buildProgressRings(AsyncValue<List<Goal>> goalsAsync) {
    return goalsAsync.when(
      loading: () => const SizedBox(height: 200),
      error: (_, __) => const SizedBox(height: 200),
      data: (goals) {
        if (goals.length < 2) return const SizedBox(height: 200);

        final goalA = goals.firstWhere((g) => g.id == 'goal_a');
        final goalB = goals.firstWhere((g) => g.id == 'goal_b');

        final ratioA = (goalA.currentAmount / goalA.targetAmount).clamp(0.0, 1.0);
        final ratioB = (goalB.currentAmount / goalB.targetAmount).clamp(0.0, 1.0);

        return Center(
          child: DualProgressRing(
            progressA: ratioA,
            progressB: ratioB,
            size: 180,
            strokeWidth: 12,
            ringSpacing: 10,
          ),
        );
      },
    );
  }

  // ============================================
  // DEPOSIT CTA
  // ============================================
  Widget _buildDepositButton(BuildContext context, String Function(String) t) {
    return AppButton(
      label: t('dash_deposit'),
      variant: ButtonVariant.primary,
      icon: Icons.add_card_rounded,
      onPressed: () => context.push('/deposit'),
    );
  }

  // ============================================
  // GOAL CARDS
  // ============================================
  Widget _buildGoalCards(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Goal>> goalsAsync,
    SettingsService settings,
  ) {
    return goalsAsync.when(
      loading: () => const SizedBox(height: 100),
      error: (_, __) => const SizedBox.shrink(),
      data: (goals) {
        if (goals.length < 2) return const SizedBox.shrink();

        final goalA = goals.firstWhere((g) => g.id == 'goal_a');
        final goalB = goals.firstWhere((g) => g.id == 'goal_b');
        final isPrivate = settings.privacyMode;

        return Column(
          children: [
            _buildSingleGoalCard(
              context: context,
              ref: ref,
              goal: goalA,
              icon: Icons.sports_esports_rounded,
              accentColor: AppColors.goalA,
              isPrivate: isPrivate,
              heroTag: 'goal_hero_goal_a',
            ),
            const SizedBox(height: AppTheme.spaceMd),
            _buildSingleGoalCard(
              context: context,
              ref: ref,
              goal: goalB,
              icon: Icons.monitor_rounded,
              accentColor: AppColors.goalB,
              isPrivate: isPrivate,
              heroTag: 'goal_hero_goal_b',
            ),
          ],
        );
      },
    );
  }

  Widget _buildSingleGoalCard({
    required BuildContext context,
    required WidgetRef ref,
    required Goal goal,
    required IconData icon,
    required Color accentColor,
    required bool isPrivate,
    required String heroTag,
  }) {
    final displayCurrent = isPrivate ? '•••' : centsToDisplay(goal.currentAmount);
    final displayTarget = isPrivate ? '•••' : centsToDisplay(goal.targetAmount);
    final progress = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);

    return GestureDetector(
      onVerticalDragEnd: (details) async {
        if (details.primaryVelocity != null && details.primaryVelocity! < -300) {
          HapticFeedback.heavyImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t('dash_quick_deposit_snack')),
              behavior: SnackBarBehavior.floating,
            ),
          );
          final activeEvent = ref.read(eventsProvider);
          await ref.read(savingsNotifierProvider.notifier).createDeposit(
                amount: 50.0,
                goalAPercent: goal.id == 'goal_a' ? 100.0 : 0.0,
                activeEvent: activeEvent,
              );
        }
      },
      child: GoalCard(
        title: goal.name,
        currentAmount: isPrivate ? 0 : centsToDisplay(goal.currentAmount),
        targetAmount: isPrivate ? 0 : centsToDisplay(goal.targetAmount),
        currency: goal.currency,
        icon: icon,
        accentColor: accentColor,
        onTap: () => context.push('/goal-detail/${goal.id}'),
        heroTag: heroTag,
        isCiphered: isPrivate,
      ),
    );
  }

  // ============================================
  // DAILY QUESTS CHECKLIST
  // ============================================
  Widget _buildDailyQuestsCard(WidgetRef ref, Brightness brightness) {
    final questsAsync = ref.watch(questProvider);

    return questsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (quests) {
        if (quests.isEmpty) return const SizedBox.shrink();

        final completedCount = quests.where((q) => q.isCompleted).length;
        final allDone = completedCount == quests.length;

        return SurfaceCard(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.assignment_turned_in_rounded,
                    color: AppColors.accent,
                    size: 20,
                  ),
                  const SizedBox(width: AppTheme.spaceSm),
                  Text(
                    t('dash_daily_quests'),
                    style: AppTypography.h3(context),
                  ),
                  const Spacer(),
                  // Count badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spaceSm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: allDone
                          ? AppColors.successMuted
                          : AppColors.accentMutedBg(brightness),
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                    child: Text(
                      '$completedCount/${quests.length}',
                      style: AppTypography.caption(context,
                          color: allDone
                              ? AppColors.success
                              : AppColors.accent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceMd),

              // Quest items
              ...quests.map((q) => _buildQuestItem(q, brightness)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuestItem(DailyQuest quest, Brightness brightness) {
    final done = quest.isCompleted;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceSm),
      child: Row(
        children: [
          // Checkbox
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: done
                  ? AppColors.accentMutedBg(brightness)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: done ? AppColors.accent : AppColors.border(brightness),
                width: 1.5,
              ),
            ),
            child: done
                ? const Icon(Icons.check, color: AppColors.accent, size: 14)
                : null,
          ),
          const SizedBox(width: AppTheme.spaceMd),

          // Title + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quest.title,
                  style: AppTypography.bodySmall(context,
                      color: done
                          ? AppColors.textSecondary(brightness)
                          : AppColors.textPrimary(brightness)),
                ),
                Text(
                  quest.description,
                  style: AppTypography.caption(context),
                ),
              ],
            ),
          ),

          // Reward badge
          if (!done)
            Text(
              '+${quest.rewardXp}XP',
              style: AppTypography.caption(context,
                  color: AppColors.accent),
            ),
        ],
      ),
    );
  }

  // ============================================
  // QUICK ACTIONS ROW
  // ============================================
  Widget _buildQuickActions(BuildContext context, String Function(String) t) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      runSpacing: 8.0,
      children: [
        _QuickActionButton(
          icon: Icons.storefront_rounded,
          label: t('dash_market'),
          onTap: () => context.push('/market'),
        ),
        _QuickActionButton(
          icon: Icons.casino_rounded,
          label: t('dash_spin'),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => const DailySpinDialog(),
            );
          },
        ),
        _QuickActionButton(
          icon: Icons.emoji_events_rounded,
          label: t('dash_leaderboard'),
          onTap: () => context.push('/leaderboards'),
        ),
        _QuickActionButton(
          icon: Icons.shield_rounded,
          label: t('dash_class'),
          onTap: () => context.push('/class-selection'),
        ),
        _QuickActionButton(
          icon: Icons.calculate_rounded,
          label: t('calc_title'),
          onTap: () => context.push('/savings-calculator'),
        ),
        _QuickActionButton(
          icon: Icons.flag_rounded,
          label: t('challenge_title'),
          onTap: () => context.push('/weekly-challenges'),
        ),
      ],
    );
  }

  // ============================================
  // FINANCIAL HEALTH THERMOMETER
  // ============================================
  Widget _buildFinancialHealth(Brightness brightness) {
    final healthAsync = ref.watch(financialHealthProvider);
    final locale = ref.read(localeProvider);
    final t = (String key) => AppLocalizations.get(locale, key);

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('health_title'),
            style: AppTypography.h3(context),
          ),
          const SizedBox(height: 12),
          healthAsync.when(
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
            data: (health) {
              return Row(
                children: [
                  // Thermometer
                  FinancialHealthThermometer(
                    score: health.score,
                    brightness: brightness,
                  ),
                  const SizedBox(width: 16),
                  // Breakdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HealthDetailRow(
                          label: t('health_streak'),
                          value: health.streakScore,
                          weight: '40%',
                        ),
                        const SizedBox(height: 8),
                        _HealthDetailRow(
                          label: t('health_goals'),
                          value: health.goalScore,
                          weight: '40%',
                        ),
                        const SizedBox(height: 8),
                        _HealthDetailRow(
                          label: t('health_avoided'),
                          value: health.avoidedScore,
                          weight: '20%',
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================
  // EVENT BANNER
  // ============================================
  Widget _buildEventBanner(Brightness brightness) {
    final activeEvent = ref.watch(eventsProvider);
    if (activeEvent == null || !activeEvent.isActive) {
      return const SizedBox.shrink();
    }

    return SurfaceCard(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      borderColor: AppColors.accent,
      child: Row(
        children: [
          Icon(Icons.event_rounded, color: AppColors.accent, size: 24),
          const SizedBox(width: AppTheme.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activeEvent.title,
                  style: AppTypography.bodySmall(context,
                      color: AppColors.accent),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  activeEvent.description,
                  style: AppTypography.caption(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // PENALTY BANNER
  // ============================================
  Widget _buildPenaltyBanner(
    AsyncValue<UserProfile?> profileAsync,
    Brightness brightness,
  ) {
    return profileAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (profile) {
        if (profile == null || profile.penaltyBalance <= 0) {
          return const SizedBox.shrink();
        }

        return SurfaceCard(
          padding: const EdgeInsets.all(AppTheme.spaceMd),
          borderColor: AppColors.error,
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: AppColors.error, size: 24),
              const SizedBox(width: AppTheme.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t('dash_active_penalties'),
                      style: AppTypography.bodySmall(context,
                          color: AppColors.error),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t('dash_penalties_detected'),
                      style: AppTypography.caption(context),
                    ),
                  ],
                ),
              ),
              AppButton(
                label: t('dash_penalties_btn'),
                variant: ButtonVariant.ghost,
                size: ButtonSize.small,
                onPressed: () => context.push('/penalty-vault'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================
// HEALTH DETAIL ROW (local widget)
// ============================================
class _HealthDetailRow extends StatelessWidget {
  final String label;
  final double value;
  final String weight;

  const _HealthDetailRow({
    required this.label,
    required this.value,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final pct = value.round();

    return Row(
      children: [
        Expanded(
          child: Text(label, style: AppTypography.bodySmall(context)),
        ),
        Text(
          '$pct%',
          style: AppTypography.caption(
            context,
            color: pct >= 70
                ? AppColors.success
                : pct >= 40
                    ? AppColors.chartAmber
                    : AppColors.error,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '($weight)',
          style: AppTypography.overline(context),
        ),
      ],
    );
  }
}

// ============================================
// QUICK ACTION BUTTON (local widget)
// ============================================
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceSm,
          vertical: AppTheme.spaceSm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted(brightness),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(
                icon,
                color: AppColors.textPrimary(brightness),
                size: 22,
              ),
            ),
            const SizedBox(height: AppTheme.spaceXs),
            Text(
              label,
              style: AppTypography.caption(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
