import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

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
  bool _hasAutoRun = false;
  PriceAnalysis? _analysis;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
    if ((widget.initialQuery ?? '').trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _hasAutoRun) return;
        _hasAutoRun = true;
        _run();
      });
    }
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
    } on ArgumentError catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message.toString();
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

  Future<void> _runPreset(PriceTargetPreset preset) async {
    _controller.text = preset.query;
    await _run();
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSearchCard(context, locale),
                    const SizedBox(height: 20.0),
                    if (_isLoading) _buildSkeletonLoader(brightness),
                    if (!_isLoading && _error != null)
                      _buildErrorCard(context, _error!),
                    if (!_isLoading && _analysis != null) ...[
                      _buildSummaryCard(context, locale, _analysis!, currency),
                      const SizedBox(height: 16.0),
                      _buildPriceChart(context, locale, _analysis!, brightness),
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
                      _buildQuotesList(context, locale, _analysis!, currency),
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
          const SizedBox(height: 10.0),
          Text(
            AppLocalizations.get(locale, 'price_quick_picks'),
            style: AppTypography.caption(
              context,
              color: AppColors.textSecondary(brightness),
            ),
          ),
          const SizedBox(height: 8.0),
          _buildQuickTargets(),
          const SizedBox(height: 12.0),
          TextField(
            controller: _controller,
            style: TextStyle(
                color: AppColors.textPrimary(brightness), fontSize: 15.0),
            decoration: InputDecoration(
              hintText: AppLocalizations.get(locale, 'price_hint'),
              hintStyle: TextStyle(color: AppColors.textTertiary(brightness)),
              filled: true,
              fillColor: AppColors.surfaceMuted(brightness),
              prefixIcon: Icon(Icons.search_rounded, color: AppColors.accent),
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
            icon:
                const Icon(Icons.radar_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(height: 8.0),
          Text(
            AppLocalizations.get(locale, 'price_live_source'),
            textAlign: TextAlign.center,
            style: AppTypography.caption(context),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTargets() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final preset in supportedPriceTargets)
          ActionChip(
            avatar: const Icon(Icons.search_rounded, size: 16),
            label: Text(preset.label),
            onPressed: _isLoading ? null : () => _runPreset(preset),
          ),
      ],
    );
  }

  Widget _buildSkeletonLoader(Brightness brightness) {
    return Column(
      children: [
        SurfaceCard(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 100,
                  height: 16,
                  color: AppColors.surfaceMuted(brightness)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 80,
                      height: 24,
                      color: AppColors.surfaceMuted(brightness)),
                  Container(
                      width: 80,
                      height: 24,
                      color: AppColors.surfaceMuted(brightness)),
                  Container(
                      width: 80,
                      height: 24,
                      color: AppColors.surfaceMuted(brightness)),
                ],
              ),
            ],
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 1200.ms, color: AppColors.border(brightness)),
        const SizedBox(height: 16),
        SurfaceCard(
          padding: const EdgeInsets.all(16.0),
          child:
              Container(height: 150, color: AppColors.surfaceMuted(brightness)),
        )
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 1200.ms, color: AppColors.border(brightness)),
        const SizedBox(height: 16),
        SurfaceCard(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: List.generate(
                3,
                (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          Container(
                              width: 50,
                              height: 50,
                              color: AppColors.surfaceMuted(brightness)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: 120,
                                    height: 16,
                                    color: AppColors.surfaceMuted(brightness)),
                                const SizedBox(height: 8),
                                Container(
                                    width: 80,
                                    height: 14,
                                    color: AppColors.surfaceMuted(brightness)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 1200.ms, color: AppColors.border(brightness)),
      ],
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

  Widget _buildSummaryCard(
      BuildContext context, String locale, PriceAnalysis a, String currency) {
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
              _buildSourceBadge(context, locale, a),
            ],
          ),
          const SizedBox(height: 18.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metric(context, AppLocalizations.get(locale, 'price_min'),
                  a.minPriceKopecks, currency, AppColors.success),
              _metric(context, AppLocalizations.get(locale, 'price_avg'),
                  a.avgPriceKopecks, currency, AppColors.accent),
              _metric(context, AppLocalizations.get(locale, 'price_max'),
                  a.maxPriceKopecks, currency, AppColors.error),
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
    )
        .animate()
        .fade()
        .slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildSourceBadge(
      BuildContext context, String locale, PriceAnalysis a) {
    final isLive = !a.isEstimate;
    final color = isLive ? AppColors.success : AppColors.warning;
    final label = isLive
        ? AppLocalizations.get(locale, 'price_live_badge')
        : AppLocalizations.get(locale, 'price_fallback_badge');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: AppTypography.overline(
          context,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPriceChart(
    BuildContext context,
    String locale,
    PriceAnalysis a,
    Brightness brightness,
  ) {
    if (a.quotes.isEmpty) return const SizedBox.shrink();

    // Prepare chart data
    final spots = <FlSpot>[];
    for (int i = 0; i < a.quotes.length; i++) {
      spots.add(FlSpot(i.toDouble(), a.quotes[i].priceKopecks / 100));
    }

    final minY = (a.minPriceKopecks / 100) * 0.95; // 5% padding below min
    final maxY = (a.maxPriceKopecks / 100) * 1.05; // 5% padding above max

    return SurfaceCard(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.get(locale, 'price_trend_title'),
            style: AppTypography.h3(context),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: math.max(1, ((maxY - minY) / 4)),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.border(brightness),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (a.quotes.length - 1).toDouble(),
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.accent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppColors.accent,
                          strokeWidth: 2,
                          strokeColor: AppColors.surface(brightness),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.accent.withValues(alpha: 0.15),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) => AppColors.surface(brightness),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final store = a.quotes[spot.x.toInt()].store;
                        return LineTooltipItem(
                          '$store\n${formatAmount((spot.y * 100).toInt())}',
                          TextStyle(
                              color: AppColors.textPrimary(brightness),
                              fontWeight: FontWeight.bold),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fade(delay: 100.ms)
        .slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _metric(BuildContext context, String label, int kopecks,
      String currency, Color color) {
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

  Widget _buildGoalImpactCard(BuildContext context, String locale,
      PriceAnalysis a, int targetKopecks, String currency) {
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
            overBudget
                ? Icons.warning_amber_rounded
                : Icons.check_circle_outline,
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
    )
        .animate()
        .fade(delay: 200.ms)
        .slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildDealBadge(DealClassification classification) {
    switch (classification) {
      case DealClassification.bestDeal:
        return const Text('🔥 Вигідно',
            style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.bold));
      case DealClassification.marketPrice:
        return const Text('✅ Ринок',
            style: TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.bold));
      case DealClassification.overpriced:
        return const Text('⚠ Дорого',
            style: TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold));
    }
  }

  Widget _buildQuotesList(
      BuildContext context, String locale, PriceAnalysis a, String currency) {
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
          const SizedBox(height: 16),
          ...a.quotes.asMap().entries.map((entry) {
            final q = entry.value;
            final dealClass = q.getClassification(a.avgPriceKopecks);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  // Thumbnail or fallback
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted(brightness),
                      borderRadius: BorderRadius.circular(8),
                      image: q.thumbnail != null
                          ? DecorationImage(
                              image: NetworkImage(q.thumbnail!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: q.thumbnail == null
                        ? Icon(Icons.image_not_supported_rounded,
                            color: AppColors.textTertiary(brightness), size: 20)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.title,
                          style: AppTypography.bodySmall(context)
                              .copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              q.store,
                              style: AppTypography.caption(context,
                                  color: AppColors.textSecondary(brightness)),
                            ),
                            if (q.rating != null) ...[
                              const SizedBox(width: 6),
                              Icon(Icons.star_rounded,
                                  color: Colors.amber, size: 12),
                              const SizedBox(width: 2),
                              Text(
                                q.rating!,
                                style: AppTypography.caption(context,
                                    color: AppColors.textSecondary(brightness)),
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Price & Badge
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${formatAmount(q.priceKopecks)} $currency',
                        style: AppTypography.amount(context),
                      ),
                      const SizedBox(height: 4),
                      _buildDealBadge(dealClass),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    )
        .animate()
        .fade(delay: 300.ms)
        .slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildRecommendationCard(
      BuildContext context, String locale, PriceAnalysis a) {
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
                  style:
                      AppTypography.overline(context, color: AppColors.accent),
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
    )
        .animate()
        .fade(delay: 400.ms)
        .slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOut);
  }
}
