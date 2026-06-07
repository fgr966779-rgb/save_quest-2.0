import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// NeonRadarChart is a high-fidelity cyberpunk skill radar chart.
/// Uses CustomPainter to draw premium neon polygon layers, interactive hubs,
/// and reactive grid scales with 120 FPS compatibility.
class NeonRadarChart extends StatefulWidget {
  final Map<String, double> data; // Skill name -> Value (0.0 to 1.0)
  final List<Color>? colors;

  const NeonRadarChart({
    super.key,
    required this.data,
    this.colors,
  });

  @override
  State<NeonRadarChart> createState() => _NeonRadarChartState();
}

class _NeonRadarChartState extends State<NeonRadarChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(double.infinity, 240),
            painter: _RadarPainter(
              data: widget.data,
              scale: _scaleAnimation.value,
              isDark: isDark,
            ),
          );
        },
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final Map<String, double> data;
  final double scale;
  final bool isDark;

  _RadarPainter({
    required this.data,
    required this.scale,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.75;
    final keys = data.keys.toList();
    final values = data.values.toList();
    final int sides = keys.length;

    if (sides < 3) return;

    final angleStep = (2 * math.pi) / sides;

    // Paints
    final gridPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final axisPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.12)
          : Colors.black.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Draw concentric scale rings (Grid)
    final int levels = 4;
    for (int i = 1; i <= levels; i++) {
      final levelRadius = radius * (i / levels);
      final Path gridPath = Path();

      for (int s = 0; s < sides; s++) {
        final angle = s * angleStep - math.pi / 2;
        final point = Offset(
          center.dx + levelRadius * math.cos(angle),
          center.dy + levelRadius * math.sin(angle),
        );
        if (s == 0) {
          gridPath.moveTo(point.dx, point.dy);
        } else {
          gridPath.lineTo(point.dx, point.dy);
        }
      }
      gridPath.close();
      canvas.drawPath(gridPath, gridPaint);
    }

    // Draw axes & Text Labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int s = 0; s < sides; s++) {
      final angle = s * angleStep - math.pi / 2;
      final tipPoint = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      // Draw Axis Line
      canvas.drawLine(center, tipPoint, axisPaint);

      // Draw Skill text label
      final String label = keys[s];
      final textStyle = GoogleFonts.inter(
        color: isDark ? Colors.white60 : Colors.black54,
        fontWeight: FontWeight.w600,
        fontSize: 10,
      );

      textPainter.text = TextSpan(text: label, style: textStyle);
      textPainter.layout();

      // Label offset logic
      final labelRadius = radius + 15;
      final labelOffset = Offset(
        center.dx + labelRadius * math.cos(angle) - textPainter.width / 2,
        center.dy + labelRadius * math.sin(angle) - textPainter.height / 2,
      );
      textPainter.paint(canvas, labelOffset);
    }

    // Draw Filled Polygon (The Data Layer)
    final Path polygonPath = Path();
    final List<Offset> points = [];

    for (int s = 0; s < sides; s++) {
      final angle = s * angleStep - math.pi / 2;
      final val = values[s] * scale;
      final point = Offset(
        center.dx + radius * val * math.cos(angle),
        center.dy + radius * val * math.sin(angle),
      );
      points.add(point);

      if (s == 0) {
        polygonPath.moveTo(point.dx, point.dy);
      } else {
        polygonPath.lineTo(point.dx, point.dy);
      }
    }
    polygonPath.close();

    // Data Fill Paint with Cyberpunk neon gradient
    final fillPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        radius,
        [
          AppColors.accent.withValues(alpha: 0.4),
          AppColors.legendary.withValues(alpha: 0.15),
        ],
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(polygonPath, fillPaint);

    // Dynamic Outline Neon stroke
    final strokePaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(polygonPath, strokePaint);

    // Draw Hub Nodes (Interactive glow circles on values)
    final nodeInnerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final nodeOutlinePaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var point in points) {
      canvas.drawCircle(point, 4, nodeInnerPaint);
      canvas.drawCircle(point, 4, nodeOutlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.scale != scale ||
        oldDelegate.isDark != isDark ||
        oldDelegate.data != data;
  }
}
