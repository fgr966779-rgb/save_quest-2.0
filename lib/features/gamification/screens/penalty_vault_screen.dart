import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/penalty_notifier.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/savings_notifier.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/neon_avatar_painter.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/glass_card.dart';

class PenaltyVaultScreen extends ConsumerWidget {
  const PenaltyVaultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fines = ref.watch(penaltyProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'ШТРАФНИЙ ІЗОЛЯТОР',
          style: AppTextStyles.orbitronHeading(
            fontSize: 18.0,
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Damaged Avatar Display
            profileAsync.when(
              data: (profile) {
                final config = profile?.avatarConfig != null 
                    ? AvatarConfig.fromJson(profile!.avatarConfig!) 
                    : const AvatarConfig();
                
                final isDamaged = config.integrity < 1.0;

                return Column(
                  children: [
                    GlassCard(
                      padding: const EdgeInsets.all(24.0),
                      borderColor: isDamaged ? Colors.redAccent : AppColors.cyanAccent,
                      glowColor: isDamaged ? Colors.redAccent.withOpacity(0.3) : AppColors.cyanAccent.withOpacity(0.3),
                      child: Center(
                        child: NeonAvatarWidget(config: config, size: 140.0),
                      ).animate(target: isDamaged ? 1 : 0).shake(hz: 8),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      isDamaged ? '⚠️ СИСТЕМУ ПОШКОДЖЕНО ⚠️' : 'СИСТЕМА СТАБІЛЬНА',
                      style: AppTextStyles.rajdhaniMedium(
                        fontSize: 16.0,
                        color: isDamaged ? Colors.redAccent : AppColors.cyanAccent,
                      ).copyWith(letterSpacing: 2.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Цілісність: ${(config.integrity * 100).toInt()}%',
                      style: const TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 32.0),

            // Active Fines
            if (fines.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'АКТИВНІ КІБЕР-ШТРАФИ',
                  style: AppTextStyles.orbitronHeading(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              ...fines.map((fine) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16.0),
                    borderColor: Colors.redAccent.withOpacity(0.5),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 30),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fine.reason,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Борг: ${centsToDisplay(fine.amountKopecks)}',
                                style: const TextStyle(color: Colors.redAccent, fontSize: 11.0),
                              ),
                            ],
                          ),
                        ),
                        NeonButton(
                          text: 'СПЛАТИТИ',
                          baseColor: Colors.redAccent,
                          glowColor: Colors.transparent,
                          width: 100.0,
                          height: 36.0,
                          onPressed: () async {
                            HapticFeedback.heavyImpact();
                            // Pay fine -> deposit into savings
                            await ref.read(savingsNotifierProvider.notifier).createDeposit(
                              amount: fine.amountKopecks / 100.0,
                              goalAPercent: 50.0,
                            );
                            await ref.read(penaltyProvider.notifier).payFine(fine.id);
                            
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Штраф сплачено. Цілісність відновлюється.'),
                                  backgroundColor: AppColors.cyanAccent,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideX(),
                );
              }).toList(),
            ] else ...[
              const Center(
                child: Text(
                  'У вас немає активних штрафів.\nVAULT-17 задоволений вашою дисципліною.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12.0, fontStyle: FontStyle.italic),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
