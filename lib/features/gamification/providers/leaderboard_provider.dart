import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/providers.dart';
import '../../../core/services/firebase_leaderboard_service.dart';
import '../models/leaderboard_model.dart';

part 'leaderboard_provider.g.dart';

final firebaseLeaderboardServiceProvider = Provider((ref) => FirebaseLeaderboardService());

@riverpod
Stream<List<LeaderboardEntry>> weeklyLeaderboard(Ref ref) {
  final currentUserId = ref.watch(userProfileProvider).value?.id.toString() ?? 'anonymous';
  final service = ref.watch(firebaseLeaderboardServiceProvider);
  return service.watchGlobalLeaderboard(currentUserId);
}

@riverpod
Stream<List<LeaderboardEntry>> monthlyLeaderboard(Ref ref) {
  final currentUserId = ref.watch(userProfileProvider).value?.id.toString() ?? 'anonymous';
  final service = ref.watch(firebaseLeaderboardServiceProvider);
  // Re-using global leaderboard for now, filtering can be added later
  return service.watchGlobalLeaderboard(currentUserId);
}

@riverpod
Stream<List<AllianceEntry>> allianceLeaderboard(Ref ref) {
  // In a real scenario we'd use the current user's squad ID.
  final currentSquadId = 'none'; 
  final service = ref.watch(firebaseLeaderboardServiceProvider);
  return service.watchAllianceLeaderboard(currentSquadId);
}
