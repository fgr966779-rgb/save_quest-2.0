import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class PriceOracleScreen extends ConsumerWidget {
  const PriceOracleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('PRICE ORACLE', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.cyan,
        onPressed: () => _showAddDialog(context, db),
        icon: const Icon(Icons.add, color: Colors.black),
        label: Text('ВІДСТЕЖИТИ', style: GoogleFonts.orbitron(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<PriceWatchItem>>(
        future: db.select(db.priceWatchItems).get(),
        builder: (context, snap) {
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return Center(child: Text('Немає товарів для відстеження', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final item = items[i];
              final diff = item.currentPrice - item.previousPrice;
              final color = diff < 0 ? Colors.green : diff > 0 ? Colors.red : Colors.white54;
              final icon = diff < 0 ? Icons.arrow_downward : diff > 0 ? Icons.arrow_upward : Icons.remove;
              final atTarget = item.currentPrice <= item.targetPrice;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: atTarget ? Colors.green.withValues(alpha: 0.5) : Colors.white12),
                  boxShadow: atTarget ? [BoxShadow(color: Colors.green.withValues(alpha: 0.1), blurRadius: 12)] : [],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(item.name, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                    if (item.storeName != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(6)),
                        child: Text(item.storeName!, style: GoogleFonts.orbitron(color: Colors.white54, fontSize: 9)),
                      ),
                  ]),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('ЦІНА', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                      Row(children: [
                        Text('${(item.currentPrice / 100).toStringAsFixed(2)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        if (diff != 0) ...[
                          const SizedBox(width: 8),
                          Icon(icon, color: color, size: 14),
                          Text('${(diff.abs() / 100).toStringAsFixed(2)}', style: GoogleFonts.shareTechMono(color: color, fontSize: 12)),
                        ]
                      ]),
                    ]),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('ЦІЛЬОВА', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                      Text('${(item.targetPrice / 100).toStringAsFixed(2)} ₴', style: GoogleFonts.shareTechMono(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
                    ]),
                  ]),
                  if (item.aiPrediction != null) ...[
                    const SizedBox(height: 12),
                    Text('ORACLE PREDICTION:', style: GoogleFonts.orbitron(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(item.aiPrediction!, style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 12)),
                  ],
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Відстежити ціну', style: GoogleFonts.orbitron(color: Colors.white)),
        content: Column(mainAxisSize: MainAxisSize.min, children: const [
          TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Назва товару або лінк', hintStyle: TextStyle(color: Colors.white38))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
            onPressed: () async {
              await db.into(db.priceWatchItems).insert(PriceWatchItemsCompanion.insert(
                userId: 1,
                name: 'Apple AirPods Pro',
                searchQuery: 'AirPods Pro 2',
                currentPrice: 950000,
                previousPrice: 990000,
                targetPrice: 850000,
                alertType: 'both',
                createdAt: DateTime.now(),
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
