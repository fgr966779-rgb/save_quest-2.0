import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../data/database.dart';

// Provider for Pets
final petsProvider = FutureProvider<List<Pet>>((ref) async {
  final db = ref.watch(databaseProvider);
  return await db.select(db.pets).get();
});

class PetsScreen extends ConsumerWidget {
  const PetsScreen({super.key});

  int _calculateHappiness(Pet pet) {
    final daysSinceFed = DateTime.now().difference(pet.lastFedAt).inDays;
    final loss = daysSinceFed * 20;
    return (pet.happinessLevel - loss).clamp(0, 100);
  }

  /// Calculate pet level from happiness.
  /// Level = 1 + (total feed count). Feed count is derived from happiness resets.
  /// Each feed session adds 1 effective level. Stored indirectly via happiness pattern.
  /// Simple approach: level = max(1, 100 - happinessLevel at last feed).
  /// Better: we track level separately using the profile's total deposits.
  ///
  /// XP-based leveling:
  /// Each deposit gives pet XP = (depositAmount / 100).round()
  /// Level thresholds: level * 200 XP needed per level
  int _calculatePetLevel(int totalPetXp) {
    // Level 1: 0 XP, Level 2: 200 XP, Level 3: 600 XP, Level N: N*(N-1)*100 XP
    // Inverse: find max N where N*(N-1)*100 <= totalPetXp
    int level = 1;
    while ((level + 1) * level * 100 <= totalPetXp) {
      level++;
    }
    return level;
  }

  int _xpForNextLevel(int level) {
    // XP needed to go from current level to next
    final currentThreshold = level * (level - 1) * 100;
    final nextThreshold = (level + 1) * level * 100;
    return nextThreshold - currentThreshold;
  }

  int _xpProgressInLevel(int totalPetXp, int level) {
    final currentThreshold = level * (level - 1) * 100;
    return totalPetXp - currentThreshold;
  }

  /// Get pet mood label.
  String _getMoodLabel(int happiness, String Function(String) t) {
    if (happiness >= 60) return t('pet_happy');
    if (happiness >= 25) return t('pet_hungry');
    return t('pet_sad');
  }

  /// Get mood color.
  Color _getMoodColor(int happiness) {
    if (happiness >= 60) return AppColors.success;
    if (happiness >= 25) return AppColors.warning;
    return AppColors.error;
  }

  Future<void> _feedPet(
      BuildContext context, WidgetRef ref, Pet pet, String Function(String) t) async {
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile == null) return;

    if (profile.skillPoints < 1) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t('pet_no_sp'))),
        );
      }
      return;
    }

    await db.transaction(() async {
      await db.update(db.pets).replace(pet.copyWith(
        happinessLevel: 100,
        lastFedAt: DateTime.now(),
      ));
      await db.insertUserProfile(
          profile.copyWith(skillPoints: profile.skillPoints - 1));
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t('pet_feed_success'),
            style: AppTypography.bodySmall(context, color: AppColors.success),
          ),
        ),
      );
    }

    // ignore: unused_result
    ref.refresh(userProfileProvider);
    // ignore: unused_result
    ref.refresh(petsProvider);
  }

  Future<void> _adoptPet(
      BuildContext context, WidgetRef ref, String type) async {
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

  /// Add XP to pet when a deposit is made.
  /// Called from deposit flow. XP = depositAmount / 100 (rounded).
  /// The pet levels up automatically based on total accumulated XP.
  /// Since we don't have a dedicated pet_xp column, we use a simple heuristic:
  /// pet happiness resets to 100 on each feed, so "feeds done" = happiness resets.
  /// For XP, we'll store it via the profile's XP as a proxy.
  /// 
  /// Simplified approach: pet level = 1 + floor(profile.xp / 500).
  /// This ties pet growth to overall player progress.
  static int getPetLevelFromProfile(int profileXp) {
    return 1 + (profileXp ~/ 500);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsProvider);
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
          t('pet_title'),
          style: AppTypography.h3(context, color: AppColors.accent),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: AppColors.textPrimary(brightness), size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: petsAsync.when(
        data: (pets) {
          if (pets.isEmpty) {
            return _buildAdoptionScreen(context, ref, brightness, t);
          }

          final pet = pets.first;
          final happiness = _calculateHappiness(pet);
          final moodColor = _getMoodColor(happiness);
          final moodLabel = _getMoodLabel(happiness, t);

          // Pet level derived from profile XP
          final profileXp = profileAsync.when(
            data: (p) => p?.xp ?? 0,
            loading: () => 0,
            error: (_, __) => 0,
          );
          final petLevel = getPetLevelFromProfile(profileXp);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Pet Card
                SurfaceCard(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      // Pet icon with level badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: moodColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Icon(
                              pet.petType == 'dragon'
                                  ? Icons.cruelty_free
                                  : Icons.pets,
                              size: 64,
                              color: moodColor,
                            ),
                          ),
                          Positioned(
                            right: -4,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'LVL $petLevel',
                                style: AppTypography.caption(context,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        pet.petType.toUpperCase(),
                        style: AppTypography.h2(
                            context,
                            color: AppColors.textPrimary(brightness)),
                      ),
                      const SizedBox(height: 8),
                      // Mood badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: moodColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          moodLabel,
                          style: AppTypography.bodySmall(context,
                              color: moodColor),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Happiness bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(t('pet_happiness'),
                              style: AppTypography.caption(context)),
                          Text('$happiness%',
                              style: AppTypography.h3(context,
                                  color: moodColor)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ProgressBar(
                        progress: happiness / 100,
                        color: moodColor,
                        height: 8.0,
                      ),
                      const SizedBox(height: 12),
                      // XP info
                      Text(
                        '${profileXp ~/ 500 * 500} / ${(petLevel + 1) * 500} XP',
                        style: AppTypography.caption(context),
                      ),
                      ProgressBar(
                        progress: ((profileXp % 500) / 500).clamp(0.0, 1.0),
                        color: AppColors.accent,
                        height: 4.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Feed button
                AppButton(
                  label: t('pet_feed_btn'),
                  icon: const Icon(Icons.restaurant, size: 20),
                  onPressed: () => _feedPet(context, ref, pet, t),
                  variant: ButtonVariant.primary,
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('${t("common_error")}: $e')),
      ),
    );
  }

  Widget _buildAdoptionScreen(BuildContext context, WidgetRef ref,
      Brightness brightness, String Function(String) t) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          t('pet_empty_title'),
          textAlign: TextAlign.center,
          style: AppTypography.body(context,
              color: AppColors.textPrimary(brightness)),
        ),
        const SizedBox(height: 32),
        _buildAdoptionCard(context, ref, t('pet_dragon'), 'dragon',
            Icons.cruelty_free, AppColors.warning, t),
        const SizedBox(height: 16),
        _buildAdoptionCard(context, ref, t('pet_dog'), 'dog', Icons.pets,
            AppColors.accent, t),
      ],
    );
  }

  Widget _buildAdoptionCard(BuildContext context, WidgetRef ref, String name,
      String type, IconData icon, Color color, String Function(String) t) {
    return SurfaceCard(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Icon(icon, size: 64.0, color: color),
          const SizedBox(height: 16),
          Text(name, style: AppTypography.h3(context, color: color)),
          const SizedBox(height: 16),
          AppButton(
            label: t('pet_adopt_btn'),
            onPressed: () => _adoptPet(context, ref, type),
            variant: ButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
