import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

/// Data model for a weekly challenge.
class WeeklyChallenge {
  final String id;
  final String title;
  final int targetAmount; // in minor units (kopecks)
  final int currentAmount; // in minor units (kopecks)
  final DateTime deadline;
  final bool isCompleted;
  final DateTime createdAt;

  final String description;

  WeeklyChallenge({
    String? id,
    required this.title,
    this.description = '',
    required this.targetAmount,
    this.currentAmount = 0,
    required this.deadline,
    this.isCompleted = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  double get progressPercent =>
      targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  bool get isExpired =>
      DateTime.now().isAfter(deadline) && !isCompleted;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'targetAmount': targetAmount,
        'currentAmount': currentAmount,
        'deadline': deadline.toIso8601String(),
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
      };

  factory WeeklyChallenge.fromJson(Map<String, dynamic> json) {
    return WeeklyChallenge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      targetAmount: json['targetAmount'] as int,
      currentAmount: json['currentAmount'] as int,
      deadline: DateTime.parse(json['deadline'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  WeeklyChallenge copyWith({
    String? title,
    String? description,
    int? targetAmount,
    int? currentAmount,
    DateTime? deadline,
    bool? isCompleted,
  }) {
    return WeeklyChallenge(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}

/// Hive-based service for weekly challenges CRUD.
/// Avoids Drift code-gen dependency.
class WeeklyChallengeService {
  static const String _boxName = 'weekly_challenges_box';

  /// Open the Hive box. Call once at startup.
  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  Box get _box => Hive.box(_boxName);

  /// Get all challenges, sorted by creation date (newest first).
  List<WeeklyChallenge> getAll() {
    final raw = _box.values.toList();
    return raw
        .map((e) => WeeklyChallenge.fromJson(
            Map<String, dynamic>.from(e as Map))) // ignore: avoid_dynamic_calls
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get only active (not completed, not expired) challenges.
  List<WeeklyChallenge> getActive() {
    return getAll().where((c) => !c.isCompleted && !c.isExpired).toList();
  }

  /// Create a new challenge.
  Future<void> create(WeeklyChallenge challenge) async {
    await _box.put(challenge.id, challenge.toJson());
  }

  /// Update an existing challenge.
  Future<void> update(WeeklyChallenge challenge) async {
    await _box.put(challenge.id, challenge.toJson());
  }

  /// Delete a challenge.
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  /// Add amount to a challenge (from deposit).
  /// Distributes equally across all active challenges.
  /// Returns the list of updated challenges (for UI refresh).
  Future<List<WeeklyChallenge>> distributeDeposit(int amountKopecks) async {
    final active = getActive();
    if (active.isEmpty) return [];

    final perChallenge = amountKopecks ~/ active.length;
    final remainder = amountKopecks % active.length;

    final updated = <WeeklyChallenge>[];
    for (var i = 0; i < active.length; i++) {
      final add = perChallenge + (i < remainder ? 1 : 0);
      final newAmount = active[i].currentAmount + add;
      final completed = newAmount >= active[i].targetAmount;

      final updatedChallenge = active[i].copyWith(
        currentAmount: newAmount,
        isCompleted: completed || active[i].isCompleted,
      );
      await update(updatedChallenge);
      updated.add(updatedChallenge);
    }

    return updated;
  }

  /// Count of completed challenges.
  int get completedCount => getAll().where((c) => c.isCompleted).length;

  /// Clear all challenges (for hard reset).
  Future<void> clearAll() async {
    await _box.clear();
  }
}
