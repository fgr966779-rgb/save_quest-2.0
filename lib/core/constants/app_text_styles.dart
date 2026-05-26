import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// DESIGN SYSTEM: Typography
/// 3 levels. Clean hierarchy. Maximum readability.
/// Font: Inter (system-level, works on all platforms)

class AppTypography {
  AppTypography._();

  // --- H1: Page titles, hero numbers ---
  static TextStyle h1(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.5,
      color: color ?? AppColors.textPrimary(Theme.of(context).brightness),
    );
  }

  // --- H2: Section headers ---
  static TextStyle h2(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: -0.3,
      color: color ?? AppColors.textPrimary(Theme.of(context).brightness),
    );
  }

  // --- H3: Card titles, subsections ---
  static TextStyle h3(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: -0.2,
      color: color ?? AppColors.textPrimary(Theme.of(context).brightness),
    );
  }

  // --- Body: Primary reading text ---
  static TextStyle body(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: -0.1,
      color: color ?? AppColors.textSecondary(Theme.of(context).brightness),
    );
  }

  // --- Body Small: Secondary text, descriptions ---
  static TextStyle bodySmall(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: color ?? AppColors.textSecondary(Theme.of(context).brightness),
    );
  }

  // --- Caption: Labels, metadata ---
  static TextStyle caption(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.4,
      letterSpacing: 0.2,
      color: color ?? AppColors.textTertiary(Theme.of(context).brightness),
    );
  }

  // --- Overline: Tiny labels, tags ---
  static TextStyle overline(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.5,
      color: color ?? AppColors.textTertiary(Theme.of(context).brightness),
    );
  }

  // --- Display: Large numbers, hero metrics ---
  static TextStyle display(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      height: 1.1,
      letterSpacing: -1.5,
      color: color ?? AppColors.textPrimary(Theme.of(context).brightness),
    );
  }

  // --- Button text ---
  static TextStyle button(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: -0.2,
      color: color ?? Colors.white,
    );
  }

  // --- Label for amounts ---
  static TextStyle amount(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: -0.3,
      color: color ?? AppColors.textPrimary(Theme.of(context).brightness),
    );
  }

  // --- Percentage / Metric ---
  static TextStyle metric(BuildContext context, {Color? color}) {
    return GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.1,
      letterSpacing: -1.0,
      color: color ?? AppColors.textPrimary(Theme.of(context).brightness),
    );
  }
}
