import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' show Value;

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/neon_avatar_painter.dart';
import '../../../core/widgets/neon_button.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Кібер-Аватар успішно збережено!')),
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'RPG АВАТАР',
          style: AppTextStyles.orbitronHeading(
            fontSize: 18.0,
            color: AppColors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
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
                child: GlassCard(
                  padding: const EdgeInsets.all(32.0),
                  borderColor: _currentConfig.primaryColor.withOpacity(0.5),
                  glowColor: _currentConfig.primaryColor.withOpacity(0.2),
                  child: NeonAvatarWidget(config: _currentConfig, size: 200.0),
                ),
              ),
            ),
          ),

          // Tabs
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderNeon.withOpacity(0.3))),
            ),
            child: Row(
              children: [
                _buildTab(0, 'КАРКАС'),
                _buildTab(1, 'ОПТИКА'),
                _buildTab(2, 'НЕОН'),
                _buildTab(3, 'ДЕКАЛІ'),
              ],
            ),
          ),

          // Selection Area
          Expanded(
            flex: 3,
            child: _buildSelectionArea(level, _currentConfig.ownedItems),
          ),

          // Save Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: NeonButton(
              text: 'ЗБЕРЕГТИ КОНФІГУРАЦІЮ',
              baseColor: _currentConfig.primaryColor,
              glowColor: _currentConfig.primaryColor,
              onPressed: _saveConfig,
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String title) {
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
                color: isSelected ? AppColors.cyanAccent : Colors.transparent,
                width: 3.0,
              ),
            ),
            color: isSelected ? AppColors.cyanAccent.withOpacity(0.1) : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppTextStyles.rajdhaniMedium(
              fontSize: 14.0,
              color: isSelected ? AppColors.cyanAccent : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionArea(int userLevel, List<String> ownedItems) {
    switch (_selectedTabIndex) {
      case 0: // Chassis
        return GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(16.0),
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          children: [
            _buildOptionCard(
              title: 'Стандарт',
              isSelected: _currentConfig.chassis == 'standard',
              onTap: () => _updateConfig(chassis: 'standard'),
              preview: const AvatarConfig(chassis: 'standard', colorHex: '#FFFFFF'),
            ),
            _buildOptionCard(
              title: 'Важкий',
              isSelected: _currentConfig.chassis == 'heavy',
              isLocked: userLevel < 5,
              lockMessage: 'LVL 5',
              onTap: () => _updateConfig(chassis: 'heavy'),
              preview: const AvatarConfig(chassis: 'heavy', colorHex: '#FFFFFF'),
            ),
            _buildOptionCard(
              title: 'Спритний',
              isSelected: _currentConfig.chassis == 'sleek',
              isLocked: userLevel < 10,
              lockMessage: 'LVL 10',
              onTap: () => _updateConfig(chassis: 'sleek'),
              preview: const AvatarConfig(chassis: 'sleek', colorHex: '#FFFFFF'),
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
              title: 'Циклоп',
              isSelected: _currentConfig.visor == 'cyclops',
              onTap: () => _updateConfig(visor: 'cyclops'),
              preview: const AvatarConfig(visor: 'cyclops', colorHex: '#FFFFFF'),
            ),
            _buildOptionCard(
              title: 'Спліт',
              isSelected: _currentConfig.visor == 'dual',
              isLocked: userLevel < 3,
              lockMessage: 'LVL 3',
              onTap: () => _updateConfig(visor: 'dual'),
              preview: const AvatarConfig(visor: 'dual', colorHex: '#FFFFFF'),
            ),
            _buildOptionCard(
              title: 'Снайпер',
              isSelected: _currentConfig.visor == 'scope',
              isLocked: userLevel < 7,
              lockMessage: 'LVL 7',
              onTap: () => _updateConfig(visor: 'scope'),
              preview: const AvatarConfig(visor: 'scope', colorHex: '#FFFFFF'),
            ),
            // Premium Visors
            _buildOptionCard(
              title: 'Термінатор',
              isSelected: _currentConfig.visor == 'visor_terminator',
              isLocked: !ownedItems.contains('visor_terminator'),
              lockMessage: 'MARKET',
              onTap: () => _updateConfig(visor: 'visor_terminator'),
              preview: const AvatarConfig(visor: 'cyclops', colorHex: '#FF0000'),
            ),
            _buildOptionCard(
              title: 'Holo-Band',
              isSelected: _currentConfig.visor == 'visor_hacker',
              isLocked: !ownedItems.contains('visor_hacker'),
              lockMessage: 'MARKET',
              onTap: () => _updateConfig(visor: 'visor_hacker'),
              preview: const AvatarConfig(visor: 'dual', colorHex: '#00FFFF'),
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
            _buildColorCard('#00E5FF', 'Ціан', userLevel >= 1, 'L1'),
            _buildColorCard('#FF00FF', 'Маджента', userLevel >= 1, 'L1'),
            _buildColorCard('#FFD700', 'Золото', userLevel >= 5, 'L5'),
            _buildColorCard('#FF3D00', 'Вогонь', userLevel >= 8, 'L8'),
            _buildColorCard('#00E676', 'Токсин', userLevel >= 12, 'L12'),
            // Premium Colors
            _buildColorCard('#E040FB', 'Quantum', ownedItems.contains('color_quantum'), 'CR'),
            _buildColorCard('#FFD700', 'Elite Gold', ownedItems.contains('color_gold'), 'CR'),
            _buildColorCard('#FFFFFF', 'Чистота', userLevel >= 20, 'L20'),
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
              title: 'Немає',
              isSelected: _currentConfig.decal == 'none',
              onTap: () => _updateConfig(decal: 'none'),
              preview: const AvatarConfig(decal: 'none', colorHex: '#FFFFFF'),
            ),
            _buildOptionCard(
              title: 'Смуги',
              isSelected: _currentConfig.decal == 'striped',
              isLocked: userLevel < 4,
              lockMessage: 'LVL 4',
              onTap: () => _updateConfig(decal: 'striped'),
              preview: const AvatarConfig(decal: 'striped', colorHex: '#FFFFFF'),
            ),
            _buildOptionCard(
              title: 'Шрам',
              isSelected: _currentConfig.decal == 'scar',
              isLocked: userLevel < 9,
              lockMessage: 'LVL 9',
              onTap: () => _updateConfig(decal: 'scar'),
              preview: const AvatarConfig(decal: 'scar', colorHex: '#FFFFFF'),
            ),
            // Premium Decals
            _buildOptionCard(
              title: 'Схеми',
              isSelected: _currentConfig.decal == 'decal_circuit',
              isLocked: !ownedItems.contains('decal_circuit'),
              lockMessage: 'MARKET',
              onTap: () => _updateConfig(decal: 'decal_circuit'),
              preview: const AvatarConfig(decal: 'striped', colorHex: '#00FF00'),
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
  }) {
    return GestureDetector(
      onTap: isLocked ? () {
        if (lockMessage == 'MARKET') {
          // Navigate to Market
          context.push('/market');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Цей предмет заблоковано ($lockMessage)!')),
          );
        }
      } : onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(8.0),
        borderColor: isSelected ? AppColors.cyanAccent : AppColors.borderNeon.withOpacity(0.3),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: isLocked ? 0.2 : 1.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NeonAvatarWidget(config: preview, size: 50.0),
                  const SizedBox(height: 8.0),
                  Text(
                    title,
                    style: AppTextStyles.orbitronHeading(
                      fontSize: 10.0,
                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isLocked)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, color: AppColors.textSecondary, size: 30),
                  const SizedBox(height: 4.0),
                  Text(lockMessage ?? '', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10.0, fontWeight: FontWeight.bold)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCard(String hex, String title, bool isUnlocked, String lockLabel) {
    final isSelected = _currentConfig.colorHex == hex;
    final color = Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));

    return GestureDetector(
      onTap: !isUnlocked ? () {
        if (lockLabel == 'CR') {
          context.push('/market');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Колір відкривається на рівні $lockLabel!')),
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
          boxShadow: isSelected ? [
            BoxShadow(color: color.withOpacity(0.5), blurRadius: 10.0, spreadRadius: 2.0)
          ] : null,
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
