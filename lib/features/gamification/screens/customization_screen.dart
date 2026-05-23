import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../data/database.dart';

class CustomizationScreen extends ConsumerWidget {
  const CustomizationScreen({Key? key}) : super(key: key);

  void _selectTheme(BuildContext context, WidgetRef ref, String theme) async {
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile != null) {
      await db.insertUserProfile(profile.copyWith(currentTheme: theme));
      // ignore: unused_result
      ref.refresh(userProfileProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Тему змінено на $theme!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'КАСТОМІЗАЦІЯ',
          style: AppTextStyles.orbitronHeading(
            fontSize: 18.0,
            color: AppColors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
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
                'КОЛЬОРОВІ ТЕМИ',
                style: AppTextStyles.rajdhaniMedium(fontSize: 16.0, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16.0),
              _buildThemeOption(
                context, ref, 
                id: 'default', 
                name: 'НЕОНОВИЙ КІБЕРПАНК (NEON)', 
                color: AppColors.cyanAccent, 
                isSelected: currentTheme == 'default',
                isUnlocked: true,
              ),
              const SizedBox(height: 12.0),
              _buildThemeOption(
                context, ref, 
                id: 'gold', 
                name: 'ПРЕСТИЖНИЙ ЗОЛОТИЙ (GOLD)', 
                color: AppColors.goldGlow, 
                isSelected: currentTheme == 'gold',
                isUnlocked: unlockedLevel >= 5,
                unlockCondition: 'Досягніть 5-го рівня',
              ),
              const SizedBox(height: 12.0),
              _buildThemeOption(
                context, ref, 
                id: 'crimson', 
                name: 'БАГРЯНИЙ ЖАХ (CRIMSON)', 
                color: Colors.redAccent, 
                isSelected: currentTheme == 'crimson',
                isUnlocked: unlockedLevel >= 10,
                unlockCondition: 'Досягніть 10-го рівня',
              ),
              const SizedBox(height: 32.0),
              
              Text(
                'ПЕРСОНАЛІЗАЦІЯ',
                style: AppTextStyles.rajdhaniMedium(fontSize: 16.0, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16.0),
              
              GestureDetector(
                onTap: () {
                  context.push('/avatar-builder');
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.cardBgLight,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: AppColors.cyanAccent.withOpacity(0.5), width: 1.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: AppColors.cyanAccent.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.face, color: AppColors.cyanAccent),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('RPG АВАТАР', style: AppTextStyles.orbitronHeading(fontSize: 14.0, color: AppColors.cyanAccent)),
                            const Text('Налаштуйте вигляд вашого кібер-робота', style: TextStyle(color: AppColors.textMuted, fontSize: 11.0)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: AppColors.cyanAccent, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, WidgetRef ref, {
    required String id,
    required String name,
    required Color color,
    required bool isSelected,
    required bool isUnlocked,
    String? unlockCondition,
  }) {
    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.5,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.cardBgLight,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: isSelected ? color : AppColors.borderNeon.withOpacity(0.3), width: isSelected ? 2.0 : 1.0),
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
                  Text(name, style: AppTextStyles.orbitronHeading(fontSize: 14.0, color: color)),
                  if (!isUnlocked && unlockCondition != null)
                    Text('Блоковано: $unlockCondition', style: const TextStyle(color: AppColors.textMuted, fontSize: 11.0)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white)
            else if (isUnlocked)
              TextButton(
                onPressed: () => _selectTheme(context, ref, id),
                child: Text('ОБРАТИ', style: TextStyle(color: color)),
              )
            else
              const Icon(Icons.lock, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
