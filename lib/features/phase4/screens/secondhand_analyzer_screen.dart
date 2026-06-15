import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class SecondhandAnalyzerScreen extends ConsumerWidget {
  const SecondhandAnalyzerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('RE-GEAR', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.tealAccent,
        onPressed: () => _analyzeItem(context, db),
        child: const Icon(Icons.search, color: Colors.black),
      ),
      body: FutureBuilder<List<SecondHandItem>>(
        future: db.select(db.secondHandItems).get(),
        builder: (context, snap) {
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return Center(child: Text('Аналізатор б/у ринку. Введіть товар.', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 14)));
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
                  border: Border.all(color: Colors.tealAccent.withValues(alpha: 0.5)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(item.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(item.condition.toUpperCase(), style: GoogleFonts.orbitron(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('НОВИЙ', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                      Text('${(item.newPrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 16)),
                    ]),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('Б/У (РЕКОМЕНДОВАНО)', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                      Text('${(item.recommendedUsedPrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.tealAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                  ]),
                  const SizedBox(height: 12),
                  Text('Платформа: $1 | Діапазон: ${(item.usedPriceMin / 100).toStringAsFixed(0)} - ${(item.usedPriceMax / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text('Амортизація: $1%/рік', style: GoogleFonts.shareTechMono(color: Colors.orangeAccent, fontSize: 12)),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _analyzeItem(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Аналіз товару', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Назва товару', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent),
            onPressed: () async {
              await db.into(db.secondHandItems).insert(SecondHandItemsCompanion.insert(
                productName: 'Sony PlayStation 5',
                newPrice: 2200000,
                usedPriceMin: 1400000,
                usedPriceMax: 1800000,
                recommendedUsedPrice: 1550000,
                depreciationRate: 15.5,
                condition: 'good',
                platform: 'OLX',
                analyzedAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Аналізувати', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
