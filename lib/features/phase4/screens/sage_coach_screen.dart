import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class SageCoachScreen extends ConsumerWidget {
  const SageCoachScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('SAGE AI', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF7C4DFF),
        onPressed: () => _predict(context, db),
        icon: const Icon(Icons.psychology, color: Colors.white),
        label: Text('НОВИЙ ПРОГНОЗ', style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<CoachPrediction>>(
        future: db.select(db.coachPredictions).get(),
        builder: (context, snap) {
          final preds = snap.data ?? [];
          if (preds.isEmpty) {
            return Center(child: Text('SAGE аналізує ваші патерни\nта прогнозує фінансову поведінку', textAlign: TextAlign.center, style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 14)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: preds.length,
            itemBuilder: (ctx, i) {
              final p = preds[i];
              final confColor = p.confidence >= 0.7 ? Colors.greenAccent : (p.confidence >= 0.4 ? Colors.orangeAccent : Colors.redAccent);
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF7C4DFF).withValues(alpha: 0.5)),
                  boxShadow: [BoxShadow(color: const Color(0xFF7C4DFF).withValues(alpha: 0.1), blurRadius: 20)],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(p.predictionType.toUpperCase(), style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 11)),
                    Row(children: [
                      Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: confColor),
                      ),
                      const SizedBox(width: 6),
                      Text('${(p.confidence * 100).toStringAsFixed(0)}% впевненість', style: GoogleFonts.shareTechMono(color: confColor, fontSize: 12)),
                    ]),
                  ]),
                  const SizedBox(height: 12),
                  Text(p.predictionText, style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 14, height: 1.5)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFF7C4DFF).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF7C4DFF).withValues(alpha: 0.3))),
                    child: Row(children: [
                      const Icon(Icons.lightbulb_outline, color: Color(0xFF7C4DFF), size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(p.actionSuggestion, style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic))),
                    ]),
                  ),
                  if (p.wasCorrect != null) ...[
                    const SizedBox(height: 12),
                    Row(children: [
                      Icon(p.wasCorrect! ? Icons.check_circle : Icons.cancel, color: p.wasCorrect! ? Colors.greenAccent : Colors.redAccent, size: 16),
                      const SizedBox(width: 8),
                      Text(p.wasCorrect! ? 'Прогноз підтвердився' : 'Прогноз не спрацював', style: GoogleFonts.shareTechMono(color: p.wasCorrect! ? Colors.greenAccent : Colors.redAccent, fontSize: 12)),
                    ]),
                  ],
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _predict(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('AI Прогноз', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const Text('SAGE AI аналізує ваші дані та генерує прогноз...', style: TextStyle(color: Colors.white54)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C4DFF)),
            onPressed: () async {
              await db.into(db.coachPredictions).insert(CoachPredictionsCompanion.insert(
                userId: 1,
                predictionType: 'spending_risk',
                confidence: 0.82,
                predictionText: 'Схоже, що наступних 2 тижні ви маєте схильність до імпульсних покупок. Протягом останніх 3 місяців 68% великих витрат відбувались у цей же період.',
                actionSuggestion: 'Поставте тимчасовий ліміт витрат на 2 тижні та автоматично відкладайте +500 ₴ до мети',
                predictedFor: DateTime.now().add(const Duration(days: 14)),
                generatedAt: DateTime.now(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Запустити SAGE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
