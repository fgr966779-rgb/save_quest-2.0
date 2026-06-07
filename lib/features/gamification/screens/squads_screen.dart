import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/widgets/surface_card.dart';
import '../providers/joint_goals_provider.dart';
import '../widgets/create_joint_goal_dialog.dart';

class SquadsScreen extends ConsumerWidget {
  const SquadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jointGoalsAsync = ref.watch(jointGoalsProvider);
    final brightness = Theme.of(context).brightness;
    final currentLocale = ref.watch(localeProvider);
    String t(String key) => AppLocalizations.get(currentLocale, key);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t('squad_title'),
          style: AppTypography.h3(context, color: AppColors.goalB),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary(brightness),
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const CreateJointGoalDialog(),
          );
        },
        backgroundColor: AppColors.goalB,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          t('squad_new_btn'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: jointGoalsAsync.when(
        data: (goalsData) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SurfaceCard(
                    padding: const EdgeInsets.all(16.0),
                    borderColor: AppColors.accent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.smart_toy, color: AppColors.accent),
                            const SizedBox(width: 8),
                            Text(
                              'NEXUS AI COACH',
                              style: AppTypography.h3(
                                context,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '"Your squad saved 30% more this week! Keep pushing the limits to unlock the Cyber-Vault achievement."',
                          style: AppTypography.body(
                            context,
                            color: AppColors.textSecondary(brightness),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (goalsData.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.group_add, size: 80, color: AppColors.goalB),
                        const SizedBox(height: 24.0),
                        Text(
                          t('squad_empty_title'),
                          textAlign: TextAlign.center,
                          style: AppTypography.h3(context),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final data = goalsData[index];
                      final goal = data.goal;
                      final members = data.members;
                      final progress = goal.targetAmount > 0
                          ? (goal.currentAmount / goal.targetAmount)
                          : 0.0;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 6.0,
                        ),
                        child: GestureDetector(
                          onTap: () => context.push('/joint-goal/${goal.id}'),
                          child: SurfaceCard(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      goal.title.toUpperCase(),
                                      style: AppTypography.h3(context),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: AppColors.goalB,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12.0),
                                Text(
                                  AppLocalizations.format(
                                    currentLocale,
                                    'squad_collected',
                                    {
                                      'amount':
                                          '${(goal.currentAmount / 100).toStringAsFixed(0)} / ${(goal.targetAmount / 100).toStringAsFixed(0)} ₴',
                                    },
                                  ),
                                  style: AppTypography.body(context),
                                ),
                                const SizedBox(height: 8.0),
                                LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: AppColors.border(brightness),
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.goalB,
                                  ),
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                const SizedBox(height: 12.0),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.people,
                                      color: AppColors.accent,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.format(
                                        currentLocale,
                                        'squad_members',
                                        {'count': '${members.length}'},
                                      ),
                                      style: AppTypography.caption(
                                        context,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: goalsData.length,
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('REAL-TIME FEED', style: AppTypography.h2(context)),
                      const SizedBox(height: 12),
                      SurfaceCard(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildFeedItem(
                              context,
                              brightness,
                              'Alex',
                              'deposited 500 ₴ to "MacBook Pro".',
                              '2m ago',
                              Icons.arrow_upward,
                            ),
                            const Divider(color: Colors.white12),
                            _buildFeedItem(
                              context,
                              brightness,
                              'Maria',
                              'completed Side Quest: "Coffee Detox".',
                              '1h ago',
                              Icons.star,
                            ),
                            const Divider(color: Colors.white12),
                            _buildFeedItem(
                              context,
                              brightness,
                              'NEXUS',
                              'Squad streak reached 7 days! +50 XP multiplier activated.',
                              '3h ago',
                              Icons.smart_toy,
                              isSystem: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.goalB),
        ),
        error: (e, _) => Center(
          child: Text(
            '${t("common_error")}: $e',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedItem(
    BuildContext context,
    Brightness brightness,
    String user,
    String action,
    String time,
    IconData icon, {
    bool isSystem = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: isSystem
                ? AppColors.accent.withValues(alpha: 0.2)
                : AppColors.goalB.withValues(alpha: 0.2),
            child: Icon(
              icon,
              color: isSystem ? AppColors.accent : AppColors.goalB,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTypography.body(context),
                    children: [
                      TextSpan(
                        text: '$user ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSystem
                              ? AppColors.accent
                              : AppColors.textPrimary(brightness),
                        ),
                      ),
                      TextSpan(
                        text: action,
                        style: TextStyle(
                          color: AppColors.textSecondary(brightness),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(time, style: AppTypography.caption(context, color: Colors.white38)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
