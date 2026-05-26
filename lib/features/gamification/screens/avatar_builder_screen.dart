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
import '../../../data/database.dart';

class AvatarBuilderScreen extends ConsumerStatefulWidget {
  const AvatarBuilderScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AvatarBuilderScreen> createState() => _AvatarBuilderScreenState();
}

class _AvatarBuilderScreenState extends ConsumerState<AvatarBuilderScreen> {
  late AvatarConfig _currentConfig;
  int _selectedTabIndex = 0; // 0: Chassis, 1: Visor, 2: Colors, 3: Decals

  @override
  void initState() {
    super.initState();
    // Default config until we load from DB
    _currentConfig = const AvatarConfig();
    _loadInitialConfig();
  }

  Future<void> _loadInitialConfig() async {
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile != null && profile.avatarConfig != null && profile.avatarConfig!.isNotEmpty) {
      setState(() {
        _currentConfig = AvatarConfig.fromJson(profile.avatarConfig!);
      });
    }
  }

  Future<void> _saveConfig() async {
    HapticFeedback.heavyImpact();
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile != null) {
      await db.insertUserProfile(profile.copyWith(avatarConfig: Value(_currentConfig.toJson())));
      // ignore: unused_result
      ref.refresh(userProfileProvider);
      if (mounted) {
        final currentLocale = ref.read(localeProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.get(currentLocale, 'avatar_saved'))),
        );
        context.pop();
      }
    }
  }

  void _updateConfig({String? chassis, String? visor, String? colorHex, String? decal}) {
    HapticFeedback.lightImpact();
    setState(() {
      _currentConfig = _currentConfig.copyWith(
        chassis: chassis,
        visor: visor,
        colorHex: colorHex,
        decal: decal,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final int level = profileAsync.value?.level ?? 1;
    final brightness = Theme.of(context).brightness;
    final currentLocale = ref.watch(localeProvider);
    String t(String key) => AppLocalizations.get(currentLocale, key);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t('avatar_title'),
          style: AppTypography.h3(context, color: AppColors.accent),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary(brightness), size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Large Preview Area
          Expanded(
            flex: 2,
            child: Center(
              child: Hero(
                tag: 'avatar_preview',
                child: SurfaceCard(
                  padding: const EdgeInsets.all(32.0),
                  child: NeonAvatarWidget(config: _currentConfig, size: 200.0, brightness: brightness),
                ),
              ),
            ),
          ),

          // Tabs
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border(brightness))),
            ),
            child: Row(
              children: [
                _buildTab(0, t('avatar_tab_chassis'), brightness),
                _buildTab(1, t('avatar_tab_optics'), brightness),
                _buildTab(2, t('avatar_tab_neon'), brightness),
                _buildTab(3, t('avatar_tab_decals'), brightness),
              ],
            ),
          ),

          // Selection Area
          Expanded(
            flex: 3,
            child: _buildSelectionArea(level, _currentConfig.ownedItems, currentLocale, t),
          ),

          // Save Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppButton(
              label: t('avatar_save_btn'),
              variant: ButtonVariant.primary,
              onPressed: _saveConfig,
            ),
          ),
          const SizedBox(height: 20.0),
        ],
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
                color: isSelected ? AppColors.accent : Colors.transparent,
                width: 3.0,
              ),
            ),
            color: isSelected ? AppColors.accent.withOpacity(0.1) : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppTypography.bodySmall(
              context,
              color: isSelected ? AppColors.accent : AppColors.textSecondary(brightness),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionArea(int userLevel, List<String> ownedItems, String currentLocale, String Function(String) t) {
    switch (_selectedTabIndex) {
      case 0: // Chassis
        return GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(16.0),
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          children: [
            _buildOptionCard(
              title: t('avatar_chassis_standard'),
              isSelected: _currentConfig.chassis == 'standard',
              onTap: () => _updateConfig(chassis: 'standard'),
              preview: const AvatarConfig(chassis: 'standard', colorHex: '#FFFFFF'),
              currentLocale: currentLocale,
              t: t,
            ),
            _buildOptionCard(
              title: t('avatar_chassis_heavy'),
              isSelected: _currentConfig.chassis == 'heavy',
              isLocked: userLevel < 5,
              lockMessage: 'LVL 5',
              onTap: () => _updateConfig(chassis: 'heavy'),
              preview: const AvatarConfig(chassis: 'heavy', colorHex: '#FFFFFF'),
              currentLocale: currentLocale,
              t: t,
            ),
            _buildOptionCard(
              title: t('avatar_chassis_agile'),
              isSelected: _currentConfig.chassis == 'sleek',
              isLocked: userLevel < 10,
              lockMessage: 'LVL 10',
              onTap: () => _updateConfig(chassis: 'sleek'),
              preview: const AvatarConfig(chassis: 'sleek', colorHex: '#FFFFFF'),
              currentLocale: currentLocale,
              t: t,
            ),
          ],
        );
      case 1: // Visor
        return GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(16.0),
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          children: [
            _buildOptionCard(
              title: t('avatar_visor_cyclops'),
              isSelected: _currentConfig.visor == 'cyclops',
              onTap: () => _updateConfig(visor: 'cyclops'),
              preview: const AvatarConfig(visor: 'cyclops', colorHex: '#FFFFFF'),
              currentLocale: currentLocale,
              t: t,
            ),
            _buildOptionCard(
              title: t('avatar_visor_split'),
              isSelected: _currentConfig.visor == 'dual',
              isLocked: userLevel < 3,
              lockMessage: 'LVL 3',
              onTap: () => _updateConfig(visor: 'dual'),
              preview: const AvatarConfig(visor: 'dual', colorHex: '#FFFFFF'),
              currentLocale: currentLocale,
              t: t,
            ),
            _buildOptionCard(
              title: t('avatar_visor_sniper'),
              isSelected: _currentConfig.visor == 'scope',
              isLocked: userLevel < 7,
              lockMessage: 'LVL 7',
              onTap: () => _updateConfig(visor: 'scope'),
              preview: const AvatarConfig(visor: 'scope', colorHex: '#FFFFFF'),
              currentLocale: currentLocale,
              t: t,
            ),
            // Premium Visors
            _buildOptionCard(
              title: t('avatar_visor_terminator'),
              isSelected: _currentConfig.visor == 'visor_terminator',
              isLocked: !ownedItems.contains('visor_terminator'),
              lockMessage: 'MARKET',
              onTap: () => _updateConfig(visor: 'visor_terminator'),
              preview: const AvatarConfig(visor: 'cyclops', colorHex: '#FF0000'),
              currentLocale: currentLocale,
              t: t,
            ),
            _buildOptionCard(
              title: 'Holo-Band',
              isSelected: _currentConfig.visor == 'visor_hacker',
              isLocked: !ownedItems.contains('visor_hacker'),
              lockMessage: 'MARKET',
              onTap: () => _updateConfig(visor: 'visor_hacker'),
              preview: const AvatarConfig(visor: 'dual', colorHex: '#00FFFF'),
              currentLocale: currentLocale,
              t: t,
            ),
          ],
        );
      case 2: // Colors
        return GridView.count(
          crossAxisCount: 4,
          padding: const EdgeInsets.all(16.0),
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          children: [
            _buildColorCard('#00E5FF', t('avatar_color_cyan'), userLevel >= 1, 'L1', currentLocale),
            _buildColorCard('#FF00FF', t('avatar_color_magenta'), userLevel >= 1, 'L1', currentLocale),
            _buildColorCard('#FFD700', t('avatar_color_gold'), userLevel >= 5, 'L5', currentLocale),
            _buildColorCard('#FF3D00', t('avatar_color_fire'), userLevel >= 8, 'L8', currentLocale),
            _buildColorCard('#00E676', t('avatar_color_toxin'), userLevel >= 12, 'L12', currentLocale),
            // Premium Colors
            _buildColorCard('#E040FB', 'Quantum', ownedItems.contains('color_quantum'), 'CR', currentLocale),
            _buildColorCard('#FFD700', 'Elite Gold', ownedItems.contains('color_gold'), 'CR', currentLocale),
            _buildColorCard('#FFFFFF', t('avatar_color_clean'), userLevel >= 20, 'L20', currentLocale),
          ],
        );
      case 3: // Decals
        return GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(16.0),
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          children: [
            _buildOptionCard(
              title: t('avatar_decal_none'),
              isSelected: _currentConfig.decal == 'none',
              onTap: () => _updateConfig(decal: 'none'),
              preview: const AvatarConfig(decal: 'none', colorHex: '#FFFFFF'),
              currentLocale: currentLocale,
              t: t,
            ),
            _buildOptionCard(
              title: t('avatar_decal_stripes'),
              isSelected: _currentConfig.decal == 'striped',
              isLocked: userLevel < 4,
              lockMessage: 'LVL 4',
              onTap: () => _updateConfig(decal: 'striped'),
              preview: const AvatarConfig(decal: 'striped', colorHex: '#FFFFFF'),
              currentLocale: currentLocale,
              t: t,
            ),
            _buildOptionCard(
              title: t('avatar_decal_scar'),
              isSelected: _currentConfig.decal == 'scar',
              isLocked: userLevel < 9,
              lockMessage: 'LVL 9',
              onTap: () => _updateConfig(decal: 'scar'),
              preview: const AvatarConfig(decal: 'scar', colorHex: '#FFFFFF'),
              currentLocale: currentLocale,
              t: t,
            ),
            // Premium Decals
            _buildOptionCard(
              title: t('avatar_decal_circuits'),
              isSelected: _currentConfig.decal == 'decal_circuit',
              isLocked: !ownedItems.contains('decal_circuit'),
              lockMessage: 'MARKET',
              onTap: () => _updateConfig(decal: 'decal_circuit'),
              preview: const AvatarConfig(decal: 'striped', colorHex: '#00FF00'),
              currentLocale: currentLocale,
              t: t,
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOptionCard({
    required String title,
    required bool isSelected,
    bool isLocked = false,
    String? lockMessage,
    required VoidCallback onTap,
    required AvatarConfig preview,
    required String currentLocale,
    required String Function(String) t,
  }) {
    final brightness = Theme.of(context).brightness;
    return GestureDetector(
      onTap: isLocked ? () {
        if (lockMessage == 'MARKET') {
          // Navigate to Market
          context.push('/market');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.format(currentLocale, 'avatar_item_locked', {'message': lockMessage ?? ''}))),
          );
        }
      } : onTap,
      child: SurfaceCard(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: isLocked ? 0.2 : 1.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NeonAvatarWidget(config: preview, size: 50.0, brightness: brightness),
                  const SizedBox(height: 8.0),
                  Text(
                    title,
                    style: AppTypography.overline(
                      context,
                      color: isSelected
                          ? AppColors.textPrimary(brightness)
                          : AppColors.textSecondary(brightness),
                    ),
                  ),
                ],
              ),
            ),
            if (isLocked)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, color: AppColors.textSecondary(brightness), size: 30),
                  const SizedBox(height: 4.0),
                  Text(lockMessage ?? '', style: AppTypography.overline(context, color: AppColors.textSecondary(brightness)).copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCard(String hex, String title, bool isUnlocked, String lockLabel, String currentLocale) {
    final isSelected = _currentConfig.colorHex == hex;
    final color = Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));

    return GestureDetector(
      onTap: !isUnlocked ? () {
        if (lockLabel == 'CR') {
          context.push('/market');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.format(currentLocale, 'avatar_color_level', {'level': lockLabel}))),
          );
        }
      } : () => _updateConfig(colorHex: hex),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(isUnlocked ? 0.8 : 0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3.0,
          ),
        ),
        child: !isUnlocked
            ? Center(child: Text(lockLabel, style: const TextStyle(color: Colors.white70, fontSize: 10.0, fontWeight: FontWeight.bold)))
            : isSelected
                ? const Center(child: Icon(Icons.check, color: Colors.white))
                : null,
      ),
    );
  }
}
