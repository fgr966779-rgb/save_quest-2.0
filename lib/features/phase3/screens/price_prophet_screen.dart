import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class PriceProphetScreen extends ConsumerStatefulWidget {
  const PriceProphetScreen({super.key});

  @override
  ConsumerState<PriceProphetScreen> createState() => _PriceProphetScreenState();
}

class _PriceProphetScreenState extends ConsumerState<PriceProphetScreen> with SingleTickerProviderStateMixin {
  late AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  Color _recColor(String rec) {
    if (rec == 'buy_now' || rec == 'urgent') return Colors.greenAccent;
    if (rec == 'wait') return Colors.orangeAccent;
    return Colors.cyan;
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('PROPHET AI', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purpleAccent,
        onPressed: () => _predictDialog(context, db),
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: Text('ЗАПИТАТИ ОРАКУЛА', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<PriceForecast>>(
        future: db.select(db.priceForecasts).get(),
        builder: (context, snap) {
          final forecasts = snap.data ?? [];
          if (forecasts.isEmpty) {
            return Center(
              child: AnimatedBuilder(
                animation: _glowCtrl,
                builder: (context, child) {
                  return Container(
                    width: 200, height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.purpleAccent.withValues(alpha: 0.2 + (_glowCtrl.value * 0.4)), blurRadius: 40 + (_glowCtrl.value * 20))],
                    ),
                    child: const Icon(Icons.remove_red_eye, size: 80, color: Colors.purpleAccent),
                  );
                },
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: forecasts.length,
            itemBuilder: (ctx, i) {
              final f = forecasts[i];
              final rColor = _recColor(f.recommendation);
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.5)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(child: Text(f.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: rColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                      child: Text(f.recommendation.toUpperCase(), style: GoogleFonts.orbitron(color: rColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    _ForecastCol('Поточна', f.currentPrice, Colors.white54),
                    _ForecastCol('7 днів', f.forecastPrice7d, Colors.cyan),
                    _ForecastCol('30 днів', f.forecastPrice30d, Colors.purpleAccent),
                  ]),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(value: f.confidence, backgroundColor: Colors.white12, valueColor: const AlwaysStoppedAnimation<Color>(Colors.purpleAccent), minHeight: 4),
                  const SizedBox(height: 4),
                  Text('Точність прогнозу: ${(f.confidence * 100).toInt()}%', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10)),
                  if (f.reasoning != null) ...[
                    const SizedBox(height: 12),
                    Text(f.reasoning!, style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic)),
                  ],
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _predictDialog(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Що прогнозуємо?', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Товар', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
            onPressed: () async {
              await db.into(db.priceForecasts).insert(PriceForecastsCompanion.insert(
                productName: 'EcoFlow Delta 2',
                currentPrice: 4200000,
                forecastPrice7d: 4200000,
                forecastPrice30d: 3800000,
                forecastPrice90d: 3500000,
                confidence: 0.85,
                reasoning: const drift.Value('Сезонний аналіз цінових тенденцій показав зниження.'),
                recommendation: 'wait',
                generatedAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Прогноз', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _ForecastCol extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _ForecastCol(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
      const SizedBox(height: 4),
      Text('${(value / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
    ]);
  }
}
