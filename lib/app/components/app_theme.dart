import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
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

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
      ),

      floatingLabelBehavior: FloatingLabelBehavior.always,

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );
}
