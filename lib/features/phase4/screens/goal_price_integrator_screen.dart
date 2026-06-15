import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class GoalPriceIntegratorScreen extends ConsumerWidget {
  const GoalPriceIntegratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('GOAL SYNC', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        onPressed: () => _addLink(context, db),
        icon: const Icon(Icons.link, color: Colors.white),
        label: Text('ПРИВ\'ЯЗАТИ ТОВАР', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<GoalProductLink>>(
        future: db.select(db.goalProductLinks).get(),
        builder: (context, snap) {
          final links = snap.data ?? [];
          if (links.isEmpty) {
            return Center(child: Text('Синхронізація ціни мети з ринком', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: links.length,
            itemBuilder: (ctx, i) {
              final link = links[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.5)),
                  boxShadow: [BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.1), blurRadius: 12)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Мета #\$1', style: GoogleFonts.orbitron(color: Colors.white54, fontSize: 12)),
                    Icon(link.autoUpdateTarget ? Icons.sync : Icons.sync_disabled, color: link.autoUpdateTarget ? Colors.blueAccent : Colors.white38, size: 16),
                  ]),
                  const SizedBox(height: 8),
                  Text(link.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Поточна ціна: ${(link.linkedPrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white)),
                    Text(link.storeName ?? 'Any Store', style: GoogleFonts.shareTechMono(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                  ]),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _addLink(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Синхронізація ціни', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Товар', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () async {
              await db.into(db.goalProductLinks).insert(GoalProductLinksCompanion.insert(
                goalId: 1, // hardcoded for demo
                productName: 'MacBook Air M2',
                searchQuery: 'macbook air m2 8 256',
                linkedPrice: 4500000,
                storeName: drift.Value('Citrus'),
                autoUpdateTarget: const drift.Value(true),
                linkedAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Зв\'язати', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
