import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/services/gamification/xp_service.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/utils/haptics_helper.dart';
import '../../../core/widgets/dual_progress_ring.dart';
import '../../../core/widgets/neon_avatar_painter.dart';
import '../../../core/widgets/financial_health_thermometer.dart';
import '../../../core/models/avatar_config.dart';
import '../../../core/providers/financial_health_provider.dart';
import '../../../data/settings_service.dart';

// New clean widgets (may be created in parallel — forward-import safe).
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/goal_card.dart';
import '../../../core/services/price_tracker_service.dart';
import '../../../core/widgets/feature_card.dart';

// Existing feature widgets
import '../widgets/banking_insights_card.dart';
import '../../gamification/providers/quest_provider.dart';
import '../../gamification/providers/daily_bonus_provider.dart';
import '../../gamification/models/daily_quest.dart';
import '../../gamification/widgets/daily_spin_dialog.dart';
import '../../gamification/widgets/daily_bonus_dialog.dart';
import '../../gamification/widgets/shield_activation_dialog.dart';
import '../../gamification/widgets/zen_breathe_dialog.dart';
import '../../../core/providers/pets_provider.dart';
import '../../gamification/widgets/cyber_pet_dashboard_widget.dart';
import '../../gamification/providers/freezer_provider.dart';
import '../../gamification/widgets/no_spend_challenge_card.dart';
import '../../gamification/widgets/karma_debt_widget.dart';
import '../../gamification/widgets/report_relapse_dialog.dart';
import '../../gamification/providers/karma_provider.dart';
import '../../../data/database.dart';
import '../../../core/services/notification_service.dart';
import '../widgets/cyber_partner_card.dart';
import '../../gamification/providers/merchant_provider.dart';
import '../../gamification/widgets/merchant_dialog.dart';
import '../../gamification/widgets/neon_pulsating_fab.dart';
import '../../gamification/widgets/flash_goal_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  /// Tracks which goal IDs are currently being scanned to show loading state.
  final Set<String> _scanningGoalIds = {};

  String t(String key) {
    final locale = ref.watch(localeProvider);
    return AppLocalizations.get(locale, key);
  }

  /// Scans market prices for the given goal and prompts the user to update
  /// the target amount if the found price differs by more than 5%.
  Future<void> _onScanPrices(Goal goal) async {
    if (_scanningGoalIds.contains(goal.id)) return; // prevent duplicate calls

    setState(() => _scanningGoalIds.add(goal.id));
    final locale = ref.read(localeProvider);

    try {
      final price = await PriceTrackerService.fetchPrice(
        goal.name,
        sku: goal.productUrl,
      );

      if (!mounted) return;

      if (price == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.get(locale, 'price_not_found')),
          behavior: SnackBarBehavior.floating,
        ));
        return;
      }

      final priceInKopecks = (price * 100).toInt();
      final oldTarget = goal.targetAmount;
      final diff = (priceInKopecks - oldTarget).abs() / oldTarget;

      if (diff > 0.05) {
        final shouldUpdate = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text(AppLocalizations.get(locale, 'update_target_title')),
            content: Text(AppLocalizations.format(locale, 'update_target_content', {
              '0': price.toStringAsFixed(0),
              '1': (oldTarget / 100).toStringAsFixed(0),
            })),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: Text(AppLocalizations.get(locale, 'common_cancel')),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(c, true),
                child: Text(AppLocalizations.get(locale, 'common_save')),
              ),
            ],
          ),
        ) ?? false;

        if (!mounted) return;

        if (shouldUpdate) {
          final db = ref.read(databaseProvider);
          await db.updateGoal(goal.copyWith(
            targetAmount: priceInKopecks,
            updatedAt: DateTime.now(),
          ));
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.get(locale, 'target_updated')),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ));
          // Refresh goals stream so progress numbers update immediately.
          ref.invalidate(goalsProvider);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.get(locale, 'price_actual')),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '${AppLocalizations.get(locale, 'price_fetch_error')} $e',
        ),
        behavior: SnackBarBehavior.floating,
      ));
    } finally {
      if (mounted) setState(() => _scanningGoalIds.remove(goal.id));
    }
  }

  void _showNewFeaturesTooltips(BuildContext context, SettingsService settings) {
    settings.hasSeenNewFeaturesTooltips = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final brightness = Theme.of(ctx).brightness;
        return Dialog(
          backgroundColor: AppColors.surface(brightness),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '🎉 Оновлення MVP',
                  style: AppTypography.h2(ctx),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const _TooltipRow(
                  icon: Icons.ac_unit_rounded,
                  color: Colors.blueAccent,
                  title: 'Кріо-Заморожувач',
                  desc: 'Хочеш купити щось зайве? Заморозь кошти на 24 години!',
                ),
                const _TooltipRow(
                  icon: Icons.not_interested_rounded,
                  color: Colors.orangeAccent,
                  title: 'No-Spend Стрік',
                  desc: 'Немає грошей на депозит? Зафіксуй день без витрат!',
                ),
                const _TooltipRow(
                  icon: Icons.healing_rounded,
                  color: Colors.redAccent,
                  title: 'Карма-Борг',
                  desc: 'Зірвався? Не біда! Вилікуй Пета квестами.',
                ),
                const _TooltipRow(
                  icon: Icons.track_changes_rounded,
                  color: Colors.purpleAccent,
                  title: 'Мисливець за цінами',
                  desc: 'Додай посилання на товар – чекай на знижку!',
                ),
                const _TooltipRow(
                  icon: Icons.group_add_rounded,
                  color: Colors.greenAccent,
                  title: 'Кібер-Напарник',
                  desc: 'Знайди союзника — отримуйте подвійний XP!',
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Круто, вперед!',
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isZenMode = ref.watch(zenModeProvider);
    final brightness = Theme.of(context).brightness;

    // Define Zen Colors locally or use theme-based logic
    final backgroundColor = isZenMode ? (brightness == Brightness.dark ? const Color(0xFF121212) : const Color(0xFFF0F4F8)) : Colors.transparent;
    final contentColor = isZenMode ? (brightness == Brightness.dark ? Colors.blueGrey[200]! : Colors.blueGrey[800]!) : null;

    // Listen for daily bonus / shield activation dialogs
    ref.listen<AsyncValue<DailyBonusState>>(dailyBonusProvider,
        (previous, next) {
      if (next is AsyncData<DailyBonusState>) {
        final state = next.value;
        if (state.shieldActivated && state.shieldDaysSaved > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            ShieldActivationDialog.show(context, state.shieldDaysSaved);
            if (state.isBonusAvailable) {
              Future.delayed(const Duration(seconds: 2), () {
                if (!context.mounted) return;
                DailyBonusDialog.show(context);
              });
            }
          });
        } else if (state.isBonusAvailable) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            DailyBonusDialog.show(context);
          });
        }
      }
    });

    // Listen for Karma-Debt triggers/updates
    ref.listen<AsyncValue<KarmaState>>(karmaProvider, (prev, next) {
      if (next is AsyncData<KarmaState>) {
        final val = next.value;
        if (val.justReported) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t('karma_compromised_toast')),
                backgroundColor: const Color(0xFFFF2A6D),
                behavior: SnackBarBehavior.floating,
              ),
            );
            ref.read(karmaProvider.notifier).clearFlags();
          });
        } else if (val.justHealed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t('karma_healed_toast')),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            ref.read(karmaProvider.notifier).clearFlags();
          });
        }
      }
    });

    final goalsAsync = ref.watch(goalsProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final petsAsync = ref.watch(petsProvider);
    final settings = ref.watch(settingsServiceProvider);

    // ── Tooltips Trigger ──
    if (!settings.hasSeenNewFeaturesTooltips) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        _showNewFeaturesTooltips(context, settings);
      });
    }

    // ── Pet Overheating Local Push Notification Trigger ──
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    if (profileAsync.hasValue && petsAsync.hasValue) {
      final profile = profileAsync.value;
      final pets = petsAsync.value;
      if (profile != null && pets != null && pets.isNotEmpty) {
        final lastDepositDate = profile.lastDepositDate;
        double temp = 37.0;
        if (lastDepositDate != null) {
          final hours = DateTime.now().difference(lastDepositDate).inHours;
          if (hours > 24) {
            temp = 37.0 + (hours - 24) * 1.5;
          }
        }
        temp = temp.clamp(37.0, 99.0);
        if (temp > 60.0 && settings.lastOverheatNotifiedDate != todayStr) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (settings.lastOverheatNotifiedDate == todayStr) return;
            settings.lastOverheatNotifiedDate = todayStr;
            await NotificationService().showNotification(
              id: 999,
              title: '${t('pet_core_temp')}: ${temp.toStringAsFixed(1)}°C',
              body: t('pet_overheating_warning'),
            );
          });
        }
      }
    }

    // ── Dopamine Detox Auto-Trigger ──
    if (settings.isDopamineDetoxEnabled &&
        profileAsync.hasValue &&
        petsAsync.hasValue) {
      final profile = profileAsync.value;
      final pets = petsAsync.value;
      if (profile != null && pets != null) {
        final hasPenalty = profile.penaltyBalance > 0;
        final lastDepositDate = profile.lastDepositDate;
        double temp = 37.0;
        if (lastDepositDate != null) {
          final hours = DateTime.now().difference(lastDepositDate).inHours;
          if (hours > 24) {
            temp = 37.0 + (hours - 24) * 1.5;
          }
        }
        temp = temp.clamp(37.0, 99.0);
        final isPetOverheating = temp > 60.0 && pets.isNotEmpty;

        if ((hasPenalty || isPetOverheating) &&
            !settings.isDopamineDetoxActive) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (settings.isDopamineDetoxActive) return;
            final until = DateTime.now()
                .add(const Duration(hours: 24))
                .millisecondsSinceEpoch;
            settings.dopamineDetoxUntil = until;
            ref.invalidate(settingsServiceProvider);
          });
        }
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(context, ref),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: RefreshIndicator(
          key: ValueKey(isZenMode),
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 400));
          },
          color: isZenMode ? Colors.blueGrey : AppColors.accent,
          backgroundColor: AppColors.surface(brightness),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceXl,
              vertical: AppTheme.spaceMd,
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                textTheme: isZenMode ? Theme.of(context).textTheme.apply(bodyColor: contentColor, displayColor: contentColor) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Dopamine Detox Warning Banner ──
                  _buildDetoxBanner(settings, brightness),

                  // ── Header: Avatar + Greeting + Level ──
                  _buildHeader(context, profileAsync, brightness),
                  const SizedBox(height: AppTheme.spaceLg),

                  // ── Cyber Pet (Hero) ──
                  CyberPetDashboardWidget(isZenMode: isZenMode),
                  const SizedBox(height: AppTheme.spaceLg),

                  // ── Progress Rings ──
                  _buildProgressRings(goalsAsync),
                  const SizedBox(height: AppTheme.spaceLg),

                  // ── Active Cryo-Freezer Banner ──
                  _buildActiveFreezerBanner(brightness),

                  // ── Karma-Debt Alert (visible only when debt > 0) ──
                  KarmaDebtWidget(isZenMode: isZenMode),

                  // ── Daily Status & Social (Grid) ──
                  // We put Streak/No-Spend and Partner in a 2-column grid to save vertical space.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildStreakBanner(profileAsync, brightness),
                            const SizedBox(height: AppTheme.spaceSm),
                            NoSpendChallengeCard(isZenMode: isZenMode),
                            const SizedBox(height: AppTheme.spaceSm),
                            const FlashGoalCard(),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppTheme.spaceSm),
                      const Expanded(
                        child: CyberPartnerCard(),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceXl),

                  // ── Goal Cards ──
                  _buildGoalCards(context, ref, goalsAsync, settings),
                  const SizedBox(height: AppTheme.spaceXl),

                  // ── Daily Quests ──
                  _buildDailyQuestsCard(ref, brightness),
                  const SizedBox(height: AppTheme.spaceLg),

                  // ── Quick Actions ──
                  _buildQuickActions(context),
                  const SizedBox(height: AppTheme.spaceLg),

                  // ── Feature Grid ──
                  _buildFeatureGrid(context),
                  const SizedBox(height: AppTheme.spaceLg),

                  // ── Financial Health (Accordion) ──
                  _buildFinancialAccordion(brightness),
                  const SizedBox(height: AppTheme.spaceLg),

                  // ── Event Banner ──
                  _buildEventBanner(brightness),
                  const SizedBox(height: AppTheme.spaceSm),

                  // ── Penalty Banner ──
                  _buildPenaltyBanner(profileAsync),
                  const SizedBox(height: AppTheme.spaceXxxl), // Extra space for FAB/BottomBar
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spaceXl,
            AppTheme.spaceMd,
            AppTheme.spaceXl,
            AppTheme.spaceLg,
          ),
          child: _buildDepositButton(context),
        ),
      ),
      floatingActionButton: (ref.watch(merchantProvider).isActive && !isZenMode)
          ? NeonPulsatingFab(
              icon: Icons.radar,
              color: Colors.purpleAccent,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const MerchantDialog(),
                );
              },
            )
          : null,
    );
  }

  // ============================================
  // APP BAR
  // ============================================
  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref) {
    final merchantState = ref.watch(merchantProvider);
    final isZenMode = ref.watch(zenModeProvider);

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
            icon: Icon(isZenMode ? Icons.nightlight_round : Icons.self_improvement, color: isZenMode ? Colors.blueGrey : AppColors.accent),
            tooltip: isZenMode ? 'Режим Наблюдателя (Zen Mode)' : 'Перейти в Zen Mode',
            onPressed: () {
                ref.read(zenModeProvider.notifier).toggle();
            },
        ),
        if (merchantState.isActive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.only(right: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.purpleAccent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.radar, color: Colors.purpleAccent, size: 16),
                SizedBox(width: 4),
                Text('Signal Detected', style: TextStyle(color: Colors.purpleAccent, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        IconButton(
          icon: const Icon(Icons.person_outline_rounded),
          onPressed: () => context.push('/avatar-builder'),
          tooltip: t('dash_profile_tooltip'),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded),
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
  ) {
    return profileAsync.when(
      loading: () => const SizedBox(height: 64),
      error: (_, __) => const SizedBox.shrink(),
      data: (profile) {
        if (profile == null) return const SizedBox.shrink();

        final currentLevel = profile.level;
        final currentXp = profile.xp;
        final xpNeeded = XpService.xpRequiredForLevel(currentLevel);
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
                color: hasStreak
                    ? AppColors.warning
                    : AppColors.textTertiary(brightness),
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
              // No-Spend streak badge
              if (profile.noSpendStreakCount > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceSm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF39FF14).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    border: Border.all(color: const Color(0xFF39FF14).withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.shield_rounded,
                        color: Color(0xFF39FF14),
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${profile.noSpendStreakCount}',
                        style: AppTypography.caption(context,
                            color: const Color(0xFF39FF14)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppTheme.spaceSm),
              ],
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

        final ratioA =
            (goalA.currentAmount / goalA.targetAmount).clamp(0.0, 1.0);
        final ratioB =
            (goalB.currentAmount / goalB.targetAmount).clamp(0.0, 1.0);

        return Center(
          child: DualProgressRing(
            progressA: ratioA,
            progressB: ratioB,
            size: 180,
          ),
        );
      },
    );
  }

  // ============================================
  // DEPOSIT CTA
  // ============================================
  Widget _buildDepositButton(BuildContext context) {
    return AppButton(
      label: t('dash_deposit'),
      variant: ButtonVariant.primary,
      icon: const Icon(Icons.add_card_rounded, color: Colors.white),
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
    return GestureDetector(
      onVerticalDragEnd: (details) async {
        if (details.primaryVelocity != null &&
            details.primaryVelocity! < -300) {
          HapticFeedback.heavyImpact();
          if (!context.mounted) return;
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
        onTap: () async {
          final settings = ref.read(settingsServiceProvider);
          if (settings.isHapticEnabled) await HapticsHelper.heartbeat();
          if (context.mounted) context.push('/goal-detail/$1');
        },
        heroTag: heroTag,
        isCiphered: isPrivate,
        secondaryActionLabel: t('goal_price_scanner'),
        secondaryActionIcon: Icons.radar_rounded,
        secondaryActionLoading: _scanningGoalIds.contains(goal.id),
        secondaryActionOnPressed: () {
          HapticFeedback.mediumImpact();
          _onScanPrices(goal);
        },
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
                          ? Colors.green
                          : AppColors.accentMutedBg(brightness),
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                    child: Text(
                      '$completedCount/$1',
                      style: AppTypography.caption(context,
                          color:
                              allDone ? Colors.green : AppColors.accent),
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
              '+$1XP',
              style: AppTypography.caption(context, color: AppColors.accent),
            ),
        ],
      ),
    );
  }

  // ============================================
  // QUICK ACTIONS ROW
  // ============================================
  Widget _buildQuickActions(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      runSpacing: 8.0,
      children: [
        _QuickActionButton(
          icon: Icons.bar_chart_rounded,
          label: 'Отчет 2026',
          color: Colors.amber,
          onTap: () => context.push('/annual-report'),
        ),
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
        _QuickActionButton(
          icon: Icons.ac_unit_rounded,
          label: t('freezer_title'),
          onTap: () => context.push('/freezer'),
        ),
        _QuickActionButton(
          icon: Icons.history_edu_rounded,
          label: t('lend_title'),
          onTap: () => context.push('/lending'),
        ),
        _QuickActionButton(
          icon: Icons.auto_awesome,
          label: t('oracle_title'),
          onTap: () => context.push('/oracle'),
        ),
        _QuickActionButton(
          icon: Icons.bug_report_rounded,
          label: t('karma_report_btn'),
          color: const Color(0xFFFF2A6D),
          onTap: () => ReportRelapseDialog.show(context),
        ),
        _QuickActionButton(
          icon: Icons.subscriptions_rounded,
          label: '🥷 Паразити',
          color: const Color(0xFFFF3B30),
          onTap: () => context.push('/subscriptions'),
        ),
      ],
    );
  }

  // ============================================
  // FEATURE GRID
  // ============================================
  Widget _buildFeatureGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'KIRO FEATURES',
          style: AppTypography.h3(context).copyWith(color: AppColors.accent),
        ),
        const SizedBox(height: AppTheme.spaceMd),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.5,
          children: const [
            FeatureCard(name: 'NECROSPEND', route: '/graveyard', color: Colors.red),
            FeatureCard(name: 'RETAINCORE', route: '/anti-churn', color: Colors.orange),
            FeatureCard(name: 'FUTUREMIRROR', route: '/future-self', color: Colors.cyan),
            FeatureCard(name: 'LOOTBOX', route: '/variable-reward', color: Colors.purple),
            FeatureCard(name: 'BANKLINK', route: '/bank-sync', color: Colors.green),
            FeatureCard(name: 'REPFORGE', route: '/reputation-forge', color: Colors.amber),
            FeatureCard(name: 'SWARMDROP', route: '/flash-mob', color: Colors.cyan),
            FeatureCard(name: 'PARADOX CTRL', route: '/choice-paradox', color: Colors.blueAccent),
            FeatureCard(name: 'NUDGE LAB', route: '/nudge-lab', color: Colors.purpleAccent),
            FeatureCard(name: 'HOLO TROPHIES', route: '/trophy-gallery', color: Colors.yellow),
            FeatureCard(name: 'INFO SCAN', route: '/news-radar', color: Colors.indigo),
            FeatureCard(name: 'PRICE ORACLE', route: '/price-oracle', color: Colors.teal),
            FeatureCard(name: 'RECEIPT RIP', route: '/receipt-scanner', color: Colors.pinkAccent),
            FeatureCard(name: 'CYBER PET', route: '/cyber-pet', color: Colors.lime),
            FeatureCard(name: 'BUDGET HELIX', route: '/budget-dna', color: Colors.greenAccent),
            FeatureCard(name: 'VOICE CRYPT', route: '/voice-vault', color: Colors.cyan),
            FeatureCard(name: 'FUND SWARM', route: '/crowd-fund', color: const Color(0xFF6B00FF)),
            FeatureCard(name: 'AR TAG', route: '/ar-price-tag', color: Colors.tealAccent),
            FeatureCard(name: 'SYNTH WAVE', route: '/soundscapes', color: Colors.purpleAccent),
            FeatureCard(name: 'PRICE SHARK', route: '/price-shark', color: Colors.blueAccent),
            FeatureCard(name: 'DROP ROULETTE', route: '/price-roulette', color: Colors.purple),
            FeatureCard(name: 'MATCH BLADE', route: '/price-match', color: Colors.redAccent),
            FeatureCard(name: 'PRE-GUARD', route: '/preorder-guard', color: Colors.cyan),
            FeatureCard(name: 'BONUS CRUNCH', route: '/loyalty-cruncher', color: Colors.orange),
            FeatureCard(name: 'FREEZE RAY', route: '/price-freeze', color: Colors.lightBlueAccent),
            FeatureCard(name: 'WISH RADAR', route: '/wishlist-radar', color: Colors.greenAccent),
            FeatureCard(name: 'ALERT CORE', route: '/smart-alerts', color: Colors.orangeAccent),
            FeatureCard(name: 'PRICE AREНА', route: '/price-arena', color: Colors.redAccent),
            FeatureCard(name: 'PRICE PROPHET', route: '/price-prophet', color: Colors.purpleAccent),
            FeatureCard(name: 'RE-GEAR', route: '/secondhand-analyzer', color: Colors.tealAccent),
            FeatureCard(name: 'SEASON PULSE', route: '/seasonal-calendar', color: Colors.deepOrangeAccent),
            FeatureCard(name: 'MOMENTUM', route: '/price-momentum', color: Colors.cyan),
            FeatureCard(name: 'PRICE WAR', route: '/price-war', color: Colors.redAccent),
            FeatureCard(name: 'HAGGLE AI', route: '/haggling-coach', color: Colors.purpleAccent),
            FeatureCard(name: 'FLEX PRICE', route: '/price-elasticity', color: Colors.amberAccent),
            FeatureCard(name: 'STOCK GHOST', route: '/inventory-stalker', color: Colors.white70),
            FeatureCard(name: 'LOAN TRACKER', route: '/lending-tracker', color: Colors.lightGreenAccent),
            FeatureCard(name: 'GOAL SYNC', route: '/goal-price-integrator', color: Colors.blueAccent),
            FeatureCard(name: 'HABIT FORGE', route: '/habit-loop-forge', color: Colors.yellowAccent),
            FeatureCard(name: 'INFLA SHIELD', route: '/inflation-shield', color: Colors.deepPurpleAccent),
            FeatureCard(name: 'PRICE EYE', route: '/price-detective', color: Colors.brown),
            FeatureCard(name: 'LINK RIP', route: '/wishlist-link-ripper', color: Colors.indigoAccent),
            FeatureCard(name: 'SHOWROOM SHIELD', route: '/showroom-shield', color: Colors.teal),
            FeatureCard(name: 'CHRONO SAVER', route: '/time-machine', color: Colors.cyanAccent),
            FeatureCard(name: 'QUEST CHAIN', route: '/quest-chain', color: Colors.orangeAccent),
            FeatureCard(name: 'SAGE AI', route: '/sage-coach', color: Color(0xFF7C4DFF)),
            FeatureCard(name: 'INFLA WALL', route: '/infla-wall', color: Colors.greenAccent),
          ],
        ),
      ],
    );
  }


  // ============================================
  // FINANCIAL HEALTH ACCORDION
  // ============================================
  Widget _buildFinancialAccordion(Brightness brightness) {
    return SurfaceCard(
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Remove border line
        ),
        child: ExpansionTile(
          title: Text(
            t('health_title'), // "Financial Health"
            style: AppTypography.h3(context),
          ),
          leading: const Icon(Icons.favorite_rounded, color: AppColors.goalB),
          childrenPadding: const EdgeInsets.only(
            left: AppTheme.spaceLg,
            right: AppTheme.spaceLg,
            bottom: AppTheme.spaceLg,
          ),
          children: [
            _buildFinancialHealth(brightness),
            const SizedBox(height: AppTheme.spaceLg),
            const BankingInsightsCard(),
          ],
        ),
      ),
    );
  }

  // ============================================
  // FINANCIAL HEALTH THERMOMETER
  // ============================================
  Widget _buildFinancialHealth(Brightness brightness) {
    final healthAsync = ref.watch(financialHealthProvider);
    final locale = ref.read(localeProvider);
    String t(String key) => AppLocalizations.get(locale, key);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  style:
                      AppTypography.bodySmall(context, color: AppColors.accent),
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
              IntrinsicWidth(
                child: AppButton(
                  label: t('dash_penalties_btn'),
                  variant: ButtonVariant.ghost,
                  fullWidth: false,
                  onPressed: () => context.push('/penalty-vault'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================
  // DOPAMINE DETOX BANNER
  // ============================================
  Widget _buildDetoxBanner(SettingsService settings, Brightness brightness) {
    if (!settings.isDopamineDetoxActive) return const SizedBox.shrink();

    final until =
        DateTime.fromMillisecondsSinceEpoch(settings.dopamineDetoxUntil);
    final remaining = until.difference(DateTime.now());
    final hoursLeft = remaining.inHours;
    final minutesLeft = remaining.inMinutes % 60;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.do_not_disturb_on_rounded,
                color: AppColors.error,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t('dopamine_detox_title'),
                      style: AppTypography.bodySmall(
                        context,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t('dopamine_detox_subtitle'),
                      style: AppTypography.caption(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spaceSm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Text(
                  '$hoursLeftг ${minutesLeft.toString().padLeft(2, '0')}хв',
                  style: AppTypography.caption(
                    context,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  ZenBreatheDialog.show(context);
                },
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.45),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.radar_rounded,
                        color: AppColors.accent,
                        size: 14,
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        'КІБЕР-МЕДИТАЦІЯ',
                        style: AppTypography.overline(
                          context,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget _buildActiveFreezerBanner(Brightness brightness) {
    final freezerState = ref.watch(freezerProvider);
    if (!freezerState.isLocked) return const SizedBox.shrink();

    final isFinished = freezerState.timeRemaining == Duration.zero;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: Colors.cyan.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: Colors.cyanAccent.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      child: Row(
        children: [
          const Icon(
            Icons.ac_unit_rounded,
            color: Colors.cyanAccent,
            size: 24,
          ),
          const SizedBox(width: AppTheme.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  freezerState.itemName.toUpperCase(),
                  style: AppTypography.bodySmall(context, color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  isFinished ? 'КРІО-БЛОКУВАННЯ ЗАВЕРШЕНО!' : 'ІМПУЛЬС ЗАБЛОКОВАНО: ${formatAmount(freezerState.lockedAmount)} ₴',
                  style: AppTypography.caption(context, color: Colors.cyanAccent),
                ),
              ],
            ),
          ),
          IntrinsicWidth(
            child: AppButton(
              label: t('freezer_title'),
              variant: ButtonVariant.ghost,
              fullWidth: false,
              onPressed: () => context.push('/freezer'),
            ),
          ),
        ],
      ),
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
                ? Colors.green
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
  final Color? color;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
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
                color: color != null
                    ? color!.withValues(alpha: 0.12)
                    : AppColors.surfaceMuted(brightness),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: color != null
                    ? Border.all(color: color!.withValues(alpha: 0.4), width: 1.5)
                    : null,
              ),
              child: Icon(
                icon,
                color: color ?? AppColors.textPrimary(brightness),
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

class _TooltipRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String desc;

  const _TooltipRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodySmall(context).copyWith(fontWeight: FontWeight.bold)),
                Text(desc, style: AppTypography.caption(context, color: AppColors.textSecondary(brightness))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
