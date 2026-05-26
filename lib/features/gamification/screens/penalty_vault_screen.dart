import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/penalty_notifier.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/savings_notifier.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/neon_avatar_painter.dart';
import '../../../core/models/avatar_config.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';

class PenaltyVaultScreen extends ConsumerWidget {
  const PenaltyVaultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fines = ref.watch(penaltyProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final brightness = Theme.of(context).brightness;
    final currentLocale = ref.watch(localeProvider);
    String t(String key) => AppLocalizations.get(currentLocale, key);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t('penalty_title'),
          style: AppTypography.h3(context, color: AppColors.error),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary(brightness), size: 20),
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
                    SurfaceCard(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: NeonAvatarWidget(config: config, size: 140.0, brightness: brightness),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      isDamaged ? t('penalty_damaged') : t('penalty_stable'),
                      style: AppTypography.h3(
                        context,
                        color: isDamaged ? AppColors.error : AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      AppLocalizations.format(currentLocale, 'penalty_integrity', {'value': '${(config.integrity * 100).toInt()}'}),
                      style: AppTypography.body(context),
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
                  t('penalty_active'),
                  style: AppTypography.h3(context),
                ),
              ),
              const SizedBox(height: 12.0),
              ...fines.map((fine) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: SurfaceCard(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 30),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fine.reason,
                                style: AppTypography.bodySmall(context, color: AppColors.textPrimary(brightness)).copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                AppLocalizations.format(currentLocale, 'penalty_debt', {'amount': centsToDisplay(fine.amountKopecks)}),
                                style: AppTypography.caption(context, color: AppColors.error),
                              ),
                            ],
                          ),
                        ),
                        AppButton(
                          label: t('penalty_pay_btn'),
                          variant: ButtonVariant.secondary,
                          fullWidth: false,
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
                                SnackBar(
                                  content: Text(t('penalty_paid')),
                                  backgroundColor: AppColors.accent,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ] else ...[
              Center(
                child: Text(
                  t('penalty_empty'),
                  textAlign: TextAlign.center,
                  style: AppTypography.caption(context).copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
