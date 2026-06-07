import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/gamification/models/leaderboard_model.dart';

/// Service to fetch global and alliance leaderboards from Firebase Firestore.
class FirebaseLeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch Global Top 100 players ordered by XP
  Stream<List<LeaderboardEntry>> watchGlobalLeaderboard(String currentUserId) {
    return _firestore
        .collection('user_profiles')
        .orderBy('xp', descending: true)
        .limit(100)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return LeaderboardEntry(
          id: doc.id,
          displayName: data['name'] ?? 'Anonymous Cyber',
          score: data['xp'] ?? 0,
          level: data['level'] ?? 1,
          avatarIndex: data['avatarConfig'] ?? 0,
          isCurrentUser: doc.id == currentUserId,
        );
      }).toList();
    });
  }

  /// Fetch Top Alliances ordered by totalXP
  Stream<List<AllianceEntry>> watchAllianceLeaderboard(String currentSquadId) {
    return _firestore
        .collection('squads')
        .orderBy('totalXp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AllianceEntry(
          id: doc.id,
          name: data['name'] ?? 'Unknown Squad',
          totalScore: data['totalXp'] ?? 0,
          membersCount: data['memberCount'] ?? 1,
          isUserAlliance: doc.id == currentSquadId,
        );
      }).toList();
    });
  }
}
