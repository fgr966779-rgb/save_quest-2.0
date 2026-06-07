import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';
import '../../../core/utils/money_utils.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/split_slider.dart';
import '../../../data/database.dart';

class SetupFinishScreen extends ConsumerStatefulWidget {
  const SetupFinishScreen({super.key});

  @override
  ConsumerState<SetupFinishScreen> createState() => _SetupFinishScreenState();
}

class _SetupFinishScreenState extends ConsumerState<SetupFinishScreen> {
  String _selectedCurrency = 'UAH';
  bool _isSaving = false;

  final Map<String, String> _currencySymbols = {
    'UAH': '₴  UAH',
    'USD': '\$  USD',
    'EUR': '€  EUR',
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
      final goalACurrency = ref.read(onboardingGoalACurrencyProvider);

      final goalBTitle = ref.read(onboardingGoalBTitleProvider);
      final goalBTarget = ref.read(onboardingGoalBTargetProvider);
      final goalBCurrency = ref.read(onboardingGoalBCurrencyProvider);

      // Save initial Goal A and Goal B
      // Targets are stored in kopecks (minor units).
      await db.insertGoal(
        Goal(
          id: 'goal_a',
          name: goalATitle,
          targetAmount: displayToCents(goalATarget),
          currentAmount: 0,
          currency: goalACurrency,
          accentColor: '#6366F1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          priceShieldHp: 100,
        ),
      );

      await db.insertGoal(
        Goal(
          id: 'goal_b',
          name: goalBTitle,
          targetAmount: displayToCents(goalBTarget),
          currentAmount: 0,
          currency: goalBCurrency,
          accentColor: '#10B981',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          priceShieldHp: 100,
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
          updatedAt: DateTime.now(),
          karmaDebt: 0,
          noSpendStreakCount: 0,
          partnerName: null,
          partnerLastDepositDate: null,
          pricePulseTrackingCount: 0,
          debuffActiveUntil: null,
          karmaHealingStreakCount: 0,
          lastKarmaHealDate: null,
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.get(ref.read(localeProvider), 'onb_finish_save_error')}$e'),
            backgroundColor: AppColors.error,
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
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);
    final splitRatioA = ref.watch(onboardingGoalASplitProvider);
    final goalATitle = ref.watch(onboardingGoalATitleProvider);
    final goalBTitle = ref.watch(onboardingGoalBTitleProvider);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                  onPressed: () => context.go('/onboarding-b'),
                ),
              ),
              const SizedBox(height: 16),
              // Step label
              Text(
                AppLocalizations.get(locale, 'onb_step_3_3'),
                style: AppTypography.caption(
                  context,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 4),
              // Page title
              Text(
                AppLocalizations.get(locale, 'onb_finish_title'),
                style: AppTypography.h1(
                  context,
                  color: AppColors.textPrimary(brightness),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.get(locale, 'onb_finish_desc'),
                style: AppTypography.body(
                  context,
                  color: AppColors.textSecondary(brightness),
                ),
              ),
              const SizedBox(height: 32),
              // Currency selector card
              SurfaceCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.get(locale, 'onb_finish_currency'),
                      style: AppTypography.h3(
                        context,
                        color: AppColors.textPrimary(brightness),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 48,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.accentMutedBg(brightness)
                                    : AppColors
                                        .surfaceMuted(brightness),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.accent
                                      : AppColors.border(brightness),
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _currencySymbols[curr]!,
                                  style: AppTypography.body(
                                    context,
                                    color: isSelected
                                        ? AppColors.accent
                                        : AppColors.textSecondary(brightness),
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
              const SizedBox(height: 16),
              // Split slider card
              SurfaceCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.get(locale, 'onb_finish_split'),
                      style: AppTypography.h3(
                        context,
                        color: AppColors.textPrimary(brightness),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.get(locale, 'onb_finish_split_desc'),
                      style: AppTypography.bodySmall(
                        context,
                        color: AppColors.textTertiary(brightness),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SplitSlider(
                      valueA: splitRatioA,
                      labelA: goalATitle,
                      labelB: goalBTitle,
                      onChanged: (val) {
                        ref.read(onboardingGoalASplitProvider.notifier).state =
                            val;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Progress dots
              _buildDotIndicators(brightness),
              const SizedBox(height: 24),
              // Launch button
              AppButton(
                label: AppLocalizations.get(locale, 'onb_finish_start_btn'),
                variant: ButtonVariant.primary,
                isLoading: _isSaving,
                onPressed: _launchVault,
              ),
              const SizedBox(height: 16),
            ],
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
        _buildDot(isActive: false, brightness: brightness),
        const SizedBox(width: 8),
        _buildDot(isActive: false, brightness: brightness),
        const SizedBox(width: 8),
        _buildDot(isActive: true, brightness: brightness),
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
