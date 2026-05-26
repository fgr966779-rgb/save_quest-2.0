import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../theme/app_theme.dart';
import 'app_button.dart';

/// Clean empty state widget with icon, title, description, and action button.
class EmptyState extends StatelessWidget {
  /// Icon widget displayed at the top (typically an Icon or IconData).
  final Widget icon;

  /// Title text shown below the icon.
  final String title;

  /// Description text shown below the title.
  final String description;

  /// Label for the optional action button.
  final String? actionLabel;

  /// Callback for the action button.
  final VoidCallback? onPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceXxxl,
          vertical: AppTheme.spaceHuge,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Large icon
            _buildIcon(context),
            const SizedBox(height: AppTheme.spaceXxl),
            // Title
            Text(
              title,
              style: AppTypography.h3(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spaceSm),
            // Description
            Text(
              description,
              style: AppTypography.bodySmall(context),
              textAlign: TextAlign.center,
            ),
            // Action button
            if (actionLabel != null && onPressed != null) ...[
              const SizedBox(height: AppTheme.spaceXxl),
              SizedBox(
                width: 200,
                child: AppButton(
                  label: actionLabel!,
                  onPressed: onPressed,
                  variant: ButtonVariant.primary,
                  fullWidth: true,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final iconColor = AppColors.textSecondary(brightness);

    if (icon is Icon) {
      return IconTheme(
        data: IconThemeData(
          size: 48,
          color: iconColor,
        ),
        child: icon,
      );
    }

    // If it's a raw IconData, wrap it
    return Icon(
      icon as IconData,
      size: 48,
      color: iconColor,
    );
  }
}
