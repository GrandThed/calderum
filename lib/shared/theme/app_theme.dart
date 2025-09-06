import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6B4E96);
  static const Color secondaryColor = Color(0xFFD4AF37);
  static const Color accentColor = Color(0xFF8B5A87);
  static const Color backgroundColor = Color(0xFF1A1A2E);
  static const Color surfaceColor = Color(0xFF16213E);
  static const Color errorColor = Color(0xFFE53E3E);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Caudex'),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontFamily: 'Caudex',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: secondaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Caudex',
          color: Colors.white70,
        ),
        hintStyle: const TextStyle(fontFamily: 'Caudex', color: Colors.white38),
      ),
    );
  }

  static TextStyle get headlineStyle => const TextStyle(
    fontFamily: 'Caveat',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: secondaryColor,
  );

  static TextStyle get titleStyle => const TextStyle(
    fontFamily: 'Caudex',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get headingStyle => const TextStyle(
    fontFamily: 'Caudex',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get bodyStyle =>
      const TextStyle(fontFamily: 'Caudex', fontSize: 16, color: Colors.white);
  
  static Color getPlayerColor(String userId) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.red,
    ];
    
    final hash = userId.hashCode.abs();
    return colors[hash % colors.length];
  }
}