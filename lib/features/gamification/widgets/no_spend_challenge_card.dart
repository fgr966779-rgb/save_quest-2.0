import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/no_spend_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/l10n.dart';

/// Dashboard card for the "No-Spend Streak" challenge.
/// Shows the streak count, 7-day chest progress bar, claim button,
/// and triggers a success dialog on claim.
class NoSpendChallengeCard extends ConsumerStatefulWidget {
  final bool isZenMode;
  const NoSpendChallengeCard({super.key, this.isZenMode = false});

  @override
  ConsumerState<NoSpendChallengeCard> createState() =>
      _NoSpendChallengeCardState();
}

class _NoSpendChallengeCardState extends ConsumerState<NoSpendChallengeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String t(String key) {
    final locale = ref.watch(localeProvider);
    return AppLocalizations.get(locale, key);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final noSpendAsync = ref.watch(noSpendProvider);

    // Listen for successful claim to show dialog
    ref.listen<AsyncValue<NoSpendState>>(noSpendProvider, (prev, next) {
      if (next is AsyncData<NoSpendState> && next.value.justClaimed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          _showSuccessDialog(context, next.value);
          ref.read(noSpendProvider.notifier).clearJustClaimed();
        });
      }
    });

    return noSpendAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (state) => _buildCard(context, brightness, state),
    );
  }

  Widget _buildCard(
      BuildContext context, Brightness brightness, NoSpendState state) {
    final isDark = brightness == Brightness.dark;
    final neonGreen = const Color(0xFF39FF14);
    final neonCyan = AppColors.accent;
    
    // Zen Mode colors
    final zenColor = isDark ? Colors.blueGrey[400]! : Colors.blueGrey[600]!;
    final zenBg = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F9FA);

    final cardBg = widget.isZenMode ? zenBg : (isDark ? const Color(0xFF0D1F17) : const Color(0xFFEEFFF5));
    final borderColor = widget.isZenMode ? zenColor : neonGreen.withValues(alpha: 0.45);
    final mainColor = widget.isZenMode ? zenColor : neonGreen;

    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
        boxShadow: widget.isZenMode ? null : [
          BoxShadow(
            color: neonGreen.withValues(alpha: 0.12),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title row ─────────────────────────────────────────────────
            Row(
              children: [
                Icon(Icons.shield_rounded,
                    color: mainColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t('no_spend_title'),
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                // Streak badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: mainColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: mainColor.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    '${state.streakCount}${t('no_spend_days')}',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            Text(
              t('no_spend_subtitle'),
              style: TextStyle(
                color: isDark
                    ? Colors.white60
                    : Colors.black54,
                fontSize: 11.5,
              ),
            ),
            const SizedBox(height: 14),

            // ── 7-Day Chest Progress Bar ───────────────────────────────────
            Row(
              children: [
                Text(
                  '${t('no_spend_chest_progress')} ${state.boxProgress}/7',
                  style: TextStyle(
                    color: widget.isZenMode ? zenColor : neonCyan,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (!widget.isZenMode) Text(
                  '🎁',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: state.boxProgress / 7.0,
                minHeight: 8,
                backgroundColor: mainColor.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(mainColor),
              ),
            ),
            const SizedBox(height: 4),

            // Pip indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final filled = i < state.boxProgress;
                return Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled
                        ? mainColor
                        : mainColor.withValues(alpha: 0.18),
                    border: Border.all(
                      color: mainColor.withValues(alpha: filled ? 0.8 : 0.3),
                    ),
                    boxShadow: filled && !widget.isZenMode
                        ? [
                            BoxShadow(
                              color: neonGreen.withValues(alpha: 0.6),
                              blurRadius: 6,
                            )
                          ]
                        : null,
                  ),
                );
              }),
            ),
            
            if (!widget.isZenMode) ...[
                const SizedBox(height: 14),

                // ── Claim Button ───────────────────────────────────────────────
                state.canClaimToday
                    ? ScaleTransition(
                        scale: _pulseAnim,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon:
                                const Icon(Icons.check_circle_outline, size: 18),
                            label: Text(t('no_spend_claim_btn')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: neonGreen,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ),
                            onPressed: () {
                              ref.read(noSpendProvider.notifier).claimNoSpend();
                            },
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: neonGreen.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: neonGreen.withValues(alpha: 0.25)),
                        ),
                        child: Text(
                          t('no_spend_claimed'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: neonGreen.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),

                // ── Debug cheat hook ───────────────────────────────────────────
                const SizedBox(height: 6),
                TextButton(
                  onPressed: () {
                    ref.read(noSpendProvider.notifier).debugIncrementDays();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: neonCyan.withValues(alpha: 0.55),
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 28),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    t('no_spend_debug_btn'),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // SUCCESS DIALOG
  // ──────────────────────────────────────────────────────────────────────────
  void _showSuccessDialog(BuildContext context, NoSpendState state) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _NoSpendSuccessDialog(state: state),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUCCESS DIALOG WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class _NoSpendSuccessDialog extends ConsumerStatefulWidget {
  final NoSpendState state;
  const _NoSpendSuccessDialog({required this.state});

  @override
  ConsumerState<_NoSpendSuccessDialog> createState() =>
      _NoSpendSuccessDialogState();
}

class _NoSpendSuccessDialogState
    extends ConsumerState<_NoSpendSuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  String t(String key) {
    final locale = ref.watch(localeProvider);
    return AppLocalizations.get(locale, key);
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnim =
        CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fadeAnim =
        CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final neonGreen = const Color(0xFF39FF14);
    final isLootbox = widget.state.justEarnedLootbox;
    final newProgress = widget.state.boxProgress;

    return FadeTransition(
      opacity: _fadeAnim,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 340),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1F17),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: neonGreen.withValues(alpha: 0.6),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: neonGreen.withValues(alpha: 0.25),
                  blurRadius: 32,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: neonGreen.withValues(alpha: 0.15),
                    border: Border.all(
                        color: neonGreen.withValues(alpha: 0.5), width: 2),
                    boxShadow: [
                      BoxShadow(
                          color: neonGreen.withValues(alpha: 0.4),
                          blurRadius: 20),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      isLootbox ? '🎁' : '🛡️',
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  isLootbox
                      ? t('no_spend_lootbox_title')
                      : t('no_spend_success_title'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: neonGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),

                // Desc / lootbox sub
                if (isLootbox)
                  Text(
                    t('no_spend_lootbox_desc'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13),
                  ),
                const SizedBox(height: 16),

                // Reward chip
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: neonGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: neonGreen.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    t('no_spend_success_reward'),
                    style: TextStyle(
                      color: neonGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Streak & progress row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _infoChip(
                      label:
                          '${t('no_spend_success_streak')} ${widget.state.streakCount}',
                      color: neonGreen,
                    ),
                    const SizedBox(width: 8),
                    _infoChip(
                      label:
                          '${t('no_spend_success_progress')} $newProgress/7',
                      color: AppColors.accent,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neonGreen,
                      foregroundColor: Colors.black,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    child: Text(AppLocalizations.get(ref.read(localeProvider), 'common_ok')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoChip({required String label, required Color color}) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
