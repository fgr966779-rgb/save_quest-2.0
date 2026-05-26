import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';
import '../providers/joint_goals_provider.dart';

class JointGoalDetailScreen extends ConsumerWidget {
  final String goalId;

  const JointGoalDetailScreen({Key? key, required this.goalId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    String t(String key) => AppLocalizations.get(currentLocale, key);

    final jointGoalsAsync = ref.watch(jointGoalsProvider);
    final brightness = Theme.of(context).brightness;

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
      body: jointGoalsAsync.when(
        data: (goalsData) {
          final dataIndex = goalsData.indexWhere((d) => d.goal.id == goalId);
          if (dataIndex == -1) {
            return Center(child: Text(t('goal_not_found'), style: TextStyle(color: AppColors.textPrimary(brightness))));
          }

          final data = goalsData[dataIndex];
          final goal = data.goal;
          final members = data.members;
          
          final double totalContributed = goal.currentAmount.toDouble();
          final double target = goal.targetAmount.toDouble();
          final double remaining = target - totalContributed > 0 ? target - totalContributed : 0;
          
          final List<Color> memberColors = [
            AppColors.accent,
            AppColors.goalB,
            AppColors.warning,
            AppColors.chartBlue,
            AppColors.chartOrange,
            AppColors.success,
            AppColors.chartPurple,
            AppColors.chartAmber,
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
                  style: AppTypography.h2(context, color: AppColors.textPrimary(brightness)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.format(currentLocale, 'squad_collected', {
                    'current': '${(goal.currentAmount / 100).toStringAsFixed(0)}',
                    'target': '${(goal.targetAmount / 100).toStringAsFixed(0)}',
                    'currency': '₴',
                  }),
                  style: AppTypography.body(context),
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
                                color: AppColors.surfaceMuted(brightness),
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
                      ),
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
                                color: AppColors.goalB.withOpacity(0.3),
                              ),
                              child: Icon(Icons.image_not_supported, color: AppColors.textSecondary(brightness), size: 40),
                            );
                          },
                        ),
                      ),
                      // Text overlay
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            t('joint_detail_together'),
                            style: AppTypography.caption(context, color: AppColors.textSecondary(brightness)).copyWith(letterSpacing: 1.5),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(target > 0 ? (totalContributed / target * 100) : 0).clamp(0, 100).toStringAsFixed(0)}%',
                            style: AppTypography.display(context, color: AppColors.textPrimary(brightness)),
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
                  AppLocalizations.format(currentLocale, 'squad_members', {'count': '${members.length}'}),
                  style: AppTypography.h3(context, color: AppColors.textPrimary(brightness)),
                ),
                const SizedBox(height: 12),
                ...members.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final m = entry.value;
                  final color = memberColors[idx % memberColors.length];
                  
                  return SurfaceCard(
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
                                style: AppTypography.body(context, color: m.isCurrentUser ? AppColors.accent : AppColors.textPrimary(brightness)).copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                AppLocalizations.format(currentLocale, 'joint_detail_contribution', {
                                  'amount': '${(m.contributedAmount / 100).toStringAsFixed(0)}',
                                  'currency': '₴',
                                }),
                                style: AppTypography.caption(context),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle, color: AppColors.goalB),
                          tooltip: t('joint_detail_add_tooltip'),
                          onPressed: () {
                            _showAddContributionDialog(context, ref, goalId, m.id, m.memberName);
                          },
                        )
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.goalB)),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showAddContributionDialog(BuildContext context, WidgetRef ref, String goalId, String memberId, String memberName) {
    final _controller = TextEditingController();
    final brightness = Theme.of(context).brightness;
    
    showDialog(
      context: context,
      builder: (ctx) {
        final container = ProviderScope.containerOf(ctx);
        final locale = container.read(localeProvider);
        String t(String key) => AppLocalizations.get(locale, key);

        return AlertDialog(
          backgroundColor: AppColors.surface(brightness),
          title: Text(
            AppLocalizations.format(locale, 'joint_detail_dialog_title', {'name': memberName}),
            style: TextStyle(color: AppColors.textPrimary(brightness)),
          ),
          content: TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(color: AppColors.textPrimary(brightness)),
            decoration: InputDecoration(
              labelText: t('joint_detail_dialog_amount'),
              labelStyle: TextStyle(color: AppColors.textSecondary(brightness)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border(brightness))),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.goalB)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t('common_cancel'), style: TextStyle(color: AppColors.textSecondary(brightness))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.goalB),
              onPressed: () async {
                final amount = double.tryParse(_controller.text.trim()) ?? 0;
                if (amount > 0) {
                  final amountInKopecks = (amount * 100).toInt();
                  await ref.read(jointGoalsNotifierProvider.notifier).addContribution(goalId, memberId, amountInKopecks);
                  if (ctx.mounted) Navigator.pop(ctx);
                }
              },
              child: Text(t('common_add')),
            ),
          ],
        );
      }
    );
  }
}
