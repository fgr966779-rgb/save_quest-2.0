import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/necrospend_provider.dart';

class SavingsGraveyardScreen extends ConsumerWidget {
  const SavingsGraveyardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graveyardState = ref.watch(graveyardProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'NECROSPEND',
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            color: const Color(0xFFFFFFFF),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: graveyardState.when(
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Text(
                'Ваш цвинтар порожній.\nВсі цілі живі.',
                textAlign: TextAlign.center,
                style: GoogleFonts.shareTechMono(
                  color: const Color(0xB3FFFFFF),
                  fontSize: 18,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xB3FFFFFF).withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.goalName,
                      style: GoogleFonts.orbitron(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ціль: ${(entry.targetAmount / 100).toStringAsFixed(0)} грн',
                      style: GoogleFonts.shareTechMono(
                        color: const Color(0xB3FFFFFF),
                      ),
                    ),
                    Text(
                      'Зібрано: ${(entry.savedAmount / 100).toStringAsFixed(0)} грн',
                      style: GoogleFonts.shareTechMono(
                        color: const Color(0xB3FFFFFF),
                      ),
                    ),
                    if (entry.epitaph != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '"${entry.epitaph!}"',
                          style: GoogleFonts.shareTechMono(
                            color: const Color(0xFF00F0FF),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B00FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: entry.isResurrected ? null : () {
                          // Воскресити
                          ref.read(graveyardProvider.notifier).resurrectGoal(entry);
                        },
                        child: Text(
                          entry.isResurrected ? 'ВОСКРЕШЕНО' : 'ВОСКРЕСИТИ',
                          style: GoogleFonts.orbitron(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00F0FF))),
        error: (err, stack) => Center(
          child: Text(
            'Помилка: $err',
            style: GoogleFonts.shareTechMono(color: const Color(0xFFFF3366)),
          ),
        ),
      ),
    );
  }
}
