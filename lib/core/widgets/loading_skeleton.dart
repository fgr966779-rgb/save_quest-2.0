import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'surface_card.dart';

/// A single skeleton line placeholder with a subtle shimmer animation.
class SkeletonLine extends StatefulWidget {
  /// Width of the line. Null means fill available width.
  final double? width;

  /// Height of the line. Defaults to 16.
  final double height;

  /// Border radius. Defaults to 8.
  final double borderRadius;

  const SkeletonLine({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  State<SkeletonLine> createState() => _SkeletonLineState();
}

class _SkeletonLineState extends State<SkeletonLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Shimmer shift from -1 to 2 across the line
        final shimmerValue = _controller.value * 3.0 - 1.0;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted(brightness),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Stack(
            children: [
              // Subtle shimmer highlight
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Align(
                    alignment: Alignment(shimmerValue, 0),
                    child: FractionallySizedBox(
                      widthFactor: 0.4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.border(brightness).withValues(alpha: 0.5),
                        ),
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
  }
}

/// A card-shaped skeleton placeholder containing several SkeletonLines.
class SkeletonCard extends StatelessWidget {
  /// Number of lines to show. Defaults to 4.
  final int lineCount;

  const SkeletonCard({
    super.key,
    this.lineCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First line: wider (simulating a title)
          const SkeletonLine(
            height: 18,
            borderRadius: 6,
            width: 140,
          ),
          const SizedBox(height: 12),
          // Middle lines
          for (int i = 1; i < lineCount - 1; i++) ...[
            SkeletonLine(
              height: 14,
              borderRadius: 6,
              width: i.isEven ? null : double.infinity,
            ),
            const SizedBox(height: 10),
          ],
          // Last line: shorter (simulating a trailing element)
          if (lineCount > 1)
            const SkeletonLine(
              height: 14,
              borderRadius: 6,
              width: 200,
            ),
        ],
      ),
    );
  }
}

/// A vertical list of SkeletonCards for loading state.
class SkeletonList extends StatelessWidget {
  /// Number of skeleton cards to display.
  final int itemCount;

  const SkeletonList({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (_) => const SkeletonCard(),
      ),
    );
  }
}
