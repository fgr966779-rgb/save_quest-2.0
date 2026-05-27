import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/utils/money_utils.dart';
import '../../../data/database.dart';

/// Provider for PenaltyHabits data.
final _penaltyHabitsProvider = FutureProvider<List<PenaltyHabit>>((ref) async {
  final db = ref.read(databaseProvider);
  return db.select(db.penaltyHabits).get();
});

/// Provider for AvoidedPurchases data.
final _avoidedPurchasesProvider = FutureProvider<List<AvoidedPurchase>>((ref) async {
  final db = ref.read(databaseProvider);
  return db.select(db.avoidedPurchases).get();
});

/// Statistics screen for PenaltyHabits & AvoidedPurchases.
/// Shows total savings, top-5 categories, and weekly trend line chart.
class SavingsStatsScreen extends ConsumerWidget {
  const SavingsStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final locale = ref.read(localeProvider);
    String t(String key) => AppLocalizations.get(locale, key);
    final currency = ref.read(settingsServiceProvider).currency;

    final penaltiesAsync = ref.watch(_penaltyHabitsProvider);
    final avoidedAsync = ref.watch(_avoidedPurchasesProvider);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          t('stats_title'),
          style: AppTypography.h2(context),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Summary cards row
            penaltiesAsync.when(
              loading: () => const Center(
                  child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
              data: (penalties) {
                final totalPenalties = penalties.fold<int>(
                    0, (sum, p) => sum + p.penaltyAmount);

                return avoidedAsync.when(
                  loading: () => const SizedBox(height: 80),
                  error: (e, _) => Text('Error: $e'),
                  data: (avoided) {
                    final totalAvoided = avoided.fold<int>(
                        0, (sum, a) => sum + a.amount);

                    return Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            title: t('stats_penalties'),
                            value: centsToDisplay(totalPenalties)
                                .toStringAsFixed(0),
                            unit: currency,
                            icon: Icons.gavel_rounded,
                            color: AppColors.error,
                            brightness: brightness,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricCard(
                            title: t('stats_avoided'),
                            value: centsToDisplay(totalAvoided)
                                .toStringAsFixed(0),
                            unit: currency,
                            icon: Icons.block_rounded,
                            color: AppColors.success,
                            brightness: brightness,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24.0),

            // Top penalty habits
            penaltiesAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (penalties) {
                if (penalties.isEmpty) return const SizedBox.shrink();

                // Sort by amount desc, take top 5
                final sorted = List<PenaltyHabit>.from(penalties)
                  ..sort((a, b) =>
                      b.penaltyAmount.compareTo(a.penaltyAmount));
                final top5 = sorted.take(5).toList();
                final maxAmount = top5.first.penaltyAmount;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t('stats_top_penalties'),
                      style: AppTypography.h3(context),
                    ),
                    const SizedBox(height: 8.0),
                    ...top5.map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _HabitBar(
                            name: p.habitName,
                            amount: centsToDisplay(p.penaltyAmount)
                                .toStringAsFixed(0),
                            fraction: maxAmount > 0
                                ? p.penaltyAmount / maxAmount
                                : 0,
                            currency: currency,
                            color: AppColors.error,
                            brightness: brightness,
                          ),
                        )),
                    const SizedBox(height: 24.0),
                  ],
                );
              },
            ),

            // Weekly trend (AvoidedPurchases)
            avoidedAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (avoided) {
                if (avoided.isEmpty) return const SizedBox.shrink();

                final weeklyData = _groupAvoidedByWeek(avoided);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t('stats_weekly_trend'),
                      style: AppTypography.h3(context),
                    ),
                    const SizedBox(height: 12.0),
                    SurfaceCard(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        height: 200,
                        child: _WeeklyTrendChart(
                          data: weeklyData,
                          currency: currency,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  /// Group avoided purchases by week (Mon-Sun).
  List<_WeekData> _groupAvoidedByWeek(List<AvoidedPurchase> avoided) {
    final weekMap = <String, int>{};

    for (final a in avoided) {
      // Find Monday of the week
      final monday = a.createdAt.subtract(
        Duration(days: a.createdAt.weekday - 1),
      );
      final weekKey =
          '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';

      weekMap[weekKey] = (weekMap[weekKey] ?? 0) + a.amount;
    }

    // Sort by week key
    final sortedKeys = weekMap.keys.toList()..sort();
    return sortedKeys.map((k) => _WeekData(weekLabel: k, totalKopecks: weekMap[k]!)).toList();
  }
}

/// Metric summary card.
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final Brightness brightness;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTypography.caption(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$value $unit',
            style: AppTypography.metric(context, color: color),
          ),
        ],
      ),
    );
  }
}

/// Horizontal bar for a penalty habit.
class _HabitBar extends StatelessWidget {
  final String name;
  final String amount;
  final double fraction;
  final String currency;
  final Color color;
  final Brightness brightness;

  const _HabitBar({
    required this.name,
    required this.amount,
    required this.fraction,
    required this.currency,
    required this.color,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: AppTypography.bodySmall(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$amount $currency',
                style: AppTypography.bodySmall(context, color: color),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: fraction.clamp(0.0, 1.0),
              backgroundColor: AppColors.border(brightness),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Weekly trend data point.
class _WeekData {
  final String weekLabel;
  final int totalKopecks;
  const _WeekData({required this.weekLabel, required this.totalKopecks});
}

/// Line chart showing weekly avoided-purchase totals.
class _WeeklyTrendChart extends StatelessWidget {
  final List<_WeekData> data;
  final String currency;

  const _WeeklyTrendChart({
    required this.data,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No data'));
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < data.length; i++) {
      final hryvnias = data[i].totalKopecks / 100.0;
      spots.add(FlSpot(i.toDouble(), hryvnias));
    }

    final maxVal = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final minVal = 0.0;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxVal > 0 ? _niceStep(maxVal) : 100,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppColors.border(Theme.of(context).brightness)
                .withValues(alpha: 0.5),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTypography.overline(context),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: data.length <= 12,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= data.length) return const SizedBox();
                // Show short date: "May 5"
                final parts = data[idx].weekLabel.split('-');
                final month = int.tryParse(parts[1]) ?? 1;
                final day = int.tryParse(parts[2]) ?? 1;
                return Text(
                  '$day/$month',
                  style: AppTypography.overline(context),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.success,
            barWidth: 2.5,
            dotData: FlDotData(
              show: data.length <= 20,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.success,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.success.withValues(alpha: 0.1),
            ),
          ),
        ],
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: minVal,
        maxY: maxVal * 1.1,
      ),
    );
  }

  /// Calculate a "nice" step value for the Y axis.
  double _niceStep(double maxVal) {
    if (maxVal <= 0) return 100;
    final raw = maxVal / 4;
    final mag = pow(10, (log(raw) / ln10).floor()).toDouble();
    final normalized = raw / mag;
    final nice = normalized <= 1
        ? 1
        : normalized <= 2
            ? 2
            : normalized <= 5
                ? 5
                : 10;
    return nice * mag;
  }
}
