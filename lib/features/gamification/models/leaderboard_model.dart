class LeaderboardEntry {
  final String id;
  final String displayName;
  final int score;
  final int level;
  final bool isCurrentUser;
  final int avatarIndex;

  LeaderboardEntry({
    required this.id,
    required this.displayName,
    required this.score,
    required this.level,
    this.isCurrentUser = false,
    required this.avatarIndex,
  });
}

class AllianceEntry {
  final String id;
  final String name;
  final int totalScore;
  final int membersCount;
  final bool isUserAlliance;

  AllianceEntry({
    required this.id,
    required this.name,
    required this.totalScore,
    required this.membersCount,
    this.isUserAlliance = false,
  });
}
