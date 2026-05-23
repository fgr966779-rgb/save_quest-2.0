import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../providers/joint_goals_provider.dart';
import '../widgets/create_joint_goal_dialog.dart';

class SquadsScreen extends ConsumerWidget {
  const SquadsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jointGoalsAsync = ref.watch(jointGoalsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'АЛЬЯНС / СПІЛЬНІ ЦІЛІ',
          style: AppTextStyles.orbitronHeading(
            fontSize: 18.0,
            color: AppColors.magentaAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
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
        backgroundColor: AppColors.magentaAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Нова спільна ціль', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    const Icon(Icons.group_add, size: 80, color: AppColors.magentaAccent)
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1.seconds),
                    const SizedBox(height: 24.0),
                    const Text(
                      'НЕМАЄ СПІЛЬНИХ ЦІЛЕЙ',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      'Створіть спільну ціль з друзями (або віртуальними друзями) для спільного накопичення!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14.0),
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
                child: GlassCard(
                  padding: const EdgeInsets.all(16.0),
                  borderColor: AppColors.magentaAccent.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            goal.title.toUpperCase(),
                            style: AppTextStyles.orbitronHeading(fontSize: 18.0, color: Colors.white),
                          ),
                          Icon(Icons.chevron_right, color: AppColors.magentaAccent),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        'Зібрано: ${(goal.currentAmount / 100).toStringAsFixed(0)} / ${(goal.targetAmount / 100).toStringAsFixed(0)} ₴',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(height: 8.0),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.borderNeon,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.magentaAccent),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        children: [
                          const Icon(Icons.people, color: AppColors.cyanAccent, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Учасників: ${members.length}',
                            style: const TextStyle(color: AppColors.cyanAccent, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: (index * 100).ms, duration: 400.ms).slideX(),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.magentaAccent)),
        error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
      ),
    );
  }
}
