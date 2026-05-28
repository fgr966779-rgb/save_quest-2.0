// ФАЙЛ: lib/data/backup_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import 'database.dart';
import 'settings_service.dart';

/// Full backup model containing all Drift tables and Hive settings.
class PiggyVaultBackup {
  final int version;
  final DateTime createdAt;
  final String appVersion;

  // Drift tables — each is a List of JSON-serializable maps (camelCase keys).
  final List<Map<String, dynamic>> goals;
  final List<Map<String, dynamic>> deposits;
  final List<Map<String, dynamic>> userProfiles;
  final List<Map<String, dynamic>> unlockedAchievements;
  final List<Map<String, dynamic>> unlockedSkills;
  final List<Map<String, dynamic>> lootboxes;
  final List<Map<String, dynamic>> pets;
  final List<Map<String, dynamic>> squads;
  final List<Map<String, dynamic>> sideQuests;
  final List<Map<String, dynamic>> transactionTags;
  final List<Map<String, dynamic>> voiceLogs;
  final List<Map<String, dynamic>> penaltyHabits;
  final List<Map<String, dynamic>> jointGoals;
  final List<Map<String, dynamic>> jointGoalMembers;
  final List<Map<String, dynamic>> avoidedPurchases;

  // Hive settings
  final Map<String, dynamic> settings;

  const PiggyVaultBackup({
    required this.version,
    required this.createdAt,
    required this.appVersion,
    required this.goals,
    required this.deposits,
    required this.userProfiles,
    required this.unlockedAchievements,
    required this.unlockedSkills,
    required this.lootboxes,
    required this.pets,
    required this.squads,
    required this.sideQuests,
    required this.transactionTags,
    required this.voiceLogs,
    required this.penaltyHabits,
    required this.jointGoals,
    required this.jointGoalMembers,
    required this.avoidedPurchases,
    required this.settings,
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'createdAt': createdAt.toIso8601String(),
        'appVersion': appVersion,
        'goals': goals,
        'deposits': deposits,
        'userProfiles': userProfiles,
        'unlockedAchievements': unlockedAchievements,
        'unlockedSkills': unlockedSkills,
        'lootboxes': lootboxes,
        'pets': pets,
        'squads': squads,
        'sideQuests': sideQuests,
        'transactionTags': transactionTags,
        'voiceLogs': voiceLogs,
        'penaltyHabits': penaltyHabits,
        'jointGoals': jointGoals,
        'jointGoalMembers': jointGoalMembers,
        'avoidedPurchases': avoidedPurchases,
        'settings': settings,
      };

  factory PiggyVaultBackup.fromJson(Map<String, dynamic> json) {
    return PiggyVaultBackup(
      version: json['version'] as int? ?? 1,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      appVersion: json['appVersion'] as String? ?? 'unknown',
      goals: _castList(json['goals']),
      deposits: _castList(json['deposits']),
      userProfiles: _castList(json['userProfiles']),
      unlockedAchievements: _castList(json['unlockedAchievements']),
      unlockedSkills: _castList(json['unlockedSkills']),
      lootboxes: _castList(json['lootboxes']),
      pets: _castList(json['pets']),
      squads: _castList(json['squads']),
      sideQuests: _castList(json['sideQuests']),
      transactionTags: _castList(json['transactionTags']),
      voiceLogs: _castList(json['voiceLogs']),
      penaltyHabits: _castList(json['penaltyHabits']),
      jointGoals: _castList(json['jointGoals']),
      jointGoalMembers: _castList(json['jointGoalMembers']),
      avoidedPurchases: _castList(json['avoidedPurchases']),
      settings: (json['settings'] as Map<String, dynamic>?) ?? {},
    );
  }

  static List<Map<String, dynamic>> _castList(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return [];
  }
}

/// Service for exporting and importing full app backups as JSON files.
class BackupService {
  static const int _currentBackupVersion = 1;
  static const String _appVersion = '1.0.0';
  static const String _backupFileName = 'piggyvault_backup';
  static const String _backupMimeType = 'application/json';

  final AppDatabase _db;
  final SettingsService? _settings;

  BackupService(this._db, [this._settings]);

  // ────────────────────────────────────────────
  // EXPORT
  // ────────────────────────────────────────────

  /// Serializes all Drift tables + Hive settings into a [PiggyVaultBackup].
  Future<PiggyVaultBackup> createBackup() async {
    return PiggyVaultBackup(
      version: _currentBackupVersion,
      createdAt: DateTime.now(),
      appVersion: _appVersion,
      goals: await _readAll(_db.select(_db.goals)),
      deposits: await _readAll(_db.select(_db.deposits)),
      userProfiles: await _readAll(_db.select(_db.userProfiles)),
      unlockedAchievements:
          await _readAll(_db.select(_db.unlockedAchievements)),
      unlockedSkills: await _readAll(_db.select(_db.unlockedSkills)),
      lootboxes: await _readAll(_db.select(_db.lootboxes)),
      pets: await _readAll(_db.select(_db.pets)),
      squads: await _readAll(_db.select(_db.squads)),
      sideQuests: await _readAll(_db.select(_db.sideQuests)),
      transactionTags: await _readAll(_db.select(_db.transactionTags)),
      voiceLogs: await _readAll(_db.select(_db.voiceLogs)),
      penaltyHabits: await _readAll(_db.select(_db.penaltyHabits)),
      jointGoals: await _readAll(_db.select(_db.jointGoals)),
      jointGoalMembers: await _readAll(_db.select(_db.jointGoalMembers)),
      avoidedPurchases: await _readAll(_db.select(_db.avoidedPurchases)),
      settings: _exportSettings(),
    );
  }

  /// Generic read of all rows from a select statement, serialized via toJson().
  Future<List<Map<String, dynamic>>> _readAll(dynamic selectStmt) async {
    final rows = await (selectStmt as dynamic).get() as List;
    return rows.map((row) {
      // Drift-generated DataClasses all have a toJson() method.
      try {
        return (row as dynamic).toJson() as Map<String, dynamic>;
      } catch (_) {
        return <String, dynamic>{};
      }
    }).toList();
  }

  /// Exports backup to a JSON file, then opens the native share sheet.
  /// Returns the file path on success, null on failure.
  Future<String?> exportAndShare() async {
    final backup = await createBackup();
    final jsonStr =
        const JsonEncoder.withIndent('  ').convert(backup.toJson());

    // Write to temp directory
    final dir = await getTemporaryDirectory();
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    final fileName = '${_backupFileName}_$timestamp.json';
    final filePath = p.join(dir.path, fileName);

    final file = File(filePath);
    await file.writeAsString(jsonStr);

    // Share via native share sheet
    await Share.shareXFiles(
      [XFile(filePath, mimeType: _backupMimeType)],
      subject: 'PiggyVault Backup ($timestamp)',
    );

    return filePath;
  }

  // ────────────────────────────────────────────
  // IMPORT
  // ────────────────────────────────────────────

  /// Opens a file picker, validates the backup file.
  /// Returns a parsed [PiggyVaultBackup] or null if user cancelled.
  Future<PiggyVaultBackup?> pickBackupFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;
    if (file.path == null) return null; // Web not supported

    final content = await File(file.path!).readAsString();
    if (content.trim().isEmpty) {
      throw const FormatException('Empty backup file');
    }

    final json = jsonDecode(content) as Map<String, dynamic>;

    // Validate required top-level keys
    if (!json.containsKey('version') || !json.containsKey('goals')) {
      throw const FormatException('Invalid backup format: missing required keys');
    }

    return PiggyVaultBackup.fromJson(json);
  }

  /// Restores all data from a backup into the database and settings.
  /// This is a destructive operation — all current data will be replaced.
  Future<void> restoreBackup(PiggyVaultBackup backup) async {
    await _db.transaction(() async {
      // 1. Clear all existing data
      const tables = [
        'goals',
        'deposits',
        'user_profiles',
        'unlocked_achievements',
        'unlocked_skills',
        'lootboxes',
        'pets',
        'squads',
        'side_quests',
        'transaction_tags',
        'voice_logs',
        'penalty_habits',
        'joint_goals',
        'joint_goal_members',
        'avoided_purchases',
      ];
      for (final table in tables) {
        await _db.customStatement('DELETE FROM $table');
      }

      // 2. Insert backup data using typed Drift insertOrReplace
      await _insertGoals(backup.goals);
      await _insertDeposits(backup.deposits);
      await _insertUserProfiles(backup.userProfiles);
      await _insertAchievements(backup.unlockedAchievements);
      await _insertSkills(backup.unlockedSkills);
      await _insertLootboxes(backup.lootboxes);
      await _insertPets(backup.pets);
      await _insertSquads(backup.squads);
      await _insertQuests(backup.sideQuests);
      await _insertTags(backup.transactionTags);
      await _insertVoiceLogs(backup.voiceLogs);
      await _insertPenalties(backup.penaltyHabits);
      await _insertJointGoals(backup.jointGoals);
      await _insertJointMembers(backup.jointGoalMembers);
      await _insertAvoided(backup.avoidedPurchases);
    });

    // 3. Restore Hive settings (outside transaction — Hive is separate)
    _importSettings(backup.settings);
  }

  // ────────────────────────────────────────────
  // TYPED INSERT METHODS (Drift-generated classes)
  // ────────────────────────────────────────────

  Future<void> _insertGoals(List<Map<String, dynamic>> rows) async {
    for (final r in rows) {
      await _db.into(_db.goals).insert(
            Goal(
              id: r['id'] as String,
              name: r['name'] as String,
              targetAmount: r['targetAmount'] as int,
              currentAmount: r['currentAmount'] as int,
              currency: r['currency'] as String,
              accentColor: r['accentColor'] as String,
              createdAt: _parseDate(r['createdAt']),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> _insertDeposits(List<Map<String, dynamic>> rows) async {
    for (final r in rows) {
      await _db.into(_db.deposits).insert(
            Deposit(
              id: r['id'] as String,
              amount: r['amount'] as int,
              goalAAmount: r['goalAAmount'] as int,
              goalBAmount: r['goalBAmount'] as int,
              note: r['note'] as String?,
              createdAt: _parseDate(r['createdAt']),
              isDeleted: r['isDeleted'] as bool? ?? false,
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> _insertUserProfiles(List<Map<String, dynamic>> rows) async {
    for (final r in rows) {
      await _db.into(_db.userProfiles).insert(
            UserProfile(
              id: r['id'] as int? ?? 1,
              xp: r['xp'] as int? ?? 0,
              level: r['level'] as int? ?? 1,
              streakCount: r['streakCount'] as int? ?? 0,
              maxStreak: r['maxStreak'] as int? ?? 0,
              freezeTokens: r['freezeTokens'] as int? ?? 0,
              lastDepositDate: _parseNullableDate(r['lastDepositDate']),
              skillPoints: r['skillPoints'] as int? ?? 0,
              playerClass: r['playerClass'] as String?,
              currentTheme: r['currentTheme'] as String? ?? 'default',
              avatarConfig: r['avatarConfig'] as String?,
              penaltyBalance: r['penaltyBalance'] as int? ?? 0,
              hackerXp: r['hackerXp'] as int? ?? 0,
              magnateXp: r['magnateXp'] as int? ?? 0,
              resilienceXp: r['resilienceXp'] as int? ?? 0,
              lastBonusClaimDate: _parseNullableDate(r['lastBonusClaimDate']),
              bonusStreak: r['bonusStreak'] as int? ?? 0,
              crystalsBalance: r['crystalsBalance'] as int? ?? 0,
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> _insertAchievements(List<Map<String, dynamic>> rows) async {
    for (final r in rows) {
      await _db.into(_db.unlockedAchievements).insert(
            UnlockedAchievement(
              id: r['id'] as String,
              unlockedAt: _parseDate(r['unlockedAt']),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> _insertSkills(List<Map<String, dynamic>> rows) async {
    for (final r in rows) {
      await _db.into(_db.unlockedSkills).insert(
            UnlockedSkill(
              id: r['id'] as String,
              unlockedAt: _parseDate(r['unlockedAt']),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> _insertLootboxes(List<Map<String, dynamic>> rows) async {
    for (final r in rows) {
      await _db.into(_db.lootboxes).insert(
            Lootboxe(
              id: r['id'] as String,
              rarity: r['rarity'] as String,
              isOpened: r['isOpened'] as bool? ?? false,
              earnedAt: _parseDate(r['earnedAt']),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> _insertPets(List<Map<String, dynamic>> rows) async {
    for (final r in rows) {
      await _db.into(_db.pets).insert(
            Pet(
              id: r['id'] as String,
              petType: r['petType'] as String,
              happinessLevel: r['happinessLevel'] as int? ?? 100,
              lastFedAt: _parseDate(r['lastFedAt']),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> _insertSquads(List<Map<String, dynamic>> rows) async {
    for (final r in rows) {
      await _db.into(_db.squads).insert(
            Squad(
              id: r['id'] as String,
              name: r['name'] as String,
              totalXp: r['totalXp'] as int? ?? 0,
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> _insertQuests(List<Map<String, dynamic>> rows) async {
    for (final r in rows) {
      await _db.into(_db.sideQuests).insert(
            SideQuest(
              id: r['id'] as String,
              title: r['title'] as String,
              description: r['description'] as String,
              isCompleted: r['isCompleted'] as bool? ?? false,
              expiresAt: _parseDate(r['expiresAt']),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> _insertTags(List<Map<String, dynamic>> rows) async {
    for (final r in rows) {
      await _db.into(_db.transactionTags).insert(
            TransactionTag(
              id: r['id'] as String,
              depositId: r['depositId'] as String,
              tag: r['tag'] as String,
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> _insertVoiceLogs(List<Map<String, dynamic>> rows) async {
    for (final r in rows) {
      await _db.into(_db.voiceLogs).insert(
            VoiceLog(
              id: r['id'] as String,
              depositId: r['depositId'] as String,
              filePath: r['filePath'] as String,
              recordedAt: _parseDate(r['recordedAt']),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> _insertPenalties(List<Map<String, dynamic>> rows) async {
    for (final r in rows) {
      await _db.into(_db.penaltyHabits).insert(
            PenaltyHabit(
              id: r['id'] as String,
              habitName: r['habitName'] as String,
              penaltyAmount: r['penaltyAmount'] as int,
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> _insertJointGoals(List<Map<String, dynamic>> rows) async {
    for (final r in rows) {
      await _db.into(_db.jointGoals).insert(
            JointGoal(
              id: r['id'] as String,
              title: r['title'] as String,
              targetAmount: r['targetAmount'] as int,
              currentAmount: r['currentAmount'] as int? ?? 0,
              deadline: _parseNullableDate(r['deadline']),
              createdAt: _parseDate(r['createdAt']),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> _insertJointMembers(List<Map<String, dynamic>> rows) async {
    for (final r in rows) {
      await _db.into(_db.jointGoalMembers).insert(
            JointGoalMember(
              id: r['id'] as String,
              goalId: r['goalId'] as String,
              memberName: r['memberName'] as String,
              contributedAmount: r['contributedAmount'] as int? ?? 0,
              avatarIndex: r['avatarIndex'] as int? ?? 0,
              isCurrentUser: r['isCurrentUser'] as bool? ?? false,
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  Future<void> _insertAvoided(List<Map<String, dynamic>> rows) async {
    for (final r in rows) {
      await _db.into(_db.avoidedPurchases).insert(
            AvoidedPurchase(
              id: r['id'] as String,
              title: r['title'] as String,
              amount: r['amount'] as int,
              createdAt: _parseDate(r['createdAt']),
            ),
            mode: InsertMode.insertOrReplace,
          );
    }
  }

  // ────────────────────────────────────────────
  // DATE PARSING HELPERS
  // ────────────────────────────────────────────

  /// Parses a DateTime from either ISO8601 string or milliseconds since epoch.
  DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return DateTime.now();
  }

  DateTime? _parseNullableDate(dynamic value) {
    if (value == null) return null;
    return _parseDate(value);
  }

  // ────────────────────────────────────────────
  // HIVE SETTINGS EXPORT / IMPORT
  // ────────────────────────────────────────────

  Map<String, dynamic> _exportSettings() {
    if (_settings == null) return {};
    return {
      'has_completed_onboarding': _settings.hasCompletedOnboarding,
      'currency': _settings.currency,
      'sound_enabled': _settings.isSoundEnabled,
      'haptic_enabled': _settings.isHapticEnabled,
      'locale': _settings.locale,
      'privacy_mode': _settings.privacyMode,
      'theme_mode': _settings.themeMode,
      'coach_personality': _settings.coachPersonality,
      'blacklisted_categories': _settings.blacklistedCategories,
      'cloud_backup_enabled': _settings.isCloudBackupEnabled,
      // Skip: openRouterApiKey (security — not in backup)
      // Skip: lastSpinDate, activeBounty, dailyQuests, dailyQuestsDate (ephemeral)
    };
  }

  void _importSettings(Map<String, dynamic> data) {
    if (_settings == null) return;
    if (data.containsKey('has_completed_onboarding')) {
      _settings.hasCompletedOnboarding =
          data['has_completed_onboarding'] as bool;
    }
    if (data.containsKey('currency')) {
      _settings.currency = data['currency'] as String;
    }
    if (data.containsKey('sound_enabled')) {
      _settings.isSoundEnabled = data['sound_enabled'] as bool;
    }
    if (data.containsKey('haptic_enabled')) {
      _settings.isHapticEnabled = data['haptic_enabled'] as bool;
    }
    if (data.containsKey('locale')) {
      _settings.locale = data['locale'] as String;
    }
    if (data.containsKey('privacy_mode')) {
      _settings.privacyMode = data['privacy_mode'] as bool;
    }
    if (data.containsKey('theme_mode')) {
      _settings.themeMode = data['theme_mode'] as String;
    }
    if (data.containsKey('coach_personality')) {
      _settings.coachPersonality = data['coach_personality'] as String;
    }
    if (data.containsKey('blacklisted_categories')) {
      final raw = data['blacklisted_categories'];
      if (raw is List) {
        _settings.blacklistedCategories = raw.cast<String>();
      }
    }
    if (data.containsKey('cloud_backup_enabled')) {
      _settings.isCloudBackupEnabled = data['cloud_backup_enabled'] as bool;
    }
  }

  // ────────────────────────────────────────────
  // CSV EXPORT
  // ────────────────────────────────────────────

  /// Exports all non-deleted deposits as a CSV file and opens share sheet.
  /// CSV format: date,goalA_name,goalA_amount,goalB_name,goalB_amount,currency,note
  /// Returns the file path on success.
  /// Throws [StateError] if no deposits exist.
  Future<String> exportCsv() async {
    // 1. Read all deposits (non-deleted, ordered by date desc)
    final deposits = await _db.getAllDeposits();
    if (deposits.isEmpty) {
      throw StateError('No deposits to export');
    }

    // 2. Read goals for names
    final goals = await _db.getAllGoals();
    final goalAName = goals
            .where((g) => g.id == 'goal_a')
            .map((g) => g.name)
            .firstOrNull ??
        'Goal A';
    final goalBName = goals
            .where((g) => g.id == 'goal_b')
            .map((g) => g.name)
            .firstOrNull ??
        'Goal B';
    final currency = _settings?.currency ?? '₴';

    // 3. Build CSV content
    final buffer = StringBuffer();
    // BOM for Excel UTF-8 compatibility
    buffer.write('\uFEFF');
    // Header
    buffer.writeln(
        'date,goalA_name,goalA_amount,goalB_name,goalB_amount,total_amount,currency,note');

    // Rows
    for (final d in deposits) {
      final date = d.createdAt.toIso8601String().split('T').first;
      final noteEscaped = _csvEscape(d.note ?? '');
      final goalAAmount = (d.goalAAmount / 100).toStringAsFixed(2);
      final goalBAmount = (d.goalBAmount / 100).toStringAsFixed(2);
      final totalAmount = (d.amount / 100).toStringAsFixed(2);

      buffer.writeln(
          '$date,${_csvEscape(goalAName)},$goalAAmount,${_csvEscape(goalBName)},$goalBAmount,$totalAmount,$currency,$noteEscaped');
    }

    // 4. Write to temp file
    final dir = await getTemporaryDirectory();
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    final fileName = 'piggyvault_transactions_$timestamp.csv';
    final filePath = p.join(dir.path, fileName);

    final file = File(filePath);
    await file.writeAsString(buffer.toString());

    // 5. Share
    await Share.shareXFiles(
      [XFile(filePath, mimeType: 'text/csv')],
      subject: 'PiggyVault Transactions ($timestamp)',
    );

    return filePath;
  }

  /// Escapes a CSV field: wraps in double quotes and doubles any internal quotes.
  String _csvEscape(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  // =========================================================================
  // CSV IMPORT
  // =========================================================================

  /// Import deposits from a CSV file.
  ///
  /// Expected CSV format (header row required):
  /// `date,amount,goal_a,goal_b,note`
  ///
  /// - date: ISO 8601 or `dd.MM.yyyy` format
  /// - amount: total deposit in display units (hryvnias, not kopecks)
  /// - goal_a: amount for Goal A (display units)
  /// - goal_b: amount for Goal B (display units)
  /// - note: optional memo text
  ///
  /// Returns the number of successfully imported rows.
  Future<int> importCsv() async {
    // 1. Pick file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result == null || result.files.isEmpty) return 0;

    final filePath = result.files.single.path;
    if (filePath == null) return 0;

    final file = File(filePath);
    if (!await file.exists()) return 0;

    final contents = await file.readAsString();
    final lines = const LineSplitter().convert(contents);

    if (lines.length < 2) return 0; // need at least header + 1 row

    // 2. Parse header
    final header = _parseCsvLine(lines[0]).map((s) => s.toLowerCase().trim()).toList();
    final requiredCols = ['date', 'amount'];
    for (final col in requiredCols) {
      if (!header.contains(col)) {
        throw FormatException('Missing required column: $col');
      }
    }

    final dateIdx = header.indexOf('date');
    final amountIdx = header.indexOf('amount');
    final goalAIdx = header.indexOf('goal_a');
    final goalBIdx = header.indexOf('goal_b');
    final noteIdx = header.indexOf('note');

    // 3. Parse and insert rows in a transaction
    int importedCount = 0;
    await _db.transaction(() async {
      for (var i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        final fields = _parseCsvLine(line);
        if (fields.length <= amountIdx) continue;

        // Parse date
        DateTime? date;
        try {
          final dateStr = fields[dateIdx].trim();
          // Try ISO 8601 first
          date = DateTime.tryParse(dateStr);
          if (date == null) {
            // Try dd.MM.yyyy
            final parts = dateStr.split('.');
            if (parts.length == 3) {
              date = DateTime(
                int.tryParse(parts[2]) ?? 0,
                int.tryParse(parts[1]) ?? 1,
                int.tryParse(parts[0]) ?? 1,
              );
            }
          }
        } catch (_) {
          continue; // skip invalid row
        }
        if (date == null) continue;

        // Parse amounts (display units → kopecks)
        final amount = (double.tryParse(
              fields[amountIdx].trim().replaceAll(',', '.'),
            ) ?? 0) * 100;
        final goalA = goalAIdx >= 0 && goalAIdx < fields.length
            ? (double.tryParse(
                  fields[goalAIdx].trim().replaceAll(',', '.'),
                ) ?? 0) * 100
            : 0;
        final goalB = goalBIdx >= 0 && goalBIdx < fields.length
            ? (double.tryParse(
                  fields[goalBIdx].trim().replaceAll(',', '.'),
                ) ?? 0) * 100
            : 0;
        final note = noteIdx >= 0 && noteIdx < fields.length
            ? fields[noteIdx].trim()
            : 'CSV Import';

        // Insert deposit
        await _db.into(_db.deposits).insert(
              Deposit(
                id: '${DateTime.now().millisecondsSinceEpoch}_$i',
                amount: amount.round(),
                goalAAmount: goalA.round(),
                goalBAmount: goalB.round(),
                note: note,
                createdAt: date,
                isDeleted: false,
              ),
            );

        importedCount++;
      }
    });

    return importedCount;
  }

  /// Parse a single CSV line respecting quoted fields.
  List<String> _parseCsvLine(String line) {
    final result = <String>[];
    var current = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final char = line[i];

      if (inQuotes) {
        if (char == '"') {
          if (i + 1 < line.length && line[i + 1] == '"') {
            current.write('"');
            i++; // skip escaped quote
          } else {
            inQuotes = false;
          }
        } else {
          current.write(char);
        }
      } else {
        if (char == '"') {
          inQuotes = true;
        } else if (char == ',') {
          result.add(current.toString());
          current = StringBuffer();
        } else {
          current.write(char);
        }
      }
    }
    result.add(current.toString());
    return result;
  }
}
