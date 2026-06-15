import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class PriceFreezeScreen extends ConsumerWidget {
  const PriceFreezeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('FREEZE RAY', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () => _addFreeze(context, db),
        icon: const Icon(Icons.ac_unit, color: Colors.black),
        label: Text('ЗАМОРОЗИТИ', style: GoogleFonts.orbitron(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<FreezeChallenge>>(
        future: db.select(db.freezeChallenges).get(),
        builder: (context, snap) {
          final challenges = snap.data ?? [];
          if (challenges.isEmpty) {
            return Center(child: Text('Заморозьте ціну та почніть накопичувати', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: challenges.length,
            itemBuilder: (ctx, i) {
              final c = challenges[i];
              final progress = (c.currentSavingsDays / c.targetSavingsDays).clamp(0.0, 1.0);
              final isBroken = c.currentPrice != null && c.currentPrice! > c.frozenPrice;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isBroken ? Colors.red.withValues(alpha: 0.5) : Colors.lightBlueAccent.withValues(alpha: 0.5)),
                  boxShadow: isBroken ? [] : [BoxShadow(color: Colors.lightBlueAccent.withValues(alpha: 0.2), blurRadius: 12)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(child: Text(c.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                    Icon(isBroken ? Icons.local_fire_department : Icons.ac_unit, color: isBroken ? Colors.red : Colors.lightBlueAccent, size: 20),
                  ]),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('ЗАМОРОЖЕНА ЦІНА', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                      Text('${(c.frozenPrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.lightBlueAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                    if (c.currentPrice != null)
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('ПОТОЧНА ЦІНА', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                        Text('${(c.currentPrice! / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: isBroken ? Colors.redAccent : Colors.white, fontSize: 16)),
                      ]),
                  ]),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(value: progress, backgroundColor: Colors.white12, valueColor: AlwaysStoppedAnimation<Color>(isBroken ? Colors.red : Colors.lightBlueAccent), minHeight: 8, borderRadius: BorderRadius.circular(4)),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Збережено днів: \$1 / \$1', style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 12)),
                    Text('+\$1 XP', style: GoogleFonts.orbitron(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                  ]),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _addFreeze(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Заморозити ціну', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Назва товару', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
            onPressed: () async {
              await db.into(db.freezeChallenges).insert(FreezeChallengesCompanion.insert(
                userId: 1,
                productName: 'Гітара Yamaha',
                frozenPrice: 850000,
                currentPrice: const drift.Value(850000),
                targetSavingsDays: 30,
                currentSavingsDays: const drift.Value(5),
                xpReward: 500,
                startedAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Заморозити', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
