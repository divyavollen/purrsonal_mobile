import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/app/components/app_theme.dart';
import 'package:workspace/app/home_page.dart';
import 'package:workspace/models/pet.dart';
import 'package:workspace/util/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppLogger().init();

  FlutterError.onError = (FlutterErrorDetails details) {
    logger.e('*** App Error ***');
    logger.e(details.exceptionAsString());
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    logger.e('*** Async/Root Error ***');
    logger.e(error.toString());
    return true;
  };

  await Hive.initFlutter();
  Hive.registerAdapter(PetAdapter());

  await Hive.openBox<Pet>('pets');
  await Hive.openBox('settings');
  runApp(const MyApp());
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
