import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class PriceMatchScreen extends ConsumerWidget {
  const PriceMatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('MATCH BLADE', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        onPressed: () => _addMatchRequest(context, db),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('НОВИЙ ЗАПИТ', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<PriceMatchRequest>>(
        future: db.select(db.priceMatchRequests).get(),
        builder: (context, snap) {
          final requests = snap.data ?? [];
          if (requests.isEmpty) {
            return Center(child: Text('Немає активних запитів Price Match', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: requests.length,
            itemBuilder: (ctx, i) {
              final r = requests[i];
              final statusColor = r.status == 'approved' ? Colors.green : r.status == 'rejected' ? Colors.red : Colors.amber;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(child: Text(r.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                      child: Text(r.status.toUpperCase(), style: GoogleFonts.orbitron(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(r.targetStore, style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                      Text('${(r.targetStorePrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 16, decoration: TextDecoration.lineThrough)),
                    ]),
                    const Icon(Icons.compare_arrows, color: Colors.white38),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(r.competitorStore, style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                      Text('${(r.competitorPrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                  ]),
                  const SizedBox(height: 12),
                  Text('Економія: ${((r.targetStorePrice - r.competitorPrice) / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 12)),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _addMatchRequest(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Новий Match', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Назва товару', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await db.into(db.priceMatchRequests).insert(PriceMatchRequestsCompanion.insert(
                productName: 'Телевізор Samsung 55"',
                targetStorePrice: 2500000,
                competitorPrice: 2200000,
                targetStore: 'Comfy',
                competitorStore: 'Rozetka',
                status: 'pending',
                submittedAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Відправити', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
