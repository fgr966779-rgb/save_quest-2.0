import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/database.dart';
import 'package:drift/drift.dart' as drift;

class LootboxScreen extends ConsumerStatefulWidget {
  const LootboxScreen({super.key});

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
      final currentLocale = ref.read(localeProvider);
      setState(() {
        _isOpening = false;
        if (xpReward > 0) _openedReward = '+$xpReward XP';
        if (freezeReward > 0) _openedReward = '+$freezeReward FREEZE TOKEN';
      });

      final brightness = Theme.of(context).brightness;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.surface(brightness),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.border(brightness)),
          ),
          title: Text(
            AppLocalizations.get(currentLocale, 'loot_opened_title'),
            style: AppTypography.h2(
              context,
              color: AppColors.warning,
            ),
          ),
          content: Text(
            '${AppLocalizations.get(currentLocale, 'loot_your_reward')}\n\n$_openedReward',
            style: AppTypography.body(context),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _openedReward = null);
              },
              child: Text(AppLocalizations.get(currentLocale, 'loot_awesome_btn'), style: TextStyle(color: AppColors.accent)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final currentLocale = ref.watch(localeProvider);
    String t(String key) => AppLocalizations.get(currentLocale, key);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t('loot_title'),
          style: AppTypography.h2(context),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary(brightness), size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<List<Lootbox>>(
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
                  Icon(Icons.card_giftcard, size: 80, color: AppColors.textTertiary(brightness)),
                  const SizedBox(height: 16),
                  Text(t('loot_empty'), style: AppTypography.body(context)),
                  const SizedBox(height: 8),
                  Text(t('loot_empty_hint'), style: AppTypography.bodySmall(context)),
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
                  final color = isRare ? AppColors.warning : AppColors.accent;

                  return SurfaceCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2, size: 60, color: color),
                        const SizedBox(height: 12),
                        Text(
                          isRare ? t('loot_rarity_rare') : t('loot_rarity_common'),
                          style: AppTypography.overline(context, color: color),
                        ),
                        const Spacer(),
                        AppButton(
                          label: t('loot_open_btn'),
                          variant: ButtonVariant.primary,
                          onPressed: _isOpening ? null : () => _openLootbox(box),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (_isOpening)
                Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: AppColors.accent),
                        const SizedBox(height: 16),
                        Text(t('loot_opening'), style: TextStyle(color: Colors.white)),
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
