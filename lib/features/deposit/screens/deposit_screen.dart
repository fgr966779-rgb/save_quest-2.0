import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/amount_input_pad.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../core/widgets/split_slider.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/database.dart';
import '../../../core/services/milestone_service.dart';
import '../../../core/widgets/milestone_dialog.dart';
import '../../../core/services/sound_service.dart';

// ---------------------------------------------------------------------------
// State machine
// ---------------------------------------------------------------------------
enum DepositStep { input, split, confirm, undoWindow, success }

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------
class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({super.key});

  @override
  ConsumerState<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen>
    with SingleTickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────────────────
  DepositStep _currentStep = DepositStep.input;
  String _amountText = '';
  double _splitRatio = 50.0; // Goal A allocation %

  DepositResult? _depositResult;
  Map<String, int> _progressBeforeDeposit = {};

  // ── Undo window ────────────────────────────────────────────────────────
  Timer? _undoTimer;
  int _undoCountdown = 5;

  // ── Success animation ──────────────────────────────────────────────────
  late final AnimationController _successAnimController;
  late final List<CelebrationConfetti> _confettiParticles;

  // ── Lifecycle ──────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _successAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _confettiParticles = _generateConfetti();
  }

  @override
  void dispose() {
    _undoTimer?.cancel();
    _successAnimController.dispose();
    super.dispose();
  }

  // ── Confetti helpers ───────────────────────────────────────────────────
  List<CelebrationConfetti> _generateConfetti() {
    final random = Random();
    const colors = [
      AppColors.accent,
      AppColors.goalB,
      AppColors.accentLight,
      AppColors.success,
    ];
    return List.generate(40, (i) {
      return CelebrationConfetti(
        x: 0.5,
        y: 0.7,
        vx: (random.nextDouble() - 0.5) * 3.0,
        vy: -random.nextDouble() * 3.0 - 2.0,
        color: colors[i % colors.length],
        size: random.nextDouble() * 4.0 + 2.0,
        rotation: random.nextDouble() * 2 * pi,
        rotationSpeed: (random.nextDouble() - 0.5) * 0.1,
      );
    });
  }

  // ── Input logic (unchanged) ────────────────────────────────────────────
  void _onKeyPress(String val) {
    HapticFeedback.lightImpact();
    setState(() {
      if (val == 'C') {
        _amountText = '';
      } else if (val == '⌫') {
        if (_amountText.isNotEmpty) {
          _amountText = _amountText.substring(0, _amountText.length - 1);
        }
      } else if (val == '🎲') {
        final random = Random();
        final amount = 50 + random.nextInt(451);
        _amountText = amount.toString();
      } else if (val == '=') {
        _amountText = _evaluateMathExpression(_amountText);
      } else {
        if (_amountText.length < 20) {
          _amountText += val;
        }
      }
    });
  }

  String _evaluateMathExpression(String expr) {
    try {
      if (expr.isEmpty) return '';
      List<String> tokens = [];
      String currentNum = '';
      for (int i = 0; i < expr.length; i++) {
        final char = expr[i];
        if (char == '+' || char == '-') {
          if (currentNum.isNotEmpty) {
            tokens.add(currentNum);
            currentNum = '';
          }
          tokens.add(char);
        } else {
          currentNum += char;
        }
      }
      if (currentNum.isNotEmpty) {
        tokens.add(currentNum);
      }

      double result = 0;
      String op = '+';
      for (String token in tokens) {
        if (token == '+' || token == '-') {
          op = token;
        } else {
          double val = double.tryParse(token) ?? 0.0;
          if (op == '+') result += val;
          if (op == '-') result -= val;
        }
      }
      if (result < 0) result = 0;
      if (result == result.toInt()) {
        return result.toInt().toString();
      }
      return result.toStringAsFixed(2);
    } catch (_) {
      return expr;
    }
  }

  double get _enteredAmount {
    String evalStr = _amountText;
    if (evalStr.endsWith('+') || evalStr.endsWith('-')) {
      evalStr = evalStr.substring(0, evalStr.length - 1);
    }
    evalStr = _evaluateMathExpression(evalStr);
    return double.tryParse(evalStr) ?? 0.0;
  }

  // ── Undo timer / commit ────────────────────────────────────────────────
  void _startUndoTimer() {
    _undoCountdown = 5;
    _undoTimer?.cancel();
    _undoTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      setState(() => _undoCountdown--);
      if (_undoCountdown <= 0) {
        timer.cancel();
        await _commitDeposit();
      }
    });
  }

  Future<void> _commitDeposit() async {
    final activeEvent = ref.read(eventsProvider);

    // Save current goal progress before deposit (for milestone tracking)
    final db = ref.read(databaseProvider);
    final goalsBefore = await db.getAllGoals();
    _progressBeforeDeposit = {};
    for (final g in goalsBefore) {
      _progressBeforeDeposit[g.id] = MilestoneService.calculateProgress(
        g.currentAmount, g.targetAmount,
      );
    }

    final result = await ref
        .read(savingsNotifierProvider.notifier)
        .createDeposit(
          amount: _enteredAmount,
          goalAPercent: _splitRatio,
          note: AppLocalizations.get(ref.read(localeProvider), 'dep_note_manual'),
          activeEvent: activeEvent,
        );

    if (result != null && mounted) {
      setState(() {
        _depositResult = result;
        _currentStep = DepositStep.success;
      });
      _successAnimController.forward(from: 0.0);

      // Play deposit sound
      SoundService().playDeposit();
      HapticFeedback.heavyImpact();

      // Check for milestone achievements after deposit
      _checkMilestones(goalsBefore, db);
    } else if (mounted) {
      setState(() => _currentStep = DepositStep.confirm);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.get(ref.read(localeProvider), 'dep_save_error')),
        ),
      );
    }
  }

  // ── Milestone check ────────────────────────────────────────────────────
  Future<void> _checkMilestones(List<Goal> goalsBefore, AppDatabase db) async {
    final milestoneService = MilestoneService();
    final goalsAfter = await db.getAllGoals();

    for (final goalAfter in goalsAfter) {
      final beforePct = _progressBeforeDeposit[goalAfter.id] ?? 0;
      final afterPct = MilestoneService.calculateProgress(
        goalAfter.currentAmount, goalAfter.targetAmount,
      );

      final newMilestones = milestoneService.checkNewMilestones(
        goalId: goalAfter.id,
        previousPercent: beforePct,
        currentPercent: afterPct,
      );

      for (final pct in newMilestones) {
        if (!mounted) return;
        await Future.delayed(const Duration(milliseconds: 600));
        if (!mounted) return;

        await MilestoneDialog.show(
          context,
          goalName: goalAfter.name,
          percent: pct,
        );

        await milestoneService.markCelebrated(goalAfter.id, pct);
      }
    }
  }

  // ── Navigation ─────────────────────────────────────────────────────────
  void _onBack() {
    HapticFeedback.lightImpact();
    switch (_currentStep) {
      case DepositStep.input:
        context.pop();
      case DepositStep.split:
        setState(() => _currentStep = DepositStep.input);
      case DepositStep.confirm:
        setState(() => _currentStep = DepositStep.split);
      default:
        break;
    }
  }

  String _stepTitle(String locale) {
    return switch (_currentStep) {
      DepositStep.input => AppLocalizations.get(locale, 'dep_step_vault'),
      DepositStep.split => AppLocalizations.get(locale, 'dep_step_split'),
      DepositStep.confirm => AppLocalizations.get(locale, 'dep_step_confirm'),
      _ => '',
    };
  }

  bool get _showHeader =>
      _currentStep == DepositStep.input ||
      _currentStep == DepositStep.split ||
      _currentStep == DepositStep.confirm;

  // =========================================================================
  // BUILD
  // =========================================================================
  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(goalsProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      body: Stack(
        children: [
          // ── Main content ──
          SafeArea(
            child: Column(
              children: [
                // ── Header (input / split / confirm only) ──
                if (_showHeader)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: _onBack,
                          tooltip: AppLocalizations.get(locale, 'common_back'),
                        ),
                        Expanded(
                          child: Text(
                            _stepTitle(locale),
                            style: AppTypography.h3(context),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                // ── Step content ──
                Expanded(
                  child: goalsAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (err, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          '${AppLocalizations.get(locale, 'dep_load_error')}$err',
                          style: AppTypography.body(
                            context,
                            color: AppColors.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    data: (goals) {
                      if (goals.length < 2) return const SizedBox.shrink();
                      final goalA =
                          goals.firstWhere((g) => g.id == 'goal_a');
                      final goalB =
                          goals.firstWhere((g) => g.id == 'goal_b');

                      return switch (_currentStep) {
                        DepositStep.input =>
                          _buildInputStep(context, locale, goalA.currency),
                        DepositStep.split =>
                          _buildSplitStep(context, locale, goalA, goalB),
                        DepositStep.confirm =>
                          _buildConfirmStep(context, locale, goalA, goalB),
                        DepositStep.undoWindow =>
                          _buildUndoWindowStep(context, locale),
                        DepositStep.success =>
                          _buildSuccessStep(context, locale, goalA, goalB),
                      };
                    },
                  ),
                ),
              ],
            ),
          ),

          // ── Confetti overlay (success) ──
          if (_currentStep == DepositStep.success)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _successAnimController,
                  builder: (context, _) {
                    for (var p in _confettiParticles) {
                      p.update();
                    }
                    return CustomPaint(
                      painter: ConfettiPainter(
                        particles: _confettiParticles,
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  // =========================================================================
  // STEP: INPUT
  // =========================================================================
  Widget _buildInputStep(BuildContext context, String locale, String currency) {
    final brightness = Theme.of(context).brightness;
    final hasAmount = _enteredAmount > 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // ── Label ──
          Text(
            AppLocalizations.get(locale, 'dep_enter_amount'),
            style: AppTypography.caption(context),
          ),
          const SizedBox(height: 12),

          // ── Amount display ──
          SurfaceCard(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      _amountText.isEmpty ? '0' : _amountText,
                      style: AppTypography.display(
                        context,
                        color: hasAmount
                            ? AppColors.textPrimary(brightness)
                            : AppColors.textTertiary(brightness),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  currency,
                  style: AppTypography.amount(
                    context,
                    color: AppColors.textSecondary(brightness),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(flex: 3),

          // ── Keypad ──
          AmountInputPad(onKeyPressed: _onKeyPress),
          const SizedBox(height: 20),

          // ── Continue button ──
          AppButton(
            label: AppLocalizations.get(locale, 'dep_continue_btn'),
            onPressed: hasAmount
                ? () {
                    HapticFeedback.mediumImpact();
                    setState(() => _currentStep = DepositStep.split);
                  }
                : null,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // =========================================================================
  // STEP: SPLIT
  // =========================================================================
  Widget _buildSplitStep(BuildContext context, String locale, Goal goalA, Goal goalB) {
    final double amountA = _enteredAmount * (_splitRatio / 100.0);
    final double amountB = _enteredAmount * ((100.0 - _splitRatio) / 100.0);
    final int amountACents = displayToCents(amountA);
    final int amountBCents = displayToCents(amountB);
    final totalCents = displayToCents(_enteredAmount);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),

          // ── Title ──
          Text(
            AppLocalizations.get(locale, 'dep_split_title'),
            textAlign: TextAlign.center,
            style: AppTypography.h2(context),
          ),
          const SizedBox(height: 8),
          Text(
            '${AppLocalizations.get(locale, 'dep_split_instruction')}'
            '${formatAmount(totalCents)} ${goalA.currency}',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall(context),
          ),
          const SizedBox(height: 32),

          // ── Goal A allocation card ──
          SurfaceCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.goalA,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goalA.name,
                        style: AppTypography.h3(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${AppLocalizations.get(locale, 'dep_goal_label')}${formatAmount(goalA.targetAmount)} '
                        '${goalA.currency}',
                        style: AppTypography.bodySmall(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '+${formatAmount(amountACents)} ${goalA.currency}',
                  style: AppTypography.amount(
                    context,
                    color: AppColors.goalA,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Split slider ──
          SplitSlider(
            valueA: _splitRatio / 100.0,
            labelA: goalA.name,
            labelB: goalB.name,
            onChanged: (val) =>
                setState(() => _splitRatio = val * 100.0),
          ),
          const SizedBox(height: 24),

          // ── Goal B allocation card ──
          SurfaceCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.goalB,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goalB.name,
                        style: AppTypography.h3(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${AppLocalizations.get(locale, 'dep_goal_label')}${formatAmount(goalB.targetAmount)} '
                        '${goalB.currency}',
                        style: AppTypography.bodySmall(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '+${formatAmount(amountBCents)} ${goalB.currency}',
                  style: AppTypography.amount(
                    context,
                    color: AppColors.goalB,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // ── Confirm split ──
          AppButton(
            label: AppLocalizations.get(locale, 'dep_set_split'),
            onPressed: () {
              HapticFeedback.mediumImpact();
              setState(() => _currentStep = DepositStep.confirm);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // =========================================================================
  // STEP: CONFIRM
  // =========================================================================
  Widget _buildConfirmStep(BuildContext context, String locale, Goal goalA, Goal goalB) {
    final double amountA = _enteredAmount * (_splitRatio / 100.0);
    final double amountB = _enteredAmount * ((100.0 - _splitRatio) / 100.0);
    final int amountACents = displayToCents(amountA);
    final int amountBCents = displayToCents(amountB);

    // Progress ratios (all in kopecks)
    final currentProgressA = goalA.targetAmount > 0
        ? goalA.currentAmount / goalA.targetAmount
        : 0.0;
    final projectedProgressA = goalA.targetAmount > 0
        ? ((goalA.currentAmount + amountACents) / goalA.targetAmount)
            .clamp(0.0, 1.0)
        : 0.0;

    final currentProgressB = goalB.targetAmount > 0
        ? goalB.currentAmount / goalB.targetAmount
        : 0.0;
    final projectedProgressB = goalB.targetAmount > 0
        ? ((goalB.currentAmount + amountBCents) / goalB.targetAmount)
            .clamp(0.0, 1.0)
        : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Title ──
          Text(
            AppLocalizations.get(locale, 'dep_confirm_title'),
            textAlign: TextAlign.center,
            style: AppTypography.h2(context),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.get(locale, 'dep_confirm_subtitle'),
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall(context),
          ),
          const SizedBox(height: 24),

          // ── Goal A card ──
          SurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        goalA.name,
                        style: AppTypography.h3(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '+${formatAmount(amountACents)} ${goalA.currency}',
                      style: AppTypography.amount(
                        context,
                        color: AppColors.goalA,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ProgressBar(
                  progress: currentProgressA,
                  color: AppColors.goalA.withValues(alpha: 0.4),
                  label: AppLocalizations.get(locale, 'dep_progress_current'),
                  trailingText: '${(currentProgressA * 100).toInt()}%',
                ),
                const SizedBox(height: 12),
                ProgressBar(
                  progress: projectedProgressA,
                  color: AppColors.goalA,
                  label: AppLocalizations.get(locale, 'dep_progress_after'),
                  trailingText: '${(projectedProgressA * 100).toInt()}%',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Goal B card ──
          SurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        goalB.name,
                        style: AppTypography.h3(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '+${formatAmount(amountBCents)} ${goalB.currency}',
                      style: AppTypography.amount(
                        context,
                        color: AppColors.goalB,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ProgressBar(
                  progress: currentProgressB,
                  color: AppColors.goalB.withValues(alpha: 0.4),
                  label: AppLocalizations.get(locale, 'dep_progress_current'),
                  trailingText: '${(currentProgressB * 100).toInt()}%',
                ),
                const SizedBox(height: 12),
                ProgressBar(
                  progress: projectedProgressB,
                  color: AppColors.goalB,
                  label: AppLocalizations.get(locale, 'dep_progress_after'),
                  trailingText: '${(projectedProgressB * 100).toInt()}%',
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ── Submit button ──
          AppButton(
            label: AppLocalizations.get(locale, 'dep_confirm_btn'),
            onPressed: () {
              HapticFeedback.heavyImpact();
              setState(() => _currentStep = DepositStep.undoWindow);
              _startUndoTimer();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // =========================================================================
  // STEP: UNDO WINDOW
  // =========================================================================
  Widget _buildUndoWindowStep(BuildContext context, String locale) {
    final brightness = Theme.of(context).brightness;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Title ──
            Text(
              AppLocalizations.get(locale, 'dep_undo_title'),
              style: AppTypography.h2(context),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.get(locale, 'dep_undo_subtitle'),
              style: AppTypography.body(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // ── Countdown ring ──
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: 0.0),
              duration: const Duration(seconds: 5),
              curve: Curves.linear,
              builder: (context, value, _) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 6,
                        backgroundColor:
                            AppColors.surfaceMuted(brightness),
                        color: AppColors.accent,
                      ),
                    ),
                    Text(
                      '${(value * 5).ceil()}',
                      style: AppTypography.display(context),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 48),

            // ── Cancel button ──
            AppButton(
              label: AppLocalizations.get(locale, 'dep_undo_btn'),
              variant: ButtonVariant.secondary,
              onPressed: () {
                HapticFeedback.mediumImpact();
                _undoTimer?.cancel();
                setState(() => _currentStep = DepositStep.confirm);
              },
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // STEP: SUCCESS
  // =========================================================================
  Widget _buildSuccessStep(BuildContext context, String locale, Goal goalA, Goal goalB) {
    final totalCents = displayToCents(_enteredAmount);
    final result = _depositResult;

    return Consumer(
      builder: (context, ref, _) {
        final goalsAsync = ref.watch(goalsProvider);
        final goals = goalsAsync.value ?? [];
        final finishedA = goals.any(
          (g) => g.id == 'goal_a' && g.currentAmount >= g.targetAmount,
        );
        final finishedB = goals.any(
          (g) => g.id == 'goal_b' && g.currentAmount >= g.targetAmount,
        );
        final anyFinished = finishedA || finishedB;

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // ── Success icon with scale-in animation ──
              Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success.withValues(alpha: 0.1),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 56,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Title ──
              Text(
                AppLocalizations.get(locale, 'dep_success_title'),
                textAlign: TextAlign.center,
                style: AppTypography.h2(
                  context,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 8),

              // ── Amount ──
              Text(
                '${formatAmount(totalCents)} ${goalA.currency} '
                '${AppLocalizations.get(locale, 'dep_success_desc')}',
                textAlign: TextAlign.center,
                style: AppTypography.body(context),
              ),
              const SizedBox(height: 28),

              // ── Rewards summary ──
              SurfaceCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          result?.isCritical == true
                              ? Icons.local_fire_department_rounded
                              : Icons.bolt_rounded,
                          color: result?.isCritical == true
                              ? AppColors.error
                              : AppColors.warning,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          result?.isCritical == true
                              ? AppLocalizations.get(locale, 'dep_reward_critical')
                              : AppLocalizations.get(locale, 'dep_reward_vault'),
                          style: AppTypography.h3(
                            context,
                            color: result?.isCritical == true
                                ? AppColors.error
                                : AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _rewardRow(
                      context,
                      label: AppLocalizations.get(locale, 'dep_reward_xp'),
                      value: '+${result?.xpGained ?? 100}',
                    ),
                    if (result?.streakCount != null &&
                        result!.streakCount > 1) ...[
                      const SizedBox(height: 6),
                      _rewardRow(
                        context,
                        label: AppLocalizations.get(locale, 'dep_reward_streak'),
                        value: '${result.streakCount}${AppLocalizations.get(locale, 'daily_bonus_days')}',
                      ),
                    ],
                    if (result?.isCritical == true) ...[
                      const SizedBox(height: 6),
                      _rewardRow(
                        context,
                        label: AppLocalizations.get(locale, 'dep_reward_crit_bonus'),
                        value: '+${result?.bonusXp ?? 0} XP',
                        valueColor: AppColors.error,
                      ),
                    ],
                    if (result?.earnedLootbox != null) ...[
                      const SizedBox(height: 6),
                      _rewardRow(
                        context,
                        label: AppLocalizations.get(locale, 'dep_reward_lootbox'),
                        value: result!.earnedLootbox!.rarity,
                        valueColor: AppColors.accent,
                      ),
                    ],
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // ── Return button ──
              AppButton(
                label: anyFinished
                    ? AppLocalizations.get(locale, 'dep_open_vault')
                    : AppLocalizations.get(locale, 'dep_return_btn'),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  if (finishedA) {
                    context.go('/goal-complete', extra: {
                      'goalName': goals
                          .firstWhere((g) => g.id == 'goal_a')
                          .name,
                      'targetAmount': goals
                          .firstWhere((g) => g.id == 'goal_a')
                          .targetAmount,
                      'currency': goalA.currency,
                    });
                  } else if (finishedB) {
                    context.go('/goal-complete', extra: {
                      'goalName': goals
                          .firstWhere((g) => g.id == 'goal_b')
                          .name,
                      'targetAmount': goals
                          .firstWhere((g) => g.id == 'goal_b')
                          .targetAmount,
                      'currency': goalB.currency,
                    });
                  } else {
                    context.go('/dashboard');
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  /// Helper: a single row inside the rewards SurfaceCard.
  Widget _rewardRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final brightness = Theme.of(context).brightness;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySmall(context)),
        Text(
          value,
          style: AppTypography.bodySmall(
            context,
            color: valueColor ?? AppColors.textPrimary(brightness),
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// Confetti celebration (simplified)
// ===========================================================================
class CelebrationConfetti {
  double x;
  double y;
  double vx;
  double vy;
  final Color color;
  final double size;
  double rotation;
  final double rotationSpeed;

  CelebrationConfetti({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
  });

  void update() {
    x += vx * 0.01;
    y += vy * 0.01;
    vy += 0.08;
    rotation += rotationSpeed;
  }
}

class ConfettiPainter extends CustomPainter {
  final List<CelebrationConfetti> particles;

  ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      if (p.y > 1.2 || p.y < -0.2) continue;

      paint.color = p.color.withValues(alpha: 0.85);
      final px = p.x * size.width;
      final py = p.y * size.height;

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(p.rotation);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 1.6,
          ),
          const Radius.circular(1),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) => true;
}
