import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromRGBO(204, 230, 245, 1),
      secondaryContainer: Color.fromRGBO(217, 234, 243, 1),
      tertiaryContainer: Color.fromRGBO(177, 201, 214, 1),
      primary: Color.fromRGBO(122, 180, 214, 1),
      tertiary: Color.fromRGBO(225, 115, 140, 1),
      surfaceContainerHighest: Color.fromARGB(255, 222, 229, 233),
      onSurface: Colors.grey[900],
      onSurfaceVariant: Colors.grey[600],
      error: const Color.fromARGB(255, 207, 1, 39),
    ),

    scaffoldBackgroundColor: const Color.fromRGBO(242, 248, 252, 1),

    textTheme: _buildTextTheme(
      GoogleFonts.nunitoTextTheme(),
      Colors.grey[900]!,
    ),

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(iconSize: 24),
    ),

    appBarTheme: AppBarThemeData(
      elevation: 0,
      backgroundColor: const Color.fromRGBO(242, 248, 252, 1),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22,
        color: Colors.grey[900],
      ),
    ),

    drawerTheme: DrawerThemeData(
      backgroundColor: const Color.fromRGBO(217, 234, 243, 1),
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

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color.fromRGBO(241, 163, 181, 1),
      splashColor: const Color.fromRGBO(225, 115, 140, 1),
      foregroundColor: Colors.grey[800],
      elevation: 0,
      extendedTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(66, 66, 66, 1),
      ),
      iconSize: 28.0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: const Color.fromRGBO(241, 163, 181, 1),
        foregroundColor: Colors.grey[800],
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

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    listTileTheme: ListTileThemeData(
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.grey[900],
      ),
      iconColor: Colors.grey[800],
      contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
    ),

    iconTheme: IconThemeData(
      color: Colors.grey[800],
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromRGBO(176, 206, 218, 1),
      brightness: Brightness.dark,
      secondaryContainer: const Color.fromRGBO(37, 45, 52, 1),
      primary: const Color.fromRGBO(176, 206, 218, 1),
      tertiary: const Color.fromRGBO(243, 176, 190, 1),
      surfaceContainerHighest: const Color.fromRGBO(44, 44, 44, 1),
      onSurface: const Color.fromRGBO(225, 227, 229, 1),
      onSurfaceVariant: const Color.fromRGBO(175, 179, 183, 1),
      error: const Color.fromRGBO(207, 102, 121, 1),
    ),

    scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),

    textTheme: _buildTextTheme(
      GoogleFonts.nunitoTextTheme(),
      const Color.fromRGBO(225, 227, 229, 1),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(iconSize: 24),
    ),

    appBarTheme: const AppBarThemeData(
      elevation: 0,
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22,
        color: Color.fromRGBO(225, 227, 229, 1),
      ),
    ),

    drawerTheme: const DrawerThemeData(
      backgroundColor: Color.fromRGBO(37, 45, 52, 1),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color.fromRGBO(37, 45, 52, 1),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color.fromRGBO(69, 71, 73, 1),
          width: 1.0,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color.fromRGBO(130, 177, 255, 1),
          width: 2.0,
        ),
      ),

      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelStyle: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 18,
      ),
      labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color.fromRGBO(243, 176, 190, 1),
      splashColor: const Color.fromRGBO(225, 115, 140, 1),
      foregroundColor: const Color.fromRGBO(33, 33, 33, 1),
      elevation: 0,
      extendedTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(33, 33, 33, 1),
      ),
      iconSize: 28.0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: const Color.fromRGBO(243, 176, 190, 1),
        foregroundColor: const Color.fromRGBO(33, 33, 33, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        minimumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        foregroundColor: const Color.fromRGBO(176, 206, 218, 1),
      ),
    ),

    listTileTheme: ListTileThemeData(
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: const Color.fromRGBO(225, 227, 229, 1),
      ),
      iconColor: const Color.fromRGBO(144, 148, 151, 1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
    ),

    iconTheme: const IconThemeData(
      color: Color.fromRGBO(144, 148, 151, 1),
    ),
  );

  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    return base
        .copyWith(
          bodyMedium: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
          headlineSmall: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: textColor,
          ),
          titleSmall: TextStyle(fontSize: 16, color: textColor),
        )
        .apply(displayColor: textColor, bodyColor: textColor)
        .merge(
          const TextTheme(
            displayLarge: TextStyle(letterSpacing: 0.5),
            displayMedium: TextStyle(letterSpacing: 0.5),
            displaySmall: TextStyle(letterSpacing: 0.5),
            headlineLarge: TextStyle(letterSpacing: 0.5),
            headlineMedium: TextStyle(letterSpacing: 0.5),
            headlineSmall: TextStyle(letterSpacing: 0.5),
            titleLarge: TextStyle(letterSpacing: 0.5),
            titleMedium: TextStyle(letterSpacing: 0.5),
            titleSmall: TextStyle(letterSpacing: 0.5),
            bodyLarge: TextStyle(letterSpacing: 0.5),
            bodyMedium: TextStyle(letterSpacing: 0.5),
            bodySmall: TextStyle(letterSpacing: 0.5),
            labelLarge: TextStyle(letterSpacing: 0.5),
            labelMedium: TextStyle(letterSpacing: 0.5),
            labelSmall: TextStyle(letterSpacing: 0.5),
          ),
        );
  }
}
