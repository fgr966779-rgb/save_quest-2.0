// FILE: lib/features/subscriptions/services/subscription_service.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/database.dart';
import '../../../core/services/notification_service.dart';
import 'package:drift/drift.dart' hide Column;

/// Subscription Ninja: manages user's recurring subscriptions (parasites).
/// All data is strictly local (Drift DB). No cloud sync.
class SubscriptionService {
  final AppDatabase _db;
  final NotificationService _notifications;

  SubscriptionService(this._db, this._notifications);

  // ── Popular service templates (auto-fill) ──────────────────────────────
  static const List<Map<String, dynamic>> kTemplates = [
    {'name': 'Netflix', 'amount': 19900, 'cycle': 'monthly'},
    {'name': 'Spotify', 'amount': 14900, 'cycle': 'monthly'},
    {'name': 'YouTube Premium', 'amount': 13900, 'cycle': 'monthly'},
    {'name': 'Apple Music', 'amount': 13900, 'cycle': 'monthly'},
    {'name': 'ChatGPT Plus', 'amount': 80000, 'cycle': 'monthly'},
    {'name': 'Notion Pro', 'amount': 48000, 'cycle': 'yearly'},
    {'name': 'Adobe CC', 'amount': 259000, 'cycle': 'monthly'},
    {'name': 'Xbox Game Pass', 'amount': 29900, 'cycle': 'monthly'},
    {'name': 'PlayStation Plus', 'amount': 59900, 'cycle': 'monthly'},
    {'name': 'Disney+', 'amount': 14900, 'cycle': 'monthly'},
    {'name': 'Telegram Premium', 'amount': 9900, 'cycle': 'monthly'},
    {'name': 'Google One', 'amount': 3900, 'cycle': 'monthly'},
    {'name': 'iCloud+', 'amount': 5900, 'cycle': 'monthly'},
    {'name': 'NovaPoshta Business', 'amount': 0, 'cycle': 'monthly'},
    {'name': 'Gym / Фітнес-клуб', 'amount': 120000, 'cycle': 'monthly'},
    {'name': 'Своє (ручне)', 'amount': 0, 'cycle': 'monthly'},
  ];

  // ── CRUD ────────────────────────────────────────────────────────────────

  Stream<List<Subscription>> watchSubscriptions() =>
      (_db.select(_db.subscriptions)
            ..orderBy([(t) => OrderingTerm.asc(t.nextBillingDate)]))
          .watch();

  Future<List<Subscription>> getActiveSubscriptions() =>
      (_db.select(_db.subscriptions)
            ..where((t) => t.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.asc(t.nextBillingDate)]))
          .get();

  Future<int> addSubscription(SubscriptionsCompanion sub) =>
      _db.into(_db.subscriptions).insert(sub);

  Future<bool> updateSubscription(Subscription sub) =>
      _db.update(_db.subscriptions).replace(sub);

  Future<int> deleteSubscription(int id) =>
      (_db.delete(_db.subscriptions)..where((t) => t.id.equals(id))).go();

  /// Mark subscription as cancelled (isActive=false).
  /// Returns the amount in kopecks for XP/goal redirection logic.
  Future<int> cancelSubscription(int id) async {
    final sub = await (_db.select(_db.subscriptions)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (sub == null) return 0;

    await _db.update(_db.subscriptions).replace(
          sub.copyWith(isActive: false),
        );
    return sub.amountKopecks;
  }

  // ── Stats ───────────────────────────────────────────────────────────────

  /// Total monthly cost in kopecks (normalizes yearly to monthly).
  Future<int> totalMonthlyCostKopecks() async {
    final subs = await getActiveSubscriptions();
    int total = 0;
    for (final s in subs) {
      total +=
          s.billingCycle == 'yearly' ? (s.amountKopecks ~/ 12) : s.amountKopecks;
    }
    return total;
  }

  /// Subscriptions due within [days] days.
  Future<List<Subscription>> getDueSoon({int days = 3}) async {
    final subs = await getActiveSubscriptions();
    final cutoff = DateTime.now().add(Duration(days: days));
    return subs
        .where((s) => s.nextBillingDate.isBefore(cutoff))
        .toList();
  }

  /// Advance the billing date by one period after user confirms payment.
  Future<void> markAsPaid(Subscription sub) async {
    final nextDate = sub.billingCycle == 'yearly'
        ? DateTime(
            sub.nextBillingDate.year + 1,
            sub.nextBillingDate.month,
            sub.nextBillingDate.day,
          )
        : DateTime(
            sub.nextBillingDate.year,
            sub.nextBillingDate.month + 1,
            sub.nextBillingDate.day,
          );

    await _db.update(_db.subscriptions).replace(
          sub.copyWith(
            nextBillingDate: nextDate,
            lastCheckedAt: DateTime.now(),
          ),
        );
  }

  // ── Notifications ───────────────────────────────────────────────────────

  /// Check and fire parasite alerts for upcoming billing.
  Future<void> checkAndNotify() async {
    final dueSoon = await getDueSoon(days: 3);
    for (final sub in dueSoon) {
      final daysLeft =
          sub.nextBillingDate.difference(DateTime.now()).inDays;
      if (daysLeft < 0) continue;

      final amountStr =
          '${(sub.amountKopecks / 100).toStringAsFixed(0)} ₴';

      await _notifications.showParasiteAlert(
        id: 3000 + sub.id,
        name: sub.name,
        amountStr: amountStr,
        daysLeft: daysLeft,
      );
    }
    debugPrint('[SubscriptionNinja] Checked ${subs.length} upcoming bills.');
  }

  // ── "Possibly Inactive" Logic ───────────────────────────────────────────

  /// Subscriptions that haven't been confirmed for >30 days.
  Future<List<Subscription>> getPossiblyInactive() async {
    final subs = await getActiveSubscriptions();
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    return subs.where((s) => s.lastCheckedAt.isBefore(cutoff)).toList();
  }

  // ── XP & Gamification ──────────────────────────────────────────────────

  static const int kXpPerCancel = 20;
  static const String kCancelCountKey = 'sub_ninja_cancel_count';

  Future<int> recordCancellation() async {
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt(kCancelCountKey) ?? 0) + 1;
    await prefs.setInt(kCancelCountKey, count);
    return count; // caller checks >= 3 for badge
  }

  Future<int> getCancellationCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(kCancelCountKey) ?? 0;
  }
}
