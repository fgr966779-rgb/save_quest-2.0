import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../data/database.dart';

import '../../gamification/providers/quest_provider.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(questProvider.notifier).completeQuest('view_analytics');
    });
  }

  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(goalsProvider);
    final depositsAsync = ref.watch(depositsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              'АНАЛІТИЧНИЙ ВІДСІК',
              style: AppTextStyles.rajdhaniMedium(
                fontSize: 12.0,
                color: AppColors.cyanAccent,
              ).copyWith(letterSpacing: 2.0),
            ),
            Text(
              'ПРОЕКЦІЇ ТА ДИНАМІКА',
              style: AppTextStyles.orbitronHeading(
                fontSize: 20.0,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24.0),

            // Allocations breakdown (Pie chart)
            _buildAllocationBreakdownCard(goalsAsync),
            const SizedBox(height: 20.0),

            // Timeline Projections Graph (Line Chart)
            _buildTimelineChartCard(depositsAsync),
            const SizedBox(height: 20.0),

            // Projections breakdown card
            _buildProjectionsSummaryCard(goalsAsync, depositsAsync),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }

  Widget _buildAllocationBreakdownCard(AsyncValue<List<Goal>> goalsAsync) {
    return goalsAsync.when(
      loading: () => const SizedBox(height: 150, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
      data: (goals) {
        if (goals.isEmpty) return const SizedBox.shrink();

        final int totalA = goals.firstWhere((g) => g.id == 'goal_a').currentAmount;
        final int totalB = goals.firstWhere((g) => g.id == 'goal_b').currentAmount;
        final int total = totalA + totalB;

        final double percentA = total > 0 ? (totalA / total * 100) : 50;
        final double percentB = total > 0 ? (totalB / total * 100) : 50;

        return GlassCard(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'РОЗПОДІЛ НАКОПИЧЕНИХ КОШТІВ',
                style: AppTextStyles.orbitronHeading(
                  fontSize: 12.0,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  // Pie Chart
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 28,
                        sections: [
                          PieChartSectionData(
                            color: AppColors.cyanAccent,
                            value: percentA,
                            title: '${percentA.toInt()}%',
                            radius: 20,
                            titleStyle: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          PieChartSectionData(
                            color: AppColors.magentaAccent,
                            value: percentB,
                            title: '${percentB.toInt()}%',
                            radius: 20,
                            titleStyle: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24.0),
                  // Legends
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem(
                          goals.firstWhere((g) => g.id == 'goal_a').name,
                          '${formatAmount(totalA)} ${goals.first.currency}',
                          AppColors.cyanAccent,
                        ),
                        const SizedBox(height: 12.0),
                        _buildLegendItem(
                          goals.firstWhere((g) => g.id == 'goal_b').name,
                          '${formatAmount(totalB)} ${goals.first.currency}',
                          AppColors.magentaAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(String title, String amount, Color color) {
    return Row(
      children: [
        Container(
          width: 12.0,
          height: 12.0,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10.0, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
              ),
              Text(
                amount,
                style: AppTextStyles.orbitronHeading(fontSize: 13.0, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineChartCard(AsyncValue<List<Deposit>> depositsAsync) {
    return depositsAsync.when(
      loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
      data: (deposits) {
        // Reverse list to show chronological progression
        final timeline = deposits.reversed.toList();

        // Calculate cumulative running values for A and B
        List<FlSpot> spotsA = [];
        List<FlSpot> spotsB = [];

        double cumA = 0;
        double cumB = 0;

        spotsA.add(const FlSpot(0, 0));
        spotsB.add(const FlSpot(0, 0));

        for (int i = 0; i < timeline.length; i++) {
          // Convert kopecks to display units for chart Y axis
          cumA += centsToDisplay(timeline[i].goalAAmount);
          cumB += centsToDisplay(timeline[i].goalBAmount);
          spotsA.add(FlSpot((i + 1).toDouble(), cumA));
          spotsB.add(FlSpot((i + 1).toDouble(), cumB));
        }

        // Limit spot lengths for perfect chart drawing
        if (spotsA.length > 8) {
          spotsA = spotsA.sublist(spotsA.length - 8);
          spotsB = spotsB.sublist(spotsB.length - 8);
        }

        return GlassCard(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'КІБЕР-ДИНАМІКА ПОТОКУ',
                style: AppTextStyles.orbitronHeading(
                  fontSize: 12.0,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (val) => FlLine(
                        color: AppColors.borderNeon.withOpacity(0.15),
                        strokeWidth: 1.0,
                      ),
                    ),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      // Goal A progress line
                      LineChartBarData(
                        spots: spotsA,
                        isCurved: true,
                        color: AppColors.cyanAccent,
                        barWidth: 3,
                        dotData: FlDotData(show: spotsA.length < 5),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.cyanAccent.withOpacity(0.06),
                        ),
                      ),
                      // Goal B progress line
                      LineChartBarData(
                        spots: spotsB,
                        isCurved: true,
                        color: AppColors.magentaAccent,
                        barWidth: 3,
                        dotData: FlDotData(show: spotsB.length < 5),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.magentaAccent.withOpacity(0.06),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProjectionsSummaryCard(AsyncValue<List<Goal>> goalsAsync, AsyncValue<List<Deposit>> depositsAsync) {
    return goalsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (goals) {
        if (goals.length < 2) return const SizedBox.shrink();

        final goalA = goals.firstWhere((g) => g.id == 'goal_a');
        final goalB = goals.firstWhere((g) => g.id == 'goal_b');

        return depositsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (deposits) {
            double totalAWeekly = 0;
            double totalBWeekly = 0;

            final now = DateTime.now();
            final oneWeekAgo = now.subtract(const Duration(days: 7));

            for (var dep in deposits) {
              if (dep.createdAt.isAfter(oneWeekAgo)) {
                totalAWeekly += centsToDisplay(dep.goalAAmount);
                totalBWeekly += centsToDisplay(dep.goalBAmount);
              }
            }

            final double remainingA = (centsToDisplay(goalA.targetAmount) - centsToDisplay(goalA.currentAmount)).clamp(0, double.infinity);
            final double remainingB = (centsToDisplay(goalB.targetAmount) - centsToDisplay(goalB.currentAmount)).clamp(0, double.infinity);

            final double rateA = totalAWeekly / 7.0;
            final double rateB = totalBWeekly / 7.0;

            final String daysRemainingA = rateA > 0 ? '${(remainingA / rateA).ceil()} днів' : '∞ (відсутній потік)';
            final String daysRemainingB = rateB > 0 ? '${(remainingB / rateB).ceil()} днів' : '∞ (відсутній потік)';

            return GlassCard(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'ТИЖНЕВА АКТИВНІСТЬ ТА ПРОГНОЗ',
                    style: AppTextStyles.orbitronHeading(
                      fontSize: 12.0,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildProjectionSummaryRow(goalA.name, '${totalAWeekly.toStringAsFixed(2)} ${goalA.currency}', daysRemainingA, AppColors.cyanAccent),
                  const Divider(color: AppColors.borderNeon, height: 24.0),
                  _buildProjectionSummaryRow(goalB.name, '${totalBWeekly.toStringAsFixed(2)} ${goalB.currency}', daysRemainingB, AppColors.magentaAccent),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProjectionSummaryRow(String goalName, String weeklySum, String expectedDays, Color accentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                goalName.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.orbitronHeading(fontSize: 12.0, color: accentColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3.0),
              Text(
                'За останні 7 днів: $weeklySum',
                style: const TextStyle(fontSize: 11.0, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'ДО 100% МІШЕНІ',
              style: TextStyle(fontSize: 9.0, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2.0),
            Text(
              expectedDays,
              style: AppTextStyles.orbitronHeading(fontSize: 13.0, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}
