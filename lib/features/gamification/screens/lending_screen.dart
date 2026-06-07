import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';
import '../providers/lending_provider.dart';
import '../../../data/database.dart';

class LendingScreen extends ConsumerStatefulWidget {
  const LendingScreen({super.key});

  @override
  ConsumerState<LendingScreen> createState() => _LendingScreenState();
}

class _LendingScreenState extends ConsumerState<LendingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contractsAsync = ref.watch(lendingContractsProvider);
    final locale = ref.watch(localeProvider);
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.get(locale, 'lend_title')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.get(locale, 'common_active')),
            Tab(text: AppLocalizations.get(locale, 'hist_filter_all')),
          ],
        ),
      ),
      body: contractsAsync.when(
        data: (contracts) {
          final active = contracts.where((c) => !c.isReturned).toList();
          final all = contracts;

          return TabBarView(
            controller: _tabController,
            children: [
              _buildContractList(context, active, locale, brightness),
              _buildContractList(context, all, locale, brightness),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddContractSheet(context),
        icon: const Icon(Icons.add_moderator),
        label: Text(AppLocalizations.get(locale, 'lend_add_btn')),
      ),
    );
  }

  Widget _buildContractList(BuildContext context, List<LendingContract> contracts, String locale, Brightness brightness) {
    if (contracts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.description_outlined, size: 64, color: AppColors.textSecondary(brightness)),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.get(locale, 'lend_empty'),
                textAlign: TextAlign.center,
                style: AppTypography.body(context, color: AppColors.textSecondary(brightness)),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      itemCount: contracts.length,
      itemBuilder: (context, index) {
        final contract = contracts[index];
        return _ContractCard(contract: contract);
      },
    );
  }

  void _showAddContractSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddContractSheet(),
    );
  }
}

class _ContractCard extends ConsumerWidget {
  final LendingContract contract;

  const _ContractCard({required this.contract});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final brightness = Theme.of(context).brightness;
    final now = DateTime.now();
    final isOverdue = !contract.isReturned && contract.returnDate.isBefore(now);
    
    final diff = contract.returnDate.difference(now).inDays;
    final statusColor = contract.isReturned 
        ? AppColors.success 
        : (isOverdue ? AppColors.error : AppColors.accent);

    return SurfaceCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  contract.debtorName.toUpperCase(),
                  style: AppTypography.h3(context, color: AppColors.textPrimary(brightness)).copyWith(letterSpacing: 1.5),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  AppLocalizations.get(locale, 
                    contract.isReturned 
                      ? 'lend_status_returned' 
                      : (isOverdue ? 'lend_status_overdue' : 'lend_status_active')
                  ),
                  style: AppTypography.overline(context, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(contract.amount / 100).toStringAsFixed(2)} ₴',
                style: AppTypography.h2(context, color: AppColors.accent),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('dd.MM.yyyy').format(contract.returnDate),
                    style: AppTypography.caption(context, color: AppColors.textSecondary(brightness)),
                  ),
                  if (!contract.isReturned)
                    Text(
                      isOverdue
                        ? AppLocalizations.format(locale, 'lend_overdue_by', {'days': diff.abs().toString()})
                        : AppLocalizations.format(locale, 'lend_days_left', {'days': diff.toString()}),
                      style: AppTypography.overline(context, color: isOverdue ? AppColors.error : AppColors.success),
                    ),
                ],
              ),
            ],
          ),
          if (!contract.isReturned) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(lendingProvider.notifier).markAsReturned(contract);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.get(locale, 'lend_returned_toast')))
                  );
                },
                icon: const Icon(Icons.check_circle_outline),
                label: Text(AppLocalizations.get(locale, 'lend_return_btn')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success.withValues(alpha: 0.1),
                  foregroundColor: AppColors.success,
                  side: const BorderSide(color: AppColors.success),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddContractSheet extends ConsumerStatefulWidget {
  const _AddContractSheet();

  @override
  ConsumerState<_AddContractSheet> createState() => _AddContractSheetState();
}

class _AddContractSheetState extends ConsumerState<_AddContractSheet> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _returnDate = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _setDays(int days) {
    setState(() {
      _returnDate = DateTime.now().add(Duration(days: days));
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _returnDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        _returnDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final debtorNames = ref.watch(debtorNamesProvider).value ?? [];
    final brightness = Theme.of(context).brightness;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface(brightness),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 24),
            Text(
              AppLocalizations.get(locale, 'lend_add_btn'),
              style: AppTypography.h2(context),
            ),
            const SizedBox(height: 24),
            
            // Debtor Name with "history" suggestions
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue value) {
                if (value.text.isEmpty) return const Iterable<String>.empty();
                return debtorNames.where((n) => n.toLowerCase().contains(value.text.toLowerCase()));
              },
              onSelected: (name) => _nameController.text = name,
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.get(locale, 'lend_debtor_name'),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.get(locale, 'lend_amount'),
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              AppLocalizations.get(locale, 'lend_return_date'),
              style: AppTypography.bodySmall(context, color: AppColors.textSecondary(brightness)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat('dd.MM.yyyy').format(_returnDate),
                    style: AppTypography.h3(context, color: AppColors.accent),
                  ),
                ),
                TextButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(AppLocalizations.get(locale, 'lend_pick_date')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _QuickDateChip(label: AppLocalizations.get(locale, 'lend_quick_7'), onTap: () => _setDays(7)),
                const SizedBox(width: 8),
                _QuickDateChip(label: AppLocalizations.get(locale, 'lend_quick_30'), onTap: () => _setDays(30)),
              ],
            ),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  final name = _nameController.text;
                  final amount = double.tryParse(_amountController.text) ?? 0;
                  if (name.isNotEmpty && amount > 0) {
                    ref.read(lendingProvider.notifier).addContract(
                      debtorName: name,
                      amountCents: (amount * 100).toInt(),
                      returnDate: _returnDate,
                    );
                    context.pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  AppLocalizations.get(locale, 'lend_save_btn'),
                  style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickDateChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickDateChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppColors.accent.withValues(alpha: 0.1),
      side: BorderSide(color: AppColors.accent.withValues(alpha: 0.3)),
      labelStyle: const TextStyle(color: AppColors.accent, fontSize: 12),
    );
  }
}
