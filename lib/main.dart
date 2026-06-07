import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/navigation/app_router.dart';
import 'core/providers/providers.dart';
import 'core/providers/l10n.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'core/services/sound_service.dart';
import 'core/services/milestone_service.dart';
import 'core/services/weekly_challenge_service.dart';
import 'core/services/goal_dependency_service.dart';
import 'data/database.dart';
import 'data/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialize local Hive Key-Value store
  await Hive.initFlutter();

  // Open the primary configuration box
  final settingsBox = await Hive.openBox(SettingsService.boxName);
  final settingsService = SettingsService(settingsBox);

  // Initialize Drift Database
  final database = AppDatabase();

  // Open notification storage box
  await Hive.openBox('notifications_box');

  // Initialize services
  await NotificationService().init();
  await MilestoneService.init();
  await WeeklyChallengeService.init();
  await GoalDependencyService.init();
  SoundService().isSoundEnabled = settingsService.isSoundEnabled;

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        settingsServiceProvider.overrideWithValue(settingsService),
      ],
      child: const PiggyVaultApp(),
    ),
  );
}

class PiggyVaultApp extends ConsumerWidget {
  const PiggyVaultApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final localeStr = ref.watch(localeProvider);
    final locale = localeStr == 'en'
        ? const Locale('en', 'US')
        : const Locale('uk', 'UA');

    return MaterialApp.router(
      title: 'PiggyVault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('uk', 'UA'),
        Locale('en', 'US'),
      ],
      locale: locale,
    );
  }
}
