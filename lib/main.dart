import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/navigation/app_router.dart';
import 'core/providers/providers.dart';
import 'core/theme/app_theme.dart';
import 'data/database.dart';
import 'data/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local Hive Key-Value store
  await Hive.initFlutter();
  
  // Open the primary configuration box
  final settingsBox = await Hive.openBox(SettingsService.boxName);
  final settingsService = SettingsService(settingsBox);

  // Initialize Drift Database
  final database = AppDatabase();

  runApp(
    ProviderScope(
      overrides: [
        // Pre-initialized Database and SettingsService injected into provider overrides
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

    return MaterialApp.router(
      title: 'Скарбничка Мрії (PiggyVault)',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
      // Localization delegates for perfect calendar and typography
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('uk', 'UA'),
        Locale('en', 'US'),
      ],
      locale: const Locale('uk', 'UA'),
    );
  }
}
