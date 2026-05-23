import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === ТЕМНАЯ ТЕМА (Dark Theme) ===
  static const Color background = Color(0xFF121220);     // Глубокий полночно-синий графит вместо черного
  static const Color cardBg = Color(0xFF1B1A2A);         // Карточки темной темы
  static const Color cardBgLight = Color(0xFF24233A);    // Выделения в темной теме
  
  // === СВЕТЛАЯ ТЕМА (Light Theme) ===
  static const Color lightBg = Color(0xFFF8F9FA);        // Чистый белый с серо-голубым оттенком
  static const Color lightSurface = Color(0xFFFFFFFF);   // Карточки светлой темы
  static const Color lightSurfaceMuted = Color(0xFFEEF1F6);

  // === АКЦЕНТЫ И ГРАДИЕНТЫ (Cyberpunk/Neon Accents) ===
  static const Color cyanAccent = Color(0xFF00E5FF);     // Goal A: PlayStation 5
  static const Color magentaAccent = Color(0xFFFF007F);  // Goal B: Gaming Monitor
  static const Color purpleGlow = Color(0xFF8B5CF6);     // Пурпурный для смешивания градиентов
  static const Color goldAccent = Color(0xFFFFC400);     // Стрики и достижения
  static const Color greenAccent = Color(0xFF39FF14);    // Успех, разблокировки
  static const Color blueAccent = Color(0xFF0D47A1);

  // === НЕОНОВЫЕ СВЕЧЕНИЯ ===
  static const Color cyanGlow = Color(0x4D00E5FF);
  static const Color magentaGlow = Color(0x4DFF007F);
  static const Color goldGlow = Color(0x4DFFC400);

  // === СТРИКИ И ОГОНЬ ===
  static const Color streakFireRed = Color(0xFFFF3D00);
  static const Color streakFireYellow = Color(0xFFFFEA00);
  static const Color fireOrange = Color(0xFFFF5722);

  // === ТЕКСТОВЫЕ ЦВЕТА ===
  static const Color textPrimary = Color(0xFFF5F5FA);       // Почти белый для темной темы
  static const Color textSecondary = Color(0xFF9E9EBA);     // Приглушенный лавандово-серый
  static const Color textMuted = Color(0xFF5E5E7A);         // Темный сланец

  static const Color textLightPrimary = Color(0xFF1E1E2C);  // Глубокий графит для светлой темы
  static const Color textLightSecondary = Color(0xFF5E6278);// Серый Slate
  static const Color textLightMuted = Color(0xFF98A2B3);    // Светло-серый

  // === ГРАНИЦЫ ===
  static const Color borderNeon = Color(0xFF231E3D);
  static const Color borderNeonActive = Color(0xFF433C73);
}
