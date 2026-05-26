import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ========================================
  // DESIGN SYSTEM: Clean Minimalism 2025-2026
  // One accent. Neutral surfaces. Zero noise.
  // ========================================

  // --- LIGHT MODE ---
  static const Color lightBackground = Color(0xFFF7F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceMuted = Color(0xFFF0F1F3);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightBorderStrong = Color(0xFFD1D5DB);

  // --- DARK MODE ---
  static const Color darkBackground = Color(0xFF111113);
  static const Color darkSurface = Color(0xFF1A1A1E);
  static const Color darkSurfaceMuted = Color(0xFF242428);
  static const Color darkBorder = Color(0xFF2A2A2E);
  static const Color darkBorderStrong = Color(0xFF3A3A3E);

  // --- ACCENT (Single Color System) ---
  // A clean, modern indigo-violet that works for both modes
  static const Color accent = Color(0xFF6366F1);
  static const Color accentLight = Color(0xFF818CF8);
  static const Color accentDark = Color(0xFF4F46E5);
  static const Color accentMuted = Color(0xFFE0E7FF);
  static const Color accentMutedDark = Color(0xFF312E81);

  // --- GOAL SEMANTIC COLORS (subtle, not neon) ---
  // Used only for goal differentiation, not as primary identity
  static const Color goalA = Color(0xFF6366F1); // Indigo (matches accent)
  static const Color goalB = Color(0xFF10B981); // Emerald green
  static const Color goalAMuted = Color(0xFFEEF2FF);
  static const Color goalBMuted = Color(0xFFECFDF5);
  static const Color goalADark = Color(0xFF3730A3);
  static const Color goalBDark = Color(0xFF065F46);

  // --- GAMIFICATION SEMANTIC ---
  // Rarity colors for achievements / trophies
  static const Color legendary = Color(0xFF8B5CF6); // Violet — for legendary tier
  static const Color legendaryMuted = Color(0xFFF3E8FF);

  // Core skill class colors
  static const Color skillHacker = Color(0xFF00FF41);   // Matrix Green
  static const Color skillMagnate = Color(0xFFF59E0B);  // Amber/Gold (same as warning)
  static const Color skillResilience = Color(0xFFEC4899); // Pink

  // Chart / member distinguishing colors (joint goals, data viz)
  static const Color chartBlue = Color(0xFF60A5FA);
  static const Color chartOrange = Color(0xFFFB923C);
  static const Color chartPurple = Color(0xFFA855F7);
  static const Color chartAmber = Color(0xFFF97316);

  // --- SEMANTIC ---
  static const Color success = Color(0xFF10B981);
  static const Color successMuted = Color(0xFFECFDF5);
  static const Color successDark = Color(0xFF065F46);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningMuted = Color(0xFFFFFBEB);
  static const Color warningDark = Color(0xFF92400E);
  static const Color error = Color(0xFFEF4444);
  static const Color errorMuted = Color(0xFFFEF2F2);
  static const Color errorDark = Color(0xFF991B1B);

  // --- TEXT (Light) ---
  static const Color textLightPrimary = Color(0xFF111827);
  static const Color textLightSecondary = Color(0xFF6B7280);
  static const Color textLightTertiary = Color(0xFF9CA3AF);
  static const Color textLightDisabled = Color(0xFFD1D5DB);

  // --- TEXT (Dark) ---
  static const Color textDarkPrimary = Color(0xFFF3F4F6);
  static const Color textDarkSecondary = Color(0xFF9CA3AF);
  static const Color textDarkTertiary = Color(0xFF6B7280);
  static const Color textDarkDisabled = Color(0xFF4B5563);

  // --- HELPERS: Context-aware colors ---
  static Color background(Brightness brightness) =>
      brightness == Brightness.dark ? darkBackground : lightBackground;

  static Color surface(Brightness brightness) =>
      brightness == Brightness.dark ? darkSurface : lightSurface;

  static Color surfaceMuted(Brightness brightness) =>
      brightness == Brightness.dark ? darkSurfaceMuted : lightSurfaceMuted;

  static Color border(Brightness brightness) =>
      brightness == Brightness.dark ? darkBorder : lightBorder;

  static Color borderStrong(Brightness brightness) =>
      brightness == Brightness.dark ? darkBorderStrong : lightBorderStrong;

  static Color textPrimary(Brightness brightness) =>
      brightness == Brightness.dark ? textDarkPrimary : textLightPrimary;

  static Color textSecondary(Brightness brightness) =>
      brightness == Brightness.dark ? textDarkSecondary : textLightSecondary;

  static Color textTertiary(Brightness brightness) =>
      brightness == Brightness.dark ? textDarkTertiary : textLightTertiary;

  static Color textDisabled(Brightness brightness) =>
      brightness == Brightness.dark ? textDarkDisabled : textLightDisabled;

  static Color accentMutedBg(Brightness brightness) =>
      brightness == Brightness.dark ? accentMutedDark : accentMuted;
}
