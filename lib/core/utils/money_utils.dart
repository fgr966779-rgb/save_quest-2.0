/// Money utilities — all amounts in DB are stored as INTEGER (minor units / kopecks).
/// 1 UAH = 100 kopecks, 1 USD = 100 cents, etc.
///
/// Rule:
///   DB  → UI  : use [centsToDisplay]  (int → double)
///   UI  → DB  : use [displayToCents]  (double → int)
///   UI display: use [formatAmount]    (int → String like "1 250.50")
library;

import 'package:intl/intl.dart';

/// Converts minor-unit integer (kopecks) to a display double.
/// e.g. 250000 → 2500.00
double centsToDisplay(int cents) => cents / 100.0;

/// Converts a display double to minor-unit integer (kopecks), rounding half-up.
/// e.g. 2500.0 → 250000
int displayToCents(double amount) => (amount * 100).round();

/// Formats a minor-unit integer for display with 2 decimal places.
/// e.g. 250050 → "2 500.50"
String formatAmount(int cents, {bool showDecimals = true}) {
  final double value = centsToDisplay(cents);
  if (showDecimals && cents % 100 != 0) {
    return NumberFormat('#,##0.00', 'uk_UA').format(value).replaceAll(',', '\u00A0');
  }
  return NumberFormat('#,##0', 'uk_UA').format(value).replaceAll(',', '\u00A0');
}

/// Formats a display double for UI (e.g. from text input) — no DB involved.
String formatDisplayAmount(double amount) {
  if (amount == amount.truncateToDouble()) {
    return amount.toInt().toString();
  }
  return amount.toStringAsFixed(2);
}
