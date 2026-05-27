import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/widgets/app_button.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 3),
              // Large clean icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.accentMutedBg(brightness),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_person_rounded,
                  color: AppColors.accent,
                  size: 40,
                ),
              ),
              const SizedBox(height: 32),
              // Title
              Text(
                'PiggyVault',
                style: AppTypography.h1(
                  context,
                  color: AppColors.textPrimary(brightness),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Subtitle
              Text(
                AppLocalizations.get(locale, 'onb_welcome_subtitle'),
                style: AppTypography.body(
                  context,
                  color: AppColors.textSecondary(brightness),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                AppLocalizations.get(locale, 'onb_welcome_desc'),
                style: AppTypography.bodySmall(
                  context,
                  color: AppColors.textTertiary(brightness),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 4),
              // Dot indicators
              _buildDotIndicators(brightness),
              const SizedBox(height: 24),
              // Action button
              AppButton(
                label: AppLocalizations.get(locale, 'onb_start_btn'),
                variant: ButtonVariant.primary,
                onPressed: () {
                  context.go('/onboarding-a');
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDotIndicators(Brightness brightness) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(isActive: true, brightness: brightness),
        const SizedBox(width: 8),
        _buildDot(isActive: false, brightness: brightness),
        const SizedBox(width: 8),
        _buildDot(isActive: false, brightness: brightness),
        const SizedBox(width: 8),
        _buildDot(isActive: false, brightness: brightness),
      ],
    );
  }

  Widget _buildDot({required bool isActive, required Brightness brightness}) {
    return Container(
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.accent : AppColors.border(brightness),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
