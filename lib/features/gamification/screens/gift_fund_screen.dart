import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/gift_fund_provider.dart';
import '../widgets/gift_goal_card.dart';

class GiftFundScreen extends ConsumerStatefulWidget {
  const GiftFundScreen({super.key});

  @override
  ConsumerState<GiftFundScreen> createState() => _GiftFundScreenState();
}

class _GiftFundScreenState extends ConsumerState<GiftFundScreen> {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final async = ref.watch(giftFundProvider);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '🎁 Фонд Подарунків',
          style: AppTypography.h3(context),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary(brightness), size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text('Помилка завантаження', style: AppTypography.bodySmall(context)),
        ),
        data: (state) {
          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.card_giftcard_rounded,
                      size: 64, color: AppColors.accent.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text('Ще немає подарунків',
                      style: AppTypography.bodySmall(context, color: AppColors.textSecondary(brightness))),
                  const SizedBox(height: 8),
                  Text('Створіть перший подарунок для близьких',
                      style: AppTypography.caption(context, color: AppColors.textSecondary(brightness))),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            itemCount: state.items.length,
            itemBuilder: (ctx, i) {
              final gift = state.items[i];
              return GiftGoalCard(giftGoal: gift);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/gift-goal-setup'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Новий подарунок'),
      ),
    );
  }
}
