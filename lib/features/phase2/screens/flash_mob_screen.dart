import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class FlashMobScreen extends ConsumerWidget {
  const FlashMobScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('SWARMDROP', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<FlashMobEvent>>(
        future: db.select(db.flashMobEvents).get(),
        builder: (context, snap) {
          final events = snap.data ?? [];
          if (events.isEmpty) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.bolt, size: 64, color: Colors.cyan.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                Text('Немає активних Flash Mob подій', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)),
                const SizedBox(height: 8),
                Text('Нові події з\'являються щодня', style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 13)),
              ]),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: events.length,
            itemBuilder: (ctx, i) {
              final ev = events[i];
              final color = ev.multiplier >= 3.0 ? Colors.amber : ev.multiplier >= 2.0 ? Colors.purple : Colors.cyan;
              final timeLeft = ev.endAt.difference(DateTime.now());
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withValues(alpha: 0.5)),
                  boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 12)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(child: Text(ev.title, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                      child: Text('$1x XP', style: GoogleFonts.orbitron(color: color, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Text(ev.description, style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 13, height: 1.4)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Icon(Icons.people, color: Colors.white38, size: 16),
                    const SizedBox(width: 4),
                    Text('$1 учасників', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 12)),
                    const Spacer(),
                    Icon(Icons.timer, color: color, size: 14),
                    const SizedBox(width: 4),
                    Text('$1г ${timeLeft.inMinutes % 60}хв', style: GoogleFonts.orbitron(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14)),
                      onPressed: ev.isJoined ? null : () {},
                      child: Text(ev.isJoined ? 'ПРИЄДНАНО' : 'ПРИЄДНАТИСЬ', style: GoogleFonts.orbitron(fontWeight: FontWeight.bold)),
                    ),
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
