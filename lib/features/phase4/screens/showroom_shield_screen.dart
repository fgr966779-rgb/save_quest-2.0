import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class ShowroomShieldScreen extends ConsumerWidget {
  const ShowroomShieldScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('SHOWROOM SHIELD', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 3, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: () => _scan(context, db),
        icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
        label: Text('СКАНУВАТИ ТОВАР', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<PriceShieldScan>>(
        future: db.select(db.priceShieldScans).get(),
        builder: (context, snap) {
          final scans = snap.data ?? [];
          if (scans.isEmpty) {
            return Center(child: Text('Сканування штрих-коду в магазині\nдля порівняння з онлайн ціною', textAlign: TextAlign.center, style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 14)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: scans.length,
            itemBuilder: (ctx, i) {
              final scan = scans[i];
              final saved = (scan.inStorePrice - (scan.onlinePrice ?? scan.inStorePrice));
              final isFair = scan.isFairPrice;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: (isFair ? Colors.teal : Colors.redAccent).withValues(alpha: 0.5)),
                  boxShadow: [BoxShadow(color: (isFair ? Colors.teal : Colors.redAccent).withValues(alpha: 0.1), blurRadius: 12)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(scan.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: (isFair ? Colors.teal : Colors.redAccent).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                      child: Text(isFair ? 'ЧЕСНА ЦІНА' : 'ПЕРЕПЛАТА', style: GoogleFonts.orbitron(color: isFair ? Colors.teal : Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(scan.inStoreName, style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                      Text('${(scan.inStorePrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 18)),
                    ]),
                    if (scan.onlinePrice != null && scan.onlineStoreName != null)
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text(scan.onlineStoreName!, style: GoogleFonts.orbitron(color: Colors.tealAccent, fontSize: 10)),
                        Text('${(scan.onlinePrice! / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.tealAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                      ]),
                  ]),
                  if (!isFair && scan.savingsPotential > 0) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text('Можна заощадити: ${(scan.savingsPotential / 100).toStringAsFixed(0)} ₴ — купи онлайн!', textAlign: TextAlign.center, style: GoogleFonts.shareTechMono(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
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

  void _scan(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Сканування товару', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Назва або штрих-код', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () async {
              await db.into(db.priceShieldScans).insert(PriceShieldScansCompanion.insert(
                productName: 'Samsung Galaxy Tab S9',
                inStorePrice: 1999900,
                onlinePrice: const drift.Value(1750000),
                inStoreName: 'Фокстрот',
                onlineStoreName: const drift.Value('Rozetka'),
                savingsPotential: 249900,
                isFairPrice: false,
                scannedAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Порівняти', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
