import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3A86FF)),
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF7F9FF),
  );
}
