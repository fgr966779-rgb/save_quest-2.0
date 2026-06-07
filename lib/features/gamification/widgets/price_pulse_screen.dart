import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import '../providers/price_hunter_provider.dart';
import 'price_forecast_chart.dart';

class PricePulseScreen extends ConsumerWidget {
  final Goal goal;

  const PricePulseScreen({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Price Pulse', style: TextStyle(color: Colors.cyanAccent, fontFamily: 'Courier')),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Аналіз ринку...'), backgroundColor: Colors.black87),
              );
              final result = await ref.read(priceHunterProvider.notifier).updatePrice(goal.id, forceManual: true);
              if (result != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result.message),
                    backgroundColor: result.success ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                );
                
                if (result.aiComment != null) {
                  final prefs = await SharedPreferences.getInstance();
                  final muted = prefs.getBool('oracleMuted_${goal.id}') ?? false;
                  if (!muted && context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.black87,
                        title: const Text('Кібер-Оракул каже:', style: TextStyle(color: Colors.cyanAccent)),
                        content: Text(result.aiComment!, style: const TextStyle(color: Colors.white)),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              await prefs.setBool('oracleMuted_${goal.id}', true);
                              if (context.mounted) Navigator.pop(context);
                            },
                            child: const Text('Не показувати знову', style: TextStyle(color: Colors.grey)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Зрозуміло', style: TextStyle(color: Colors.cyanAccent)),
                          )
                        ],
                      )
                    );
                  }
                }
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Ціль: ${goal.name}',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            
            // The Trend Chart
            PriceForecastChart(goal: goal),
            
            const SizedBox(height: 24),
            
            // History List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'Історія Цін',
                style: TextStyle(color: Colors.cyanAccent, fontSize: 18),
              ),
            ),
            const SizedBox(height: 8),
            
            StreamBuilder<List<PriceHistoryEntry>>(
              stream: ref.watch(databaseProvider).watchPriceHistory(goal.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
                }
                
                final history = snapshot.data ?? [];
                if (history.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Немає історичних даних.', style: TextStyle(color: Colors.grey)),
                  );
                }
                
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final entry = history[index];
                    
                    // Compare with previous (which is index + 1 in a descending list)
                    double? deltaPercent;
                    if (index + 1 < history.length) {
                      final prev = history[index + 1];
                      deltaPercent = ((entry.priceKopecks - prev.priceKopecks) / prev.priceKopecks) * 100;
                    }
                    
                    return ListTile(
                      leading: const Icon(Icons.history, color: Colors.grey),
                      title: Text('${(entry.priceKopecks / 100).toStringAsFixed(0)} грн', style: const TextStyle(color: Colors.white)),
                      subtitle: Text(
                        '${entry.cachedAt.day.toString().padLeft(2, '0')}.${entry.cachedAt.month.toString().padLeft(2, '0')} ${entry.cachedAt.hour.toString().padLeft(2, '0')}:${entry.cachedAt.minute.toString().padLeft(2, '0')} • ${entry.store}',
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      trailing: deltaPercent != null
                          ? Text(
                              '${deltaPercent > 0 ? '+' : ''}${deltaPercent.toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: deltaPercent < 0 ? Colors.greenAccent : (deltaPercent > 0 ? Colors.redAccent : Colors.grey),
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
