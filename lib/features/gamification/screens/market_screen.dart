import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:drift/drift.dart' show Value;

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/neon_avatar_painter.dart';
import '../../../data/database.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  int _selectedTabIndex = 0; // 0: SP Items, 1: Cosmetics (Credits)

  Future<void> _buyCosmetic(AvatarConfig currentConfig, int cost, String itemId, String itemName) async {
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile == null) return;

    if (currentConfig.credits < cost) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Недостатньо Кібер-Кредитів!'), backgroundColor: Colors.redAccent),
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
        SnackBar(content: Text('Придбано: $itemName! Тепер він доступний у конструкторі.'), backgroundColor: AppColors.cyanAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'ЧОРНИЙ РИНОК',
          style: AppTextStyles.orbitronHeading(
            fontSize: 18.0,
            color: AppColors.goldGlow,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
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
                      child: GlassCard(
                        padding: const EdgeInsets.all(12.0),
                        borderColor: AppColors.goldGlow.withOpacity(0.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SKILL POINTS', style: AppTextStyles.rajdhaniMedium(fontSize: 12.0, color: AppColors.textSecondary)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('$sp', style: AppTextStyles.orbitronHeading(fontSize: 24.0, color: AppColors.goldGlow)),
                                const Icon(Icons.stars, color: AppColors.goldGlow, size: 24),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.all(12.0),
                        borderColor: AppColors.cyanAccent.withOpacity(0.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('КІБЕР-КРЕДИТИ', style: AppTextStyles.rajdhaniMedium(fontSize: 12.0, color: AppColors.textSecondary)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${avatarConfig.credits}', style: AppTextStyles.orbitronHeading(fontSize: 24.0, color: AppColors.cyanAccent)),
                                const Icon(Icons.token, color: AppColors.cyanAccent, size: 24),
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
                    _buildTab(0, 'БУСТЕРИ (SP)'),
                    _buildTab(1, 'КОСМЕТИКА (CR)'),
                  ],
                ),
              ),
              
              const SizedBox(height: 16.0),

              // Content
              Expanded(
                child: _selectedTabIndex == 0 
                  ? _buildSpItems(sp) 
                  : _buildCosmeticItems(avatarConfig),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
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
                color: isSelected ? AppColors.goldGlow : Colors.transparent,
                width: 3.0,
              ),
            ),
            color: isSelected ? AppColors.goldGlow.withOpacity(0.1) : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: AppTextStyles.rajdhaniMedium(
              fontSize: 14.0,
              color: isSelected ? AppColors.goldGlow : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpItems(int sp) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        _buildMarketItem(
          name: 'ЗАМОРОЖЕННЯ СТРІКУ',
          description: 'Дозволяє пропустити 1 день без втрати серії.',
          icon: Icons.ac_unit,
          color: AppColors.cyanAccent,
          costText: '2 SP',
          canAfford: sp >= 2,
          onBuy: () {
            // Logic handled via standard SP purchase (simplified here for brevity since focus is Cosmetics)
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('В розробці: Будуть інтегровані в наступному патчі.')));
          },
        ),
        const SizedBox(height: 16.0),
        _buildMarketItem(
          name: 'ЗВИЧАЙНИЙ ЛУТБОКС',
          description: 'Містить випадкову нагороду.',
          icon: Icons.inventory_2,
          color: Colors.blueAccent,
          costText: '1 SP',
          canAfford: sp >= 1,
          onBuy: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('В розробці')));
          },
        ),
      ],
    );
  }

  Widget _buildCosmeticItems(AvatarConfig config) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: [
        Text('ЕКСКЛЮЗИВНА ОПТИКА', style: AppTextStyles.orbitronHeading(fontSize: 14.0, color: AppColors.textPrimary)),
        const SizedBox(height: 12.0),
        _buildCosmeticItem(config, 'visor_terminator', 'Термінатор', 'Червоне кібер-око', 50, Colors.redAccent, const AvatarConfig(visor: 'cyclops', colorHex: '#FF0000')),
        _buildCosmeticItem(config, 'visor_hacker', 'Holo-Band', 'Голографічна смуга', 75, AppColors.cyanAccent, const AvatarConfig(visor: 'dual', colorHex: '#00FFFF')),
        
        const SizedBox(height: 24.0),
        Text('ПРЕМІУМ ФАРБИ', style: AppTextStyles.orbitronHeading(fontSize: 14.0, color: AppColors.textPrimary)),
        const SizedBox(height: 12.0),
        _buildCosmeticItem(config, 'color_quantum', 'Quantum Purple', 'Абсолютний неон', 100, Colors.purpleAccent, const AvatarConfig(colorHex: '#E040FB')),
        _buildCosmeticItem(config, 'color_gold', 'Neon Gold', 'Сяйво еліти', 150, AppColors.goldGlow, const AvatarConfig(colorHex: '#FFD700')),
        
        const SizedBox(height: 24.0),
        Text('ДЕКАЛІ ТА ШРАМИ', style: AppTextStyles.orbitronHeading(fontSize: 14.0, color: AppColors.textPrimary)),
        const SizedBox(height: 12.0),
        _buildCosmeticItem(config, 'decal_circuit', 'Circuit Board', 'Електронні доріжки', 80, Colors.greenAccent, const AvatarConfig(decal: 'striped', colorHex: '#00FF00')),
      ],
    );
  }

  Widget _buildCosmeticItem(AvatarConfig currentConfig, String itemId, String name, String description, int cost, Color color, AvatarConfig previewConfig) {
    final bool isOwned = currentConfig.ownedItems.contains(itemId);
    final bool canAfford = currentConfig.credits >= cost;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: GlassCard(
        padding: const EdgeInsets.all(12.0),
        borderColor: isOwned ? color.withOpacity(0.5) : AppColors.borderNeon.withOpacity(0.2),
        child: Row(
          children: [
            NeonAvatarWidget(config: previewConfig, size: 40.0),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.rajdhaniMedium(fontSize: 16.0, color: Colors.white)),
                  Text(description, style: const TextStyle(fontSize: 10.0, color: AppColors.textSecondary)),
                ],
              ),
            ),
            if (isOwned)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                child: const Text('ПРИДБАНО', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            else
              NeonButton(
                text: '$cost CR',
                baseColor: canAfford ? AppColors.cyanAccent : AppColors.textMuted,
                glowColor: Colors.transparent,
                height: 32,
                width: 80,
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
    return GlassCard(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 36.0),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.orbitronHeading(fontSize: 14.0, color: color)),
                const SizedBox(height: 4.0),
                Text(description, style: const TextStyle(fontSize: 11.0, color: AppColors.textSecondary)),
              ],
            ),
          ),
          NeonButton(
            text: costText,
            baseColor: canAfford ? AppColors.goldGlow : AppColors.textMuted,
            glowColor: Colors.transparent,
            height: 36,
            width: 70,
            onPressed: canAfford ? onBuy : null,
          ),
        ],
      ),
    );
  }
}
