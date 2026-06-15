import 'dart:math';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/app_button.dart';

/// A celebratory dialog shown when a goal reaches a milestone (25%, 50%, 75%, 100%).
/// Features a custom confetti animation and the milestone percentage.
class MilestoneDialog extends StatefulWidget {
  final String goalName;
  final int percent;
  final VoidCallback? onDismiss;

  const MilestoneDialog({
    super.key,
    required this.goalName,
    required this.percent,
    this.onDismiss,
  });

  /// Show the milestone dialog.
  static Future<void> show(
    BuildContext context, {
    required String goalName,
    required int percent,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => MilestoneDialog(
        goalName: goalName,
        percent: percent,
      ),
    );
  }

  @override
  State<MilestoneDialog> createState() => _MilestoneDialogState();
}

class _MilestoneDialogState extends State<MilestoneDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  late final List<_ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward(from: 0.0);

    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _particles = List.generate(40, (i) => _ConfettiParticle.random());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isFull = widget.percent == 100;
    final accentColor = isFull ? AppColors.legendary : AppColors.accent;

    return Center(
      child: Stack(
        children: [
          // Confetti background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              for (final p in _particles) {
                p.update(_controller.value);
              }
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _MilestoneConfettiPainter(
                  particles: _particles,
                  opacity: _fadeAnim.value,
                ),
              );
            },
          ),
          // Dialog content
          FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(28.0),
                  decoration: BoxDecoration(
                    color: AppColors.surface(brightness),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: accentColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.2),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Icon(
                          isFull
                              ? Icons.emoji_events_rounded
                              : Icons.military_tech_rounded,
                          size: 40,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Title
                      Text(
                        isFull ? '🎯' : '🏅',
                        style: const TextStyle(fontSize: 32),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '\$1%',
                        style: AppTypography.display(context, color: accentColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        widget.goalName,
                        style: AppTypography.h3(context),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        isFull
                            ? 'Ціль досягнута! Вітаємо!'
                            : '\$1% цілі виконано!',
                        style: AppTypography.body(
                          context,
                          color: AppColors.textSecondary(brightness),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24.0),
                      AppButton(
                        label: 'Продовжити',
                        onPressed: () {
                          widget.onDismiss?.call();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple confetti particle for milestone celebration.
class _ConfettiParticle {
  double x, y, vx, vy;
  final Color color;
  final double size;
  double rotation;
  final double rotationSpeed;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
  });

  factory _ConfettiParticle.random() {
    final rng = Random();
    final colors = [
      AppColors.accent,
      AppColors.legendary,
      AppColors.chartBlue,
      AppColors.chartOrange,
      AppColors.chartPurple,
      AppColors.chartAmber,
      AppColors.success,
    ];
    return _ConfettiParticle(
      x: 0.5 + (rng.nextDouble() - 0.5) * 0.3,
      y: 0.3 + (rng.nextDouble() - 0.5) * 0.2,
      vx: (rng.nextDouble() - 0.5) * 0.8,
      vy: -rng.nextDouble() * 0.6 - 0.2,
      color: colors[rng.nextInt(colors.length)],
      size: rng.nextDouble() * 6 + 4,
      rotation: rng.nextDouble() * 6.28,
      rotationSpeed: (rng.nextDouble() - 0.5) * 10,
    );
  }

  void update(double t) {
    x += vx * 0.01;
    y += vy * 0.01;
    vy += 0.008; // gravity
    rotation += rotationSpeed * 0.01;
  }
}

/// Custom painter for milestone confetti.
class _MilestoneConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double opacity;

  _MilestoneConfettiPainter({
    required this.particles,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity * 0.8)
        ..style = PaintingStyle.fill;

      final cx = p.x * size.width;
      final cy = p.y * size.height;
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(p.rotation);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: p.size,
          height: p.size * 0.6,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _MilestoneConfettiPainter oldDelegate) => true;
}
