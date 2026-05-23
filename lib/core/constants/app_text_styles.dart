import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Orbitron styles for headlining/counters
  static TextStyle orbitronHeading({
    double fontSize = 28.0,
    FontWeight fontWeight = FontWeight.bold,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.orbitron(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: 1.5,
    );
  }

  // Rajdhani styles for stats and buttons
  static TextStyle rajdhaniMedium({
    double fontSize = 18.0,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.rajdhani(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: 1.0,
    );
  }

  static TextStyle rajdhaniBold({
    double fontSize = 22.0,
    FontWeight fontWeight = FontWeight.bold,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.rajdhani(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: 1.2,
    );
  }

  // Inter styles for general body reading
  static TextStyle interBody({
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.textSecondary,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1.4,
    );
  }

  static TextStyle interSemiBold({
    double fontSize = 15.0,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle interMuted({
    double fontSize = 12.0,
    FontWeight fontWeight = FontWeight.normal,
    Color color = AppColors.textMuted,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
