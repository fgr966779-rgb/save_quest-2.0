// FILE: lib/features/gamification/screens/notification_center_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/l10n.dart';
import '../../../core/providers/providers.dart';
import '../../../core/services/notification_center_service.dart';
import '../../../core/widgets/surface_card.dart';

/// Simple provider that returns unread count for the badge.
final unreadNotificationCountProvider = Provider<int>((ref) {
  try {
    final box = Hive.box('notifications_box');
    final service = NotificationCenterService(box);
    return service.getUnreadCount();
  } catch (_) {
    return 0;
  }
});

class NotificationCenterScreen extends ConsumerStatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  ConsumerState<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState
    extends ConsumerState<NotificationCenterScreen> {
  List<AppNotification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    // Read from Hive directly (matching SettingsService pattern)
    try {
      final box = Hive.box('notifications_box');
      final service = NotificationCenterService(box);
      setState(() {
        _notifications = service.getAll();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final brightness = Theme.of(context).brightness;
    String t(String key) => AppLocalizations.get(locale, key);

    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppColors.background(brightness),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t('notif_title'),
          style: AppTypography.h2(context),
        ),
        actions: [
          if (_notifications.isNotEmpty) ...[
            IconButton(
              icon: Icon(Icons.done_all, color: AppColors.accent),
              tooltip: t('notif_mark_all'),
              onPressed: _markAllRead,
            ),
            IconButton(
              icon: Icon(Icons.delete_sweep_outlined,
                  color: AppColors.error.withOpacity(0.7)),
              tooltip: t('notif_delete_all'),
              onPressed: _deleteAll,
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? _buildEmpty(t, brightness)
              : _buildList(t, brightness, unreadCount),
    );
  }

  Widget _buildEmpty(String t(String k), Brightness brightness) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 64,
            color: AppColors.textTertiary(brightness),
          ),
          const SizedBox(height: 16),
          Text(
            t('notif_empty'),
            style: AppTypography.body(context,
                color: AppColors.textSecondary(brightness)),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
      String t(String k), Brightness brightness, int unreadCount) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final notif = _notifications[index];
        return _buildTile(notif, t, brightness);
      },
    );
  }

  Widget _buildTile(
      AppNotification notif, String t(String k), Brightness brightness) {
    final iconData = _getIconForType(notif.type);
    final iconColor = _getColorForType(notif.type);

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      borderColor:
          notif.isRead ? null : AppColors.accent.withOpacity(0.3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconData, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notif.title,
                        style: AppTypography.body(context,
                            fontWeight: notif.isRead
                                ? FontWeight.w400
                                : FontWeight.w600),
                      ),
                    ),
                    if (!notif.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notif.body,
                  style: AppTypography.caption(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(notif.createdAt),
                  style: AppTypography.caption(context,
                      color: AppColors.textTertiary(brightness)),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 16,
                color: AppColors.textTertiary(brightness)),
            onPressed: () => _deleteNotification(notif.id),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'reminder':
        return Icons.alarm;
      case 'streak':
        return Icons.local_fire_department;
      case 'achievement':
        return Icons.emoji_events;
      case 'milestone':
        return Icons.military_tech;
      case 'levelup':
        return Icons.trending_up;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'reminder':
        return AppColors.accent;
      case 'streak':
        return Colors.orange;
      case 'achievement':
        return AppColors.success;
      case 'milestone':
        return Colors.amber;
      case 'levelup':
        return Colors.purple;
      default:
        return AppColors.accent;
    }
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  void _markAllRead() {
    try {
      final box = Hive.box('notifications_box');
      final service = NotificationCenterService(box);
      service.markAllRead();
      setState(() => _notifications = service.getAll());
    } catch (e) {
      debugPrint('markAllRead error: $e');
    }
  }

  void _deleteAll() {
    try {
      final box = Hive.box('notifications_box');
      final service = NotificationCenterService(box);
      service.deleteAll();
      setState(() => _notifications = []);
    } catch (e) {
      debugPrint('deleteAll error: $e');
    }
  }

  void _deleteNotification(String id) {
    try {
      final box = Hive.box('notifications_box');
      final service = NotificationCenterService(box);
      service.delete(id);
      setState(() => _notifications = service.getAll());
    } catch (e) {
      debugPrint('deleteNotification error: $e');
    }
  }
}
