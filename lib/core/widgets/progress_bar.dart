import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Clean linear progress bar. No glow, no shimmer.
/// Replaces NeonProgressBar.
class ProgressBar extends StatelessWidget {
  /// Progress value between 0.0 and 1.0.
  final double progress;

  /// Fill color. Defaults to AppColors.accent.
  final Color color;

  /// Height of the bar track. Defaults to 6.
  final double height;

  /// Optional label shown above-left of the bar.
  final String? label;

  /// Optional trailing text shown above-right of the bar.
  final String? trailingText;

  const ProgressBar({
    super.key,
    required this.progress,
    this.color = AppColors.accent,
    this.height = 6,
    this.label,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || trailingText != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: AppTypography.caption(context),
                  ),
                if (trailingText != null)
                  Text(
                    trailingText!,
                    style: AppTypography.caption(
                      context,
                      color: color,
                    ),
                  ),
              ],
            ),
          ),
        ],
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: clampedProgress),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (context, animatedValue, child) {
            return Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted(brightness),
                borderRadius: BorderRadius.circular(height / 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(height / 2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: animatedValue,
                    child: Container(
                      height: height,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(height / 2),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
