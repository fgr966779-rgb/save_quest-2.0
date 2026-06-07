// FILE: lib/features/subscriptions/providers/subscription_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';
import '../../../core/services/notification_service.dart';
import '../services/subscription_service.dart';

part 'subscription_provider.g.dart';

// ── Service provider ────────────────────────────────────────────────────────

@riverpod
SubscriptionService subscriptionService(Ref ref) {
  final db = ref.watch(databaseProvider);
  return SubscriptionService(db, NotificationService());
}

// ── Stream: all subscriptions (active + inactive) ───────────────────────────

@riverpod
Stream<List<Subscription>> subscriptionsStream(Ref ref) {
  return ref.watch(subscriptionServiceProvider).watchSubscriptions();
}

// ── Async: stats ─────────────────────────────────────────────────────────────

@riverpod
Future<int> totalMonthlyCost(Ref ref) =>
    ref.watch(subscriptionServiceProvider).totalMonthlyCostKopecks();

@riverpod
Future<List<Subscription>> possiblyInactive(Ref ref) =>
    ref.watch(subscriptionServiceProvider).getPossiblyInactive();

@riverpod
Future<int> cancellationCount(Ref ref) =>
    ref.watch(subscriptionServiceProvider).getCancellationCount();
