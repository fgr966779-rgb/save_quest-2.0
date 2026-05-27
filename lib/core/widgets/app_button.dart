import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Button variant for AppButton.
enum ButtonVariant { primary, secondary, ghost }

/// Clean minimal button. Three variants, no glow, no shimmer, no gradient.
/// Replaces NeonButton.
class AppButton extends StatefulWidget {
  /// Display label for the button.
  final String label;

  /// Callback when pressed.
  final VoidCallback? onPressed;

  /// Visual variant: primary (filled), secondary (outlined), ghost (text only).
  final ButtonVariant variant;

  /// Shows a loading indicator and disables interaction when true.
  final bool isLoading;

  /// Optional icon widget placed before the label.
  final Widget? icon;

  /// Whether the button should expand to fill available width.
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isDisabled => widget.onPressed == null || widget.isLoading;

  void _handleTapDown(TapDownDetails _) {
    if (!_isDisabled) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails _) {
    if (!_isDisabled) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (!_isDisabled) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    // Determine colors based on variant
    final Color bgColor;
    final Color textColor;
    final Color? borderColor;

    switch (widget.variant) {
      case ButtonVariant.primary:
        bgColor = _isDisabled
            ? AppColors.border(brightness)
            : AppColors.accent;
        textColor = Colors.white;
        borderColor = null;
        break;
      case ButtonVariant.secondary:
        bgColor = Colors.transparent;
        textColor = _isDisabled
            ? AppColors.textDisabled(brightness)
            : AppColors.accent;
        borderColor = _isDisabled
            ? AppColors.border(brightness)
            : AppColors.accent;
        break;
      case ButtonVariant.ghost:
        bgColor = Colors.transparent;
        textColor = _isDisabled
            ? AppColors.textDisabled(brightness)
            : AppColors.accent;
        borderColor = null;
        break;
    }

    // Disabled opacity for ghost/secondary
    final double effectiveOpacity = _isDisabled ? 0.5 : 1.0;

    Widget buttonChild = widget.isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: widget.variant == ButtonVariant.primary
                  ? Colors.white
                  : AppColors.accent,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: AppTypography.button(
                  context,
                  color: textColor,
                ),
              ),
            ],
          );

    Widget button = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: () {
        if (!_isDisabled) {
          widget.onPressed!();
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          height: 48,
          constraints: widget.fullWidth
              ? const BoxConstraints.expand(height: 48)
              : null,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: bgColor.withValues(alpha: effectiveOpacity),
            borderRadius: BorderRadius.circular(12),
            border: borderColor != null
                ? Border.all(color: borderColor, width: 1)
                : null,
          ),
          child: Center(child: buttonChild),
        ),
      ),
    );

    if (!widget.fullWidth) {
      return IntrinsicWidth(child: button);
    }

    return button;
  }
}
