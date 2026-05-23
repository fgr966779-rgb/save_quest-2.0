import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class DualProgressRing extends StatelessWidget {
  final double progressA; // 0.0 to 1.0
  final double progressB; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final double ringSpacing;
  final String centerLabel;

  const DualProgressRing({
    Key? key,
    required this.progressA,
    required this.progressB,
    this.size = 200.0,
    this.strokeWidth = 14.0,
    this.ringSpacing = 12.0,
    this.centerLabel = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final compositeProgress = ((progressA + progressB) / 2.0 * 100).toInt();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Converted concentric rings using CustomPaint and Tween animations
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progressA.clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutQuart,
            builder: (context, valA, _) {
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progressB.clamp(0.0, 1.0)),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOutQuart,
                builder: (context, valB, _) {
                  return CustomPaint(
                    size: Size(size, size),
                    painter: _ConcentricRingPainter(
                      progressA: valA,
                      progressB: valB,
                      strokeWidth: strokeWidth,
                      ringSpacing: ringSpacing,
                    ),
                  );
                },
              );
            },
          ),
          // Inside layout: Metrics
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                centerLabel.isNotEmpty ? centerLabel : 'СПІЛЬНО',
                style: AppTextStyles.rajdhaniMedium(
                  fontSize: 12.0,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                '$compositeProgress%',
                style: AppTextStyles.orbitronHeading(
                  fontSize: 32.0,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.cyanAccent,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(progressA * 100).toInt()}%',
                    style: AppTextStyles.rajdhaniMedium(fontSize: 11, color: AppColors.cyanAccent),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.magentaAccent,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(progressB * 100).toInt()}%',
                    style: AppTextStyles.rajdhaniMedium(fontSize: 11, color: AppColors.magentaAccent),
                  ),
                ],
              )
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

  _ConcentricRingPainter({
    required this.progressA,
    required this.progressB,
    required this.strokeWidth,
    required this.ringSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double startAngle = -math.pi / 2;

    // ----------------------------------------
    // Outer Ring (Goal A - Cyan)
    // ----------------------------------------
    final double outerRadius = (size.width / 2) - (strokeWidth / 2);
    final Rect outerRect = Rect.fromCircle(center: center, radius: outerRadius);

    // Track
    final outerTrackPaint = Paint()
      ..color = AppColors.cyanAccent.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, outerRadius, outerTrackPaint);

    // Glowing Neon Arc Underlay
    if (progressA > 0.005) {
      final outerGlowPaint = Paint()
        ..color = AppColors.cyanAccent.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 4.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);
      canvas.drawArc(outerRect, startAngle, 2 * math.pi * progressA, false, outerGlowPaint);

      // Active Arc
      final outerActivePaint = Paint()
        ..color = AppColors.cyanAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(outerRect, startAngle, 2 * math.pi * progressA, false, outerActivePaint);
    }

    // ----------------------------------------
    // Inner Ring (Goal B - Magenta)
    // ----------------------------------------
    final double innerRadius = outerRadius - strokeWidth - ringSpacing;
    final Rect innerRect = Rect.fromCircle(center: center, radius: innerRadius);

    // Track
    final innerTrackPaint = Paint()
      ..color = AppColors.magentaAccent.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, innerRadius, innerTrackPaint);

    // Glowing Neon Arc Underlay
    if (progressB > 0.005) {
      final innerGlowPaint = Paint()
        ..color = AppColors.magentaAccent.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 4.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);
      canvas.drawArc(innerRect, startAngle, 2 * math.pi * progressB, false, innerGlowPaint);

      // Active Arc
      final innerActivePaint = Paint()
        ..color = AppColors.magentaAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(innerRect, startAngle, 2 * math.pi * progressB, false, innerActivePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConcentricRingPainter oldDelegate) {
    return oldDelegate.progressA != progressA ||
        oldDelegate.progressB != progressB ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.ringSpacing != ringSpacing;
  }
}
