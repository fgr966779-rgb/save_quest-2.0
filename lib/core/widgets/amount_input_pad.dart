import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../theme/app_theme.dart';

/// Clean calculator-style input pad. No Orbitron font, no neon colors.
/// Replaces old AmountInputPad. Same callback interface: onKeyPressed(String).
class AmountInputPad extends StatelessWidget {
  final Function(String) onKeyPressed;

  const AmountInputPad({
    super.key,
    required this.onKeyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 3-column digit grid
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRow(context, ['1', '2', '3']),
                const SizedBox(height: 12),
                _buildRow(context, ['4', '5', '6']),
                const SizedBox(height: 12),
                _buildRow(context, ['7', '8', '9']),
                const SizedBox(height: 12),
                _buildRow(context, ['.', '0', '⌫']),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Operators column
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildColumnItem(context, '🎲'),
                const SizedBox(height: 12),
                _buildColumnItem(context, '+'),
                const SizedBox(height: 12),
                _buildColumnItem(context, '-'),
                const SizedBox(height: 12),
                _buildColumnItem(context, '='),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: _InputKey(
              label: key,
              onTap: () => onKeyPressed(key),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColumnItem(BuildContext context, String key) {
    return _InputKey(
      label: key,
      onTap: () => onKeyPressed(key),
    );
  }
}

class _InputKey extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _InputKey({
    required this.label,
    required this.onTap,
  });

  @override
  State<_InputKey> createState() => _InputKeyState();
}

class _InputKeyState extends State<_InputKey> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isSpecial = widget.label == '⌫';
    final isOperator = {'🎲', '+', '-', '='}.contains(widget.label);

    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: isOperator
                ? AppColors.accent.withValues(alpha: 0.08)
                : AppColors.surfaceMuted(brightness),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: isSpecial
                  ? AppColors.border(brightness)
                  : AppColors.border(brightness).withValues(alpha: 0.6),
              width: 1,
            ),
          ),
          child: Center(
            child: widget.label == '⌫'
                ? Icon(
                    Icons.backspace_outlined,
                    color: AppColors.textSecondary(brightness),
                    size: 20,
                  )
                : Text(
                    widget.label,
                    style: isOperator
                        ? AppTypography.h3(context)
                        : AppTypography.display(
                            context,
                          ).copyWith(fontSize: 24),
                  ),
          ),
        ),
      ),
    );
  }
}
