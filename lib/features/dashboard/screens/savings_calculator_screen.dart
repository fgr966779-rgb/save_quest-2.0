import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/widgets/surface_card.dart';

/// Savings Calculator — pure math, no Drift.
/// Given a target amount and a term (days/weeks/months),
/// computes how much to save per day, per week, and per month.
class SavingsCalculatorScreen extends ConsumerStatefulWidget {
  const SavingsCalculatorScreen({super.key});

  @override
  ConsumerState<SavingsCalculatorScreen> createState() =>
      _SavingsCalculatorScreenState();
}

class _SavingsCalculatorScreenState
    extends ConsumerState<SavingsCalculatorScreen> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocus = FocusNode();

  int _termValue = 12;
  _TermUnit _termUnit = _TermUnit.months;

  /// Whether the user has entered a valid amount.
  bool get _hasValidInput {
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    return amount != null && amount > 0 && _termValue > 0;
  }

  /// Parse amount from controller.
  double get _parsedAmount {
    return double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;
  }

  /// Calculate results based on current inputs.
  _CalcResult? get _result {
    if (!_hasValidInput) return null;
    final amount = _parsedAmount;
    final termDays = switch (_termUnit) {
      _TermUnit.days => _termValue.toDouble(),
      _TermUnit.weeks => _termValue * 7.0,
      _TermUnit.months => _termValue * 30.44, // average days per month
    };

    if (termDays <= 0) return null;

    final perDay = amount / termDays;
    final perWeek = perDay * 7;
    final perMonth = perDay * 30.44;

    return _CalcResult(
      perDay: perDay,
      perWeek: perWeek,
      perMonth: perMonth,
      totalDays: termDays.round(),
    );
  }

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    setState(() {}); // trigger recalculation
  }

  /// Increment / decrement the term value.
  void _changeTerm(int delta) {
    setState(() {
      _termValue = (_termValue + delta).clamp(1, 999);
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final locale = ref.read(localeProvider);
    String t(String key) => AppLocalizations.get(locale, key);
    final currency = ref.read(settingsServiceProvider).currency;
    final result = _result;

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          t('calc_title'),
          style: AppTypography.h2(context),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24.0),

            // ── Target Amount Input ──
            Text(
              t('calc_target_amount'),
              style: AppTypography.h3(context),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _amountController,
              focusNode: _amountFocus,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
              ],
              style: AppTypography.display(context),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: t('calc_target_hint'),
                hintStyle: AppTypography.display(
                  context,
                  color: AppColors.textDisabled(brightness),
                ),
                suffixText: currency,
                suffixStyle: AppTypography.h2(context),
                filled: true,
                fillColor: AppColors.surface(brightness),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  borderSide: BorderSide(color: AppColors.border(brightness)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  borderSide: BorderSide(color: AppColors.border(brightness)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  borderSide: const BorderSide(color: AppColors.accent, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
              ),
            ),
            const SizedBox(height: 32.0),

            // ── Term Selector ──
            Text(
              t('calc_term'),
              style: AppTypography.h3(context),
            ),
            const SizedBox(height: 12.0),

            // Term value stepper
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TermStepperButton(
                  icon: Icons.remove,
                  onTap: () => _changeTerm(-1),
                ),
                Container(
                  width: 100,
                  alignment: Alignment.center,
                  child: Text(
                    '$_termValue',
                    style: AppTypography.display(context),
                  ),
                ),
                _TermStepperButton(
                  icon: Icons.add,
                  onTap: () => _changeTerm(1),
                ),
              ],
            ),
            const SizedBox(height: 12.0),

            // Term unit chips
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _TermUnit.values.map((unit) {
                final isSelected = _termUnit == unit;
                final label = switch (unit) {
                  _TermUnit.days => t('calc_days'),
                  _TermUnit.weeks => t('calc_weeks'),
                  _TermUnit.months => t('calc_months'),
                };
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () => setState(() => _termUnit = unit),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.accent.withValues(alpha: 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.border(brightness),
                        ),
                      ),
                      child: Text(
                        label,
                        style: AppTypography.bodySmall(
                          context,
                          color: isSelected ? AppColors.accent : null,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40.0),

            // ── Results ──
            if (result != null) ...[
              Text(
                t('calc_result'),
                style: AppTypography.bodySmall(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),

              // Daily amount
              _ResultCard(
                icon: Icons.today_rounded,
                label: t('calc_per_day'),
                value: _formatMoney(result.perDay, currency),
                accentColor: AppColors.chartBlue,
                brightness: brightness,
              ),
              const SizedBox(height: 12.0),

              // Weekly amount
              _ResultCard(
                icon: Icons.date_range_rounded,
                label: t('calc_per_week'),
                value: _formatMoney(result.perWeek, currency),
                accentColor: AppColors.chartOrange,
                brightness: brightness,
              ),
              const SizedBox(height: 12.0),

              // Monthly amount
              _ResultCard(
                icon: Icons.calendar_month_rounded,
                label: t('calc_per_month'),
                value: _formatMoney(result.perMonth, currency),
                accentColor: AppColors.accent,
                brightness: brightness,
              ),
              const SizedBox(height: 24.0),

              // Summary
              SurfaceCard(
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 20,
                      color: AppColors.textSecondary(brightness),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${t('calc_title')}: $_termValue ${switch (_termUnit) {
                          _TermUnit.days => t('calc_days'),
                          _TermUnit.weeks => t('calc_weeks'),
                          _TermUnit.months => t('calc_months'),
                        }} = \$1 ${t('calc_days')}',
                        style: AppTypography.bodySmall(context),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Empty state
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48.0),
                child: Text(
                  t('calc_empty'),
                  style: AppTypography.body(
                    context,
                    color: AppColors.textTertiary(brightness),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  /// Format money value with 2 decimal places.
  String _formatMoney(double value, String currency) {
    if (value == value.roundToDouble()) {
      return '${value.round()} $currency';
    }
    return '${value.toStringAsFixed(2)} $currency';
  }
}

/// Stepper button for adjusting term value.
class _TermStepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TermStepperButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Material(
      color: AppColors.surface(brightness),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 24,
            color: AppColors.accent,
          ),
        ),
      ),
    );
  }
}

/// Result card showing a single savings breakdown.
class _ResultCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;
  final Brightness brightness;

  const _ResultCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodySmall(context),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.metric(context, color: accentColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Term unit enum.
enum _TermUnit { days, weeks, months }

/// Computed calculation result.
class _CalcResult {
  final double perDay;
  final double perWeek;
  final double perMonth;
  final int totalDays;

  const _CalcResult({
    required this.perDay,
    required this.perWeek,
    required this.perMonth,
    required this.totalDays,
  });
}
