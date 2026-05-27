import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/widgets/surface_card.dart';
import '../models/reward_model.dart';

class TrophyRoomScreen extends ConsumerWidget {
  const TrophyRoomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlockedAsync = ref.watch(unlockedAchievementsProvider);
    final currentLocale = ref.watch(localeProvider);
    final brightness = Theme.of(context).brightness;
    String t(String key) => AppLocalizations.get(currentLocale, key);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                t('ach_header'),
                style: AppTypography.caption(
                  context,
                  color: AppColors.accent,
                ).copyWith(letterSpacing: 2.0),
              ),
              Text(
                t('ach_title'),
                style: AppTypography.h2(context),
              ),
              const SizedBox(height: 16.0),

              // Skill Tree shortcut banner
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  context.push('/skill-tree');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface(brightness),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.warning),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.warningMuted,
                          border: Border.all(color: AppColors.warning),
                        ),
                        child: const Icon(Icons.account_tree_rounded, color: AppColors.warning, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t('ach_skill_tree'),
                              style: AppTypography.overline(context, color: AppColors.warning),
                            ),
                            const SizedBox(height: 2),
                            Text(t('ach_skill_desc'),
                                style: AppTypography.caption(context)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: AppColors.warning),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Grid of achievements
              Expanded(
                child: unlockedAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(
                    child: Text('${AppLocalizations.get(currentLocale, 'common_error')}: $err', style: AppTypography.body(context, color: AppColors.error)),
                  ),
                  data: (unlockedList) {
                    final Set<String> unlockedIds = unlockedList.map((badge) => badge.id).toSet();
                    final int count = unlockedIds.length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Progression summary badge
                        SurfaceCard(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t('ach_unlocked'),
                                    style: AppTypography.overline(
                                      context,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    t('ach_unlocked_desc'),
                                    style: AppTypography.caption(context),
                                  ),
                                ],
                              ),
                              Text(
                                '$count / 18',
                                style: AppTypography.metric(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // Trophy Grid
                        Expanded(
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.0,
                              mainAxisSpacing: 12.0,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: allRewards.length,
                            itemBuilder: (context, index) {
                              final reward = allRewards[index];
                              final bool isUnlocked =
                                  unlockedIds.contains(reward.id);
                              return _buildTrophyCard(
                                  context, reward, isUnlocked, t, ref);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrophyCard(BuildContext context, Reward reward, bool isUnlocked,
      String Function(String) t, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    Color rarityColor = AppColors.textTertiary(brightness);
    if (isUnlocked) {
      switch (reward.rarity) {
        case RewardRarity.common:
          rarityColor = AppColors.accent;
          break;
        case RewardRarity.rare:
          rarityColor = AppColors.goalB;
          break;
        case RewardRarity.epic:
          rarityColor = AppColors.warning;
          break;
        case RewardRarity.legendary:
          rarityColor = AppColors.legendary;
          break;
      }
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showAchievementDetailSheet(context, reward, isUnlocked, t, ref);
      },
      child: SurfaceCard(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon / Emoji (with opacity if locked)
            Opacity(
              opacity: isUnlocked ? 1.0 : 0.25,
              child: Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: isUnlocked ? rarityColor.withValues(alpha: 0.1) : AppColors.surfaceMuted(brightness),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isUnlocked ? rarityColor : AppColors.border(brightness),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    reward.icon,
                    style: const TextStyle(fontSize: 32.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12.0),

            // Reward Title
            Text(
              reward.getTitle(ref.watch(localeProvider)).toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.overline(
                context,
                color: isUnlocked
                    ? AppColors.textPrimary(brightness)
                    : AppColors.textSecondary(brightness),
              ),
            ),
            const SizedBox(height: 4.0),

            // Rarity Label
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? rarityColor.withValues(alpha: 0.1)
                    : AppColors.surfaceMuted(brightness),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                isUnlocked ? reward.rarity.name.toUpperCase() : t('ach_locked'),
                style: AppTypography.overline(
                  context,
                  color: isUnlocked
                      ? rarityColor
                      : AppColors.textSecondary(brightness),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAchievementDetailSheet(BuildContext context, Reward reward,
      bool isUnlocked, String Function(String) t, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: AppColors.surface(brightness),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
            border: Border.all(color: AppColors.border(brightness), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 50.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary(brightness).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // Giant emoji badge
              Center(
                child: Text(
                  reward.icon,
                  style: const TextStyle(
                    fontSize: 64.0,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              Text(
                reward.getTitle(ref.watch(localeProvider)).toUpperCase(),
                textAlign: TextAlign.center,
                style: AppTypography.h2(context),
              ),
              const SizedBox(height: 6.0),
              Text(
                reward.rarity.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: AppTypography.overline(
                  context,
                  color: isUnlocked
                      ? AppColors.accent
                      : AppColors.textSecondary(brightness),
                ),
              ),
              const SizedBox(height: 16.0),

              // Description
              Text(
                reward.getDescription(ref.watch(localeProvider)),
                textAlign: TextAlign.center,
                style: AppTypography.body(context),
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        );
      },
    );
  }
}
