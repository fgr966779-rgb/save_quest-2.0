import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/providers/l10n.dart';
import '../providers/daily_bonus_provider.dart';

class DailyBonusDialog extends ConsumerStatefulWidget {
  const DailyBonusDialog({super.key});

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return const DailyBonusDialog();
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
  ConsumerState<DailyBonusDialog> createState() => _DailyBonusDialogState();
}

class _DailyBonusDialogState extends ConsumerState<DailyBonusDialog> {
  late ConfettiController _confettiController;
  bool _claimed = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _claim() async {
    setState(() => _claimed = true);
    _confettiController.play();

    // Call the provider to save to DB
    await ref.read(dailyBonusProvider.notifier).claimBonus();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    String t(String key) => AppLocalizations.get(currentLocale, key);

    final dailyStateAsync = ref.watch(dailyBonusProvider);
    final brightness = Theme.of(context).brightness;

    return dailyStateAsync.when(
      data: (state) {
        final streak = state.currentBonusStreak;
        final amount = state.bonusAmountForToday;

        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  emissionFrequency: 0.05,
                  numberOfParticles: 20,
                  gravity: 0.1,
                  colors: const [
                    AppColors.accent,
                    AppColors.accentLight,
                    AppColors.success,
                  ],
                ),
                SurfaceCard(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(24),
                  borderRadius: 24,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        size: 48,
                        color: AppColors.accent,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        t('daily_bonus_title'),
                        style: AppTypography.h2(context),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.format(currentLocale, 'daily_bonus_streak', {'days': '$streak'}),
                        style: AppTypography.body(
                          context,
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentMutedBg(brightness),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.diamond_rounded,
                              color: AppColors.accent,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '+$amount',
                              style: AppTypography.display(
                                context,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      AppButton(
                        label: _claimed ? t('daily_bonus_claimed') : t('daily_bonus_claim_btn'),
                        variant: ButtonVariant.primary,
                        onPressed: _claimed ? null : _claim,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      ),
      error: (e, st) => Center(
        child: Text(
          '${t('common_error')}: $e',
          style: AppTypography.body(context, color: AppColors.error),
        ),
      ),
    );
  }
}
