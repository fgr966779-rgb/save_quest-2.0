import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class SmartAlertsScreen extends ConsumerWidget {
  const SmartAlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('ALERT CORE', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () => _addAlert(context, db),
        child: const Icon(Icons.add_alert, color: Colors.black),
      ),
      body: FutureBuilder<List<SmartAlertEntry>>(
        future: db.select(db.smartAlertEntries).get(),
        builder: (context, snap) {
          final alerts = snap.data ?? [];
          if (alerts.isEmpty) {
            return Center(child: Text('Немає налаштованих сповіщень', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: alerts.length,
            itemBuilder: (ctx, i) {
              final a = alerts[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: a.isTriggered ? Colors.orangeAccent : Colors.white12),
                  boxShadow: a.isTriggered ? [BoxShadow(color: Colors.orangeAccent.withValues(alpha: 0.2), blurRadius: 12)] : [],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(child: Text(a.productName, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                    Icon(a.isTriggered ? Icons.notifications_active : Icons.notifications_paused, color: a.isTriggered ? Colors.orangeAccent : Colors.white24, size: 20),
                  ]),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('ТРИГЕР ЦІНА', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                      Text('${(a.triggerPrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 16)),
                    ]),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('ПОТОЧНА ЦІНА', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10)),
                      Text('${(a.currentPrice / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: a.isTriggered ? Colors.orangeAccent : Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                  ]),
                  if (a.isTriggered) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(color: Colors.orangeAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text('АЛЕРИ СПРАЦЮВАВ! КУПУЙТЕ ЗРАЗУ!', textAlign: TextAlign.center, style: GoogleFonts.shareTechMono(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold)),
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

  void _addAlert(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Нове сповіщення', style: GoogleFonts.orbitron(color: Colors.white)),
        content: Column(mainAxisSize: MainAxisSize.min, children: const [
          TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Товар', hintStyle: TextStyle(color: Colors.white38))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
            onPressed: () async {
              await db.into(db.smartAlertEntries).insert(SmartAlertEntriesCompanion.insert(
                productName: 'Nintendo Switch OLED',
                alertType: 'target_reached',
                triggerPrice: 1200000,
                currentPrice: 1150000,
                isTriggered: const drift.Value(true),
                triggeredAt: drift.Value(DateTime.now()),
                createdAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Створити', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
