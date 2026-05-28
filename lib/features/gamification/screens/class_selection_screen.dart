import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_button.dart';

class ClassSelectionScreen extends ConsumerWidget {
  const ClassSelectionScreen({super.key});

  void _selectClass(BuildContext context, WidgetRef ref, String playerClass) async {
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile != null) {
      await db.insertUserProfile(profile.copyWith(playerClass: drift.Value(playerClass)));
      // ignore: unused_result
      ref.refresh(userProfileProvider);
      if (context.mounted) {
        final currentLocale = ref.read(localeProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.get(currentLocale, 'class_changed'))),
        );
        context.pop();
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
          t('class_title'),
          style: AppTypography.h2(context),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary(brightness), size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: profileAsync.when(
        data: (profile) {
          final currentClass = profile?.playerClass ?? 'none';
          
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildClassCard(
                context,
                ref,
                title: t('class_warrior_name'),
                description: t('class_warrior_desc'),
                icon: Icons.shield,
                color: AppColors.accent,
                classId: 'warrior',
                isSelected: currentClass == 'warrior',
                t: t,
              ),
              const SizedBox(height: 16.0),
              _buildClassCard(
                context,
                ref,
                title: t('class_mage_name'),
                description: t('class_mage_desc'),
                icon: Icons.auto_awesome,
                color: AppColors.goalB,
                classId: 'mage',
                isSelected: currentClass == 'mage',
                t: t,
              ),
              const SizedBox(height: 16.0),
              _buildClassCard(
                context,
                ref,
                title: t('class_rogue_name'),
                description: t('class_rogue_desc'),
                icon: Icons.speed,
                color: AppColors.success,
                classId: 'rogue',
                isSelected: currentClass == 'rogue',
                t: t,
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(t('common_error'), style: const TextStyle(color: AppColors.error))),
      ),
    );
  }

  Widget _buildClassCard(
    BuildContext context, 
    WidgetRef ref, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String classId,
    required bool isSelected,
    required String Function(String) t,
  }) {
    final brightness = Theme.of(context).brightness;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.accentMutedBg(brightness) : AppColors.surface(brightness),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isSelected ? color : AppColors.border(brightness),
          width: isSelected ? 2.0 : 1.0,
        ),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 36.0),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.h2(context, color: color),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: color, size: 28.0),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            description,
            style: AppTypography.body(context),
          ),
          const SizedBox(height: 20.0),
          if (!isSelected)
            AppButton(
              label: t('class_choose_btn'),
              variant: ButtonVariant.primary,
              onPressed: () => _selectClass(context, ref, classId),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: Text(
                  t('class_current'),
                  style: AppTypography.body(context, color: color),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
