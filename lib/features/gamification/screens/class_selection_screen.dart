import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' as drift;

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/neon_button.dart';

class ClassSelectionScreen extends ConsumerWidget {
  const ClassSelectionScreen({Key? key}) : super(key: key);

  void _selectClass(BuildContext context, WidgetRef ref, String playerClass) async {
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile != null) {
      await db.insertUserProfile(profile.copyWith(playerClass: drift.Value(playerClass)));
      // ignore: unused_result
      ref.refresh(userProfileProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Клас успішно змінено!')),
        );
        context.pop();
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
          'ВИБІР КЛАСУ',
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
          final currentClass = profile?.playerClass ?? 'none';
          
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildClassCard(
                context,
                ref,
                title: 'ВОЇН (Warrior)',
                description: 'Надійний та наполегливий. Отримує +10% більше XP за кожен внесок.',
                icon: Icons.shield,
                color: Colors.blueAccent,
                classId: 'warrior',
                isSelected: currentClass == 'warrior',
              ),
              const SizedBox(height: 16.0),
              _buildClassCard(
                context,
                ref,
                title: 'МАГ (Mage)',
                description: 'Керує ймовірностями. Шанс "Критичного внеску" збільшено з 10% до 25%.',
                icon: Icons.auto_awesome,
                color: Colors.purpleAccent,
                classId: 'mage',
                isSelected: currentClass == 'mage',
              ),
              const SizedBox(height: 16.0),
              _buildClassCard(
                context,
                ref,
                title: 'ЗЛОДІЙ (Rogue)',
                description: 'Швидкий та хитрий. +25 баз. XP. Також має 25% шанс зберегти Freeze Token при втраті стріку.',
                icon: Icons.speed,
                color: Colors.greenAccent,
                classId: 'rogue',
                isSelected: currentClass == 'rogue',
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Помилка: $err', style: const TextStyle(color: Colors.red))),
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBgLight.withOpacity(isSelected ? 0.9 : 0.4),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isSelected ? color : color.withOpacity(0.3),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: isSelected
            ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 15.0, spreadRadius: 2.0)]
            : [],
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
                  style: AppTextStyles.orbitronHeading(
                    fontSize: 20.0,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.white, size: 28.0),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            description,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14.0, height: 1.5),
          ),
          const SizedBox(height: 20.0),
          if (!isSelected)
            SizedBox(
              width: double.infinity,
              child: NeonButton(
                text: 'ОБРАТИ ЦЕЙ КЛАС',
                baseColor: color,
                glowColor: color,
                onPressed: () => _selectClass(context, ref, classId),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                child: Text('ПОТОЧНИЙ КЛАС', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}
