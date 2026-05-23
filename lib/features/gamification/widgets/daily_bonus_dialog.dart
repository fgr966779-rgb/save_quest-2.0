import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/daily_bonus_provider.dart';

class DailyBonusDialog extends ConsumerStatefulWidget {
  const DailyBonusDialog({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.8),
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
    final dailyStateAsync = ref.watch(dailyBonusProvider);
    
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
                  colors: const [AppColors.goldAccent, AppColors.cyanAccent, AppColors.magentaAccent],
                ),
                Container(
                  width: 320,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.borderNeon, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cyanGlow,
                        blurRadius: 20,
                        spreadRadius: -5,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_month_rounded, size: 48, color: AppColors.cyanAccent)
                          .animate(onPlay: (controller) => controller.repeat())
                          .shimmer(duration: 2000.ms, color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        'ЩОДЕННА ВИНАГОРОДА',
                        style: AppTextStyles.orbitronHeading(fontSize: 20).copyWith(color: AppColors.textPrimary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '🔥 Стрік: ${state.currentBonusStreak} днів',
                        style: AppTextStyles.interBody(fontSize: 14).copyWith(color: AppColors.streakFireYellow),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        decoration: BoxDecoration(
                          color: AppColors.cardBgLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.goldAccent.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.diamond_rounded, color: AppColors.goldAccent, size: 28),
                            const SizedBox(width: 8),
                            Text(
                              '+${state.bonusAmountForToday}',
                              style: AppTextStyles.orbitronHeading(fontSize: 32).copyWith(color: AppColors.goldAccent),
                            ),
                          ],
                        ),
                      ).animate().scale(delay: 300.ms, duration: 400.ms, curve: Curves.easeOutBack),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _claimed ? null : _claim,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.cyanAccent,
                            foregroundColor: AppColors.background,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: _claimed ? 0 : 8,
                            shadowColor: AppColors.cyanGlow,
                          ),
                          child: Text(
                            _claimed ? 'Отримано!' : 'Забрати',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.cyanAccent)),
      error: (e, st) => Center(child: Text('Помилка: $e', style: const TextStyle(color: Colors.red))),
    );
  }
}
