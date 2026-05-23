import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/particle_background.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  late AnimationController _logoController;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _navigateToNext();
  }

  @override
  void dispose() {
    _scanController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final settings = ref.read(settingsServiceProvider);
    if (settings.hasCompletedOnboarding) {
      context.go('/dashboard');
    } else {
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const ParticleBackground(),
          // Central Vault branding with FadeTransition + ScaleTransition
          Center(
            child: FadeTransition(
              opacity: _logoOpacity,
              child: ScaleTransition(
                scale: _logoScale,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90.0,
                      height: 90.0,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cyanAccent, width: 2.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyanAccent.withOpacity(0.4),
                            blurRadius: 16.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.vpn_key_rounded,
                        color: AppColors.cyanAccent,
                        size: 40.0,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      'PIGGYVAULT',
                      style: AppTextStyles.orbitronHeading(
                        fontSize: 28.0,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ).copyWith(letterSpacing: 2.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'СКАРБНИЧКА МРІЇ',
                      style: AppTextStyles.rajdhaniMedium(
                        fontSize: 14.0,
                        color: AppColors.cyanAccent,
                      ).copyWith(letterSpacing: 4.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Cinematic scanning horizontal neon line — thinner (2px) but brighter
          AnimatedBuilder(
            animation: _scanAnimation,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height * _scanAnimation.value,
                left: 0.0,
                right: 0.0,
                child: Container(
                  height: 2.0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cyanAccent.withOpacity(1.0),
                        blurRadius: 10.0,
                        spreadRadius: 3.0,
                      ),
                    ],
                    gradient: const LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.cyanAccent,
                        Colors.white,
                        AppColors.cyanAccent,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
