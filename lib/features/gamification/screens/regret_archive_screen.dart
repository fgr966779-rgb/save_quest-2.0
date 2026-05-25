import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../data/database.dart';

final avoidedPurchasesProvider = StreamProvider<List<AvoidedPurchase>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.avoidedPurchases)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
});

class RegretArchiveScreen extends ConsumerWidget {
  const RegretArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avoidedAsync = ref.watch(avoidedPurchasesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'АРХІВ ЖАЛЮ',
          style: AppTextStyles.orbitronHeading(
            fontSize: 18,
            color: AppColors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: avoidedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Помилка: $e')),
        data: (items) {
          if (items.isEmpty) {
            return _buildEmptyState(context, ref);
          }

          final totalSavedCents = items.fold<int>(0, (sum, item) => sum + item.amount);

          return Column(
            children: [
              _buildSummaryHeader(totalSavedCents),
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
                child: NeonButton(
                  text: 'ДОДАТИ НЕКУПЛЕНЕ',
                  onPressed: () => _showAddDialog(context, ref),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_delete_outlined, size: 80, color: AppColors.textMuted),
          const SizedBox(height: 24),
          const Text(
            'ВАШ АРХІВ ПОРОЖНІЙ',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Тут зберігаються речі, які ви хотіли купити, але стрималися. Це ваші врятовані гроші!',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 32),
          NeonButton(
            text: 'ДОДАТИ ПЕРШИЙ ЗАПИС',
            onPressed: () => _showAddDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(int totalCents) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cyanAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text(
            'ВСЬОГО ВРЯТОВАНО',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          Text(
            '${centsToDisplay(totalCents).toStringAsFixed(2)} ₴',
            style: AppTextStyles.orbitronHeading(
              fontSize: 32,
              color: AppColors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: Text(
          'ДОДАТИ В АРХІВ',
          style: AppTextStyles.orbitronHeading(fontSize: 16, color: AppColors.cyanAccent),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Що ви не купили?',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Ціна (₴)',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('СКАСУВАТИ', style: TextStyle(color: AppColors.textMuted)),
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
            child: const Text('ЗБЕРЕГТИ', style: TextStyle(color: AppColors.cyanAccent, fontWeight: FontWeight.bold)),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        borderColor: Colors.white12,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.block_flipped, color: Colors.redAccent, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title.toUpperCase(),
                    style: AppTextStyles.rajdhaniMedium(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(item.createdAt),
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              '+${centsToDisplay(item.amount).toStringAsFixed(0)} ₴',
              style: AppTextStyles.orbitronHeading(
                fontSize: 16,
                color: AppColors.goldGlow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
