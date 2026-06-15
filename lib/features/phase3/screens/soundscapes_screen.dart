import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class SoundscapesScreen extends ConsumerWidget {
  const SoundscapesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('SYNTH WAVE', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<SoundUnlock>>(
        future: db.select(db.soundUnlocks).get(),
        builder: (context, snap) {
          final sounds = snap.data ?? [];
          if (sounds.isEmpty) {
            // Mock data for display if empty
            db.into(db.soundUnlocks).insert(SoundUnlocksCompanion.insert(userId: 1, soundName: 'Cyberpunk Beat', soundFile: 'cyber.mp3', isUnlocked: const drift.Value(true), isActive: const drift.Value(true), unlockCost: 0));
            db.into(db.soundUnlocks).insert(SoundUnlocksCompanion.insert(userId: 1, soundName: 'Neon Rain', soundFile: 'rain.mp3', isUnlocked: const drift.Value(false), unlockCost: 500));
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: sounds.length,
            itemBuilder: (ctx, i) {
              final s = sounds[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: s.isActive ? Colors.purple.withValues(alpha: 0.2) : const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: s.isActive ? Colors.purple : (s.isUnlocked ? Colors.white24 : Colors.white12)),
                ),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: s.isUnlocked ? Colors.purple.withValues(alpha: 0.2) : Colors.white12, shape: BoxShape.circle),
                    child: Icon(s.isUnlocked ? Icons.music_note : Icons.lock, color: s.isUnlocked ? Colors.purpleAccent : Colors.white38),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s.soundName, style: GoogleFonts.orbitron(color: s.isUnlocked ? Colors.white : Colors.white54, fontWeight: FontWeight.bold, fontSize: 16)),
                      if (!s.isUnlocked)
                        Text('\$1 XP', style: GoogleFonts.shareTechMono(color: Colors.amber, fontSize: 12)),
                    ]),
                  ),
                  if (s.isUnlocked)
                    IconButton(
                      icon: Icon(s.isActive ? Icons.volume_up : Icons.play_arrow, color: s.isActive ? Colors.purpleAccent : Colors.white),
                      onPressed: () {},
                    ),
                  if (!s.isUnlocked)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 12)),
                      onPressed: () {},
                      child: Text('UNLOCK', style: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                ]),
              );
            },
          );
        },
      ),
    );
  }
}
