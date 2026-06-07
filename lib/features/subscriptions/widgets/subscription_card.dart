// FILE: lib/features/subscriptions/widgets/subscription_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../data/database.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback? onKill;
  final VoidCallback? onPaid;
  final VoidCallback? onConfirmActive; // for "Possibly Inactive" prompt

  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.onKill,
    required this.onPaid,
    this.onConfirmActive,
  });

  @override
  Widget build(BuildContext context) {
    final s = subscription;
    final isActive = s.isActive;
    final daysLeft =
        s.nextBillingDate.difference(DateTime.now()).inDays;
    final isDueSoon = isActive && daysLeft <= 3;
    final isPossiblyInactive = isActive &&
        s.lastCheckedAt.isBefore(
            DateTime.now().subtract(const Duration(days: 30)));

    // Color coding
    final Color borderColor = !isActive
        ? Colors.white12
        : isDueSoon
            ? const Color(0xFFFF3B30)
            : const Color(0xFF00FF9D).withValues(alpha: 0.3);

    final Color amountColor = !isActive
        ? Colors.white38
        : isDueSoon
            ? const Color(0xFFFF3B30)
            : const Color(0xFF00FF9D);

    final amountStr =
        '${(s.amountKopecks / 100).toStringAsFixed(0)} ${s.currency}';
    final cycleLabel = s.billingCycle == 'yearly' ? '/рік' : '/міс';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF12122A),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: isDueSoon && isActive
            ? [
                BoxShadow(
                  color: const Color(0xFFFF3B30).withValues(alpha: 0.2),
                  blurRadius: 12,
                  spreadRadius: 0,
                )
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row 1: Name + Amount ───────────────────────────────────
            Row(
              children: [
                // Parasite icon
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: borderColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: 0.8),
                  ),
                  child: Center(
                    child: Text(
                      isActive ? '🩸' : '💀',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.name,
                        style: GoogleFonts.orbitron(
                          color: isActive ? Colors.white : Colors.white38,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        s.billingCycle == 'yearly' ? 'Річна підписка' : 'Щомісячна підписка',
                        style: GoogleFonts.spaceMono(
                            color: Colors.white38, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      amountStr,
                      style: GoogleFonts.orbitron(
                        color: amountColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      cycleLabel,
                      style: GoogleFonts.spaceMono(
                          color: Colors.white38, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),

            if (isActive) ...[
              const SizedBox(height: 12),

              // ── Days progress bar ────────────────────────────────────
              _BillingCountdown(
                  daysLeft: daysLeft, isDueSoon: isDueSoon),

              // ── Possibly Inactive Warning ────────────────────────────
              if (isPossiblyInactive) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.4)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.warning_amber,
                        color: Colors.orange, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text('Можливо неактивна',
                          style: GoogleFonts.spaceMono(
                              color: Colors.orange, fontSize: 10)),
                    ),
                    if (onConfirmActive != null)
                      GestureDetector(
                        onTap: onConfirmActive,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00FF9D).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: const Color(0xFF00FF9D), width: 0.7),
                          ),
                          child: Text('✓ Активна',
                              style: GoogleFonts.spaceMono(
                                  color: const Color(0xFF00FF9D),
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ]),
                ),
              ],

              // ── Action buttons ───────────────────────────────────────
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: const Color(0xFF00FF9D).withValues(alpha: 0.6)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: onPaid,
                      icon: const Icon(Icons.check_circle_outline,
                          color: Color(0xFF00FF9D), size: 16),
                      label: Text('Оплачено',
                          style: GoogleFonts.spaceMono(
                              color: const Color(0xFF00FF9D), fontSize: 11)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: const Color(0xFFFF3B30).withValues(alpha: 0.6)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: onKill,
                      icon: const Icon(Icons.delete_outline,
                          color: Color(0xFFFF3B30), size: 16),
                      label: Text('Знищити',
                          style: GoogleFonts.spaceMono(
                              color: const Color(0xFFFF3B30), fontSize: 11)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.05, end: 0);
  }
}

// ── Billing countdown bar ────────────────────────────────────────────────────

class _BillingCountdown extends StatelessWidget {
  final int daysLeft;
  final bool isDueSoon;
  const _BillingCountdown({required this.daysLeft, required this.isDueSoon});

  @override
  Widget build(BuildContext context) {
    final label = daysLeft <= 0
        ? '⚠️ Сьогодні списання!'
        : daysLeft == 1
            ? '⚠️ Списання завтра'
            : '📅 Списання через $daysLeft дн.';

    final barValue = (daysLeft / 30).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: GoogleFonts.spaceMono(
                    color: isDueSoon
                        ? const Color(0xFFFF3B30)
                        : Colors.white54,
                    fontSize: 11,
                    fontWeight: isDueSoon ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: 1.0 - barValue,
          backgroundColor: Colors.white12,
          valueColor: AlwaysStoppedAnimation(
              isDueSoon ? const Color(0xFFFF3B30) : const Color(0xFF00FF9D)),
        ),
      ],
    );
  }
}
