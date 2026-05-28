import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Clean minimal card widget. No animation, no blur, no shimmer, no glow.
/// Replaces the old GlassCard with a simple Container + border approach.
class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? color;
  final Color? borderColor;

  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bgColor = color ?? AppColors.surface(brightness);
    final effectiveBorderColor = borderColor ?? AppColors.border(brightness);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
