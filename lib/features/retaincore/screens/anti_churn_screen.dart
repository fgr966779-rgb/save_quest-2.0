import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/retaincore_provider.dart';

class AntiChurnScreen extends ConsumerStatefulWidget {
  const AntiChurnScreen({super.key});

  @override
  ConsumerState<AntiChurnScreen> createState() => _AntiChurnScreenState();
}

class _AntiChurnScreenState extends ConsumerState<AntiChurnScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _getRiskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.critical:
        return Colors.red;
      case RiskLevel.high:
        return Colors.redAccent;
      case RiskLevel.medium:
        return Colors.orange;
      case RiskLevel.low:
        return Colors.green;
    }
  }

  String _getRiskTitle(RiskLevel level) {
    switch (level) {
      case RiskLevel.critical:
        return 'CRITICAL RISK';
      case RiskLevel.high:
        return 'HIGH RISK';
      case RiskLevel.medium:
        return 'MEDIUM RISK';
      case RiskLevel.low:
        return 'LOW RISK';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(retainCoreProvider);

    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0E17),
        body: Center(child: CircularProgressIndicator(color: Colors.cyan)),
      );
    }

    final riskColor = _getRiskColor(state.riskLevel);
    final isCritical = state.riskLevel == RiskLevel.critical;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'RETAINCORE',
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Indicator
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F2E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: riskColor.withValues(alpha: isCritical ? _pulseController.value * 0.8 + 0.2 : 0.5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: riskColor.withValues(alpha: isCritical ? _pulseController.value * 0.4 : 0.1),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        isCritical ? Icons.warning_amber_rounded : Icons.radar,
                        color: riskColor,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _getRiskTitle(state.riskLevel),
                        style: GoogleFonts.orbitron(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: riskColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Днів без депозиту: ${state.daysSinceDeposit}',
                        style: GoogleFonts.shareTechMono(
                          fontSize: 16,
                          color: const Color(0xB3FFFFFF),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // AI Mission / Message
            Text(
              'RESCUE MISSION',
              style: GoogleFonts.orbitron(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: riskColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: riskColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                state.aiMessage,
                style: GoogleFonts.shareTechMono(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
            const Spacer(),

            // Emergency Deposit Action
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: riskColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Here we would trigger an emergency deposit of 50 UAH
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Екстрений депозит 50 грн ініційовано!')),
                );
              },
              child: Text(
                'ЕКСТРЕНИЙ ДЕПОЗИТ (50 ГРН)',
                style: GoogleFonts.orbitron(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
