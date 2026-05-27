import 'dart:convert';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Pure data model for user avatar configuration.
/// Extracted from legacy neon_avatar_painter.dart — no legacy color references.
class AvatarConfig {
  final String chassis;
  final String visor;
  final String colorHex;
  final String decal;
  final double integrity; // 0.0 (Broken) to 1.0 (Pristine)
  final int xp;
  final int credits;
  final List<String> ownedItems;
  final List<String> badges;

  const AvatarConfig({
    this.chassis = 'standard',
    this.visor = 'cyclops',
    this.colorHex = '#6366F1', // Indigo accent (matches AppColors.accent)
    this.decal = 'none',
    this.integrity = 1.0,
    this.xp = 0,
    this.credits = 0,
    this.ownedItems = const [],
    this.badges = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'chassis': chassis,
      'visor': visor,
      'colorHex': colorHex,
      'decal': decal,
      'integrity': integrity,
      'xp': xp,
      'credits': credits,
      'ownedItems': ownedItems,
      'badges': badges,
    };
  }

  factory AvatarConfig.fromMap(Map<String, dynamic> map) {
    return AvatarConfig(
      chassis: map['chassis'] ?? 'standard',
      visor: map['visor'] ?? 'cyclops',
      colorHex: map['colorHex'] ?? '#6366F1',
      decal: map['decal'] ?? 'none',
      integrity: (map['integrity'] as num?)?.toDouble() ?? 1.0,
      xp: map['xp'] ?? 0,
      credits: map['credits'] ?? 0,
      ownedItems: List<String>.from(map['ownedItems'] ?? []),
      badges: List<String>.from(map['badges'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory AvatarConfig.fromJson(String source) {
    try {
      return AvatarConfig.fromMap(json.decode(source));
    } catch (e) {
      return const AvatarConfig(); // fallback
    }
  }

  AvatarConfig copyWith({
    String? chassis,
    String? visor,
    String? colorHex,
    String? decal,
    double? integrity,
    int? xp,
    int? credits,
    List<String>? ownedItems,
    List<String>? badges,
  }) {
    return AvatarConfig(
      chassis: chassis ?? this.chassis,
      visor: visor ?? this.visor,
      colorHex: colorHex ?? this.colorHex,
      decal: decal ?? this.decal,
      integrity: integrity ?? this.integrity,
      xp: xp ?? this.xp,
      credits: credits ?? this.credits,
      ownedItems: ownedItems ?? this.ownedItems,
      badges: badges ?? this.badges,
    );
  }

  /// Parse colorHex to Color. Fallback to AppColors.accent if parsing fails.
  Color get primaryColor {
    try {
      final hex = colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppColors.accent;
    }
  }
}
