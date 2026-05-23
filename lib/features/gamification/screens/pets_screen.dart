import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../data/database.dart';

// Provider for Pets
final petsProvider = FutureProvider<List<Pet>>((ref) async {
  final db = ref.watch(databaseProvider);
  return await db.select(db.pets).get();
});

class PetsScreen extends ConsumerWidget {
  const PetsScreen({Key? key}) : super(key: key);

  int _calculateHappiness(Pet pet) {
    final daysSinceFed = DateTime.now().difference(pet.lastFedAt).inDays;
    final loss = daysSinceFed * 20;
    return (pet.happinessLevel - loss).clamp(0, 100);
  }

  Future<void> _feedPet(BuildContext context, WidgetRef ref, Pet pet) async {
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile == null) return;

    if (profile.skillPoints < 1) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Недостатньо SP для годування (Потрібно 1 SP)!')),
        );
      }
      return;
    }

    await db.transaction(() async {
      await db.update(db.pets).replace(pet.copyWith(
        happinessLevel: 100,
        lastFedAt: DateTime.now(),
      ));
      await db.insertUserProfile(profile.copyWith(skillPoints: profile.skillPoints - 1));
    });

    // ignore: unused_result
    ref.refresh(userProfileProvider);
    // ignore: unused_result
    ref.refresh(petsProvider);
  }

  Future<void> _adoptPet(BuildContext context, WidgetRef ref, String type) async {
    final db = ref.read(databaseProvider);
    await db.into(db.pets).insert(
      Pet(
        id: const Uuid().v4(),
        petType: type,
        happinessLevel: 100,
        lastFedAt: DateTime.now(),
      ),
    );
    // ignore: unused_result
    ref.refresh(petsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'КІБЕР-ПІТОМЦІ',
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
      body: petsAsync.when(
        data: (pets) {
          if (pets.isEmpty) {
            return _buildAdoptionScreen(context, ref);
          }

          final pet = pets.first;
          final happiness = _calculateHappiness(pet);
          Color statusColor = AppColors.cyanAccent;
          if (happiness < 50) statusColor = AppColors.goldGlow;
          if (happiness < 20) statusColor = Colors.redAccent;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlassCard(
                  padding: const EdgeInsets.all(32.0),
                  borderColor: statusColor.withOpacity(0.5),
                  child: Column(
                    children: [
                      Icon(
                        pet.petType == 'dragon' ? Icons.cruelty_free : Icons.pets,
                        size: 100,
                        color: statusColor,
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        pet.petType.toUpperCase(),
                        style: AppTextStyles.orbitronHeading(fontSize: 24.0, color: Colors.white),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ЩАСТЯ', style: AppTextStyles.rajdhaniMedium(fontSize: 14.0, color: AppColors.textSecondary)),
                          Text('$happiness%', style: AppTextStyles.orbitronHeading(fontSize: 16.0, color: statusColor)),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      LinearProgressIndicator(
                        value: happiness / 100,
                        backgroundColor: AppColors.cardBg,
                        color: statusColor,
                        minHeight: 8.0,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                NeonButton(
                  text: 'НАГОДУВАТИ (1 SP)',
                  baseColor: AppColors.cyanAccent,
                  glowColor: AppColors.cyanAccent,
                  icon: const Icon(Icons.restaurant, color: Colors.black, size: 20),
                  onPressed: () => _feedPet(context, ref, pet),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildAdoptionScreen(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'У ВАС НЕМАЄ ПІТОМЦЯ.\nОБЕРІТЬ СВОГО КОМПАНЬЙОНА:',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        const SizedBox(height: 32.0),
        _buildAdoptionCard(context, ref, 'КІБЕР-ДРАКОН', 'dragon', Icons.cruelty_free, AppColors.goldGlow),
        const SizedBox(height: 16.0),
        _buildAdoptionCard(context, ref, 'МЕХА-ПЕС', 'dog', Icons.pets, AppColors.cyanAccent),
      ],
    );
  }

  Widget _buildAdoptionCard(BuildContext context, WidgetRef ref, String name, String type, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(16.0),
      borderColor: color.withOpacity(0.5),
      child: Column(
        children: [
          Icon(icon, size: 64.0, color: color),
          const SizedBox(height: 16.0),
          Text(name, style: AppTextStyles.orbitronHeading(fontSize: 18.0, color: color)),
          const SizedBox(height: 16.0),
          NeonButton(
            text: 'ВЗЯТИ',
            baseColor: color,
            glowColor: color,
            onPressed: () => _adoptPet(context, ref, type),
          ),
        ],
      ),
    );
  }
}
