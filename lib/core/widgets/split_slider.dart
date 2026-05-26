import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../theme/app_theme.dart';

/// Clean allocation slider between two goals.
/// Replaces old SplitSlider. No Orbitron font.
class SplitSlider extends StatelessWidget {
  /// Ratio for Goal A (0.0-1.0). Goal B gets 1.0 - valueA.
  final double valueA;
  final String labelA;
  final String labelB;
  final ValueChanged<double> onChanged;

  const SplitSlider({
    super.key,
    required this.valueA,
    required this.onChanged,
    this.labelA = 'Ціль А',
    this.labelB = 'Ціль Б',
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final percentA = (valueA * 100).toInt();
    final percentB = 100 - percentA;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Percent labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labelA,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption(context),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$percentA%',
                    style: AppTypography.metric(
                      context,
                      color: AppColors.goalA,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    labelB,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption(context),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$percentB%',
                    style: AppTypography.metric(
                      context,
                      color: AppColors.goalB,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Slider with gradient track
        Stack(
          alignment: Alignment.center,
          children: [
            // Gradient track background
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  colors: [
                    brightness == Brightness.dark
                        ? AppColors.goalADark
                        : AppColors.goalAMuted,
                    brightness == Brightness.dark
                        ? AppColors.goalBDark
                        : AppColors.goalBMuted,
                  ],
                ),
              ),
            ),
            // Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 8,
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
                thumbColor: Colors.white,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 12,
                  elevation: 2,
                  pressedElevation: 4,
                ),
                overlayColor: AppColors.accent.withOpacity(0.1),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              ),
              child: Slider(
                value: valueA,
                min: 0.0,
                max: 1.0,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Bottom labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '100% Ціль А',
              style: AppTypography.overline(
                context,
                color: AppColors.goalA,
              ),
            ),
            Text(
              '50/50',
              style: AppTypography.overline(context),
            ),
            Text(
              '100% Ціль Б',
              style: AppTypography.overline(
                context,
                color: AppColors.goalB,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
