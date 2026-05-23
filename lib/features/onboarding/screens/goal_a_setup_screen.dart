import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/particle_background.dart';
import '../../../core/widgets/glass_card.dart';

class GoalASetupScreen extends ConsumerStatefulWidget {
  const GoalASetupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GoalASetupScreen> createState() => _GoalASetupScreenState();
}

class _GoalASetupScreenState extends ConsumerState<GoalASetupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _targetController;

  @override
  void initState() {
    super.initState();
    final initialTitle = ref.read(onboardingGoalATitleProvider);
    final initialTarget = ref.read(onboardingGoalATargetProvider);

    _titleController = TextEditingController(text: initialTitle);
    _targetController = TextEditingController(text: initialTarget.toInt().toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(onboardingGoalATitleProvider.notifier).state = _titleController.text.trim();
      ref.read(onboardingGoalATargetProvider.notifier).state = double.tryParse(_targetController.text) ?? 25000.0;
      context.go('/onboarding-b');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const ParticleBackground(),
          // Decorative top color stripe
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 3.0,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.cyanAccent, Colors.transparent],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16.0),
                    // Back button & header
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.cyanAccent),
                          onPressed: () => context.go('/welcome'),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'МОДУЛЬ ЦІЛІ А',
                      style: AppTextStyles.rajdhaniMedium(
                        fontSize: 14.0,
                        color: AppColors.cyanAccent,
                      ).copyWith(letterSpacing: 3.0),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      'КОНФІГУРАЦІЯ',
                      style: AppTextStyles.orbitronHeading(
                        fontSize: 24.0,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    // Glass Card Container for settings — increased padding to 28
                    GlassCard(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12.0,
                                height: 12.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.cyanAccent,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'ЦІЛЬ А (CYAN МАРКЕР)',
                                style: AppTextStyles.orbitronHeading(
                                  fontSize: 14.0,
                                  color: AppColors.cyanAccent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          // Title Input
                          Text(
                            'НАЗВА ЦІЛІ',
                            style: AppTextStyles.rajdhaniMedium(
                              fontSize: 12.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            controller: _titleController,
                            style: const TextStyle(color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Введіть назву цілі',
                              prefixIcon: const Icon(Icons.label_outline, color: AppColors.cyanAccent),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.borderNeon),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.cyanAccent, width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Будь ласка, вкажіть назву цілі';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24.0),
                          // Target Amount Input
                          Text(
                            'ФІНАНСОВА МІШЕНЬ (UAH)',
                            style: AppTextStyles.rajdhaniMedium(
                              fontSize: 12.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            controller: _targetController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              hintText: '25000',
                              prefixIcon: const Icon(Icons.attach_money, color: AppColors.cyanAccent),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.borderNeon),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.cyanAccent, width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Будь ласка, вкажіть суму';
                              }
                              final numVal = double.tryParse(val);
                              if (numVal == null || numVal <= 0) {
                                return 'Введіть коректне позитивне число';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48.0),
                    // Progress dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDot(false),
                        _buildDot(true),
                        _buildDot(false),
                        _buildDot(false),
                      ],
                    ),
                    const SizedBox(height: 32.0),
                    // Continue button
                    NeonButton(
                      text: 'Конфігурувати Ціль Б',
                      baseColor: AppColors.cyanAccent,
                      glowColor: AppColors.cyanAccent,
                      onPressed: _onNextPressed,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: isActive ? 24.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: isActive ? AppColors.cyanAccent : AppColors.textMuted.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.cyanAccent.withOpacity(0.6),
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                ),
              ]
            : [],
      ),
    );
  }
}
