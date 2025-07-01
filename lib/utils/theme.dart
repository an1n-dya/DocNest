import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Color palette
  static const Color primaryBlue = Color(0xFF0066FF);
  static const Color primaryBlueLight = Color(0xFF4D94FF);
  static const Color primaryBlueDark = Color(0xFF0052CC);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentOrange = Color(0xFFFF8A00);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F0F0F);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF262626);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryBlue,
      secondary: accentPurple,
      tertiary: accentGreen,
      surface: surfaceLight,
      background: backgroundLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1A1A1A),
      onBackground: Color(0xFF1A1A1A),
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: cardLight,
    fontFamily: 'Inter',

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(color: primaryBlue, size: 24),
      titleTextStyle: TextStyle(
        color: Color(0xFF1A1A1A),
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
    ),

    // Card Theme
    // FIX: Changed CardTheme to CardThemeData
    cardTheme: CardThemeData(
      color: cardLight,
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade100, width: 1),
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      elevation: 8,
      highlightElevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: cardLight,
      elevation: 24,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: const TextStyle(
        color: Color(0xFF1A1A1A),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),

    // Button Themes
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.transparent,
      iconColor: primaryBlue,
      textColor: const Color(0xFF1A1A1A),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryBlueLight,
      secondary: accentPurple,
      tertiary: accentGreen,
      surface: surfaceDark,
      background: backgroundDark,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: cardDark,
    fontFamily: 'Inter',

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: primaryBlueLight, size: 24),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
    ),

    // FIX: Changed CardTheme to CardThemeData
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade800, width: 1),
      ),
    ),
  );

  // Gradient definitions
  static const Gradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient accentGradient = LinearGradient(
    colors: [accentPurple, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Animation durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 32,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> floatingButtonShadow = [
    BoxShadow(
      color: primaryBlue.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}
