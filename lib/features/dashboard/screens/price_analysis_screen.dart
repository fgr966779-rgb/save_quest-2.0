import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/services/price_analysis_service.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';

class PriceAnalysisScreen extends ConsumerStatefulWidget {
  final String? initialQuery;
  final int? targetAmountKopecks;
  final String? currency;

  const PriceAnalysisScreen({
    super.key,
    this.initialQuery,
    this.targetAmountKopecks,
    this.currency,
  });

  @override
  ConsumerState<PriceAnalysisScreen> createState() =>
      _PriceAnalysisScreenState();
}

class _PriceAnalysisScreenState extends ConsumerState<PriceAnalysisScreen> {
  late final TextEditingController _controller;
  bool _isLoading = false;
  PriceAnalysis? _analysis;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    final locale = ref.read(localeProvider);
    final query = _controller.text.trim();
    if (query.isEmpty) {
      setState(() {
        _error = AppLocalizations.get(locale, 'price_enter_product');
        _analysis = null;
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final service = ref.read(priceAnalysisServiceProvider);
      final result = await service.analyze(query);
      if (!mounted) return;
      setState(() {
        _analysis = result;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '${AppLocalizations.get(locale, 'price_fetch_error')}$e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final currency = widget.currency ?? '₴';
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context, locale),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSearchCard(context, locale),
                    const SizedBox(height: 20.0),
                    if (_error != null) _buildErrorCard(context, _error!),
                    if (_analysis != null) ...[
                      _buildSummaryCard(context, locale, _analysis!, currency),
                      const SizedBox(height: 16.0),
                      if (widget.targetAmountKopecks != null)
                        _buildGoalImpactCard(
                          context,
                          locale,
                          _analysis!,
                          widget.targetAmountKopecks!,
                          currency,
                        ),
                      if (widget.targetAmountKopecks != null)
                        const SizedBox(height: 16.0),
                      _buildQuotesCard(context, locale, _analysis!, currency),
                      const SizedBox(height: 16.0),
                      _buildRecommendationCard(context, locale, _analysis!),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String locale) {
    final brightness = Theme.of(context).brightness;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary(brightness)),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.get(locale, 'price_scanner_header'),
                  style: AppTypography.overline(
                    context,
                    color: AppColors.accent,
                  ),
                ),
                Text(
                  AppLocalizations.get(locale, 'price_analysis_title'),
                  style: AppTypography.h2(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context, String locale) {
    final brightness = Theme.of(context).brightness;

    return SurfaceCard(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.get(locale, 'price_target_product'),
            style: AppTypography.overline(context, color: AppColors.accent),
          ),
          const SizedBox(height: 12.0),
          TextField(
            controller: _controller,
            style: TextStyle(color: AppColors.textPrimary(brightness), fontSize: 15.0),
            decoration: InputDecoration(
              hintText: AppLocalizations.get(locale, 'price_hint'),
              hintStyle: TextStyle(color: AppColors.textTertiary(brightness)),
              filled: true,
              fillColor: AppColors.surfaceMuted(brightness),
              prefixIcon: Icon(Icons.search_rounded,
                  color: AppColors.accent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: AppColors.border(brightness),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: AppColors.border(brightness),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: AppColors.accent),
              ),
            ),
            onSubmitted: (_) => _run(),
          ),
          const SizedBox(height: 16.0),
          AppButton(
            label: AppLocalizations.get(locale, 'price_scan_btn'),
            variant: ButtonVariant.primary,
            onPressed: _isLoading ? null : _run,
            isLoading: _isLoading,
            icon: const Icon(Icons.radar_rounded, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String message) {
    return SurfaceCard(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.error, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String locale, PriceAnalysis a, String currency) {
    final brightness = Theme.of(context).brightness;

    return SurfaceCard(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.get(locale, 'price_range_header'),
                style: AppTypography.overline(context, color: AppColors.accent),
              ),
              if (a.isEstimate)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    AppLocalizations.get(locale, 'price_estimate'),
                    style: AppTypography.overline(
                      context,
                      color: AppColors.warning,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metric(context, AppLocalizations.get(locale, 'price_min'), a.minPriceKopecks, currency,
                  AppColors.success),
              _metric(context, AppLocalizations.get(locale, 'price_avg'), a.avgPriceKopecks, currency,
                  AppColors.accent),
              _metric(context, AppLocalizations.get(locale, 'price_max'), a.maxPriceKopecks, currency,
                  AppColors.error),
            ],
          ),
          const SizedBox(height: 14.0),
          Text(
            '${AppLocalizations.get(locale, 'price_spread')}${formatAmount(a.spreadKopecks)} $currency '
            '(${(a.spreadRatio * 100).toStringAsFixed(1)}%)',
            style: AppTypography.bodySmall(
              context,
              color: AppColors.textSecondary(brightness),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(BuildContext context, String label, int kopecks, String currency, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption(
            context,
            color: AppColors.textSecondary(Theme.of(context).brightness),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${formatAmount(kopecks)} $currency',
          style: AppTypography.amount(context, color: color),
        ),
      ],
    );
  }

  Widget _buildGoalImpactCard(
      BuildContext context, String locale, PriceAnalysis a, int targetKopecks, String currency) {
    final brightness = Theme.of(context).brightness;
    final diff = targetKopecks - a.minPriceKopecks;
    final overBudget = diff < 0;
    final color = overBudget ? AppColors.error : AppColors.success;
    final label = overBudget
        ? AppLocalizations.get(locale, 'price_below_market')
        : AppLocalizations.get(locale, 'price_above_market');

    return SurfaceCard(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(
            overBudget ? Icons.warning_amber_rounded : Icons.check_circle_outline,
            color: color,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.get(locale, 'price_comparison'),
                  style: AppTypography.overline(context, color: color),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: AppTypography.bodySmall(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotesCard(BuildContext context, String locale, PriceAnalysis a, String currency) {
    final brightness = Theme.of(context).brightness;

    return SurfaceCard(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.get(locale, 'price_by_store'),
            style: AppTypography.h3(context),
          ),
          const SizedBox(height: 10),
          ...a.quotes.asMap().entries.map((entry) {
            final i = entry.key;
            final q = entry.value;
            final isCheapest = i == 0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isCheapest
                          ? AppColors.success
                          : AppColors.borderStrong(brightness),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      q.store,
                      style: AppTypography.bodySmall(context),
                    ),
                  ),
                  Text(
                    '${formatAmount(q.priceKopecks)} $currency',
                    style: AppTypography.amount(
                      context,
                      color: isCheapest
                          ? AppColors.success
                          : AppColors.textPrimary(brightness),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, String locale, PriceAnalysis a) {
    return SurfaceCard(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: [
          const Icon(Icons.psychology_alt_rounded,
              color: AppColors.accent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.get(locale, 'price_conclusion'),
                  style: AppTypography.overline(context, color: AppColors.accent),
                ),
                const SizedBox(height: 4),
                Text(
                  a.recommendation,
                  style: AppTypography.bodySmall(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
