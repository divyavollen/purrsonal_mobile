import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/models/pet.dart';
import 'package:workspace/pages/home_page.dart';
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

      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromRGBO(204, 230, 245, 1),
        ),

        appBarTheme: AppBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),

        drawerTheme: DrawerThemeData(
          backgroundColor: const Color.fromRGBO(217, 234, 243, 1),
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color.fromRGBO(241, 163, 181, 1),
          splashColor: const Color.fromRGBO(225, 115, 140, 1),
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}
