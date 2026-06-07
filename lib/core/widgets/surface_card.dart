import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../constants/app_colors.dart';

/// Premium glassmorphic card widget. Features frosted backdrop blur,
/// elegant semi-transparent borders, and soft glowing shadows that create a modern 3D depth.
class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? color;
  final Color? borderColor;
  final bool enableBlur;

  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16,
    this.color,
    this.borderColor,
    this.enableBlur = true,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    
    // Curated high-fidelity glass transparency
    final bgColor = color ?? (isDark 
        ? Colors.white.withValues(alpha: 0.035) 
        : Colors.white.withValues(alpha: 0.65));
        
    final effectiveBorderColor = borderColor ?? (isDark 
        ? Colors.white.withValues(alpha: 0.08) 
        : Colors.black.withValues(alpha: 0.065));

    final cardContent = Padding(
      padding: padding,
      child: child,
    );

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          // Soft ambient occlusion shadow
          BoxShadow(
            color: isDark 
                ? Colors.black.withValues(alpha: 0.35) 
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          // Subtle neon light leakage in dark mode
          if (isDark)
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.025),
              blurRadius: 30,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: enableBlur
            ? BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      color: effectiveBorderColor,
                      width: 1.2,
                    ),
                  ),
                  child: cardContent,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: effectiveBorderColor,
                    width: 1.2,
                  ),
                ),
                child: cardContent,
              ),
      ),
    );
  }
}

