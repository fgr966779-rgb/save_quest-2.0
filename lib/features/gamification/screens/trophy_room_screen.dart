import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/widgets/glass_card.dart';
import '../models/achievement_model.dart';

class TrophyRoomScreen extends ConsumerWidget {
  const TrophyRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlockedAsync = ref.watch(unlockedAchievementsProvider);
    final currentLocale = ref.watch(localeProvider);
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
                style: AppTextStyles.rajdhaniMedium(
                  fontSize: 12.0,
                  color: AppColors.cyanAccent,
                ).copyWith(letterSpacing: 2.0),
              ),
              Text(
                t('ach_title'),
                style: AppTextStyles.orbitronHeading(
                  fontSize: 20.0,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),

              // Skill Tree shortcut banner
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  context.push('/skill-tree');
                },
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  borderColor: AppColors.goldGlow.withOpacity(0.4),
                  glowColor: AppColors.goldGlow,
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.goldGlow.withOpacity(0.15),
                          border: Border.all(color: AppColors.goldGlow.withOpacity(0.5)),
                        ),
                        child: const Icon(Icons.account_tree_rounded, color: AppColors.goldGlow, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t('ach_skill_tree'),
                              style: AppTextStyles.orbitronHeading(
                                fontSize: 12, color: AppColors.goldGlow, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(t('ach_skill_desc'),
                                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.goldGlow),
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
                    child: Text('Помилка: $err', style: const TextStyle(color: AppColors.magentaAccent)),
                  ),
                  data: (unlockedList) {
                    final Set<String> unlockedIds = unlockedList.map((badge) => badge.id).toSet();
                    final int count = unlockedIds.length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Progression summary badge
                        GlassCard(
                          padding: const EdgeInsets.all(16.0),
                          borderColor: AppColors.cyanAccent.withOpacity(0.3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t('ach_unlocked'),
                                    style: AppTextStyles.orbitronHeading(
                                      fontSize: 11.0,
                                      color: AppColors.cyanAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    t('ach_unlocked_desc'),
                                    style: const TextStyle(fontSize: 10.0, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                              Text(
                                '$count / 18',
                                style: AppTextStyles.orbitronHeading(
                                  fontSize: 20.0,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
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
                            itemCount: allAchievements.length,
                            itemBuilder: (context, index) {
                              final achievement = allAchievements[index];
                              final bool isUnlocked = unlockedIds.contains(achievement.id);
                              return _buildTrophyCard(context, achievement, isUnlocked, t);
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

  Widget _buildTrophyCard(BuildContext context, Achievement achievement, bool isUnlocked, String Function(String) t) {
    Color rarityColor = Colors.grey;
    if (isUnlocked) {
      switch (achievement.rarity) {
        case AchievementRarity.common:
          rarityColor = Colors.cyanAccent;
          break;
        case AchievementRarity.rare:
          rarityColor = AppColors.magentaAccent;
          break;
        case AchievementRarity.epic:
          rarityColor = Colors.amberAccent;
          break;
        case AchievementRarity.legendary:
          rarityColor = Colors.purpleAccent;
          break;
      }
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showAchievementDetailSheet(context, achievement, isUnlocked, t);
      },
      child: GlassCard(
        padding: const EdgeInsets.all(12.0),
        borderColor: isUnlocked ? rarityColor.withOpacity(0.4) : AppColors.borderNeon.withOpacity(0.15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon / Emoji (with color filter grayscale if locked)
            Opacity(
              opacity: isUnlocked ? 1.0 : 0.25,
              child: Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: isUnlocked ? rarityColor.withOpacity(0.1) : AppColors.cardBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isUnlocked ? rarityColor : AppColors.borderNeon.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    achievement.icon,
                    style: const TextStyle(fontSize: 32.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12.0),

            // Achievement Title
            Text(
              achievement.titleUa.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.orbitronHeading(
                fontSize: 10.0,
                color: isUnlocked ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),

            // Rarity Label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: isUnlocked ? rarityColor.withOpacity(0.15) : AppColors.cardBg.withOpacity(0.4),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                isUnlocked ? achievement.rarity.name.toUpperCase() : t('ach_locked'),
                style: AppTextStyles.orbitronHeading(
                  fontSize: 8.0,
                  color: isUnlocked ? rarityColor : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAchievementDetailSheet(BuildContext context, Achievement achievement, bool isUnlocked, String Function(String) t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
            border: Border.all(color: AppColors.borderNeon.withOpacity(0.3), width: 1.5),
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
                    color: AppColors.textSecondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // Giant emoji badge
              Center(
                child: Text(
                  achievement.icon,
                  style: TextStyle(
                    fontSize: 64.0,
                    shadows: isUnlocked
                        ? [
                            const BoxShadow(
                              color: AppColors.cyanAccent,
                              blurRadius: 20.0,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              Text(
                achievement.titleUa.toUpperCase(),
                textAlign: TextAlign.center,
                style: AppTextStyles.orbitronHeading(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6.0),
              Text(
                achievement.rarity.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: AppTextStyles.orbitronHeading(
                  fontSize: 10.0,
                  color: isUnlocked ? AppColors.cyanAccent : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),

              // Description
              Text(
                achievement.descriptionUa,
                textAlign: TextAlign.center,
                style: AppTextStyles.rajdhaniMedium(fontSize: 14.0, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        );
      },
    );
  }
}
