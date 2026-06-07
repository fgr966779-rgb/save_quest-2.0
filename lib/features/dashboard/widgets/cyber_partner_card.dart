import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../features/gamification/providers/partner_provider.dart';

class CyberPartnerCard extends ConsumerWidget {
  const CyberPartnerCard({super.key});

  void _showSetupDialog(BuildContext context, WidgetRef ref) {
    final locale = ref.read(localeProvider);
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        final brightness = Theme.of(ctx).brightness;
        return Dialog(
          backgroundColor: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface(brightness).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.connect_without_contact_rounded,
                    color: AppColors.accent,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.get(locale, 'partner_dialog_title'),
                    style: AppTypography.h2(ctx),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.get(locale, 'partner_dialog_desc'),
                    style: AppTypography.bodySmall(ctx, color: AppColors.textSecondary(brightness)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: controller,
                    style: AppTypography.body(ctx),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.get(locale, 'partner_dialog_input'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border(brightness)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.accent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: AppLocalizations.get(locale, 'partner_btn_add'),
                    variant: ButtonVariant.primary,
                    onPressed: () {
                      final name = controller.text.trim();
                      if (name.isNotEmpty) {
                        ref.read(partnerProvider.notifier).setPartnerName(name);
                        Navigator.pop(ctx);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      'Cancel',
                      style: AppTypography.body(ctx, color: AppColors.textTertiary(brightness)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final locale = ref.watch(localeProvider);
    final partnerState = ref.watch(partnerProvider);

    return partnerState.when(
      data: (profile) {
        if (profile == null || profile.partnerName == null) {
          // EMPTY STATE
          return SurfaceCard(
            padding: const EdgeInsets.all(20),
            child: InkWell(
              onTap: () => _showSetupDialog(context, ref),
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.get(locale, 'partner_empty_title'),
                          style: AppTypography.h3(context),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.get(locale, 'partner_empty_desc'),
                          style: AppTypography.caption(context, color: AppColors.textSecondary(brightness)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ACTIVE STATE
        final partnerName = profile.partnerName!;
        final isActive = ref.read(partnerProvider.notifier).isDoubleStrikeActive();
        final statusText = isActive 
            ? AppLocalizations.get(locale, 'partner_status_online')
            : AppLocalizations.get(locale, 'partner_status_offline');
        final statusColor = isActive ? AppColors.success : AppColors.textTertiary(brightness);

        // Simple Hash Avatar
        final initial = partnerName.isNotEmpty ? partnerName[0].toUpperCase() : '?';
        final colorIndex = partnerName.hashCode.abs() % 4;
        final avatarColors = [
          Colors.cyanAccent,
          Colors.purpleAccent,
          Colors.orangeAccent,
          Colors.greenAccent,
        ];
        final avatarColor = avatarColors[colorIndex];

        return SurfaceCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.get(locale, 'partner_card_title'),
                    style: AppTypography.h3(context),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_horiz_rounded, color: AppColors.textTertiary(brightness)),
                    color: AppColors.surface(brightness),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (value) {
                      if (value == 'change') {
                        _showSetupDialog(context, ref);
                      } else if (value == 'remove') {
                        ref.read(partnerProvider.notifier).removePartner();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'change',
                        child: Text(AppLocalizations.get(locale, 'partner_btn_change'), style: AppTypography.body(context)),
                      ),
                      PopupMenuItem(
                        value: 'remove',
                        child: Text('Видалити', style: AppTypography.body(context, color: AppColors.error)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Partner Info
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: avatarColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: avatarColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: avatarColor.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: avatarColor,
                          shadows: [
                            Shadow(color: avatarColor, blurRadius: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          partnerName,
                          style: AppTypography.h2(context),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: statusColor.withValues(alpha: 0.5),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                statusText,
                                style: AppTypography.caption(context, color: statusColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Quest Progress
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background(brightness).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border(brightness)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.get(locale, 'partner_quest_title'),
                          style: AppTypography.bodySmall(context).copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          isActive ? '2/2' : '1/2',
                          style: AppTypography.caption(context, color: AppColors.accent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: isActive ? 1.0 : 0.5,
                        backgroundColor: AppColors.surfaceMuted(brightness),
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                        minHeight: 8.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.get(locale, 'partner_quest_desc'),
                      style: AppTypography.overline(context, color: AppColors.textTertiary(brightness)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
