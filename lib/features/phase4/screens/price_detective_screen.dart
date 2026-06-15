import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class PriceDetectiveScreen extends ConsumerWidget {
  const PriceDetectiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('PRICE EYE', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown[300],
        onPressed: () => _investigate(context, db),
        child: const Icon(Icons.search, color: Colors.white),
      ),
      body: FutureBuilder<List<PriceDetectiveItem>>(
        future: db.select(db.priceDetectiveItems).get(),
        builder: (context, snap) {
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return Center(child: Text('Детектив готовий до розслідування', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final item = items[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.brown[300]!.withValues(alpha: 0.5)),
                  boxShadow: [BoxShadow(color: Colors.brown.withValues(alpha: 0.1), blurRadius: 12)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(item.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Icon(Icons.policy, color: Colors.brown[300]),
                  ]),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    _P('MIN (ЗАВЖДИ)', item.priceAllTimeMin, Colors.greenAccent),
                    _P('MAX (ЗАВЖДИ)', item.priceAllTimeMax, Colors.redAccent),
                    _P('СЕРЕДНЯ', item.priceAverage, Colors.white54),
                  ]),
                  const SizedBox(height: 16),
                  Text('Поточна ціна: ${(item.currentPrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  if (item.pricePattern != null) ...[
                    const SizedBox(height: 8),
                    Text('Паттерн: \$1', style: GoogleFonts.shareTechMono(color: Colors.orangeAccent, fontSize: 12)),
                  ],
                  if (item.aiDetectiveReport != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                      child: Text(item.aiDetectiveReport!, style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic)),
                    ),
                  ],
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _investigate(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Розслідування', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Товар', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[300]),
            onPressed: () async {
              await db.into(db.priceDetectiveItems).insert(PriceDetectiveItemsCompanion.insert(
                productName: 'Sony WH-1000XM5',
                searchQuery: 'sony wh 1000xm5',
                currentPrice: 1299900,
                priceAllTimeMin: 999900,
                priceAllTimeMax: 1599900,
                priceAverage: 1350000,
                pricePattern: drift.Value('volatile'),
                aiDetectiveReport: drift.Value('Ціна часто стрибає. Останній раз падала до мінімуму в листопаді. Можливо, варто зачекати святкових знижок.'),
                investigatedAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Знайти істину', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _P extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _P(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 8)),
      const SizedBox(height: 4),
      Text('${(value / 100).toStringAsFixed(0)}', style: GoogleFonts.shareTechMono(color: color, fontSize: 14)),
    ]);
  }
}
