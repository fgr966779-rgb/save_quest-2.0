import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

/// Data model for a goal dependency relationship.
class GoalDependency {
  final String id;
  final String childGoalId;
  final String parentGoalId;
  final bool isUnlocked;

  GoalDependency({
    String? id,
    required this.childGoalId,
    required this.parentGoalId,
    this.isUnlocked = false,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'childGoalId': childGoalId,
        'parentGoalId': parentGoalId,
        'isUnlocked': isUnlocked,
      };

  factory GoalDependency.fromJson(Map<String, dynamic> json) {
    return GoalDependency(
      id: json['id'] as String,
      childGoalId: json['childGoalId'] as String,
      parentGoalId: json['parentGoalId'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
    );
  }
}

/// Hive-based service for managing goal dependencies.
/// Tracks which goals are "locked" until their parent goal is completed.
class GoalDependencyService {
  static const String _boxName = 'goal_dependencies_box';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  Box get _box => Hive.box(_boxName);

  /// Get all dependencies.
  List<GoalDependency> getAll() {
    return _box.values
        .map((e) =>
            GoalDependency.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  /// Check if a goal is locked (has an unmet dependency).
  bool isGoalLocked(String goalId, Set<String> completedGoalIds) {
    final deps = getAll();
    for (final dep in deps) {
      if (dep.childGoalId == goalId &&
          !completedGoalIds.contains(dep.parentGoalId)) {
        return true;
      }
    }
    return false;
  }

  /// Get the parent goal ID that locks a child goal.
  String? getBlockingParent(String goalId, Set<String> completedGoalIds) {
    final deps = getAll();
    for (final dep in deps) {
      if (dep.childGoalId == goalId &&
          !completedGoalIds.contains(dep.parentGoalId)) {
        return dep.parentGoalId;
      }
    }
    return null;
  }

  /// Add a dependency: childGoal is locked until parentGoal is completed.
  Future<void> addDependency({
    required String childGoalId,
    required String parentGoalId,
  }) async {
    // Don't add duplicate
    final existing = getAll();
    final alreadyExists = existing.any(
      (d) => d.childGoalId == childGoalId && d.parentGoalId == parentGoalId,
    );
    if (alreadyExists) return;

    final dep = GoalDependency(
      childGoalId: childGoalId,
      parentGoalId: parentGoalId,
    );
    await _box.put(dep.id, dep.toJson());
  }

  /// Remove a dependency.
  Future<void> removeDependency(String dependencyId) async {
    await _box.delete(dependencyId);
  }

  /// Clear all dependencies (for hard reset).
  Future<void> clearAll() async {
    await _box.clear();
  }
}
