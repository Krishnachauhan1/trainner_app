import 'package:flutter/material.dart';

class AppThemeData {
  AppThemeData({required this.primary, required this.isTrainer});

  final Color primary;
  final bool isTrainer;

  static const spacing = 8.0;

  ThemeData build() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF8F9FB),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  static const guruPrimary = Color(0xFF1769E0);
  static const trainerPrimary = Color(0xFFE50914);
}
