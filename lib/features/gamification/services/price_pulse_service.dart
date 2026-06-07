import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import '../../../core/services/openrouter_service.dart';
import '../../../core/services/price_analysis_service.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import '../../../core/services/notification_service.dart';

/// Business logic for the "Price Pulse" system.
/// Orchestrates price history caching, AI commentary, gamification XP,
/// and future trend projection.
class PricePulseService {
  final AppDatabase _db;
  final PriceAnalysisService _priceAnalysis;
  final OpenRouterService _openRouter;

  PricePulseService(this._db, this._priceAnalysis, this._openRouter);

  /// Analyzes the market price for the given [goal], caches it, and applies
  /// gamification rules (XP for tracking, critical hit bonuses, AI comments).
  ///
  /// Set [forceManual] to true if the user explicitly pushed the "Update" button.
  /// Throws an exception if the API limit might be reached (handled in UI).
  Future<PricePulseResult> updatePriceForGoal(
    Goal goal, {
    bool forceManual = false,
  }) async {
    final query = goal.productUrl;
    if (query == null || query.isEmpty) {
      return PricePulseResult(
        success: false,
        message: 'No product query set for this goal.',
      );
    }

    final latestEntry = await _db.getLatestPriceEntry(goal.id);
    final now = DateTime.now();

    // 1. Enforce aggressive caching: 24h limit
    if (!forceManual && latestEntry != null) {
      final hoursSinceLastCheck = now.difference(latestEntry.cachedAt).inHours;
      if (hoursSinceLastCheck < 24) {
        return PricePulseResult(
          success: true,
          message: 'Using cached price. Wait 24h for auto-update.',
          isCached: true,
        );
      }
    }

    // 2. Fetch live data
    PriceAnalysis analysis;
    try {
      analysis = await _priceAnalysis.analyze(query);
    } catch (e) {
      // Fallback to cache if API fails
      if (latestEntry != null) {
        return PricePulseResult(
          success: false,
          message: 'API error, using cache.',
          isCached: true,
        );
      }
      rethrow;
    }

    final newPrice = analysis.avgPriceKopecks;
    final storeName = analysis.quotes.isNotEmpty
        ? analysis.quotes.first.store
        : 'SerpAPI Avg';

    // 3. Save to History
    await _db.insertPriceHistoryEntry(PriceHistoryEntriesCompanion.insert(
      goalId: goal.id,
      priceKopecks: newPrice,
      store: drift.Value(storeName),
      dataSource: drift.Value(analysis.isEstimate ? 'cache' : 'api'),
      cachedAt: now,
    ));

    // Update goal's currentPrice
    await _db.updateGoal(goal.copyWith(
      currentPrice: drift.Value(newPrice),
      lastPriceUpdate: drift.Value(now),
    ));

    // Cleanup old history
    await _db.pruneOldPriceHistory(goal.id);

    // 4. Gamification (XP & AI)
    int xpAwarded = 0;
    String? aiComment;
    bool isCriticalHit = false;

    final profile = await _db.getUserProfile();
    if (profile != null) {
      var updatedProfile = profile;

      // Rule: +15 XP for weekly price check
      if (profile.lastPricePulseXPDate == null ||
          now.difference(profile.lastPricePulseXPDate!).inDays >= 7) {
        xpAwarded += 15;
        updatedProfile = updatedProfile.copyWith(
          xp: updatedProfile.xp + 15,
          lastPricePulseXPDate: drift.Value(now),
          pricePulseTrackingCount: updatedProfile.pricePulseTrackingCount + 1,
        );
      }

      // Check for price changes against PREVIOUS entry
      if (latestEntry != null) {
        final oldPrice = latestEntry.priceKopecks;
        final deltaPercent = ((newPrice - oldPrice) / oldPrice) * 100;

        // Rule: +50 XP Critical Hit (price dropped by > 15%)
        if (deltaPercent <= -15.0) {
          xpAwarded += 50;
          isCriticalHit = true;
          updatedProfile = updatedProfile.copyWith(
            xp: updatedProfile.xp + 50,
          );
          
          NotificationService().showPriceAlert(
            id: goal.id.hashCode,
            title: '🎯 Critical Hit!',
            body: '${goal.name} подешевшала на ${deltaPercent.abs().toStringAsFixed(1)}%! Ти отримав +50 XP!',
          );
        }

        // AI Oracle trigger: >10% change or critical hit
        if (deltaPercent.abs() > 10.0 || isCriticalHit) {
          aiComment = await _generateOracleComment(goal.name, deltaPercent);
        }
      }

      if (updatedProfile != profile) {
        await _db.updateUserProfile(updatedProfile);
      }
    }

    return PricePulseResult(
      success: true,
      message: 'Price updated successfully.',
      xpAwarded: xpAwarded,
      aiComment: aiComment,
      isCriticalHit: isCriticalHit,
      isCached: false,
    );
  }

  /// Linear regression on last 3-5 price points to estimate trend.
  /// Returns expected price in 30 days.
  Future<PriceTrendForecast?> getForecast(String goalId) async {
    final history = await _db.getPriceHistory(goalId, limit: 5);
    if (history.length < 2) return null; // Not enough data

    // Reverse so oldest is first
    final points = history.reversed.toList();
    
    // Convert to relative days and prices
    final t0 = points.first.cachedAt;
    final x = points.map((p) => p.cachedAt.difference(t0).inDays.toDouble()).toList();
    final y = points.map((p) => p.priceKopecks.toDouble()).toList();

    final n = points.length;
    final sumX = x.reduce((a, b) => a + b);
    final sumY = y.reduce((a, b) => a + b);
    final sumXY = List.generate(n, (i) => x[i] * y[i]).reduce((a, b) => a + b);
    final sumX2 = x.map((v) => v * v).reduce((a, b) => a + b);

    // slope (m) and intercept (b)
    final denominator = (n * sumX2 - sumX * sumX);
    if (denominator == 0) {
       // Flat line if all points are on same day
       return PriceTrendForecast(
         expectedPriceKopecks30d: points.last.priceKopecks,
         trendSlope: 0,
       );
    }
    
    final m = (n * sumXY - sumX * sumY) / denominator;
    final b = (sumY - m * sumX) / n;

    // Forecast for day = last day + 30
    final lastDay = x.last;
    final targetDay = lastDay + 30;
    
    int expectedPrice = (m * targetDay + b).round();
    // Don't predict negative prices
    expectedPrice = max(expectedPrice, 1);

    return PriceTrendForecast(
      expectedPriceKopecks30d: expectedPrice,
      trendSlope: m, // change in kopecks per day
    );
  }

  Future<String?> _generateOracleComment(String item, double deltaPercent) async {
    try {
      final direction = deltaPercent > 0 ? "зросла на ${deltaPercent.toStringAsFixed(1)}%" : "впала на ${deltaPercent.abs().toStringAsFixed(1)}%";
      final prompt = "Ти — Кібер-Оракул. Проаналізуй зміну ціни: '$item' $direction. Поясни причину коротко (1-2 речення) у стилі кіберпанк. Не давай фінансових порад.";
      
      return await _openRouter.generateText(prompt: prompt);
    } catch (e) {
      debugPrint('[PricePulse] Oracle failed: $e');
      return null;
    }
  }
  
  /// DEBUG ONLY: Resets cache to allow testing XP logic
  Future<void> debugResetCache(String goalId) async {
    final entry = await _db.getLatestPriceEntry(goalId);
    if (entry != null) {
      await _db.update(_db.priceHistoryEntries).replace(
        entry.copyWith(cachedAt: DateTime.now().subtract(const Duration(days: 8)))
      );
    }
    
    final profile = await _db.getUserProfile();
    if (profile != null) {
       await _db.updateUserProfile(profile.copyWith(
         lastPricePulseXPDate: drift.Value(null)
       ));
    }
  }

  /// DEBUG ONLY: Simulates a critical hit by inserting a fake high-price entry
  Future<void> debugSimulateCriticalHit(Goal goal) async {
     final currentPrice = goal.currentPrice ?? goal.targetPrice ?? 100000;
     // Insert a fake entry 20% higher 
     await _db.insertPriceHistoryEntry(PriceHistoryEntriesCompanion.insert(
      goalId: goal.id,
      priceKopecks: (currentPrice * 1.2).round(),
      store: const drift.Value('Debug Store'),
      dataSource: const drift.Value('manual'),
      cachedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ));
    
    // Now trigger an update which should see the real price as a 16.6% drop
    await updatePriceForGoal(goal, forceManual: true);
  }
}

class PricePulseResult {
  final bool success;
  final String message;
  final int xpAwarded;
  final String? aiComment;
  final bool isCriticalHit;
  final bool isCached;

  PricePulseResult({
    required this.success,
    required this.message,
    this.xpAwarded = 0,
    this.aiComment,
    this.isCriticalHit = false,
    this.isCached = false,
  });
}

class PriceTrendForecast {
  final int expectedPriceKopecks30d;
  final double trendSlope; // kopecks per day

  PriceTrendForecast({
    required this.expectedPriceKopecks30d,
    required this.trendSlope,
  });
  
  bool get isTrendingUp => trendSlope > 0;
  bool get isTrendingDown => trendSlope < 0;
}

final pricePulseServiceProvider = Provider<PricePulseService>((ref) {
  return PricePulseService(
    ref.watch(databaseProvider),
    ref.watch(priceAnalysisServiceProvider),
    ref.watch(openRouterProvider),
  );
});
