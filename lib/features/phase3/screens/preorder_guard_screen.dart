import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class PreOrderGuardScreen extends ConsumerWidget {
  const PreOrderGuardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('PRE-GUARD', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: () => _addGuard(context, db),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: FutureBuilder<List<PreOrderGuard>>(
        future: db.select(db.preOrderGuards).get(),
        builder: (context, snap) {
          final guards = snap.data ?? [];
          if (guards.isEmpty) {
            return Center(child: Text('Немає активних передзамовлень', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: guards.length,
            itemBuilder: (ctx, i) {
              final g = guards[i];
              final isDrop = g.currentPrice != null && g.currentPrice! < g.preOrderPrice;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDrop ? Colors.red.withValues(alpha: 0.5) : Colors.cyan.withValues(alpha: 0.5)),
                  boxShadow: isDrop ? [BoxShadow(color: Colors.red.withValues(alpha: 0.2), blurRadius: 12)] : [],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(g.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('ЦІНА ПРЕДЗАМОВЛЕННЯ', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                      Text('${(g.preOrderPrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 16)),
                    ]),
                    if (g.currentPrice != null)
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('ПОТОЧНА НА РИНКУ', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                        Text('${(g.currentPrice! / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: isDrop ? Colors.redAccent : Colors.cyan, fontSize: 16, fontWeight: FontWeight.bold)),
                      ]),
                  ]),
                  if (isDrop) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text('Увага! Ціна впала на ${((g.preOrderPrice - g.currentPrice!) / 100).toStringAsFixed(0)} ₴. Можливо варто скасувати передзамовлення.', style: GoogleFonts.shareTechMono(color: Colors.redAccent, fontSize: 12)),
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

  void _addGuard(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Нове передзамовлення', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Назва гри/товару', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
            onPressed: () async {
              await db.into(db.preOrderGuards).insert(PreOrderGuardsCompanion.insert(
                productName: 'GTA VI',
                preOrderPrice: 350000,
                currentPrice: const drift.Value(320000), // Drop simulated
                priceDropAlert: const drift.Value(true),
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
