import 'package:calderum/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

final calderumTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF1E1236),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFFFB347),
    primary: const Color(0xFFFFB347),
    secondary: const Color(0xFF3F2A78),
    brightness: Brightness.dark,
  ),
  textTheme: CalderumTextTheme,
);
