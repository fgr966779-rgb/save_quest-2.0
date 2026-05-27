import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' show Value;

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/neon_avatar_painter.dart';
import '../../../core/models/avatar_config.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  int _selectedTabIndex = 0; // 0: SP Items, 1: Cosmetics (Credits)

  Future<void> _buyCosmetic(AvatarConfig currentConfig, int cost, String itemId, String itemName) async {
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile == null) return;
    final currentLocale = ref.read(localeProvider);
    String t(String key) => AppLocalizations.get(currentLocale, key);

    if (currentConfig.credits < cost) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t('market_no_credits')), backgroundColor: AppColors.error),
        );
      }
      return;
    }

    // Deduct credits and add item
    final updatedConfig = currentConfig.copyWith(
      credits: currentConfig.credits - cost,
      ownedItems: [...currentConfig.ownedItems, itemId],
    );

    await db.insertUserProfile(profile.copyWith(avatarConfig: Value(updatedConfig.toJson())));
    // ignore: unused_result
    ref.refresh(userProfileProvider);

    if (mounted) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.format(currentLocale, 'market_purchased_success', {'name': itemName})), backgroundColor: AppColors.accent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final brightness = Theme.of(context).brightness;
    final currentLocale = ref.watch(localeProvider);
    String t(String key) => AppLocalizations.get(currentLocale, key);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t('market_title'),
          style: AppTypography.h3(context, color: AppColors.warning),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary(brightness), size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: profileAsync.when(
        data: (profile) {
          final sp = profile?.skillPoints ?? 0;
          final avatarConfig = profile?.avatarConfig != null
              ? AvatarConfig.fromJson(profile!.avatarConfig!)
              : const AvatarConfig();

          return Column(
            children: [
              // Balances Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SurfaceCard(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t('market_sp'), style: AppTypography.caption(context)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('$sp', style: AppTypography.metric(context, color: AppColors.warning)),
                                const Icon(Icons.stars, color: AppColors.warning, size: 24),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: SurfaceCard(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t('market_cr'), style: AppTypography.caption(context)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${avatarConfig.credits}', style: AppTypography.metric(context, color: AppColors.accent)),
                                const Icon(Icons.token, color: AppColors.accent, size: 24),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // Tabs
              Container(
                height: 45,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _buildTab(0, t('market_tab_boosters'), brightness),
                    _buildTab(1, t('market_tab_cosmetics'), brightness),
                  ],
                ),
              ),

              const SizedBox(height: 16.0),

              // Content
              Expanded(
                child: _selectedTabIndex == 0
                    ? _buildSpItems(sp, t)
                    : _buildCosmeticItems(avatarConfig, t),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${t('common_error')}: $e')),
      ),
    );
  }

  Widget _buildTab(int index, String title, Brightness brightness) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _selectedTabIndex = index);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.warning : Colors.transparent,
                width: 3.0,
              ),
            ),
            color: isSelected ? AppColors.warning.withValues(alpha: 0.1) : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppTypography.bodySmall(
              context,
              color: isSelected ? AppColors.warning : AppColors.textSecondary(brightness),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpItems(int sp, String Function(String) t) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        _buildMarketItem(
          name: t('market_streak_freeze'),
          description: t('market_streak_freeze_desc'),
          icon: Icons.ac_unit,
          color: AppColors.accent,
          costText: '2 SP',
          canAfford: sp >= 2,
          onBuy: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('market_integration_soon'))));
          },
        ),
        const SizedBox(height: 16.0),
        _buildMarketItem(
          name: t('market_common_lootbox'),
          description: t('market_common_lootbox_desc'),
          icon: Icons.inventory_2,
          color: Colors.blueAccent,
          costText: '1 SP',
          canAfford: sp >= 1,
          onBuy: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t('common_in_dev'))));
          },
        ),
      ],
    );
  }

  Widget _buildCosmeticItems(AvatarConfig config, String Function(String) t) {
    final brightness = Theme.of(context).brightness;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: [
        Text(t('market_exclusive_optics'), style: AppTypography.overline(context, color: AppColors.textPrimary(brightness))),
        const SizedBox(height: 12.0),
        _buildCosmeticItem(config, 'visor_terminator', t('market_terminator'), t('market_terminator_desc'), 50, Colors.redAccent, const AvatarConfig(visor: 'cyclops', colorHex: '#FF0000'), t),
        _buildCosmeticItem(config, 'visor_hacker', 'Holo-Band', t('market_item_holo_desc'), 75, AppColors.accent, const AvatarConfig(visor: 'dual', colorHex: '#00FFFF'), t),

        const SizedBox(height: 24.0),
        Text(t('market_premium_paints'), style: AppTypography.overline(context, color: AppColors.textPrimary(brightness))),
        const SizedBox(height: 12.0),
        _buildCosmeticItem(config, 'color_quantum', 'Quantum Purple', t('market_item_quantum_desc'), 100, Colors.purpleAccent, const AvatarConfig(colorHex: '#E040FB'), t),
        _buildCosmeticItem(config, 'color_gold', 'Neon Gold', t('market_item_gold_desc'), 150, AppColors.warning, const AvatarConfig(colorHex: '#FFD700'), t),

        const SizedBox(height: 24.0),
        Text(t('market_decals_scars'), style: AppTypography.overline(context, color: AppColors.textPrimary(brightness))),
        const SizedBox(height: 12.0),
        _buildCosmeticItem(config, 'decal_circuit', 'Circuit Board', t('market_item_circuit_desc'), 80, AppColors.success, const AvatarConfig(decal: 'striped', colorHex: '#00FF00'), t),
      ],
    );
  }

  Widget _buildCosmeticItem(
      AvatarConfig currentConfig,
      String itemId,
      String name,
      String description,
      int cost,
      Color color,
      AvatarConfig previewConfig,
      String Function(String) t) {
    final brightness = Theme.of(context).brightness;
    final bool isOwned = currentConfig.ownedItems.contains(itemId);
    final bool canAfford = currentConfig.credits >= cost;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: SurfaceCard(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            NeonAvatarWidget(config: previewConfig, size: 40.0, brightness: brightness),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTypography.h3(context)),
                  Text(description, style: AppTypography.caption(context)),
                ],
              ),
            ),
            if (isOwned)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                child: Text(t('market_purchased_badge'), style: AppTypography.overline(context, color: AppColors.success)),
              )
            else
              AppButton(
                label: '$cost CR',
                variant: canAfford ? ButtonVariant.secondary : ButtonVariant.ghost,
                fullWidth: false,
                onPressed: canAfford ? () => _buyCosmetic(currentConfig, cost, itemId, name) : null,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketItem({
    required String name,
    required String description,
    required IconData icon,
    required Color color,
    required String costText,
    required bool canAfford,
    required VoidCallback onBuy,
  }) {
    return SurfaceCard(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 36.0),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.overline(context, color: color)),
                const SizedBox(height: 4.0),
                Text(description, style: AppTypography.caption(context)),
              ],
            ),
          ),
          AppButton(
            label: costText,
            variant: canAfford ? ButtonVariant.secondary : ButtonVariant.ghost,
            fullWidth: false,
            onPressed: canAfford ? onBuy : null,
          ),
        ],
      ),
    );
  }
}
