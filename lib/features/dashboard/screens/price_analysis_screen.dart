import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/price_analysis_service.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/neon_button.dart';

class PriceAnalysisScreen extends ConsumerStatefulWidget {
  final String? initialQuery;
  final int? targetAmountKopecks;
  final String? currency;

  const PriceAnalysisScreen({
    Key? key,
    this.initialQuery,
    this.targetAmountKopecks,
    this.currency,
  }) : super(key: key);

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
    final query = _controller.text.trim();
    if (query.isEmpty) {
      setState(() {
        _error = 'Введіть назву товару для аналізу';
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
        _error = 'Не вдалося отримати ціни: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = widget.currency ?? '₴';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSearchCard(),
                    const SizedBox(height: 20.0),
                    if (_error != null) _buildErrorCard(_error!),
                    if (_analysis != null) ...[
                      _buildSummaryCard(_analysis!, currency),
                      const SizedBox(height: 16.0),
                      if (widget.targetAmountKopecks != null)
                        _buildGoalImpactCard(
                          _analysis!,
                          widget.targetAmountKopecks!,
                          currency,
                        ),
                      if (widget.targetAmountKopecks != null)
                        const SizedBox(height: 16.0),
                      _buildQuotesCard(_analysis!, currency),
                      const SizedBox(height: 16.0),
                      _buildRecommendationCard(_analysis!),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'СКАНЕР РИНКУ',
                  style: AppTextStyles.rajdhaniMedium(
                    fontSize: 11,
                    color: AppColors.cyanAccent,
                  ).copyWith(letterSpacing: 2),
                ),
                Text(
                  'АНАЛІЗ ЦІНИ',
                  style: AppTextStyles.orbitronHeading(
                    fontSize: 18,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return GlassCard(
      padding: const EdgeInsets.all(16.0),
      borderColor: AppColors.cyanAccent.withOpacity(0.3),
      glowColor: AppColors.cyanAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ЦІЛЬОВИЙ ТОВАР',
            style: AppTextStyles.orbitronHeading(
              fontSize: 12,
              color: AppColors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12.0),
          TextField(
            controller: _controller,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15.0),
            decoration: InputDecoration(
              hintText: 'Наприклад: PS5, монітор 27"',
              hintStyle: const TextStyle(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.cardBgLight,
              prefixIcon: const Icon(Icons.search_rounded,
                  color: AppColors.cyanAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: AppColors.borderNeon.withOpacity(0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(
                  color: AppColors.borderNeon.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: AppColors.cyanAccent),
              ),
            ),
            onSubmitted: (_) => _run(),
          ),
          const SizedBox(height: 16.0),
          NeonButton(
            text: 'СКАНУВАТИ ЦІНИ',
            onPressed: _isLoading ? null : _run,
            isLoading: _isLoading,
            icon: const Icon(Icons.radar_rounded, color: Colors.black, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return GlassCard(
      padding: const EdgeInsets.all(14.0),
      borderColor: AppColors.magentaAccent.withOpacity(0.5),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.magentaAccent, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(PriceAnalysis a, String currency) {
    return GlassCard(
      padding: const EdgeInsets.all(20.0),
      borderColor: AppColors.cyanAccent.withOpacity(0.4),
      glowColor: AppColors.cyanAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ДІАПАЗОН ЦІН',
                style: AppTextStyles.orbitronHeading(
                  fontSize: 12,
                  color: AppColors.cyanAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (a.isEstimate)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.goldAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: AppColors.goldAccent.withOpacity(0.5)),
                  ),
                  child: Text(
                    'ОЦІНКА',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.2,
                      color: AppColors.goldAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metric('МІНІМУМ', a.minPriceKopecks, currency,
                  AppColors.greenAccent),
              _metric('СЕРЕДНЯ', a.avgPriceKopecks, currency,
                  AppColors.cyanAccent),
              _metric('МАКСИМУМ', a.maxPriceKopecks, currency,
                  AppColors.magentaAccent),
            ],
          ),
          const SizedBox(height: 14.0),
          Text(
            'Розкид: ${formatAmount(a.spreadKopecks)} $currency '
            '(${(a.spreadRatio * 100).toStringAsFixed(1)}%)',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, int kopecks, String currency, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${formatAmount(kopecks)} $currency',
          style: AppTextStyles.orbitronHeading(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalImpactCard(
      PriceAnalysis a, int targetKopecks, String currency) {
    final diff = targetKopecks - a.minPriceKopecks;
    final overBudget = diff < 0;
    final color = overBudget ? AppColors.magentaAccent : AppColors.greenAccent;
    final label = overBudget
        ? 'Ціль менша за ринкову ціну на ${formatAmount(-diff)} $currency. '
            'Розгляньте підняття цілі.'
        : 'Ваша ціль вища за мінімальну ціну на ${formatAmount(diff)} $currency. '
            'Можна досягти раніше або обрати кращу комплектацію.';

    return GlassCard(
      padding: const EdgeInsets.all(16.0),
      borderColor: color.withOpacity(0.4),
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
                  'ПОРІВНЯННЯ З ЦІЛЛЮ',
                  style: TextStyle(
                    fontSize: 9.5,
                    color: color,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotesCard(PriceAnalysis a, String currency) {
    return GlassCard(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ЦІНИ ПО МАГАЗИНАХ',
            style: AppTextStyles.orbitronHeading(
              fontSize: 12,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
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
                          ? AppColors.greenAccent
                          : AppColors.borderNeonActive,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      q.store,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${formatAmount(q.priceKopecks)} $currency',
                    style: AppTextStyles.orbitronHeading(
                      fontSize: 13,
                      color: isCheapest
                          ? AppColors.greenAccent
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
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

  Widget _buildRecommendationCard(PriceAnalysis a) {
    return GlassCard(
      padding: const EdgeInsets.all(14.0),
      borderColor: AppColors.purpleGlow.withOpacity(0.4),
      child: Row(
        children: [
          const Icon(Icons.psychology_alt_rounded,
              color: AppColors.purpleGlow, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ВИСНОВОК АНАЛІТИКА',
                  style: TextStyle(
                    fontSize: 9.5,
                    color: AppColors.purpleGlow,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  a.recommendation,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
