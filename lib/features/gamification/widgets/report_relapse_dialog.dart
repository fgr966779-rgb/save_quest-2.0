import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/l10n.dart';
import '../providers/karma_provider.dart';

/// Bottom-sheet that lets the user self-report an impulse buy.
/// Calls [KarmaNotifier.reportImpulseSpend] and closes itself.
class ReportRelapseDialog extends ConsumerStatefulWidget {
  const ReportRelapseDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ReportRelapseDialog(),
    );
  }

  @override
  ConsumerState<ReportRelapseDialog> createState() =>
      _ReportRelapseDialogState();
}

class _ReportRelapseDialogState extends ConsumerState<ReportRelapseDialog>
    with SingleTickerProviderStateMixin {
  final _amountController = TextEditingController();
  bool _isLoading = false;

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnim;

  String t(String key) {
    final locale = ref.read(localeProvider);
    return AppLocalizations.get(locale, key);
  }

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    HapticFeedback.heavyImpact();
    setState(() => _isLoading = true);

    final rawText = _amountController.text.trim().replaceAll(',', '.');
    final amount = double.tryParse(rawText) ?? 0.0;

    await ref.read(karmaProvider.notifier).reportImpulseSpend(amount);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    const neonRed = Color(0xFFFF2A6D);
    const neonPink = Color(0xFFD100D1);

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (context, child) => Transform.translate(
        offset: Offset(_shakeAnim.value, 0),
        child: child,
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: 24 + bottomInset,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A0A12) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: neonRed.withValues(alpha: 0.45), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: neonRed.withValues(alpha: 0.18),
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Drag handle ──
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: neonRed.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ── Icon + Title ──
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: neonRed.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: neonRed.withValues(alpha: 0.4)),
                  ),
                  child: const Icon(
                    Icons.bug_report_rounded,
                    color: neonRed,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t('karma_report_dialog_title'),
                        style: TextStyle(
                          color: neonRed,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        t('karma_subtitle'),
                        style: TextStyle(
                          color: neonPink.withValues(alpha: 0.8),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Description ──
            Text(
              t('karma_report_dialog_desc'),
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontSize: 12.5,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // ── Amount Field ──
            Text(
              t('karma_report_amount_label'),
              style: TextStyle(
                color: isDark ? Colors.white60 : Colors.black54,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white30 : Colors.black26,
                ),
                prefixIcon: const Icon(
                  Icons.currency_exchange_rounded,
                  color: neonRed,
                  size: 18,
                ),
                filled: true,
                fillColor: neonRed.withValues(alpha: 0.06),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: neonRed.withValues(alpha: 0.3), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: neonRed.withValues(alpha: 0.7), width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),

            // ── Action Buttons ──
            Row(
              children: [
                // Cancel
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        _isLoading ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          isDark ? Colors.white60 : Colors.black54,
                      side: BorderSide(
                        color: isDark
                            ? Colors.white24
                            : Colors.black12,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      t('common_cancel'),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Confirm / Report
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _confirm,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.warning_amber_rounded, size: 18),
                    label: Text(
                      t('karma_report_confirm_btn'),
                      style: const TextStyle(
                          fontSize: 11.5, fontWeight: FontWeight.w800),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neonRed,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: neonRed.withValues(alpha: 0.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
