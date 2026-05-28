import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../data/database.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

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
    final locale = ref.watch(localeProvider);

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
                AppLocalizations.get(locale, 'hist_title'),
                style: AppTypography.h1(context),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.get(locale, 'hist_subtitle'),
                style: AppTypography.body(context),
              ),
              const SizedBox(height: 20.0),

              // Search & Filter Box
              _buildSearchAndFilter(locale),
              const SizedBox(height: 20.0),

              // History list
              Expanded(
                child: depositsAsync.when(
                  loading: () => const SkeletonList(itemCount: 4),
                  error: (err, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        '${AppLocalizations.get(locale, 'hist_load_error')}$err',
                        style: AppTypography.body(context, color: AppColors.error),
                      ),
                    ),
                  ),
                  data: (deposits) {
                    final activeDeposits =
                        deposits.where((d) => !d.isDeleted).toList();

                    // Filter deposits by search query and target goal
                    final filtered = activeDeposits.where((dep) {
                      final matchesSearch =
                          dep.amount.toString().contains(_searchQuery) ||
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
                      return EmptyState(
                        icon: const Icon(Icons.receipt_long_outlined),
                        title: AppLocalizations.get(locale, 'hist_empty_title'),
                        description: AppLocalizations.get(locale, 'hist_empty_desc'),
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
                              padding: const EdgeInsets.only(
                                  left: 4, bottom: 8.0, top: 12.0),
                              child: Text(
                                group.dateString,
                                style: AppTypography.overline(context),
                              ),
                            ),
                            ...group.items
                                .map((dep) => _buildDepositItem(
                                      dep,
                                      goalsAsync.value ?? [],
                                      locale,
                                    ))
                                ,
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

  Widget _buildSearchAndFilter(String locale) {
    return Column(
      children: [
        // Search bar — uses theme InputDecorationTheme
        TextField(
          onChanged: (val) {
            setState(() {
              _searchQuery = val;
            });
          },
          style: AppTypography.body(context),
          decoration: InputDecoration(
            hintText: AppLocalizations.get(locale, 'hist_search_hint'),
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 12.0),
        // Filter tabs
        Row(
          children: [
            _buildFilterButton(AppLocalizations.get(locale, 'hist_filter_all'), 'all'),
            const SizedBox(width: 8.0),
            _buildFilterButton(AppLocalizations.get(locale, 'dash_goal_a'), 'goal_a'),
            const SizedBox(width: 8.0),
            _buildFilterButton(AppLocalizations.get(locale, 'dash_goal_b'), 'goal_b'),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterButton(String label, String code) {
    final brightness = Theme.of(context).brightness;
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
            color: active
                ? AppColors.accent.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: active
                  ? AppColors.accent
                  : AppColors.border(brightness),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall(
              context,
              color: active ? AppColors.accent : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDepositItem(Deposit dep, List<Goal> goals, String locale) {
    final brightness = Theme.of(context).brightness;
    final currency = goals.isNotEmpty ? goals.first.currency : '₴';
    final now = DateTime.now();
    final bool canDelete = now.difference(dep.createdAt).inHours < 24;

    // Determine stripe color
    final Color stripeColor;
    if (dep.goalAAmount > 0 && dep.goalBAmount > 0) {
      // Both goals — use a gradient stripe
      stripeColor = AppColors.goalA;
    } else if (dep.goalAAmount > 0) {
      stripeColor = AppColors.goalA;
    } else {
      stripeColor = AppColors.goalB;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                AppLocalizations.get(locale, 'hist_swipe_delete'),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.0,
                ),
              ),
              SizedBox(width: 8.0),
              Icon(Icons.delete_outline, color: Colors.white),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: () => _showDetailsModal(dep, goals),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: AppColors.border(brightness),
              ),
              color: AppColors.surface(brightness),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Colored left stripe (3px)
                  Container(
                    width: 3.0,
                    decoration: BoxDecoration(
                      gradient: dep.goalAAmount > 0 && dep.goalBAmount > 0
                          ? const LinearGradient(
                              colors: [AppColors.goalA, AppColors.goalB],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : null,
                      color: dep.goalAAmount > 0 && dep.goalBAmount > 0
                          ? null
                          : stripeColor,
                    ),
                  ),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceMuted(brightness),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.textSecondary(brightness),
                                    size: 18.0,
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${AppLocalizations.get(locale, 'hist_entry_label')}${dep.id.length > 8 ? dep.id.substring(0, 8) : dep.id}',
                                        style: AppTypography.bodySmall(context),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        DateFormat('HH:mm')
                                            .format(dep.createdAt),
                                        style: AppTypography.caption(context),
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
                                style: AppTypography.amount(context),
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [
                                  if (dep.goalAAmount > 0)
                                    Container(
                                      width: 6,
                                      height: 6,
                                      margin:
                                          const EdgeInsets.only(right: 4.0),
                                      decoration: const BoxDecoration(
                                        color: AppColors.goalA,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  if (dep.goalBAmount > 0)
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: AppColors.goalB,
                                        shape: BoxShape.circle,
                                      ),
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
    final locale = ref.read(localeProvider);
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.get(locale, 'hist_cancel_dialog_title'),
          style: AppTypography.h3(context),
        ),
        content: Text(
          AppLocalizations.get(locale, 'hist_cancel_dialog_desc'),
          style: AppTypography.body(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              AppLocalizations.get(locale, 'common_cancel'),
              style: AppTypography.body(context,
                  color: AppColors.textSecondary(Theme.of(context).brightness)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              AppLocalizations.get(locale, 'common_delete'),
              style: AppTypography.body(context, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showDetailsModal(Deposit dep, List<Goal> goals) {
    HapticFeedback.heavyImpact();
    final locale = ref.read(localeProvider);
    final goalA = goals.firstWhere((g) => g.id == 'goal_a');
    final goalB = goals.firstWhere((g) => g.id == 'goal_b');
    final brightness = Theme.of(context).brightness;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: AppColors.border(brightness),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                AppLocalizations.get(locale, 'hist_detail_title'),
                textAlign: TextAlign.center,
                style: AppTypography.h2(context),
              ),
              const SizedBox(height: 24.0),

              // Allocation split visual
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildModalGoalDetail(
                    goalA.name,
                    '${formatAmount(dep.goalAAmount)} ${goalA.currency}',
                    AppColors.goalA,
                  ),
                  Container(
                    width: 1,
                    height: 40.0,
                    color: AppColors.border(brightness),
                  ),
                  _buildModalGoalDetail(
                    goalB.name,
                    '${formatAmount(dep.goalBAmount)} ${goalB.currency}',
                    AppColors.goalB,
                  ),
                ],
              ),
              const SizedBox(height: 32.0),

              // Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.get(locale, 'hist_detail_time'),
                    style: AppTypography.body(context),
                  ),
                  Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(dep.createdAt),
                    style: AppTypography.bodySmall(context),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              // Edit status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.get(locale, 'hist_detail_status'),
                    style: AppTypography.body(context),
                  ),
                  Text(
                    DateTime.now().difference(dep.createdAt).inHours < 24
                        ? AppLocalizations.get(locale, 'hist_status_active')
                        : AppLocalizations.get(locale, 'hist_status_locked'),
                    style: AppTypography.bodySmall(
                      context,
                      color: DateTime.now().difference(dep.createdAt).inHours < 24
                          ? AppColors.success
                          : null,
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

  Widget _buildModalGoalDetail(
      String title, String amount, Color accentColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall(context, color: accentColor),
          ),
          const SizedBox(height: 6.0),
          Text(
            amount,
            style: AppTypography.metric(context),
          ),
        ],
      ),
    );
  }

  List<DateGroupedDeposits> _groupDepositsByDate(List<Deposit> items) {
    final Map<String, List<Deposit>> groups = {};
    for (var dep in items) {
      final String formattedDate =
          DateFormat('dd MMMM yyyy', 'uk').format(dep.createdAt);
      if (groups.containsKey(formattedDate)) {
        groups[formattedDate]!.add(dep);
      } else {
        groups[formattedDate] = [dep];
      }
    }

    return groups.entries
        .map((e) => DateGroupedDeposits(dateString: e.key, items: e.value))
        .toList();
  }
}

class DateGroupedDeposits {
  final String dateString;
  final List<Deposit> items;

  DateGroupedDeposits({required this.dateString, required this.items});
}
