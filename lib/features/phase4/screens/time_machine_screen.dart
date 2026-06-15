import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class TimeMachineScreen extends ConsumerWidget {
  const TimeMachineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('CHRONO SAVER', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.cyanAccent,
        onPressed: () => _project(context, db),
        icon: const Icon(Icons.access_time, color: Colors.black),
        label: Text('РОЗРАХУВАТИ', style: GoogleFonts.orbitron(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<TimeMachineProjection>>(
        future: db.select(db.timeMachineProjections).get(),
        builder: (context, snap) {
          final projections = snap.data ?? [];
          if (projections.isEmpty) {
            return Center(child: Text('Машина часу: симуляція різних стратегій\nнакопичення', textAlign: TextAlign.center, style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 14)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: projections.length,
            itemBuilder: (ctx, i) {
              final p = projections[i];
              final d = p.projectedCompletionDate;
              final daysLeft = d.difference(DateTime.now()).inDays;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.4)),
                  boxShadow: [BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.08), blurRadius: 20)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(p.scenarioName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('${p.depositFrequency.toUpperCase()}', style: GoogleFonts.orbitron(color: Colors.cyanAccent, fontSize: 11)),
                  ]),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    _C('КІНЦЕВА СУМА', p.projectedFinalAmount, Colors.cyanAccent),
                    _C('ДАТА ДОСЯГНЕННЯ', null, Colors.white, '$1.$1.$1'),
                  ]),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.3,
                      backgroundColor: Colors.white12,
                      color: Colors.cyanAccent,
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('+$1% до внесків', style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 12)),
                    Text('$daysLeft днів', style: GoogleFonts.shareTechMono(color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                  ]),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _project(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Нова симуляція', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Назва сценарію', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
            onPressed: () async {
              await db.into(db.timeMachineProjections).insert(TimeMachineProjectionsCompanion.insert(
                goalId: 1,
                scenarioName: 'Базова стратегія',
                depositIncreasePercent: 15.0,
                lumpSumAmount: 500000,
                depositFrequency: 'monthly',
                projectedCompletionDate: DateTime.now().add(const Duration(days: 365)),
                projectedFinalAmount: 12000000,
                calculatedAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Симулювати', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

class _C extends StatelessWidget {
  final String label;
  final int? value;
  final Color color;
  final String? customText;
  const _C(this.label, this.value, this.color, [this.customText]);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 9)),
      const SizedBox(height: 4),
      Text(
        customText ?? '${(value! / 100).toStringAsFixed(0)} ₴',
        style: GoogleFonts.shareTechMono(color: color, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ]);
  }
}
