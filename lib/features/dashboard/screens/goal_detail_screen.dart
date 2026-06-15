import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/services/price_tracker_service.dart';
import '../../gamification/widgets/memory_vault_widgets.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/database.dart';
import '../../gamification/widgets/boss_hp_bar.dart';
import '../../gamification/widgets/price_hunter_widget.dart';

class GoalDetailScreen extends ConsumerStatefulWidget {
  final int goalId;
  final String goalStrId;

  const GoalDetailScreen({
    super.key,
    required this.goalId,
  }) : goalStrId = goalId == 0 ? 'goal_a' : 'goal_b';

  const GoalDetailScreen.fromString({
    super.key,
    required String id,
  })  : goalId = id == 'goal_a' ? 0 : 1,
        goalStrId = id;

  @override
  ConsumerState<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends ConsumerState<GoalDetailScreen> {
  bool _isLoading = false;

  Future<void> _onScanPrices(Goal goal) async {
    final locale = ref.read(localeProvider);
    setState(() => _isLoading = true);
    
    try {
      final price = await PriceTrackerService.fetchPrice(goal.name, sku: goal.productUrl);
      
      if (!mounted) return;
      if (price == null) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
             content: Text(AppLocalizations.get(locale, 'price_not_found')),
         ));
         return;
      }
      
      final priceInKopecks = (price * 100).toInt();
      final db = ref.read(databaseProvider);
      final oldTarget = goal.targetAmount;
      
      final diff = (priceInKopecks - oldTarget).abs() / oldTarget;
      
      if (diff > 0.05) {
          final shouldUpdate = await showDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
              title: Text(AppLocalizations.get(locale, 'update_target_title')),
              content: Text(AppLocalizations.format(locale, 'update_target_content', {
                '0': price.toStringAsFixed(0),
                '1': (oldTarget / 100).toStringAsFixed(0)
              })),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(c, false), 
                  child: Text(AppLocalizations.get(locale, 'common_cancel'))
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(c, true), 
                  child: Text(AppLocalizations.get(locale, 'common_save'))
                ),
              ],
            )
          ) ?? false;

          if (shouldUpdate) {
             await db.updateGoal(goal.copyWith(targetAmount: priceInKopecks));
             if (!mounted) return;
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                 content: Text(AppLocalizations.get(locale, 'target_updated'))
             ));
             ref.invalidate(goalsProvider);
          }
       } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.get(locale, 'price_actual'))
          ));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${AppLocalizations.get(locale, 'price_fetch_error')} $e')
      ));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);

    final id = widget.goalId == 0 ? 'goal_a' : (widget.goalId == 1 ? 'goal_b' : widget.goalStrId);
    final isA = id == 'goal_a';
    final accentColor = isA ? AppColors.goalA : AppColors.goalB;

    final goalsAsync = ref.watch(goalsProvider);
    final depositsBreakdown = ref.watch(depositsBreakdownProvider);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      body: SafeArea(
        child: goalsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('${AppLocalizations.get(locale, 'common_error')}: $e', style: const TextStyle(color: Colors.red))),
          data: (goals) {
            final goal = goals.firstWhere(
              (g) => g.id == id,
              orElse: () => Goal(
                id: id,
                name: isA ? AppLocalizations.get(locale, 'dash_goal_a') : AppLocalizations.get(locale, 'dash_goal_b'),
                targetAmount: 1000000,
                currentAmount: 0,
                currency: 'UAH',
                accentColor: isA ? '#00E5FF' : '#FF007F',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                priceShieldHp: 100,
              ),
            );

            final double progressRatio = goal.targetAmount > 0
                ? (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0)
                : 0.0;
            final int progressPercent = (progressRatio * 100).toInt();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, locale, goal, accentColor),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildMainMetrics(context, locale, goal, progressRatio, progressPercent, accentColor),
                        const SizedBox(height: 20.0),
                        _buildProjections(context, locale, goal, depositsBreakdown, accentColor),
                        const SizedBox(height: 16.0),
                        _buildPriceAnalysisLink(context, locale, goal, accentColor),
                        const SizedBox(height: 16.0),
                        PriceHunterWidget(goal: goal, accentColor: accentColor),
                        const SizedBox(height: 16.0),
                        _buildPriceTrackerControls(goal, accentColor),
                        const SizedBox(height: 24.0),
                        MemoryVaultWidget(goalId: goal.id, currentPercent: progressPercent),
                        const SizedBox(height: 24.0),
                        Text(
                          AppLocalizations.get(locale, 'goal_transaction_history'),
                          style: AppTypography.overline(
                            context,
                            color: AppColors.textSecondary(brightness),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        _buildTransactionHistory(context, ref, locale, id, depositsBreakdown, goal.currency, accentColor),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPriceTrackerControls(Goal goal, Color accentColor) {
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.get(ref.read(localeProvider), 'goal_price_scanner'), style: AppTypography.caption(context)),
                Text(
                  goal.currentPrice != null ? '${(goal.currentPrice! / 100).toStringAsFixed(2)} ₴' : 'Нет данных',
                  style: AppTypography.bodySmall(context, color: accentColor),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
          else
            IconButton(
              icon: Icon(Icons.qr_code_scanner_rounded, color: accentColor),
              onPressed: () => _onScanPrices(goal),
              tooltip: AppLocalizations.get(ref.read(localeProvider), 'goal_price_scanner'),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String locale, Goal goal, Color accentColor) {
    final brightness = Theme.of(context).brightness;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary(brightness)),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.get(locale, 'goal_details'),
                  style: AppTypography.overline(context, color: accentColor),
                ),
                Text(
                  goal.name.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.h2(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMetrics(BuildContext context, String locale, Goal goal, double progressRatio, int progressPercent, Color accentColor) {
    final int remaining = (goal.targetAmount - goal.currentAmount).clamp(0, 999999999);
    return SurfaceCard(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.get(locale, 'goal_accumulation_status'),
                style: AppTypography.overline(context, color: accentColor),
              ),
              Text(
                '$progressPercent%',
                style: AppTypography.metric(context, color: accentColor),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricColumn(context, AppLocalizations.get(locale, 'goal_accumulated'), '${formatAmount(goal.currentAmount)} ₴'),
              _buildMetricColumn(context, AppLocalizations.get(locale, 'goal_remaining'), '${formatAmount(remaining)} ₴'),
            ],
          ),
          const SizedBox(height: 16.0),
          _buildMetricColumn(context, AppLocalizations.get(locale, 'goal_target'), '${formatAmount(goal.targetAmount)} ₴'),
          const SizedBox(height: 20.0),
          BossHpBar(
            goalName: goal.name,
            currentAmount: goal.currentAmount / 100.0,
            targetAmount: goal.targetAmount / 100.0,
            currency: goal.currency,
            accentColor: accentColor,
            priceShieldHp: goal.priceShieldHp,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(BuildContext context, String label, String value) {
    final brightness = Theme.of(context).brightness;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption(
            context,
            color: AppColors.textSecondary(brightness),
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: AppTypography.h3(context),
        ),
      ],
    );
  }

  Widget _buildProjections(BuildContext context, String locale, Goal goal, AsyncValue<List<DepositBreakdown>> depositsBreakdown, Color accentColor) {
    final brightness = Theme.of(context).brightness;
    return depositsBreakdown.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (breakdowns) {
        final id = goal.id;
        final filtered = breakdowns.where((b) => b.amountForGoal(id) > 0).toList();
        String forecastText = AppLocalizations.get(locale, 'goal_forecast_need_more');
        if (filtered.isNotEmpty) {
          int totalGoalDeposits = filtered.fold(0, (s, b) => s + b.amountForGoal(id));
          final firstDate = filtered.last.deposit.createdAt;
          final daysRange = DateTime.now().difference(firstDate).inDays.clamp(1, 99999);
          final double avgPerDay = totalGoalDeposits / daysRange;
          if (avgPerDay > 0) {
            final int remaining = (goal.targetAmount - goal.currentAmount).clamp(0, 999999999);
            final remainingDays = (remaining / avgPerDay).ceil();
            forecastText = '${AppLocalizations.get(locale, 'goal_forecast_pace')} ~$remainingDays ${AppLocalizations.get(locale, 'common_days_abbr')}';
          } else {
            forecastText = AppLocalizations.get(locale, 'goal_forecast_first');
          }
        }
        return SurfaceCard(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            children: [
              Icon(Icons.query_stats_rounded, color: accentColor, size: 24.0),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.get(locale, 'goal_analytic_projection'),
                      style: AppTypography.caption(
                        context,
                        color: AppColors.textSecondary(brightness),
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      forecastText,
                      style: AppTypography.bodySmall(context),
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

  Widget _buildTransactionHistory(
    BuildContext context,
    WidgetRef ref,
    String locale,
    String id,
    AsyncValue<List<DepositBreakdown>> depositsBreakdown,
    String currency,
    Color accentColor,
  ) {
    final brightness = Theme.of(context).brightness;
    return depositsBreakdown.when(
      loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
      error: (e, _) => Text('${AppLocalizations.get(locale, 'common_error')}: $e'),
      data: (breakdowns) {
        final filtered = breakdowns.where((b) => b.amountForGoal(id) > 0).toList();
        if (filtered.isEmpty) {
          return SurfaceCard(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Text(
                AppLocalizations.get(locale, 'goal_no_transactions'),
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall(
                  context,
                  color: AppColors.textTertiary(brightness),
                ),
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final breakdown = filtered[index];
            final dep = breakdown.deposit;
            final int amount = breakdown.amountForGoal(id);
            final isDeletable = DateTime.now().difference(dep.createdAt).inHours < 24;
            return Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              decoration: BoxDecoration(
                color: AppColors.surface(brightness),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: AppColors.border(brightness)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                      border: Border.all(color: accentColor.withValues(alpha: 0.4), width: 1.0),
                    ),
                    child: Icon(Icons.arrow_downward_rounded, color: accentColor, size: 20.0),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dep.note ?? AppLocalizations.get(locale, 'goal_deposit_note'),
                          style: AppTypography.bodySmall(context),
                        ),
                        const SizedBox(height: 3.0),
                        Text(
                          _formatDate(dep.createdAt),
                          style: AppTypography.caption(
                            context,
                            color: AppColors.textTertiary(brightness),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '+${formatAmount(amount)} $currency',
                    style: AppTypography.amount(context, color: accentColor),
                  ),
                  if (isDeletable) ...[
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: Icon(Icons.delete_sweep_rounded, color: AppColors.error, size: 20.0),
                      onPressed: () => _confirmDelete(context, ref, dep, amount, id),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPriceAnalysisLink(
      BuildContext context, String locale, Goal goal, Color accentColor) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: () => context.push(
        '/price-analysis',
        extra: {
          'query': goal.name,
          'targetAmount': goal.targetAmount,
          'currency': goal.currency,
        },
      ),
      child: SurfaceCard(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Icon(Icons.radar_rounded, color: accentColor, size: 24.0),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.get(locale, 'goal_price_scanner'),
                    style: AppTypography.caption(
                      context,
                      color: AppColors.textSecondary(Theme.of(context).brightness),
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    '${AppLocalizations.get(locale, 'goal_price_check')}: «\$1»',
                    style: AppTypography.bodySmall(context),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: accentColor, size: 22.0),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.\$1 | ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Deposit deposit,
    int targetAmount,
    String targetGoalId,
  ) async {
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface(brightness),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: AppColors.error, width: 1.5),
          ),
          title: Text(
            AppLocalizations.get(locale, 'goal_reversal_title'),
            style: AppTypography.h3(context, color: AppColors.error),
          ),
          content: Text(
            AppLocalizations.get(locale, 'goal_reversal_confirm'),
            style: AppTypography.bodySmall(context),
          ),
          actions: [
            TextButton(
              child: Text(AppLocalizations.get(locale, 'common_cancel'), style: AppTypography.body(context, color: AppColors.textSecondary(brightness))),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(AppLocalizations.get(locale, 'common_delete'), style: AppTypography.body(context, color: AppColors.error).copyWith(fontWeight: FontWeight.bold)),
              onPressed: () async {
                Navigator.pop(context);
                
                // --- BIOMETRIC VAULT LOCK INTEGRATION ---
                final bool? isAuthorized = await context.push<bool>('/biometric-vault');
                if (isAuthorized != true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Access Denied: Biometric Vault Locked'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }
                
                final db = ref.read(databaseProvider);
                final isA = targetGoalId == 'goal_a';
                await db.softDeleteDepositAndUpdateGoals(
                  depositId: deposit.id,
                  goalAAmount: isA ? targetAmount : 0,
                  goalBAmount: isA ? 0 : targetAmount,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.get(locale, 'goal_reversal_success')),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
