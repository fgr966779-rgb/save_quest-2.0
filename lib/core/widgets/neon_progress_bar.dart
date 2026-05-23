import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class NeonProgressBar extends StatelessWidget {
  final double progress; // Between 0.0 and 1.0
  final Color activeColor;
  final Color glowColor;
  final double height;
  final String? label;
  final String? trailingText;

  const NeonProgressBar({
    Key? key,
    required this.progress,
    required this.activeColor,
    required this.glowColor,
    this.height = 10.0,
    this.label,
    this.trailingText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || trailingText != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              if (trailingText != null)
                Text(
                  trailingText!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: activeColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8.0),
        ],
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: clampedProgress),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutCubic,
          builder: (context, animatedValue, child) {
            return Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.cardBgLight,
                borderRadius: BorderRadius.circular(height / 2),
                border: Border.all(color: AppColors.borderNeon, width: 1.0),
              ),
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final activeWidth = constraints.maxWidth * animatedValue;
                      if (activeWidth <= 0) return const SizedBox.shrink();

                      return Container(
                        width: activeWidth,
                        height: height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(height / 2),
                          color: activeColor,
                          boxShadow: [
                            BoxShadow(
                              color: glowColor.withOpacity(0.5),
                              blurRadius: 8.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
