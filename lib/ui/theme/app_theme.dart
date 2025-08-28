import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlack = Color(0xFF121212);
  static const Color secondaryGray = Color(0xFF1E1E1E);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color accentSilver = Color(0xFFBDBDBD);

  static final ThemeData themeData = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: primaryBlack,
    primaryColor: accentGold,
    appBarTheme: const AppBarTheme(
      backgroundColor: secondaryGray,
      elevation: 0,
      iconTheme: IconThemeData(color: accentSilver),
      titleTextStyle: TextStyle(
        color: accentSilver,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // ✅ A CORREÇÃO ESTÁ AQUI: CardThemeData
    cardTheme: CardThemeData(
      color: secondaryGray,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentGold,
      foregroundColor: primaryBlack,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: accentGold,
          foregroundColor: primaryBlack,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: secondaryGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: accentGold),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: accentGold,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: accentGold,
    ),
  );
}
