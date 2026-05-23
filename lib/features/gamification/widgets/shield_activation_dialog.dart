import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class ShieldActivationDialog extends StatelessWidget {
  final int daysSaved;

  const ShieldActivationDialog({Key? key, required this.daysSaved}) : super(key: key);

  static void show(BuildContext context, int daysSaved) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withOpacity(0.8),
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
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.blueAccent, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.blueAccent.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: -5,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.security_rounded, size: 56, color: AppColors.blueAccent)
                  .animate()
                  .scale(duration: 400.ms, curve: Curves.easeOutBack)
                  .shimmer(duration: 1500.ms, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                'Стрік Врятовано!',
                style: AppTextStyles.orbitronHeading(fontSize: 20).copyWith(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Ваш Shield (кріо-токен) автоматично захистив прогрес.',
                style: AppTextStyles.interBody(fontSize: 14).copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.cardBgLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Використано Shield: $daysSaved шт.',
                  style: AppTextStyles.rajdhaniMedium(fontSize: 14).copyWith(color: AppColors.blueAccent),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.blueAccent,
                    side: const BorderSide(color: AppColors.blueAccent, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Супер!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
