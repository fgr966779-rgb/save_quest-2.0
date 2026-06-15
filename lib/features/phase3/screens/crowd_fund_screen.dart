import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class CrowdFundScreen extends ConsumerWidget {
  const CrowdFundScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('FUND SWARM', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6B00FF),
        onPressed: () => _addWishlist(context, db),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('НОВИЙ ЗБІР', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<CrowdFundWishlist>>(
        future: db.select(db.crowdFundWishlists).get(),
        builder: (context, snap) {
          final wishlists = snap.data ?? [];
          if (wishlists.isEmpty) {
            return Center(child: Text('Немає активних зборів', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: wishlists.length,
            itemBuilder: (ctx, i) {
              final w = wishlists[i];
              final progress = w.targetAmount > 0 ? (w.collectedAmount / w.targetAmount).clamp(0.0, 1.0) : 0.0;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF1A1F2E), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF6B00FF).withValues(alpha: 0.5))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(w.itemName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    IconButton(icon: const Icon(Icons.share, color: Colors.cyan, size: 20), onPressed: () {}),
                  ]),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: progress.toDouble(), backgroundColor: Colors.white12, valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6B00FF)), minHeight: 8, borderRadius: BorderRadius.circular(4)),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('${(w.collectedAmount / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('ЦІЛЬ: ${(w.targetAmount / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 12)),
                  ]),
                  const SizedBox(height: 16),
                  Text('КОД: $1', style: GoogleFonts.orbitron(color: Colors.cyan, fontSize: 12, letterSpacing: 2)),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _addWishlist(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Створити збір', style: GoogleFonts.orbitron(color: Colors.white)),
        content: Column(mainAxisSize: MainAxisSize.min, children: const [
          TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'На що збираємо?', hintStyle: TextStyle(color: Colors.white38))),
          SizedBox(height: 12),
          TextField(style: TextStyle(color: Colors.white), keyboardType: TextInputType.number, decoration: InputDecoration(hintText: 'Сума (грн)', hintStyle: TextStyle(color: Colors.white38))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B00FF)),
            onPressed: () async {
              await db.into(db.crowdFundWishlists).insert(CrowdFundWishlistsCompanion.insert(
                userId: 1,
                itemName: 'Новий Макбук',
                targetAmount: 5000000,
                shareCode: 'MAC-88F2',
                createdAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('СТВОРИТИ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
