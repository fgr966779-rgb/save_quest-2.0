import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:drift/drift.dart' as drift;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/database.dart';

final avoidedPurchasesProvider = StreamProvider<List<AvoidedPurchase>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.avoidedPurchases)
        ..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)]))
      .watch();
});

class RegretArchiveScreen extends ConsumerWidget {
  const RegretArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avoidedAsync = ref.watch(avoidedPurchasesProvider);
    final brightness = Theme.of(context).brightness;
    final currentLocale = ref.watch(localeProvider);
    String t(String key) => AppLocalizations.get(currentLocale, key);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: AppColors.textPrimary(brightness), size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          t('regret_title'),
          style: AppTypography.h3(context, color: AppColors.accent),
        ),
      ),
      body: avoidedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${t("common_error")}: $e')),
        data: (items) {
          if (items.isEmpty) {
            return _buildEmptyState(context, ref, brightness, t);
          }

          final totalSavedCents = items.fold<int>(0, (sum, item) => sum + item.amount);

          return Column(
            children: [
              _buildSummaryHeader(context, totalSavedCents, brightness, t),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _AvoidedPurchaseCard(item: item);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: AppButton(
                  label: t('regret_add_btn'),
                  onPressed: () => _showAddDialog(context, ref, brightness, t),
                  variant: ButtonVariant.primary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref,
      Brightness brightness, String Function(String) t) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_delete_outlined, size: 80, color: AppColors.textTertiary(brightness)),
          const SizedBox(height: 24),
          Text(
            t('regret_empty_title'),
            style: AppTypography.h3(context, color: AppColors.textPrimary(brightness)),
          ),
          const SizedBox(height: 12),
          Text(
            t('regret_empty_desc'),
            textAlign: TextAlign.center,
            style: AppTypography.body(context),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: t('regret_empty_btn'),
            onPressed: () => _showAddDialog(context, ref, brightness, t),
            variant: ButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(BuildContext context, int totalCents, Brightness brightness, String Function(String) t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentMutedBg(brightness),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            t('regret_total_saved'),
            style: AppTypography.overline(context),
          ),
          const SizedBox(height: 8),
          Text(
            '${centsToDisplay(totalCents).toStringAsFixed(2)} ₴',
            style: AppTypography.display(context, color: AppColors.accent),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref, Brightness brightness, String Function(String) t) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface(brightness),
        title: Text(
          t('regret_dialog_title'),
          style: AppTypography.h3(context, color: AppColors.accent),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(color: AppColors.textPrimary(brightness)),
              decoration: InputDecoration(
                labelText: t('regret_dialog_what'),
                labelStyle: TextStyle(color: AppColors.textSecondary(brightness)),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border(brightness))),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: AppColors.textPrimary(brightness)),
              decoration: InputDecoration(
                labelText: t('regret_dialog_price'),
                labelStyle: TextStyle(color: AppColors.textSecondary(brightness)),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border(brightness))),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t('common_cancel'), style: TextStyle(color: AppColors.textTertiary(brightness))),
          ),
          TextButton(
            onPressed: () async {
              final title = titleController.text;
              final amount = double.tryParse(amountController.text) ?? 0.0;
              if (title.isNotEmpty && amount > 0) {
                final db = ref.read(databaseProvider);
                await db.into(db.avoidedPurchases).insert(
                  AvoidedPurchase(
                    id: const Uuid().v4(),
                    title: title,
                    amount: displayToCents(amount),
                    createdAt: DateTime.now(),
                  ),
                );
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: Text(t('common_save'), style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _AvoidedPurchaseCard extends StatelessWidget {
  final AvoidedPurchase item;

  const _AvoidedPurchaseCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SurfaceCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted(brightness),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.block_flipped, color: AppColors.error, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title.toUpperCase(),
                    style: AppTypography.body(context, color: AppColors.textPrimary(brightness)).copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(item.createdAt),
                    style: AppTypography.caption(context),
                  ),
                ],
              ),
            ),
            Text(
              '+${centsToDisplay(item.amount).toStringAsFixed(0)} ₴',
              style: AppTypography.amount(context, color: AppColors.warning),
            ),
          ],
        ),
      ),
    );
  }
}
