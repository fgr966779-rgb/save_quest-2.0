import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/karma_provider.dart';
import '../../../core/providers/l10n.dart';

class KarmaDebtWidget extends ConsumerWidget {
  final bool isZenMode;
  const KarmaDebtWidget({super.key, this.isZenMode = false});

  String t(WidgetRef ref, String key) {
    final locale = ref.watch(localeProvider);
    return AppLocalizations.get(locale, key);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final karmaAsync = ref.watch(karmaProvider);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final neonRed = const Color(0xFFFF2A6D);
    final neonPink = const Color(0xFFD100D1);
    
    final zenColor = isDark ? Colors.blueGrey[700]! : Colors.blueGrey[200]!;

    return karmaAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (state) {
        if (state.karmaDebt <= 0) return const SizedBox.shrink();

        final now = DateTime.now();
        int hoursRemaining = 0;
        if (state.debuffActiveUntil != null && state.debuffActiveUntil!.isAfter(now)) {
          hoursRemaining = state.debuffActiveUntil!.difference(now).inHours;
          if (hoursRemaining == 0 && state.debuffActiveUntil!.difference(now).inMinutes > 0) {
            hoursRemaining = 1;
          }
        }

        final ratio = (state.karmaDebt / 150.0).clamp(0.0, 1.0);
        
        final borderColor = isZenMode ? zenColor : neonRed.withValues(alpha: 0.5);
        final textColor = isZenMode ? (isDark ? Colors.blueGrey[300]! : Colors.blueGrey[700]!) : neonRed;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isZenMode ? (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F9FA)) : (isDark ? const Color(0xFF240A15) : const Color(0xFFFFF0F5)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
            boxShadow: isZenMode ? null : [
              BoxShadow(
                color: neonRed.withValues(alpha: 0.15),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bug_report_rounded, color: textColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isZenMode ? 'Карма-борг' : t(ref, 'karma_title'),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    if (!isZenMode) Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: neonRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: neonRed.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        '-${state.karmaDebt} XP',
                        style: TextStyle(
                          color: neonRed,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                if (!isZenMode) Text(
                  t(ref, 'karma_debuff_desc'),
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 12),
                if (!isZenMode && hoursRemaining > 0) ...[
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, color: neonPink, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        AppLocalizations.get(ref.watch(localeProvider), 'karma_debuff_hours')
                            .replaceAll('{hours}', hoursRemaining.toString()),
                        style: TextStyle(
                          color: neonPink,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
                // Progress indicator for current karma debt
                if (!isZenMode) ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 6,
                    backgroundColor: neonRed.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(neonRed),
                  ),
                ),
                if (!isZenMode) const SizedBox(height: 12),
                if (!isZenMode) SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(karmaProvider.notifier).cleanseKarma();
                    },
                    icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                    label: Text(t(ref, 'karma_cleanse_btn')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neonRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
