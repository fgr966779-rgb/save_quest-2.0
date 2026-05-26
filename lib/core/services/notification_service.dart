// FILE: lib/core/services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Service for scheduling and managing local push notifications.
/// Handles daily deposit reminders and streak warnings.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize the notification plugin. Must be called once at app startup.
  Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  /// Request notification permissions from the user.
  /// Returns true if granted.
  Future<bool> requestPermissions() async {
    // Android 13+ requires explicit permission request
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }

    // iOS permission request
    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  /// Schedule a daily reminder notification at the given [hour] and [minute].
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    String title = 'PiggyVault',
    String body = "Time to save! Make a deposit today.",
  }) async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      'piggyvault_reminders',
      'Daily Reminders',
      channelDescription: 'Daily deposit reminders',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Schedule for every day at the specified time
    await _plugin.zonedSchedule(
      0, // notification id
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    debugPrint('Scheduled daily reminder at $hour:$minute');
  }

  /// Cancel all scheduled notifications.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
    debugPrint('All notifications cancelled');
  }

  /// Schedule a one-time streak warning notification.
  Future<void> scheduleStreakWarning({
    String title = 'Streak at risk!',
    String body = 'Make a deposit before midnight to keep your streak.',
  }) async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      'piggyvault_streak',
      'Streak Alerts',
      channelDescription: 'Streak warning notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      1,
      title,
      body,
      details,
    );
  }

  /// Show an instant notification (for achievements, milestones, etc.).
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      'piggyvault_general',
      'General',
      channelDescription: 'General PiggyVault notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(id, title, body, details);
  }

  /// Handle notification tap — placeholder for navigation.
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Future: navigate based on payload
  }

  /// Get the next occurrence of the given time (today or tomorrow).
  TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final location = tz.local;
    final now = TZDateTime.now(location);
    var scheduled = TZDateTime(location, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
