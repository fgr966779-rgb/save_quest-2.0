import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// CyberSwipeSlider is a high-fidelity cyberpunk slider-confirmation widget.
/// Used for triggering critical game mechanics, locks, and premium transactions.
/// Features glassmorphism, animated neon track states, custom particles and physical tactile response.
class CyberSwipeSlider extends StatefulWidget {
  final String text;
  final VoidCallback onConfirm;
  final bool isLoading;

  const CyberSwipeSlider({
    super.key,
    required this.text,
    required this.onConfirm,
    this.isLoading = false,
  });

  @override
  State<CyberSwipeSlider> createState() => _CyberSwipeSliderState();
}

class _CyberSwipeSliderState extends State<CyberSwipeSlider>
    with SingleTickerProviderStateMixin {
  double _dragValue = 0.0;
  bool _isFinished = false;

  late final AnimationController _resetController;
  late final Animation<double> _resetAnimation;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _resetAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CyberSwipeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading && !widget.isLoading && _isFinished) {
      // Completed, reset state if loading finished
      setState(() {
        _isFinished = false;
        _dragValue = 0.0;
      });
    }
  }

  void _onDragUpdate(DragUpdateDetails details, double maxWidth) {
    if (_isFinished || widget.isLoading) return;
    
    final finalWidth = maxWidth - 56.0; // Subtract drag handle diameter
    if (finalWidth <= 0) return;

    setState(() {
      _dragValue = (_dragValue + details.primaryDelta! / finalWidth).clamp(0.0, 1.0);
    });

    // Sub-tactile ticking while sliding
    if (_dragValue > 0.1 && _dragValue < 0.9 && details.primaryDelta!.abs() > 0.5) {
      HapticFeedback.selectionClick();
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isFinished || widget.isLoading) return;

    if (_dragValue >= 0.92) {
      // Trigger confirmation
      HapticFeedback.heavyImpact();
      setState(() {
        _isFinished = true;
        _dragValue = 1.0;
      });
      widget.onConfirm();
    } else {
      // Elastic snap-back
      HapticFeedback.lightImpact();
      _resetAnimation = Tween<double>(begin: _dragValue, end: 0.0).animate(
        CurvedAnimation(parent: _resetController, curve: Curves.easeOutBack),
      );
      _resetController.forward(from: 0.0).then((_) {
        setState(() {
          _dragValue = 0.0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _resetController,
      builder: (context, child) {
        final currentDrag = _resetController.isAnimating ? _resetAnimation.value : _dragValue;

        return LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final double handleSize = 48.0;
            final double usableWidth = width - handleSize - 8.0; // padding accounted
            final double leftOffset = currentDrag * usableWidth + 4.0;

            return Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.black.withValues(alpha: 0.03),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.08),
                  width: 1.2,
                ),
                boxShadow: [
                  if (isDark)
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: currentDrag * 0.08),
                      blurRadius: 20,
                      spreadRadius: -2,
                    )
                ],
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Gradient Track Progress Fill
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      width: leftOffset + handleSize / 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accent.withValues(alpha: 0.15),
                            AppColors.legendary.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Static Centered Lock / Unlock text
                  Center(
                    child: Opacity(
                      opacity: (1.0 - currentDrag * 1.5).clamp(0.0, 1.0),
                      child: Text(
                        widget.text,
                        style: AppTypography.button(
                          context,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  // Draggable Neon Handle
                  Positioned(
                    left: leftOffset,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (d) => _onDragUpdate(d, width),
                      onHorizontalDragEnd: _onDragEnd,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: handleSize,
                        height: handleSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: widget.isLoading
                                ? [Colors.grey.shade600, Colors.grey.shade400]
                                : [AppColors.accent, AppColors.legendary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.4 + currentDrag * 0.4),
                              blurRadius: 12 + currentDrag * 8,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: widget.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  _isFinished ? Icons.lock_open_rounded : Icons.lock_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
