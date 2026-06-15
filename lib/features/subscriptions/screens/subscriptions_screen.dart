// FILE: lib/features/subscriptions/screens/subscriptions_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import '../providers/subscription_provider.dart';
import '../services/subscription_service.dart';
import '../widgets/subscription_card.dart';
import '../widgets/add_subscription_sheet.dart';

class SubscriptionsScreen extends ConsumerStatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  ConsumerState<SubscriptionsScreen> createState() =>
      _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends ConsumerState<SubscriptionsScreen> {
  bool _unlocked = false;

  static const _kDisclaimerKey = 'sub_ninja_disclaimer_shown';

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    final auth = LocalAuthentication();
    final canAuth = await auth.canCheckBiometrics;
    if (canAuth) {
      final authenticated = await auth.authenticate(
        localizedReason: 'Підтвердьте особу для перегляду підписок',
        options: const AuthenticationOptions(stickyAuth: true),
      );
      if (mounted) setState(() => _unlocked = authenticated);
    } else {
      // Biometrics not available — allow access
      if (mounted) setState(() => _unlocked = true);
    }
    // Show disclaimer only once ever (stored in SharedPreferences)
    if (_unlocked) {
      final prefs = await SharedPreferences.getInstance();
      final shown = prefs.getBool(_kDisclaimerKey) ?? false;
      if (!shown) {
        await prefs.setBool(_kDisclaimerKey, true);
        Future.microtask(() => _showDisclaimer());
      }
    }
  }

  void _showDisclaimer() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D0D1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF00FF9D), width: 1),
        ),
        title: Row(children: [
          const Icon(Icons.lock_outline, color: Color(0xFF00FF9D), size: 20),
          const SizedBox(width: 8),
          Text('Повна приватність',
              style: GoogleFonts.spaceMono(
                  color: const Color(0xFF00FF9D), fontSize: 14)),
        ]),
        content: Text(
          'Цей трекер працює повністю офлайн.\nВаші дані ніколи не залишають пристрій.',
          style: GoogleFonts.spaceMono(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Зрозуміло 🥷',
                style: GoogleFonts.spaceMono(color: const Color(0xFF00FF9D))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_unlocked) {
      return Scaffold(
        backgroundColor: const Color(0xFF0D0D1A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fingerprint, color: Color(0xFF00FF9D), size: 72),
              const SizedBox(height: 16),
              Text('Subscription Ninja',
                  style: GoogleFonts.orbitron(
                      color: Colors.white, fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Потрібна біометрична аутентифікація',
                  style: GoogleFonts.spaceMono(
                      color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.fingerprint, color: Color(0xFF00FF9D)),
                label: Text('Розблокувати',
                    style: GoogleFonts.spaceMono(
                        color: const Color(0xFF00FF9D))),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF00FF9D))),
              ),
            ],
          ),
        ),
      );
    }

    final subsAsync = ref.watch(subscriptionsStreamProvider);
    final totalAsync = ref.watch(totalMonthlyCostProvider);
    final countAsync = ref.watch(cancellationCountProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '🥷 Subscription Ninja',
          style: GoogleFonts.orbitron(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF00FF9D)),
            onPressed: () => _showAddSheet(context),
            tooltip: 'Додати паразита',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Stats header ────────────────────────────────────────────────
          _StatsHeader(totalAsync: totalAsync, cancelCountAsync: countAsync),

          // ── List ────────────────────────────────────────────────────────
          Expanded(
            child: subsAsync.when(
              data: (subs) {
                if (subs.isEmpty) {
                  return _EmptyState(onAdd: () => _showAddSheet(context));
                }
                final active = subs.where((s) => s.isActive).toList();
                final dead = subs.where((s) => !s.isActive).toList();
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  children: [
                    if (active.isNotEmpty) ...[
                      _SectionLabel('⚡ АКТИВНІ ПАРАЗИТИ [${active.length}]'),
                      ...active.map((s) => SubscriptionCard(
                            subscription: s,
                            onKill: () => _onKill(s),
                            onPaid: () => _onPaid(s),
                            onConfirmActive: () => _onPaid(s),
                          )),
                    ],
                    if (dead.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _SectionLabel('✅ ЗНИЩЕНІ ПАРАЗИТИ [${dead.length}]'),
                      ...dead.map((s) => SubscriptionCard(
                            subscription: s,
                            onKill: null,
                            onPaid: null,
                          )),
                    ],
                  ],
                );
              },
              loading: () => const Center(
                  child: CircularProgressIndicator(
                      color: Color(0xFF00FF9D))),
              error: (e, _) => Center(
                  child: Text('Error: $e',
                      style: GoogleFonts.spaceMono(
                          color: Colors.redAccent))),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context),
        backgroundColor: const Color(0xFF00FF9D),
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddSubscriptionSheet(),
    );
  }

  Future<void> _onKill(Subscription sub) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D0D1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFFF3B30), width: 1),
        ),
        title: Text('💀 Знищити паразита?',
            style: GoogleFonts.orbitron(
                color: const Color(0xFFFF3B30), fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${sub.name} більше не буде списувати кошти.',
                style: GoogleFonts.spaceMono(
                    color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF00FF9D).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF00FF9D), width: 0.5),
              ),
              child: Row(children: [
                const Icon(Icons.bolt, color: Color(0xFF00FF9D), size: 18),
                const SizedBox(width: 8),
                Text('+${SubscriptionService.kXpPerCancel} XP за перемогу!',
                    style: GoogleFonts.spaceMono(
                        color: const Color(0xFF00FF9D), fontSize: 12)),
              ]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Скасувати',
                style: GoogleFonts.spaceMono(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3B30)),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Знищити 🗡️',
                style: GoogleFonts.spaceMono(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final service = ref.read(subscriptionServiceProvider);
    final amountKopecks = await service.cancelSubscription(sub.id);
    final count = await service.recordCancellation();

    if (!mounted) return;

    // Award XP via investment service
    final db = ref.read(databaseProvider);
    final profile = await db.getUserProfile();
    if (profile != null) {
      await db.updateUserProfile(profile.copyWith(
        xp: profile.xp + SubscriptionService.kXpPerCancel,
      ));
    }

    final amountStr =
        '${(amountKopecks / 100).toStringAsFixed(0)} ₴';
    _showKillReward(sub.name, amountStr, amountKopecks, count >= 3);
  }

  Future<void> _onPaid(Subscription sub) async {
    await ref.read(subscriptionServiceProvider).markAsPaid(sub);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: const Color(0xFF00FF9D).withValues(alpha: 0.9),
        content: Text('✅ ${sub.name} — оплата підтверджена',
            style: GoogleFonts.spaceMono(color: Colors.black)),
      ));
    }
  }

  void _showKillReward(
      String name, String amount, int kopecks, bool badgeEarned) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D0D1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF00FF9D), width: 1.5),
        ),
        title: Text('⚔️ Паразита знищено!',
            style: GoogleFonts.orbitron(
                color: const Color(0xFF00FF9D), fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$name більше не загрожує твоєму бюджету.',
                style:
                    GoogleFonts.spaceMono(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 12),
            _RewardChip(
                icon: Icons.bolt, label: '+${SubscriptionService.kXpPerCancel} XP'),
            if (badgeEarned) ...[
              const SizedBox(height: 8),
              _RewardChip(icon: Icons.military_tech, label: 'Badge: Мисливець за підписками 🏅'),
            ],
            const SizedBox(height: 16),
            Text('Куди направити $amount?',
                style: GoogleFonts.spaceMono(
                    color: Colors.white54, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Залишити в бюджеті',
                style: GoogleFonts.spaceMono(color: Colors.white54, fontSize: 12)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FF9D)),
            onPressed: () {
              Navigator.pop(ctx);
              // Navigate to goals to redirect savings — future integration
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: const Color(0xFF1A1A2E),
                content: Text('💡 Додай $amount до своєї Скарбнички!',
                    style: GoogleFonts.spaceMono(
                        color: const Color(0xFF00FF9D), fontSize: 12)),
              ));
            },
            icon: const Icon(Icons.savings, color: Colors.black, size: 18),
            label: Text('В Скарбничку 🎯',
                style: GoogleFonts.spaceMono(
                    color: Colors.black, fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ── Stats Header ────────────────────────────────────────────────────────────

class _StatsHeader extends StatelessWidget {
  final AsyncValue<int> totalAsync;
  final AsyncValue<int> cancelCountAsync;
  const _StatsHeader({required this.totalAsync, required this.cancelCountAsync});

  @override
  Widget build(BuildContext context) {
    final monthly = totalAsync.valueOrNull ?? 0;
    final yearly = monthly * 12;
    final kills = cancelCountAsync.valueOrNull ?? 0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF3B30).withValues(alpha: 0.15),
            const Color(0xFF1A1A2E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
            color: const Color(0xFFFF3B30).withValues(alpha: 0.4), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('🩸', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ПАРАЗИТИ З'ЇДАЮТЬ",
                      style: GoogleFonts.spaceMono(
                          color: Colors.white54, fontSize: 10,
                          letterSpacing: 1.5)),
                  Text(
                    '${(monthly / 100).toStringAsFixed(0)} UAH / міс',
                    style: GoogleFonts.orbitron(
                        color: const Color(0xFFFF3B30),
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '≈ ${(yearly / 100).toStringAsFixed(0)} UAH на рік',
                    style: GoogleFonts.spaceMono(
                        color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text('🗡️ $kills',
                      style: GoogleFonts.orbitron(
                          color: const Color(0xFF00FF9D),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text('знищено',
                      style: GoogleFonts.spaceMono(
                          color: Colors.white38, fontSize: 10)),
                ],
              ),
            ],
          ),
          if (kills < 3) ...[
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: kills / 3,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation(Color(0xFF00FF9D)),
            ),
            const SizedBox(height: 4),
            Text('Ще ${3 - kills} до бейджа "Мисливець за підписками"',
                style: GoogleFonts.spaceMono(
                    color: Colors.white38, fontSize: 10)),
          ] else ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00FF9D).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF00FF9D), width: 0.5),
              ),
              child: Text('🏅 Мисливець за підписками',
                  style: GoogleFonts.spaceMono(
                      color: const Color(0xFF00FF9D), fontSize: 11)),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Helpers ─────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(label,
            style: GoogleFonts.spaceMono(
                color: Colors.white38,
                fontSize: 10,
                letterSpacing: 1.5)),
      );
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🥷', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 16),
            Text('Паразитів не знайдено',
                style: GoogleFonts.orbitron(
                    color: Colors.white, fontSize: 18)),
            const SizedBox(height: 8),
            Text('Додай підписки, щоб стежити за паразитами',
                style: GoogleFonts.spaceMono(
                    color: Colors.white54, fontSize: 12),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF9D)),
              onPressed: onAdd,
              icon: const Icon(Icons.add, color: Colors.black),
              label: Text('Додати паразита',
                  style: GoogleFonts.spaceMono(
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
}

class _RewardChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _RewardChip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF00FF9D).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF00FF9D), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF00FF9D), size: 16),
            const SizedBox(width: 6),
            Text(label,
                style: GoogleFonts.spaceMono(
                    color: const Color(0xFF00FF9D), fontSize: 12)),
          ],
        ),
      );
}
