import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import 'providers.dart';

/// Stream-based provider so the UI reactively updates when pets change.
final petsProvider = StreamProvider<List<Pet>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.pets).watch();
});
