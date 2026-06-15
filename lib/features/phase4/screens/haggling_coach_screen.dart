import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class HagglingCoachScreen extends ConsumerWidget {
  const HagglingCoachScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('HAGGLE AI', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purpleAccent,
        onPressed: () => _startSession(context, db),
        icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
        label: Text('ПОЧАТИ ТОРГ', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<HagglingSession>>(
        future: db.select(db.hagglingSessions).get(),
        builder: (context, snap) {
          final sessions = snap.data ?? [];
          if (sessions.isEmpty) {
            return Center(child: Text('AI допоможе вам торгуватись', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: sessions.length,
            itemBuilder: (ctx, i) {
              final s = sessions[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.5)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(s.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(s.outcome?.toUpperCase() ?? 'PENDING', style: GoogleFonts.orbitron(color: s.outcome == 'won' ? Colors.green : Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Просять: ${(s.listedPrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white54)),
                    Text('Ціль: ${(s.targetPrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white)),
                  ]),
                  const SizedBox(height: 16),
                  if (s.script != null) ...[
                    Text('Скрипт від AI:', style: GoogleFonts.orbitron(color: Colors.purpleAccent, fontSize: 10)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
                      child: Text(s.script!, style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic)),
                    ),
                  ],
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _startSession(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Новий торг', style: GoogleFonts.orbitron(color: Colors.white)),
        content: Column(mainAxisSize: MainAxisSize.min, children: const [
          TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Товар (напр. iPhone 13)', hintStyle: TextStyle(color: Colors.white38))),
          SizedBox(height: 12),
          TextField(style: TextStyle(color: Colors.white), keyboardType: TextInputType.number, decoration: InputDecoration(hintText: 'Просять (грн)', hintStyle: TextStyle(color: Colors.white38))),
          SizedBox(height: 12),
          TextField(style: TextStyle(color: Colors.white), keyboardType: TextInputType.number, decoration: InputDecoration(hintText: 'Хочу за (грн)', hintStyle: TextStyle(color: Colors.white38))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
            onPressed: () async {
              await db.into(db.hagglingSessions).insert(HagglingSessionsCompanion.insert(
                productName: 'iPhone 13 128GB б/у',
                listedPrice: 2000000,
                targetPrice: 1800000,
                platform: 'OLX',
                script: drift.Value('Привіт! Бачу телефон давно висить. Заберу сьогодні за 18,000 грн готівкою, якщо екран в ідеалі. Що скажете?'),
                outcome: const drift.Value('pending'),
                sessionAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Згенерувати скрипт', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
