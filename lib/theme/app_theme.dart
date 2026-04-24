import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Common Colors (Old naming preserved for compatibility)
  static const Color backgroundLight = Color(0xFFFBFDFF);
  static const Color accentBlue = Color(0xFFE0F2FE);
  static const Color accentPink = Color(0xFFFFE4E6);
  static const Color mainText = Color(0xFF1E293B);
  static const Color secondaryText = Color(0xFF64748B);

  static ThemeData getTheme(String themeName) {
    switch (themeName) {
      case 'dark':
        return midnightDark;
      case 'gold':
        return royalGold;
      case 'emerald':
        return natureEmerald;
      case 'pastel':
      default:
        return softTheme;
    }
  }

  // 1. Soft Pastel (Original)
  static ThemeData softTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF3B82F6),
      secondary: const Color(0xFFF472B6),
      surface: Colors.white,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.light().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: mainText),
      titleTextStyle: TextStyle(color: mainText, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: accentBlue,
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: mainText),
      ),
    ),
  );

  // 2. Midnight Dark
  static ThemeData midnightDark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF38BDF8),
      secondary: const Color(0xFF818CF8),
      surface: const Color(0xFF1E293B),
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E293B),
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  // 3. Royal Gold
  static ThemeData royalGold = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFFFBEB),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFFD97706),
      secondary: const Color(0xFFF59E0B),
      surface: Colors.white,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.light().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFEF3C7),
      elevation: 0,
      titleTextStyle: TextStyle(color: Color(0xFF92400E), fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  // 4. Nature Emerald
  static ThemeData natureEmerald = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF0FDF4),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF16A34A),
      secondary: const Color(0xFF22C55E),
      surface: Colors.white,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.light().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(color: Color(0xFF14532D), fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}

