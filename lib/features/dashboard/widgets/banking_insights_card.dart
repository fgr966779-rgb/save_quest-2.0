import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/banking_provider.dart';
import '../../../core/providers/events_notifier.dart';
import '../../../core/providers/savings_notifier.dart';
import '../../../core/providers/penalty_notifier.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/surface_card.dart';

class BankingInsightsCard extends ConsumerWidget {
  const BankingInsightsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);
    final insightsAsync = ref.watch(aiInsightsProvider);

    return insightsAsync.when(
      // --- Loading: VAULT-7 is "thinking" ---
      loading: () => SurfaceCard(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              AppLocalizations.get(locale, 'bank_analyzing'),
              style: AppTypography.bodySmall(
                context,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),

      // --- Error or no data: silent ---
      error: (_, __) => const SizedBox.shrink(),

      // --- Data loaded ---
      data: (insights) {
        if (insights.isEmpty) return const SizedBox.shrink();

        return Column(
          children: insights.map((insight) {
            final isLLM = insight.type == 'cyber_coach';
            final accentColor =
                isLLM ? AppColors.goalB : (insight.type == 'round_up' ? AppColors.accent : AppColors.warning);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: SurfaceCard(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isLLM
                            ? Icons.smart_toy_rounded
                            : (insight.type == 'round_up'
                                ? Icons.auto_awesome
                                : Icons.psychology),
                        color: accentColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14.0),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            insight.title,
                            style: isLLM
                                ? AppTypography.overline(context, color: accentColor)
                                : AppTypography.h3(context, color: accentColor),
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            insight.description,
                            style: AppTypography.bodySmall(
                              context,
                              color: AppColors.textSecondary(brightness),
                            ).copyWith(
                              fontStyle: isLLM ? FontStyle.italic : FontStyle.normal,
                            ),
                          ),

                          if (insight.suggestedAmountKopecks > 0) ...[
                            const SizedBox(height: 12.0),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      HapticFeedback.heavyImpact();
                                      final amount =
                                          insight.suggestedAmountKopecks / 100.0;

                                      ref.read(mockBankingProvider.notifier).clearTransactions();

                                      final activeEvent = ref.read(eventsProvider);

                                      await ref
                                          .read(savingsNotifierProvider.notifier)
                                          .createDeposit(
                                            amount: amount,
                                            goalAPercent: 50.0,
                                            activeEvent: activeEvent,
                                          );

                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              AppLocalizations.get(locale, 'bank_transferred'),
                                            ),
                                            backgroundColor:
                                                accentColor.withOpacity(0.85),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: accentColor,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0)),
                                    ),
                                    child: Text(
                                      '${AppLocalizations.get(locale, 'bank_deposit_btn')} ${centsToDisplay(insight.suggestedAmountKopecks)}',
                                      style: AppTypography.overline(context),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                IconButton(
                                  icon: Icon(Icons.close,
                                      color: AppColors.textTertiary(brightness), size: 18),
                                  onPressed: () {
                                    HapticFeedback.heavyImpact();
                                    
                                    // Issue a penalty when ignoring VAULT-7
                                    if (isLLM || insight.type == 'spending_alert') {
                                      ref.read(penaltyProvider.notifier).issueFine(
                                        AppLocalizations.get(locale, 'bank_ignored'), 
                                        insight.suggestedAmountKopecks
                                      );
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(AppLocalizations.get(locale, 'bank_remembered')),
                                            backgroundColor: AppColors.error,
                                          ),
                                        );
                                      }
                                    }

                                    ref.read(mockBankingProvider.notifier).clearTransactions();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
