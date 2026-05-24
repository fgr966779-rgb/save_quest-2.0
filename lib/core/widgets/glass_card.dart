import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final Color? borderColor;
  final Color? glowColor;
  final double glowSigma;
  final Color? backgroundColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Gradient? gradient;

  /// When true (default) the card runs a slow breathing glow / shimmer so it
  /// never feels static. Set to false in places where a still card is needed
  /// (e.g. inside dialogs).
  final bool animated;

  const GlassCard({
    Key? key,
    required this.child,
    this.borderRadius = 16.0,
    this.blur = 15.0,
    this.borderColor,
    this.glowColor,
    this.glowSigma = 12.0,
    this.backgroundColor,
    this.borderWidth = 1.0,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.gradient,
    this.animated = true,
  }) : super(key: key);

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> with TickerProviderStateMixin {
  late final AnimationController _breath;
  late final AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _breath = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    );
    if (widget.animated) {
      _breath.repeat(reverse: true);
      _shimmer.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant GlassCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animated != oldWidget.animated) {
      if (widget.animated) {
        _breath.repeat(reverse: true);
        _shimmer.repeat();
      } else {
        _breath.stop();
        _shimmer.stop();
      }
    }
  }

  @override
  void dispose() {
    _breath.dispose();
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final finalBgColor = widget.backgroundColor ?? AppColors.cardBg.withOpacity(0.65);
    final finalBorderColor = widget.borderColor ?? AppColors.borderNeon;
    final hasExternalGlow = widget.glowColor != null && widget.glowSigma > 0;

    return AnimatedBuilder(
      animation: Listenable.merge([_breath, _shimmer]),
      builder: (context, _) {
        final breath = widget.animated ? _breath.value : 0.5;
        final glowOpacity = hasExternalGlow ? (0.18 + 0.22 * breath) : 0.0;

        return Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: hasExternalGlow
                ? [
                    BoxShadow(
                      color: widget.glowColor!.withOpacity(glowOpacity),
                      blurRadius: widget.glowSigma + 4.0 * breath,
                      spreadRadius: 1.0,
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.gradient == null ? finalBgColor : null,
                  gradient: widget.gradient,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(
                    color: finalBorderColor,
                    width: widget.borderWidth,
                  ),
                ),
                child: Stack(
                  children: [
                    // Slow horizontal shimmer sweep behind the content
                    if (widget.animated)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: LayoutBuilder(
                            builder: (context, c) {
                              final w = c.maxWidth.isFinite ? c.maxWidth : 320.0;
                              return Transform.translate(
                                offset: Offset((_shimmer.value * 2.0 - 0.5) * w, 0),
                                child: FractionallySizedBox(
                                  widthFactor: 0.45,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.white.withOpacity(0.025),
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
                          ),
                        ),
                      ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Subtle inner highlight — thin white line at top
                        Container(
                          height: 1.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(widget.borderRadius),
                              topRight: Radius.circular(widget.borderRadius),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.08 + 0.06 * breath),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Padding(
                            padding: widget.padding ?? const EdgeInsets.all(16.0),
                            child: widget.child,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
