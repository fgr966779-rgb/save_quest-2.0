import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class PriceRouletteScreen extends ConsumerStatefulWidget {
  const PriceRouletteScreen({super.key});

  @override
  ConsumerState<PriceRouletteScreen> createState() => _PriceRouletteScreenState();
}

class _PriceRouletteScreenState extends ConsumerState<PriceRouletteScreen> with SingleTickerProviderStateMixin {
  late AnimationController _spinCtrl;

  @override
  void initState() {
    super.initState();
    _spinCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('DROP ROULETTE', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<RouletteItem>>(
        future: db.select(db.rouletteItems).get(),
        builder: (context, snap) {
          final bets = snap.data ?? [];
          return Column(
            children: [
              const SizedBox(height: 40),
              // Roulette Wheel
              GestureDetector(
                onTap: () {
                  _spinCtrl.forward(from: 0);
                  db.into(db.rouletteItems).insert(RouletteItemsCompanion.insert(
                    productName: 'PS5 Pro',
                    currentPrice: 2500000,
                    predictedDropPrice: 2300000,
                    betAmount: 50,
                    outcome: const drift.Value('pending'),
                    betPlacedAt: DateTime.now(),
                    resolvesAt: DateTime.now().add(const Duration(days: 7)),
                  ));
                  setState((){});
                },
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: 5.0).animate(CurvedAnimation(parent: _spinCtrl, curve: Curves.easeOutCubic)),
                  child: Container(
                    width: 200, height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1A1F2E),
                      border: Border.all(color: Colors.purpleAccent, width: 4),
                      boxShadow: [BoxShadow(color: Colors.purpleAccent.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)],
                    ),
                    child: const Center(
                      child: Icon(Icons.casino, size: 80, color: Colors.purpleAccent),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('НАТИСНИ ЩОБ ПОСТАВИТИ НА ПАДІННЯ', style: GoogleFonts.orbitron(color: Colors.white54, fontSize: 12, letterSpacing: 1)),
              const SizedBox(height: 40),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: bets.length,
                  itemBuilder: (ctx, i) {
                    final b = bets[i];
                    final color = b.outcome == 'win' ? Colors.green : b.outcome == 'lose' ? Colors.red : Colors.amber;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1F2E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color.withValues(alpha: 0.5)),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(b.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text(b.outcome?.toUpperCase() ?? 'PENDING', style: GoogleFonts.orbitron(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                        ]),
                        const SizedBox(height: 8),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('Поточна: ${(b.currentPrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white54)),
                          Text('Прогноз: <${(b.predictedDropPrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white)),
                        ]),
                        const SizedBox(height: 8),
                        Text('Ставка: \$1 XP', style: GoogleFonts.shareTechMono(color: Colors.purpleAccent, fontWeight: FontWeight.bold)),
                      ]),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
