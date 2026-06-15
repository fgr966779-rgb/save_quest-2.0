import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class BudgetDNAScreen extends ConsumerWidget {
  const BudgetDNAScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('BUDGET HELIX', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () => _addCategory(context, db),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: FutureBuilder<List<BudgetReport>>(
        future: db.select(db.budgetReports).get(),
        builder: (context, rSnap) {
          final reports = rSnap.data ?? [];
          final report = reports.isNotEmpty ? reports.first : null;

          return FutureBuilder<List<BudgetEntry>>(
            future: db.select(db.budgetEntries).get(),
            builder: (context, eSnap) {
              final entries = eSnap.data ?? [];
              
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Overview DNA
                    if (report != null)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1F2E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.5)),
                          boxShadow: [BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.1), blurRadius: 16)],
                        ),
                        child: Column(children: [
                          Text('МІСЯЧНИЙ ЗВІТ', style: GoogleFonts.orbitron(color: Colors.white54, fontSize: 12, letterSpacing: 2)),
                          const SizedBox(height: 16),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                            _ScoreColumn(label: 'ВИТРАЧЕНО', value: '${(report.totalSpent / 100).toStringAsFixed(0)} ₴', color: Colors.white),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.greenAccent.withValues(alpha: 0.2), border: Border.all(color: Colors.greenAccent)),
                              child: Text('A', style: GoogleFonts.orbitron(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                            ),
                            _ScoreColumn(label: 'СЕЙВ РЕЙТ', value: '${report.savingsRate.toStringAsFixed(1)}%', color: Colors.cyan),
                          ]),
                          if (report.aiAnalysis != null) ...[
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
                              child: Text(report.aiAnalysis!, style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 13, height: 1.4)),
                            ),
                          ],
                        ]),
                      ),
                    
                    const SizedBox(height: 32),
                    Text('ВИТРАТИ ПО КАТЕГОРІЯХ', style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 14, letterSpacing: 2)),
                    const SizedBox(height: 16),
                    
                    if (entries.isEmpty)
                      Center(child: Text('Немає категорій', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16))),
                    
                    ...entries.map((e) {
                      final p = e.monthlyLimit > 0 ? (e.spentAmount / e.monthlyLimit).clamp(0.0, 1.0) : 0.0;
                      final color = e.isBreach ? Colors.red : (p > 0.8 ? Colors.orange : Colors.greenAccent);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1F2E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: color.withValues(alpha: 0.3)),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(e.category.toUpperCase(), style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text('${(e.spentAmount / 100).toStringAsFixed(0)} / ${(e.monthlyLimit / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: color, fontWeight: FontWeight.bold)),
                          ]),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(value: p.toDouble(), backgroundColor: Colors.white12, valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 6, borderRadius: BorderRadius.circular(3)),
                        ]),
                      );
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _addCategory(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Нова категорія', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Назва категорії', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
            onPressed: () async {
              await db.into(db.budgetEntries).insert(BudgetEntriesCompanion.insert(
                userId: 1,
                category: 'Продукти',
                monthlyLimit: 1000000,
                spentAmount: 0,
                month: '2026-06',
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Додати', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

class _ScoreColumn extends StatelessWidget {
  final String label, value;
  final Color color;
  const _ScoreColumn({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(label, style: GoogleFonts.orbitron(color: Colors.white54, fontSize: 10)),
      const SizedBox(height: 8),
      Text(value, style: GoogleFonts.shareTechMono(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
    ]);
  }
}
