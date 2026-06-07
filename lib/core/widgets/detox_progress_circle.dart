import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// DetoxProgressCircle is an elegant concentric progress arc built for gamified "financial detox".
/// Displays countdown parameters with ambient warning states, neon border glowing gradients and tactile warning limits.
class DetoxProgressCircle extends StatelessWidget {
  final double progress; // Remaining duration percentage (0.0 to 1.0)
  final String timeLabel; // E.g., "14 годин" або "2 дні"
  final double size;

  const DetoxProgressCircle({
    super.key,
    required this.progress,
    required this.timeLabel,
    this.size = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCritical = progress < 0.25; // Warning limit when detox time is running thin

    return RepaintBoundary(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Rotating glowing painter
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: progress.clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutQuart,
              builder: (context, animValue, _) {
                return CustomPaint(
                  size: Size(size, size),
                  painter: _DetoxCirclePainter(
                    progress: animValue,
                    isDark: isDark,
                    isCritical: isCritical,
                  ),
                );
              },
            ),

            // Inner core text info
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ДЕТОКС АКТИВНИЙ',
                  style: AppTypography.overline(context).copyWith(
                    color: isCritical ? AppColors.error : AppColors.accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  timeLabel,
                  style: AppTypography.metric(context).copyWith(
                    fontSize: 28,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'залишилось ${(progress * 100).toInt()}%',
                  style: AppTypography.caption(context).copyWith(
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetoxCirclePainter extends CustomPainter {
  final double progress;
  final bool isDark;
  final bool isCritical;

  _DetoxCirclePainter({
    required this.progress,
    required this.isDark,
    required this.isCritical,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = 14.0;
    final radius = (size.width / 2) - (strokeWidth / 2) - 8.0;
    const startAngle = -math.pi / 2;

    // Conforming active neon color
    final neonColor = isCritical ? AppColors.error : AppColors.accent;

    // Track Paint
    final trackPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.04)
          : Colors.black.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Active Gradient Paint
    final activePaint = Paint()
      ..shader = ui.Gradient.sweep(
        center,
        [
          neonColor.withValues(alpha: 0.2),
          neonColor,
        ],
        [
          0.0,
          1.0,
        ],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw main progress arc
    canvas.save();
    // Rotate canvas so sweep shader aligns correctly with top start angle
    canvas.translate(center.dx, center.dy);
    canvas.rotate(startAngle);
    canvas.translate(-center.dx, -center.dy);
    
    canvas.drawArc(
      rect,
      0.0,
      2 * math.pi * progress,
      false,
      activePaint,
    );
    canvas.restore();

    // Soft Ambient Glow Shadows for maximum cyberpunk depth
    if (isDark) {
      final glowPaint = Paint()
        ..color = neonColor.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 8
        ..imageFilter = ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8);

      canvas.drawArc(
        rect,
        startAngle,
        2 * math.pi * progress,
        false,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DetoxCirclePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isDark != isDark ||
        oldDelegate.isCritical != isCritical;
  }
}
