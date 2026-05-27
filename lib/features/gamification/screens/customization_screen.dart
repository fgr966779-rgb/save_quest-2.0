import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';

class CustomizationScreen extends ConsumerWidget {
  const CustomizationScreen({super.key});

  void _selectTheme(BuildContext context, WidgetRef ref, String theme) async {
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    final currentLocale = ref.read(localeProvider);
    if (profile != null) {
      await db.insertUserProfile(profile.copyWith(currentTheme: theme));
      // ignore: unused_result
      ref.refresh(userProfileProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.format(currentLocale, 'custom_theme_saved', {'theme': theme}))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          t('custom_title'),
          style: AppTypography.h2(context),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary(brightness), size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: profileAsync.when(
        data: (profile) {
          final currentTheme = profile?.currentTheme ?? 'default';
          final unlockedLevel = profile?.level ?? 1;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                t('custom_colors'),
                style: AppTypography.body(context),
              ),
              const SizedBox(height: 16.0),
              _buildThemeOption(
                context,
                ref,
                id: 'default',
                name: t('custom_theme_neon'),
                color: AppColors.accent,
                isSelected: currentTheme == 'default',
                isUnlocked: true,
                locale: currentLocale,
              ),
              const SizedBox(height: 12.0),
              _buildThemeOption(
                context,
                ref,
                id: 'gold',
                name: t('custom_theme_gold'),
                color: AppColors.warning,
                isSelected: currentTheme == 'gold',
                isUnlocked: unlockedLevel >= 5,
                unlockCondition: t('custom_unlock_level_5'),
                locale: currentLocale,
              ),
              const SizedBox(height: 12.0),
              _buildThemeOption(
                context,
                ref,
                id: 'crimson',
                name: t('custom_theme_crimson'),
                color: AppColors.error,
                isSelected: currentTheme == 'crimson',
                isUnlocked: unlockedLevel >= 10,
                unlockCondition: t('custom_unlock_level_10'),
                locale: currentLocale,
              ),
              const SizedBox(height: 32.0),
              
              Text(
                t('custom_personal'),
                style: AppTypography.body(context),
              ),
              const SizedBox(height: 16.0),
              
              GestureDetector(
                onTap: () {
                  context.push('/avatar-builder');
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted(brightness),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: AppColors.border(brightness)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: AppColors.accentMutedBg(brightness),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.face, color: AppColors.accent),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t('custom_avatar_link'), style: AppTypography.h3(context, color: AppColors.accent)),
                            Text(t('custom_avatar_desc'), style: AppTypography.bodySmall(context)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: AppColors.textTertiary(brightness), size: 16),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${t('common_error')}: $e')),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref, {
    required String id,
    required String name,
    required Color color,
    required bool isSelected,
    required bool isUnlocked,
    String? unlockCondition,
    required String locale,
  }) {
    final brightness = Theme.of(context).brightness;
    String t(String key) => AppLocalizations.get(locale, key);

    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.5,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted(brightness),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected ? color : AppColors.border(brightness),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTypography.h3(context, color: color)),
                  if (!isUnlocked && unlockCondition != null)
                    Text('${t('custom_locked')}$unlockCondition', style: AppTypography.bodySmall(context)),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: color)
            else if (isUnlocked)
              TextButton(
                onPressed: () => _selectTheme(context, ref, id),
                child: Text(t('custom_select_btn'), style: TextStyle(color: color)),
              )
            else
              Icon(Icons.lock, color: AppColors.textTertiary(brightness)),
          ],
        ),
      ),
    );
  }
}
