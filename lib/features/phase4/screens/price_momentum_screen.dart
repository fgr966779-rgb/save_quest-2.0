import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class PriceMomentumScreen extends ConsumerWidget {
  const PriceMomentumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('MOMENTUM', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () => _addMomentum(context, db),
        child: const Icon(Icons.show_chart, color: Colors.black),
      ),
      body: FutureBuilder<List<MomentumItem>>(
        future: db.select(db.momentumItems).get(),
        builder: (context, snap) {
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return Center(child: Text('Немає даних про моментум цін', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final item = items[i];
              final trendColor = item.trend == 'falling' ? Colors.green : (item.trend == 'rising' ? Colors.red : Colors.cyan);
              final trendIcon = item.trend == 'falling' ? Icons.trending_down : (item.trend == 'rising' ? Icons.trending_up : Icons.trending_flat);
              final rec = item.trend == 'falling' ? 'Зараз добрий час купити' : 'Чекай';
              
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: trendColor.withValues(alpha: 0.5)),
                  boxShadow: [BoxShadow(color: trendColor.withValues(alpha: 0.1), blurRadius: 12)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(item.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Icon(trendIcon, color: trendColor, size: 24),
                  ]),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    _PriceCol('30 ДНІВ ТОМУ', item.price30dAgo, Colors.white38),
                    _PriceCol('7 ДНІВ ТОМУ', item.price7dAgo, Colors.white54),
                    _PriceCol('ПОТОЧНА', item.currentPrice, Colors.white),
                  ]),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Моментум (30д): ${item.momentum30d > 0 ? '+' : ''}${item.momentum30d.toStringAsFixed(1)}%', style: GoogleFonts.shareTechMono(color: trendColor, fontSize: 14, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: trendColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                      child: Text(rec.toUpperCase(), style: GoogleFonts.orbitron(color: trendColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _addMomentum(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Новий трекер', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Товар', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
            onPressed: () async {
              await db.into(db.momentumItems).insert(MomentumItemsCompanion.insert(
                productName: 'SSD 2TB Samsung',
                price30dAgo: 750000,
                price7dAgo: 700000,
                currentPrice: 650000,
                momentum7d: -7.1,
                momentum30d: -13.3,
                trend: 'falling',
                updatedAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Додати', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

class _PriceCol extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _PriceCol(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 8)),
      const SizedBox(height: 4),
      Text('${(value / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: color, fontSize: 14)),
    ]);
  }
}
