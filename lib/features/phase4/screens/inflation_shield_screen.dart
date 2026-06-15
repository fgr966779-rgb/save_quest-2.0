import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class InflationShieldScreen extends ConsumerWidget {
  const InflationShieldScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('INFLA SHIELD', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () => _calculate(context, db),
        icon: const Icon(Icons.shield, color: Colors.white),
        label: Text('РОЗРАХУВАТИ ЗАХИСТ', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<InflationShield>>(
        future: db.select(db.inflationShields).get(),
        builder: (context, snap) {
          final shields = snap.data ?? [];
          if (shields.isEmpty) {
            return Center(child: Text('Захист від інфляції', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: shields.length,
            itemBuilder: (ctx, i) {
              final s = shields[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.deepPurpleAccent.withValues(alpha: 0.5)),
                  boxShadow: [BoxShadow(color: Colors.deepPurpleAccent.withValues(alpha: 0.1), blurRadius: 16)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Мета #\$1', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                      child: Text('ІНФЛЯЦІЯ: \$1%', style: GoogleFonts.orbitron(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    _Val('ПОЧАТКОВА ЦІЛЬ', s.originalTargetAmount, Colors.white54),
                    _Val('НОВА ЦІЛЬ', s.adjustedTargetAmount, Colors.deepPurpleAccent),
                  ]),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.deepPurpleAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text('Щоб покрити інфляцію, потрібно ще:\n${(s.additionalNeeded / 100).toStringAsFixed(0)} ₴', textAlign: TextAlign.center, style: GoogleFonts.shareTechMono(color: Colors.deepPurpleAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _calculate(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Щит від інфляції', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Відсоток інфляції (%)', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
            onPressed: () async {
              await db.into(db.inflationShields).insert(InflationShieldsCompanion.insert(
                userId: 1,
                goalId: 1,
                inflationRate: 15.5,
                originalTargetAmount: 10000000, // 100,000 грн
                adjustedTargetAmount: 11550000,
                additionalNeeded: 1550000,
                calculatedAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Розрахувати', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _Val extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _Val(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
      const SizedBox(height: 4),
      Text('${(value / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
    ]);
  }
}
