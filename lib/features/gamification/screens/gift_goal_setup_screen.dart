import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' show Value;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/database.dart';

enum SetupStep { selectGoal, recipient, occasion, message, confirm }

class OccasionPreset {
  final String type;
  final String label;
  final String emoji;

  const OccasionPreset({
    required this.type,
    required this.label,
    required this.emoji,
  });

  static const List<OccasionPreset> all = [
    OccasionPreset(type: 'birthday', label: 'День народження', emoji: '🎂'),
    OccasionPreset(type: 'wedding', label: 'Весілля', emoji: '💍'),
    OccasionPreset(type: 'graduation', label: 'Випускний', emoji: '🎓'),
    OccasionPreset(type: 'anniversary', label: 'Річниця', emoji: '❤️'),
    OccasionPreset(type: 'new_year', label: 'Новий рік', emoji: '🎄'),
    OccasionPreset(type: 'other', label: 'Інше', emoji: '🎁'),
  ];
}

class GiftGoalSetupScreen extends ConsumerStatefulWidget {
  const GiftGoalSetupScreen({super.key});

  @override
  ConsumerState<GiftGoalSetupScreen> createState() => _GiftGoalSetupScreenState();
}

class _GiftGoalSetupScreenState extends ConsumerState<GiftGoalSetupScreen> {
  SetupStep _step = SetupStep.selectGoal;
  String? _selectedGoalId;
  final _recipientController = TextEditingController();
  final _relationshipController = TextEditingController();
  String _selectedOccasionType = 'birthday';
  DateTime _occasionDate = DateTime.now().add(const Duration(days: 14));
  final _messageController = TextEditingController();
  bool _isSurpriseMode = true;

  @override
  void dispose() {
    _recipientController.dispose();
    _relationshipController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _stepTitle,
          style: AppTypography.h3(context),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary(brightness), size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressIndicator(brightness),
            Expanded(
              child: _buildCurrentStep(brightness),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  String get _stepTitle {
    switch (_step) {
      case SetupStep.selectGoal:
        return 'Крок 1/5: Ціль';
      case SetupStep.recipient:
        return 'Крок 2/5: Одержувач';
      case SetupStep.occasion:
        return 'Крок 3/5: Подія';
      case SetupStep.message:
        return 'Крок 4/5: Повідомлення';
      case SetupStep.confirm:
        return 'Крок 5/5: Підтвердження';
    }
  }

  Widget _buildProgressIndicator(Brightness brightness) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg, vertical: AppTheme.spaceSm),
      child: Row(
        children: List.generate(5, (index) {
          final isActive = index <= _step.index;
          return Expanded(
            child: Container(
              height: 3,
              margin: EdgeInsets.only(right: index < 4 ? 4 : 0),
              decoration: BoxDecoration(
                color: isActive ? AppColors.accent : AppColors.border(brightness),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep(Brightness brightness) {
    switch (_step) {
      case SetupStep.selectGoal:
        return _buildSelectGoalStep(brightness);
      case SetupStep.recipient:
        return _buildRecipientStep(brightness);
      case SetupStep.occasion:
        return _buildOccasionStep(brightness);
      case SetupStep.message:
        return _buildMessageStep(brightness);
      case SetupStep.confirm:
        return _buildConfirmStep(brightness);
    }
  }

  Widget _buildSelectGoalStep(Brightness brightness) {
    final goalsAsync = ref.watch(goalsProvider);

    return goalsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Помилка завантаження цілей')),
      data: (goals) {
        final activeGoals = goals.where((g) => g.currentAmount < g.targetAmount).toList();

        if (activeGoals.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline_rounded, size: 48, color: AppColors.success),
                const SizedBox(height: 16),
                Text('Всі цілі досягнуті', style: AppTypography.bodySmall(context)),
                const SizedBox(height: 8),
                Text('Створіть нову ціль перед створенням подарунка',
                    style: AppTypography.caption(context, color: AppColors.textSecondary(brightness))),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppTheme.spaceMd),
          itemCount: activeGoals.length,
          itemBuilder: (ctx, i) {
            final goal = activeGoals[i];
            final isSelected = _selectedGoalId == goal.id;
            return GestureDetector(
              onTap: () => setState(() => _selectedGoalId = goal.id),
              child: Container(
                margin: const EdgeInsets.only(bottom: AppTheme.spaceSm),
                padding: const EdgeInsets.all(AppTheme.spaceMd),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent.withValues(alpha: 0.15) : AppColors.surface(brightness),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : AppColors.border(brightness),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: AppTheme.spaceSm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(goal.name, style: AppTypography.bodySmall(context)),
                          const SizedBox(height: 2),
                          Text(
                            '${((goal.currentAmount / goal.targetAmount) * 100).toInt()}% виконано',
                            style: AppTypography.caption(context, color: AppColors.textSecondary(brightness)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRecipientStep(Brightness brightness) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Хто отримувач?', style: AppTypography.h3(context)),
          const SizedBox(height: AppTheme.spaceMd),
          TextField(
            controller: _recipientController,
            style: AppTypography.bodySmall(context),
            decoration: InputDecoration(
              labelText: 'Ім\'я одержувача',
              hintText: 'Наприклад: Макс',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          TextField(
            controller: _relationshipController,
            style: AppTypography.bodySmall(context),
            decoration: InputDecoration(
              labelText: 'Зв\'язок',
              hintText: 'Наприклад: син, мама, друг',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Text(
            'Підставка для створення eмоційного зв\'язку з ціллю',
            style: AppTypography.caption(context, color: AppColors.textSecondary(brightness)),
          ),
        ],
      ),
    );
  }

  Widget _buildOccasionStep(Brightness brightness) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Оберіть подію', style: AppTypography.h3(context)),
          const SizedBox(height: AppTheme.spaceMd),
          Wrap(
            spacing: AppTheme.spaceSm,
            runSpacing: AppTheme.spaceSm,
            children: OccasionPreset.all.map((preset) {
              final isSelected = _selectedOccasionType == preset.type;
              return GestureDetector(
                onTap: () => setState(() => _selectedOccasionType = preset.type),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accent.withValues(alpha: 0.2) : AppColors.surface(brightness),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : AppColors.border(brightness),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(preset.emoji, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(preset.label, style: AppTypography.bodySmall(context)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppTheme.spaceLg),
          Text('Дата події', style: AppTypography.bodySmall(context)),
          const SizedBox(height: AppTheme.spaceSm),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _occasionDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
              );
              if (!mounted) return;
              if (picked != null) {
                setState(() => _occasionDate = picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spaceMd),
              decoration: BoxDecoration(
                color: AppColors.surface(brightness),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppColors.border(brightness)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Text(
                    '${_occasionDate.day}.${_occasionDate.month}.${_occasionDate.year}',
                    style: AppTypography.bodySmall(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageStep(Brightness brightness) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Особисте повідомлення (необов\'язково)', style: AppTypography.h3(context)),
          const SizedBox(height: AppTheme.spaceMd),
          TextField(
            controller: _messageController,
            maxLines: 3,
            style: AppTypography.bodySmall(context),
            decoration: InputDecoration(
              hintText: 'Напишіть теплое побажання для одержувача...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: AppColors.surface(brightness),
            ),
          ),
          const SizedBox(height: AppTheme.spaceLg),
          Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 18, color: AppColors.textSecondary(brightness)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Повідомлення буде видно тільки Вам',
                  style: AppTypography.caption(context, color: AppColors.textSecondary(brightness)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceXl),
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                Switch(
                  value: _isSurpriseMode,
                  onChanged: (v) => setState(() => _isSurpriseMode = v),
                  activeColor: AppColors.accent,
                ),
                const SizedBox(width: AppTheme.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Режим сюрпризу', style: AppTypography.bodySmall(context)),
                      const SizedBox(height: 2),
                      Text(
                        'Ціль будує завуальована від одержувача',
                        style: AppTypography.caption(context, color: AppColors.textSecondary(brightness)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmStep(Brightness brightness) {
    final goalsAsync = ref.watch(goalsProvider);
    final selectedGoal = goalsAsync.value?.firstWhere(
      (g) => g.id == _selectedGoalId,
      orElse: () => throw StateError('Goal not found'),
    );
    final progress = selectedGoal != null && selectedGoal.targetAmount > 0
        ? (selectedGoal.currentAmount / selectedGoal.targetAmount).clamp(0.0, 1.0)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Перевірте дані', style: AppTypography.h3(context)),
          const SizedBox(height: AppTheme.spaceMd),
          _buildConfirmRow('Ціль', selectedGoal?.name ?? '—'),
          _buildConfirmRow('Одержувач', '${_recipientController.text} (${_relationshipController.text})'),
          _buildConfirmRow('Подія',
              '${OccasionPreset.all.firstWhere((p) => p.type == _selectedOccasionType, orElse: () => OccasionPreset.all.last).label} · ${_occasionDate.day}.${_occasionDate.month}.${_occasionDate.year}'),
          _buildConfirmRow('Режим сюрпризу', _isSurpriseMode ? 'Так' : 'Ні'),
          _buildConfirmRow('Прогрес', '${(progress * 100).toInt()}%'),
          if (_messageController.text.isNotEmpty)
            _buildConfirmRow('Повідомлення', _messageController.text),
        ],
      ),
    );
  }

  Widget _buildConfirmRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: AppTypography.caption(context, color: AppColors.textSecondary(Theme.of(context).brightness))),
          ),
          Expanded(
            child: Text(value, style: AppTypography.bodySmall(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final brightness = Theme.of(context).brightness;
    final isLastStep = _step == SetupStep.confirm;
    final isFirstStep = _step == SetupStep.selectGoal;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface(brightness),
        border: Border(top: BorderSide(color: AppColors.border(brightness))),
      ),
      child: Row(
        children: [
          if (!isFirstStep)
            Expanded(
              child: AppButton(
                label: 'Назад',
                variant: ButtonVariant.ghost,
                onPressed: () {
                  setState(() {
                    _step = SetupStep.values[_step.index - 1];
                  });
                },
              ),
            ),
          if (!isFirstStep) const SizedBox(width: AppTheme.spaceMd),
          Expanded(
            child: AppButton(
              label: isLastStep ? 'Створити' : 'Далі',
              onPressed: _onNext,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onNext() async {
    if (_step == SetupStep.selectGoal) {
      if (_selectedGoalId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Оберіть ціль')),
        );
        return;
      }
    }

    if (_step == SetupStep.recipient) {
      if (_recipientController.text.trim().isEmpty ||
          _relationshipController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Заповніть ім\'я та зв\'язок')),
        );
        return;
      }
    }

    if (_step == SetupStep.confirm) {
      await _createGiftGoal();
      return;
    }

    setState(() {
      _step = SetupStep.values[_step.index + 1];
    });
  }

  Future<void> _createGiftGoal() async {
    if (_selectedGoalId == null) return;

    final notifier = ref.read(giftFundProvider.notifier);
    final now = DateTime.now();

    final companion = GiftGoalsCompanion(
      goalId: Value(_selectedGoalId!),
      recipientName: Value(_recipientController.text.trim()),
      recipientRelationship: Value(_relationshipController.text.trim()),
      occasionType: Value(_selectedOccasionType),
      occasionDate: Value(_occasionDate),
      emoji: Value(OccasionPreset.all
          .firstWhere((p) => p.type == _selectedOccasionType,
              orElse: () => OccasionPreset.all.last)
          .emoji),
      personalizedMessage: Value(_messageController.text.trim().isEmpty
          ? null
          : _messageController.text.trim()),
      isSurpriseMode: Value(_isSurpriseMode),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    final goal = await ref.read(databaseProvider).getGoalById(_selectedGoalId!);
    if (goal == null) return;

    await notifier.createGiftGoal(companion, goal);

    if (mounted) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Подарунок створено! 🎁')),
      );
    }
  }
}
