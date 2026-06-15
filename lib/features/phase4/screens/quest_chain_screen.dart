import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class QuestChainScreen extends ConsumerWidget {
  const QuestChainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('QUEST CHAIN', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () => _startChain(context, db),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: FutureBuilder<List<QuestChain>>(
        future: db.select(db.questChains).get(),
        builder: (context, snap) {
          final quests = snap.data ?? [];
          if (quests.isEmpty) {
            return Center(child: Text('Ланцюжки квестів порожні\nВиконуй — відкривай наступний', textAlign: TextAlign.center, style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 14)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: quests.length,
            itemBuilder: (ctx, i) {
              final q = quests[i];
              final progress = q.targetValue > 0 ? (q.currentValue / q.targetValue).clamp(0.0, 1.0) : 0.0;
              final isCompleted = q.isCompleted;
              return Column(children: [
                if (i > 0 && quests[i - 1].chainOrder == q.chainOrder - 1)
                  Container(
                    width: 2, height: 24,
                    color: isCompleted ? Colors.orangeAccent : Colors.white24,
                  ),
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isCompleted ? const Color(0xFF1A2A1A) : const Color(0xFF1A1F2E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isCompleted ? Colors.greenAccent.withValues(alpha: 0.5) : Colors.orangeAccent.withValues(alpha: 0.4)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(children: [
                        Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted ? Colors.greenAccent : Colors.orangeAccent,
                          ),
                          child: Center(child: Text('', style: GoogleFonts.orbitron(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12))),
                        ),
                        const SizedBox(width: 12),
                        Text(q.questTitle, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      ]),
                      Row(children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text('+${q.xpReward} XP', style: GoogleFonts.shareTechMono(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                      ]),
                    ]),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white12,
                        color: isCompleted ? Colors.greenAccent : Colors.orangeAccent,
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(q.questType, style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                      Text('${(q.currentValue / 100).toStringAsFixed(0)} / ${(q.targetValue / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: isCompleted ? Colors.greenAccent : Colors.white, fontSize: 12)),
                    ]),
                  ]),
                ),
              ]);
            },
          );
        },
      ),
    );
  }

  void _startChain(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Новий ланцюжок', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Назва першого квесту', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
            onPressed: () async {
              for (int step = 0; step < 3; step++) {
                final names = ['Перший крок: 1,000 ₴', 'Зростання: 5,000 ₴', 'Фінал: 10,000 ₴'];
                final targets = [100000, 500000, 1000000];
                await db.into(db.questChains).insert(QuestChainsCompanion.insert(
                  userId: 1,
                  questType: 'savings',
                  questTitle: names[step],
                  targetValue: targets[step],
                  xpReward: (step + 1) * 100,
                  chainOrder: step + 1,
                  isCompleted: drift.Value(step == 0),
                  startedAt: DateTime.now(),
                ));
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Почати ланцюжок', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
