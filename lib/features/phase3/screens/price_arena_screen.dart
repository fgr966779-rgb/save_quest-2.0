import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class PriceArenaScreen extends ConsumerWidget {
  const PriceArenaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('COLOSSEUM', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        onPressed: () {},
        icon: const Icon(Icons.shield, color: Colors.white),
        label: Text('ДОЛУЧИТИСЬ', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<ArenaTournament>>(
        future: db.select(db.arenaTournaments).get(),
        builder: (context, snap) {
          final tournaments = snap.data ?? [];
          if (tournaments.isEmpty) {
            db.into(db.arenaTournaments).insert(ArenaTournamentsCompanion.insert(
              productName: 'iPhone 15 Pro Max',
              startAt: DateTime.now().subtract(const Duration(days: 1)),
              endAt: DateTime.now().add(const Duration(days: 2)),
              status: 'active',
              prizeXp: 1000,
            ));
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: tournaments.length,
            itemBuilder: (ctx, i) {
              final t = tournaments[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
                  boxShadow: [BoxShadow(color: Colors.redAccent.withValues(alpha: 0.1), blurRadius: 16)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('БИТВА ЗА ЦІНУ', style: GoogleFonts.orbitron(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                      child: Text('$1 XP', style: GoogleFonts.orbitron(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  Text(t.productName, style: GoogleFonts.orbitron(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(children: [
                    const Icon(Icons.timer, color: Colors.white38, size: 16),
                    const SizedBox(width: 8),
                    Text('Залишилось: ${t.endAt.difference(DateTime.now()).inDays} дн', style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 12)),
                  ]),
                  const SizedBox(height: 16),
                  FutureBuilder<List<ArenaSubmission>>(
                    future: (db.select(db.arenaSubmissions)..where((tbl) => tbl.tournamentId.equals(t.id))).get(),
                    builder: (ctx, subSnap) {
                      final subs = subSnap.data ?? [];
                      if (subs.isEmpty) return Text('Ще немає ставок. Будь першим!', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 12));
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: subs.map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(s.storeName, style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 12)),
                            Text('${(s.price / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                          ]),
                        )).toList(),
                      );
                    },
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
