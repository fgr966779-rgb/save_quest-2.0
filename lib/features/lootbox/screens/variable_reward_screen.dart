import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/lootbox_provider.dart';

class VariableRewardScreen extends ConsumerStatefulWidget {
  const VariableRewardScreen({super.key});

  @override
  ConsumerState<VariableRewardScreen> createState() => _VariableRewardScreenState();
}

class _VariableRewardScreenState extends ConsumerState<VariableRewardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  Color _getTierColor(String tier) {
    switch (tier) {
      case 'mythic': return Colors.red;
      case 'legendary': return Colors.amber;
      case 'epic': return Colors.purpleAccent;
      case 'rare': return Colors.cyan;
      case 'common': return Colors.grey;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(variableRewardProvider);
    final notifier = ref.read(variableRewardProvider.notifier);

    if (state.isOpening && !_spinController.isAnimating) {
      _spinController.repeat();
    } else if (!state.isOpening && _spinController.isAnimating) {
      _spinController.stop();
      _spinController.reset();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'LOOTBOX VAULT',
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('ВІДКРИТО', '${state.totalOpened}'),
                    _buildStatCard('НАЙКРАЩИЙ', state.bestLoot),
                  ],
                ),
                const Spacer(),

                // Lootbox Display
                GestureDetector(
                  onTap: () {
                    notifier.openLootBox();
                  },
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _spinController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _spinController.value * 2 * 3.14159,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF1A1F2E),
                              boxShadow: [
                                BoxShadow(
                                  color: state.isOpening
                                      ? Colors.purpleAccent.withValues(alpha: 0.5)
                                      : Colors.cyan.withValues(alpha: 0.2),
                                  blurRadius: state.isOpening ? 40 : 20,
                                  spreadRadius: state.isOpening ? 10 : 2,
                                ),
                              ],
                              border: Border.all(
                                color: state.isOpening ? Colors.purpleAccent : Colors.cyan,
                                width: 4,
                              ),
                            ),
                            child: Icon(
                              Icons.all_inclusive,
                              size: 80,
                              color: state.isOpening ? Colors.purpleAccent : Colors.cyan,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'НАТИСНІТЬ ЩОБ ВІДКРИТИ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.orbitron(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                    letterSpacing: 2,
                  ),
                ),
                const Spacer(),

                // Odds Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'ВІРОГІДНОСТІ',
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildOddRow('Mythic', '0.1%', Colors.red),
                          _buildOddRow('Legendary', '1%', Colors.amber),
                          _buildOddRow('Epic', '5%', Colors.purpleAccent),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildOddRow('Rare', '20%', Colors.cyan),
                          _buildOddRow('Common', '73.9%', Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Reward Overlay
          if (state.lastResult != null)
            Container(
              color: Colors.black.withValues(alpha: 0.8),
              child: Center(
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        margin: const EdgeInsets.all(32),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1F2E),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _getTierColor(state.lastResult!.tier),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _getTierColor(state.lastResult!.tier).withValues(alpha: 0.5),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.lastResult!.tier.toUpperCase(),
                              style: GoogleFonts.orbitron(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _getTierColor(state.lastResult!.tier),
                                letterSpacing: 4,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Icon(
                              Icons.star,
                              size: 64,
                              color: _getTierColor(state.lastResult!.tier),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              '+${state.lastResult!.xpReward} XP',
                              style: GoogleFonts.shareTechMono(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Тип: ${state.lastResult!.rewardType.toUpperCase()}',
                              style: GoogleFonts.shareTechMono(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _getTierColor(state.lastResult!.tier),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              ),
                              onPressed: () {
                                notifier.reset();
                              },
                              child: Text(
                                'ЗАБРАТИ НАГОРОДУ',
                                style: GoogleFonts.orbitron(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.orbitron(
            fontSize: 12,
            color: Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.shareTechMono(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOddRow(String name, String odd, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          '$name: $odd',
          style: GoogleFonts.shareTechMono(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
