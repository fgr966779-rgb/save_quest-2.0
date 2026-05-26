import 'dart:math' show log;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import 'providers.dart';

/// Financial health score model.
class FinancialHealthScore {
  final double score; // 0-100
  final double streakScore; // 0-100
  final double goalScore; // 0-100
  final double avoidedScore; // 0-100

  const FinancialHealthScore({
    required this.score,
    required this.streakScore,
    required this.goalScore,
    required this.avoidedScore,
  });
}

/// Provider that computes financial health score.
///
/// Formula: score = (streak_score * 0.4) + (goal_completion_pct * 0.4) + (avoided_purchases_score * 0.2)
///
/// - Streak score: min(streak / 30 * 100, 100). A 30-day streak = 100.
/// - Goal score: average of both goals' completion %.
/// - Avoided score: logarithmic scale based on total avoided amount.
///   0 UAH = 0, 1000 = 50, 10000 = 100.
final financialHealthProvider = FutureProvider<FinancialHealthScore>((ref) async {
  final db = ref.watch(databaseProvider);

  // 1. User profile for streak
  final profile = await db.getUserProfile();
  final streak = profile?.streakCount ?? 0;
  final streakScore = (streak / 30.0 * 100).clamp(0.0, 100.0);

  // 2. Goal completion %
  final goals = await db.getAllGoals();
  double goalScore = 0;
  if (goals.isNotEmpty) {
    double totalPercent = 0;
    for (final g in goals) {
      totalPercent += g.targetAmount > 0
          ? (g.currentAmount / g.targetAmount * 100).clamp(0.0, 100.0)
          : 0;
    }
    goalScore = totalPercent / goals.length;
  }

  // 3. Avoided purchases score (logarithmic)
  final avoided = await db.select(db.avoidedPurchases).get();
  final totalAvoidedKopecks =
      avoided.fold<int>(0, (sum, a) => sum + a.amount);
  // Convert to hryvnias for score calculation
  final totalAvoidedHryvnias = totalAvoidedKopecks / 100.0;
  // Log scale: 0 -> 0, 1000 -> 50, 10000 -> 100
  double avoidedScore = 0;
  if (totalAvoidedHryvnias > 0) {
    avoidedScore = (50 + 50 * (log(totalAvoidedHryvnias / 1000) / log(10)))
        .clamp(0.0, 100.0);
  }

  // Combine with weights
  final score = (streakScore * 0.4) + (goalScore * 0.4) + (avoidedScore * 0.2);

  return FinancialHealthScore(
    score: score,
    streakScore: streakScore,
    goalScore: goalScore,
    avoidedScore: avoidedScore,
  );
});
