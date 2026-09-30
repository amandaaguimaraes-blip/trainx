import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFF111111);
  static const sidebar = Color(0xFF161616);
  static const card = Color(0xFF1C1C1C);
  static const border = Color(0xFF2A2A2A);
  static const orange = Color(0xFFFF5A1F);
  static const text = Color(0xFFF5F5F5);
  static const muted = Color(0xFF8A8A8A);
  static const green = Color(0xFF2ECC71);
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.orange,
      surface: AppColors.card,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.sidebar,
      indicatorColor: AppColors.orange.withOpacity(0.2),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
