import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/particle_background.dart';

class GoalCompleteScreen extends StatefulWidget {
  final String goalName;
  final int targetAmount; // in kopecks
  final String currency;

  const GoalCompleteScreen({
    Key? key,
    required this.goalName,
    required this.targetAmount,
    required this.currency,
  }) : super(key: key);

  @override
  State<GoalCompleteScreen> createState() => _GoalCompleteScreenState();
}

class _GoalCompleteScreenState extends State<GoalCompleteScreen> with SingleTickerProviderStateMixin {
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
            ? AppColors.cyanAccent
            : index % 3 == 1
                ? AppColors.magentaAccent
                : Colors.amberAccent,
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Cyberpunk stars/particles background
          const Positioned.fill(
            child: ParticleBackground(),
          ),

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

          // Glowing vault overlay & text content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Golden glowing badge or vault icon
                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amberAccent.withOpacity(0.3),
                            blurRadius: 40.0,
                            spreadRadius: 5.0,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.amberAccent,
                          width: 3.0,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.workspace_premium_rounded,
                          size: 70,
                          color: Colors.amberAccent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),

                  // Congratulations title
                  Text(
                    'ЦІЛЬ ДОСЯГНУТА!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.orbitronHeading(
                      fontSize: 28.0,
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.bold,
                    ).copyWith(
                      shadows: [
                        const Shadow(
                          color: Colors.amberAccent,
                          blurRadius: 15.0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Goal details summary
                  Text(
                    widget.goalName.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.orbitronHeading(
                      fontSize: 18.0,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Ви успішно накопичили повну суму:\n${formatAmount(widget.targetAmount)} ${widget.currency}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.rajdhaniMedium(
                      fontSize: 16.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  // Achievement bonus banner
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.amberAccent.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.amberAccent.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bolt, color: Colors.amberAccent, size: 24),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'БОНУС ЗОЛОТОГО СЕЙФУ',
                                style: AppTextStyles.orbitronHeading(
                                  fontSize: 11.0,
                                  color: Colors.amberAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3.0),
                              const Text(
                                '+500 XP нараховано до вашого профілю!',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Return to vault
                  NeonButton(
                    text: 'ПОВЕРНУТИСЬ В СЕЙФ',
                    baseColor: Colors.amber,
                    glowColor: Colors.amber,
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
