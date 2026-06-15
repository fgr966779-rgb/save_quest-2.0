import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class ChoiceParadoxScreen extends ConsumerWidget {
  const ChoiceParadoxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('PARADOX CTRL', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6B00FF),
        onPressed: () => _showCreateDialog(context, db),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('КОНТРАКТ', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
      body: FutureBuilder<List<SavingsContract>>(
        future: db.select(db.savingsContracts).get(),
        builder: (context, snap) {
          final contracts = snap.data ?? [];
          if (contracts.isEmpty) {
            return Center(child: Text('Немає активних контрактів', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: contracts.length,
            itemBuilder: (ctx, i) {
              final c = contracts[i];
              final progress = c.targetAmount > 0 ? (c.currentProgress / c.targetAmount).clamp(0.0, 1.0) : 0.0;
              final statusColor = c.isBroken ? Colors.red : c.isFulfilled ? Colors.green : Colors.cyan;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(c.contractType.toUpperCase(), style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold))),
                    Text(c.isBroken ? 'ПОРУШЕНО' : c.isFulfilled ? 'ВИКОНАНО' : 'АКТИВНИЙ', style: GoogleFonts.orbitron(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: progress.toDouble(), backgroundColor: Colors.white12, valueColor: AlwaysStoppedAnimation<Color>(statusColor), minHeight: 6, borderRadius: BorderRadius.circular(3)),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('${(c.currentProgress / 100).toStringAsFixed(0)} / ${(c.targetAmount / 100).toStringAsFixed(0)} грн', style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 12)),
                    Text('XP ризик: \$1', style: GoogleFonts.shareTechMono(color: Colors.red.withValues(alpha: 0.8), fontSize: 12)),
                  ]),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Новий контракт', style: GoogleFonts.orbitron(color: Colors.white)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final type in ['weekly_deposit_target', 'no_spend_challenge', 'minimum_daily'])
            ListTile(
              title: Text(type, style: GoogleFonts.shareTechMono(color: Colors.white)),
              onTap: () async {
                await db.into(db.savingsContracts).insert(SavingsContractsCompanion.insert(
                  userId: 1,
                  contractType: type,
                  targetAmount: 50000,
                  xpStake: 200,
                  karmaStake: 20,
                  currentProgress: 0,
                  endDate: DateTime.now().add(const Duration(days: 7)),
                  createdAt: DateTime.now(),
                ));
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
        ]),
      ),
    );
  }
}
