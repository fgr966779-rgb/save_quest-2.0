import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

enum CoreSkillType {
  hacker,
  magnate,
  resilience
}

class CoreSkillSystem {
  static const int xpBase = 500;

  static int getLevelFromXp(int xp) {
    if (xp <= 0) return 1;
    // Formula: xp = xpBase * (level ^ 1.5)
    // level = (xp / xpBase) ^ (1 / 1.5)
    final level = math.pow(xp / xpBase, 1 / 1.5).floor();
    return level < 1 ? 1 : level;
  }

  static int xpRequiredForLevel(int level) {
    if (level <= 1) return 0;
    return (xpBase * math.pow(level, 1.5)).toInt();
  }

  static double getProgressToNextLevel(int currentXp) {
    final currentLevel = getLevelFromXp(currentXp);
    final currentLevelXp = xpRequiredForLevel(currentLevel);
    final nextLevelXp = xpRequiredForLevel(currentLevel + 1);
    
    final xpIntoLevel = currentXp - currentLevelXp;
    final xpNeeded = nextLevelXp - currentLevelXp;
    
    if (xpNeeded <= 0) return 1.0;
    return (xpIntoLevel / xpNeeded).clamp(0.0, 1.0);
  }

  static String getSkillName(CoreSkillType type) {
    switch (type) {
      case CoreSkillType.hacker: return 'Hacker';
      case CoreSkillType.magnate: return 'Magnate';
      case CoreSkillType.resilience: return 'Resilience';
    }
  }

  static String getSkillDescription(CoreSkillType type) {
    switch (type) {
      case CoreSkillType.hacker: 
        return 'Майстер терміналу. Отримуйте ХР за використання CLI, розшифровку даних та Incognito Mode. Підвищує шанс критичного внеску.';
      case CoreSkillType.magnate: 
        return 'Фінансовий геній. Отримуйте ХР за великі депозити та системність. Дає множники ХР та знижки на Чорному Ринку.';
      case CoreSkillType.resilience: 
        return 'Незламний кібер-самурай. Отримуйте ХР за відновлення серії та сплату штрафів. Зменшує вартість штрафів.';
    }
  }

  static Color getSkillColor(CoreSkillType type) {
    switch (type) {
      case CoreSkillType.hacker: return AppColors.skillHacker;
      case CoreSkillType.magnate: return AppColors.skillMagnate;
      case CoreSkillType.resilience: return AppColors.skillResilience;
    }
  }

  static IconData getSkillIcon(CoreSkillType type) {
    switch (type) {
      case CoreSkillType.hacker: return Icons.terminal_rounded;
      case CoreSkillType.magnate: return Icons.diamond_rounded;
      case CoreSkillType.resilience: return Icons.shield_rounded;
    }
  }
}
