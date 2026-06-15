import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class ReputationForgeScreen extends ConsumerWidget {
  const ReputationForgeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('REPFORGE', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<ReputationProfile>>(
        future: db.select(db.reputationProfiles).get(),
        builder: (context, snapshot) {
          final profiles = snapshot.data ?? [];
          final int score = profiles.isNotEmpty ? profiles.first.score : 0;
          final String tier = profiles.isNotEmpty ? profiles.first.tier : 'Novice';

          return FutureBuilder<List<PublicCommitment>>(
            future: db.select(db.publicCommitments).get(),
            builder: (context, cSnap) {
              final commitments = cSnap.data ?? [];
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Reputation Score
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1F2E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
                      ),
                      child: Column(
                        children: [
                          Text('РЕПУТАЦІЯ', style: GoogleFonts.orbitron(color: Colors.amber, fontSize: 14, letterSpacing: 2)),
                          const SizedBox(height: 8),
                          Text('$score', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                            child: Text(tier, style: GoogleFonts.orbitron(color: Colors.amber, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('ЗОБОВ\'ЯЗАННЯ', style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 14, letterSpacing: 2)),
                    const SizedBox(height: 12),
                    if (commitments.isEmpty)
                      Center(child: Text('Немає активних зобов\'язань', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 16))),
                    ...commitments.map((c) => _CommitmentCard(commitment: c)),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16)),
                      onPressed: () => _showAddCommitmentDialog(context, db),
                      child: Text('НОВЕ ЗОБОВ\'ЯЗАННЯ', style: GoogleFonts.orbitron(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddCommitmentDialog(BuildContext context, AppDatabase db) {
    final titleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Нове зобов\'язання', style: GoogleFonts.orbitron(color: Colors.white)),
        content: TextField(
          controller: titleCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'Назва зобов\'язання', hintStyle: TextStyle(color: Colors.white38)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () async {
              if (titleCtrl.text.isNotEmpty) {
                await db.into(db.publicCommitments).insert(PublicCommitmentsCompanion.insert(
                  userId: 1,
                  title: titleCtrl.text,
                  deadline: DateTime.now().add(const Duration(days: 7)),
                  xpStake: 100,
                  karmaStake: 10,
                  createdAt: DateTime.now(),
                ));
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Створити', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

class _CommitmentCard extends StatelessWidget {
  final PublicCommitment commitment;
  const _CommitmentCard({required this.commitment});

  @override
  Widget build(BuildContext context) {
    final daysLeft = commitment.deadline.difference(DateTime.now()).inDays;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(commitment.title, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('XP: \$1  |  Карма: \$1', style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: (daysLeft < 2 ? Colors.red : Colors.amber).withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
            child: Text('$daysLeft д', style: GoogleFonts.orbitron(color: daysLeft < 2 ? Colors.red : Colors.amber, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
