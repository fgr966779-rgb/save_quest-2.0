import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import '../models/avatar_config.dart';
import 'providers.dart';

class Fine {
  final String id;
  final String reason;
  final int amountKopecks;
  final DateTime issuedAt;

  Fine({
    required this.id,
    required this.reason,
    required this.amountKopecks,
    required this.issuedAt,
  });
}

final penaltyProvider = StateNotifierProvider<PenaltyNotifier, List<Fine>>((ref) {
  final db = ref.watch(databaseProvider);
  return PenaltyNotifier(db, ref);
});

class PenaltyNotifier extends StateNotifier<List<Fine>> {
  final AppDatabase _db;
  final Ref _ref;

  PenaltyNotifier(this._db, this._ref) : super([]);

  Future<void> issueFine(String reason, int amountKopecks) async {
    final fine = Fine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      reason: reason,
      amountKopecks: amountKopecks,
      issuedAt: DateTime.now(),
    );
    state = [...state, fine];
    await _applyIntegrityDamage(0.2); // 20% damage per fine
  }

  Future<void> payFine(String fineId) async {
    state = state.where((f) => f.id != fineId).toList();
    if (state.isEmpty) {
      // If all fines paid, fully restore integrity
      await _restoreIntegrity(1.0);
    } else {
      // Partially restore based on remaining fines
      await _restoreIntegrity(0.2);
    }
  }

  Future<void> _applyIntegrityDamage(double damage) async {
    final profile = await _db.getUserProfile();
    if (profile == null) return;

    AvatarConfig config = const AvatarConfig();
    if (profile.avatarConfig != null) {
      config = AvatarConfig.fromJson(profile.avatarConfig!);
    }

    final newIntegrity = (config.integrity - damage).clamp(0.0, 1.0);
    final updatedConfig = config.copyWith(integrity: newIntegrity);

    await _db.insertUserProfile(
      profile.copyWith(avatarConfig: Value(updatedConfig.toJson())),
    );
    // ignore: unused_result
    _ref.refresh(userProfileProvider);
  }

  Future<void> _restoreIntegrity(double amount) async {
    final profile = await _db.getUserProfile();
    if (profile == null) return;

    AvatarConfig config = const AvatarConfig();
    if (profile.avatarConfig != null) {
      config = AvatarConfig.fromJson(profile.avatarConfig!);
    }

    // If restoring fully, set to 1.0, else add amount
    final newIntegrity = amount >= 1.0 ? 1.0 : (config.integrity + amount).clamp(0.0, 1.0);
    final updatedConfig = config.copyWith(integrity: newIntegrity);

    await _db.insertUserProfile(
      profile.copyWith(avatarConfig: Value(updatedConfig.toJson())),
    );
    // ignore: unused_result
    _ref.refresh(userProfileProvider);
  }
}
