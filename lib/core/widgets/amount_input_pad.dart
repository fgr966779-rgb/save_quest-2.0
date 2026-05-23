import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AmountInputPad extends StatelessWidget {
  final Function(String) onKeyPressed;

  const AmountInputPad({
    Key? key,
    required this.onKeyPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRow(['1', '2', '3']),
                const SizedBox(height: 12.0),
                _buildRow(['4', '5', '6']),
                const SizedBox(height: 12.0),
                _buildRow(['7', '8', '9']),
                const SizedBox(height: 12.0),
                _buildRow(['.', '0', '⌫']),
              ],
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildColumnItem('🎲'),
                const SizedBox(height: 12.0),
                _buildColumnItem('+'),
                const SizedBox(height: 12.0),
                _buildColumnItem('-'),
                const SizedBox(height: 12.0),
                _buildColumnItem('='),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: _InputKey(
              label: key,
              onTap: () => onKeyPressed(key),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColumnItem(String key) {
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
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_InputKey> createState() => _InputKeyState();
}

class _InputKeyState extends State<_InputKey> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSpecial = widget.label == '.' || widget.label == '⌫';

    return GestureDetector(
      onTapDown: (_) {
        _animController.forward();
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        _animController.reverse();
      },
      onTapCancel: () {
        _animController.reverse();
      },
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          height: 60.0,
          decoration: BoxDecoration(
            color: isSpecial ? Colors.white.withOpacity(0.02) : AppColors.cardBgLight,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isSpecial ? AppColors.borderNeon.withOpacity(0.2) : AppColors.borderNeon,
              width: 1.0,
            ),
          ),
          child: Center(
            child: widget.label == '⌫'
                ? const Icon(
                    Icons.backspace_outlined,
                    color: AppColors.cyanAccent,
                    size: 20.0,
                  )
                : Text(
                    widget.label,
                    style: AppTextStyles.orbitronHeading(
                      fontSize: 22.0,
                      color: isSpecial ? AppColors.cyanAccent : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
