import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// DESIGN SYSTEM: Theme
/// Apple-level clean + Linear-level clarity + Notion-level spacing

class AppTheme {
  AppTheme._();

  // --- Spacing ---
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 12.0;
  static const double spaceLg = 16.0;
  static const double spaceXl = 20.0;
  static const double spaceXxl = 24.0;
  static const double spaceXxxl = 32.0;
  static const double spaceHuge = 40.0;

  // --- Border Radius ---
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusFull = 100.0;

  // --- Animation ---
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 200);
  static const Duration animSlow = Duration(milliseconds: 250);
  static const Curve animCurve = Curves.easeOutCubic;

  // ========================================
  // DARK THEME
  // ========================================
  static ThemeData get darkTheme {
    final brightness = Brightness.dark;
    return _buildTheme(brightness);
  }

  // ========================================
  // LIGHT THEME
  // ========================================
  static ThemeData get lightTheme {
    final brightness = Brightness.light;
    return _buildTheme(brightness);
  }

  // Helper to build text styles without BuildContext
  static TextStyle _inter({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final textPrimary = isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary;
    final textSecondary = isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary;
    final textTertiary = isDark ? AppColors.textDarkTertiary : AppColors.textLightTertiary;

    final colorScheme = isDark
        ? const ColorScheme.dark(
            primary: AppColors.accent,
            onPrimary: Colors.white,
            primaryContainer: AppColors.accentMutedDark,
            secondary: AppColors.goalB,
            onSecondary: Colors.white,
            secondaryContainer: AppColors.goalBDark,
            surface: AppColors.darkSurface,
            onSurface: AppColors.textDarkPrimary,
            onSurfaceVariant: AppColors.textDarkSecondary,
            error: AppColors.error,
            onError: Colors.white,
            errorContainer: AppColors.errorDark,
            outline: AppColors.darkBorder,
            outlineVariant: AppColors.darkBorder,
          )
        : const ColorScheme.light(
            primary: AppColors.accent,
            onPrimary: Colors.white,
            primaryContainer: AppColors.accentMuted,
            secondary: AppColors.goalB,
            onSecondary: Colors.white,
            secondaryContainer: AppColors.goalBMuted,
            surface: AppColors.lightSurface,
            onSurface: AppColors.textLightPrimary,
            onSurfaceVariant: AppColors.textLightSecondary,
            error: AppColors.error,
            onError: Colors.white,
            errorContainer: AppColors.errorMuted,
            outline: AppColors.lightBorder,
            outlineVariant: AppColors.lightBorder,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background(brightness),
      dividerColor: AppColors.border(brightness),

      // --- App Bar ---
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: _inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          height: 1.4,
          letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(
          color: textPrimary,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: textSecondary,
          size: 22,
        ),
      ),

      // --- Card ---
      cardTheme: CardThemeData(
        color: AppColors.surface(brightness),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide(
            color: AppColors.border(brightness),
            width: 1,
          ),
        ),
      ),

      // --- Dialog ---
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface(brightness),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXl),
        ),
      ),

      // --- Bottom Sheet ---
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface(brightness),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusXl),
          ),
        ),
      ),

      // --- Divider ---
      dividerTheme: DividerThemeData(
        color: AppColors.border(brightness),
        thickness: 1,
        space: 1,
      ),

      // --- Input Decoration ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceMuted(brightness),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceLg,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(
            color: AppColors.border(brightness),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(
            color: AppColors.border(brightness),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: 1.5,
          ),
        ),
        hintStyle: _inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textTertiary,
          height: 1.5,
        ),
        labelStyle: _inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.5,
        ),
      ),

      // --- Navigation Bar (Bottom) ---
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface(brightness),
        elevation: 0,
        indicatorColor: AppColors.accentMutedBg(brightness),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return _inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.accent : textTertiary,
            height: 1.4,
            letterSpacing: 0.2,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isSelected ? AppColors.accent : textTertiary,
            size: isSelected ? 24 : 22,
          );
        }),
        height: 80,
      ),

      // --- Switch ---
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.accent;
          }
          return AppColors.borderStrong(brightness);
        }),
      ),

      // --- SnackBar ---
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),

      // --- Floating Action Button ---
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),

      // --- Text Selection ---
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.accent,
        selectionColor: AppColors.accent.withValues(alpha: 0.3),
        selectionHandleColor: AppColors.accent,
      ),

      // --- Scrollbar ---
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
          AppColors.borderStrong(brightness),
        ),
        thickness: WidgetStateProperty.all(4),
        radius: const Radius.circular(2),
      ),
    );
  }
}
