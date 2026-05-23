import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/particle_background.dart';
import '../../../core/widgets/glass_card.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const ParticleBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 24.0),
                  // App Title
                  Text(
                    'PIGGYVAULT',
                    style: AppTextStyles.orbitronHeading(
                      fontSize: 24.0,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ).copyWith(letterSpacing: 2.0),
                  ),
                  const Spacer(),
                  // Animated breathing secure vault graphic — enlarged to 180x180
                  ScaleTransition(
                    scale: _breathingAnimation,
                    child: Container(
                      width: 180.0,
                      height: 180.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.background,
                        border: Border.all(color: AppColors.cyanAccent, width: 2.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyanAccent.withOpacity(0.3),
                            blurRadius: 32.0,
                            spreadRadius: 4.0,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_person_rounded,
                        color: AppColors.cyanAccent,
                        size: 80.0,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Glassmorphic onboarding welcome card with cyan glow
                  GlassCard(
                    padding: const EdgeInsets.all(20.0),
                    glowColor: AppColors.cyanAccent,
                    glowSigma: 16.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Ініціалізувати Протокол',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.orbitronHeading(
                            fontSize: 18.0,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          'Ласкаво просимо в PiggyVault. Це твій персональний кіберпанковий смарт-сейф для накопичень.\n\nСистема дозволяє синхронно відкладати кошти на дві ключові мрії одночасно за допомогою гнучкого динамічного розподілу.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.0,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  // Progress dot indicators with pulse animation for active dot
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(true),
                      _buildDot(false),
                      _buildDot(false),
                      _buildDot(false),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  // Action Button
                  NeonButton(
                    text: 'Розпочати конфігурацію',
                    baseColor: AppColors.cyanAccent,
                    glowColor: AppColors.cyanAccent,
                    onPressed: () {
                      context.go('/onboarding-a');
                    },
                  ),
                  const SizedBox(height: 12.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    if (isActive) {
      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: 24.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: AppColors.cyanAccent,
              borderRadius: BorderRadius.circular(4.0),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyanAccent.withOpacity(0.3 * _pulseAnimation.value),
                  blurRadius: 6.0 * _pulseAnimation.value,
                  spreadRadius: 1.0 * _pulseAnimation.value,
                ),
              ],
            ),
          );
        },
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: AppColors.textMuted.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}
