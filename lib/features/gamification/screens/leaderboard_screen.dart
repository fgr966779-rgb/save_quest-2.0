import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';
import '../providers/leaderboard_provider.dart';
import '../widgets/leaderboard_tile.dart';
import '../models/leaderboard_model.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);
    String t(String key) => AppLocalizations.get(locale, key);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        title: Text(
          t('lb_title'),
          style: AppTypography.h2(context, color: AppColors.warning),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary(brightness)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.textSecondary(brightness),
          indicatorColor: AppColors.accent,
          tabs: [
            Tab(text: t('lb_weekly')),
            Tab(text: t('lb_monthly')),
            Tab(text: t('lb_alliance')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _WeeklyTab(t: t, brightness: brightness),
          _MonthlyTab(t: t, brightness: brightness),
          _AllianceTab(t: t, brightness: brightness),
        ],
      ),
    );
  }
}

class _WeeklyTab extends ConsumerWidget {
  final String Function(String) t;
  final Brightness brightness;
  const _WeeklyTab({required this.t, required this.brightness});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyAsync = ref.watch(weeklyLeaderboardProvider);

    return weeklyAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (entries) => _buildList(context, ref, entries),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List<LeaderboardEntry> entries) {
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(weeklyLeaderboardProvider),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: entries.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildShareBanner(context, ref, entries);
          }
          return LeaderboardTile(
            entry: entries[index - 1],
            position: index,
          );
        },
      ),
    );
  }

  Widget _buildShareBanner(BuildContext context, WidgetRef ref, List<LeaderboardEntry> entries) {
    final currentUserEntries = entries.where((e) => e.isCurrentUser).toList();
    final userEntry = currentUserEntries.isNotEmpty ? currentUserEntries.first : null;
    if (userEntry == null) return const SizedBox.shrink();

    final position = entries.indexOf(userEntry) + 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SurfaceCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#$position',
                    style: AppTypography.h1(context, color: AppColors.accent),
                  ),
                  Text(
                    '\$1 XP',
                    style: AppTypography.body(context),
                  ),
                ],
              ),
            ),
            AppButton(
              label: t('lb_share'),
              onPressed: () {
                HapticFeedback.lightImpact();
                Share.share(
                  t('lb_share_text')
                      .replaceAll('{position}', '$position')
                      .replaceAll('{score}', '\$1'),
                );
              },
              variant: ButtonVariant.secondary,
              icon: const Icon(Icons.share, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthlyTab extends ConsumerWidget {
  final String Function(String) t;
  final Brightness brightness;
  const _MonthlyTab({required this.t, required this.brightness});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyAsync = ref.watch(monthlyLeaderboardProvider);

    return monthlyAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (entries) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(monthlyLeaderboardProvider),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 80),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            return LeaderboardTile(
              entry: entries[index],
              position: index + 1,
            );
          },
        ),
      ),
    );
  }
}

class _AllianceTab extends ConsumerWidget {
  final String Function(String) t;
  final Brightness brightness;
  const _AllianceTab({required this.t, required this.brightness});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allianceAsync = ref.watch(allianceLeaderboardProvider);

    return allianceAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (entries) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(allianceLeaderboardProvider),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 80),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            return AllianceLeaderboardTile(
              entry: entries[index],
              position: index + 1,
            );
          },
        ),
      ),
    );
  }
}
