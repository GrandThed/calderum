import 'package:calderum/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

final calderumTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Caudex',
  fontFamilyFallback: ['Georgia', 'Times New Roman', 'serif'],
  scaffoldBackgroundColor: const Color(0xFF1E1236),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFFFB347),
    primary: const Color(0xFFFFB347),
    secondary: const Color(0xFF3F2A78),
    brightness: Brightness.dark,
  ),
  textTheme: CalderumTextTheme,
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: const Color(0xFF3F2A78),
    circularTrackColor: const Color(0xFFFFB347),
  ),
);
