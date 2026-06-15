import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class PriceSharkScreen extends ConsumerWidget {
  const PriceSharkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('PRICE SHARK', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () => _addSharkItem(context, db),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<List<PriceSharkItem>>(
        future: db.select(db.priceSharkItems).get(),
        builder: (context, snap) {
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return Center(child: Text('Додайте товар для відстеження ціни', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
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
                  border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.5)),
                  boxShadow: item.currentPrice <= item.lowestPrice ? [BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.2), blurRadius: 12)] : [],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(child: Text(item.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                    if (item.currentPrice <= item.lowestPrice)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.blueAccent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                        child: Text('НАЙКРАЩА ЦІНА', style: GoogleFonts.orbitron(color: Colors.blueAccent, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                  ]),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    _PriceStat('ПОТОЧНА', item.currentPrice, Colors.white),
                    _PriceStat('МІНІМУМ', item.lowestPrice, Colors.green),
                    _PriceStat('МАКСИМУМ', item.highestPrice, Colors.redAccent),
                  ]),
                  const SizedBox(height: 16),
                  Row(children: [
                    Icon(Icons.arrow_downward, color: Colors.green, size: 16),
                    Text('Впала на \$1% від максимуму', style: GoogleFonts.shareTechMono(color: Colors.green, fontSize: 12)),
                  ]),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _addSharkItem(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Відстежити товар', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Назва товару', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () async {
              await db.into(db.priceSharkItems).insert(PriceSharkItemsCompanion.insert(
                userId: 1,
                productName: 'MacBook Air M3',
                searchQuery: 'MacBook Air M3 256GB',
                lowestPrice: 4200000,
                highestPrice: 4800000,
                currentPrice: 4250000,
                dropPercentage: 11,
                lastUpdatedAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Додати', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _PriceStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _PriceStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
      const SizedBox(height: 4),
      Text('${(value / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
    ]);
  }
}
