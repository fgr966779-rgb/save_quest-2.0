import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Clean concentric dual progress rings. No glow, no shimmer.
/// Replaces old DualProgressRing.
class DualProgressRing extends StatelessWidget {
  /// Progress for Goal A (0.0-1.0).
  final double progressA;

  /// Progress for Goal B (0.0-1.0).
  final double progressB;

  /// Overall size of the widget (width and height).
  final double size;

  /// Stroke width of each ring arc.
  final double strokeWidth;

  /// Gap between the outer and inner ring.
  final double ringSpacing;

  /// Label shown above the composite percentage in the center.
  final String centerLabel;

  const DualProgressRing({
    super.key,
    required this.progressA,
    required this.progressB,
    this.size = 200.0,
    this.strokeWidth = 14.0,
    this.ringSpacing = 12.0,
    this.centerLabel = '',
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final compositeProgress = ((progressA + progressB) / 2.0 * 100).toInt();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated concentric rings
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progressA.clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            builder: (context, valA, _) {
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progressB.clamp(0.0, 1.0)),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                builder: (context, valB, _) {
                  return CustomPaint(
                    size: Size(size, size),
                    painter: _ConcentricRingPainter(
                      progressA: valA,
                      progressB: valB,
                      strokeWidth: strokeWidth,
                      ringSpacing: ringSpacing,
                      brightness: brightness,
                    ),
                  );
                },
              );
            },
          ),
          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                centerLabel.isNotEmpty ? centerLabel : 'СПІЛЬНО',
                style: AppTypography.overline(context),
              ),
              const SizedBox(height: 2),
              Text(
                '$compositeProgress%',
                style: AppTypography.metric(context),
              ),
              const SizedBox(height: 4),
              // Individual goal dots
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.goalA,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(progressA * 100).toInt()}%',
                    style: AppTypography.caption(
                      context,
                      color: AppColors.goalA,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.goalB,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(progressB * 100).toInt()}%',
                    style: AppTypography.caption(
                      context,
                      color: AppColors.goalB,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConcentricRingPainter extends CustomPainter {
  final double progressA;
  final double progressB;
  final double strokeWidth;
  final double ringSpacing;
  final Brightness brightness;

  _ConcentricRingPainter({
    required this.progressA,
    required this.progressB,
    required this.strokeWidth,
    required this.ringSpacing,
    required this.brightness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const startAngle = -math.pi / 2;
    final trackColor = AppColors.border(brightness).withOpacity(0.3);

    // ── Outer Ring (Goal A) ──
    final outerRadius = (size.width / 2) - (strokeWidth / 2);
    final outerRect = Rect.fromCircle(center: center, radius: outerRadius);

    // Track
    final outerTrackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, outerRadius, outerTrackPaint);

    // Active arc
    if (progressA > 0.005) {
      final outerActivePaint = Paint()
        ..color = AppColors.goalA
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        outerRect,
        startAngle,
        2 * math.pi * progressA,
        false,
        outerActivePaint,
      );
    }

    // ── Inner Ring (Goal B) ──
    final innerRadius = outerRadius - strokeWidth - ringSpacing;
    final innerRect = Rect.fromCircle(center: center, radius: innerRadius);

    // Track
    final innerTrackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, innerRadius, innerTrackPaint);

    // Active arc
    if (progressB > 0.005) {
      final innerActivePaint = Paint()
        ..color = AppColors.goalB
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        innerRect,
        startAngle,
        2 * math.pi * progressB,
        false,
        innerActivePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ConcentricRingPainter oldDelegate) {
    return oldDelegate.progressA != progressA ||
        oldDelegate.progressB != progressB ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.ringSpacing != ringSpacing ||
        oldDelegate.brightness != brightness;
  }
}
