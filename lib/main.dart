import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/app/components/app_theme.dart';
import 'package:workspace/app/home_page.dart';
import 'package:workspace/models/pet.dart';
import 'package:workspace/util/app_logger.dart';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await AppLogger().init();

      try {
        await Hive.initFlutter();
        Hive.registerAdapter(PetAdapter());

        await Hive.openBox<Pet>('pets');
      } catch (e, stack) {
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

      runApp(const MyApp());
    },
    (Object error, StackTrace stackTrace) {
      appLogger.f('Fatal Zone Error', error: error, stackTrace: stackTrace);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Purrsonal',

      theme: AppTheme.light,

      home: const HomePage(),
    );
  }
}
