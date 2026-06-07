import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import '../providers/price_hunter_provider.dart';
import '../services/price_pulse_service.dart';

class PriceForecastChart extends ConsumerWidget {
  final Goal goal;

  const PriceForecastChart({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<PriceTrendForecast?>(
      future: ref.read(priceHunterProvider.notifier).getForecast(goal.id),
      builder: (context, forecastSnapshot) {
        return StreamBuilder<List<PriceHistoryEntry>>(
          stream: ref.read(databaseProvider).watchPriceHistory(goal.id, limit: 10),
          builder: (context, historySnapshot) {
            if (historySnapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator(color: Colors.cyanAccent)),
              );
            }

            final history = historySnapshot.data ?? [];
            if (history.isEmpty) {
              return _buildEmptyState(context, ref);
            }

            final forecast = forecastSnapshot.data;
            return _buildChart(context, history, forecast);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_graph, color: Colors.grey, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Недостатньо даних для тренду',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.read(priceHunterProvider.notifier).updatePrice(goal.id, forceManual: true);
              },
              child: const Text('Оновити ціну', style: TextStyle(color: Colors.cyanAccent)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<PriceHistoryEntry> historyReversed, PriceTrendForecast? forecast) {
    // Reverse to chronological order
    final history = historyReversed.reversed.toList();
    
    // Convert to spots
    final spots = <FlSpot>[];
    double minX = 0;
    double maxX = (history.length - 1).toDouble();
    double minY = double.infinity;
    double maxY = 0;

    for (int i = 0; i < history.length; i++) {
      final y = history[i].priceKopecks / 100;
      spots.add(FlSpot(i.toDouble(), y));
      if (y < minY) minY = y;
      if (y > maxY) maxY = y;
    }

    // Add forecast point if available
    final forecastSpots = <FlSpot>[];
    if (forecast != null && history.length >= 2) {
      final lastSpot = spots.last;
      forecastSpots.add(lastSpot); // Start from last known point
      
      final forecastY = forecast.expectedPriceKopecks30d / 100;
      forecastSpots.add(FlSpot(maxX + 1, forecastY)); // Assuming X+1 is the forecast horizon
      
      maxX += 1;
      if (forecastY < minY) minY = forecastY;
      if (forecastY > maxY) maxY = forecastY;
    }

    // Add savings line
    final savingsSpots = <FlSpot>[];
    final savingsCurrent = goal.currentAmount / 100;
    // Assuming savings started at 0 on X=0 (very simplified)
    savingsSpots.add(FlSpot(0, 0));
    savingsSpots.add(FlSpot(maxX, savingsCurrent));
    if (savingsCurrent > maxY) maxY = savingsCurrent;

    // Add padding to Y axis
    final padding = (maxY - minY) * 0.2;
    if (padding == 0) {
      minY -= 100;
      maxY += 100;
    } else {
      minY -= padding;
      maxY += padding;
    }

    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.only(top: 24, right: 24, left: 8, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                minX: minX,
                maxX: maxX,
                minY: minY > 0 ? minY : 0,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white12,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                            textAlign: TextAlign.right,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Actual Price Line
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.white70,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(radius: 4, color: Colors.white70, strokeWidth: 0),
                    ),
                  ),
                  // Forecast Line (Dashed)
                  if (forecastSpots.isNotEmpty)
                    LineChartBarData(
                      spots: forecastSpots,
                      isCurved: false,
                      color: Colors.orangeAccent,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dashArray: [5, 5], // Dashed line
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(radius: 3, color: Colors.orangeAccent, strokeWidth: 0),
                      ),
                    ),
                  // Savings Line
                  LineChartBarData(
                    spots: savingsSpots,
                    isCurved: false,
                    color: const Color(0xFF00D4FF),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toInt()} грн',
                          TextStyle(
                            color: spot.bar.color ?? Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Legend and Disclaimer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(color: Colors.white70, text: 'Ціна'),
              const SizedBox(width: 12),
              _LegendItem(color: const Color(0xFF00D4FF), text: 'Накопичення'),
              if (forecast != null) ...[
                const SizedBox(width: 12),
                _LegendItem(color: Colors.orangeAccent, text: 'Прогноз', isDashed: true),
              ]
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Прогноз базується на історичних трендах. Не є фінансовою порадою.',
            style: TextStyle(color: Colors.grey, fontSize: 10, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  final bool isDashed;

  const _LegendItem({required this.color, required this.text, this.isDashed = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          color: isDashed ? Colors.transparent : color,
          child: isDashed 
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(width: 4, height: 3, color: color),
                  Container(width: 4, height: 3, color: color),
                ],
              )
            : null,
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
