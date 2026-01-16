import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workspace/app/home_page.dart';
import 'package:workspace/app/theme/app_theme.dart';
import 'package:workspace/data/settings_database.dart';
import 'package:workspace/models/hive/pet.dart';
import 'package:workspace/models/hive/settings.dart';
import 'package:workspace/util/app_logger.dart';
import 'package:workspace/util/image_util.dart';
import 'package:workspace/util/provider/theme_provider.dart';

late SettingsDatabase settingsDatabase;

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await AppLogger().init();
      await _initHive();
      await ImageUtil().init();

      try {} catch (e, stack) {
        appLogger.e("Initialization Error", error: e, stackTrace: stack);
      }

      FlutterError.onError = (FlutterErrorDetails details) {
        appLogger.e(
          "Flutter Error",
          error: details.exception,
          stackTrace: details.stack,
        );
      };

      PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
        appLogger.f("Global Async Error", error: error, stackTrace: stack);
        return true;
      };

      runApp(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(settingsDatabase),
          child: const MyApp(),
        ),
      );
    },
    (Object error, StackTrace stackTrace) {
      appLogger.f('Fatal Zone Error', error: error, stackTrace: stackTrace);
    },
  );
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PetAdapter());
  Hive.registerAdapter(SettingsAdapter());

  await Hive.openBox<Pet>('pets');
  final settingsBox = await Hive.openBox<Settings>('settings');
  settingsDatabase = SettingsDatabase(settingsBox);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Purrsonal',

      themeMode: themeProvider.themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      home: HomePage(),
    );
  }
}
