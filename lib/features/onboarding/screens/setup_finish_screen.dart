import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/particle_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/split_slider.dart';
import '../../../data/database.dart';

class SetupFinishScreen extends ConsumerStatefulWidget {
  const SetupFinishScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SetupFinishScreen> createState() => _SetupFinishScreenState();
}

class _SetupFinishScreenState extends ConsumerState<SetupFinishScreen> {
  String _selectedCurrency = 'UAH';
  bool _isSaving = false;

  final Map<String, String> _currencySymbols = {
    'UAH': '₴ (UAH)',
    'USD': '\$ (USD)',
    'EUR': '€ (EUR)',
  };

  Future<void> _launchVault() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final db = ref.read(databaseProvider);
      final settings = ref.read(settingsServiceProvider);

      final goalATitle = ref.read(onboardingGoalATitleProvider);
      final goalATarget = ref.read(onboardingGoalATargetProvider);

      final goalBTitle = ref.read(onboardingGoalBTitleProvider);
      final goalBTarget = ref.read(onboardingGoalBTargetProvider);

      // Save initial Goal A and Goal B
      // Targets are stored in kopecks (minor units).
      await db.insertGoal(
        Goal(
          id: 'goal_a',
          name: goalATitle,
          targetAmount: displayToCents(goalATarget),
          currentAmount: 0,
          currency: _selectedCurrency,
          accentColor: '#00E5FF',
          createdAt: DateTime.now(),
        ),
      );

      await db.insertGoal(
        Goal(
          id: 'goal_b',
          name: goalBTitle,
          targetAmount: displayToCents(goalBTarget),
          currentAmount: 0,
          currency: _selectedCurrency,
          accentColor: '#FF007F',
          createdAt: DateTime.now(),
        ),
      );

      // Initialize Profile record
      await db.insertUserProfile(
        UserProfile(
          id: 1,
          xp: 0,
          level: 1,
          streakCount: 0,
          maxStreak: 0,
          freezeTokens: 0,
          skillPoints: 0,
          playerClass: null,
          currentTheme: 'default',
          avatarConfig: null,
          penaltyBalance: 0,
          hackerXp: 0,
          magnateXp: 0,
          resilienceXp: 0,
          lastBonusClaimDate: null,
          bonusStreak: 0,
          crystalsBalance: 0,
        ),
      );

      // Write preferences to Hive
      settings.currency = _selectedCurrency;
      settings.hasCompletedOnboarding = true;

      // Navigate to main application Dashboard
      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      // Error handling
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Помилка при ініціалізації: $e'),
            backgroundColor: AppColors.magentaAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final splitRatioA = ref.watch(onboardingGoalASplitProvider);
    final goalATitle = ref.watch(onboardingGoalATitleProvider);
    final goalBTitle = ref.watch(onboardingGoalBTitleProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const ParticleBackground(),
          // Decorative gold top stripe
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 3.0,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.goldAccent, Colors.transparent],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16.0),
                  // Back button
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.goldGlow),
                        onPressed: () => context.go('/onboarding-b'),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'ФІНАЛЬНА СИНХРОНІЗАЦІЯ',
                    style: AppTextStyles.rajdhaniMedium(
                      fontSize: 14.0,
                      color: AppColors.goldGlow,
                    ).copyWith(letterSpacing: 3.0),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    'СИСТЕМНІ НАЛАШТУВАННЯ',
                    style: AppTextStyles.orbitronHeading(
                      fontSize: 24.0,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  // Currency selector card
                  GlassCard(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'КЛЮЧОВА ВАЛЮТА',
                          style: AppTextStyles.orbitronHeading(
                            fontSize: 14.0,
                            color: AppColors.goldGlow,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: _currencySymbols.keys.map((curr) {
                            final isSelected = _selectedCurrency == curr;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCurrency = curr;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? LinearGradient(
                                            colors: [
                                              AppColors.goldAccent.withOpacity(0.25),
                                              AppColors.goldAccent.withOpacity(0.08),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                    color: isSelected ? null : AppColors.cardBgLight,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: isSelected ? AppColors.goldAccent : AppColors.borderNeon,
                                      width: isSelected ? 2.0 : 1.0,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: AppColors.goldAccent.withOpacity(0.3),
                                              blurRadius: 8.0,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      _currencySymbols[curr]!,
                                      style: TextStyle(
                                        color: isSelected ? AppColors.goldAccent : AppColors.textPrimary,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Split Slider configuration card
                  GlassCard(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'БАЛАНС РОЗПОДІЛУ НАКОПИЧЕНЬ',
                          style: AppTextStyles.orbitronHeading(
                            fontSize: 14.0,
                            color: AppColors.goldGlow,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SplitSlider(
                          valueA: splitRatioA,
                          labelA: goalATitle,
                          labelB: goalBTitle,
                          onChanged: (val) {
                            ref.read(onboardingGoalASplitProvider.notifier).state = val;
                          },
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          'Кожен твій наступний внесок буде автоматично розподілений між цілями за цим балансом. Ти зможеш змінити його у будь-який момент.',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: AppColors.textMuted,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  // Progress dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(false),
                      _buildDot(false),
                      _buildDot(false),
                      _buildDot(true),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  // Launch Vault button
                  NeonButton(
                    text: 'ІНІЦІАЛІЗУВАТИ СЕЙФ',
                    baseColor: AppColors.goldAccent,
                    glowColor: AppColors.goldAccent,
                    isLoading: _isSaving,
                    onPressed: _launchVault,
                  ),
                  const SizedBox(height: 12.0),
                ],
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
        color: isActive ? AppColors.goldAccent : AppColors.textMuted.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.goldAccent.withOpacity(0.6),
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                ),
              ]
            : [],
      ),
    );
  }
}
