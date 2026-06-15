import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class NudgeLabScreen extends ConsumerWidget {
  const NudgeLabScreen({super.key});

  static const _nudgeColors = {
    'loss_aversion': Colors.red,
    'social_proof': Colors.blue,
    'anchoring': Colors.amber,
    'scarcity': Colors.orange,
    'gamification': Colors.purple,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('NUDGE LAB', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<NudgeExperiment>>(
        future: db.select(db.nudgeExperiments).get(),
        builder: (context, snap) {
          final experiments = snap.data ?? [];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('A/B ЕКСПЕРИМЕНТИ', style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 14, letterSpacing: 2)),
                const SizedBox(height: 16),
                if (experiments.isEmpty)
                  Center(child: Text('Немає активних експериментів', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 15))),
                ...experiments.map((ex) {
                  final color = _nudgeColors[ex.nudgeType] ?? Colors.cyan;
                  final convRate = ex.impressions > 0 ? (ex.conversions / ex.impressions * 100).toStringAsFixed(1) : '0.0';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1F2E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: (color as Color).withValues(alpha: 0.4)),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text(ex.nudgeType.replaceAll('_', ' ').toUpperCase(), style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                          child: Text('Варіант ${ex.variant}', style: GoogleFonts.orbitron(color: color, fontSize: 11)),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                        _Stat(label: 'ПОКАЗИ', value: '${ex.impressions}'),
                        _Stat(label: 'КОНВЕРСІЇ', value: '${ex.conversions}'),
                        _Stat(label: 'CTR', value: '$convRate%', color: color),
                      ]),
                    ]),
                  );
                }),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B00FF), padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () => _showNewExperimentDialog(context, db),
                  child: Text('ЗАПУСТИТИ ЕКСПЕРИМЕНТ', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showNewExperimentDialog(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Новий експеримент', style: GoogleFonts.orbitron(color: Colors.white)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final type in _nudgeColors.keys)
            ListTile(
              title: Text(type.replaceAll('_', ' '), style: GoogleFonts.shareTechMono(color: Colors.white)),
              onTap: () async {
                await db.into(db.nudgeExperiments).insert(NudgeExperimentsCompanion.insert(
                  nudgeType: type,
                  variant: 'A',
                  startedAt: DateTime.now(),
                ));
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
        ]),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Stat({required this.label, required this.value, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(label, style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
      const SizedBox(height: 4),
      Text(value, style: GoogleFonts.shareTechMono(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
    ]);
  }
}
