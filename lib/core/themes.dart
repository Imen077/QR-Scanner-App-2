import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppThemes {
  AppThemes._();
  //palettes
  static const Color background = Color(0xFF0A0A0A); // near-black canvas
  static const Color surface = Color(0xFF141414);    // card / sheet bg
  static const Color surfaceVariant = Color(0xFF1F1F1F); // elevated surface
  static const Color border = Color(0xFF2A2A2A);    // subtle dividers

  static const Color primary = Color(0xFFFFFFFF);    // white - main accent
  static const Color primaryMuted = Color(0xFFB0B0B0); // secondary text / icons
  static const Color hint = Color(0xFF555555);       // placeholder / disabled

  static const Color success = Color(
    0xFF4CAF50,
  ); // scan OK (only non-mono color)
  
  static const Color error = Color(0xFFCF6679);

  // --- Text Styles ---
static const TextTheme _textTheme = TextTheme(
  // Large headers
  displayLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: primary,
    letterSpacing: -1.0,
  ), 
  displayMedium: TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: primary,
    letterSpacing: -0.5,
  ), 
  // Section titles
  headlineLarge: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: primary,
  ), 
  headlineMedium: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: primary,
  ), 
  headlineSmall: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: primary,
  ), 
  // Body
  bodyLarge: TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: primary,
    height: 1.5,
  ), 
  bodyMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: primaryMuted,
    height: 1.5,
  ),
  bodySmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: hint,
    height: 1.4,
  ), 
  // Labels
  labelLarge: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: background,
    letterSpacing: 0.5,
  ), // TextStyle
  labelMedium: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: primaryMuted,
  ), // TextStyle
  labelSmall: TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: hint,
    letterSpacing: 0.3,
  ), // TextStyle
);

// --- Theme Data ---
static ThemeData get dark => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: background,

  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: background,
    secondary: primaryMuted,
    onSecondary: background,
    surface: surface,
    onSurface: primary,
    surfaceContainerHighest: surfaceVariant,
    outline: border,
    error: error,
    onError: background,
  ), // ColorScheme.dark

  textTheme: _textTheme,

// --- AppBar ---
appBarTheme: const AppBarTheme(
  backgroundColor: background,
  foregroundColor: primary,
  elevation: 0,
  scrolledUnderElevation: 0,
  centerTitle: false,
  titleTextStyle: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: primary,
  ), // TextStyle
  iconTheme: IconThemeData(color: primary, size: 22),
  systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: background,
    systemNavigationBarIconBrightness: Brightness.light,
  ), // SystemUiOverlayStyle
),

// --- ElevatedButton ---
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: background,
    disabledBackgroundColor: border,
    disabledForegroundColor: hint,
    elevation: 0,
    minimumSize: const Size(double.infinity, 52),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    textStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ), // TextStyle
  ),
),
// --- OutlinedButton ---
outlinedButtonTheme: OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    foregroundColor: primary,
    minimumSize: const Size(double.infinity, 52),
    side: const BorderSide(color: border, width: 1.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
  ),
),
// --- TextButton ---
textButtonTheme: TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: primaryMuted,
    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  ),
),

// --- InputDecoration (TextField) ---
inputDecorationTheme: InputDecorationTheme(
  filled: true,
  fillColor: surfaceVariant,
  hintStyle: const TextStyle(color: hint, fontSize: 14),
  labelStyle: const TextStyle(color: primaryMuted, fontSize: 14),
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: border),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: border),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: primary, width: 1.5),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: error),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: error, width: 1.5),
  ),
),

// —— Divider ——
dividerTheme: const DividerThemeData(color: border, thickness: 1, space: 1),

// —— BottomNavigationBar ——
bottomNavigationBarTheme: const BottomNavigationBarThemeData(
  backgroundColor: surface,
  selectedItemColor: primary,
  unselectedItemColor: hint,
  elevation: 0,
  type: BottomNavigationBarType.fixed,
  selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
  unselectedLabelStyle: TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
  ),
),

// —— SnackBar ——
snackBarTheme: SnackBarThemeData(
  backgroundColor: surfaceVariant,
  contentTextStyle: const TextStyle(color: primary, fontSize: 14),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  behavior: SnackBarBehavior.floating,
),

// —— ListTile ——
listTileTheme: const ListTileThemeData(
  tileColor: Colors.transparent,
  iconColor: primaryMuted,
  textColor: primary,
  subtitleTextStyle: TextStyle(color: primaryMuted, fontSize: 13),
),

// —— Icon ——
iconTheme: const IconThemeData(color: primaryMuted, size: 22),

// —— Chip ——
chipTheme: ChipThemeData(
  backgroundColor: surfaceVariant,
  labelStyle: const TextStyle(color: primaryMuted, fontSize: 12),
  side: const BorderSide(color: border),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
), 

);
}
