import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/haptics_helper.dart';
import '../../../core/services/gamification/xp_service.dart';

class ZenBreatheDialog extends ConsumerStatefulWidget {
  const ZenBreatheDialog({super.key});

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return const ZenBreatheDialog();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  ConsumerState<ZenBreatheDialog> createState() => _ZenBreatheDialogState();
}

class _ZenBreatheDialogState extends ConsumerState<ZenBreatheDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late ConfettiController _confettiController;

  int _completedCycles = 0;
  bool _isFinished = false;
  bool _isSaving = false;
  String _currentPhaseText = 'Приготуйтеся...'; // Inhale, hold, exhale localized Ukrainian

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    // Breathing Controller: 4 seconds for complete animation direction
    // (forward = 4s inhale, reverse = 4s exhale)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.35).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.15, end: 0.7).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );

    _animationController.addStatusListener((status) {
      if (_isFinished) return;

      if (status == AnimationStatus.completed) {
        // Peak of Inhalation -> Transition to Exhalation
        HapticsHelper.heartbeat();
        setState(() {
          _currentPhaseText = 'Видих...';
        });
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // End of Exhalation -> Transition to Inhalation
        HapticsHelper.heartbeat();
        setState(() {
          _completedCycles++;
          if (_completedCycles >= 4) {
            _finishMeditation();
          } else {
            _currentPhaseText = 'Вдих...';
            _animationController.forward();
          }
        });
      }
    });

    // Start meditation after a short intro delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _currentPhaseText = 'Вдих...';
        });
        HapticsHelper.heartbeat();
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _finishMeditation() async {
    setState(() {
      _isFinished = true;
      _currentPhaseText = 'Дихання завершено!';
    });
    _animationController.stop();
    _confettiController.play();
    HapticFeedback.heavyImpact();

    // Persist Rewards and Early Release
    setState(() => _isSaving = true);
    try {
      final db = ref.read(databaseProvider);
      final settings = ref.read(settingsServiceProvider);
      final profile = await db.getUserProfile();

      if (profile != null) {
        // Calculate Level-up with +50 XP
        var newXP = profile.xp + 50;
        var currentLevel = profile.level;

        while (newXP >= XpService.xpRequiredForLevel(currentLevel)) {
          currentLevel++;
        }

        final levelUps = currentLevel - profile.level;
        final newSkillPoints = profile.skillPoints + levelUps;

        // Write Crystals (+25) and XP (+50) and SP updates to DB
        await db.updateUserProfile(profile.copyWith(
          xp: newXP,
          level: currentLevel,
          skillPoints: newSkillPoints,
          crystalsBalance: profile.crystalsBalance + 25,
        ));

        // Shorten active Dopamine Detox countdown by 2 hours in Hive Settings box
        final currentDetoxUntil = settings.dopamineDetoxUntil;
        final reducedDetoxUntil =
            currentDetoxUntil - const Duration(hours: 2).inMilliseconds;
        settings.dopamineDetoxUntil = math.max(0, reducedDetoxUntil);

        // Invalidate providers to force UI updates immediately
        ref.invalidate(userProfileProvider);
        ref.invalidate(settingsServiceProvider);
      }
    } catch (e) {
      // Handle silently
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Glassmorphic Backdrop blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                color: Colors.black.withValues(alpha: 0.75),
              ),
            ),
          ),

          // Confetti explosion
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.06,
              numberOfParticles: 28,
              gravity: 0.15,
              colors: const [
                AppColors.accent,
                AppColors.accentLight,
                AppColors.success,
              ],
            ),
          ),

          // Main Focus Chamber Panel
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SurfaceCard(
                padding: const EdgeInsets.all(28.0),
                borderRadius: 24.0,
                borderColor: AppColors.accent.withValues(alpha: 0.25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // futuristic header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.radar_rounded,
                          color: AppColors.accent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'КАМЕРА КІБЕР-МЕДИТАЦІЇ',
                          style: AppTypography.overline(
                            context,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    if (!_isFinished) ...[
                      // Breathing Phase Prompt Text
                      Text(
                        _currentPhaseText.toUpperCase(),
                        style: AppTypography.h2(
                          context,
                          color: AppColors.accent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      // Pulsing Reactor Circle Widget
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          final scale = _scaleAnimation.value;
                          final glowVal = _glowAnimation.value;

                          return Container(
                            width: 130 * scale,
                            height: 130 * scale,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.accent.withValues(alpha: 0.8),
                                  AppColors.accent.withValues(alpha: 0.2),
                                  Colors.transparent,
                                ],
                                stops: const [0.1, 0.7, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: glowVal),
                                  blurRadius: 36 * scale,
                                  spreadRadius: 8 * scale,
                                ),
                              ],
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: glowVal + 0.2),
                                width: 2.0,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 48),

                      // Cycle progress nodes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          final isCompleted = index < _completedCycles;
                          final isCurrent = index == _completedCycles;

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6.0),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCompleted
                                  ? AppColors.accent
                                  : (isCurrent
                                      ? AppColors.accent.withValues(alpha: 0.4)
                                      : Colors.transparent),
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.6),
                                width: 1.5,
                              ),
                              boxShadow: isCompleted || isCurrent
                                  ? [
                                      BoxShadow(
                                        color: AppColors.accent.withValues(alpha: 0.5),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      )
                                    ]
                                  : null,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 36),

                      // Exit button with warning
                      AppButton(
                        label: 'ПЕРЕРВАТИ СЕАНС',
                        variant: ButtonVariant.ghost,
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                      ),
                    ] else ...[
                      // Success completion summary view
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.success,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'ДИСЦИПЛІНА ЗМІЦНЕНА!',
                        style: AppTypography.h2(
                          context,
                          color: AppColors.success,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ваш розум очищено від імпульсних тригерів.',
                        style: AppTypography.bodySmall(
                          context,
                          color: AppColors.textSecondary(brightness),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Rewards display card
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted(brightness),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: AppColors.border(brightness),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildRewardRow(
                              context,
                              icon: Icons.diamond_rounded,
                              label: '+25 Кристалів',
                              color: AppColors.accent,
                            ),
                            const Divider(height: 16, thickness: 0.5),
                            _buildRewardRow(
                              context,
                              icon: Icons.bolt_rounded,
                              label: '+50 XP Досвіду',
                              color: AppColors.warning,
                            ),
                            const Divider(height: 16, thickness: 0.5),
                            _buildRewardRow(
                              context,
                              icon: Icons.hourglass_bottom_rounded,
                              label: '-2 Години Детоксу',
                              color: AppColors.success,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      AppButton(
                        label: 'ПОВЕРНУТИСЬ В СИСТЕМУ',
                        variant: ButtonVariant.primary,
                        isLoading: _isSaving,
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTypography.body(context),
        ),
      ],
    );
  }
}
