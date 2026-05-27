import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';
import '../models/core_skill.dart';

// ─────────────────────────────────────────────
// Skill model
// ─────────────────────────────────────────────
class SkillNode {
  final String id;
  final String titleKey;
  final String descKey;
  final int cost;
  final IconData icon;
  final Color color;
  final int requiredLevel;
  final String? requiresSkill; // must be unlocked first
  final CoreSkillType branch;

  const SkillNode({
    required this.id,
    required this.titleKey,
    required this.descKey,
    required this.cost,
    required this.icon,
    required this.color,
    this.requiredLevel = 1,
    this.requiresSkill,
    required this.branch,
  });
}

final List<SkillNode> allSkillNodes = [
  // ── Hacker ──
  SkillNode(
    id: 'hacker_easter_egg',
    titleKey: 'skill_name_hacker',
    descKey: 'skill_ghost_desc',
    cost: 1,
    icon: Icons.code,
    color: CoreSkillSystem.getSkillColor(CoreSkillType.hacker),
    requiredLevel: 2,
    branch: CoreSkillType.hacker,
  ),
  SkillNode(
    id: 'hacker_crit_boost',
    titleKey: 'skill_crit_title',
    descKey: 'skill_crit_desc',
    cost: 2,
    icon: Icons.auto_awesome,
    color: CoreSkillSystem.getSkillColor(CoreSkillType.hacker),
    requiredLevel: 5,
    requiresSkill: 'hacker_easter_egg',
    branch: CoreSkillType.hacker,
  ),

  // ── Magnate ──
  SkillNode(
    id: 'magnate_xp_boost',
    titleKey: 'skill_dividends_title',
    descKey: 'skill_dividends_desc',
    cost: 1,
    icon: Icons.trending_up,
    color: CoreSkillSystem.getSkillColor(CoreSkillType.magnate),
    requiredLevel: 2,
    branch: CoreSkillType.magnate,
  ),
  SkillNode(
    id: 'magnate_discount',
    titleKey: 'skill_trade_title',
    descKey: 'skill_trade_desc',
    cost: 2,
    icon: Icons.local_offer_rounded,
    color: CoreSkillSystem.getSkillColor(CoreSkillType.magnate),
    requiredLevel: 5,
    requiresSkill: 'magnate_xp_boost',
    branch: CoreSkillType.magnate,
  ),

  // ── Resilience ──
  SkillNode(
    id: 'resilience_shield',
    titleKey: 'skill_shield_title',
    descKey: 'skill_shield_desc',
    cost: 2,
    icon: Icons.shield_rounded,
    color: CoreSkillSystem.getSkillColor(CoreSkillType.resilience),
    requiredLevel: 2,
    branch: CoreSkillType.resilience,
  ),
  SkillNode(
    id: 'resilience_penalty_reduction',
    titleKey: 'skill_iron_title',
    descKey: 'skill_iron_desc',
    cost: 3,
    icon: Icons.security,
    color: CoreSkillSystem.getSkillColor(CoreSkillType.resilience),
    requiredLevel: 5,
    requiresSkill: 'resilience_shield',
    branch: CoreSkillType.resilience,
  ),
];

// ─────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────
class SkillTreeScreen extends ConsumerWidget {
  const SkillTreeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final skillsAsync = ref.watch(unlockedSkillsProvider);
    final brightness = Theme.of(context).brightness;
    final currentLocale = ref.watch(localeProvider);
    String t(String key) => AppLocalizations.get(currentLocale, key);

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: AppColors.textPrimary(brightness), size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          t('skill_title'),
          style: AppTypography.h3(context, color: AppColors.warning),
        ),
        actions: [
          profileAsync.when(
            data: (profile) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _SpBadge(sp: profile?.skillPoints ?? 0),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: skillsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${t('skill_error')}$e', style: TextStyle(color: AppColors.error))),
        data: (unlocked) {
          final unlockedIds = unlocked.map((s) => s.id).toSet();
          final sp = profileAsync.value?.skillPoints ?? 0;
          final hackerLvl = CoreSkillSystem.getLevelFromXp(profileAsync.value?.hackerXp ?? 0);
          final magnateLvl = CoreSkillSystem.getLevelFromXp(profileAsync.value?.magnateXp ?? 0);
          final resilienceLvl = CoreSkillSystem.getLevelFromXp(profileAsync.value?.resilienceXp ?? 0);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              _buildSkillPillar(
                context: context,
                ref: ref,
                type: CoreSkillType.hacker,
                level: hackerLvl,
                xp: profileAsync.value?.hackerXp ?? 0,
                sp: sp,
                unlockedIds: unlockedIds,
                t: t,
              ),
              const SizedBox(height: 32),
              _buildSkillPillar(
                context: context,
                ref: ref,
                type: CoreSkillType.magnate,
                level: magnateLvl,
                xp: profileAsync.value?.magnateXp ?? 0,
                sp: sp,
                unlockedIds: unlockedIds,
                t: t,
              ),
              const SizedBox(height: 32),
              _buildSkillPillar(
                context: context,
                ref: ref,
                type: CoreSkillType.resilience,
                level: resilienceLvl,
                xp: profileAsync.value?.resilienceXp ?? 0,
                sp: sp,
                unlockedIds: unlockedIds,
                t: t,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSkillPillar({
    required BuildContext context,
    required WidgetRef ref,
    required CoreSkillType type,
    required int level,
    required int xp,
    required int sp,
    required Set<String> unlockedIds,
    required String Function(String) t,
  }) {
    final brightness = Theme.of(context).brightness;
    final color = CoreSkillSystem.getSkillColor(type);
    final name = CoreSkillSystem.getSkillName(type);
    final icon = CoreSkillSystem.getSkillIcon(type);
    final progress = CoreSkillSystem.getProgressToNextLevel(xp);

    final nodes = allSkillNodes.where((n) => n.branch == type).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(brightness),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.toUpperCase(),
                      style: AppTypography.h3(context, color: color),
                    ),
                    Text(
                      'Level $level',
                      style: AppTypography.caption(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surfaceMuted(brightness),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 16),
          ...nodes.map((node) {
            final isUnlocked = unlockedIds.contains(node.id);
            final reqMet = level >= node.requiredLevel;
            final depMet = node.requiresSkill == null || unlockedIds.contains(node.requiresSkill);
            final canUnlock = !isUnlocked && reqMet && depMet && sp >= node.cost;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SkillNodeCard(
                node: node,
                isUnlocked: isUnlocked,
                canUnlock: canUnlock,
                isLocked: !reqMet || !depMet,
                locale: ref.read(localeProvider),
                onTap: () {
                  if (canUnlock) {
                    _unlockSkill(context, ref, node);
                  } else if (!isUnlocked) {
                    String msg = '${t('skill_req_level')}${node.cost} SP.';
                    if (!reqMet) {
                      msg +=
                          ' ${t('skill_req_text')}$name: ${node.requiredLevel}.';
                    }
                    if (!depMet) msg += ' ${t('skill_locked_dep')}';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(msg)),
                    );
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _unlockSkill(BuildContext context, WidgetRef ref, SkillNode node) async {
    HapticFeedback.mediumImpact();
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile == null || profile.skillPoints < node.cost) return;

    await db.transaction(() async {
      await db.unlockSkill(node.id);
      final newSp = profile.skillPoints - node.cost;
      await db.updateUserProfile(profile.copyWith(skillPoints: newSp));
    });

    ref.invalidate(userProfileProvider);
    ref.invalidate(unlockedSkillsProvider);
  }
}

// ─────────────────────────────────────────────
// Components
// ─────────────────────────────────────────────
class _SkillNodeCard extends StatelessWidget {
  final SkillNode node;
  final bool isUnlocked;
  final bool canUnlock;
  final bool isLocked;
  final VoidCallback onTap;
  final String locale;

  const _SkillNodeCard({
    required this.node,
    required this.isUnlocked,
    required this.canUnlock,
    required this.isLocked,
    required this.onTap,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    final borderColor = isUnlocked
        ? node.color
        : canUnlock
            ? node.color.withValues(alpha: 0.5)
            : AppColors.border(brightness);

    final iconColor = isUnlocked ? node.color : AppColors.textDisabled(brightness);
    final titleColor = isUnlocked
        ? AppColors.textPrimary(brightness)
        : AppColors.textSecondary(brightness);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnlocked ? node.color.withValues(alpha: 0.1) : Colors.transparent,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isUnlocked ? node.color.withValues(alpha: 0.2) : AppColors.surfaceMuted(brightness),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLocked ? Icons.lock_outline : node.icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.get(locale, node.titleKey),
                    style: AppTypography.h3(context, color: titleColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.get(locale, node.descKey),
                    style: AppTypography.caption(context),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (isUnlocked)
              Icon(Icons.check_circle, color: node.color, size: 24)
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: canUnlock ? node.color : AppColors.surfaceMuted(brightness),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${node.cost} SP',
                  style: TextStyle(
                    color: canUnlock ? AppColors.background(brightness) : AppColors.textSecondary(brightness),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SpBadge extends StatelessWidget {
  final int sp;
  const _SpBadge({required this.sp});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface(brightness),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.stars_rounded, color: AppColors.warning, size: 16),
          const SizedBox(width: 6),
          Text(
            '$sp SP',
            style: AppTypography.bodySmall(context, color: AppColors.textPrimary(brightness)),
          ),
        ],
      ),
    );
  }
}
