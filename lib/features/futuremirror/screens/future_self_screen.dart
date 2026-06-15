import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/futuremirror_provider.dart';

class FutureSelfScreen extends ConsumerWidget {
  const FutureSelfScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(futureMirrorProvider);
    final notifier = ref.read(futureMirrorProvider.notifier);

    // Provide a cool glow effect based on months forward
    final double glowIntensity = state.monthsForward / 24.0;
    final glowColor = const Color(0xFF00FFFF).withValues(alpha: glowIntensity.clamp(0.1, 1.0));

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'FUTURE MIRROR',
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00FFFF)))
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Split Screen visualization
                  Expanded(
                    child: Row(
                      children: [
                        // Current State (Left)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1F2E),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.person_outline,
                                  color: Colors.white54,
                                  size: 64,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'ПОТОЧНИЙ СТАН',
                                  style: GoogleFonts.orbitron(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Future State (Right)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1F2E),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: glowColor, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: glowColor.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: glowColor.withValues(alpha: 1.0),
                                  size: 64,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '+${state.monthsForward} МІСЯЦІВ',
                                  style: GoogleFonts.orbitron(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: glowColor.withValues(alpha: 1.0),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${(state.projectedAmount / 100).toStringAsFixed(0)} ₴',
                                  style: GoogleFonts.shareTechMono(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Slider section
                  Text(
                    'FAST-FORWARD',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.orbitron(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: const Color(0xFF00FFFF),
                      inactiveTrackColor: Colors.white24,
                      thumbColor: Colors.white,
                      overlayColor: const Color(0xFF00FFFF).withValues(alpha: 0.2),
                      valueIndicatorColor: const Color(0xFF00FFFF),
                      valueIndicatorTextStyle: GoogleFonts.orbitron(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Slider(
                      value: state.monthsForward.toDouble(),
                      min: 3,
                      max: 24,
                      divisions: 7, // 3, 6, 9, 12, 15, 18, 21, 24
                      label: '${state.monthsForward} міс',
                      onChanged: (val) {
                        notifier.setMonthsForward(val.toInt());
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('3 міс', style: GoogleFonts.shareTechMono(color: Colors.white54)),
                      Text('24 міс', style: GoogleFonts.shareTechMono(color: Colors.white54)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // AI Motivation Message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00FFFF).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF00FFFF).withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome, color: Color(0xFF00FFFF), size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'ORACLE PREDICTION',
                              style: GoogleFonts.orbitron(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF00FFFF),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state.aiMessage,
                          style: GoogleFonts.shareTechMono(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
