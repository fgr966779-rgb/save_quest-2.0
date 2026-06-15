import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class ReceiptScannerScreen extends ConsumerWidget {
  const ReceiptScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('RECEIPT RIP', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFFF00FF),
        onPressed: () => _mockScan(context, db),
        icon: const Icon(Icons.document_scanner, color: Colors.white),
        label: Text('СКАНУВАТИ', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<ScannedReceipt>>(
        future: db.select(db.scannedReceipts).get(),
        builder: (context, snap) {
          final receipts = snap.data ?? [];
          if (receipts.isEmpty) {
            return Center(child: Text('Відскануйте чек для аналізу витрат', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: receipts.length,
            itemBuilder: (ctx, i) {
              final r = receipts[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: r.isImpulseBuy ? Colors.red.withValues(alpha: 0.5) : const Color(0xFFFF00FF).withValues(alpha: 0.3)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(r.merchant, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('${(r.amount / 100).toStringAsFixed(2)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(6)),
                      child: Text(r.category, style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 10)),
                    ),
                    if (r.isImpulseBuy) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                        child: Text('ІМПУЛЬСНА ПОКУПКА', style: GoogleFonts.orbitron(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ]
                  ]),
                  if (r.savingsPotential > 0) ...[
                    const SizedBox(height: 12),
                    Row(children: [
                      const Icon(Icons.savings, color: Colors.green, size: 14),
                      const SizedBox(width: 4),
                      Text('Потенціал збереження: ${(r.savingsPotential / 100).toStringAsFixed(2)} ₴', style: GoogleFonts.shareTechMono(color: Colors.green, fontSize: 12)),
                    ]),
                  ],
                  if (r.aiMotivation != null) ...[
                    const SizedBox(height: 12),
                    Text(r.aiMotivation!, style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 12, fontStyle: FontStyle.italic)),
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
      builder: (ctx) => const Center(child: CircularProgressIndicator(color: Color(0xFFFF00FF))),
    );
    await Future.delayed(const Duration(seconds: 2));
    await db.into(db.scannedReceipts).insert(ScannedReceiptsCompanion.insert(
      userId: 1,
      merchant: 'Сільпо',
      amount: 145050,
      category: 'Гросері',
      savingsPotential: 25000,
      isImpulseBuy: const drift.Value(true),
      aiMotivation: const drift.Value('Ваш аналіз покупок завершено'),
      scannedAt: DateTime.now(),
    ));
    if (context.mounted) Navigator.pop(context); // close dialog
  }
}
