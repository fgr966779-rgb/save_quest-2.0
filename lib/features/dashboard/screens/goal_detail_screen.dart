import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/database.dart';

class GoalDetailScreen extends ConsumerWidget {
  final int goalId; // We support parsing as string keys 'goal_a' or 'goal_b'
  final String goalStrId;

  const GoalDetailScreen({
    super.key,
    required this.goalId,
  }) : goalStrId = goalId == 0 ? 'goal_a' : 'goal_b';

  // String constructor variant
  const GoalDetailScreen.fromString({
    super.key,
    required String id,
  })  : goalId = id == 'goal_a' ? 0 : 1,
        goalStrId = id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);

    // Determine target ID
    final id = goalId == 0 ? 'goal_a' : (goalId == 1 ? 'goal_b' : goalStrId);
    final isA = id == 'goal_a';
    final accentColor = isA ? AppColors.goalA : AppColors.goalB;

    final goalsAsync = ref.watch(goalsProvider);
    final depositsAsync = ref.watch(depositsProvider);

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
                targetAmount: 1000000, // 10 000.00 UAH in kopecks
                currentAmount: 0,
                currency: 'UAH',
                accentColor: isA ? '#00E5FF' : '#FF007F',
                createdAt: DateTime.now(),
              ),
            );

            final double progressRatio = goal.targetAmount > 0
                ? (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0)
                : 0.0;
            final int progressPercent = (progressRatio * 100).toInt();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Custom Navigation Appbar
                _buildHeader(context, locale, goal, accentColor),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Main details card
                        _buildMainMetrics(context, locale, goal, progressRatio, progressPercent, accentColor),
                        const SizedBox(height: 20.0),

                        // Future Projections Panel
                        _buildProjections(context, locale, goal, depositsAsync, accentColor),
                        const SizedBox(height: 16.0),

                        // Price Analysis entry point
                        _buildPriceAnalysisLink(context, locale, goal, accentColor),
                        const SizedBox(height: 24.0),

                        // Section header
                        Text(
                          AppLocalizations.get(locale, 'goal_transaction_history'),
                          style: AppTypography.overline(
                            context,
                            color: AppColors.textSecondary(brightness),
                          ),
                        ),
                        const SizedBox(height: 12.0),

                        // Goal Transaction history list
                        _buildTransactionHistory(context, ref, locale, id, depositsAsync, goal.currency, accentColor),
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
                  style: AppTypography.overline(
                    context,
                    color: accentColor,
                  ),
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
    final brightness = Theme.of(context).brightness;
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
              _buildMetricColumn(context, AppLocalizations.get(locale, 'goal_accumulated'), '${formatAmount(goal.currentAmount)} ${goal.currency}'),
              _buildMetricColumn(context, AppLocalizations.get(locale, 'goal_remaining'), '${formatAmount(remaining)} ${goal.currency}'),
            ],
          ),
          const SizedBox(height: 16.0),
          _buildMetricColumn(context, AppLocalizations.get(locale, 'goal_target'), '${formatAmount(goal.targetAmount)} ${goal.currency}'),
          const SizedBox(height: 20.0),
          ProgressBar(
            progress: progressRatio,
            color: accentColor,
            height: 8.0,
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

  Widget _buildProjections(BuildContext context, String locale, Goal goal, AsyncValue<List<Deposit>> depositsAsync, Color accentColor) {
    final brightness = Theme.of(context).brightness;

    return depositsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (deposits) {
        final id = goal.id;
        final filtered = deposits.where((d) => id == 'goal_a' ? d.goalAAmount > 0 : d.goalBAmount > 0).toList();

        String forecastText = AppLocalizations.get(locale, 'goal_forecast_need_more');
        if (filtered.isNotEmpty) {
          // Calculate average deposit per day (in kopecks)
          int totalGoalDeposits = 0;
          for (var dep in filtered) {
            totalGoalDeposits += id == 'goal_a' ? dep.goalAAmount : dep.goalBAmount;
          }
          final firstDate = filtered.last.createdAt;
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
    AsyncValue<List<Deposit>> depositsAsync,
    String currency,
    Color accentColor,
  ) {
    final brightness = Theme.of(context).brightness;

    return depositsAsync.when(
      loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
      error: (e, _) => Text('${AppLocalizations.get(locale, 'common_error')}: $e'),
      data: (deposits) {
        final filtered = deposits.where((d) => id == 'goal_a' ? d.goalAAmount > 0 : d.goalBAmount > 0).toList();

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
            final dep = filtered[index];
            final int amount = id == 'goal_a' ? dep.goalAAmount : dep.goalBAmount;

            // Check if deletable (editable within 24 hours of creation)
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
        padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
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
                    '${AppLocalizations.get(locale, 'goal_price_check')}: «${goal.name}»',
                    style: AppTypography.bodySmall(context),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: accentColor, size: 22.0),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} | ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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
