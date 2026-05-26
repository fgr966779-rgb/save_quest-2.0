import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/providers.dart';
import '../models/leaderboard_model.dart';

part 'leaderboard_provider.g.dart';

@riverpod
Future<List<LeaderboardEntry>> weeklyLeaderboard(Ref ref) async {
  // Wait a bit to simulate network
  await Future.delayed(const Duration(milliseconds: 800));

  final profile = await ref.watch(userProfileProvider.future);
  
  final random = Random(42); // Seeded for consistent mock data
  final List<LeaderboardEntry> entries = [];
  
  // Generate mock users
  final names = [
    'CyberNinja', 'NeonRider', 'PixelGhost', 'ZeroCool', 'AcidBurn',
    'CrashOverride', 'LordMaster', 'PhantomX', 'HackerDog', 'GlitchBot',
    'ShadowNet', 'ChromeHeart', 'DataRunner', 'ByteMe', 'LogicBomb'
  ];

  for (int i = 0; i < 50; i++) {
    entries.add(LeaderboardEntry(
      id: 'mock_$i',
      displayName: names[random.nextInt(names.length)] + random.nextInt(99).toString(),
      score: random.nextInt(5000) + 100, // Weekly score (XP or savings)
      level: random.nextInt(20) + 1,
      avatarIndex: random.nextInt(10),
    ));
  }

  // Inject current user
  if (profile != null) {
    // Determine a fake weekly score based on user's XP
    // For realism, let's just use a percentage of their total XP or a random high number
    // Let's pretend they earned 1500 XP this week, or their total XP if it's less.
    final weeklyScore = profile.xp > 0 ? (profile.xp * 0.3).toInt().clamp(50, 4500) : 0;
    
    entries.add(LeaderboardEntry(
      id: profile.id,
      displayName: 'You (Player)', // or profile name if we have one
      score: weeklyScore,
      level: profile.level,
      isCurrentUser: true,
      avatarIndex: 0,
    ));
  }

  // Sort descending
  entries.sort((a, b) => b.score.compareTo(a.score));

  return entries;
}

@riverpod
Future<List<LeaderboardEntry>> monthlyLeaderboard(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 800));

  final profile = await ref.watch(userProfileProvider.future);
  
  final random = Random(1337); 
  final List<LeaderboardEntry> entries = [];
  
  final names = [
    'VoidWalker', 'SynthWave', 'CryptoKing', 'NeuralNet', 'MatrixAgent',
    'RootAdmin', 'Terminator', 'SystemFail', 'RedPill', 'BluePill',
  ];

  for (int i = 0; i < 50; i++) {
    entries.add(LeaderboardEntry(
      id: 'mock_$i',
      displayName: names[random.nextInt(names.length)] + random.nextInt(999).toString(),
      score: random.nextInt(15000) + 1000, 
      level: random.nextInt(35) + 5,
      avatarIndex: random.nextInt(10),
    ));
  }

  if (profile != null) {
    entries.add(LeaderboardEntry(
      id: profile.id,
      displayName: 'You (Player)',
      score: profile.xp, // Monthly score might just be their total XP for now
      level: profile.level,
      isCurrentUser: true,
      avatarIndex: 0,
    ));
  }

  entries.sort((a, b) => b.score.compareTo(a.score));

  return entries;
}

@riverpod
Future<List<AllianceEntry>> allianceLeaderboard(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 800));

  final random = Random(999);
  final List<AllianceEntry> entries = [];

  final names = [
    'The Archons', 'NullSec', 'CyberPunkz', 'Hacktivists', 'Anonymous',
    'NightCity Elite', 'CorpoRats', 'NetRunners', 'SaveTheWorld', 'CryptoBros'
  ];

  for (int i = 0; i < names.length; i++) {
    entries.add(AllianceEntry(
      id: 'all_$i',
      name: names[i],
      totalScore: random.nextInt(100000) + 10000,
      membersCount: random.nextInt(10) + 2,
      isUserAlliance: i == 3, // Mock that user is in 4th alliance
    ));
  }

  entries.sort((a, b) => b.totalScore.compareTo(a.totalScore));
  return entries;
}
