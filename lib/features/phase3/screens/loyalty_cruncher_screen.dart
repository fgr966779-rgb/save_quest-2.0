import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class LoyaltyCruncherScreen extends ConsumerWidget {
  const LoyaltyCruncherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('BONUS CRUNCH', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => _addCard(context, db),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: FutureBuilder<List<LoyaltyCard>>(
        future: db.select(db.loyaltyCards).get(),
        builder: (context, snap) {
          final cards = snap.data ?? [];
          if (cards.isEmpty) {
            return Center(child: Text('Додайте карту лояльності', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: cards.length,
            itemBuilder: (ctx, i) {
              final c = cards[i];
              final valueInUah = (c.pointsBalance * c.pointsToMoney) / 100;
              final canRedeem = c.pointsBalance >= c.minRedeemPoints;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(c.storeName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    if (c.cardNumber != null)
                      Text('**** ${c.cardNumber!.substring(c.cardNumber!.length > 4 ? c.cardNumber!.length - 4 : 0)}', style: GoogleFonts.shareTechMono(color: Colors.white38)),
                  ]),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('БАЛАНС БОНУСІВ', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                      Text('$1 pts', style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ]),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('ГРОШОВИЙ ЕКВІВАЛЕНТ', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                      Text('${valueInUah.toStringAsFixed(2)} ₴', style: GoogleFonts.shareTechMono(color: Colors.orange, fontSize: 20, fontWeight: FontWeight.bold)),
                    ]),
                  ]),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: canRedeem ? 1.0 : c.pointsBalance / c.minRedeemPoints, backgroundColor: Colors.white12, valueColor: AlwaysStoppedAnimation<Color>(canRedeem ? Colors.green : Colors.orange), minHeight: 4),
                  const SizedBox(height: 8),
                  Text(canRedeem ? 'Можна використати для знижки!' : 'Ще ${c.minRedeemPoints - c.pointsBalance} поінтів до мінімуму', style: GoogleFonts.shareTechMono(color: canRedeem ? Colors.green : Colors.white54, fontSize: 12)),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _addCard(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Нова карта', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Магазин', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              await db.into(db.loyaltyCards).insert(LoyaltyCardsCompanion.insert(
                userId: 1,
                storeName: 'Сільпо (Власний Рахунок)',
                cardNumber: drift.Value('1234567890123456'),
                pointsBalance: const drift.Value(15000),
                pointsToMoney: 1, // 1 point = 1 kopeck (0.01 UAH)
                minRedeemPoints: 500,
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
