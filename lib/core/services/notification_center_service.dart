// FILE: lib/core/services/notification_center_service.dart
import 'package:uuid/uuid.dart';

/// In-app notification model (stored in Hive, not Drift — avoids build_runner).
class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type; // 'reminder', 'streak', 'achievement', 'milestone', 'levelup'
  final bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        type: json['type'] as String,
        isRead: json['isRead'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        title: title,
        body: body,
        type: type,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
      );
}

/// Manages in-app notifications using a Hive box.
/// Provides methods for CRUD operations and unread count.
class NotificationCenterService {
  static const String boxName = 'notifications_box';
  static const int maxNotifications = 50;

  final dynamic _box; // Box<dynamic> from Hive

  NotificationCenterService(this._box);

  /// Get all notifications, newest first.
  List<AppNotification> getAll() {
    final raw = _box.get('notifications');
    if (raw == null) return [];
    final list = (raw as List).cast<Map<String, dynamic>>();
    return list.map((m) => AppNotification.fromJson(m)).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get unread notification count.
  int getUnreadCount() => getAll().where((n) => !n.isRead).length;

  /// Add a new notification.
  void add(AppNotification notification) {
    final all = getAll();
    all.insert(0, notification);
    // Keep only last N notifications
    final trimmed = all.take(maxNotifications).toList();
    _box.put('notifications', trimmed.map((n) => n.toJson()).toList());
  }

  /// Add a notification with auto-generated ID.
  void addSimple({
    required String title,
    required String body,
    required String type,
  }) {
    final notification = AppNotification(
      id: const Uuid().v4(),
      title: title,
      body: body,
      type: type,
      createdAt: DateTime.now(),
    );
    add(notification);
  }

  /// Mark a notification as read.
  void markAsRead(String id) {
    final all = getAll().map((n) {
      if (n.id == id) return n.copyWith(isRead: true);
      return n;
    }).toList();
    _box.put('notifications', all.map((n) => n.toJson()).toList());
  }

  /// Mark all notifications as read.
  void markAllRead() {
    final all = getAll().map((n) => n.copyWith(isRead: true)).toList();
    _box.put('notifications', all.map((n) => n.toJson()).toList());
  }

  /// Delete a notification by ID.
  void delete(String id) {
    final all = getAll().where((n) => n.id != id).toList();
    _box.put('notifications', all.map((n) => n.toJson()).toList());
  }

  /// Delete all notifications.
  void deleteAll() {
    _box.delete('notifications');
  }
}
