import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/savings_notifier.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../data/database.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'all'; // all, goal_a, goal_b

  @override
  Widget build(BuildContext context) {
    final depositsAsync = ref.watch(depositsProvider);
    final goalsAsync = ref.watch(goalsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'ІСТОРІЯ ТРАНЗАКЦІЙ',
                style: AppTextStyles.rajdhaniMedium(
                  fontSize: 12.0,
                  color: AppColors.magentaAccent,
                ).copyWith(letterSpacing: 2.0),
              ),
              Text(
                'АРХІВ СЕЙФУ',
                style: AppTextStyles.orbitronHeading(
                  fontSize: 20.0,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),

              // Search & Filter Box
              _buildSearchAndFilter(),
              const SizedBox(height: 20.0),

              // History list
              Expanded(
                child: depositsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(
                    child: Text(
                      'Помилка завантаження: $err',
                      style: const TextStyle(color: AppColors.magentaAccent),
                    ),
                  ),
                  data: (deposits) {
                    final activeDeposits = deposits.where((d) => !d.isDeleted).toList();

                    // Filter deposits by search query and target goal
                    final filtered = activeDeposits.where((dep) {
                      final matchesSearch = dep.amount.toString().contains(_searchQuery) ||
                          _searchQuery.isEmpty;
                      
                      if (!matchesSearch) return false;

                      if (_selectedFilter == 'goal_a') {
                        return dep.goalAAmount > 0;
                      } else if (_selectedFilter == 'goal_b') {
                        return dep.goalBAmount > 0;
                      }
                      return true;
                    }).toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          'ТРАНЗАКЦІЙ НЕ ЗНАЙДЕНО',
                          style: AppTextStyles.orbitronHeading(
                            fontSize: 13.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }

                    // Group deposits by date
                    final grouped = _groupDepositsByDate(filtered);

                    return ListView.builder(
                      itemCount: grouped.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final group = grouped[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                group.dateString.toUpperCase(),
                                style: AppTextStyles.orbitronHeading(
                                  fontSize: 10.0,
                                  color: AppColors.cyanAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...group.items.map((dep) => _buildDepositItem(dep, goalsAsync.value ?? [])).toList(),
                            const SizedBox(height: 16.0),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Column(
      children: [
        // Search bar
        TextField(
          onChanged: (val) {
            setState(() {
              _searchQuery = val;
            });
          },
          style: AppTextStyles.orbitronHeading(fontSize: 13.0, color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Пошук за сумою...',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.cardBg.withOpacity(0.4),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: AppColors.borderNeon.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: AppColors.cyanAccent),
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        // Filter tabs
        Row(
          children: [
            _buildFilterButton('Всі', 'all'),
            const SizedBox(width: 8.0),
            _buildFilterButton('Ціль A', 'goal_a'),
            const SizedBox(width: 8.0),
            _buildFilterButton('Ціль B', 'goal_b'),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterButton(String label, String code) {
    final bool active = _selectedFilter == code;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() {
            _selectedFilter = code;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: active ? AppColors.magentaAccent.withOpacity(0.15) : AppColors.cardBg.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: active ? AppColors.magentaAccent : AppColors.borderNeon.withOpacity(0.3),
            ),
          ),
          child: Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTextStyles.orbitronHeading(
              fontSize: 10.0,
              color: active ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDepositItem(Deposit dep, List<Goal> goals) {
    final currency = goals.isNotEmpty ? goals.first.currency : '\$';
    final now = DateTime.now();
    final bool canDelete = now.difference(dep.createdAt).inHours < 24;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Dismissible(
        key: Key(dep.id.toString()),
        direction: canDelete ? DismissDirection.endToStart : DismissDirection.none,
        confirmDismiss: (direction) async {
          return await _showDeleteConfirmation(dep, currency);
        },
        onDismissed: (direction) async {
          await ref.read(savingsNotifierProvider.notifier).deleteDeposit(dep);
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: AppColors.magentaAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: AppColors.magentaAccent),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'ВИДАЛИТИ',
                style: TextStyle(
                  color: AppColors.magentaAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
              SizedBox(width: 8.0),
              Icon(Icons.delete_sweep, color: AppColors.magentaAccent),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: () => _showDetailsModal(dep, goals),
          child: GlassCard(
            padding: EdgeInsets.zero,
            borderColor: canDelete ? AppColors.cyanAccent.withOpacity(0.3) : AppColors.borderNeon.withOpacity(0.2),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                // Colored left stripe: cyan=goalA, magenta=goalB, both=split
                Container(
                  width: 3.0,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      bottomLeft: Radius.circular(16.0),
                    ),
                    gradient: dep.goalAAmount > 0 && dep.goalBAmount > 0
                        ? const LinearGradient(
                            colors: [AppColors.cyanAccent, AppColors.magentaAccent],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                        : null,
                    color: dep.goalAAmount > 0 && dep.goalBAmount > 0
                        ? null
                        : dep.goalAAmount > 0
                            ? AppColors.cyanAccent
                            : AppColors.magentaAccent,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: canDelete ? AppColors.cyanAccent.withOpacity(0.1) : AppColors.borderNeon.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.shield,
                                  color: canDelete ? AppColors.cyanAccent : AppColors.textSecondary,
                                  size: 20.0,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ВНЕСОК #${dep.id.length > 8 ? dep.id.substring(0, 8) : dep.id}',
                                      style: AppTextStyles.orbitronHeading(
                                        fontSize: 12.0,
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      DateFormat('HH:mm').format(dep.createdAt),
                                      style: const TextStyle(fontSize: 10.0, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '+${formatAmount(dep.amount)} $currency',
                              style: AppTextStyles.orbitronHeading(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Row(
                              children: [
                                if (dep.goalAAmount > 0)
                                  Container(
                                    width: 6,
                                    height: 6,
                                    margin: const EdgeInsets.only(right: 4.0),
                                    decoration: const BoxDecoration(color: AppColors.cyanAccent, shape: BoxShape.circle),
                                  ),
                                if (dep.goalBAmount > 0)
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(color: AppColors.magentaAccent, shape: BoxShape.circle),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(Deposit dep, String currency) async {
    HapticFeedback.heavyImpact();
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(color: AppColors.magentaAccent, width: 1.5),
        ),
        title: Text(
          'СКАСУВАННЯ ТРАНЗАКЦІЇ',
          style: AppTextStyles.orbitronHeading(
            fontSize: 14.0,
            color: AppColors.magentaAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Ви дійсно бажаєте видалити внесок на суму ${formatAmount(dep.amount)} $currency? Цю дію неможливо скасувати.',
          style: AppTextStyles.rajdhaniMedium(fontSize: 14.0, color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('ВІДМІНА', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('ВИДАЛИТИ', style: TextStyle(color: AppColors.magentaAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showDetailsModal(Deposit dep, List<Goal> goals) {
    HapticFeedback.lightImpact();
    final goalA = goals.firstWhere((g) => g.id == 'goal_a');
    final goalB = goals.firstWhere((g) => g.id == 'goal_b');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
            border: Border.all(color: AppColors.borderNeon.withOpacity(0.3), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 50.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                'ДЕТАЛІ ТРАНЗАКЦІЇ',
                textAlign: TextAlign.center,
                style: AppTextStyles.orbitronHeading(fontSize: 14.0, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24.0),

              // Allocation Split visual
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildModalGoalDetail(goalA.name, '${formatAmount(dep.goalAAmount)} ${goalA.currency}', AppColors.cyanAccent),
                  Container(
                    width: 1.5,
                    height: 40.0,
                    color: AppColors.borderNeon.withOpacity(0.3),
                  ),
                  _buildModalGoalDetail(goalB.name, '${formatAmount(dep.goalBAmount)} ${goalB.currency}', AppColors.magentaAccent),
                ],
              ),
              const SizedBox(height: 32.0),

              // Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Час транзакції:', style: TextStyle(color: AppColors.textSecondary, fontSize: 13.0)),
                  Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(dep.createdAt),
                    style: AppTextStyles.orbitronHeading(fontSize: 12.0, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              // Security status check
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Статус редагування:', style: TextStyle(color: AppColors.textSecondary, fontSize: 13.0)),
                  Text(
                    DateTime.now().difference(dep.createdAt).inHours < 24 ? 'АКТИВНИЙ СЕЙФ' : 'ЗАБЛОКОВАНО (24Г)',
                    style: AppTextStyles.orbitronHeading(
                      fontSize: 12.0,
                      color: DateTime.now().difference(dep.createdAt).inHours < 24 ? AppColors.cyanAccent : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalGoalDetail(String title, String amount, Color accentColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11.0, color: accentColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6.0),
          Text(
            amount,
            style: AppTextStyles.orbitronHeading(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  List<DateGroupedDeposits> _groupDepositsByDate(List<Deposit> items) {
    final Map<String, List<Deposit>> groups = {};
    for (var dep in items) {
      final String formattedDate = DateFormat('dd MMMM yyyy', 'uk').format(dep.createdAt);
      if (groups.containsKey(formattedDate)) {
        groups[formattedDate]!.add(dep);
      } else {
        groups[formattedDate] = [dep];
      }
    }

    return groups.entries.map((e) => DateGroupedDeposits(dateString: e.key, items: e.value)).toList();
  }
}

class DateGroupedDeposits {
  final String dateString;
  final List<Deposit> items;

  DateGroupedDeposits({required this.dateString, required this.items});
}
