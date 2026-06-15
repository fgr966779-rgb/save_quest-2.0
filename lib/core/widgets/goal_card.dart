import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'cipher_text.dart';
import 'surface_card.dart';
import '../../features/gamification/widgets/boss_hp_bar.dart';


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
  final String? secondaryActionLabel;
  final IconData? secondaryActionIcon;
  /// Called when the secondary action button is pressed.
  /// The button shows a spinner and blocks re-taps while [secondaryActionLoading] is true.
  final VoidCallback? secondaryActionOnPressed;
  /// When true, shows a loading spinner instead of the icon on the secondary action button.
  final bool secondaryActionLoading;

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
    this.secondaryActionLabel,
    this.secondaryActionIcon,
    this.secondaryActionOnPressed,
    this.secondaryActionLoading = false,
  });

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard>
    with SingleTickerProviderStateMixin {
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
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.accentColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.accentColor.withValues(alpha: 0.25),
                              width: 1.5,
                            ),
                          ),
                          child: Hero(
                            tag: widget.heroTag,
                            child: Icon(
                              widget.icon,
                              color: widget.accentColor,
                              size: 22,
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
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.accentColor.withValues(alpha: 0.2),
                                widget.accentColor.withValues(alpha: 0.08),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                            border: Border.all(
                              color: widget.accentColor.withValues(alpha: 0.25),
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            '$percentage%',
                            style: AppTypography.caption(
                              context,
                              color: widget.accentColor,
                            ).copyWith(
                              fontWeight: FontWeight.w600,
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
                                  '${widget.currentAmount.toStringAsFixed(0)} ₴',
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
                                  '${widget.targetAmount.toStringAsFixed(0)} ₴',
                              isCiphered: widget.isCiphered,
                              style: AppTypography.amount(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spaceLg),
                    // Boss HP bar instead of progress bar
                    BossHpBar(
                      goalName: widget.title,
                      currentAmount: widget.currentAmount,
                      targetAmount: widget.targetAmount,
                      currency: widget.currency,
                      accentColor: widget.accentColor,
                    ),
                    if (widget.secondaryActionOnPressed != null &&
                        widget.secondaryActionLabel != null) ...[
                      const SizedBox(height: AppTheme.spaceMd),
                      // Use a Row so the button occupies only its natural width
                      // and sits to the right, while remaining fully tappable.
                      // Wrapped in a plain Container to guarantee hit-test is NOT
                      // absorbed by the parent GestureDetector or BackdropFilter.
                      Align(
                        alignment: Alignment.centerRight,
                        child: _ScannerButton(
                          label: widget.secondaryActionLabel!,
                          icon: widget.secondaryActionIcon ?? Icons.radar_rounded,
                          accentColor: widget.accentColor,
                          isLoading: widget.secondaryActionLoading,
                          onPressed: widget.secondaryActionOnPressed!,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Lock overlay
            if (widget.isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        AppColors.background(brightness).withValues(alpha: 0.7),
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

// ---------------------------------------------------------------------------
// _ScannerButton — isolated StatefulWidget so its tap events are NOT blocked
// by the parent GestureDetector in GoalCard. Using a dedicated Listener +
// Material + InkWell guarantees the touch event is captured at this node first.
// ---------------------------------------------------------------------------
class _ScannerButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color accentColor;
  final bool isLoading;
  final VoidCallback onPressed;

  const _ScannerButton({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  State<_ScannerButton> createState() => _ScannerButtonState();
}

class _ScannerButtonState extends State<_ScannerButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Stop the tap from bubbling up to the GoalCard GestureDetector.
      onTapDown: (d) {},
      onTapUp: (d) {},
      onTapCancel: () {},
      // Use behavior translucent so child Material InkWell also gets the event.
      behavior: HitTestBehavior.translucent,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          splashColor: widget.accentColor.withValues(alpha: 0.15),
          highlightColor: widget.accentColor.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: widget.isLoading
                      ? SizedBox(
                          key: const ValueKey('spinner'),
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: widget.accentColor,
                          ),
                        )
                      : Icon(
                          key: const ValueKey('icon'),
                          widget.icon,
                          size: 18,
                          color: widget.accentColor,
                        ),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: AppTypography.caption(
                    context,
                    color: widget.isLoading
                        ? widget.accentColor.withValues(alpha: 0.5)
                        : widget.accentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fade(duration: 150.ms);
  }
}
