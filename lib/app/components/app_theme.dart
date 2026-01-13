import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromRGBO(204, 230, 245, 1),
    ),

    textTheme: GoogleFonts.nunitoTextTheme().copyWith(
      bodyMedium: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: Colors.black87,
      ),
    ),

    appBarTheme: AppBarThemeData(
      elevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22,
        color: Colors.black87,
      ),
    ),

    drawerTheme: DrawerThemeData(
      backgroundColor: const Color.fromRGBO(217, 234, 243, 1),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color.fromRGBO(241, 163, 181, 1),
      splashColor: const Color.fromRGBO(225, 115, 140, 1),
      foregroundColor: Colors.white,
      elevation: 0,
      extendedTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconSize: 24.0,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color.fromRGBO(217, 234, 243, 1),

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
      floatingLabelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),

      labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: const Color.fromRGBO(241, 163, 181, 1),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8.0),
        ),
        minimumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    listTileTheme: ListTileThemeData(
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.grey[700],
      ),
      iconColor: Colors.grey[600],
      contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
    ),
  );
}
