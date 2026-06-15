import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/providers.dart';
import '../../../data/database.dart';

class GiftGoalCard extends ConsumerWidget {
  final GiftGoal giftGoal;

  const GiftGoalCard({super.key, required this.giftGoal});

  String get _occasionLabel {
    switch (giftGoal.occasionType) {
      case 'birthday':
        return '🎂 День народження';
      case 'wedding':
        return '💍 Весільний банкет';
      case 'graduation':
        return '🎓 Випускний';
      case 'anniversary':
        return '❤️ Річниця';
      case 'new_year':
        return '🎄 Новий рік';
      default:
        return '🎁 Особистий подарунок';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final goalsAsync = ref.watch(goalsProvider);

    return goalsAsync.when(
      loading: () => _buildCardSkeleton(context, brightness),
      error: (_, __) => _buildError(context, brightness),
      data: (goals) {
        final goal = goals.firstWhere(
          (g) => g.id == giftGoal.goalId,
          orElse: () => goals.isNotEmpty ? goals.first : throw StateError('no goals'),
        );

        final progress = goal.targetAmount > 0
            ? (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0)
            : 0.0;
        final isCompleted = progress >= 1.0;
        final daysLeft = giftGoal.occasionDate.difference(DateTime.now()).inDays;
        final isUrgent = daysLeft >= 0 && daysLeft <= 14;

        return GestureDetector(
          onTap: () => context.push('/gift-preview/${giftGoal.id}'),
          child: Container(
            margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            decoration: BoxDecoration(
              color: AppColors.surface(brightness),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: isUrgent
                    ? AppColors.accent
                    : AppColors.border(brightness),
                width: isUrgent ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: isUrgent ? 0.18 : 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                      ),
                      child: Center(
                        child: Text(
                          giftGoal.emoji,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spaceSm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            giftGoal.recipientName,
                            style: AppTypography.h3(context, color: AppColors.textPrimary(brightness)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _occasionLabel,
                            style: AppTypography.caption(context, color: AppColors.accent),
                          ),
                        ],
                      ),
                    ),
                    if (isUrgent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                          border: Border.all(color: AppColors.error.withValues(alpha: 0.5)),
                        ),
                        child: Text(
                          'через $daysLeft дн.',
                          style: AppTypography.caption(context, color: AppColors.error),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceSm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.border(brightness),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? AppColors.success : AppColors.accent,
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: AppTheme.spaceSm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Залишилось: ${(progress * 100).toInt()}%',
                      style: AppTypography.caption(context),
                    ),
                    Text(
                      isCompleted
                          ? 'Ціль досягнута ✓'
                          : '${((goal.targetAmount - goal.currentAmount) / 100).toStringAsFixed(0)} ₴ залишилось',
                      style: AppTypography.caption(context, color: AppColors.textSecondary(brightness)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardSkeleton(BuildContext context, Brightness brightness) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface(brightness),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
    );
  }

  Widget _buildError(BuildContext context, Brightness brightness) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface(brightness),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Text('Не вдалося завантажити подарунок', style: AppTypography.bodySmall(context)),
    );
  }
}
