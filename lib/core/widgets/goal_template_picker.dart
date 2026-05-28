import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../providers/l10n.dart';
import '../providers/providers.dart';
import '../models/goal_template.dart';
import '../widgets/surface_card.dart';

/// Bottom sheet showing predefined goal templates.
/// When a template is selected, calls [onSelected] with the name and target amount.
class GoalTemplatePicker extends ConsumerWidget {
  final void Function(String name, double targetHryvnias) onSelected;

  const GoalTemplatePicker({super.key, required this.onSelected});

  /// Show the template picker bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required void Function(String name, double targetHryvnias) onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => GoalTemplatePicker(onSelected: onSelected),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);
    String t(String key) => AppLocalizations.get(locale, key);
    final currency = ref.watch(settingsServiceProvider).currency;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border(brightness),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                t('template_title'),
                style: AppTypography.h2(context),
              ),
              const SizedBox(height: 4),
              Text(
                t('template_subtitle'),
                style: AppTypography.body(
                  context,
                  color: AppColors.textSecondary(brightness),
                ),
              ),
              const SizedBox(height: 16),

              // Template grid
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: GoalTemplate.all.length,
                  itemBuilder: (context, index) {
                    final tmpl = GoalTemplate.all[index];
                    return _TemplateCard(
                      template: tmpl,
                      currency: currency,
                      brightness: brightness,
                      locale: locale,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onSelected(tmpl.name, tmpl.targetHryvnias.toDouble());
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Card for a single template in the picker.
class _TemplateCard extends StatelessWidget {
  final GoalTemplate template;
  final String currency;
  final Brightness brightness;
  final String locale;
  final VoidCallback onTap;

  const _TemplateCard({
    required this.template,
    required this.currency,
    required this.brightness,
    required this.locale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: SurfaceCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Emoji icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  template.emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: AppTypography.body(context),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '${template.targetHryvnias} $currency',
                          style: AppTypography.bodySmall(
                            context,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${template.monthlyPayment.toStringAsFixed(0)} $currency/${AppLocalizations.get(locale, 'calc_months')}',
                          style: AppTypography.overline(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Term badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.border(brightness).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${template.termMonths} ${AppLocalizations.get(locale, 'template_months_short')}',
                  style: AppTypography.overline(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
