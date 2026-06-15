import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class TrophyGalleryScreen extends ConsumerWidget {
  const TrophyGalleryScreen({super.key});

  Color _tierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'mythic': return Colors.red;
      case 'legendary': return Colors.amber;
      case 'epic': return Colors.purpleAccent;
      case 'rare': return Colors.cyan;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('HOLO TROPHIES', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<TrophyEntry>>(
        future: db.select(db.trophyEntries).get(),
        builder: (context, snap) {
          final trophies = snap.data ?? [];
          final unlocked = trophies.where((t) => t.isUnlocked).length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _StatChip(label: 'ВСЬОГО', value: '${trophies.length}'),
                  _StatChip(label: 'ВІДКРИТО', value: '$unlocked'),
                  _StatChip(label: '% УСПІХУ', value: trophies.isNotEmpty ? '${(unlocked / trophies.length * 100).toInt()}%' : '0%'),
                ]),
              ),
              Expanded(
                child: trophies.isEmpty
                    ? Center(child: Text('Трофеї появляться після досягнень', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12),
                        itemCount: trophies.length,
                        itemBuilder: (ctx, i) {
                          final t = trophies[i];
                          final color = _tierColor(t.tier);
                          return Container(
                            decoration: BoxDecoration(
                              color: t.isUnlocked ? color.withValues(alpha: 0.15) : const Color(0xFF1A1F2E),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: t.isUnlocked ? color.withValues(alpha: 0.5) : Colors.white12),
                              boxShadow: t.isUnlocked ? [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 12)] : [],
                            ),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              ColorFiltered(
                                colorFilter: t.isUnlocked ? const ColorFilter.mode(Colors.transparent, BlendMode.color) : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                                child: Icon(Icons.emoji_events, color: color, size: 36),
                              ),
                              const SizedBox(height: 6),
                              Text(t.name, textAlign: TextAlign.center, style: GoogleFonts.orbitron(color: t.isUnlocked ? Colors.white : Colors.white24, fontSize: 9, fontWeight: FontWeight.bold)),
                              if (!t.isUnlocked)
                                const Icon(Icons.lock, color: Colors.white24, size: 14),
                            ]),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(label, style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
      const SizedBox(height: 4),
      Text(value, style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
    ]);
  }
}
