class DailyQuest {
  final String id; // e.g. 'deposit_any', 'view_analytics', 'spin_roulette'
  final String title;
  final String description;
  final int rewardXp;
  final int rewardCredits;
  final bool isCompleted;

  const DailyQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardXp,
    required this.rewardCredits,
    this.isCompleted = false,
  });

  DailyQuest copyWith({
    String? id,
    String? title,
    String? description,
    int? rewardXp,
    int? rewardCredits,
    bool? isCompleted,
  }) {
    return DailyQuest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rewardXp: rewardXp ?? this.rewardXp,
      rewardCredits: rewardCredits ?? this.rewardCredits,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'rewardXp': rewardXp,
      'rewardCredits': rewardCredits,
      'isCompleted': isCompleted,
    };
  }

  factory DailyQuest.fromJson(Map<String, dynamic> json) {
    return DailyQuest(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      rewardXp: json['rewardXp'] as int,
      rewardCredits: json['rewardCredits'] as int,
      isCompleted: json['isCompleted'] as bool,
    );
  }
}
