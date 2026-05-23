import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/neon_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../data/database.dart';
import 'package:drift/drift.dart' as drift;

class LootboxScreen extends ConsumerStatefulWidget {
  const LootboxScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LootboxScreen> createState() => _LootboxScreenState();
}

class _LootboxScreenState extends ConsumerState<LootboxScreen> with TickerProviderStateMixin {
  bool _isOpening = false;
  String? _openedReward;
  
  Future<void> _openLootbox(Lootbox box) async {
    setState(() {
      _isOpening = true;
      _openedReward = null;
    });

    // Simulate opening animation delay
    await Future.delayed(const Duration(seconds: 2));

    // Determine reward
    final random = Random();
    int xpReward = 0;
    int freezeReward = 0;
    
    if (box.rarity == 'rare') {
      if (random.nextBool()) {
        xpReward = 200;
      } else {
        freezeReward = 2;
      }
    } else { // common
      if (random.nextDouble() > 0.2) {
        xpReward = 50;
      } else {
        freezeReward = 1;
      }
    }

    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    
    if (profile != null) {
      await db.transaction(() async {
        // Mark opened
        await (db.update(db.lootboxes)..where((t) => t.id.equals(box.id))).write(
          const LootboxesCompanion(isOpened: drift.Value(true)),
        );
        
        // Grant reward
        var updated = profile;
        if (xpReward > 0) updated = updated.copyWith(xp: profile.xp + xpReward);
        if (freezeReward > 0) updated = updated.copyWith(freezeTokens: profile.freezeTokens + freezeReward);
        await db.insertUserProfile(updated);
      });
      // ignore: unused_result
      ref.refresh(userProfileProvider);
    }

    if (mounted) {
      setState(() {
        _isOpening = false;
        if (xpReward > 0) _openedReward = '+$xpReward XP';
        if (freezeReward > 0) _openedReward = '+$freezeReward FREEZE TOKEN';
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.background,
          title: Text('ЛУТБОКС ВІДКРИТО!', style: AppTextStyles.orbitronHeading(fontSize: 18, color: AppColors.goldGlow)),
          content: Text('Ваша нагорода:\n\n$_openedReward', style: const TextStyle(color: Colors.white, fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _openedReward = null);
              },
              child: const Text('КРУТО!', style: TextStyle(color: AppColors.cyanAccent)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'ЛУТБОКСИ',
          style: AppTextStyles.orbitronHeading(
            fontSize: 18.0,
            color: Colors.purpleAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<List<Lootbox>>(
        // Rebuild when future changes
        future: (ref.read(databaseProvider).select(ref.read(databaseProvider).lootboxes)
          ..where((t) => t.isOpened.equals(false))).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData && !_isOpening) return const Center(child: CircularProgressIndicator());
          
          final boxes = snapshot.data ?? [];
          if (boxes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.card_giftcard, size: 80, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  Text('У вас немає закритих лутбоксів.', style: AppTextStyles.rajdhaniMedium(fontSize: 16, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  const Text('Робіть внески, щоб отримати шанс на дроп!', style: TextStyle(color: AppColors.textMuted)),
                ],
              ),
            );
          }

          return Stack(
            children: [
              GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: boxes.length,
                itemBuilder: (context, index) {
                  final box = boxes[index];
                  final isRare = box.rarity == 'rare';
                  final color = isRare ? AppColors.goldGlow : Colors.blueAccent;

                  return GlassCard(
                    borderColor: color.withOpacity(0.5),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2, size: 60, color: color),
                        const SizedBox(height: 12),
                        Text(
                          isRare ? 'РІДКІСНИЙ' : 'ЗВИЧАЙНИЙ',
                          style: AppTextStyles.orbitronHeading(fontSize: 12, color: color, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        NeonButton(
                          text: 'ВІДКРИТИ',
                          baseColor: color,
                          glowColor: color,
                          onPressed: _isOpening ? null : () => _openLootbox(box),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (_isOpening)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: AppColors.magentaAccent),
                        SizedBox(height: 16),
                        Text('Відкриття лутбоксу...', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
