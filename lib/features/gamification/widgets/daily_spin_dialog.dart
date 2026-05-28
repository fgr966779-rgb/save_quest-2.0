import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';
import '../providers/quest_provider.dart';

class DailySpinDialog extends ConsumerStatefulWidget {
  const DailySpinDialog({super.key});

  @override
  ConsumerState<DailySpinDialog> createState() => _DailySpinDialogState();
}

class _DailySpinDialogState extends ConsumerState<DailySpinDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isSpinning = false;
  bool _hasSpun = false;
  String _rewardText = '';

  final List<String> _rewards = [
    '+10 XP',
    '+50 XP',
    '+1 FREEZE TOKEN',
    '+20 XP',
    '+5 XP',
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCirc,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spin() {
    final settings = ref.read(settingsServiceProvider);
    final now = DateTime.now();
    final lastSpin = settings.lastSpinDate;

    if (lastSpin != null &&
        lastSpin.year == now.year &&
        lastSpin.month == now.month &&
        lastSpin.day == now.day) {
      final locale = ref.read(localeProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.get(locale, 'spin_already'))),
      );
      return;
    }

    setState(() {
      _isSpinning = true;
    });

    final random = Random();
    final targetIndex = random.nextInt(_rewards.length);
    final extraSpins = 3;
    final targetAngle = (extraSpins * 2 * pi) +
        (targetIndex * (2 * pi / _rewards.length));

    _animation = Tween<double>(begin: 0, end: targetAngle).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCirc),
    );

    _controller.forward(from: 0).then((_) async {
      setState(() {
        _isSpinning = false;
        _hasSpun = true;
        _rewardText = _rewards[targetIndex];
      });
      settings.lastSpinDate = now;

      // Trigger Daily Quest
      ref.read(questProvider.notifier).completeQuest('spin_roulette');

      // Apply reward
      if (_rewardText.contains('XP')) {
        final xpAmount =
            int.tryParse(_rewardText.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        final db = ref.read(databaseProvider);
        final profile = await db.getUserProfile();
        if (profile != null) {
          final updated = profile.copyWith(xp: profile.xp + xpAmount);
          await db.insertUserProfile(updated);
          // ignore: unused_result
          ref.refresh(userProfileProvider);
        }
      } else if (_rewardText.contains('FREEZE')) {
        final db = ref.read(databaseProvider);
        final profile = await db.getUserProfile();
        if (profile != null) {
          final updated =
              profile.copyWith(freezeTokens: profile.freezeTokens + 1);
          await db.insertUserProfile(updated);
          // ignore: unused_result
          ref.refresh(userProfileProvider);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    String t(String key) => AppLocalizations.get(currentLocale, key);

    final brightness = Theme.of(context).brightness;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: AppColors.surface(brightness),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: AppColors.border(brightness)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t('spin_title'),
              style: AppTypography.h2(context, color: AppColors.accent),
            ),
            const SizedBox(height: 32.0),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accent,
                        width: 3.0,
                      ),
                      gradient: SweepGradient(
                        colors: [
                          AppColors.surfaceMuted(brightness),
                          AppColors.border(brightness),
                          AppColors.surfaceMuted(brightness),
                          AppColors.border(brightness),
                          AppColors.surfaceMuted(brightness),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.star,
                        color: AppColors.accent.withValues(alpha: 0.3),
                        size: 100,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32.0),
            if (_hasSpun) ...[
              Text(
                t('spin_result'),
                style: AppTypography.bodySmall(context),
              ),
              const SizedBox(height: 8.0),
              Text(
                _rewardText,
                style: AppTypography.metric(context, color: AppColors.accent),
              ),
            ] else ...[
              AppButton(
                label: _isSpinning ? t('spin_spinning') : t('spin_spin_btn'),
                variant: ButtonVariant.primary,
                onPressed: _isSpinning ? null : _spin,
              ),
            ],
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                t('common_close'),
                style: AppTypography.body(
                  context,
                  color: AppColors.textTertiary(brightness),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
