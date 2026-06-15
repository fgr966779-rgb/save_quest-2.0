import 'dart:io';

void main() {
  var replacements = {
    'd:/Скарбничка мрії/save_quest 2.0/save_quest/lib/features/phase3/screens/preorder_guard_screen.dart': [
      ['isCancelled: false,', 'isCancelled: const drift.Value(false),']
    ],
    'd:/Скарбничка мрії/save_quest 2.0/save_quest/lib/features/phase3/screens/price_freeze_screen.dart': [
      ['maxDays: 7,', 'maxDays: const drift.Value(7),']
    ],
    'd:/Скарбничка мрії/save_quest 2.0/save_quest/lib/features/phase3/screens/price_prophet_screen.dart': [
      ['confidence: 85,', 'confidence: const drift.Value(85),']
    ],
    'd:/Скарбничка мрії/save_quest 2.0/save_quest/lib/features/phase3/screens/soundscapes_screen.dart': [
      ['isActive: true,', 'isActive: const drift.Value(true),']
    ],
    'd:/Скарбничка мрії/save_quest 2.0/save_quest/lib/features/phase3/screens/voice_vault_screen.dart': [
      ['isConfirmed: false,', 'isConfirmed: const drift.Value(false),']
    ],
    'd:/Скарбничка мрії/save_quest 2.0/save_quest/lib/features/phase3/screens/wishlist_radar_screen.dart': [
      ['isNotified: false,', 'isNotified: const drift.Value(false),']
    ],
    'd:/Скарбничка мрії/save_quest 2.0/save_quest/lib/features/phase4/screens/inventory_stalker_screen.dart': [
      ['isActive: true,', 'isActive: const drift.Value(true),']
    ]
  };

  for (var entry in replacements.entries) {
    var file = File(entry.key);
    if (!file.existsSync()) continue;
    var content = file.readAsStringSync();
    var newContent = content;
    for (var rep in entry.value) {
      newContent = newContent.replaceAll(rep[0], rep[1]);
    }
    file.writeAsStringSync(newContent);
    print('Fixed file ' + entry.key);
  }
}
