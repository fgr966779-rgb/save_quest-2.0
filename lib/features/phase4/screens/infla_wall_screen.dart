import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class InflaWallScreen extends ConsumerStatefulWidget {
  const InflaWallScreen({super.key});

  @override
  ConsumerState<InflaWallScreen> createState() => _InflaWallScreenState();
}

class _InflaWallScreenState extends ConsumerState<InflaWallScreen> with SingleTickerProviderStateMixin {
  late AnimationController _waveCtrl;
  int _currentWave = 1;
  int _savingsBalance = 500000; // 5000 грн
  int _score = 0;
  final double _currentInflation = 18.5;

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    super.dispose();
  }

  void _defend(AppDatabase db) async {
    final attack = (_savingsBalance * _currentInflation / 100).round();
    final defended = (attack * 0.85).round();
    final lost = attack - defended;

    setState(() {
      _savingsBalance = (_savingsBalance - lost).clamp(0, 9999999);
      _score += defended ~/ 100;
    });

    await db.into(db.inflationWaves).insert(InflationWavesCompanion.insert(
      userId: 1,
      waveNumber: _currentWave,
      inflationRate: _currentInflation,
      savingsDefended: defended,
      savingsLost: lost,
      score: _score,
      isWaveWon: true,
      playedAt: DateTime.now(),
    ));

    setState(() => _currentWave++);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.greenAccent,
        content: Text('Вал відбито! Заощаджено ${(defended / 100).toStringAsFixed(0)} ₴. Втрати: ${(lost / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.black, fontWeight: FontWeight.bold)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('INFLA WALL', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(child: Text('РАХУНОК: $_score', style: GoogleFonts.orbitron(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 12))),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          // Header stats
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _Stat('ХВИЛЯ', '#$_currentWave', Colors.redAccent),
            _Stat('БАЛАНС', '${(_savingsBalance / 100).toStringAsFixed(0)} ₴', Colors.white),
            _Stat('ІНФЛЯЦІЯ', '$_currentInflation%', Colors.orangeAccent),
          ]),
          const SizedBox(height: 40),

          // Wave animation
          AnimatedBuilder(
            animation: _waveCtrl,
            builder: (ctx, _) {
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
                  boxShadow: [BoxShadow(color: Colors.redAccent.withValues(alpha: 0.1 + _waveCtrl.value * 0.15), blurRadius: 30, spreadRadius: 2)],
                ),
                child: Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('ХВИЛЯ ІНФЛЯЦІЇ', style: GoogleFonts.orbitron(color: Colors.redAccent, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 4)),
                    const SizedBox(height: 8),
                    Text('$1% атаки', style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 16)),
                    const SizedBox(height: 20),
                    Text('Можливі втрати: ${(_savingsBalance * _currentInflation / 100 / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                  ]),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Defend button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => _defend(db),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.shield, color: Colors.black, size: 24),
                const SizedBox(width: 12),
                Text('ВІДБИТИ ХВИЛЮ', style: GoogleFonts.orbitron(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 18)),
              ]),
            ),
          ),

          const SizedBox(height: 32),

          // History
          FutureBuilder<List<InflationWave>>(
            future: db.select(db.inflationWaves).get(),
            builder: (context, snap) {
              final waves = (snap.data ?? []).reversed.take(5).toList();
              if (waves.isEmpty) return const SizedBox.shrink();
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('ХРОНІКА БІТВ', style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 12, letterSpacing: 2)),
                const SizedBox(height: 12),
                ...waves.map((w) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F2E),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: (w.isWaveWon ? Colors.greenAccent : Colors.redAccent).withValues(alpha: 0.3)),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Хвиля #$1 ($1%)', style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 12)),
                    Text('${w.isWaveWon ? "+" : "-"}${(w.savingsDefended / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: w.isWaveWon ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                  ]),
                )),
              ]);
            },
          ),
        ]),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Stat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(label, style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10, letterSpacing: 2)),
      const SizedBox(height: 4),
      Text(value, style: GoogleFonts.shareTechMono(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
    ]);
  }
}
