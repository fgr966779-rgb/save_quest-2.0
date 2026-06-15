import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class PriceElasticityScreen extends ConsumerWidget {
  const PriceElasticityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('FLEX PRICE', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amberAccent,
        onPressed: () => _analyze(context, db),
        icon: const Icon(Icons.analytics, color: Colors.black),
        label: Text('ДОСЛІДИТИ', style: GoogleFonts.orbitron(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<ElasticityItem>>(
        future: db.select(db.elasticityItems).get(),
        builder: (context, snap) {
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return Center(child: Text('Аналіз еластичності цін', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final item = items[i];
              final catColor = item.category == 'elastic' ? Colors.green : (item.category == 'inelastic' ? Colors.red : Colors.orange);
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: catColor.withValues(alpha: 0.5)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(item.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: catColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                      child: Text(item.category.toUpperCase(), style: GoogleFonts.orbitron(color: catColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  Text('БАЗОВА ЦІНА: ${(item.basePrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text('Індекс еластичності: ${item.elasticityScore.toStringAsFixed(2)}', style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 12)),
                  if (item.insight != null) ...[
                    const SizedBox(height: 16),
                    Text('IНСАЙТ:', style: GoogleFonts.orbitron(color: Colors.amberAccent, fontSize: 10)),
                    const SizedBox(height: 4),
                    Text(item.insight!, style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic)),
                  ],
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _analyze(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Еластичність попиту', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Товар', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amberAccent),
            onPressed: () async {
              await db.into(db.elasticityItems).insert(ElasticityItemsCompanion.insert(
                productName: 'Кава в зернах 1кг',
                basePrice: 50000,
                elasticityScore: -0.2,
                category: 'inelastic',
                insight: drift.Value('Цей товар слабо реагує на зміну ціни. Якщо ціна зросте на 10%, попит впаде лише на 2%. Не варто чекати великих знижок.'),
                calculatedAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Дослідити', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
