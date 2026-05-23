import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class SplitSlider extends StatelessWidget {
  final double valueA; // 0.0 to 1.0 (Goal A ratio, Goal B is 1.0 - valueA)
  final String labelA;
  final String labelB;
  final ValueChanged<double> onChanged;

  const SplitSlider({
    Key? key,
    required this.valueA,
    required this.onChanged,
    this.labelA = 'Goal A',
    this.labelB = 'Goal B',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '$percentA%',
                    style: AppTextStyles.orbitronHeading(
                      fontSize: 20.0,
                      color: AppColors.cyanAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    labelB,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '$percentB%',
                    style: AppTextStyles.orbitronHeading(
                      fontSize: 20.0,
                      color: AppColors.magentaAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        // Slider Track
        Stack(
          alignment: Alignment.center,
          children: [
            // Dual gradient background track
            Container(
              height: 8.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.cyanAccent,
                    AppColors.magentaAccent,
                  ],
                ),
              ),
            ),
            // The Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 8.0,
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
                thumbColor: Colors.white,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 12.0,
                  elevation: 6.0,
                  pressedElevation: 10.0,
                ),
                overlayColor: AppColors.cyanAccent.withOpacity(0.2),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
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
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              '100% Goal A',
              style: TextStyle(fontSize: 10.0, color: AppColors.cyanAccent, fontWeight: FontWeight.bold),
            ),
            Text(
              '50/50 Split',
              style: TextStyle(fontSize: 10.0, color: AppColors.textMuted),
            ),
            Text(
              '100% Goal B',
              style: TextStyle(fontSize: 10.0, color: AppColors.magentaAccent, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
