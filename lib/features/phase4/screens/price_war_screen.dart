import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class PriceWarScreen extends ConsumerWidget {
  const PriceWarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('PRICE WAR', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        onPressed: () => _addWar(context, db),
        icon: const Icon(Icons.flash_on, color: Colors.white),
        label: Text('ВІДСТЕЖИТИ ВІЙНУ', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<PriceWarEntry>>(
        future: db.select(db.priceWarEntries).get(),
        builder: (context, snap) {
          final wars = snap.data ?? [];
          if (wars.isEmpty) {
            return Center(child: Text('Немає активних цінових війн', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: wars.length,
            itemBuilder: (ctx, i) {
              final w = wars[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
                  boxShadow: [BoxShadow(color: Colors.redAccent.withValues(alpha: 0.1), blurRadius: 16)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Center(child: Text(w.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
                  const SizedBox(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    _StoreCol(w.store1Name, w.store1Price, w.winner == 'store1'),
                    Text('VS', style: GoogleFonts.orbitron(color: Colors.redAccent, fontWeight: FontWeight.w900, fontSize: 24, fontStyle: FontStyle.italic)),
                    _StoreCol(w.store2Name, w.store2Price, w.winner == 'store2'),
                  ]),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text('Різниця: ${(w.priceDifference / 100).toStringAsFixed(0)} ₴. Найактивніша конкуренція зараз!', textAlign: TextAlign.center, style: GoogleFonts.shareTechMono(color: Colors.redAccent, fontSize: 12)),
                  ),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _addWar(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Нова війна', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Товар', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await db.into(db.priceWarEntries).insert(PriceWarEntriesCompanion.insert(
                productName: 'Телевізор LG OLED 55"',
                store1Name: 'Comfy',
                store1Price: 4200000,
                store2Name: 'Rozetka',
                store2Price: 4150000,
                priceDifference: 50000,
                winner: 'store2',
                detectedAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Почати', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _StoreCol extends StatelessWidget {
  final String name;
  final int price;
  final bool isWinner;
  const _StoreCol(this.name, this.price, this.isWinner);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(name, style: GoogleFonts.orbitron(color: isWinner ? Colors.white : Colors.white54, fontSize: 14, fontWeight: isWinner ? FontWeight.bold : FontWeight.normal)),
      const SizedBox(height: 8),
      Text('${(price / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: isWinner ? Colors.greenAccent : Colors.white38, fontSize: 18, fontWeight: FontWeight.bold)),
      if (isWinner) ...[
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: Colors.greenAccent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
          child: Text('WINNER', style: GoogleFonts.orbitron(color: Colors.greenAccent, fontSize: 8, fontWeight: FontWeight.bold)),
        ),
      ]
    ]);
  }
}
