import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

enum PetEvolutionType {
  base,
  wise,
  wealthy,
  resilient,
}

class PetEvolutionState {
  final PetEvolutionType type;
  final int progress;
  final int target;
  final String currentRitual;

  const PetEvolutionState({
    required this.type,
    required this.progress,
    required this.target,
    required this.currentRitual,
  });
}

final petEvolutionProvider = Provider<PetEvolutionState>((ref) {
  final profileAsync = ref.watch(userProfileProvider);

  return profileAsync.maybeWhen(
    data: (profile) {
      if (profile == null) {
        return const PetEvolutionState(
          type: PetEvolutionType.base,
          progress: 0,
          target: 7,
          currentRitual: '',
        );
      }
      final noSpend = profile.noSpendStreakCount;
      final deposits = profile.streakCount;
      final karma = 0; // karmaHealingStreakCount not yet implemented in DB

      final candidates = <PetEvolutionType>[];
      if (noSpend >= 7) candidates.add(PetEvolutionType.wise);
      if (deposits >= 7) candidates.add(PetEvolutionType.wealthy);
      if (karma >= 7) candidates.add(PetEvolutionType.resilient);

      // If exactly one dominates
      if (candidates.length == 1) {
        final type = candidates.first;
        int progress = 7;
        String ritual = '';
        if (type == PetEvolutionType.wise) {
          progress = noSpend;
          ritual = 'no_spend';
        } else if (type == PetEvolutionType.wealthy) {
          progress = deposits;
          ritual = 'deposits';
        } else if (type == PetEvolutionType.resilient) {
          progress = karma;
          ritual = 'karma';
        }
        return PetEvolutionState(
          type: type,
          progress: progress,
          target: 7,
          currentRitual: ritual,
        );
      }

      // If mixed or none reached 7, determine current "leading" ritual for progress indication
      int maxProgress = 0;
      String leadingRitual = '';

      if (noSpend > maxProgress) {
        maxProgress = noSpend;
        leadingRitual = 'no_spend';
      }
      if (deposits > maxProgress) {
        maxProgress = deposits;
        leadingRitual = 'deposits';
      }
      if (karma > maxProgress) {
        maxProgress = karma;
        leadingRitual = 'karma';
      }

      // If multiple have same max progress, it's mixed
      int countWithMax = 0;
      if (noSpend == maxProgress && maxProgress > 0) countWithMax++;
      if (deposits == maxProgress && maxProgress > 0) countWithMax++;
      if (karma == maxProgress && maxProgress > 0) countWithMax++;

      if (countWithMax > 1) {
        return PetEvolutionState(
          type: PetEvolutionType.base,
          progress: maxProgress,
          target: 7,
          currentRitual: 'mixed',
        );
      }

      return PetEvolutionState(
        type: PetEvolutionType.base,
        progress: maxProgress,
        target: 7,
        currentRitual: leadingRitual,
      );
    },
    orElse: () => const PetEvolutionState(
      type: PetEvolutionType.base,
      progress: 0,
      target: 7,
      currentRitual: '',
    ),
  );
});
