import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/neon_progress_bar.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../data/database.dart';

class GoalDetailScreen extends ConsumerWidget {
  final int goalId; // We support parsing as string keys 'goal_a' or 'goal_b'
  final String goalStrId;

  GoalDetailScreen({
    Key? key,
    required int goalId,
  })  : goalId = goalId,
        goalStrId = goalId == 0 ? 'goal_a' : 'goal_a', // Backwards compatible fallback
        super(key: key);

  // String constructor variant
  const GoalDetailScreen.fromString({
    Key? key,
    required String id,
  })  : goalId = id == 'goal_a' ? 0 : 1,
        goalStrId = id,
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine target ID
    final id = goalId == 0 ? 'goal_a' : (goalId == 1 ? 'goal_b' : goalStrId);
    final isA = id == 'goal_a';
    final accentColor = isA ? AppColors.cyanAccent : AppColors.magentaAccent;

    final goalsAsync = ref.watch(goalsProvider);
    final depositsAsync = ref.watch(depositsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: goalsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
          data: (goals) {
            final goal = goals.firstWhere(
              (g) => g.id == id,
              orElse: () => Goal(
                id: id,
                name: isA ? 'Ціль А' : 'Ціль Б',
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
                _buildHeader(context, goal, accentColor),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Glassmorphic main details
                        _buildMainMetrics(goal, progressRatio, progressPercent, accentColor),
                        const SizedBox(height: 20.0),

                        // Future Projections Panel
                        _buildProjections(goal, depositsAsync, accentColor),
                        const SizedBox(height: 24.0),

                        // Section header
                        Text(
                          'ІСТОРІЯ ТРАНЗАКЦІЙ ЦІЛІ',
                          style: AppTextStyles.orbitronHeading(
                            fontSize: 13.0,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ).copyWith(letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 12.0),

                        // Goal Transaction history list
                        _buildTransactionHistory(context, ref, id, depositsAsync, goal.currency, accentColor),
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

  Widget _buildHeader(BuildContext context, Goal goal, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ДЕТАЛІ КІБЕР-ЦІЛІ',
                  style: AppTextStyles.rajdhaniMedium(fontSize: 11, color: accentColor).copyWith(letterSpacing: 2),
                ),
                Text(
                  goal.name.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.orbitronHeading(fontSize: 18, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMetrics(Goal goal, double progressRatio, int progressPercent, Color accentColor) {
    final int remaining = (goal.targetAmount - goal.currentAmount).clamp(0, 999999999);

    return GlassCard(
      padding: const EdgeInsets.all(20.0),
      borderColor: accentColor.withOpacity(0.3),
      glowColor: accentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'СТАТУС НАКОПИЧЕННЯ',
                style: AppTextStyles.orbitronHeading(fontSize: 12, color: accentColor, fontWeight: FontWeight.bold),
              ),
              Text(
                '$progressPercent%',
                style: AppTextStyles.orbitronHeading(fontSize: 20, color: accentColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricColumn('НАКОПИЧЕНО', '${formatAmount(goal.currentAmount)} ${goal.currency}'),
              _buildMetricColumn('ЗАЛИШИЛОСЬ', '${formatAmount(remaining)} ${goal.currency}'),
            ],
          ),
          const SizedBox(height: 16.0),
          _buildMetricColumn('ФІНАНСОВА МІШЕНЬ', '${formatAmount(goal.targetAmount)} ${goal.currency}'),
          const SizedBox(height: 20.0),
          NeonProgressBar(
            progress: progressRatio,
            activeColor: accentColor,
            glowColor: accentColor,
            height: 8.0,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: AppTextStyles.orbitronHeading(fontSize: 17, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildProjections(Goal goal, AsyncValue<List<Deposit>> depositsAsync, Color accentColor) {
    return depositsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (deposits) {
        final id = goal.id;
        final filtered = deposits.where((d) => id == 'goal_a' ? d.goalAAmount > 0 : d.goalBAmount > 0).toList();

        String forecastText = 'Потрібно більше транзакцій для аналізу прогнозу';
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
            forecastText = 'За поточного темпу (${formatAmount((avgPerDay).round())} ${goal.currency}/день) ціль буде досягнуто через ~$remainingDays дн.';
          } else {
            forecastText = 'Внесіть перший вклад сьогодні для старту прогнозу!';
          }
        }

        return GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          borderColor: AppColors.borderNeon.withOpacity(0.2),
          child: Row(
            children: [
              Icon(Icons.query_stats_rounded, color: accentColor, size: 24.0),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'АНАЛІТИЧНИЙ ПРОГНОЗ ПОТОКУ',
                      style: TextStyle(fontSize: 9.0, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      forecastText,
                      style: const TextStyle(
                        fontSize: 12.0,
                        height: 1.4,
                        color: AppColors.textPrimary,
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

  Widget _buildTransactionHistory(
    BuildContext context,
    WidgetRef ref,
    String id,
    AsyncValue<List<Deposit>> depositsAsync,
    String currency,
    Color accentColor,
  ) {
    return depositsAsync.when(
      loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
      error: (e, _) => Text('Помилка: $e'),
      data: (deposits) {
        final filtered = deposits.where((d) => id == 'goal_a' ? d.goalAAmount > 0 : d.goalBAmount > 0).toList();

        if (filtered.isEmpty) {
          return GlassCard(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Text(
                'Жодних транзакцій за цією ціллю ще не було проведено.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 13.0),
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
                color: AppColors.cardBgLight,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: AppColors.borderNeon.withOpacity(0.4), width: 1.0),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.08),
                      shape: BoxShape.circle,
                      border: Border.all(color: accentColor.withOpacity(0.4), width: 1.0),
                    ),
                    child: Icon(Icons.arrow_downward_rounded, color: accentColor, size: 20.0),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dep.note ?? 'Вклад у Скарбницю',
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3.0),
                        Text(
                          _formatDate(dep.createdAt),
                          style: TextStyle(
                            fontSize: 10.0,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '+${formatAmount(amount)} $currency',
                    style: AppTextStyles.orbitronHeading(
                      fontSize: 14.0,
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isDeletable) ...[
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep_rounded, color: AppColors.magentaAccent, size: 20.0),
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: const BorderSide(color: AppColors.magentaAccent, width: 1.5),
          ),
          title: Text(
            'РЕВЕРСІЯ ТРАНЗАКЦІЇ',
            style: AppTextStyles.orbitronHeading(fontSize: 14.0, color: AppColors.magentaAccent),
          ),
          content: Text(
            'Ви дійсно бажаєте анулювати цей внесок на суму ${formatAmount(targetAmount)}? Це зменшить ваші накопичення за цією ціллю.',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13.0, height: 1.4),
          ),
          actions: [
            TextButton(
              child: const Text('СКАСУВАТИ', style: TextStyle(color: AppColors.textSecondary)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('АНУЛЮВАТИ', style: TextStyle(color: AppColors.magentaAccent, fontWeight: FontWeight.bold)),
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
                    const SnackBar(
                      content: Text('Вклад успішно анульовано!'),
                      backgroundColor: AppColors.magentaAccent,
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
