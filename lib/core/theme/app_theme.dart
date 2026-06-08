import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    primaryColor: AppColors.primary,

    scaffoldBackgroundColor: const Color(0xffF4F7F4),

    cardColor: Colors.white,

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffF4F7F4),
      elevation: 0,
      foregroundColor: Colors.black,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    primaryColor: AppColors.primary,

    scaffoldBackgroundColor: const Color(0xff111827),

    cardColor: const Color(0xff1F2937),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff111827),
      elevation: 0,
      foregroundColor: Colors.white,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}
