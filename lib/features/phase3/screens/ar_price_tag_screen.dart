import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class ARPriceTagScreen extends ConsumerWidget {
  const ARPriceTagScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('AR SCANNER', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.tealAccent,
        onPressed: () => _mockScan(context, db),
        icon: const Icon(Icons.camera_alt, color: Colors.black),
        label: Text('СКАНУВАТИ ЦІННИК', style: GoogleFonts.orbitron(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<ARScanEntry>>(
        future: db.select(db.aRScanEntries).get(),
        builder: (context, snap) {
          final scans = snap.data ?? [];
          if (scans.isEmpty) {
            return Center(child: Text('Наведіть камеру на цінник в магазині', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: scans.length,
            itemBuilder: (ctx, i) {
              final s = scans[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: s.isFairPrice ? Colors.green.withValues(alpha: 0.5) : Colors.red.withValues(alpha: 0.5)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(s.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Icon(s.isFairPrice ? Icons.thumb_up : Icons.warning, color: s.isFairPrice ? Colors.green : Colors.red, size: 20),
                  ]),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('МАГАЗИН', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                      Text('${(s.scannedPrice / 100).toStringAsFixed(2)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 18, decoration: s.isFairPrice ? TextDecoration.none : TextDecoration.lineThrough)),
                    ]),
                    if (s.onlinePrice != null)
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('ОНЛАЙН', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                        Text('${(s.onlinePrice! / 100).toStringAsFixed(2)} ₴', style: GoogleFonts.shareTechMono(color: Colors.tealAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                      ]),
                  ]),
                  if (!s.isFairPrice && s.savingsPotential > 0) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text('Переплачуєш ${(s.savingsPotential / 100).toStringAsFixed(0)} ₴! Замов онлайн.', style: GoogleFonts.shareTechMono(color: Colors.redAccent, fontSize: 13)),
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

  void _mockScan(BuildContext context, AppDatabase db) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator(color: Colors.tealAccent)),
    );
    await Future.delayed(const Duration(seconds: 2));
    await db.into(db.aRScanEntries).insert(ARScanEntriesCompanion.insert(
      productName: 'Sony WH-1000XM5',
      scannedPrice: 1599900,
      onlinePrice: drift.Value(1299900),
      storeName: drift.Value('Comfy'),
      isFairPrice: const drift.Value(false),
      savingsPotential: 300000,
      scannedAt: DateTime.now(),
    ));
    if (context.mounted) Navigator.pop(context);
  }
}
