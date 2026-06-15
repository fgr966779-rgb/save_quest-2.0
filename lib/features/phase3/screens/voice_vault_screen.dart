import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import 'package:drift/drift.dart' as drift;

class VoiceVaultScreen extends ConsumerStatefulWidget {
  const VoiceVaultScreen({super.key});

  @override
  ConsumerState<VoiceVaultScreen> createState() => _VoiceVaultScreenState();
}

class _VoiceVaultScreenState extends ConsumerState<VoiceVaultScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('VOICE CRYPT', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<VoiceCommand>>(
        future: db.select(db.voiceCommands).get(),
        builder: (context, snap) {
          final commands = snap.data ?? [];
          return Column(
            children: [
              const SizedBox(height: 60),
              GestureDetector(
                onTapDown: (_) => setState(() => _isRecording = true),
                onTapUp: (_) => _stopRecording(db),
                onTapCancel: () => setState(() => _isRecording = false),
                child: AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (context, child) {
                    return Container(
                      width: 150, height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1A1F2E),
                        border: Border.all(color: Colors.cyan.withValues(alpha: 0.5), width: 2),
                        boxShadow: _isRecording ? [
                          BoxShadow(color: Colors.cyan.withValues(alpha: 0.2 + (_pulseCtrl.value * 0.4)), blurRadius: 40 + (_pulseCtrl.value * 30), spreadRadius: 10),
                        ] : [],
                      ),
                      child: Icon(Icons.mic, size: 64, color: _isRecording ? Colors.cyan : Colors.white38),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(_isRecording ? 'СЛУХАЮ...' : 'НАТИСНІТЬ ТА ГОВОРІТЬ', style: GoogleFonts.orbitron(color: _isRecording ? Colors.cyan : Colors.white54, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 8),
              Text('Приклад: "Відкласти 500 гривень на PS5"', style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 12)),
              const SizedBox(height: 40),
              Expanded(
                child: commands.isEmpty ? Center(child: Text('Немає голосових логів', style: GoogleFonts.shareTechMono(color: Colors.white38))) : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: commands.length,
                  itemBuilder: (ctx, i) {
                    final c = commands[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFF1A1F2E), borderRadius: BorderRadius.circular(12), border: Border.all(color: c.wasExecuted ? Colors.green.withValues(alpha: 0.3) : Colors.white12)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('"$1"', style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 8),
                        Row(children: [
                          Icon(c.wasExecuted ? Icons.check_circle : Icons.pending, color: c.wasExecuted ? Colors.green : Colors.amber, size: 14),
                          const SizedBox(width: 8),
                          Text(c.parsedAction.toUpperCase(), style: GoogleFonts.orbitron(color: Colors.white54, fontSize: 10)),
                          if (c.parsedAmount != null) ...[
                            const Spacer(),
                            Text('${(c.parsedAmount! / 100).toStringAsFixed(0)} ₴', style: GoogleFonts.shareTechMono(color: Colors.cyan, fontWeight: FontWeight.bold)),
                          ]
                        ]),
                      ]),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _stopRecording(AppDatabase db) async {
    setState(() => _isRecording = false);
    // Mock processing
    await Future.delayed(const Duration(milliseconds: 500));
    await db.into(db.voiceCommands).insert(VoiceCommandsCompanion.insert(
      transcription: 'Відкласти 500 гривень',
      parsedAction: 'deposit',
      parsedAmount: const drift.Value(50000),
      wasExecuted: const drift.Value(true),
      recordedAt: DateTime.now(),
    ));
    setState(() {});
  }
}
