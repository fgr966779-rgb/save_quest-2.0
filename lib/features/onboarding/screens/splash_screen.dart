import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';
import '../../../core/services/biometric_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // Fade in, then navigate after delay
    _controller.forward().then((_) {
      _navigateToNext();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final settings = ref.read(settingsServiceProvider);

    // If biometric is enabled, require authentication before proceeding
    if (settings.isBiometricEnabled && settings.hasCompletedOnboarding) {
      final bio = BiometricService();
      final canAuth = await bio.canEnable();

      if (canAuth && mounted) {
        final locale = ref.read(localeProvider);
        final reason = AppLocalizations.get(locale, 'biometric_auth_reason');
        final success = await bio.authenticate(reason: reason);

        if (!mounted) return;

        if (!success) {
          // Auth failed — show SnackBar and stay on splash (user can retry)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.get(locale, 'biometric_failed'),
                style: AppTypography.bodySmall(context, color: Colors.white),
              ),
              backgroundColor: AppColors.error,
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () => _navigateToNext(),
              ),
            ),
          );
          return;
        }
      }
    }

    if (!mounted) return;

    if (settings.hasCompletedOnboarding) {
      context.go('/dashboard');
    } else {
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Clean icon in accent-colored circle
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.accentMutedBg(brightness),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.savings_rounded,
                  color: AppColors.accent,
                  size: 44,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'PiggyVault',
                style: AppTypography.h1(
                  context,
                  color: AppColors.textPrimary(brightness),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.get(locale, 'onb_splash_tagline'),
                style: AppTypography.bodySmall(
                  context,
                  color: AppColors.textTertiary(brightness),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
