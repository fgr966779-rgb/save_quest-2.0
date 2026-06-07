import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/database.dart';
import '../providers/price_hunter_provider.dart';

class PriceHunterWidget extends ConsumerWidget {
  final Goal goal;
  final Color accentColor;

  const PriceHunterWidget({
    super.key,
    required this.goal,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);

    final bool isTracking = goal.productUrl != null && goal.productUrl!.isNotEmpty && goal.targetPrice != null;

    return SurfaceCard(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.track_changes, color: accentColor),
              const SizedBox(width: 8.0),
              Text(
                AppLocalizations.get(locale, 'ph_title'),
                style: AppTypography.h3(context),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          if (!isTracking) ...[
            Text(
              'Відстежуйте знижки на товар, щоб завдати критичної шкоди босу!',
              style: AppTypography.body(context, color: AppColors.textSecondary(brightness)),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _showSetupDialog(context, ref, locale),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor.withValues(alpha: 0.1),
                foregroundColor: accentColor,
                side: BorderSide(color: accentColor),
              ),
              child: Text(AppLocalizations.get(locale, 'ph_track_btn')),
            ),
          ] else ...[
            // Tracking Active
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPriceCol(
                  context,
                  AppLocalizations.get(locale, 'ph_initial_price_label'),
                  formatAmount(goal.targetPrice!),
                  AppColors.textSecondary(brightness),
                ),
                _buildPriceCol(
                  context,
                  AppLocalizations.get(locale, 'ph_current_price_label'),
                  formatAmount(goal.currentPrice ?? goal.targetPrice!),
                  accentColor,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildShieldHp(context, locale, goal.priceShieldHp),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _showUpdateDialog(context, ref, locale),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.black,
              ),
              child: Text(AppLocalizations.get(locale, 'ph_update_btn')),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceCol(BuildContext context, String label, String price, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption(context, color: AppColors.textSecondary(Theme.of(context).brightness)),
        ),
        Text(
          '$price ₴',
          style: AppTypography.h3(context).copyWith(color: color),
        ),
      ],
    );
  }

  Widget _buildShieldHp(BuildContext context, String locale, int hp) {
    final bool isDestroyed = hp == 0;
    final color = isDestroyed ? Colors.red : Colors.blue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Щит Ціни Боса',
              style: AppTypography.caption(context, color: color),
            ),
            Text(
              '$hp%',
              style: AppTypography.caption(context, color: color).copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 6.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: LinearProgressIndicator(
            value: hp / 100.0,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8.0,
          ),
        ),
        if (isDestroyed)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              AppLocalizations.get(locale, 'ph_boss_vulnerable'),
              style: AppTypography.caption(context, color: Colors.red).copyWith(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  void _showSetupDialog(BuildContext context, WidgetRef ref, String locale) {
    final urlController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface(Theme.of(ctx).brightness),
        title: Text(AppLocalizations.get(locale, 'ph_track_btn')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: AppLocalizations.get(locale, 'ph_url_label'),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: AppLocalizations.get(locale, 'ph_initial_price_label'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.get(locale, 'common_cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              final url = urlController.text.trim();
              final priceText = priceController.text.trim();
              final price = double.tryParse(priceText);
              if (url.isNotEmpty && price != null && price > 0) {
                ref.read(priceHunterProvider.notifier).setProductUrl(
                  goal.id,
                  url,
                  (price * 100).toInt(),
                );
                Navigator.pop(ctx);
              }
            },
            child: Text(AppLocalizations.get(locale, 'common_save')),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, WidgetRef ref, String locale) {
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface(Theme.of(ctx).brightness),
        title: Text(AppLocalizations.get(locale, 'ph_update_btn')),
        content: TextField(
          controller: priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: AppLocalizations.get(locale, 'ph_new_price_label'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.get(locale, 'common_cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              final priceText = priceController.text.trim();
              final price = double.tryParse(priceText);
              if (price != null && price > 0) {
                await ref.read(priceHunterProvider.notifier).updateManualPrice(
                  goal.id,
                  (price * 100).toInt(),
                );
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                }
              }
            },
            child: Text(AppLocalizations.get(locale, 'common_save')),
          ),
        ],
      ),
    );
  }
}
