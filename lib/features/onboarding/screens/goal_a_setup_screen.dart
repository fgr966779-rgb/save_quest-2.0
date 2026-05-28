import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/goal_template_picker.dart';

class GoalASetupScreen extends ConsumerStatefulWidget {
  const GoalASetupScreen({super.key});

  @override
  ConsumerState<GoalASetupScreen> createState() => _GoalASetupScreenState();
}

class _GoalASetupScreenState extends ConsumerState<GoalASetupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _targetController;
  String _selectedCurrency = '₴';

  @override
  void initState() {
    super.initState();
    final initialTitle = ref.read(onboardingGoalATitleProvider);
    final initialTarget = ref.read(onboardingGoalATargetProvider);
    _selectedCurrency = ref.read(settingsServiceProvider).currency;

    _titleController = TextEditingController(text: initialTitle);
    _targetController =
        TextEditingController(text: initialTarget.toInt().toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(onboardingGoalATitleProvider.notifier).state =
          _titleController.text.trim();
      ref.read(onboardingGoalATargetProvider.notifier).state =
          double.tryParse(_targetController.text) ?? 25000.0;
      ref.read(onboardingGoalACurrencyProvider.notifier).state =
          _selectedCurrency;
      context.go('/onboarding-b');
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textPrimary(brightness),
                      size: 20,
                    ),
                    onPressed: () => context.go('/welcome'),
                  ),
                ),
                const SizedBox(height: 16),
                // Step label
                Text(
                  AppLocalizations.get(locale, 'onb_step_1_3'),
                  style: AppTypography.caption(
                    context,
                    color: AppColors.goalA,
                  ),
                ),
                const SizedBox(height: 4),
                // Page title
                Text(
                  AppLocalizations.get(locale, 'onb_goal_a_title'),
                  style: AppTypography.h1(
                    context,
                    color: AppColors.textPrimary(brightness),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.get(locale, 'onb_goal_a_desc'),
                  style: AppTypography.body(
                    context,
                    color: AppColors.textSecondary(brightness),
                  ),
                ),
                const SizedBox(height: 32),
                // Form card
                SurfaceCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card header with goal indicator
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.goalA,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            AppLocalizations.get(locale, 'onb_goal_card_header_a'),
                            style: AppTypography.h3(
                              context,
                              color: AppColors.goalA,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Title input
                      Text(
                        AppLocalizations.get(locale, 'onb_goal_name_label'),
                        style: AppTypography.caption(
                          context,
                          color: AppColors.textSecondary(brightness),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.get(locale, 'onb_goal_name_hint'),
                          prefixIcon: const Icon(Icons.label_outline_rounded),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return AppLocalizations.get(locale, 'onb_goal_name_validator');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Target amount input
                      Text(
                        AppLocalizations.get(locale, 'onb_goal_amount_label'),
                        style: AppTypography.caption(
                          context,
                          color: AppColors.textSecondary(brightness),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _targetController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          hintText: '25000',
                          prefixIcon: Icon(Icons.attach_money_rounded),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return AppLocalizations.get(
                                locale, 'onb_goal_amount_validator');
                          }
                          final numVal = double.tryParse(val);
                          if (numVal == null || numVal <= 0) {
                            return AppLocalizations.get(
                                locale, 'onb_goal_amount_invalid');
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Currency selector
                Text(
                  AppLocalizations.get(locale, 'onb_currency_label'),
                  style: AppTypography.caption(
                    context,
                    color: AppColors.textSecondary(brightness),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ['₴', '\$', '€'].map((cur) {
                    final isSelected = _selectedCurrency == cur;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedCurrency = cur),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accent.withValues(alpha: 0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accent
                                  : AppColors.border(brightness),
                            ),
                          ),
                          child: Text(
                            cur,
                            style: AppTypography.body(
                              context,
                              color: isSelected ? AppColors.accent : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
                // Template picker button
                AppButton(
                  label: AppLocalizations.get(locale, 'template_btn'),
                  variant: ButtonVariant.secondary,
                  icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                  onPressed: () {
                    GoalTemplatePicker.show(
                      context,
                      onSelected: (name, target) {
                        setState(() {
                          _titleController.text = name;
                          _targetController.text = target.toInt().toString();
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Progress dots
                _buildDotIndicators(brightness),
                const SizedBox(height: 24),
                // Continue button
                AppButton(
                  label: AppLocalizations.get(locale, 'common_next'),
                  variant: ButtonVariant.primary,
                  onPressed: _onNextPressed,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDotIndicators(Brightness brightness) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(isActive: false, brightness: brightness),
        const SizedBox(width: 8),
        _buildDot(isActive: true, brightness: brightness),
        const SizedBox(width: 8),
        _buildDot(isActive: false, brightness: brightness),
        const SizedBox(width: 8),
        _buildDot(isActive: false, brightness: brightness),
      ],
    );
  }

  Widget _buildDot({required bool isActive, required Brightness brightness}) {
    return Container(
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.accent : AppColors.border(brightness),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
