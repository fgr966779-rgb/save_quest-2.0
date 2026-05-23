import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../providers/joint_goals_provider.dart';

class JointGoalDetailScreen extends ConsumerWidget {
  final String goalId;

  const JointGoalDetailScreen({Key? key, required this.goalId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jointGoalsAsync = ref.watch(jointGoalsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'ДЕТАЛІ ЦІЛІ',
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
      body: jointGoalsAsync.when(
        data: (goalsData) {
          final dataIndex = goalsData.indexWhere((d) => d.goal.id == goalId);
          if (dataIndex == -1) {
            return const Center(child: Text('Ціль не знайдено', style: TextStyle(color: Colors.white)));
          }

          final data = goalsData[dataIndex];
          final goal = data.goal;
          final members = data.members;
          
          final double totalContributed = goal.currentAmount.toDouble();
          final double target = goal.targetAmount.toDouble();
          final double remaining = target - totalContributed > 0 ? target - totalContributed : 0;
          
          final List<Color> memberColors = [
            AppColors.cyanAccent,
            AppColors.magentaAccent,
            AppColors.goldGlow,
            AppColors.blueAccent,
            AppColors.fireOrange,
            Colors.greenAccent,
            Colors.purpleAccent,
            Colors.orangeAccent,
          ];

          String getGoalImage(String title) {
            final t = title.toLowerCase();
            if (t.contains('ps 5') || t.contains('playstation') || t.contains('ps5')) {
              return 'assets/images/ps5_neon.png';
            } else if (t.contains('монітор') || t.contains('monitor')) {
              return 'assets/images/monitor_neon.png';
            }
            return 'assets/images/ps5_neon.png';
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  goal.title.toUpperCase(),
                  style: AppTextStyles.orbitronHeading(fontSize: 24, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Зібрано ${(goal.currentAmount / 100).toStringAsFixed(0)} ₴ з ${(goal.targetAmount / 100).toStringAsFixed(0)} ₴',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // CHART
                SizedBox(
                  height: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 80,
                          sections: [
                            if (remaining > 0)
                              PieChartSectionData(
                                color: AppColors.cardBgLight,
                                value: remaining,
                                title: '',
                                radius: 20,
                              ),
                            ...members.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final m = entry.value;
                              if (m.contributedAmount <= 0) {
                                return PieChartSectionData(value: 0, title: '', radius: 0);
                              }
                              return PieChartSectionData(
                                color: memberColors[idx % memberColors.length],
                                value: m.contributedAmount.toDouble(),
                                title: '',
                                radius: 25,
                              );
                            }).toList(),
                          ],
                        ),
                      ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                      // Goal image in the center of donut
                      ClipOval(
                        child: Image.asset(
                          getGoalImage(goal.title),
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                          opacity: const AlwaysStoppedAnimation(0.7),
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback if image fails to load
                            return Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.magentaAccent.withOpacity(0.3),
                              ),
                              child: const Icon(Icons.image_not_supported, color: Colors.white54, size: 40),
                            );
                          },
                        ),
                      ),
                      // Text overlay
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'СПІЛЬНО',
                            style: AppTextStyles.interMuted(fontSize: 14).copyWith(letterSpacing: 1.5, color: Colors.white70),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(target > 0 ? (totalContributed / target * 100) : 0).clamp(0, 100).toStringAsFixed(0)}%',
                            style: AppTextStyles.orbitronHeading(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: members.asMap().entries.map((entry) {
                              final m = entry.value;
                              final c = memberColors[entry.key % memberColors.length];
                              final p = target > 0 ? (m.contributedAmount / target * 100).toStringAsFixed(0) : '0';
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
                                    const SizedBox(width: 4),
                                    Text('$p%', style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // MEMBERS LIST
                Text(
                  'УЧАСНИКИ (${members.length})',
                  style: AppTextStyles.rajdhaniMedium(fontSize: 18, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                ...members.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final m = entry.value;
                  final color = memberColors[idx % memberColors.length];
                  
                  return GlassCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: color.withOpacity(0.2),
                          child: Icon(Icons.person, color: color),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.memberName,
                                style: AppTextStyles.rajdhaniBold(fontSize: 18).copyWith(color: m.isCurrentUser ? AppColors.cyanAccent : Colors.white),
                              ),
                              Text(
                                'Внесок: ${(m.contributedAmount / 100).toStringAsFixed(0)} ₴',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: AppColors.magentaAccent),
                          tooltip: 'Додати внесок',
                          onPressed: () {
                            _showAddContributionDialog(context, ref, goalId, m.id, m.memberName);
                          },
                        )
                      ],
                    ),
                  ).animate().fadeIn(delay: (idx * 100).ms).slideX();
                }).toList(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.magentaAccent)),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showAddContributionDialog(BuildContext context, WidgetRef ref, String goalId, String memberId, String memberName) {
    final _controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.cardBg,
          title: Text('Внесок від: $memberName', style: const TextStyle(color: Colors.white)),
          content: TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Сума (₴)',
              labelStyle: const TextStyle(color: AppColors.textSecondary),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderNeon)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.magentaAccent)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('СКАСУВАТИ', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.magentaAccent),
              onPressed: () async {
                final amount = double.tryParse(_controller.text.trim()) ?? 0;
                if (amount > 0) {
                  final amountInKopecks = (amount * 100).toInt();
                  await ref.read(jointGoalsNotifierProvider.notifier).addContribution(goalId, memberId, amountInKopecks);
                  if (ctx.mounted) Navigator.pop(ctx);
                }
              },
              child: const Text('ДОДАТИ'),
            ),
          ],
        );
      }
    );
  }
}
