import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/database.dart';

import '../../gamification/providers/quest_provider.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

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
    final depositsAsync = ref.watch(depositsBreakdownProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              AppLocalizations.get(locale, 'analytics_title'),
              style: AppTypography.h1(context),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.get(locale, 'analytics_subtitle'),
              style: AppTypography.body(context),
            ),
            const SizedBox(height: 24.0),

            // Allocations breakdown (Pie chart)
            _buildAllocationBreakdownCard(goalsAsync, locale),
            const SizedBox(height: 20.0),

            // Timeline Projections Graph (Line Chart)
            _buildTimelineChartCard(depositsAsync, locale),
            const SizedBox(height: 20.0),

            // Projections breakdown card
            _buildProjectionsSummaryCard(goalsAsync, depositsAsync, locale),
            const SizedBox(height: 20.0),

            // Penalty / Avoided Stats link
            AppButton(
              label: AppLocalizations.get(locale, 'stats_title'),
              onPressed: () => context.push('/savings-stats'),
              variant: ButtonVariant.secondary,
              icon: const Icon(Icons.bar_chart_rounded, size: 18),
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }

  Widget _buildAllocationBreakdownCard(AsyncValue<List<Goal>> goalsAsync, String locale) {
    return goalsAsync.when(
      loading: () => const SkeletonList(itemCount: 2),
      error: (_, __) => const SizedBox.shrink(),
      data: (goals) {
        if (goals.isEmpty) return const SizedBox.shrink();

        final int totalA = goals.firstWhere((g) => g.id == 'goal_a').currentAmount;
        final int totalB = goals.firstWhere((g) => g.id == 'goal_b').currentAmount;
        final int total = totalA + totalB;

        final double percentA = total > 0 ? (totalA / total * 100) : 50;
        final double percentB = total > 0 ? (totalB / total * 100) : 50;

        final brightness = Theme.of(context).brightness;

        return SurfaceCard(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.get(locale, 'analytics_distribution'),
                style: AppTypography.h3(context),
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
                            color: AppColors.goalA,
                            value: percentA,
                            title: '${percentA.toInt()}%',
                            radius: 20,
                            titleStyle: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary(brightness),
                            ),
                          ),
                          PieChartSectionData(
                            color: AppColors.goalB,
                            value: percentB,
                            title: '${percentB.toInt()}%',
                            radius: 20,
                            titleStyle: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary(brightness),
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
                          '${formatAmount(totalA)} ₴',
                          AppColors.goalA,
                        ),
                        const SizedBox(height: 12.0),
                        _buildLegendItem(
                          goals.firstWhere((g) => g.id == 'goal_b').name,
                          '${formatAmount(totalB)} ₴',
                          AppColors.goalB,
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
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall(context),
              ),
              Text(
                amount,
                style: AppTypography.amount(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineChartCard(AsyncValue<List<DepositBreakdown>> depositsAsync, String locale) {
    return depositsAsync.when(
      loading: () => const SkeletonList(itemCount: 2),
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
          cumA += centsToDisplay(timeline[i].goalAAmount);
          cumB += centsToDisplay(timeline[i].goalBAmount);
          spotsA.add(FlSpot((i + 1).toDouble(), cumA));
          spotsB.add(FlSpot((i + 1).toDouble(), cumB));
        }

        // Limit spot lengths for chart readability
        if (spotsA.length > 8) {
          spotsA = spotsA.sublist(spotsA.length - 8);
          spotsB = spotsB.sublist(spotsB.length - 8);
        }

        final brightness = Theme.of(context).brightness;
        final gridColor = AppColors.border(brightness).withValues(alpha: 0.15);

        return SurfaceCard(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.get(locale, 'analytics_dynamics'),
                style: AppTypography.h3(context),
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
                        color: gridColor,
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
                        color: AppColors.goalA,
                        barWidth: 2.5,
                        dotData: FlDotData(show: spotsA.length < 5),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.goalA.withValues(alpha: 0.06),
                        ),
                      ),
                      // Goal B progress line
                      LineChartBarData(
                        spots: spotsB,
                        isCurved: true,
                        color: AppColors.goalB,
                        barWidth: 2.5,
                        dotData: FlDotData(show: spotsB.length < 5),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.goalB.withValues(alpha: 0.06),
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

  Widget _buildProjectionsSummaryCard(
    AsyncValue<List<Goal>> goalsAsync,
    AsyncValue<List<DepositBreakdown>> depositsAsync,
    String locale,
  ) {
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
              if (dep.deposit.createdAt.isAfter(oneWeekAgo)) {
                totalAWeekly += centsToDisplay(dep.goalAAmount);
                totalBWeekly += centsToDisplay(dep.goalBAmount);
              }
            }

            final double remainingA =
                (centsToDisplay(goalA.targetAmount) - centsToDisplay(goalA.currentAmount))
                    .clamp(0, double.infinity);
            final double remainingB =
                (centsToDisplay(goalB.targetAmount) - centsToDisplay(goalB.currentAmount))
                    .clamp(0, double.infinity);

            final double rateA = totalAWeekly / 7.0;
            final double rateB = totalBWeekly / 7.0;

            final String daysRemainingA =
                rateA > 0 ? '${(remainingA / rateA).ceil()}${AppLocalizations.get(locale, 'daily_bonus_days')}' : '∞';
            final String daysRemainingB =
                rateB > 0 ? '${(remainingB / rateB).ceil()}${AppLocalizations.get(locale, 'daily_bonus_days')}' : '∞';

            return SurfaceCard(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.get(locale, 'analytics_projection'),
                    style: AppTypography.h3(context),
                  ),
                  const SizedBox(height: 16.0),
                  _buildProjectionSummaryRow(
                    goalA.name,
                    '${totalAWeekly.toStringAsFixed(2)} ₴',
                    daysRemainingA,
                    AppColors.goalA,
                    locale,
                  ),
                  Divider(
                    color: AppColors.border(Theme.of(context).brightness),
                    height: 24.0,
                  ),
                  _buildProjectionSummaryRow(
                    goalB.name,
                    '${totalBWeekly.toStringAsFixed(2)} ₴',
                    daysRemainingB,
                    AppColors.goalB,
                    locale,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProjectionSummaryRow(
    String goalName,
    String weeklySum,
    String expectedDays,
    Color accentColor,
    String locale,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                goalName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall(context, color: accentColor),
              ),
              const SizedBox(height: 3.0),
              Text(
                '${AppLocalizations.get(locale, 'analytics_weekly_sum')}$weeklySum',
                style: AppTypography.caption(context),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppLocalizations.get(locale, 'analytics_to_100'),
              style: AppTypography.overline(context),
            ),
            const SizedBox(height: 2.0),
            Text(
              expectedDays,
              style: AppTypography.metric(context),
            ),
          ],
        ),
      ],
    );
  }
}
