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
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary(brightness), size: 20),
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
        label: Text(t('squad_new_btn'), style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: jointGoalsAsync.when(
        data: (goalsData) {
          if (goalsData.isEmpty) {
            return Center(
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
                    const SizedBox(height: 12.0),
                    Text(
                      t('squads_empty_desc'),
                      textAlign: TextAlign.center,
                      style: AppTypography.body(context),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: goalsData.length,
            itemBuilder: (context, index) {
              final data = goalsData[index];
              final goal = data.goal;
              final members = data.members;
              final progress = goal.targetAmount > 0 ? (goal.currentAmount / goal.targetAmount) : 0.0;

              return GestureDetector(
                onTap: () {
                  context.push('/joint-goal/${goal.id}');
                },
                child: SurfaceCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            goal.title.toUpperCase(),
                            style: AppTypography.h3(context),
                          ),
                          Icon(Icons.chevron_right, color: AppColors.goalB),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        AppLocalizations.format(currentLocale, 'squad_collected', {
                          'amount': '${(goal.currentAmount / 100).toStringAsFixed(0)} / ${(goal.targetAmount / 100).toStringAsFixed(0)} ₴',
                        }),
                        style: AppTypography.body(context),
                      ),
                      const SizedBox(height: 8.0),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.border(brightness),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.goalB),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        children: [
                          Icon(Icons.people, color: AppColors.accent, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.format(currentLocale, 'squad_members', {'count': '${members.length}'}),
                            style: AppTypography.caption(context, color: AppColors.accent),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.goalB)),
        error: (e, _) => Center(child: Text('${t("common_error")}: $e', style: TextStyle(color: AppColors.error))),
      ),
    );
  }
}
