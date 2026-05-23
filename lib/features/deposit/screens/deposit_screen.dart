import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/savings_notifier.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/amount_input_pad.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/neon_progress_bar.dart';
import '../../../core/widgets/particle_background.dart';
import '../../../core/widgets/split_slider.dart';
import '../../../data/database.dart';

enum DepositStep { input, split, confirm, undoWindow, success }

class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> with SingleTickerProviderStateMixin {
  DepositStep _currentStep = DepositStep.input;
  String _amountText = '';
  double _splitRatio = 50.0; // Goal A allocation % (0 to 100)

  // Success animations
  late AnimationController _successAnimController;
  late List<CelebrationConfetti> _confettiParticles;

  DepositResult? _depositResult;

  // Undo window
  Timer? _undoTimer;
  int _undoCountdown = 5;

  @override
  void initState() {
    super.initState();
    _successAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Prepare success particles
    final random = Random();
    _confettiParticles = List.generate(60, (index) {
      return CelebrationConfetti(
        x: 0.5,
        y: 0.7,
        vx: (random.nextDouble() - 0.5) * 4.0,
        vy: -random.nextDouble() * 3.5 - 2.5,
        color: index % 2 == 0 ? AppColors.cyanAccent : AppColors.magentaAccent,
        size: random.nextDouble() * 5.0 + 3.0,
        rotation: random.nextDouble() * 2 * pi,
        rotationSpeed: (random.nextDouble() - 0.5) * 0.1,
      );
    });
  }

  @override
  void dispose() {
    _undoTimer?.cancel();
    _successAnimController.dispose();
    super.dispose();
  }

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
        final amount = 50 + random.nextInt(451); // 50 to 500
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
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(goalsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const Positioned.fill(child: ParticleBackground()),

          if (_currentStep == DepositStep.success)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _successAnimController,
                builder: (context, child) {
                  for (var particle in _confettiParticles) {
                    particle.update();
                  }
                  return CustomPaint(
                    painter: ConfettiPainter(particles: _confettiParticles),
                  );
                },
              ),
            ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                _buildHeader(context),

                Expanded(
                  child: goalsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(
                      child: Text(
                        'ПОМИЛКА ЗАВАНТАЖЕННЯ: $err',
                        style: AppTextStyles.orbitronHeading(fontSize: 14.0, color: AppColors.magentaAccent),
                      ),
                    ),
                    data: (goals) {
                      if (goals.length < 2) return const SizedBox.shrink();
                      final goalA = goals.firstWhere((g) => g.id == 'goal_a');
                      final goalB = goals.firstWhere((g) => g.id == 'goal_b');

                      switch (_currentStep) {
                        case DepositStep.input:
                          return _buildInputStep(goalA.currency);
                        case DepositStep.split:
                          return _buildSplitStep(goalA, goalB);
                        case DepositStep.confirm:
                          return _buildConfirmStep(goalA, goalB);
                        case DepositStep.undoWindow:
                          return _buildUndoWindowStep();
                        case DepositStep.success:
                          return _buildSuccessStep(goalA, goalB);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    String stepTitle = 'ВНЕСОК У СЕЙФ';
    if (_currentStep == DepositStep.split) stepTitle = 'РОЗПОДІЛ КОШТІВ';
    if (_currentStep == DepositStep.confirm) stepTitle = 'ПІДТВЕРДЖЕННЯ';
    if (_currentStep == DepositStep.undoWindow) stepTitle = 'ОЧІКУВАННЯ';
    if (_currentStep == DepositStep.success) stepTitle = 'ТРАНЗАКЦІЯ УСПІШНА';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep != DepositStep.success && _currentStep != DepositStep.undoWindow)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
              onPressed: () {
                HapticFeedback.lightImpact();
                if (_currentStep == DepositStep.input) {
                  context.pop();
                } else if (_currentStep == DepositStep.split) {
                  setState(() => _currentStep = DepositStep.input);
                } else if (_currentStep == DepositStep.confirm) {
                  setState(() => _currentStep = DepositStep.split);
                }
              },
            )
          else
            const SizedBox(width: 48),
          Text(
            stepTitle,
            style: AppTextStyles.orbitronHeading(
              fontSize: 16.0,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildInputStep(String currency) {
    return Column(
      children: [
        const Spacer(),
        // Massive Typography Display
        Text(
          'ВВЕДІТЬ СУМУ',
          style: AppTextStyles.rajdhaniMedium(
            fontSize: 12.0,
            color: AppColors.cyanAccent,
          ).copyWith(letterSpacing: 2.0),
        ),
        const SizedBox(height: 10.0),
        // Amount display wrapped in GlassCard with animated glow
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          glowColor: _enteredAmount > 0 ? AppColors.cyanAccent : null,
          glowSigma: _enteredAmount > 0 ? 18.0 : 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: _enteredAmount > 0
                      ? [
                          BoxShadow(
                            color: AppColors.cyanAccent.withOpacity(0.4),
                            blurRadius: 20.0,
                            spreadRadius: 2.0,
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  _amountText.isEmpty ? '0' : _amountText,
                  style: AppTextStyles.orbitronHeading(
                    fontSize: 54.0,
                    color: _enteredAmount > 0 ? AppColors.textPrimary : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                currency,
                style: AppTextStyles.orbitronHeading(
                  fontSize: 24.0,
                  color: AppColors.cyanAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Custom Numeric Input Pad
        AmountInputPad(onKeyPressed: _onKeyPress),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: NeonButton(
            text: 'ПРОДОВЖИТИ',
            baseColor: AppColors.cyanAccent,
            glowColor: AppColors.cyanAccent,
            onPressed: _enteredAmount > 0
                ? () {
                    HapticFeedback.mediumImpact();
                    setState(() => _currentStep = DepositStep.split);
                  }
                : null,
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildSplitStep(Goal goalA, Goal goalB) {
    final double amountA = _enteredAmount * (_splitRatio / 100.0);
    final double amountB = _enteredAmount * ((100.0 - _splitRatio) / 100.0);
    // Convert to cents for display formatting
    final int amountACents = displayToCents(amountA);
    final int amountBCents = displayToCents(amountB);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'НАЛАШТУВАННЯ РОЗПОДІЛУ',
            textAlign: TextAlign.center,
            style: AppTextStyles.orbitronHeading(fontSize: 14.0, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Перетягніть повзунок для розподілу ${formatAmount(displayToCents(_enteredAmount))} ${goalA.currency} між вашими цілями',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12.0, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 48.0),

          // Goal A Card Allocation
          GlassCard(
            padding: const EdgeInsets.all(16.0),
            borderColor: AppColors.cyanAccent.withOpacity(0.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goalA.name.toUpperCase(),
                        style: AppTextStyles.orbitronHeading(fontSize: 12.0, color: AppColors.cyanAccent, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Ціль: ${formatAmount(goalA.targetAmount)} ${goalA.currency}',
                        style: const TextStyle(fontSize: 11.0, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Text(
                  '+${formatAmount(amountACents)} ${goalA.currency}',
                  style: AppTextStyles.orbitronHeading(fontSize: 18.0, color: AppColors.cyanAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),

          SplitSlider(
            valueA: _splitRatio / 100.0,
            labelA: goalA.name,
            labelB: goalB.name,
            onChanged: (val) {
              setState(() {
                _splitRatio = val * 100.0;
              });
            },
          ),
          const SizedBox(height: 24.0),

          // Goal B Card Allocation
          GlassCard(
            padding: const EdgeInsets.all(16.0),
            borderColor: AppColors.magentaAccent.withOpacity(0.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goalB.name.toUpperCase(),
                        style: AppTextStyles.orbitronHeading(fontSize: 12.0, color: AppColors.magentaAccent, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Ціль: ${formatAmount(goalB.targetAmount)} ${goalB.currency}',
                        style: const TextStyle(fontSize: 11.0, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Text(
                  '+${formatAmount(amountBCents)} ${goalB.currency}',
                  style: AppTextStyles.orbitronHeading(fontSize: 18.0, color: AppColors.magentaAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const Spacer(),
          NeonButton(
            text: 'ВСТАНОВИТИ РОЗПОДІЛ',
            baseColor: AppColors.magentaAccent,
            glowColor: AppColors.magentaAccent,
            onPressed: () {
              HapticFeedback.mediumImpact();
              setState(() => _currentStep = DepositStep.confirm);
            },
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildConfirmStep(Goal goalA, Goal goalB) {
    final double amountA = _enteredAmount * (_splitRatio / 100.0);
    final double amountB = _enteredAmount * ((100.0 - _splitRatio) / 100.0);
    final int amountACents = displayToCents(amountA);
    final int amountBCents = displayToCents(amountB);

    // Progress ratios — all in kopecks
    final double currentProgressA = goalA.targetAmount > 0 ? (goalA.currentAmount / goalA.targetAmount) : 0.0;
    final double projectedProgressA = goalA.targetAmount > 0
        ? ((goalA.currentAmount + amountACents) / goalA.targetAmount).clamp(0.0, 1.0)
        : 0.0;

    final double currentProgressB = goalB.targetAmount > 0 ? (goalB.currentAmount / goalB.targetAmount) : 0.0;
    final double projectedProgressB = goalB.targetAmount > 0
        ? ((goalB.currentAmount + amountBCents) / goalB.targetAmount).clamp(0.0, 1.0)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16.0),
          Text(
            'ПРОЕКЦІЯ ВПЛИВУ НА БАЛАНС',
            textAlign: TextAlign.center,
            style: AppTextStyles.orbitronHeading(fontSize: 13.0, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24.0),

          GlassCard(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      goalA.name.toUpperCase(),
                      style: AppTextStyles.orbitronHeading(fontSize: 12.0, color: AppColors.cyanAccent, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '+${formatAmount(amountACents)} ${goalA.currency}',
                      style: AppTextStyles.orbitronHeading(fontSize: 14.0, color: AppColors.cyanAccent, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Поточний прогрес: ${(currentProgressA * 100).toInt()}%',
                  style: const TextStyle(fontSize: 10.0, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6.0),
                NeonProgressBar(
                  progress: currentProgressA,
                  activeColor: AppColors.cyanAccent.withOpacity(0.5),
                  glowColor: AppColors.cyanAccent.withOpacity(0.2),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Проектований прогрес: ${(projectedProgressA * 100).toInt()}%',
                  style: const TextStyle(fontSize: 10.0, color: AppColors.cyanAccent, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6.0),
                NeonProgressBar(
                  progress: projectedProgressA,
                  activeColor: AppColors.cyanAccent,
                  glowColor: AppColors.cyanAccent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),

          GlassCard(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      goalB.name.toUpperCase(),
                      style: AppTextStyles.orbitronHeading(fontSize: 12.0, color: AppColors.magentaAccent, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '+${formatAmount(amountBCents)} ${goalB.currency}',
                      style: AppTextStyles.orbitronHeading(fontSize: 14.0, color: AppColors.magentaAccent, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Поточний прогрес: ${(currentProgressB * 100).toInt()}%',
                  style: const TextStyle(fontSize: 10.0, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6.0),
                NeonProgressBar(
                  progress: currentProgressB,
                  activeColor: AppColors.magentaAccent.withOpacity(0.5),
                  glowColor: AppColors.magentaAccent.withOpacity(0.2),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Проектований прогрес: ${(projectedProgressB * 100).toInt()}%',
                  style: AppTextStyles.orbitronHeading(fontSize: 10.0, color: AppColors.magentaAccent, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6.0),
                NeonProgressBar(
                  progress: projectedProgressB,
                  activeColor: AppColors.magentaAccent,
                  glowColor: AppColors.magentaAccent,
                ),
              ],
            ),
          ),

          const Spacer(),
          NeonButton(
            text: 'ЗАТВЕРДИТИ ТРАНЗАКЦІЮ',
            baseColor: Colors.greenAccent,
            glowColor: Colors.greenAccent,
            onPressed: () {
              HapticFeedback.heavyImpact();
              setState(() => _currentStep = DepositStep.undoWindow);
              _startUndoTimer();
            },
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  void _startUndoTimer() {
    _undoCountdown = 5;
    _undoTimer?.cancel();
    _undoTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      setState(() {
        _undoCountdown--;
      });
      if (_undoCountdown <= 0) {
        timer.cancel();
        await _commitDeposit();
      }
    });
  }

  Future<void> _commitDeposit() async {
    final activeEvent = ref.read(eventsProvider);

    final result = await ref.read(savingsNotifierProvider.notifier).createDeposit(
      amount: _enteredAmount,
      goalAPercent: _splitRatio,
      note: 'Ручний депозит з терміналу',
      activeEvent: activeEvent,
    );

    if (result != null && mounted) {
      setState(() {
        _depositResult = result;
        _currentStep = DepositStep.success;
      });
      _successAnimController.forward(from: 0.0);
    } else if (mounted) {
      // If error, go back to confirm step
      setState(() => _currentStep = DepositStep.confirm);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Помилка при збереженні транзакції')),
      );
    }
  }

  Widget _buildUndoWindowStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ОБРОБКА ТРАНЗАКЦІЇ...',
          style: AppTextStyles.orbitronHeading(fontSize: 16.0, color: AppColors.cyanAccent),
        ),
        const SizedBox(height: 32.0),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: _undoCountdown / 5.0,
                color: AppColors.cyanAccent,
                strokeWidth: 8.0,
              ),
            ),
            Text(
              '$_undoCountdown',
              style: AppTextStyles.orbitronHeading(fontSize: 48.0, color: AppColors.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: 48.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: NeonButton(
            text: 'СКАСУВАТИ (UNDO)',
            baseColor: Colors.redAccent,
            glowColor: Colors.redAccent,
            icon: const Icon(Icons.undo, color: Colors.black),
            onPressed: () {
              HapticFeedback.mediumImpact();
              _undoTimer?.cancel();
              setState(() => _currentStep = DepositStep.confirm);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessStep(Goal goalA, Goal goalB) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Success animated checkmark — enlarged to 120x120
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.greenAccent, width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.withOpacity(0.3),
                    blurRadius: 30.0,
                    spreadRadius: 4.0,
                  ),
                ],
              ),
              child: Icon(Icons.check_circle_outline_rounded, color: Colors.greenAccent, size: 72),
            ),
          ),
          const SizedBox(height: 32.0),

          Text(
            'ЗАБЕЗПЕЧЕНО ТРАНЗАКЦІЮ!',
            textAlign: TextAlign.center,
            style: AppTextStyles.orbitronHeading(
              fontSize: 20.0,
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
            ).copyWith(shadows: [
              Shadow(color: Colors.greenAccent, blurRadius: 10.0),
            ]),
          ),
          const SizedBox(height: 12.0),
          Text(
            'Сума ${formatAmount(displayToCents(_enteredAmount))} ${goalA.currency} успішно розподілена у ваші фонди.',
            textAlign: TextAlign.center,
            style: AppTextStyles.rajdhaniMedium(fontSize: 14.0, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24.0),

          // Rewards summary card
          GlassCard(
            padding: const EdgeInsets.all(16.0),
            borderColor: _depositResult?.isCritical == true ? Colors.redAccent.withOpacity(0.5) : Colors.transparent,
            child: Row(
              children: [
                Icon(
                  _depositResult?.isCritical == true ? Icons.local_fire_department : Icons.flash_on, 
                  color: _depositResult?.isCritical == true ? Colors.redAccent : Colors.amberAccent, 
                  size: 30
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _depositResult?.isCritical == true ? 'КРИТИЧНИЙ ВНЕСОК!' : 'НАГОРОДА ВІДСІКУ',
                        style: AppTextStyles.orbitronHeading(
                          fontSize: 12.0,
                          color: _depositResult?.isCritical == true ? Colors.redAccent : Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      Text(
                        '+${_depositResult?.xpGained ?? 100} XP нараховано до вашого рангу!',
                        style: const TextStyle(fontSize: 11.0, color: AppColors.textPrimary),
                      ),
                      if (_depositResult?.isCritical == true)
                        Text(
                          '+${_depositResult?.bonusXp} БОНУС КРИТА!',
                          style: const TextStyle(fontSize: 11.0, color: Colors.redAccent, fontWeight: FontWeight.bold),
                        ),
                      if (_depositResult?.earnedLootbox != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '🎁 ВИ ОТРИМАЛИ ${_depositResult!.earnedLootbox!.rarity.toUpperCase()} ЛУТБОКС!',
                            style: const TextStyle(fontSize: 11.0, color: Colors.purpleAccent, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Check if either of the goals is complete
          Consumer(
            builder: (context, ref, child) {
              final goals = ref.read(goalsProvider).value ?? [];
              final finishedA = goals.any((g) => g.id == 'goal_a' && g.currentAmount >= g.targetAmount);
              final finishedB = goals.any((g) => g.id == 'goal_b' && g.currentAmount >= g.targetAmount);

              return NeonButton(
                text: (finishedA || finishedB) ? 'ВІДКРИТИ ЗОЛОТИЙ СЕЙФ' : 'ПОВЕРНУТИСЬ В СЕЙФ',
                baseColor: (finishedA || finishedB) ? Colors.amberAccent : AppColors.cyanAccent,
                glowColor: (finishedA || finishedB) ? Colors.amberAccent : AppColors.cyanAccent,
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  if (finishedA) {
                    context.go('/goal-complete', extra: {
                      'goalName': goals.firstWhere((g) => g.id == 'goal_a').name,
                      'targetAmount': goals.firstWhere((g) => g.id == 'goal_a').targetAmount, // int (kopecks)
                      'currency': goalA.currency,
                    });
                  } else if (finishedB) {
                    context.go('/goal-complete', extra: {
                      'goalName': goals.firstWhere((g) => g.id == 'goal_b').name,
                      'targetAmount': goals.firstWhere((g) => g.id == 'goal_b').targetAmount, // int (kopecks)
                      'currency': goalB.currency,
                    });
                  } else {
                    context.go('/dashboard');
                  }
                },
              );
            },
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

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
    vy += 0.08; // Gravity effect
    rotation += rotationSpeed;
  }
}

class ConfettiPainter extends CustomPainter {
  final List<CelebrationConfetti> particles;

  ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      if (particle.y > 1.0 || particle.y < 0.0) continue;

      paint.color = particle.color;
      final px = particle.x * size.width;
      final py = particle.y * size.height;

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(particle.rotation);

      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: particle.size, height: particle.size * 1.6),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
