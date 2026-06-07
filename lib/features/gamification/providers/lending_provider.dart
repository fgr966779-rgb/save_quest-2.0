import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import '../../../core/services/gamification/xp_service.dart';

class LendingNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addContract({
    required String debtorName,
    required int amountCents,
    required DateTime returnDate,
  }) async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    
    await db.into(db.lendingContracts).insert(LendingContractsCompanion.insert(
      id: const Uuid().v4(),
      debtorName: debtorName,
      amount: amountCents,
      returnDate: returnDate,
      createdAt: now,
      updatedAt: drift.Value(now),
    ));
    
    // Invalidate to refresh UI
    ref.invalidate(lendingContractsProvider);
    ref.invalidate(debtorNamesProvider);
  }

  Future<void> markAsReturned(LendingContract contract) async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();

    await db.transaction(() async {
      // 1. Update contract status
      await (db.update(db.lendingContracts)..where((t) => t.id.equals(contract.id))).write(
        LendingContractsCompanion(
          isReturned: const drift.Value(true),
          updatedAt: drift.Value(now),
        ),
      );

      // 2. Reward user with XP
      final profile = await db.getUserProfile();
      if (profile != null) {
        final unlockedSkills = await db.getUnlockedSkills();
        final skillIds = unlockedSkills.map((s) => s.id).toSet();
        
        // Base XP for returning money
        final baseXP = 50;
        final xpGained = XpService.calculateXpGained(
          baseAmount: baseXP,
          multiplier: 1.0, // No streak multiplier for lending yet
          playerClass: profile.playerClass,
          hasXpBoostSkill: skillIds.contains('magnate_xp_boost'),
        );

        int newXP = profile.xp + xpGained;
        int currentLevel = profile.level;
        while (newXP >= XpService.xpRequiredForLevel(currentLevel)) {
          currentLevel++;
        }

        await db.updateUserProfile(profile.copyWith(
          xp: newXP,
          level: currentLevel,
          updatedAt: now,
        ));
      }
    });

    ref.invalidate(lendingContractsProvider);
    ref.invalidate(userProfileProvider);
  }
}

final lendingProvider = AsyncNotifierProvider<LendingNotifier, void>(LendingNotifier.new);

final lendingContractsProvider = StreamProvider<List<LendingContract>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.lendingContracts)
        ..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)]))
      .watch();
});

final debtorNamesProvider = FutureProvider<List<String>>((ref) async {
  final db = ref.watch(databaseProvider);
  final contracts = await db.select(db.lendingContracts).get();
  return contracts.map((e) => e.debtorName).toSet().toList();
});
