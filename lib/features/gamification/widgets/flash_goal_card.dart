import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../providers/flash_goal_provider.dart';

class FlashGoalCard extends ConsumerWidget {
  const FlashGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(flashGoalProvider);
    final locale = ref.watch(localeProvider);
    String t(String key) => AppLocalizations.get(locale, key);

    // Listen for completion to trigger haptics
    ref.listen<FlashGoalState>(flashGoalProvider, (previous, next) {
      if (previous != null && !previous.isCompleted && next.isCompleted) {
        HapticFeedback.mediumImpact();
      }
    });

    final targetDisplay = (state.targetAmount / 100).toStringAsFixed(0);
    final currentDisplay = (state.currentAmount / 100).toStringAsFixed(0);
    final progress = state.targetAmount > 0 
        ? (state.currentAmount / state.targetAmount).clamp(0.0, 1.0) 
        : 0.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: state.isCompleted 
            ? AppColors.success.withValues(alpha: 0.15) 
            : const Color(0xFF1E1E2C), // dark surface
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: state.isCompleted 
              ? AppColors.success.withValues(alpha: 0.5) 
              : Colors.amberAccent.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: state.isCompleted
            ? [BoxShadow(color: AppColors.success.withValues(alpha: 0.2), blurRadius: 10)]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    state.isCompleted ? Icons.check_circle_rounded : Icons.flash_on_rounded,
                    color: state.isCompleted ? AppColors.success : Colors.amberAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.isCompleted 
                          ? t('flash_goal_completed') 
                          : t('flash_goal_desc').replaceAll('%s', targetDisplay),
                      style: AppTypography.bodySmall(context,
                          color: state.isCompleted ? AppColors.success : Colors.white),
                    ),
                  ),
                  if (!state.isCompleted)
                    Text(
                      '$currentDisplay / $targetDisplay',
                      style: AppTypography.caption(context, color: Colors.white70),
                    ),
                ],
              ),
              if (!state.isCompleted) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    builder: (context, val, child) {
                      return LinearProgressIndicator(
                        value: val,
                        backgroundColor: Colors.black26,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.amberAccent),
                        minHeight: 6,
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
