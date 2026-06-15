import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/app_button.dart';

class GoalCompleteScreen extends ConsumerStatefulWidget {
  final String goalName;
  final int targetAmount; // in kopecks
  final String currency;

  const GoalCompleteScreen({
    super.key,
    required this.goalName,
    required this.targetAmount,
    required this.currency,
  });

  @override
  ConsumerState<GoalCompleteScreen> createState() => _GoalCompleteScreenState();
}

class _GoalCompleteScreenState extends ConsumerState<GoalCompleteScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late List<CelebrationConfetti> _confettiParticles;

  @override
  void initState() {
    super.initState();
    // Play light haptic feedback on launch
    HapticFeedback.vibrate();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Generate confetti explosion particles
    final random = Random();
    _confettiParticles = List.generate(80, (index) {
      return CelebrationConfetti(
        x: 0.5,
        y: 0.8,
        vx: (random.nextDouble() - 0.5) * 3,
        vy: -random.nextDouble() * 4 - 2,
        color: index % 3 == 0
            ? AppColors.accent
            : index % 3 == 1
                ? AppColors.goalB
                : AppColors.warning,
        size: random.nextDouble() * 6 + 4,
        rotation: random.nextDouble() * 2 * pi,
        rotationSpeed: (random.nextDouble() - 0.5) * 0.1,
      );
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      body: Stack(
        children: [
          // Custom celebratory confetti burst overlay
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                // Update confetti particle movements on tick
                for (var particle in _confettiParticles) {
                  particle.update();
                }
                return CustomPaint(
                  painter: ConfettiBurstPainter(particles: _confettiParticles),
                );
              },
            ),
          ),

          // Text content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Achievement badge icon
                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.warning.withValues(alpha: 0.08),
                        border: Border.all(
                          color: AppColors.warning,
                          width: 3.0,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.workspace_premium_rounded,
                          size: 70,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),

                  // Congratulations title
                  Text(
                    AppLocalizations.get(locale, 'goal_complete_title'),
                    textAlign: TextAlign.center,
                    style: AppTypography.h1(context, color: AppColors.warning),
                  ),
                  const SizedBox(height: 16.0),

                  // Goal details summary
                  Text(
                    widget.goalName.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTypography.h2(context),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '${AppLocalizations.get(locale, 'goal_complete_desc')}\n${formatAmount(widget.targetAmount)} ₴',
                    textAlign: TextAlign.center,
                    style: AppTypography.body(
                      context,
                      color: AppColors.textSecondary(brightness),
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  // Achievement bonus banner
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.bolt, color: AppColors.warning, size: 24),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.get(locale, 'goal_complete_bonus'),
                                style: AppTypography.overline(
                                  context,
                                  color: AppColors.warning,
                                ),
                              ),
                              const SizedBox(height: 3.0),
                              Text(
                                AppLocalizations.get(locale, 'goal_complete_bonus_desc'),
                                style: AppTypography.bodySmall(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Return to vault
                  AppButton(
                    label: AppLocalizations.get(locale, 'goal_complete_back'),
                    variant: ButtonVariant.primary,
                    onPressed: () {
                      context.go('/dashboard');
                    },
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CelebrationConfetti {
  double x;
  double y;
  double vx;
  double vy;
  final Color color;
  final double size;
  double rotation;
  final double rotationSpeed;
  final double gravity = 0.08;

  CelebrationConfetti({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
  });

  void update() {
    x += vx * 0.01;
    y += vy * 0.01;
    vy += gravity;
    rotation += rotationSpeed;

    // Bounce off sides
    if (x < 0 || x > 1.0) {
      vx = -vx * 0.8;
    }
  }
}

class ConfettiBurstPainter extends CustomPainter {
  final List<CelebrationConfetti> particles;

  ConfettiBurstPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      if (particle.y < 0 || particle.y > 1.2) continue;

      paint.color = particle.color;
      final px = particle.x * size.width;
      final py = particle.y * size.height;

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(particle.rotation);

      // Draw diamond / square confetti shapes
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: particle.size,
        height: particle.size * 1.5,
      );
      canvas.drawRect(rect, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
