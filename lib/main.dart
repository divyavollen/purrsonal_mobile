import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workspace/core/router/app_router_config.dart';
import 'package:workspace/core/theme/app_theme.dart';
import 'package:workspace/core/theme/theme_provider.dart';
import 'package:workspace/core/utils/app_logger.dart';
import 'package:workspace/core/utils/image_util.dart';
import 'package:workspace/data/database/settings_database.dart';
import 'package:workspace/data/models/hive/pet.dart';
import 'package:workspace/data/models/hive/pet_appointment.dart';
import 'package:workspace/data/models/hive/settings.dart';
import 'package:workspace/features/pets/providers/appointment_provider.dart';
import 'package:workspace/features/pets/providers/calendar_selection_provider.dart';
import 'package:workspace/features/pets/providers/pet_provider.dart';

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
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => ThemeProvider(settingsDatabase),
            ),

            ChangeNotifierProvider(
              create: (_) => PetProvider(),
            ),

            ChangeNotifierProvider(
              create: (_) => PetAppointmentProvider(),
            ),

            ChangeNotifierProvider(
              create: (_) => CalendarSelectionProvider(),
            ),
          ],
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
  Hive.registerAdapter(PetAppointmentAdapter());

  await Hive.openBox<Pet>('pets');
  await Hive.openBox<PetAppointment>('appointments');
  final settingsBox = await Hive.openBox<Settings>('settings');
  settingsDatabase = SettingsDatabase(settingsBox);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Purrsonal',

      themeMode: themeProvider.themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      routerConfig: AppRouterConfig().router,
    );
  }
}
