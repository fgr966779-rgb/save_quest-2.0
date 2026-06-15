import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class SeasonalCalendarScreen extends ConsumerWidget {
  const SeasonalCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('SEASON PULSE', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () => _addEvent(context, db),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<List<PriceEvent>>(
        future: db.select(db.priceEvents).get(),
        builder: (context, snap) {
          final events = snap.data ?? [];
          if (events.isEmpty) {
            return Center(child: Text('Календар розпродажів порожній', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: events.length,
            itemBuilder: (ctx, i) {
              final e = events[i];
              final daysLeft = e.eventDate.difference(DateTime.now()).inDays;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.deepOrangeAccent.withValues(alpha: 0.5)),
                  boxShadow: daysLeft <= 7 && daysLeft >= 0 ? [BoxShadow(color: Colors.deepOrangeAccent.withValues(alpha: 0.2), blurRadius: 12)] : [],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(e.eventName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.deepOrangeAccent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                      child: Text('-\$1% ОЧІКУЄТЬСЯ', style: GoogleFonts.orbitron(color: Colors.deepOrangeAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    const Icon(Icons.calendar_today, color: Colors.white38, size: 16),
                    const SizedBox(width: 8),
                    Text('\$1.\$1.\$1', style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 14)),
                  ]),
                  const SizedBox(height: 8),
                  Text('Категорія: \$1', style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 12),
                  if (daysLeft >= 0)
                    Text('До розпродажу: $daysLeft днів', style: GoogleFonts.shareTechMono(color: daysLeft <= 7 ? Colors.deepOrangeAccent : Colors.cyan, fontSize: 14, fontWeight: FontWeight.bold))
                  else
                    Text('Розпродаж минув', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 14)),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _addEvent(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Нова подія', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Назва події', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent),
            onPressed: () async {
              await db.into(db.priceEvents).insert(PriceEventsCompanion.insert(
                eventName: 'Чорна П\'ятниця',
                productCategory: 'Electronics',
                expectedDropPercent: 30,
                eventDate: DateTime(DateTime.now().year, 11, 24),
                isRecurring: const drift.Value(true),
                recurrencePattern: drift.Value('yearly'),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Додати', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
