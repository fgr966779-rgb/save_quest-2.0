import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class NeonButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color baseColor;
  final Color glowColor;
  final bool isLoading;
  final Widget? icon;
  final double width;
  final double height;

  const NeonButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.baseColor = AppColors.cyanAccent,
    this.glowColor = AppColors.cyanAccent,
    this.isLoading = false,
    this.icon,
    this.width = double.infinity,
    this.height = 56.0,
  }) : super(key: key);

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (widget.onPressed != null && !widget.isLoading) {
      _scaleController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onPressed != null && !widget.isLoading) {
      _scaleController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: () {
        if (!isDisabled) {
          widget.onPressed!();
        }
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            gradient: isDisabled
                ? const LinearGradient(
                    colors: [AppColors.cardBgLight, AppColors.cardBgLight],
                  )
                : LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.15),
                      widget.baseColor,
                      widget.baseColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 0.3, 1.0],
                  ),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: widget.glowColor.withOpacity(0.4),
                      blurRadius: 14.0,
                      spreadRadius: 1.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
            border: Border.all(
              color: isDisabled
                  ? AppColors.borderNeon.withOpacity(0.3)
                  : widget.glowColor.withOpacity(0.6),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: Stack(
              children: [
                // Shimmer overlay — uses LayoutBuilder to avoid double.infinity offsets
                if (!isDisabled)
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final actualWidth = constraints.maxWidth.isFinite
                            ? constraints.maxWidth
                            : 300.0;
                        return AnimatedBuilder(
                          animation: _shimmerAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                _shimmerAnimation.value * actualWidth,
                                0,
                              ),
                              child: FractionallySizedBox(
                                widthFactor: 0.35,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.white.withOpacity(0.18),
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                // Button content
                Center(
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              widget.icon!,
                              const SizedBox(width: 8.0),
                            ],
                            Text(
                              widget.text.toUpperCase(),
                              style: AppTextStyles.orbitronHeading(
                                fontSize: 15.0,
                                color: isDisabled ? AppColors.textMuted : Colors.black,
                                fontWeight: FontWeight.w900,
                              ).copyWith(
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
