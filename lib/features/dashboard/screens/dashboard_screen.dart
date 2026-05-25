import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/savings_notifier.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/dual_progress_ring.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/neon_progress_bar.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/saving_goal_card.dart';
import '../../gamification/providers/bounty_provider.dart';
import '../../gamification/models/bounty_model.dart';
import '../../../data/database.dart';
import '../../gamification/widgets/daily_spin_dialog.dart';
import '../../../core/widgets/neon_avatar_painter.dart';
import '../../../core/providers/banking_provider.dart';
import '../../../core/providers/events_notifier.dart';
import '../widgets/banking_insights_card.dart';
import '../../gamification/providers/quest_provider.dart';
import '../../gamification/models/daily_quest.dart';
import '../../gamification/providers/daily_bonus_provider.dart';
import '../../gamification/widgets/daily_bonus_dialog.dart';
import '../../gamification/widgets/shield_activation_dialog.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
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

    String t(String key) => AppLocalizations.get(currentLocale, key);

    return Scaffold(
      backgroundColor: Colors.transparent, // Let ShellScaffold background handle it
      appBar: buildAppBar(context, t),
      body: RefreshIndicator(
        onRefresh: () async {
          // Relies on live Streams from Drift, so no-op pull to refresh suffices
          await Future.delayed(const Duration(milliseconds: 400));
        },
        color: AppColors.cyanAccent,
        backgroundColor: AppColors.background,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Segment
              _buildHeader(context, profileAsync, t)
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 50.ms)
                  .slideY(begin: -0.1, end: 0.0),
              const SizedBox(height: 16.0),

              // Streak Banner
              _buildStreakBanner(profileAsync, t)
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 100.ms)
                  .slideY(begin: 0.1, end: 0.0),
              const SizedBox(height: 16.0),

              // Quick Actions — 2x2 grid with reduced height
              Row(
                children: [
                  Expanded(
                    child: NeonButton(
                      text: t('dash_market'),
                      baseColor: AppColors.goldGlow,
                      glowColor: AppColors.goldGlow,
                      icon: const Icon(Icons.storefront, color: Colors.black, size: 16),
                      height: 46.0,
                      onPressed: () => context.push('/market'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: NeonButton(
                      text: t('dash_spin'),
                      baseColor: AppColors.cyanAccent,
                      glowColor: AppColors.cyanAccent,
                      icon: const Icon(Icons.casino, color: Colors.black, size: 16),
                      height: 46.0,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => const DailySpinDialog(),
                        );
                      },
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms, delay: 150.ms).scaleXY(begin: 0.96, end: 1.0),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: NeonButton(
                      text: t('dash_penalty'),
                      baseColor: Colors.redAccent,
                      glowColor: Colors.redAccent,
                      icon: const Icon(Icons.warning_amber_rounded, color: Colors.black, size: 16),
                      height: 46.0,
                      onPressed: () => context.push('/penalty-vault'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: NeonButton(
                      text: t('dash_squad'),
                      baseColor: AppColors.magentaAccent,
                      glowColor: AppColors.magentaAccent,
                      icon: const Icon(Icons.group, color: Colors.black, size: 16),
                      height: 46.0,
                      onPressed: () => context.push('/squads'),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms, delay: 150.ms).scaleXY(begin: 0.96, end: 1.0),
              const SizedBox(height: 8.0),
              SizedBox(
                width: double.infinity,
                child: NeonButton(
                  text: '🏆 Лідерборди',
                  baseColor: AppColors.goldAccent,
                  glowColor: AppColors.goldAccent,
                  icon: const Icon(Icons.emoji_events, color: Colors.black, size: 16),
                  height: 46.0,
                  onPressed: () => context.push('/leaderboards'),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 150.ms).scaleXY(begin: 0.96, end: 1.0),
              const SizedBox(height: 16.0),

              // Active Cyber-Event Banner
              Consumer(
                builder: (context, ref, child) {
                  final activeEvent = ref.watch(eventsProvider);
                  if (activeEvent == null || !activeEvent.isActive) {
                    return const SizedBox.shrink();
                  }
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: AppColors.magentaAccent.withOpacity(0.15),
                      border: Border.all(color: AppColors.magentaAccent),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.magentaAccent.withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.public, color: AppColors.magentaAccent, size: 28),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activeEvent.title,
                                style: AppTextStyles.orbitronHeading(
                                  fontSize: 12.0,
                                  color: AppColors.magentaAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                activeEvent.description,
                                style: const TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate(onPlay: (controller) => controller.repeat(reverse: true)).fadeIn(duration: 800.ms).then().fade(end: 0.7);
                },
              ),

              // Blacklist Virus Banner
              Consumer(
                builder: (context, ref, child) {
                  final profileAsync = ref.watch(userProfileProvider);
                  return profileAsync.when(
                    data: (profile) {
                      if (profile == null || profile.penaltyBalance <= 0) {
                        return const SizedBox.shrink();
                      }
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.15),
                          border: Border.all(color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.bug_report, color: Colors.redAccent, size: 28)
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .shake(duration: 300.ms),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'СИСТЕМА ІНФІКОВАНА',
                                    style: AppTextStyles.orbitronHeading(
                                      fontSize: 12.0,
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: 500.ms, color: Colors.white),
                                  const SizedBox(height: 2.0),
                                  const Text(
                                    'Виявлено транзакції з Blacklist. Несплачені штрафи пошкоджують Аватар!',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  );
                },
              ),

              // AI Insights Banner
              const BankingInsightsCard(),
              const SizedBox(height: 12.0),

              // AI Daily Bounty
              _buildDailyBounty(context, ref)
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 180.ms)
                  .slideY(begin: 0.1, end: 0.0),
              const SizedBox(height: 12.0),

              // Daily Quests Checklist
              _buildDailyQuestsCard(ref)
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 200.ms)
                  .slideY(begin: 0.1, end: 0.0),

              // Interactive concentric rings
              _buildCenterpiece(goalsAsync)
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 200.ms)
                  .scale(
                    begin: const Offset(0.92, 0.92),
                    end: const Offset(1.0, 1.0),
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: 28.0),

              // Deposit Action Button
              NeonButton(
                text: t('dash_deposit'),
                baseColor: AppColors.cyanAccent,
                glowColor: AppColors.cyanAccent,
                icon: const Icon(Icons.add_card_rounded, color: Colors.black, size: 20),
                onPressed: () => context.push('/deposit'),
              ).animate().fadeIn(duration: 400.ms, delay: 250.ms).slideY(begin: 0.15, end: 0.0),
              const SizedBox(height: 28.0),

              // Goals List Cards
              _buildGoalCards(context, ref, goalsAsync)
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 300.ms)
                  .slideY(begin: 0.1, end: 0.0),
              const SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SUB-WIDGETS
  // ==========================================

  Widget _buildHeader(BuildContext context, AsyncValue<UserProfile?> profileAsync, String Function(String) t) {
    final isPrivacyMode = ref.watch(settingsServiceProvider).privacyMode;

    return profileAsync.when(
      loading: () => const SizedBox(height: 70, child: Center(child: CircularProgressIndicator())),
      error: (e, _) => Text('Error loading profile: $e', style: const TextStyle(color: Colors.red)),
      data: (profile) {
        if (profile == null) return const SizedBox.shrink();

        // Level threshold: 1000 * level^1.5
        final currentLevel = profile.level;
        final currentXp = profile.xp;
        final xpNeededForNext = SavingsNotifier.xpRequiredForLevel(currentLevel);
        final progress = (currentXp / xpNeededForNext).clamp(0.0, 1.0);

        final avatarConfig = profile.avatarConfig != null 
            ? AvatarConfig.fromJson(profile.avatarConfig!) 
            : const AvatarConfig();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (profile.avatarConfig != null && profile.avatarConfig!.isNotEmpty) ...[
                    GestureDetector(
                      onLongPress: () {
                        HapticFeedback.heavyImpact();
                        final settings = ref.read(settingsServiceProvider);
                        settings.privacyMode = !settings.privacyMode;
                        // setState to trigger rebuild of header
                        setState(() {});
                      },
                      child: NeonAvatarWidget(
                        config: avatarConfig,
                        size: 46.0,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t('dash_vault'),
                          style: AppTextStyles.rajdhaniMedium(
                            fontSize: 12.0,
                            color: AppColors.cyanAccent,
                          ).copyWith(letterSpacing: 2.0),
                        ),
                        GestureDetector(
                          onDoubleTap: () {
                            context.push('/terminal');
                          },
                          child: Text(
                            t('dash_title'),
                            style: AppTextStyles.orbitronHeading(
                              fontSize: 22.0,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ).copyWith(
                              shadows: [
                                Shadow(
                                  color: AppColors.cyanAccent.withOpacity(0.6),
                                  blurRadius: 12.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            // Level Badge with interactive XP bar
            Container(
              width: 140.0,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.cardBgLight,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AppColors.borderNeon, width: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'LVL $currentLevel',
                        style: AppTextStyles.orbitronHeading(
                          fontSize: 11.0,
                          color: AppColors.goldGlow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$currentXp/$xpNeededForNext XP',
                        style: const TextStyle(
                          fontSize: 9.0,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  NeonProgressBar(
                    progress: progress,
                    activeColor: AppColors.goldGlow,
                    glowColor: AppColors.goldGlow,
                    height: 4.0,
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      const Icon(Icons.token, color: AppColors.cyanAccent, size: 10),
                      const SizedBox(width: 4.0),
                      Text(
                        'CREDITS: ${avatarConfig.credits}',
                        style: const TextStyle(
                          fontSize: 9.0,
                          color: AppColors.cyanAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (avatarConfig.integrity < 1.0) ...[
                    const SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'INTEGRITY WARNING',
                          style: TextStyle(
                            fontSize: 8.0,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${(avatarConfig.integrity * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 8.0,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    NeonProgressBar(
                      progress: avatarConfig.integrity,
                      activeColor: Colors.redAccent,
                      glowColor: Colors.redAccent,
                      height: 4.0,
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStreakBanner(AsyncValue<UserProfile?> profileAsync, String Function(String) t) {
    return profileAsync.when(
      loading: () => const SizedBox(height: 50),
      error: (_, __) => const SizedBox.shrink(),
      data: (profile) {
        if (profile == null) return const SizedBox.shrink();

        final streak = profile.streakCount;
        final hasStreak = streak > 0;
        final tokens = profile.freezeTokens;

        return GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          gradient: hasStreak
              ? LinearGradient(
                  colors: [
                    AppColors.fireOrange.withOpacity(0.08),
                    Colors.transparent,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          child: Row(
            children: [
              Icon(
                hasStreak ? Icons.local_fire_department_rounded : Icons.opacity_rounded,
                color: hasStreak ? AppColors.fireOrange : AppColors.textMuted,
                size: 28.0,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasStreak ? '${t('dash_streak_active')} $streak ${t('dash_days')}' : t('dash_streak_inactive'),
                      style: AppTextStyles.orbitronHeading(
                        fontSize: 12.0,
                        color: hasStreak ? AppColors.fireOrange : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      hasStreak ? t('dash_streak_tip_active') : t('dash_streak_tip_inactive'),
                      style: TextStyle(
                        fontSize: 10.0,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              // Freeze tokens counter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: AppColors.cyanAccent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(color: AppColors.cyanAccent.withOpacity(0.4), width: 1.0),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.ac_unit_rounded, color: AppColors.cyanAccent, size: 14.0),
                    const SizedBox(width: 4.0),
                    Text(
                      '$tokens CRYSH',
                      style: AppTextStyles.orbitronHeading(
                        fontSize: 9.0,
                        color: AppColors.cyanAccent,
                        fontWeight: FontWeight.bold,
                      ),
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

  AppBar buildAppBar(BuildContext context, String Function(String) t) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t('dash_title'),
          style: AppTextStyles.orbitronHeading(
            fontSize: 20.0,
            color: AppColors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.pets, color: AppColors.goldGlow),
            onPressed: () => context.push('/pets'),
          ),
          IconButton(
            icon: const Icon(Icons.card_giftcard, color: Colors.purpleAccent),
            onPressed: () => context.push('/lootboxes'),
          ),
          IconButton(
            icon: const Icon(Icons.shield, color: AppColors.magentaAccent),
            onPressed: () => context.push('/class-selection'),
          ),
          IconButton(
            icon: const Icon(Icons.auto_delete_outlined, color: AppColors.cyanAccent),
            onPressed: () => context.push('/regret-archive'),
          ),
        ],
      );
  }

  Widget _buildCenterpiece(AsyncValue<List<Goal>> goalsAsync) {
    return goalsAsync.when(
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox(height: 200),
      data: (goals) {
        if (goals.length < 2) return const SizedBox(height: 200);

        final goalA = goals.firstWhere((g) => g.id == 'goal_a');
        final goalB = goals.firstWhere((g) => g.id == 'goal_b');

        final double ratioA = (goalA.currentAmount / goalA.targetAmount).clamp(0.0, 1.0);
        final double ratioB = (goalB.currentAmount / goalB.targetAmount).clamp(0.0, 1.0);

        return Center(
          child: DualProgressRing(
            progressA: ratioA,
            progressB: ratioB,
            size: 210.0,
            strokeWidth: 13.0,
            ringSpacing: 10.0,
          ),
        );
      },
    );
  }

  Widget _buildGoalCards(BuildContext context, WidgetRef ref, AsyncValue<List<Goal>> goalsAsync) {
    return goalsAsync.when(
      loading: () => const SizedBox(height: 100),
      error: (_, __) => const SizedBox.shrink(),
      data: (goals) {
        if (goals.length < 2) return const SizedBox.shrink();

        final goalA = goals.firstWhere((g) => g.id == 'goal_a');
        final goalB = goals.firstWhere((g) => g.id == 'goal_b');
        final isCiphered = ref.watch(settingsServiceProvider).privacyMode;

        return Column(
          children: [
            GestureDetector(
              onVerticalDragEnd: (details) async {
                if (details.primaryVelocity != null && details.primaryVelocity! < -300) {
                  // Swipe up detected - Quick Deposit 50
                  HapticFeedback.heavyImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Швидкий внесок: 50.00 ${goalA.currency} до ${goalA.name}!'),
                      backgroundColor: AppColors.cyanAccent.withOpacity(0.8),
                    ),
                  );
                  final activeEvent = ref.read(eventsProvider);
                  await ref.read(savingsNotifierProvider.notifier).createDeposit(
                        amount: 50.0,
                        goalAPercent: 100.0,
                        activeEvent: activeEvent,
                      );
                }
              },
              child: SavingGoalCard(
                title: goalA.name,
                currentAmount: centsToDisplay(goalA.currentAmount),
                targetAmount: centsToDisplay(goalA.targetAmount),
                currency: goalA.currency,
                icon: Icons.sports_esports_rounded,
                accentColor: AppColors.cyanAccent,
                heroTag: 'goal_hero_goal_a',
                isCiphered: isCiphered,
                onTap: () => context.push('/goal-detail/${goalA.id}'),
              ),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onVerticalDragEnd: (details) async {
                if (details.primaryVelocity != null && details.primaryVelocity! < -300) {
                  // Swipe up detected - Quick Deposit 50
                  HapticFeedback.heavyImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Швидкий внесок: 50.00 ${goalB.currency} до ${goalB.name}!'),
                      backgroundColor: AppColors.magentaAccent.withOpacity(0.8),
                    ),
                  );
                  final activeEvent = ref.read(eventsProvider);
                  await ref.read(savingsNotifierProvider.notifier).createDeposit(
                        amount: 50.0,
                        goalAPercent: 0.0,
                        activeEvent: activeEvent,
                      );
                }
              },
              child: SavingGoalCard(
                title: goalB.name,
                currentAmount: centsToDisplay(goalB.currentAmount),
                targetAmount: centsToDisplay(goalB.targetAmount),
                currency: goalB.currency,
                icon: Icons.monitor_rounded,
                accentColor: AppColors.magentaAccent,
                heroTag: 'goal_hero_goal_b',
                isCiphered: isCiphered,
                onTap: () => context.push('/goal-detail/${goalB.id}'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDailyBounty(BuildContext context, WidgetRef ref) {
    final bountyAsync = ref.watch(bountyProvider);

    return bountyAsync.when(
      loading: () => const SizedBox(height: 60, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
      data: (bounty) {
        if (bounty == null) return const SizedBox.shrink();

        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: bounty.isCompleted 
                ? AppColors.goldGlow.withOpacity(0.1) 
                : AppColors.cyanAccent.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: bounty.isCompleted 
                  ? AppColors.goldGlow.withOpacity(0.5) 
                  : AppColors.cyanAccent.withOpacity(0.3),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.0),
              onTap: bounty.isCompleted ? null : () {
                // Future: show details dialog
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      bounty.isCompleted ? Icons.check_circle : Icons.assignment,
                      color: bounty.isCompleted ? AppColors.goldGlow : AppColors.cyanAccent,
                      size: 28,
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                bounty.title.toUpperCase(),
                                style: AppTextStyles.orbitronHeading(
                                  fontSize: 11.0,
                                  color: bounty.isCompleted ? AppColors.goldGlow : AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              if (!bounty.isCompleted)
                                Text(
                                  '${bounty.targetAmount.toStringAsFixed(0)} ${ref.watch(settingsServiceProvider).currency}',
                                  style: AppTextStyles.orbitronHeading(
                                    fontSize: 10.0,
                                    color: AppColors.cyanAccent,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            bounty.isCompleted ? 'КОНТРАКТ ВИКОНАНО!' : bounty.description,
                            style: TextStyle(
                              fontSize: 11.0,
                              color: isDark ? AppColors.textSecondary : AppColors.textLightSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // DAILY QUESTS CHECKLIST
  // ==========================================
  Widget _buildDailyQuestsCard(WidgetRef ref) {
    final questsAsync = ref.watch(questProvider);

    return questsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (quests) {
        if (quests.isEmpty) return const SizedBox.shrink();

        final completedCount = quests.where((q) => q.isCompleted).length;

        return GlassCard(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  const Icon(Icons.assignment_turned_in, color: AppColors.cyanAccent, size: 20),
                  const SizedBox(width: 8.0),
                  Text(
                    'ЩОДЕННІ КВЕСТИ',
                    style: AppTextStyles.orbitronHeading(
                      fontSize: 12.0,
                      color: AppColors.cyanAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: completedCount == quests.length
                          ? AppColors.cyanAccent.withOpacity(0.2)
                          : AppColors.cardBg,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: completedCount == quests.length
                            ? AppColors.cyanAccent
                            : AppColors.borderNeon,
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      '$completedCount/${quests.length}',
                      style: AppTextStyles.rajdhaniMedium(
                        fontSize: 11.0,
                        color: completedCount == quests.length
                            ? AppColors.cyanAccent
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),

              // Quest items
              ...quests.map((quest) => _buildQuestItem(quest)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuestItem(DailyQuest quest) {
    final isCompleted = quest.isCompleted;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          // Checkbox
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 22.0,
            height: 22.0,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.cyanAccent.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                color: isCompleted ? AppColors.cyanAccent : AppColors.borderNeon,
                width: 1.5,
              ),
            ),
            child: isCompleted
                ? const Icon(Icons.check, color: AppColors.cyanAccent, size: 14)
                : null,
          ),
          const SizedBox(width: 10.0),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quest.title,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: isCompleted
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.textSecondary,
                  ),
                ),
                Text(
                  quest.description,
                  style: TextStyle(
                    fontSize: 10.0,
                    color: isCompleted
                        ? AppColors.textSecondary.withOpacity(0.5)
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Rewards badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.cyanAccent.withOpacity(0.1)
                  : AppColors.magentaAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              isCompleted ? '✓' : '+${quest.rewardXp}XP +${quest.rewardCredits}CR',
              style: TextStyle(
                fontSize: 9.0,
                fontWeight: FontWeight.bold,
                color: isCompleted ? AppColors.cyanAccent : AppColors.magentaAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Quick inline math exponent calculator for Dart environment
class MathHelper {
  static double pow(double x, double exponent) {
    if (exponent == 0) return 1.0;
    if (exponent == 1) return x;
    // Basic approximation since dart:math only works with num values
    return math.pow(x, exponent).toDouble();
  }
}
