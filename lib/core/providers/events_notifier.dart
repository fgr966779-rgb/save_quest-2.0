import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CyberEvent {
  final String id;
  final String title;
  final String description;
  final double xpMultiplier;
  final double creditsMultiplier;
  final DateTime expiresAt;

  CyberEvent({
    required this.id,
    required this.title,
    required this.description,
    this.xpMultiplier = 1.0,
    this.creditsMultiplier = 1.0,
    required this.expiresAt,
  });

  bool get isActive => DateTime.now().isBefore(expiresAt);
}

final eventsProvider = StateNotifierProvider<EventsNotifier, CyberEvent?>((ref) {
  return EventsNotifier();
});

class EventsNotifier extends StateNotifier<CyberEvent?> {
  EventsNotifier() : super(null) {
    _checkForEvents();
  }

  void _checkForEvents() {
    // For demonstration, we'll assign a random event with a 30% chance, 
    // or always assign one for testing purposes. Let's make it 100% for the prototype.
    final rand = Random().nextDouble();
    
    // Hardcoded to trigger an event currently to showcase the feature.
    // In production, this would use persistent storage to check if an event was already generated today.
    if (rand < 1.0) { 
      _generateRandomEvent();
    }
  }

  void _generateRandomEvent() {
    final now = DateTime.now();
    // Event lasts until the end of the day
    final expiresAt = DateTime(now.year, now.month, now.day, 23, 59, 59);
    
    final events = [
      CyberEvent(
        id: 'corp_breach',
        title: '🌐 CORPORATE DATA BREACH',
        description: 'Витік даних корпорації дозволяє заробляти ×2 Кібер-Кредитів за всі депозити!',
        creditsMultiplier: 2.0,
        expiresAt: expiresAt,
      ),
      CyberEvent(
        id: 'system_anomaly',
        title: '👾 SYSTEM ANOMALY',
        description: 'Збій у матриці збільшує отримання XP на 50%!',
        xpMultiplier: 1.5,
        expiresAt: expiresAt,
      ),
      CyberEvent(
        id: 'hacker_manifesto',
        title: '🏴‍☠️ HACKER MANIFESTO',
        description: 'Подвійні XP та Кредити для всіх повстанців сьогодні!',
        xpMultiplier: 2.0,
        creditsMultiplier: 2.0,
        expiresAt: expiresAt,
      ),
    ];

    state = events[Random().nextInt(events.length)];
  }

  /// Manually clear the event (e.g., for testing)
  void clearEvent() {
    state = null;
  }

  /// Force generate a new event
  void forceNewEvent() {
    _generateRandomEvent();
  }
}
