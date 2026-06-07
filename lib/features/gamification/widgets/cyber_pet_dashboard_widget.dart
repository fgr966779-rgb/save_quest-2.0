import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/pets_screen.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/providers/providers.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/pet_evolution_provider.dart';
import '../../../core/providers/pets_provider.dart';

class CyberPetDashboardWidget extends ConsumerWidget {
  final bool isZenMode;
  const CyberPetDashboardWidget({super.key, this.isZenMode = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final petsAsync = ref.watch(petsProvider);
    final evolution = ref.watch(petEvolutionProvider);
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);

    // Listen for evolution changes to show snackbar
    ref.listen<PetEvolutionState>(petEvolutionProvider, (previous, next) {
      if (previous != null && previous.type != next.type && next.type != PetEvolutionType.base) {
        final typeName = AppLocalizations.get(locale, 'pet_evo_${next.type.name}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.format(locale, 'pet_evo_success', {'type': typeName}),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.accent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return profileAsync.when(
      data: (profile) {
        if (profile == null) return const SizedBox.shrink();

        return petsAsync.when(
          data: (pets) {
            if (pets.isEmpty) return const SizedBox.shrink();

            final pet = pets.first;
            final lastDepositDate = profile.lastDepositDate;
            
            // Calculate energy / temp based on inactivity
            double temp = 37.0;
            if (lastDepositDate != null) {
              final hours = DateTime.now().difference(lastDepositDate).inHours;
              if (hours > 24) {
                temp = 37.0 + (hours - 24) * 1.5;
              }
            }
            temp = temp.clamp(37.0, 99.0);
            
            final isOverheating = temp > 60.0;
            final isWarning = temp > 45.0 && temp <= 60.0;
            
            final isDebuffActive = profile.debuffActiveUntil != null && 
                DateTime.now().isBefore(profile.debuffActiveUntil!);
            
            Color moodColor = isDebuffActive ? const Color(0xFFFF2A6D) : AppColors.success;
            IconData moodIcon = isDebuffActive 
                ? Icons.bug_report_rounded 
                : Icons.sentiment_very_satisfied_rounded;
            String statusText = isDebuffActive ? 'VIRUS DEBUFF ACTIVE (-20% XP)' : 'SYSTEM OPTIMAL';
            
            if (isZenMode) {
                moodColor = Colors.blueGrey;
                moodIcon = Icons.self_improvement_rounded;
                statusText = 'Медитує / Відпочиває';
            } else if (!isDebuffActive) {
              if (isOverheating) {
                moodColor = AppColors.error;
                moodIcon = Icons.sentiment_very_dissatisfied_rounded;
                statusText = 'CRITICAL OVERHEAT';
              } else if (isWarning) {
                moodColor = AppColors.warning;
                moodIcon = Icons.sentiment_neutral_rounded;
                statusText = 'ENERGY DRAINING';
              }
            }

            // --- Evolution Visuals ---
            Color? evolutionFilterColor;
            IconData? evolutionOverlayIcon;
            
            switch (evolution.type) {
              case PetEvolutionType.wise:
                evolutionFilterColor = Colors.blue.withValues(alpha: 0.3);
                evolutionOverlayIcon = Icons.self_improvement; // 📿 proxy
                break;
              case PetEvolutionType.wealthy:
                evolutionFilterColor = Colors.amber.withValues(alpha: 0.3);
                evolutionOverlayIcon = Icons.paid; // 💰 proxy
                break;
              case PetEvolutionType.resilient:
                evolutionFilterColor = Colors.purple.withValues(alpha: 0.3);
                evolutionOverlayIcon = Icons.shield; // 🛡️ proxy
                break;
              case PetEvolutionType.base:
                break;
            }

            return SurfaceCard(
              padding: const EdgeInsets.all(AppTheme.spaceMd),
              child: InkWell(
                onTap: () => context.push('/pets'),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                child: Row(
                  children: [
                    // Avatar / Icon with neon glow + Evolution Filter
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(scale: animation, child: child),
                        );
                      },
                      child: Stack(
                        key: ValueKey('${evolution.type}_$isZenMode'),
                        children: [
                          ColorFiltered(
                            colorFilter: evolutionFilterColor != null
                                ? ColorFilter.mode(evolutionFilterColor, BlendMode.colorBurn)
                                : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: moodColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: moodColor.withValues(alpha: 0.5), width: 2),
                                boxShadow: isZenMode ? null : [
                                  BoxShadow(
                                    color: moodColor.withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                pet.petType == 'dragon' ? Icons.cruelty_free : Icons.pets,
                                color: moodColor,
                                size: 32,
                              ),
                            ),
                          ),
                          if (evolutionOverlayIcon != null)
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: AppColors.surface(brightness),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.accent, width: 1),
                                ),
                                child: Icon(evolutionOverlayIcon, size: 16, color: AppColors.accent),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppTheme.spaceMd),
                    
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                evolution.type == PetEvolutionType.base 
                                  ? pet.petType.toUpperCase()
                                  : AppLocalizations.get(locale, 'pet_evo_${evolution.type.name}').toUpperCase(),
                                style: AppTypography.bodySmall(context, color: AppColors.textPrimary(brightness)).copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: AppTheme.spaceSm),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isZenMode ? Colors.blueGrey.withValues(alpha: 0.15) : AppColors.accent.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'LVL ${PetsScreen.getPetLevelFromProfile(profile.xp)}',
                                  style: AppTypography.overline(context, color: isZenMode ? Colors.blueGrey : AppColors.accent),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Evolution Progress Badge
                          if (!isZenMode && evolution.progress < 7 && evolution.currentRitual.isNotEmpty)
                             Padding(
                               padding: const EdgeInsets.only(bottom: 4),
                               child: Text(
                                 AppLocalizations.format(locale, 'pet_evo_progress', {
                                   'progress': evolution.progress.toString(),
                                   'ritual': AppLocalizations.get(locale, 'ritual_${evolution.currentRitual}'),
                                 }),
                                 style: AppTypography.overline(context, color: AppColors.textSecondary(brightness)),
                               ),
                             ),
                          Row(
                            children: [
                              Icon(moodIcon, size: 14, color: moodColor),
                              const SizedBox(width: 4),
                              Text(
                                statusText,
                                style: AppTypography.caption(context, color: moodColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Temp bar
                    if (!isZenMode) Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${temp.toStringAsFixed(1)}°C',
                          style: AppTypography.h3(context, color: moodColor).copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 60,
                          height: 4,
                          child: LinearProgressIndicator(
                            value: ((temp - 37.0) / (99.0 - 37.0)).clamp(0.0, 1.0),
                            backgroundColor: AppColors.border(brightness),
                            valueColor: AlwaysStoppedAnimation<Color>(moodColor),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
