import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class LendingTrackerScreen extends ConsumerWidget {
  const LendingTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('LOAN TRACKER', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreenAccent,
        onPressed: () => _addRecord(context, db),
        child: const Icon(Icons.handshake, color: Colors.black),
      ),
      body: FutureBuilder<List<LendingRecord>>(
        future: db.select(db.lendingRecords).get(),
        builder: (context, snap) {
          final records = snap.data ?? [];
          if (records.isEmpty) {
            return Center(child: Text('Боргова книга порожня', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: records.length,
            itemBuilder: (ctx, i) {
              final r = records[i];
              final isLent = r.direction == 'lent'; // Ми позичили комусь (вони нам винні)
              final color = isLent ? Colors.lightGreenAccent : Colors.pinkAccent;
              final directionText = isLent ? 'ПОЗИЧИВ' : 'ПОЗИЧИВ У';
              
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: r.isSettled ? Colors.white24 : color.withValues(alpha: 0.5)),
                  boxShadow: r.isSettled ? [] : [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 12)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(directionText, style: GoogleFonts.orbitron(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                    if (r.isSettled)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)),
                        child: Text('ЗАКРИТО', style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                        child: Text('АКТИВНИЙ', style: GoogleFonts.orbitron(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                  ]),
                  const SizedBox(height: 8),
                  Text(r.counterpartyName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('${(r.amount / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: r.isSettled ? Colors.white54 : color, fontSize: 24, fontWeight: FontWeight.bold)),
                    if (r.dueDate != null)
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('ПОВЕРНЕННЯ ДО', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 8)),
                        Text('${r.dueDate!.day}.${r.dueDate!.month}.${r.dueDate!.year}', style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 12)),
                      ]),
                  ]),
                  if (r.reason != null && r.reason!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text('Призначення: \$1', style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 12)),
                  ],
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _addRecord(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Новий запис', style: GoogleFonts.orbitron(color: Colors.white)),
        content: Column(mainAxisSize: MainAxisSize.min, children: const [
          TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Ім\'я', hintStyle: TextStyle(color: Colors.white38))),
          SizedBox(height: 12),
          TextField(style: TextStyle(color: Colors.white), keyboardType: TextInputType.number, decoration: InputDecoration(hintText: 'Сума (грн)', hintStyle: TextStyle(color: Colors.white38))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreenAccent),
            onPressed: () async {
              await db.into(db.lendingRecords).insert(LendingRecordsCompanion.insert(
                userId: 1,
                counterpartyName: 'Макс',
                amount: 150000,
                direction: 'lent',
                reason: drift.Value('На каву та обід'),
                dueDate: drift.Value(DateTime.now().add(const Duration(days: 7))),
                createdAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Я позичив', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            onPressed: () async {
              await db.into(db.lendingRecords).insert(LendingRecordsCompanion.insert(
                userId: 1,
                counterpartyName: 'Анна',
                amount: 500000,
                direction: 'borrowed',
                reason: drift.Value('До зарплати'),
                createdAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Мені позичили', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
