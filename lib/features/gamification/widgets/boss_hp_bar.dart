import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// Helper to get a cool cyberpunk boss name based on the goal's name.
String getBossName(String goalName) {
  final name = goalName.trim().toLowerCase();
  
  // Specific override keywords for hand-crafted bosses
  if (name.contains('ps5') || name.contains('playstation') || name.contains('плейстейшн')) {
    return 'PS5 Cyber-Demon';
  } else if (name.contains('iphone') || name.contains('phone') || name.contains('телефон')) {
    return 'Neuro-Phone Overlord';
  } else if (name.contains('car') || name.contains('машин')) {
    return 'Mecha-Titan Engine';
  } else if (name.contains('vacation') || name.contains('trip') || name.contains('подорож') || name.contains('відпустк')) {
    return 'Neo-Spectre Wanderer';
  } else if (name.contains('mac') || name.contains('laptop') || name.contains('комп')) {
    return 'Mainframe Overlord';
  }

  // Deterministic generated names using prefixes and suffixes
  const prefixes = ['Mecha-', 'Neo-', 'Cyber-', 'Quantum-', 'Giga-', 'Synth-', 'Psycho-', 'Turbo-', 'Zero-', 'Apex-'];
  const suffixes = ['-Overlord', '-Glitch', '-Devourer', '-Demon', '-Spectre', '-Titan', '-Engine', '-Beast', '-Slayer', '-Matrix'];
  
  final hash = goalName.hashCode;
  final prefix = prefixes[hash.abs() % prefixes.length];
  final suffix = suffixes[(hash.abs() ~/ prefixes.length) % suffixes.length];
  
  return '$prefix$goalName$suffix';
}

class BossHpBar extends StatelessWidget {
  final String goalName;
  final double currentAmount;
  final double targetAmount;
  final String currency;
  final Color accentColor;
  final int? priceShieldHp;

  const BossHpBar({
    super.key,
    required this.goalName,
    required this.currentAmount,
    required this.targetAmount,
    required this.currency,
    required this.accentColor,
    this.priceShieldHp,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bossName = getBossName(goalName);

    // Boss Max HP is the target amount
    final maxHp = targetAmount > 0 ? targetAmount : 100.0;
    // Damage is the saved amount
    final damageDealt = currentAmount.clamp(0.0, maxHp);
    // Remaining HP is maxHP - damageDealt
    final remainingHp = (maxHp - damageDealt).clamp(0.0, maxHp);
    // Ratio of HP remaining
    final hpRatio = (remainingHp / maxHp).clamp(0.0, 1.0);
    final hpPercent = (hpRatio * 100).toInt();

    final isDefeated = hpRatio <= 0.0;
    final isLowHp = hpRatio > 0.0 && hpRatio <= 0.3;

    // Cyberpunk themed boss HP bar color scheme
    // HP bar starts green/blue and turns deep red or flashing orange/red, but let's make it neon red/purple for the boss
    final hpBarColor = isDefeated
        ? AppColors.textTertiary(brightness)
        : isLowHp
            ? AppColors.error // Flashing neon red
            : const Color(0xFFFF2A6D); // Synthwave neon red/pink

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Boss Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  isDefeated ? '☠️ ' : '👾 ',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  bossName.toUpperCase(),
                  style: AppTypography.caption(
                    context,
                    color: isDefeated
                        ? AppColors.textTertiary(brightness)
                        : isLowHp
                            ? AppColors.error
                            : Colors.white,
                  ).copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontFamily: 'Courier New', // Cyberpunk monospace feel
                  ),
                ),
              ],
            ),
            if (isDefeated)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.success, width: 1),
                ),
                child: Text(
                  'DEFEATED',
                  style: AppTypography.overline(
                    context,
                    color: AppColors.success,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
              )
            else
              Text(
                'HP: $hpPercent%',
                style: AppTypography.caption(
                  context,
                  color: hpBarColor,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
          ],
        ),
        const SizedBox(height: 6),

        // HP Progress Bar
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 1.0, end: hpRatio),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, animatedHp, child) {
            return Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F30), // Cyberpunk dark blue-grey track
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: hpBarColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: animatedHp,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            hpBarColor,
                            hpBarColor.withValues(alpha: 0.8),
                            hpBarColor.withValues(alpha: 0.5),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: hpBarColor.withValues(alpha: 0.6),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 4),

        // Boss HP numeric status & Damage indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'HP: ${remainingHp.toStringAsFixed(0)} / ${maxHp.toStringAsFixed(0)} $currency',
              style: AppTypography.overline(
                context,
                color: AppColors.textSecondary(brightness),
              ),
            ),
            Text(
              'DMG: -${damageDealt.toStringAsFixed(0)} HP',
              style: AppTypography.overline(
                context,
                color: isDefeated ? AppColors.success : AppColors.warning,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),

        // Price Shield HP
        if (priceShieldHp != null && priceShieldHp! < 100) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '⚡ БОС УРАЗЛИВИЙ! (Щит ${priceShieldHp!}%)',
                style: AppTypography.caption(
                  context,
                  color: Colors.cyanAccent,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
              if (priceShieldHp! <= 0)
                Text(
                  'ЩИТ ЗРУЙНОВАНО',
                  style: AppTypography.caption(
                    context,
                    color: Colors.cyanAccent,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: priceShieldHp! / 100.0,
              backgroundColor: Colors.cyanAccent.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
              minHeight: 6.0,
            ),
          ),
        ],
      ],
    );
  }
}
