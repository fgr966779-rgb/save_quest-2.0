import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/surface_card.dart';
import '../models/leaderboard_model.dart';

class LeaderboardTile extends StatelessWidget {
  final LeaderboardEntry entry;
  final int position;

  const LeaderboardTile({super.key, required this.entry, required this.position});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    Color positionColor;
    if (position == 1) {
      positionColor = AppColors.warning;
    } else if (position == 2) {
      positionColor = AppColors.textSecondary(brightness);
    } else if (position == 3) {
      positionColor = AppColors.textTertiary(brightness);
    } else {
      positionColor = AppColors.textTertiary(brightness);
    }

    return SurfaceCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      borderRadius: 12,
      color: entry.isCurrentUser
          ? AppColors.accentMutedBg(brightness)
          : AppColors.surfaceMuted(brightness),
      child: Row(
        children: [
          // Position
          SizedBox(
            width: 30,
            child: Text(
              '#$position',
              style: AppTypography.h3(
                context,
                color: positionColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Avatar placeholder
          CircleAvatar(
            backgroundColor: AppColors.surfaceMuted(brightness),
            radius: 20,
            child: Icon(
              Icons.person,
              color: position <= 3 ? positionColor : AppColors.accent,
            ),
          ),
          const SizedBox(width: 12),
          // Name and Level
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.displayName,
                  style: AppTypography.h3(
                    context,
                    color: entry.isCurrentUser
                        ? AppColors.accent
                        : AppColors.textPrimary(brightness),
                  ),
                ),
                Text(
                  'LVL ${entry.level}',
                  style: AppTypography.caption(context),
                ),
              ],
            ),
          ),
          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.score}',
                style: AppTypography.h2(
                  context,
                  color: position <= 3
                      ? positionColor
                      : AppColors.textPrimary(brightness),
                ),
              ),
              Text(
                'XP',
                style: AppTypography.overline(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AllianceLeaderboardTile extends StatelessWidget {
  final AllianceEntry entry;
  final int position;

  const AllianceLeaderboardTile(
      {super.key, required this.entry, required this.position});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    Color positionColor;
    if (position == 1) {
      positionColor = AppColors.warning;
    } else if (position == 2) {
      positionColor = AppColors.textSecondary(brightness);
    } else if (position == 3) {
      positionColor = AppColors.textTertiary(brightness);
    } else {
      positionColor = AppColors.textTertiary(brightness);
    }

    return SurfaceCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      borderRadius: 12,
      color: entry.isUserAlliance
          ? AppColors.accentMutedBg(brightness)
          : AppColors.surfaceMuted(brightness),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              '#$position',
              style: AppTypography.h3(
                context,
                color: positionColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: AppColors.surfaceMuted(brightness),
            radius: 20,
            child: Icon(
              Icons.group,
              color: position <= 3 ? positionColor : AppColors.accent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: AppTypography.h3(
                    context,
                    color: entry.isUserAlliance
                        ? AppColors.accent
                        : AppColors.textPrimary(brightness),
                  ),
                ),
                Text(
                  '${entry.membersCount} members',
                  style: AppTypography.caption(context),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.totalScore}',
                style: AppTypography.h2(
                  context,
                  color: position <= 3
                      ? positionColor
                      : AppColors.textPrimary(brightness),
                ),
              ),
              Text(
                'PTS',
                style: AppTypography.overline(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
