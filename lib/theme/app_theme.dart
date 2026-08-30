import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryBackground = Color(0xFF0A0E17);
  static const Color secondaryBackground = Color(0xFF1A202E);
  static const Color tertiaryBackground = Color(0xFF13232C);
  
  static const Color primaryTeal = Color(0xFF10B981);
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryOrange = Color(0xFFF59E0B);
  static const Color alertRed = Colors.redAccent;
  static const Color textPrimary = Colors.white;
  
  // Opacities
  static final Color textSecondary = Colors.white.withAlpha(153);
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryBackground,
      colorScheme: ColorScheme.dark(
        surface: primaryBackground,
        primary: primaryTeal,
        secondary: primaryBlue,
        error: alertRed,
        onSurface: textPrimary,
      ),
      textTheme: TextTheme(
        titleLarge: const TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        titleMedium: const TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        bodyLarge: const TextStyle(
          color: textPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTeal,
          foregroundColor: primaryBackground,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
