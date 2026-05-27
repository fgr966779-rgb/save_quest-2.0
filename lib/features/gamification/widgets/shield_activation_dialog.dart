import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/providers/l10n.dart';

class ShieldActivationDialog extends StatelessWidget {
  final int daysSaved;

  const ShieldActivationDialog({super.key, required this.daysSaved});

  static void show(BuildContext context, int daysSaved) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return ShieldActivationDialog(daysSaved: daysSaved);
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final container = ProviderScope.containerOf(context);
    final locale = container.read(localeProvider);
    String t(String key) => AppLocalizations.get(locale, key);

    final brightness = Theme.of(context).brightness;

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: SurfaceCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(24),
          borderRadius: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.security_rounded,
                size: 56,
                color: AppColors.accent,
              ),
              const SizedBox(height: 16),
              Text(
                t('shield_title'),
                style: AppTypography.h2(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                t('shield_desc'),
                style: AppTypography.body(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.accentMutedBg(brightness),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppLocalizations.format(locale, 'shield_used', {'count': '$daysSaved'}),
                  style: AppTypography.body(
                    context,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: t('shield_btn'),
                variant: ButtonVariant.secondary,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
