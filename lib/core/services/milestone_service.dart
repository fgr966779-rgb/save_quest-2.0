import 'package:hive_flutter/hive_flutter.dart';

/// Service for tracking goal milestones (25%, 50%, 75%, 100%).
/// Uses Hive for persistence — no Drift schema change needed.
///
/// Milestone thresholds are computed from existing Goals data.
/// This service only tracks which milestones have been "celebrated"
/// (dismissed by the user) to avoid showing duplicate dialogs.
class MilestoneService {
  static const String _boxName = 'milestones_box';

  /// Milestone threshold percentages.
  static const List<int> thresholds = [25, 50, 75, 100];

  /// Open the Hive box. Call once at app startup.
  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  Box get _box => Hive.box(_boxName);

  /// Build a Hive key for a specific goal + milestone.
  /// Format: "goal_a_25", "goal_b_100", etc.
  static String _key(String goalId, int percent) =>
      '${goalId}_$percent';

  /// Check if a milestone has already been celebrated.
  bool isCelebrated(String goalId, int percent) {
    return _box.get(_key(goalId, percent), defaultValue: false) as bool;
  }

  /// Mark a milestone as celebrated.
  Future<void> markCelebrated(String goalId, int percent) async {
    await _box.put(_key(goalId, percent), true);
  }

  /// Calculate current progress percentage for a goal.
  static int calculateProgress(int currentAmount, int targetAmount) {
    if (targetAmount <= 0) return 0;
    return ((currentAmount / targetAmount) * 100).round();
  }

  /// Check which new milestones have been reached since last celebration.
  /// Returns a list of just-reached milestone percentages.
  ///
  /// [previousPercent] — progress BEFORE the deposit.
  /// [currentPercent] — progress AFTER the deposit.
  List<int> checkNewMilestones({
    required String goalId,
    required int previousPercent,
    required int currentPercent,
  }) {
    final reached = <int>[];
    for (final threshold in thresholds) {
      if (currentPercent >= threshold &&
          previousPercent < threshold &&
          !isCelebrated(goalId, threshold)) {
        reached.add(threshold);
      }
    }
    return reached;
  }

  /// Clear all milestone data (for hard reset).
  Future<void> clearAll() async {
    await _box.clear();
  }
}
