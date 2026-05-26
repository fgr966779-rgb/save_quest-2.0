import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../theme/app_theme.dart';
import 'cipher_text.dart';
import 'progress_bar.dart';
import 'surface_card.dart';

/// Clean minimal goal card. No breathing animation, no shimmer, no glow, no BackdropFilter.
/// Replaces SavingGoalCard.
class GoalCard extends StatefulWidget {
  final String title;
  final double currentAmount;
  final double targetAmount;
  final String currency;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;
  final String heroTag;
  final bool isCiphered;
  final bool isLocked;

  const GoalCard({
    super.key,
    required this.title,
    required this.currentAmount,
    required this.targetAmount,
    required this.currency,
    required this.icon,
    required this.accentColor,
    required this.onTap,
    required this.heroTag,
    this.isCiphered = false,
    this.isLocked = false,
  });

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final progress = widget.targetAmount > 0
        ? (widget.currentAmount / widget.targetAmount).clamp(0.0, 1.0)
        : 0.0;
    final percentage = (progress * 100).toInt();

    return GestureDetector(
      onTapDown: widget.isLocked
          ? null
          : (_) {
              setState(() => _scale = 0.97);
              HapticFeedback.lightImpact();
            },
      onTapUp: widget.isLocked
          ? null
          : (_) {
              setState(() => _scale = 1.0);
              widget.onTap();
            },
      onTapCancel: () {
        setState(() => _scale = 1.0);
      },
      child: AnimatedScale(
        scale: _scale,
        duration: AppTheme.animFast,
        curve: AppTheme.animCurve,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                border: Border(
                  left: BorderSide(
                    color: widget.isLocked
                        ? AppColors.border(brightness)
                        : widget.accentColor,
                    width: 3,
                  ),
                ),
              ),
              child: SurfaceCard(
            padding: const EdgeInsets.all(16),
            borderRadius: AppTheme.radiusLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Icon + Title + Percentage badge
                Row(
                  children: [
                    // Icon in subtle circle
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Hero(
                        tag: widget.heroTag,
                        child: Icon(
                          widget.icon,
                          color: widget.accentColor,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spaceMd),
                    // Title
                    Expanded(
                      child: Text(
                        widget.title,
                        style: AppTypography.h3(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Percentage badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: Text(
                        '$percentage%',
                        style: AppTypography.caption(
                          context,
                          color: widget.accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceLg),
                // Amounts row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Накоплено
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Накоплено',
                          style: AppTypography.overline(context),
                        ),
                        const SizedBox(height: 2),
                        CipherText(
                          text:
                              '${widget.currentAmount.toStringAsFixed(0)} ${widget.currency}',
                          isCiphered: widget.isCiphered,
                          style: AppTypography.amount(context),
                        ),
                      ],
                    ),
                    // Мішень
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Мішень',
                          style: AppTypography.overline(context),
                        ),
                        const SizedBox(height: 2),
                        CipherText(
                          text:
                              '${widget.targetAmount.toStringAsFixed(0)} ${widget.currency}',
                          isCiphered: widget.isCiphered,
                          style: AppTypography.amount(context),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceLg),
                // Progress bar
                ProgressBar(
                  progress: progress,
                  color: widget.accentColor,
                  height: 6,
                ),
              ],
            ),
          ),
        ),
            // Lock overlay
            if (widget.isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background(brightness).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_rounded,
                          size: 28,
                          color: AppColors.textTertiary(brightness),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Locked',
                          style: AppTypography.caption(
                            context,
                            color: AppColors.textTertiary(brightness),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
