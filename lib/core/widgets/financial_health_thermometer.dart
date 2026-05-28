import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Thermometer-style widget showing financial health score (0-100).
/// Uses a CustomPainter to render the thermometer shape with gradient fill.
class FinancialHealthThermometer extends StatelessWidget {
  final double score; // 0.0 - 100.0
  final double width;
  final double height;
  final Brightness brightness;

  const FinancialHealthThermometer({
    super.key,
    required this.score,
    this.width = 48,
    this.height = 200,
    this.brightness = Brightness.light,
  });

  Color get _scoreColor {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.accent;
    if (score >= 40) return AppColors.chartAmber;
    if (score >= 20) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final clampedScore = score.clamp(0.0, 100.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: width + 20,
          height: height + 50,
          child: CustomPaint(
            size: Size(width + 20, height + 50),
            painter: _ThermometerPainter(
              fillFraction: clampedScore / 100.0,
              fillColor: _scoreColor,
              brightness: brightness,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${clampedScore.round()}°',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: _scoreColor,
          ),
        ),
      ],
    );
  }
}

/// Custom painter for thermometer shape.
class _ThermometerPainter extends CustomPainter {
  final double fillFraction; // 0.0 - 1.0
  final Color fillColor;
  final Brightness brightness;

  _ThermometerPainter({
    required this.fillFraction,
    required this.fillColor,
    required this.brightness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // Dimensions
    final tubeWidth = 20.0;
    final tubeTop = 4.0;
    final tubeBottom = h - 36.0;
    final tubeHeight = tubeBottom - tubeTop;
    final bulbRadius = 20.0;
    final bulbCy = h - bulbRadius - 2;

    // Background path (tube + bulb)
    final bgPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx, tubeTop + tubeHeight / 2),
            width: tubeWidth,
            height: tubeHeight),
        const Radius.circular(10),
      ))
      ..addOval(Rect.fromCircle(center: Offset(cx, bulbCy), radius: bulbRadius));

    // Stroke background
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.border(brightness);
    canvas.drawPath(bgPath, bgPaint);

    // Fill background
    final bgFillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.surface(brightness);
    canvas.drawPath(bgPath, bgFillPaint);

    // Fill level
    final fillLevel = tubeHeight * fillFraction.clamp(0.0, 1.0);
    final fillTop = tubeBottom - fillLevel;

    final fillPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx, (fillTop + tubeBottom) / 2),
            width: tubeWidth - 4,
            height: fillLevel),
        const Radius.circular(8),
      ))
      ..addOval(Rect.fromCircle(
          center: Offset(cx, bulbCy), radius: bulbRadius - 2));

    // Gradient fill
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        fillColor.withValues(alpha: 0.6),
        fillColor,
      ],
    );
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(Rect.fromLTWH(0, fillTop, w, fillLevel));
    canvas.drawPath(fillPath, fillPaint);

    // Tick marks
    for (int i = 0; i <= 4; i++) {
      final y = tubeBottom - (tubeHeight * i / 4);
      final tickLeft = cx + tubeWidth / 2 + 2;
      final tickRight = tickLeft + (i.isEven ? 10 : 6);
      canvas.drawLine(
        Offset(tickLeft, y),
        Offset(tickRight, y),
        Paint()
          ..strokeWidth = 1.5
          ..color = AppColors.textTertiary(brightness).withValues(alpha: 0.5),
      );

      // Labels
      if (i.isEven) {
        final label = (i * 25).toString();
        final textPainter = TextPainter(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 9,
              color: AppColors.textTertiary(brightness),
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(tickRight + 3, y - 5));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ThermometerPainter oldDelegate) {
    return oldDelegate.fillFraction != fillFraction ||
        oldDelegate.fillColor != fillColor;
  }
}
