import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/widgets/surface_card.dart';

class StreakRoomScreen extends ConsumerStatefulWidget {
  const StreakRoomScreen({super.key});

  @override
  ConsumerState<StreakRoomScreen> createState() => _StreakRoomScreenState();
}

class _StreakRoomScreenState extends ConsumerState<StreakRoomScreen> with SingleTickerProviderStateMixin {
  late AnimationController _flameAnimController;

  @override
  void initState() {
    super.initState();
    _flameAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _flameAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(userProfileProvider);
    final depositsAsync = ref.watch(depositsProvider);
    final currentLocale = ref.watch(localeProvider);
    final brightness = Theme.of(context).brightness;
    String t(String key) => AppLocalizations.get(currentLocale, key);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              t('streak_header'),
              style: AppTypography.caption(
                context,
                color: AppColors.accent,
              ).copyWith(letterSpacing: 2.0),
            ),
            Text(
              t('streak_title'),
              style: AppTypography.h2(context),
            ),
            const SizedBox(height: 20.0),

            // Streak info details & Reactive vector flame
            userProfileAsync.when(
              loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
              error: (err, _) => const SizedBox.shrink(),
              data: (profile) {
                final streak = profile?.streakCount ?? 0;
                final tokens = profile?.freezeTokens ?? 0;

                return Column(
                  children: [
                    // Vector Flame
                    SizedBox(
                      height: 220,
                      child: AnimatedBuilder(
                        animation: _flameAnimController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: ReactiveFlamePainter(
                              animationValue: _flameAnimController.value,
                              streakCount: streak,
                              brightness: brightness,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '$streak',
                                    style: AppTypography.display(context).copyWith(
                                      shadows: [
                                        BoxShadow(
                                          color: streak > 0 ? AppColors.accent : AppColors.textSecondary(brightness),
                                          blurRadius: 20.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    t('streak_days'),
                                    style: AppTypography.caption(
                                      context,
                                      color: AppColors.textSecondary(brightness),
                                    ).copyWith(letterSpacing: 1.5),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Cryogenic tokens freeze display
                    SurfaceCard(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.ac_unit_rounded, color: AppColors.accent, size: 28.0),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t('streak_tokens'),
                                  style: AppTypography.overline(
                                    context,
                                    color: AppColors.accent,
                                  ),
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  t('streak_tokens_desc'),
                                  style: AppTypography.caption(
                                    context,
                                    color: AppColors.textSecondary(brightness),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                            decoration: BoxDecoration(
                              color: AppColors.accentMutedBg(brightness),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color: AppColors.accent),
                            ),
                            child: Text(
                              '$tokens ${t('streak_tokens_btn')}',
                              style: AppTypography.caption(
                                context,
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24.0),

            // Heatmap calendar Grid (Last 70 Days saving flow)
            Text(
              t('streak_heatmap'),
              style: AppTypography.h3(context),
            ),
            const SizedBox(height: 12.0),
            depositsAsync.when(
              loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
              error: (_, __) => const SizedBox.shrink(),
              data: (deposits) {
                final Set<String> activeDates = deposits
                    .where((d) => !d.isDeleted)
                    .map((d) => DateUtils.dateOnly(d.createdAt).toString())
                    .toSet();

                return SurfaceCard(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Heatmap Grid: 7 days x 10 weeks
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                          crossAxisSpacing: 6.0,
                          mainAxisSpacing: 6.0,
                        ),
                        itemCount: 70,
                        itemBuilder: (context, index) {
                          // Date calculation: index days ago
                          final DateTime day = DateTime.now().subtract(Duration(days: 69 - index));
                          final bool hasSaved = activeDates.contains(DateUtils.dateOnly(day).toString());

                          return Container(
                            decoration: BoxDecoration(
                              color: hasSaved ? AppColors.accent : AppColors.surfaceMuted(brightness),
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: hasSaved ? AppColors.accent : AppColors.border(brightness),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(t('streak_heatmap_low'), style: AppTypography.overline(context)),
                          const SizedBox(width: 4.0),
                          Container(width: 10, height: 10, decoration: BoxDecoration(color: AppColors.surfaceMuted(brightness), borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 4.0),
                          Container(width: 10, height: 10, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 4.0),
                          Text(t('streak_heatmap_high'), style: AppTypography.overline(context)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class ReactiveFlamePainter extends CustomPainter {
  final double animationValue;
  final int streakCount;
  final Brightness brightness;

  ReactiveFlamePainter({
    required this.animationValue,
    required this.streakCount,
    required this.brightness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 20);
    final baseRadius = 50.0 + (streakCount * 2.5).clamp(0.0, 40.0);

    // Multi-layered glowing vector flame draw
    final paintFlameInner = Paint()
      ..style = PaintingStyle.fill
      ..shader = const RadialGradient(
        colors: [Colors.amber, Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: baseRadius * 0.6));

    final paintFlameOuter = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: [
          streakCount > 0 ? AppColors.accent.withValues(alpha: 0.8) : AppColors.border(brightness).withValues(alpha: 0.6),
          Colors.transparent
        ],
      ).createShader(Rect.fromCircle(center: center, radius: baseRadius));

    // Outer flame custom path waving based on animation value
    final pathOuter = Path();
    pathOuter.moveTo(center.dx - baseRadius, center.dy);

    for (double i = -baseRadius; i <= baseRadius; i += 5) {
      final dx = center.dx + i;
      final wave = sin((i / baseRadius) * pi * 2 + animationValue * pi * 2) * 8.0;
      final dy = center.dy - sqrt(max(0, baseRadius * baseRadius - i * i)) - wave;
      pathOuter.lineTo(dx, dy);
    }
    pathOuter.quadraticBezierTo(center.dx, center.dy - baseRadius * 1.5, center.dx + baseRadius, center.dy);
    pathOuter.close();

    canvas.drawPath(pathOuter, paintFlameOuter);

    // Inner core flame
    final pathInner = Path();
    pathInner.moveTo(center.dx - baseRadius * 0.5, center.dy);
    for (double i = -baseRadius * 0.5; i <= baseRadius * 0.5; i += 3) {
      final dx = center.dx + i;
      final wave = cos((i / (baseRadius * 0.5)) * pi * 2 + animationValue * pi * 2) * 5.0;
      final dy = center.dy - sqrt(max(0, (baseRadius * 0.5) * (baseRadius * 0.5) - i * i)) - wave;
      pathInner.lineTo(dx, dy);
    }
    pathInner.quadraticBezierTo(center.dx, center.dy - baseRadius * 0.9, center.dx + baseRadius * 0.5, center.dy);
    pathInner.close();

    canvas.drawPath(pathInner, paintFlameInner);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
