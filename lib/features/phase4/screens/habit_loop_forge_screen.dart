import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class HabitLoopForgeScreen extends ConsumerWidget {
  const HabitLoopForgeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('HABIT FORGE', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.yellowAccent,
        onPressed: () => _addHabit(context, db),
        icon: const Icon(Icons.loop, color: Colors.black),
        label: Text('НОВА ЗВИЧКА', style: GoogleFonts.orbitron(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<HabitLoop>>(
        future: db.select(db.habitLoops).get(),
        builder: (context, snap) {
          final habits = snap.data ?? [];
          if (habits.isEmpty) {
            return Center(child: Text('Створіть цикл звички: Тригер -> Дія -> Нагорода', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 14)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: habits.length,
            itemBuilder: (ctx, i) {
              final h = habits[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.yellowAccent.withValues(alpha: 0.5)),
                  boxShadow: h.isActive ? [BoxShadow(color: Colors.yellowAccent.withValues(alpha: 0.1), blurRadius: 12)] : [],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Стрік: $1 🔥', style: GoogleFonts.orbitron(color: Colors.orangeAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                    Switch(
                      value: h.isActive,
                      onChanged: (v) {},
                      activeColor: Colors.yellowAccent,
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _Step('ТРИГЕР', h.triggerEvent, Icons.bolt, Colors.blueAccent),
                  _Step('ДІЯ', '$1 (${(h.routineAmount / 100).toStringAsFixed(0)} ₴)', Icons.play_arrow, Colors.greenAccent),
                  _Step('НАГОРОДА', '+$1 XP', Icons.star, Colors.yellowAccent),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  void _addHabit(BuildContext context, AppDatabase db) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Новий цикл', style: GoogleFonts.orbitron(color: Colors.white)),
        content: const TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Тригер (напр. Ранкова кава)', hintStyle: TextStyle(color: Colors.white38))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.yellowAccent),
            onPressed: () async {
              await db.into(db.habitLoops).insert(HabitLoopsCompanion.insert(
                userId: 1,
                triggerEvent: 'Ранкова кава',
                routine: 'Відкласти вартість кави',
                routineAmount: 5000,
                rewardXp: 25,
                isActive: const drift.Value(true),
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

class _Step extends StatelessWidget {
  final String label;
  final String text;
  final IconData icon;
  final Color color;
  const _Step(this.label, this.text, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        SizedBox(width: 60, child: Text(label, style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10))),
        Expanded(child: Text(text, style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 14))),
      ]),
    );
  }
}
