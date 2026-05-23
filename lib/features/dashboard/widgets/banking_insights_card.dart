import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/banking_provider.dart';
import '../../../core/providers/events_notifier.dart';
import '../../../core/providers/savings_notifier.dart';
import '../../../core/providers/penalty_notifier.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/glass_card.dart';

class BankingInsightsCard extends ConsumerWidget {
  const BankingInsightsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(aiInsightsProvider);

    return insightsAsync.when(
      // --- Loading: VAULT-7 is "thinking" ---
      loading: () => GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        borderColor: AppColors.cyanAccent.withOpacity(0.4),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColors.cyanAccent),
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              'VAULT-7 аналізує транзакцію...',
              style: AppTextStyles.rajdhaniMedium(
                fontSize: 13.0,
                color: AppColors.cyanAccent,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(),

      // --- Error or no data: silent ---
      error: (_, __) => const SizedBox.shrink(),

      // --- Data loaded ---
      data: (insights) {
        if (insights.isEmpty) return const SizedBox.shrink();

        return Column(
          children: insights.map((insight) {
            final isLLM = insight.type == 'cyber_coach';
            final accentColor =
                isLLM ? AppColors.magentaAccent : (insight.type == 'round_up' ? AppColors.cyanAccent : AppColors.goldGlow);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GlassCard(
                padding: const EdgeInsets.all(16.0),
                borderColor: accentColor.withOpacity(0.6),
                glowColor: accentColor.withOpacity(0.15),
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
                            style: AppTextStyles.orbitronHeading(
                              fontSize: isLLM ? 11.0 : 13.0,
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            insight.description,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: AppColors.textSecondary,
                              height: 1.4,
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
                                              '✅ Переказано ${centsToDisplay(insight.suggestedAmountKopecks)} у Сховище!',
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
                                      'ВНЕСТИ ${centsToDisplay(insight.suggestedAmountKopecks)}',
                                      style: AppTextStyles.orbitronHeading(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                IconButton(
                                  icon: const Icon(Icons.close,
                                      color: AppColors.textMuted, size: 18),
                                  onPressed: () {
                                    HapticFeedback.heavyImpact();
                                    
                                    // Issue a penalty when ignoring VAULT-7
                                    if (isLLM || insight.type == 'spending_alert') {
                                      ref.read(penaltyProvider.notifier).issueFine(
                                        'Проігноровано пораду VAULT-17', 
                                        insight.suggestedAmountKopecks
                                      );
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('⚠️ VAULT-17 запам\'ятав це. Цілісність аватара знижено!'),
                                            backgroundColor: Colors.redAccent,
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
              ).animate().slideX(begin: 0.08, end: 0.0, curve: Curves.easeOut).fadeIn(),
            );
          }).toList(),
        );
      },
    );
  }
}
