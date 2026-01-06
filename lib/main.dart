import 'package:flutter/material.dart';
import 'package:workspace/pages/home_page.dart';

void main() {
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
