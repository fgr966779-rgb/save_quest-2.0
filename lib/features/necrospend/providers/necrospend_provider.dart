import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/database.dart';
import 'package:drift/drift.dart' as drift;

final graveyardProvider = StateNotifierProvider<GraveyardNotifier, AsyncValue<List<GraveyardEntry>>>((ref) {
  final db = ref.watch(databaseProvider);
  return GraveyardNotifier(db);
});

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase(); // You might want to get it from a global provider
});

class GraveyardNotifier extends StateNotifier<AsyncValue<List<GraveyardEntry>>> {
  final AppDatabase _db;

  GraveyardNotifier(this._db) : super(const AsyncValue.loading()) {
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    try {
      final entries = await _db.select(_db.graveyardEntries).get();
      state = AsyncValue.data(entries);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> resurrectGoal(GraveyardEntry entry) async {
    try {
      await _db.update(_db.graveyardEntries).replace(
        entry.copyWith(
          isResurrected: true,
          resurrectionDate: drift.Value(DateTime.now()),
        ),
      );
      // Here we should also recreate the Goal or mark it as resurrected in Goals table
      await _loadEntries();
    } catch (e) {
      // Handle error
    }
  }
}
